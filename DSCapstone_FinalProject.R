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

# set sample size
set.seed(100)
sample_size = 500

sample_blog <- blogsData[sample(1:length(blogsData),sample_size)]
sample_news <- newsData[sample(1:length(newsData),sample_size)]
sample_twitter <- twitterData[sample(1:length(twitterData),sample_size)]

sample_data<-rbind(sample_blog,sample_news,sample_twitter)
rm(blogsData,newsData,twitterData)

mycorpus<-VCorpus(VectorSource(sample_data))
mycorpus <- tm_map(mycorpus, content_transformer(tolower)) # convert to lowercase
mycorpus <- tm_map(mycorpus, removePunctuation) # remove punctuation
mycorpus <- tm_map(mycorpus, removeNumbers) # remove numbers
mycorpus <- tm_map(mycorpus, stripWhitespace) # remove multiple whitespace
changetospace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
mycorpus <- tm_map(mycorpus, changetospace, "/|@|\\|")


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
saveRDS(unigramlist,file="unigram.rds",ascii = FALSE, version = NULL,
        compress = TRUE, refhook = NULL)
freqTerms2 <- findFreqTerms(twoGM, lowfreq = 3)
termFreq2 <- rowSums(as.matrix(twoGM[freqTerms2,]))
termFreq2 <- data.frame(bigram=names(termFreq2), frequency=termFreq2)
termFreq2 <- termFreq2[order(-termFreq2$frequency),]
bigramlist <- setDT(termFreq2)
saveRDS(bigramlist,file="bigram.rds",ascii = FALSE, version = NULL,
        compress = TRUE, refhook = NULL)
freqTerms3 <- findFreqTerms(threeGM, lowfreq = 2)
termFreq3 <- rowSums(as.matrix(threeGM[freqTerms3,]))
termFreq3 <- data.frame(trigram=names(termFreq3), frequency=termFreq3)
trigramlist <- setDT(termFreq3)
saveRDS(trigramlist,file="trigram.rds",ascii = FALSE, version = NULL,
        compress = TRUE, refhook = NULL)

#bad words

badwords <- readLines("profanityfile.txt",encoding = "UTF-8", skipNul = TRUE)
badwords <- tolower(badwords)
badwords <- str_replace_all(badwords, "\\(", "\\\\(")
saveRDS(badwords, "badwords.rds",ascii = FALSE, version = NULL,
        compress = TRUE, refhook = NULL)
rm(badwords)
