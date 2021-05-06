# create a file without the solution
library(tidyverse)

# extract q from just one file

extract_q <- function(base) {
  fname <- str_c(base, ".Rmd")
  lines <- readLines(fname)
  lines %>% enframe() %>% 
    mutate(start = str_detect(value, "Solution"),
           end = str_detect(value, "blacksquare")) %>% 
    mutate(start_cume = cumsum(start),
           end_cume = cumsum(end)) %>% 
    filter(start_cume == end_cume, !end) -> d
  outname <- str_c(base, "_qq.Rmd")
  writeLines(d$value, outname)
}

# extract all files from a chapter

extract_chapter_files <- function(chapter_name) {
  print(chapter_name)
  lines <- readLines(chapter_name)
  lines %>% enframe() %>% 
    filter(str_detect(value, "child=")) %>% 
    extract(value, "file", "child=\"(.*).Rmd\"") %>% 
    filter(file != "packages") %>% 
    filter(!str_detect(file, "_qq$")) %>% 
    pull(file)
}

# make question files for a chapter

make_chapter_q <- function(chapter_name) {
  v <- extract_chapter_files(chapter_name)
  walk(v, ~extract_q(.))
}

# grab chapters

readLines("_bookdown.yml") %>% 
  enframe(name = NULL) %>% 
  mutate(ch_name = str_replace_all(value, '"', '')) %>% 
  mutate(ch_name = str_replace(ch_name, ",", "")) %>% 
  filter(str_detect(ch_name, "^[0-9][0-9]*")) %>% 
  pull(ch_name) -> z
walk(z, ~make_chapter_q(.))

# find chapters that don't have "answers follow"

has_follow <- function(chapter) {
  v <- readLines(chapter)
  enframe(v, name = NULL) %>%
    mutate(foll = str_detect(value, "My solutions follow")) -> d
  any(d$foll)
}

# find chapters without "my solutions follow:" in them

readLines("_bookdown.yml") %>% 
  enframe(name = NULL) %>% 
  mutate(ch_name = str_replace_all(value, '"', '')) %>% 
  mutate(ch_name = str_replace(ch_name, ",", "")) %>% 
  filter(str_detect(ch_name, "^[0-9][0-9]*")) %>% 
  rowwise() %>% 
  mutate(done = has_follow(ch_name)) %>% 
  ungroup() %>% 
  filter(!done) %>% 
  slice_sample(n = 50)

