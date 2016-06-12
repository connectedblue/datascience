# summarise data

data(mtcars)

# data structure

# adjust for factor variables

mtcars$cyl <- factor(mtcars$cyl)
mtcars$am <- factor(mtcars$am)
mtcars$gear <- factor(mtcars$gear)
mtcars$carb <- factor(mtcars$carb)
mtcars$vs <- factor(mtcars$vs)
mtcars <- within(mtcars, wt_qt<-as.integer(cut(wt, quantile(wt, probs=0:4/4), include.lowest=TRUE)))
mtcars <- within(mtcars, hp_qt<-as.integer(cut(hp, quantile(hp, probs=0:4/4), include.lowest=TRUE)))
mtcars$am_txt<-ifelse(mtcars$am==1, "Manual", "Automatic")

# adjust for average weight and horsepower

#mtcars$wt  <- mtcars$wt - mean(mtcars$wt)
#mtcars$hp  <- mtcars$hp - mean(mtcars$hp)


library(plyr)

summ <- function(grp, hdg){
        dd<- ddply(mtcars, grp, summarise, 
                        N=length(mpg), 
                        mean_mpg=round(mean(mpg),3), 
                        std_mpg=round(sd(mpg),3))
        names(dd) <- c(hdg, c("Number", "Mean mpg", "Std dev"))
        dd
}

mean_am<-summ(c("am_txt"), c("Type"))
mean_am_hp<-summ(c("am_txt", "hp_qt"), c("Type", "Horsepower quantile"))
mean_am_wt<-summ(c("am_txt", "wt_qt"), c("Type", "Weight quantile"))
mean_am_cyl<-summ(c("am_txt", "cyl"), c("Type", "Number of cylinders"))
