packages <- c("tidytext", "janeaustenr", "stringr", "gutenbergr", "wordcloud")
install.packages(packages)

library(tidyverse)
library(tidytext)
library(janeaustenr)
library(stringr)
library(gutenbergr)

# some emily dickinson
text <- c("Because I could not stop for Death -",
          "He kindly stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")
text

text_df <- tibble(line = 1:4, text = text)

text_df %>% unnest_tokens(word, text)

original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text,
                                     regex("^chapter [\\divxlc]",
                                           ignore_case = TRUE)))) %>%
  ungroup()

tidy_books <- original_books %>%
  unnest_tokens(word, text)

data(stop_words)

tidy_books <- tidy_books %>%
  anti_join(stop_words)

tidy_books %>%
  count(word, sort = TRUE) %>%
  filter(n > 600) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col() +
  labs(y = NULL)

tidy_books %>%
  count(word, sort = TRUE) %>%
  filter(n > 100) %>%
  tail(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col() +
  labs(y = NULL)

tidy_books %>%
  group_by(book) %>%
  count(word, sort = TRUE) %>%
  filter(n > 250) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col() +
  labs(y = NULL) +
  facet_grid(. ~ book)

library(gutenbergr)
gutenberg_metadata
View(gutenberg_metadata)

hgwells <- gutenberg_download(c(35, 36, 5230, 159), 
                              mirror = "http://mirrors.xmission.com/gutenberg/")

bronte <- gutenberg_download(c(1260, 768, 969, 9182, 767),
                             mirror = "http://mirrors.xmission.com/gutenberg/")

get_sentiments("afinn")

tidy_books

get_sentiments("nrc")

nrc_joy <- get_sentiments('nrc') %>%
  filter(sentiment == "joy")

tidy_books %>%
  filter(book == "Emma") %>%
  inner_join(nrc_joy) %>%
  count(word, sort = TRUE)

jane_austen_sentiment <- tidy_books %>%
  inner_join(get_sentiments("bing")) %>% 
  count(book, index = linenumber %/% 80, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>%
  mutate(sentiment = positive - negative)

jane_austen_sentiment %>%
  ggplot(aes(x = index, y = sentiment, fill = book)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ book, ncol = 2, scales = "free_x")

get_sentiments('nrc') %>%
  filter(sentiment %in% c("positive", "negative")) %>%
  count(sentiment)

get_sentiments('bing') %>%
  count(sentiment)

bing_word_counts <- tidy_books %>% 
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

bing_word_counts %>%
  group_by(sentiment) %>%
  slice_max(n, n = 10) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = n, y = word, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ sentiment, scales = "free_y")

stop_words <- data.frame(word = 'miss', lexicon = 'custom') %>% 
  bind_rows(stop_words)

stop_words <- bind_rows(c(word = "miss", lexicon = "custom"), stop_words)
stop_words

book_words <- austen_books() %>%
  unnest_tokens(word, text) %>%
  count(book, word, sort = TRUE)

total_words <- book_words %>%
  group_by(book) %>%
  summarize(total = sum(n)) 

book_words <- left_join(book_words, total_words)

book_tf_idf <- book_words %>% bind_tf_idf(word, book, n)

book_tf_idf %>%
  select(-total) %>%
  arrange(desc(tf_idf))

book_tf_idf %>%
  group_by(book) %>%
  slice_max(tf_idf, n = 15) %>%
  ungroup() %>%
  ggplot(aes(x = tf_idf, y = fct_reorder(word, tf_idf), fill = book)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~book, ncol = 2, scales= "free")

austen_bigrams <- austen_books() %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2) %>%
  count(book, bigram, sort = TRUE)

austen_books() %>% unnest_tokens(sentence, text, token = "sentences")
