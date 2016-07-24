library('ProjectTemplate')
load.project()


## ---- analysis

set.seed(1234)
# Run the model on all four cores
registerDoParallel(cores=4)

# if the model is not already present, train one using cross validation
if(!exists("caretrf_mod")){
        caretrf_mod <- train(classe~., data=training, 
                     trControl=trainControl(method="cv",number=5),
                     method="parRF")

}
              

# Run the model against the testing set
caretrf_testing_prediction<-predict(caretrf_mod$finalModel, testing)
caretrf_testing_result<-confusionMatrix(caretrf_testing_prediction, testing$classe)


# Get the answers on the clean testing set to submit to the quiz
caretrf_submitted_answers<-predict(caretrf_mod, clean_testing)

# Save the model in the cache (because it takes a while to run)

cache("caretrf_mod")
