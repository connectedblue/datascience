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

ques1()
