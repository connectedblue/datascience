## Report helper functions
#  
# A set of functions to help create and generate reports


# find names of executable analysis (including reports) and a list of templates
#
# Input:  directory to explore
#
#  Output is a named list:
#         $templates:  a dataframe of available templates if a *_templates directory exists
#                       $name:  name of template
#                       $file:  file name of template
#         $names:  a data frame of available analysis/reports 
#                        $name:  name derived from subdirectory name
#                        $file: files contained in that directory

find.names <- function (dir="."){
        
        # get a list of top level sub directories for the directory passed in
        sub_dirs <- sort(list.dirs(dir, recursive = FALSE))
        
        # get any template subdirectory if they exist (ending in _template)
        template_dir<-grep(".*_templates$", sub_dirs, value = TRUE)
        # get remaining directories, if any
        other_dir <- setdiff(sub_dirs, template_dir)
        
        # function to extract relevant files and names from a list of directories
        # if get_name_from_dir is true, the sub directory name is used
        # otherwise the name is the part of the file before the extension
        extract_files <- function (dirs, get_name_from_dir=TRUE) {
                
                #helper function to split a full path name into component parts
                split_path <- function(x) if (dirname(x)==x) x else c(basename(x),split_path(dirname(x)))
                
                # make sure there's at least one / in the dir name
                dirs <- paste0("./", dirs)
                file <- c()
                
                # extract only files with extension R or Rmd
                extract_type <- ".*\\.Rmd|R$"
                
                # get the full path names of all the files of interest in dirs
                for (d in dirs) {
                        file <- c(file, file.path(d,list.files(d, pattern = extract_type)))
                }
                
                if (get_name_from_dir) {
                        name<-c()
                        for (f in file) name<-c(name, split_path(f)[2])
                }
                else {
                        # the name is the part before extension, not including path
                        name <- sub("(.*)\\.(.*)$","\\1", basename(file))
                }
                
                #return the names and paths as a data frame
                data.frame(name=name, file=file, stringsAsFactors = FALSE)
        }
        
        # Get template names and files
        templates <- NULL
        default_row <- 0
        if (length(template_dir)>0) {
                # Get the templates
                templates <- extract_files(template_dir, get_name_from_dir = FALSE)
                
                # Find the default
                default_templates <- grepl("(.*)-default$", templates$name)
                default_row <- which(default_templates==TRUE)
                
                # if there's no default template, set the first one as the default
                # otherwise find the first default template and set that
                if(length(default_row)==0) default_row<-1 else default_row <- min(default_row)
                
                # remove the -default from the names and add a (*) against the default row 
                templates$name <- sub("(.*)-default$", "\\1", templates$name)
                templates$default <- ""
                templates$default[default_row] <- "(*)"
        }
        
        # Get list of analysis/report files
        analysis <- NULL
        if (length(other_dir)>0)  analysis <- extract_files(other_dir)
        
        #return results as a list
        list(templates=templates, default_template=default_row, analysis=analysis)
}

# Function to create reports
# the reports folder has sub folders with the report names
# one subfolder is called report_templates and this contains various templates that
# can be used.  There is always one called standard.Rmd.  There can be many to choose
# from.
#  Inputs to this function:
#     name of new report 
#     template to base the new report on (default is standard)
#
#  Calling the function with no arguments shows a list of available templates

from.template <- function (report_name=NULL, template=NULL, rep_dir=NULL) {
        
        find_names <- find.names(rep_dir)
        available_templates <- find_names$templates
        
        if (is.null(available_templates)) stop("No report template directory found.")
        
        # if no report_name, print out the available templates
        if (is.null(report_name)) {
                # Show available templates, default template shown with an asterix
                templates <- paste0(available_templates$name, available_templates$default)
                
                cat("Available report templates: ", templates, "\n")
                cat("* template used by default if no name specified\n")
                return()
        }
        
        # if no template, select the default, otherwise find the row number of the
        # requested template
        if (is.null(template)) {
                template_file <- find_names$default_template
        }
        else {
                template_file <- match(template, available_templates$name)
                if (is.na(template_file)) stop(paste0("Report template ", template, " not found."))
        }
        
        template_file <- available_templates$file[template_file] 
        template_ext <- sub(".*(\\..*)$", "\\1", template_file)
        report_dir <- file.path(rep_dir, report_name)
        
        ####  This needs some more work to put a better name
        report_file <- file.path(report_dir, paste0("00",report_name, template_ext))
        
        #if(file.exists(report_file)) stop(paste0("Report ", report_name, " already exists"))
        
        dir.create(report_dir)
        file.copy(template_file, report_file)
        cat(paste0("Created new report ", report_name))
}

# wrapper for creating reports
create.report <- function(...) from.template(..., rep_dir="reports")

# wrapper for creating reports
create.analysis <- function(...) from.template(..., rep_dir="src")

# Function to generate reports
# Input parameters are:
#       report name     - in the reports directory as a subfolder 
#                         also supports x:y where y.Rmd is a script in the x folder
#       regenerate      - if TRUE, then the caches are deleted before running
# Running the function without any parameters will give a list of
# available reports

write.report <- function (report_name=NULL, regenerate=FALSE) {
        
        rep_dir <- "reports"
        if (is.null(report_name)) {
                # Find available reports with the Rmd file extension
                # but show them without the extension
                rep_dir_reports <- report.names(rep_dir)
                return ()
        }
        
        report_file <- file.path(rep_dir, paste0(report, ".Rmd"))
        report_cache <- file.path(rep_dir, paste0(report, "_cache"))
        
        if (!file.exists(report_file)) stop("No such report:  Type report() to see available reports")
        if (generate) {
                if (file.exists(report_cache)) unlink(report_cache, recursive = TRUE)
        }
        run.file(report_file)
}


# File to execute a file depending on its extension
#
# .R file is just sourced
# .Rmd is rendered 

run.file <- function(file) {
        
        if (length(file) != 1 | !is.character(file)) stop("Invalid file name")
        
        run_function <- function (file) {
                ext <- sub(".*\\.(.*)$", "\\1", file)
                if (ext =="R") return (source)
                if (ext =="Rmd") return (rmarkdown::render)
                NULL
        }
        
        exec <- run_function(file)
        if(!is.null(exec)) do.call(exec, list(file))
}

# Run a list of files

run.files <- function(files){
        
        for (file in files) run.file(file)
        
}