library(keras)
library(tidyverse)
library(janeaustenr)
library(tokenizers)

max_length <- 40

text <- austen_books() %>% 
  filter(book == "Pride & Prejudice") %>%
  pull(text) %>%
  str_c(collapse = " ") %>%
  tokenize_characters(lowercase = FALSE, strip_non_alphanum = FALSE, simplify = TRUE)

print(sprintf("Corpus length: %d", length(text)))