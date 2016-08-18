update_cache <-
function(objs)
{
        for (o in objs) {
                cache_file <- paste("cache\\", o, ".Rdata", sep="")
                if (!file.exists(cache_file)) cache(o)
        }      
        
}
