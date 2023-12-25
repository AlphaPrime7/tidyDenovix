#' Title: Log Errors to File
#'
#' @author Tingwei Adeck
#'
#' @import tryCatchLog
#'
#' @param errfunc A function with an error.
#'
#' @return A file with errors logged found in the present working directory.
#'
#' @export
#'
#' @references https://www.datatechnotes.com/2017/09/logging-into-file-in-r-scripts.html
#'
#' @examples
#' library(normfluodbf)
#' fpath <- system.file("extdata", "dat_2.dat", package = "normfluodbf", mustWork = TRUE)
#' log_it(normfluodat(dat=fpath, tnp = 3, cycles = 40))

log_it = function(errfunc, ...){


  log_file_name = function(file_name = 'log_file'){

    log_path = getwd()

    file_name = paste(file_name, format(Sys.time(),'%Y%m%d'), sep = '_')
    file_name = paste(log_path, paste(file_name, "log",sep = '.'), sep = '/')
    return(file_name)
  }

  file_name = log_file_name(file_name = 'log_file')

  #capture warnings that were suppressed
  out = tryCatch(

    {
      errfunc
    },

    error = function(e){
      message(paste('check the pwd for a log file:',file_name))
      print(e)
          },

    warning = function(w){
      message(paste('check the pwd for a log file:',file_name))
      print(w)
      return(NA)
    }

    )

  #setup logger to take errors or warnings
  logger = file(log_file_name(), open = 'at')
  sink(logger, type = 'message')

  #appending error messages to logger
  cat(format(Sys.time(), '%Y-%m-%d %X'), ':', paste(out,...), '\n', append = T, file = logger)
}




