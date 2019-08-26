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

ggplot(mpg, aes(x=displ, y=displ, color=year))+geom_point()+ 
  geom_smooth(method="gam")

punctuation %>%ggplot(aes(x=token, y=n, color="red")) + geom_point() + geom_smooth()
  


  
  ggplot(aes(token, n, fill = title, fill=)) +
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

#emojis
library(jsonlite)
emoji_data <- fromJSON("data/emoji.json")
head(emoji_data)
emoji_cat <- fromJSON("data/categories.json")



library(tm)
library(tidytext) 
library(tidyverse) 
library(quanteda)
df <- as.data.frame(cbind(doc = c("doc1", "doc2"), text = c("the quick brown fox jumps over the lazy dog", "The quick brown foxy ox jumps over the lazy god")), stringsAsFactors = FALSE)

df.count1 <- df %>% unnest_tokens(word, text) %>% 
  count(doc, word) %>% 
  bind_tf_idf(word, doc, n) %>% 
  select(doc, word, tf_idf) %>% 
  spread(word, tf_idf, fill = 0) 

df.count2 <- df %>% unnest_tokens(word, text) %>% 
  count(doc, word) %>% 
  cast_dtm(document = doc,term = word, value = n, weighting = weightTfIdf) %>% 
  as.matrix() %>% as.data.frame()

df.count3 <- df %>% unnest_tokens(word, text) %>% 
  count(doc, word) %>% 
  cast_dfm(document = doc,term = word, value = n) %>% 
  dfm_tfidf() %>% as.data.frame()


#=====================
install.packages("itunesr")
library(itunesr)
uber_reviews <- getReviews(368677368,'us',1)
reviews1 <- getReviews("297606951", "us", 1)
reviews2 <- getReviews("297606951", "us", 2)

reviews <- rbind(reviews1, reviews2)
reviews_neg <- reviews[reviews$Rating %in% c('1','2'),]


doc <- udpipe::udpipe_annotate(model, reviews_neg$Review)
amazon_reviews <- getReviews(297606951,'us',1)

install.packages("udpipe")
library(udpipe)
en <- udpipe::udpipe_download_model("english")

model <- udpipe_load_model("english-ewt-ud-2.4-190531.udpipe")

doc <- udpipe::udpipe_annotate(model, reviews_neg$Review)

names(as.data.frame(doc))

doc_df <- as.data.frame(doc)

topics <- keywords_rake(x = doc_df, term = "lemma", group = "doc_id", 
                        relevant = doc_df$upos %in% c("NOUN", "ADJ"))


