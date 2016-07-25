# Preprocess the raw data

# cache the raw data (so that the raw data isn't downloaded every time) 
cache('pml.testing')
cache('pml.training')

# dataset cleaning function

## -- Code chunk to be displayed in reports
## ---- clean

clean<- function(dataset){
        
        # save the response in it's own variable
        classe <- dataset[,160]
        
        # The first 7 columns are identifiers - there are some redundant values
        # Need X and user_name - columns 1 and 2
        # timestamp is col 3 + col 4/1000000
        # Don't need columns 5,6 and 7
        identifiers <- dataset[,1:2]
        identifiers$timestamp <- round(dataset[,3] + dataset[,4]/1000000, 6)
        
        # isolate the middle columns 8-159 which are the measurement values
        measurement <- dataset[,8:159]
        
        # Get the measurement columns which are factors and force them to be numeric
        factor_cols <- names(Filter(is.factor, measurement))
        for (col in factor_cols) {
                measurement[[col]] <- as.numeric(as.character(measurement[[col]]))
        }
        
        # Return a cleaned dataframe
        cbind(identifiers, measurement, classe)
}


# create new training and test data which is cleaned up
clean_training <- clean(pml.training)
clean_testing <- clean(pml.testing)

## ----

## -- Code chunk to be displayed in reports
## ---- summarisetraining

# Create a summary table of the training data showing
# when each exercise was performed, how long each took, 
# and how many samples were collected

training_summary<-aggregate( timestamp~user_name+classe, 
                             data=clean_training, 
                             function(x) c(start = min(x), 
                                           stop = max(x), samples=length(x)))
tmp<-cbind(training_summary[,1:2], data.frame(training_summary[,3]))
training_summary<-tmp
rm(tmp)
training_summary$exercise_time<-training_summary$stop-training_summary$start
training_summary$start_time<-as.POSIXlt(training_summary$start,
                                        origin = "1970-01-01", tz = "UTC")
training_summary<-training_summary[with(training_summary,order(start)),]

## ----


## -- Code chunk to be displayed in reports
## ---- reduce

# Reduce down the training set further for analysis

# Remove the identifier columns - not relevant for the prediction modelling
clean_training<-clean_training[,-(1:3)]

# identify which measurement columns do not have any NA values
nona<-sapply(names(clean_training), function(x) 
        ifelse(sum(is.na(clean_training[,x]))==0,TRUE,FALSE))
# and filter only those ones
clean_training <- clean_training[, nona]
rm(nona)

# Split the training set into a testing and training set for the modelling
set.seed(1234)
inTrain <- createDataPartition(y=clean_training$classe, p=0.7, list=FALSE)
training<-clean_training[inTrain,]
testing<-clean_training[-inTrain,]
rm(inTrain)

## ---- 



# Following lines not used ....
# remove any near zero variance columns
# measurement<-predict(preProcess(measurement, method = "nzv"), measurement)
# nzv<-nearZeroVar(measurement)
# measurement<-measurement[,-nzv]


