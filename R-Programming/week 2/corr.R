corr<-function(directory="C:\\Users\\cs\\Dropbox\\Connected Blue\\Training\\data science\\git\\datascience\\R-Programming\\week 2\\rprog-data-specdata\\specdata", threshold=0) {
  # Prepare to read in files from directory
  library(readr)
  files=list()
  for (i in 1:332) {
    fn<-paste(sprintf("%03d", i),".csv",sep="")
    files<-c(files,file.path(directory, fn, fsep = "\\"))
  } # creates a list of files to read
  filedata <- lapply(files, read_csv) # Puts all the files into filedata variable
  correlations<-integer(0) # empty result vector
  for (d in filedata){       # go through each file
    d<-d[complete.cases(d),] # filter out observations with NA
    d<-d[c("sulfate", "nitrate", "ID")] # only keep the columns we're interested in
    if (nrow(d)>threshold) {
      #print(d[[3]])
      #print(d[[1]],d[[2]])  
      correlations<-c(correlations, round(cor(as.numeric(d[[1]]), as.numeric(d[[2]])), digits=5))
      } 
  }
  correlations
}