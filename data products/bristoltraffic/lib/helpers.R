# Useful Helper functions applicable to all projects

# delete specific files from the cache
clear_cache <- function (files=NULL){
        cache_dir <- ".\\cache"
        
        #if no arguments, then select everything in the cache 
        if (is.null(files)) {
                files <- list.files(cache_dir)
        }
        else {
                # Add the .RData cache extension to the objects to delete
                files <- paste(files, rep("RData", length(files)),  sep=".")
        }
        files_to_delete <-paste(rep(cache_dir, length(files)), files, sep="\\")
        do.call(file.remove,list(files_to_delete))
}


# delete both the cache and environment data
clear_all <- function()
{
        clear_cache()
        clear()
}

# clear all the environment data
clear <- function () {
        rm(list=ls(envir = globalenv()), envir =  globalenv())
}

# This function only caches an object if it's not already in the cache
# Accepts a character vector as an input
update_cache <- function(objs)
{
        for (o in objs) {
                cache_file <- paste("cache\\", o, ".Rdata", sep="")
                if (!file.exists(cache_file)) cache(o)
        }      
        
}

# Read in custom config contained in a file called
# custom.dcf in the config directory
# Adds the custom config options to the global config variable

read_custom_config <- function () {
        custom_cfg <- file.path('config', 'custom.dcf') 
        # read in custom config
        if (file.exists(custom_cfg)) {
                cust_config <- translate.dcf(custom_cfg)
        }
        # all items are char, so convert them if they look like logical or numeric
        convert_type <- function(v){
                
                if(!is.na(as.logical(v))) return (as.logical(v))
                if(!is.na(as.numeric(v))) return (as.numeric(v))
                v
        }
        # Add custom config to global config variable
        # warnings about NA from the convert type function can be ignored
        config <<- c(config, suppressWarnings(lapply(cust_config, convert_type)))
}

# Function to generate reports
# Input parameters are:
#       report name   - in the reports directory with the .Rmd extension
#       generate      - if TRUE, then the caches are deleted before running
# Running the function without any parameters will give a list of
# available reports

report <- function (report=NULL, generate=FALSE) {
        
        rep_dir <- "reports"
        if (is.null(report)) {
                # Find available reports with the Rmd file extension
                # but show them without the extension
                return (sub("(.*)\\.Rmd$","\\1",list.files(rep_dir, pattern = "*.Rmd")))
        }
        
        report_file <- file.path(rep_dir, paste0(report, ".Rmd"))
        report_cache <- file.path(rep_dir, paste0(report, "_cache"))
        
        if (!file.exists(report_file)) stop("No such report:  Type report() to see available reports")
        if (generate) {
                if (file.exists(report_cache)) unlink(report_cache, recursive = TRUE)
        }
        rmarkdown::render(report_file)
}

