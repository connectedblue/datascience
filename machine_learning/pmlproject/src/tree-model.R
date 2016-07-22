library('ProjectTemplate')
load.project()

# Run some tree models to get a feel for accuracy


set.seed(1234)
# Run the model on all four cores

mod <- train(classe~., method="rpart", data=training)
              
predicted<-predict(mod, training)

# Show the training result as a confusion matrix
training_result<-confusionMatrix(predicted, training$classe)

print(training_result)

# Run the model against the testing set
testing_prediction<-predict(mod, testing)
testing_result<-confusionMatrix(testing_prediction, testing$classe)


# Get the answers on the clean testing set to submit to the quiz
submitted_answers<-predict(mod, clean_testing)
