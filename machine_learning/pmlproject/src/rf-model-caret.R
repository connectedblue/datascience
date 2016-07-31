## ---- analysis


library('ProjectTemplate')
load.project()




set.seed(1234)
# Run the model on all four cores
registerDoParallel(cores=4)

# if the model is not already present, train one using cross validation
if(!exists("caretrf_mod")){
        caretrf_mod <- train(classe~., data=training, 
                     trControl=trainControl(method="cv",number=5),
                     method="rf")

}

# Run the model against the training set (this should be an exact match because the
# final model is re-run against the full training set)
caretrf_training_prediction<-predict(caretrf_mod$finalModel, training)
caretrf_training_result<-confusionMatrix(caretrf_training_prediction, training$classe)

              

# Run the model against the testing set
caretrf_testing_prediction<-predict(caretrf_mod$finalModel, testing)
caretrf_testing_result<-confusionMatrix(caretrf_testing_prediction, testing$classe)


# Get the answers on the clean testing set to submit to the quiz
caretrf_submitted_answers<-predict(caretrf_mod, clean_testing)

# Save the model in the cache (because it takes a while to run)

cache("caretrf_mod")

## ----
