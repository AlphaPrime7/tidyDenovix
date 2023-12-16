#' Title: Clean data from the Denovix DS-11 instrument
#'
#' @author Tingwei Adeck
#'
#' @param dfile The raw file obtained from the machine.
#' @param file_type The file type specification.
#' @param sample_type The sample type specification used in quality control.
#' @param check_level The level of quality control performed.
#' @param fun A parameter used for boolean expressions.
#'
#' @return A cleaned data frame with attribute names in some instances.
#'
#' @export
#'
#' @note The strict level of QC yields a data frame with no attribute names.
#' This will be worked on so that users get the sample names for their data.
#'
#' @examples
#' fpath <- system.file("extdata", "rnaspec2018.csv", package = "tidyDenovix", mustWork = TRUE)
#' rna_data = tidyDenovix(fpath, file_type = 'csv', sample_type = 'RNA', check_level = 'lax')

tidyDenovix = function(dfile, file_type= c('csv','excel','txt'), sample_type = c('RNA','DNA'), check_level = c('strict','lax'), fun = NA){

  #PRE-TRANSPOSE:workflow before transposing

  nofun <- is.na(fun)

  #import ds11 file
  xdf = read_denovix_data(dfile=dfile, file_type = file_type)

  #get the qc df
  qc_df = qc_attributes(xdf)

  #get the lambda df
  lambda_df = extract_wavelength(xdf)

  #initial col_names for qc crosscheck
  xdfc = janitor::clean_names(xdf)
  sample_names = xdfc[, c("sample_name")]
  sample_names_wl = append('wave_length', sample_names)

  #TRANSPOSE the df-for workflow after transposing

  xdf = data.table::transpose(l = xdf)

  #sample_col_names<- vector("list")
  sample_col_names<- c()
  for(j in xdf[2,]){
    if(is.na(j) != nofun){
      sample_col_names <- c(sample_col_names,j)
    }
  }
  sample_col_names = append('wave_length', sample_col_names)

  #column names quality control
  qc_colnames = as.numeric((sample_names_wl == sample_col_names))

  if (sum(qc_colnames) == length(sample_names_wl)){
    col_names = sample_names_wl
  } else {
    col_names = c(1:length(sample_names_wl))
  }

  #wrangle df
  xdf = xdf[21:nrow(xdf),]

  #bind qc_df with wrangled df for QC
  xdf =rbind(qc_df, xdf)
  colnames(xdf) = sample_names

  #QC now
  xdf = lambda_check(xdf,sample_type = sample_type, check_level = check_level)

  #remove QC rows
  xdf = xdf[6:nrow(xdf),]

  #add the lambda attribute
  xdf = cbind(lambda_df, xdf)

  rownames(xdf) = c(1:nrow(xdf))

  return(xdf)

}



