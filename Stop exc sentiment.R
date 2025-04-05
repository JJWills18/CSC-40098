install.packages("tm")
install.packages("readr")
install.packages("tidytext")
install.packages("dplyr")
install.packages("tidyr")
install.packages("ggplot2")

library(tm)
library(readr)
library(tidytext)
library(dplyr)
library(tidyr)
library(ggplot2)


setwd("C:/Users/jwill/OneDrive/Keele/Module 8/Dissertation/Final documents")

db <- read.csv("Rstudio.csv")

#Restructure the database
db_new <- unnest_tokens(tbl=db, input=Question, output=word)

#Create stop word database
stp_wrds <- get_stopwords(source="smart")

#Remove stop words
db_new <- anti_join(db_new, stp_wrds, by="word")

#Sentiment Analysis
bing <- get_sentiments(lexicon="bing")

#Join db
db_bing <- inner_join(db_new, bing, by="word")

#Compute sentiment by forum
db_class <-count(db_bing, Class, sentiment)

db_question <-count(db_bing, ID, sentiment, Date)

#Spread the data
db_class <- spread(key=sentiment, value=n, fill=0, data=db_class)
db_question <- spread(key=sentiment, value=n, fill=0, data=db_question)

#Create sentiment 
db_class <- mutate(sentiment = positive - negative, .data=db_class)
db_question <- mutate(sentiment = positive - negative, .data=db_question)

#Statistics
mean(db_class$sentiment, na.rm=TRUE)
mean(db_question$sentiment, na.rm=TRUE)

#Data visualisations
ggplot(aes(x=Class, y=sentiment, fill=Class), data=db_class) + 
  geom_col(show.legend=FALSE)

