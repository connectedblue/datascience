# Library functions specific for this project

# create a handy shortcut to remove the journeys object from the cache and regenerate
# the  dataset from scratch
cc<- function () {
        clear_cache("journeys")
        clear()
        load.project()
}

# Function to parse a location vector of the form:
#        (lat, long)
# into a data frame of two numeric values

split_location <- function (location) {
        # extract the co-ordinates from the location field ignoring the brackets
        location<-sub("^\\((.*)\\)$", "\\1", location)
        # create and return a data frame with two numeric columns
        read.table(text=location, sep=",", col.names = c("lat", "long"))
}


# This function plots a histogram and overlays the normal distribution

hist_norm <- function (g, b=10, main="Comparison to normal", xlab="Average mph", ...) {
        
        
        sd<-sd(g)
        mean<-mean(g)
        
        h<-hist(g, breaks=b, density=10, col="lightgray", xlab=xlab, 
                main=main, ...) 
        
        xfit<-seq(min(g),max(g),length=40) 
        yfit<-dnorm(xfit,mean=mean,sd) 
        yfit <- yfit*diff(h$mids[1:2])*length(g) 
        lines(xfit, yfit, col="black", lwd=2)
        
        sd_x <- seq(mean - 3 * sd, mean + 3 * sd, by = sd)
        sd_y <- dnorm(x = sd_x, mean = mean, sd = sd)
        sd_y <- sd_y*diff(h$mids[1:2])*length(g) 
        segments(x0 = sd_x, y0=0, x1 = sd_x, y1 = sd_y, col = "red", lwd = 2)
        
        
        
}