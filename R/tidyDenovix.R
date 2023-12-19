#' Title: Clean data from the Denovix DS-11 instrument
#'
#' @author Tingwei Adeck
#'
#' @import tidyr
#' @importFrom stats complete.cases
#'
#' @param dfile The raw file obtained from the machine.
#' @param file_type The file type specification.
#' @param sample_type The sample type specification used in quality control.
#' @param check_level The level of quality control performed.
#' @param qc_omit Takes 'yes' or 'no' and determines if the qc data would be provided.
#' @param normalized Takes 'yes' or 'no'.
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

tidyDenovix = function(dfile, file_type= NULL, sample_type = c('RNA','DNA'), check_level = c('strict','lax'), qc_omit = NULL, normalized = c('yes','no'), fun = NA){

suppressWarnings({

  nofun <- is.na(fun)

  #import
  if(!is.null(file_type)){
    xdf = read_denovix_data(dfile=dfile, file_type = file_type)
    xdf_qc = read_denovix_data(dfile=dfile, file_type = file_type) #for QC

  } else {
    xdf = read_denovix(dfile=dfile)
    xdf_qc = read_denovix(dfile=dfile) #for QC
  }
  #xdf = read_denovix(dfile=dfile)
  #xdf_qc = read_denovix(dfile=dfile) #for QC


  cutoff = which( colnames(xdf)=="Exposure" )
  aftercut = as.numeric(cutoff + 1)

  #qc_df
  qc_df = qc_attributes(dfile = dfile,file_type, xdf)
  row_cutoff = as.numeric(nrow(qc_df) + 1)

  #wavelength
  lambda_df = extract_wavelength(xdf)

  #col_names from source
  xdfc = janitor::clean_names(xdf)
  esn = extract_sample_names(dfile=dfile, file_type)

  #transpose
  xdf = data.table::transpose(l = xdf)

  #segment spectrophotometry data
  xdf = xdf[c(aftercut:nrow(xdf) ),]

  #bind qc_df
  xdf =rbind(qc_df, xdf)
  colnames(xdf) = esn

  #perform quality check
  xdf = lambda_check(xdf,sample_type = sample_type, check_level = check_level)
  sample_names = lambda_check_source(xdf_qc,sample_type = sample_type, check_level = check_level)
  col_names = append('wave_length', sample_names)

  if( is.null(qc_omit) || qc_omit == 'yes'){

    if(is.null(normalized) || 'no' %in% normalized){
      xdf = xdf[row_cutoff:nrow(xdf),]
      xdf = cbind(lambda_df, xdf)
      xdf = xdf[complete.cases(xdf), ]
      xdf = as.data.frame(lapply(xdf[1:ncol(xdf)], as.numeric))
      rownames(xdf) = c(1:nrow(xdf))
      colnames(xdf) = col_names

      return(xdf)

    } else {
      xdf = xdf[row_cutoff:nrow(xdf),]
      xdf = as.data.frame(lapply(xdf[1:ncol(xdf)], as.numeric))
      xdf = as.data.frame(lapply(xdf[1:ncol(xdf)], min_max_norm))
      xdf = cbind(lambda_df, xdf)
      #xdf = as.data.frame(lapply(xdf[1:ncol(xdf)], as.numeric))
      #rownames(xdf) = c(1:nrow(xdf))
      colnames(xdf) = col_names

      return(xdf)

    }

  } else {

    if(is.null(normalized) || 'no' %in% normalized){
      n <- 'qc_df'
      assign( paste0(n, '_check'), as.data.frame(xdf), envir = parent.frame())
      xdf = xdf[row_cutoff:nrow(xdf),]
      xdf = as.data.frame(lapply(xdf[1:ncol(xdf)], as.numeric))
      xdf = cbind(lambda_df, xdf)
      rownames(xdf) = c(1:nrow(xdf))
      colnames(xdf) = col_names

      return(xdf)

    } else {
      n <- 'qc_df'
      assign( paste0(n, '_check'), as.data.frame(xdf), envir = parent.frame())
      xdf = xdf[row_cutoff:nrow(xdf),]
      xdf = as.data.frame(lapply(xdf[1:ncol(xdf)], as.numeric))
      xdf = as.data.frame(lapply(xdf[1:ncol(xdf)], min_max_norm))
      xdf = cbind(lambda_df, xdf)
      #rownames(xdf) = c(1:nrow(xdf))
      colnames(xdf) = col_names

      return(xdf)

    }

  }

})

}


