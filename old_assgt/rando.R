vowel_id <- c(1, 5, 9, 15, 21)
vowels <- letters[vowel_id]
consonants <- letters[!(1:26 %in% vowel_id)]
vowels
consonants
cc <- sample(consonants, 3, replace = TRUE)
vv <- sample(vowels, 2, replace = TRUE)
paste0(cc[1], vv[1], cc[2], vv[2], cc[3])