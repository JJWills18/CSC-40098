# Step 1: Install necessary libraries (if not already installed)
install.packages("tm")
install.packages("wordcloud")
install.packages("RColorBrewer")
install.packages("dplyr")

# Step 2: Load the libraries
library(tm)
library(wordcloud)
library(RColorBrewer)
library(dplyr)

setwd("C:/Users/jwill/OneDrive/Keele/Module 8/Dissertation/Final documents")

db <- read.csv("Rstudiomaths.csv")


text_data <- db$Question

#Create a text corpus from the extracted text
corpus <- Corpus(VectorSource(text_data))

#Preprocess the text data (convert to lowercase, remove punctuation, stopwords, etc.)
corpus_clean <- corpus %>%
  tm_map(tolower) %>%  # Convert text to lowercase
  tm_map(removePunctuation) %>%  # Remove punctuation
  tm_map(removeNumbers) %>%  # Remove numbers
  tm_map(removeWords, stopwords("en")) %>%  # Remove common stopwords
  tm_map(stripWhitespace)  # Remove extra whitespace

#Create a term-document matrix
tdm <- TermDocumentMatrix(corpus_clean)

#Convert the term-document matrix to a matrix format
m <- as.matrix(tdm)

#Get the word frequencies
word_freqs <- sort(rowSums(m), decreasing = TRUE)

# Create a data frame for the word frequencies
word_freq_df <- data.frame(word = names(word_freqs), freq = word_freqs)

# Generate the word cloud
wordcloud(words = word_freq_df$word, freq = word_freq_df$freq, min.freq = 1,
          scale = c(3,0.5), colors = brewer.pal(8, "Dark2"))


