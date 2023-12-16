#' Title: Read Denovix files
#'
#' @author Tingwei Adeck
#'
#' @description
#' A function read Denovix data files.
#'
#' @import readxl
#'
#' @param dfile A Denovix file or path to the Denovix file.
#' @param file_type The file type being imported.
#'
#' @return A data frame.
#'
#' @export
#'
#' @note
#' Denovix files can be saved as csv, txt or even excel files.
#' This function accounts for these file types.
#'
#' @examples
#' fpath <- system.file("extdata", "rnaspec2018.csv", package = "tidyDenovix", mustWork = TRUE)
#' rna_data = read_denovix_data(fpath, file_type = 'csv')

read_denovix_data = function(dfile, file_type = c('csv','excel','txt')){

  if(is.null(dfile)){
    warning('Enter the string for a file or path to the Denovix-DS11 file')
  }

  if('csv' %in% file_type){
    csvfile = read.csv(file = dfile)
    return(csvfile)

  } else if('excel' %in% file_type){
    xlfile = read_excel(dfile)
    return(xlfile)

  } else if('txt' %in% file_type){
    txtfile = read.table(file = dfile, header = TRUE, skip = 0)
    return(txtfile)

  } else {
    txtfile = read.table(file = dfile, header = TRUE, skip = 0)
    return(txtfile)
  }

}

#' Title: Extract key colnames from the Denovix data frame
#'
#' @author Tingwei Adeck
#'
#' @import janitor
#'
#' @param xdf The data frame for colname(s) extraction.
#'
#' @return A vector of key column names.
#'
#' @export
#'
#' @examples
#' fpath <- system.file("extdata", "rnaspec2018.csv", package = "tidyDenovix", mustWork = TRUE)
#' rna_data = read_denovix_data(fpath, file_type = 'csv')
#' col_names = extract_col_names(rna_data)

extract_col_names = function(xdf){

  ecn = xdf %>%
    janitor::clean_names() %>%
    base::names() %>%
    .[1:20]

  return(ecn)

}

#' Title: Quality Control data frame
#'
#' @author Tingwei Adeck
#'
#' @import data.table
#'
#' @param xdf The Denovix data frame.
#'
#' @return A quality control data frame.
#'
#' @export
#'
#' @examples
#' fpath <- system.file("extdata", "rnaspec2018.csv", package = "tidyDenovix", mustWork = TRUE)
#' rna_data = read_denovix_data(fpath, file_type = 'csv')
#' qc_attributes = qc_attributes(rna_data)

qc_attributes = function(xdf){

  xdf = xdf %>%
    janitor::clean_names()

  #concentration
  concentration = xdf[, c("concentration")]
  concentration = as.data.frame(concentration)
  concentration = data.table::transpose(concentration)
  rownames(concentration) = "concentration"

  #a260 value-not needed for QC
  a260 = xdf[, c("a260")] #of no use

  #260/280 ratio-important for QC
  x260_280 = xdf[, c("x260_280")]
  x260_280 = as.data.frame(x260_280)
  x260_280 = data.table::transpose(x260_280)
  rownames(x260_280) = "x260_280"

  #260/280 ratio-alert simplifies QC
  x260_280_alert = xdf[, c("x260_280_alert")]
  x260_280_alert = as.data.frame(x260_280_alert)
  x260_280_alert = data.table::transpose(x260_280_alert)
  rownames(x260_280_alert) = "x260_280_alert"

  #260/230 ratio-important for QC
  x260_230 = xdf[, c("x260_230")]
  x260_230 = as.data.frame(x260_230)
  x260_230 = data.table::transpose(x260_230)
  rownames(x260_230) = "x260_230"

  #260/230 ratio-alert simplifies QC
  x260_230_alert = xdf[, c("x260_230_alert")]
  x260_230_alert = as.data.frame(x260_230_alert)
  x260_230_alert = data.table::transpose(x260_230_alert)
  rownames(x260_230_alert) = "x260_230_alert"

  qc_df =rbind(concentration, x260_280, x260_280_alert, x260_230, x260_230_alert)
  #str(qc_df)
  return(qc_df)

}

#' Title: Extract wavelength
#'
#' @author Tingwei Adeck
#'
#' @param xdf The original data frame derived from importing Denovix data.
#'
#' @return A numeric data frame for the wavelength attribute.
#'
#' @export
#'
#' @examples
#' fpath <- system.file("extdata", "rnaspec2018.csv", package = "tidyDenovix", mustWork = TRUE)
#' rna_data = read_denovix_data(fpath, file_type = 'csv')
#' wl = extract_wavelength(rna_data)

extract_wavelength = function(xdf){

  xdf = xdf %>%
    janitor::clean_names()

  wave_lengths = colnames(xdf)[21:length(colnames(xdf))]

  wl_vector = c()
  for (i in wave_lengths) {
    i = gsub('x','',i)
    wl_vector = c(wl_vector, as.numeric(i))
  }

  wave_lengths = wl_vector
  wave_lengths = as.data.frame(wave_lengths)

  return(wave_lengths)

}
