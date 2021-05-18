## -------------------------------------------------------------------------------------------------
library(tidyverse)


## -------------------------------------------------------------------------------------------------
setwd("old_assgt")
lines <- readLines("../_bookdown.yml")
lines %>% str_remove_all("\"") %>% 
  str_remove_all(",") %>% 
  enframe(name = NULL, value = "chapter") %>% 
  filter(str_detect(chapter, "^[0-9][0-9]")) %>% 
  rowwise() %>% 
  mutate(chapter_text = list(readLines(str_c("../", chapter)))) %>% 
  unnest(chapter_text) %>% 
  filter(str_detect(chapter_text, "^#")) %>% 
  mutate(chapter_text = str_replace(chapter_text, "# ", ""),
         chapter_text = str_replace_all(chapter_text, " ", "-"),
         chapter_text = tolower(chapter_text)
  ) %>% 
  mutate(chapter_title = str_c("../docs/", chapter_text, ".html")) %>% 
  mutate(chapter_mtime = file.mtime(chapter_title)) %>% 
  select(chapter, chapter_mtime) %>% 
  rowwise() %>% 
  mutate(files_in = list(readLines(str_c("../", chapter)))) %>% 
  unnest(files_in) %>% 
  filter(str_detect(files_in, "child")) %>% 
  extract(files_in, into = "fname", regex = "child=\"(.*Rmd)\"}") %>% 
  mutate(file_mtime = file.mtime(str_c("../", fname))) %>% 
  arrange(desc(file_mtime)) %>% 
  filter(!str_detect(fname, "_qq")) %>% 
  mutate(file_later = file_mtime > chapter_mtime) -> d
d %>% arrange(fname)
d %>% filter(file_later)


## -------------------------------------------------------------------------------------------------
d %>% 
  filter(file_later) %>% 
  distinct(chapter) %>% 
  slice(1:3) %>% 
  mutate(thing = walk(chapter, ~bookdown::preview_chapter(.)))

