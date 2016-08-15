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
