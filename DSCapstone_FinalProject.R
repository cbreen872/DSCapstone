library(ggplot2)
library(NLP)
library(tm)
library(RWeka)
library(data.table)
library(dplyr)

# read data from files

blogsData <- readLines("./final/en_US/en_US.blogs.txt", encoding = "UTF-8", skipNul = TRUE)
newsData <- readLines("./final/en_US/en_US.news.txt", encoding = "UTF-8", skipNul = TRUE)
twitterData <- readLines("./final/en_US/en_US.twitter.txt", encoding = "UTF-8", skipNul = TRUE)
badwords <- readLines("profanityfile.txt",encoding = "UTF-8", skipNul = TRUE)
badwords <- tolower(badwords)
badwords <- str_replace_all(badwords, "\\(", "\\\\(")

# set sample size
set.seed(100)
sample_size = 500

sample_blog <- blogsData[sample(1:length(blogsData),sample_size)]
sample_news <- newsData[sample(1:length(newsData),sample_size)]
sample_twitter <- twitterData[sample(1:length(twitterData),sample_size)]

sample_data<-rbind(sample_blog,sample_news,sample_twitter)
rm(blogsData,newsData,twitterData)

corpus<-VCorpus(VectorSource(sample_data))
corpus <- tm_map(corpus, content_transformer(tolower)) # convert to lowercase
corpus <- tm_map(corpus, removePunctuation) # remove punctuation
corpus <- tm_map(corpus, removeNumbers) # remove numbers
corpus <- tm_map(corpus, stripWhitespace) # remove multiple whitespace
changetospace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
corpus <- tm_map(corpus, changetospace, "/|@|\\|")
mycorpus <- tm_map(corpus, removeWords, badwords)
rm(badwords)


uniGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
biGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
triGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
OneT <- NGramTokenizer(mycorpus, Weka_control(min = 1, max = 1))
oneGM <- TermDocumentMatrix(mycorpus, control = list(tokenize = uniGramTokenizer))
twoGM <- TermDocumentMatrix(mycorpus, control = list(tokenize = biGramTokenizer))
threeGM <- TermDocumentMatrix(mycorpus, control = list(tokenize = triGramTokenizer))

freqTerms1 <- findFreqTerms(oneGM, lowfreq = 5)
termFreq1 <- rowSums(as.matrix(oneGM[freqTerms1,]))
termFreq1 <- data.frame(unigram=names(termFreq1), frequency=termFreq1)
termFreq1 <- termFreq1[order(-termFreq1$frequency),]
unigramlist <- setDT(termFreq1)
save(unigramlist,file="unigram.Rda")
freqTerms2 <- findFreqTerms(twoGM, lowfreq = 3)
termFreq2 <- rowSums(as.matrix(twoGM[freqTerms2,]))
termFreq2 <- data.frame(bigram=names(termFreq2), frequency=termFreq2)
termFreq2 <- termFreq2[order(-termFreq2$frequency),]
bigramlist <- setDT(termFreq2)
save(bigramlist,file="bigram.Rda")
freqTerms3 <- findFreqTerms(threeGM, lowfreq = 2)
termFreq3 <- rowSums(as.matrix(threeGM[freqTerms3,]))
termFreq3 <- data.frame(trigram=names(termFreq3), frequency=termFreq3)
trigramlist <- setDT(termFreq3)
save(trigramlist,file="trigram.Rda")
