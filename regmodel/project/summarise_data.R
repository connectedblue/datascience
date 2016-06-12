# summarise data

data(mtcars)

# data structure

# adjust for factor variables

mtcars$cyl <- factor(mtcars$cyl)
mtcars$am <- factor(mtcars$am)
mtcars$gear <- factor(mtcars$gear)
mtcars$carb <- factor(mtcars$carb)
mtcars$vs <- factor(mtcars$vs)

# adjust for average weight and horsepower

#mtcars$wt  <- mtcars$wt - mean(mtcars$wt)
#mtcars$hp  <- mtcars$hp - mean(mtcars$hp)


library(plyr)

c<-ddply(mtcars, c("am", "cyl"), summarise, N=length(mpg), mean_mpg=mean(mpg), std_mpg=sd(mpg))

print(c)
