clear_cache <-
function (files=NULL){
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
