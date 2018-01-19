## trainsubsetting.R takes as input 1 of the 3 files and selects a
## subset with fraction given by trainfrac and outputs it to a text file.
## This allows us to work with a smaller text file to develop our text
## prediction algorithm. The original input files are quite big and
## any sophisticated processing costs a lot of time.

## Clear workspace
rm(list = ls())

## For trainfrac = 0.01, with seed = 1 gives the following:
## twitter = 23438 lines; news = 9970 lines; blogs = 8925 lines
## 0.0001 used for final project submission
## 0.1, 0.05, 0.02 causes memory issues in ngramgenrator step
trainfrac = 0.01

## Brute force read in everything at once
#twitter = readLines("final/en_US/en_US.twitter.txt")

## Open a connection to the file and read in one line at a time
#con <- file("testinput.txt", "r")
con <- file("final/en_US/en_US.twitter.txt", "r") ## 2360148 lines
#con <- file("final/en_US/en_US.news.txt", "r") ## 1010242 lines
#con <- file("final/en_US/en_US.blogs.txt", "r") ## 899288 lines

## Start by reading in the first line
train_file = readLines(con, 1)
iinit = 1 ## keeps track of total number of lines in the initial file

set.seed(1)
while (TRUE) {
  temp = readLines(con,1000)
  if (identical(temp, character(0))) {
    break ## if I reach the end of the txt file, end the loop
  }
  else {
    for (i in temp) {
      iinit = iinit + 1
      if (rbinom(1,1,trainfrac)) {
        train_file = append(train_file, i)
      }
    }
  }
}

#iinit ## print length of original file length
#length(train_twitter) ## print length of subset file

close(con)
write(train_file, "train_twitter.txt", sep="\t")
