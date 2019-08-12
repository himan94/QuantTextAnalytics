install.packages("gutenbergr")

library(tidyverse)
library(gutenbergr)

# use of selected words - change initial dataset and tokens to filter

titles <- c("Pride and Prejudice",
            "Ulysses",
            "Anne of Green Gables",
            "Wuthering Heights",
            "The War of the Worlds",
            "Alice's Adventures in Wonderland",
            "Adventures of Huckleberry Finn",
            "Frankenstein; Or, The Modern Prometheus",
            "The Strange Case of Dr. Jekyll and Mr. Hyde")

books <- gutenberg_works(title %in% titles) %>%
  gutenberg_download(meta_fields = "title") %>%
  mutate(text = iconv(text, from = "latin1", to = "UTF-8"))

books

library(tidytext)

punctuation <- books %>%
  unnest_tokens(token, text, strip_punct = FALSE) %>%
  count(title, token, sort = TRUE) %>%
  filter(token %in% c(",", "?", ".", '"', "'", "!", ";", ":"))

# # @ ? ! 

punctuation

punctuation<-punctuation %>%
  mutate(token = reorder(token, n),
         title = case_when(str_detect(title, "Frankenstein") ~ "Frankenstein",
                           str_detect(title, "Dr. Jekyll") ~ "Dr. Jekyll and Mr. Hyde",
                           TRUE ~ title))

punctuation %>%
  
  
  ggplot(aes(token, n, fill = title)) +
  geom_col(alpha = 0.8, show.legend = FALSE) +
  coord_flip() +
  facet_wrap(~title, scales = "free_x") +
  scale_y_continuous(expand = c(0,0)) +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.y = element_text(family = "IBMPlexSans-Bold", 
                                   size = 14)) +
  labs(x = NULL, y = NULL,
       title = "Punctuation in literature",
       subtitle = "Commas are typically most common")

