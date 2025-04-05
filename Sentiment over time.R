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

# Convert the 'Date' column to Date format 

db$Date <- as.Date(db$Date, format = "%d/%m/%Y")  

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
db_question <-count(db_bing, ID, sentiment, Date)

#Spread the data
db_question <- spread(key=sentiment, value=n, fill=0, data=db_question)

#Create sentiment 
db_question <- mutate(sentiment = positive - negative, .data=db_question)


db_question$Date <- as.Date(db_question$Date, format = "%d/%m/%Y") 
head(db_question$Date)
class(db_question$Date)

# Create the timeline plot using ggplot2
ggplot(db_question, aes(x = Date, y = sentiment)) +
  geom_line(color = "blue") +
  geom_point(color = "red") +
  labs(title = "Sentiment Over Time", x = "Date", y = "Sentiment") +
  theme_minimal()

# Example of saving data to a CSV file
write.csv(db_question, "C:/Users/jwill/OneDrive/Keele/Module 8/Dissertation/Final documents/database_data.csv", row.names = FALSE)
