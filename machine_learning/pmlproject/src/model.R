library('ProjectTemplate')
load.project()

# Run some different models to get a feel for accuracy

mod1<-randomForest(classe~., data=training, ntree=200, nodesize=5)
mod2<-randomForest(classe~., data=training, ntree=400, nodesize=5)
mod3<-randomForest(classe~., data=training, ntree=400, nodesize=3)

