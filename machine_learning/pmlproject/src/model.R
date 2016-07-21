library('ProjectTemplate')
load.project()

# Run some different models to get a feel for accuracy

#mod1<-randomForest(classe~., data=training, ntree=200, nodesize=5)
#mod2<-randomForest(classe~., data=training, ntree=400, nodesize=5)
#mod3<-randomForest(classe~., data=training, ntree=400, nodesize=4)

#mod3<-randomForest(classe~., data=training, ntree=100, nodesize=1)

set.seed(1234)
# Run the model on all four cores
registerDoParallel(cores=4)
# Do a number of trees on each cpu and combine them
mod <- foreach(ntree=rep(50, 4), .combine=combine, .multicombine=TRUE,
              .packages='randomForest') %dopar% {
                      randomForest(classe~., data=training, ntree=ntree, nodesize=10)
              }

# Show the result as a confusion matrix
result<-confusionMatrix(mod$predicted, training$classe)

print(result)