install_keras(method = c("auto", "virtualenv", "conda"),
              conda = "auto", version = "default", tensorflow = "default",
              extra_packages = c("tensorflow-hub"))


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



library(keras)
library(dplyr)
library(ggplot2)
library(purrr)

#The dataset comes preprocessed: each example is an array of integers representing the 
#words of the movie review. Each label is an integer value of either 0 or 1, 
#where 0 is a negative review, and 1 is a positive review.
imdb <- dataset_imdb(num_words = 10000)

c(train_data, train_labels) %<-% imdb$train
c(test_data, test_labels) %<-% imdb$test

#an index mapping words to integers
word_index <- dataset_imdb_word_index()

paste0("Training entries: ", length(train_data), ", labels: ", length(train_labels))

#reviews have been converted to integers, where each integer represents a specific word in a dictionary
train_data[[1]]

#Movie reviews may be different lengths. 
#The below code shows the number of words in the first and second reviews. 
#Since inputs to a neural network must be the same length, we’ll need to resolve this later.

length(train_data[[1]])
length(train_data[[2]])

#Convert the integers back to words -> dataframe

word_index_df <- data.frame(
  word = names(word_index),
  idx = unlist(word_index, use.names = FALSE),
  stringsAsFactors = FALSE
)

# The first indices are reserved  
word_index_df <- word_index_df %>% mutate(idx = idx + 3)
word_index_df <- word_index_df %>%
  add_row(word = "<PAD>", idx = 0)%>%
  add_row(word = "<START>", idx = 1)%>%
  add_row(word = "<UNK>", idx = 2)%>%
  add_row(word = "<UNUSED>", idx = 3)

word_index_df <- word_index_df %>% arrange(idx)

decode_review <- function(text){
  paste(map(text, function(number) word_index_df %>%
              filter(idx == number) %>%
              select(word) %>% 
              pull()),
        collapse = " ")
}
#Now we can use the decode_review function to display the text for the first review:
  
  decode_review(train_data[[1]])