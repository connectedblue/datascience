rm(list=ls())

# Question 1

ques1 <- function () {
        library(ElemStatLearn)
        library(caret)
        
        data(vowel.test)
        data(vowel.train)
        
        vowel.test$y<<-as.factor(vowel.test$y)
        vowel.train$y<<-as.factor(vowel.train$y)
        
        set.seed(33833)
        mod_rf<<-train(y~., method="rf", data=vowel.train)
        mod_gbm<<-train(y~., method="gbm", data=vowel.train)
        
        pred_rf<<-predict(mod_rf, newdata = vowel.test)
        pred_gbm<<-predict(mod_gbm, newdata = vowel.test)
        
        rf_cm<<-confusionMatrix(pred_rf, vowel.test$y)
        gbm_cm<<-confusionMatrix(pred_gbm, vowel.test$y)
        
        duplicates<<-duplicated(data.frame(pred_rf=pred_rf, pred_gbm=pred_gbm))
        
        new_pred<<-pred_rf[duplicates]
        new_y<<-vowel.test$y[duplicates]
        
        dup_cm<<-confusionMatrix(new_pred, new_y)

}

#ques1()

ques2<-function(){
        library(caret)
        library(gbm)
        
        set.seed(3433)
        library(AppliedPredictiveModeling)
        data(AlzheimerDisease)
        
        adData <<-data.frame(diagnosis,predictors)
        inTrain <<-createDataPartition(adData$diagnosis, p = 3/4)[[1]]
        training <<- adData[ inTrain,]
        testing <<- adData[-inTrain,]
        
        set.seed(62433)
        
        # Individual models first
        
        mod_rf<<-train(diagnosis~., method="rf", data=training)
        pred_rf<<-predict(mod_rf, newdata = testing)
        rf_cm<<-confusionMatrix(pred_rf, testing$diagnosis)
        
        #set.seed(62433)
        mod_gbm<<-train(diagnosis~., method="gbm", data=training)
        pred_gbm<<-predict(mod_gbm, newdata = testing)
        gbm_cm<<-confusionMatrix(pred_gbm, testing$diagnosis)
        
        set.seed(62433)
        mod_lda<<-train(diagnosis~., method="lda", data=training)
        pred_lda<<-predict(mod_lda, newdata = testing)
        lda_cm<<-confusionMatrix(pred_lda, testing$diagnosis)
        
        # stacked model
        stacked<<- data.frame(pred_rf, pred_gbm, pred_lda, testing$diagnosis)
        colnames(stacked)[4]<-"diagnosis"
        
        set.seed(62433)
        mod_stacked<<-train(diagnosis~., method="rf", data=stacked)
        pred_stacked<<-predict(mod_stacked, newdata = testing)
        stacked_cm<<-confusionMatrix(pred_stacked, testing$diagnosis)
        
        
}

#ques2()

ques3<-function(){
        
        set.seed(3523)
        
        library(AppliedPredictiveModeling)
        
        data(concrete)
        
        inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
        
        training = concrete[ inTrain,]
        
        testing = concrete[-inTrain,]
        
        set.seed(233)
        
        mod_lasso<<-train(CompressiveStrength~., method="lasso", data=training)
        pred_lasso<<-predict(mod_lasso, newdata = testing)
        #stacked_cm<<-confusionMatrix(pred_stacked, testing$diagnosis)
        
        
}

#ques3()

ques4<-function(){
        gaData<<- read.table("https://d396qusza40orc.cloudfront.net/predmachlearn/gaData.csv", sep=",", header=TRUE)
        library(lubridate) # For year() function below
        
        training <<- gaData[year(gaData$date) < 2012,]
        
        testing <<- gaData[(year(gaData$date)) > 2011,]
        
        tstrain <<- ts(training$visitsTumblr)
        
        library(forecast)
        mod_bat<<-bats(tstrain)
        fore<<-forecast(mod_bat, h=length(testing$visitsTumblr))
        upper95<<-fore$upper[,2]
        under<<-testing$visitsTumblr[testing$visitsTumblr<upper95]
        p<<-length(under)/length(testing$visitsTumblr)
        
        
}

#ques4()

ques5<-function(){
        
        set.seed(3523)
        
        library(AppliedPredictiveModeling)
        
        data(concrete)
        
        inTrain <<- createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
        
        training <<- concrete[ inTrain,]
        
        testing <<- concrete[-inTrain,]
        
        library(e1071)
        set.seed(325)
        mod_svm<<-svm(CompressiveStrength~.,data=training)
        pred<<-predict(mod_svm, newdata = testing)
        
        library(hydroGOF)
        
        rmse_error<<-rmse(pred, testing$CompressiveStrength)
        
}

ques5()