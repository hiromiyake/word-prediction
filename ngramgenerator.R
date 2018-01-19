## https://www.r-bloggers.com/safe-loading-of-rdata-files-2/
## https://stat.ethz.ch/R-manual/R-devel/library/base/html/load.html

## train_news.txt is 25 kB
## train_news_big.txt is 2 MB, probably using 1% of en_US.news.txt
## 20 MB, 10% of data from en_US.news.txt caused memory problem
## 10 MB, 5% of data from en_US.news.txt caused memory problem
## 4 MB, 2% of data from en_US.news.txt caused memory problem
remove(list = ls())

library(tm)
## http://charlotte-ngs.github.io/2016/01/MacOsXrJavaProblem.html
## https://stackoverflow.com/questions/30738974/rjava-load-error-in-rstudio-r-after-upgrading-to-osx-yosemite
dyn.load('/Library/Java/JavaVirtualMachines/jdk1.8.0_151.jdk/Contents/Home/jre/lib/server/libjvm.dylib')
library(RWeka)

#con = file("train_news_big.txt", open = "r")
#txtsource = readLines(con)

txtsource = readLines("train_twitter.txt")
#txtsource = readLines("train_news_bigger.txt")
#txtsource = readLines("final/en_US/en_US.news.txt")
#con <- file("final/en_US/en_US.news.txt", "r")

#print(txtsource)

tdmNgram = function(inputText, ng) {
  ## Somehow Corpus isn't working anymore, so use VCorpus.
  ## https://stackoverflow.com/questions/43410491/2-gram-and-3-gram-instead-of-1-gram-using-rweka
  ## https://stackoverflow.com/questions/42757183/creating-n-grams-with-tm-rweka-works-with-vcorpus-but-not-corpus
  #corpus = Corpus(VectorSource(inputText))
  corpus = VCorpus(VectorSource(inputText))
  corpus = tm_map(corpus, content_transformer(tolower))
  corpus = tm_map(corpus, removePunctuation)
  corpus = tm_map(corpus, removeNumbers)
  corpus = tm_map(corpus, stripWhitespace)
  # http://stackoverflow.com/questions/17703553/bigrams-instead-of-single-words-in-termdocument-matrix-using-r-and-rweka/20251039#20251039
  options(mc.cores=1) 
  ngramTokenizerWeka = function(x) NGramTokenizer(x, Weka_control(min = ng, max = ng)) # create n-grams
  tdm = TermDocumentMatrix(corpus, control = list(tokenize = ngramTokenizerWeka)) # create tdm from n-grams
  
  tdmMatrix = as.matrix(tdm)
  ngramSum = rowSums(tdmMatrix)
  ngramSumSort = sort(ngramSum, decreasing=TRUE)
  ngramSumSort
}

ngram1 = tdmNgram(txtsource,1)
ngram2 = tdmNgram(txtsource,2)
ngram3 = tdmNgram(txtsource,3)
ngram4 = tdmNgram(txtsource,4)

remove(txtsource)
remove(tdmNgram)

save.image('ngram4_twitter.RData')
#save.image('ngrams_bigger.RData')