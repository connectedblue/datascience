# Preprocess the raw data

# cache the raw data
cache('pml.testing')
cache('pml.training')

# dataset cleaning function

clean<- function(dataset){
        
        # save the response in it's own variable
        classe <- dataset[,160]
        
        # The first 7 columns are identifiers - there are some redundant values
        # Need X and user_name - columns 1 and 2
        # timestamp is col 3 + col 4/1000000
        # Don't need columns 5,6 and 7
        identifiers <- dataset[,1:2]
        identifiers$timestamp <- round(dataset[,3] + dataset[,3]/1000000, 6)
        
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


# create new training data which is cleaned up
clean_training <- clean(pml.training)

# remove any near zero variance columns

# nzv<-nearZeroVar(measurement)
# measurement<-measurement[,-nzv]
# measurement<-predict(preProcess(measurement, method = "nzv"), measurement)



times<-aggregate( timestamp~user_name+classe, data=clean_training, function(x) c(min = min(x), max = max(x) ) )
times$exercise_time<-times$timestamp[,2]-times$timestamp[,1]
times<-times[with(times,order(user_name, classe)),]
