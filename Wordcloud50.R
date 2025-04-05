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
word_freq_table <- data.frame(word = names(word_freqs), freq = word_freqs)

# Select the top 50 most frequent words
top_words <- head(word_freq_table, 50)

#Create wordcloud
wordcloud(words = top_words$word, 
          freq = top_words$freq, 
          min.freq = 1, 
          max.words = 50,  # Limit the number of words shown
          scale = c(2, 0.5),  # Adjust word size scale
          colors = brewer.pal(8, "Dark2"),  # Use color palette
          rot.per = 0.3,  # Allow some rotation for word placement
          random.order = FALSE)  # Arrange words by frequency
          options(repr.plot.width = 20, repr.plot.height = 25)




