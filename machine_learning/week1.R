
library(caret)

create_data <- function(data, response, p=0.75) {

        inTrain <- createDataPartition(y=data[,response], p=p, list=FALSE)
        training<<-data[inTrain,]
        testing<<-data[-inTrain,]
}