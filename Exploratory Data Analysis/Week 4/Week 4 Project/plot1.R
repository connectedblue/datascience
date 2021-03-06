#  Exploratory Data Analysis - Week 4 project
#  
# The function below makes the plot and is called at the bottom of the script so that 
# reading this file in via source() will cause the plot graphic to be output
#

make_plot<-function(){
        
        # Download data for the project if not present in the working directory
        # This uses a helper function download_dataset defined below
        
        emission_dataset<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download_dataset(emission_dataset, filename = "emmissions.zip", datasetname = "summarySCC_PM25.rds")

        # create dataframe variables if not already present and clean up
        # it takes a while to load, so don't do it if already in memory
        if(!exists("NEI")) NEI <- readRDS("summarySCC_PM25.rds")
        if(!exists("SCC")) SCC <- readRDS("Source_Classification_Code.rds")

        # Calculate the total emissions per year in tonnes
        total_em<-with(NEI, tapply(Emissions, year, sum))
        # Scale to units of 1000 tonnes
        total_em<-total_em/1000
        
        # print to png file
        png("plot1.png")
        
        # Prepare the plot
        par(mfrow=c(1,1), mar=c(4,4,2,2))
        plot(names(total_em), total_em, type="b", pch=19, xaxt="n",
             xlim=c(1999, 2009),
             xlab="Year", ylab = "Thousand Tons of PM2.5",
             main ="Annual U.S. PM2.5 Emissions from all pollutant sources")
        
        # Add Years to x-axis
        axis(1, at = seq(1999, 2008, by = 1), las=1)
        
        # close the png file
        dev.off()
}


#
# The functions below are used to retrieve and unpack the raw data
# 

# helper function to download datasets to the current working directory
# Inputs:
# url - url of dataset 
# filename - the filename that the data should be stored on disk
# datasetname - the name of the dataset.  This could be different to filename,
#               for example an unzipped file might have a different name to the download
# zipdelete - if true, then a downloaded zip is deleted after sucessfully unzipping
# gitignore - if true, then the downloaded files will be added to .gitignore for the 
#             current directory so they won't get included in the commits

library(tools)

download_dataset<-function(url, filename="data", datasetname="",
                           zipdelete=TRUE, gitignore=TRUE) {
        
        # Don't do anything if the dataset is already present in the working directory
        if ((file.exists(filename) | file.exists(datasetname))){
                return()
        } 
        zipfilecontents<-""
        
        # get the file and save it
        download.file(url = url, destfile = filename)
        
        # for zip files, attempt to extract and delete the original zip
        if (file_ext(filename)=="zip") {
                zipfilecontents<-unzip(filename, list=TRUE)[["Name"]]    
                unzipfile <- tryCatch(
                        unzip(filename),
                        warning=function(e) e
                )
                # remove the zip file if there are no unzip warnings and zipdelete is TRUE
                if(!inherits(unzipfile, "warning") & zipdelete) {
                        unlink(filename)
                }
        }
        
        # add downloaded datafile names to gitignore
        if(gitignore)  add_to_gitignore(c(filename, zipfilecontents))
}

add_to_gitignore<-function(new_files_to_ignore){
        gitignore<-".gitignore"
        ensure_file_exists(gitignore)
        # get current contents
        current_files_to_ignore<-readLines(gitignore)
        # make new contents, eliminating any duplicates
        new_contents<-unique(c(new_files_to_ignore, current_files_to_ignore))
        # write new gitignore file
        writeLines(new_contents, gitignore)
}

ensure_file_exists <-function(file){
        # if a filename doesn't exist, create a zero byte one
        if(!file.exists(file)){
                write.table(data.frame(), file=file, col.names=FALSE)
        }
}

# Call the plot function
make_plot()
