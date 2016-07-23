library('ProjectTemplate')
load.project()


set.seed(1234)
# Run the model on all four cores
registerDoParallel(cores=4)

# Do a number of trees on each cpu and combine them
caretrf_mod <- train(classe~., data=training, 
             trControl=trainControl(method="cv",number=5),
             method="parRF")
              

# Run the model against the testing set
caretrf_testing_prediction<-predict(mod$finalModel, testing)
caretrf_testing_result<-confusionMatrix(testing_prediction, testing$classe)


# Get the answers on the clean testing set to submit to the quiz
caretrf_submitted_answers<-predict(mod, clean_testing)

# Save key results in the cache (because it takes a while to run)

cache("caretrf_mod")
cache("caretrf_testing_prediction")
cache("caretrf_testing_result")
cache("caretrf_submitted_answers")

