#' Title: Read Denovix files
#'
#' @author Tingwei Adeck
#'
#' @description
#' A function read Denovix data files.
#'
#' @import readxl
#' @importFrom utils read.csv
#' @importFrom utils read.table
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
    stop('Enter the string for a file or path to the Denovix-DS11 file')
  }

  if('csv' %in% file_type){
    csvfile = read.csv(file = dfile, header = TRUE)
    return(csvfile)

  } else if('excel' %in% file_type){
    xlfile = read_excel(dfile, col_names = TRUE)
    return(xlfile)

  } else if('txt' %in% file_type){
    txtfile = read.table(file = dfile, header = TRUE, skip = 0)
    return(txtfile)

  } else {
    if( is.null(file_type) || file_ext(dfile) == 'csv'){
      csvfile = read.csv(file = dfile, header = TRUE)
      return(csvfile)

    } else if(is.null(file_type) || file_ext(dfile) == 'xlsx'){
      xlfile = read_excel(dfile, col_names = TRUE)
      return(xlfile)

    } else if(is.null(file_type) || file_ext(dfile) == 'txt'){
      txtfile = read.table(file = dfile, header = TRUE, skip = 0)
      return(txtfile)

    }

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

  cutoff = which( colnames(xdf)=="Exposure" )
  ecn = xdf %>%
    janitor::clean_names() %>%
    base::names() %>%
    .[1:cutoff]

  return(ecn)

}

#' Title: Extract sample names from the Denovix data frame
#'
#' @author Tingwei Adeck
#'
#' @param dfile The denovix raw file for sample name(s) extraction.
#' @param file_type The type of file.
#'
#' @return A vector of sample names.
#'
#' @export
#'
#' @examples
#' fpath <- system.file("extdata", "rnaspec2018.csv", package = "tidyDenovix", mustWork = TRUE)
#' esn = extract_sample_names(fpath, file_type = 'csv')

extract_sample_names = function(dfile, file_type=NULL){

  xdf = read_denovix_data(dfile, file_type)

  xdf = janitor::clean_names(xdf)
  sample_names = xdf[, c("sample_name")]

  if(is.atomic(sample_names) || is.character(sample_names) ){
    sample_names = janitor::make_clean_names(sample_names)
    return(sample_names)
  } else {
    fixed_container = c()
    sample_names = as.character(sample_names)
    split_names = strsplit(sample_names,split = ',')
    for(i in split_names){
      fixed_container = c(fixed_container, i)
      }
    sample_names = janitor::make_clean_names(fixed_container)
    return(sample_names)
  }

}

#' Title: Quality Control data frame
#'
#' @author Tingwei Adeck
#'
#' @import data.table
#'
#' @param dfile The Denovix file path.
#' @param file_type The type of file.
#' @param xdf The Denovix data frame.
#'
#' @return A quality control data frame.
#'
#' @export
#'
#' @examples
#' fpath <- system.file("extdata", "rnaspec2018.csv", package = "tidyDenovix", mustWork = TRUE)
#' rna_data = read_denovix_data(fpath, file_type = 'csv')
#' qc_attributes = qc_attributes(fpath, file_type = 'csv', rna_data)

qc_attributes = function(dfile, file_type=NULL, xdf){

  xdf = xdf %>%
    janitor::clean_names()

  esn = extract_sample_names(dfile, file_type)

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
  #colnames(qc_df) = esn
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

  #cutoff = which(names(xdf)%in%c("Exposure"))
  #cutoff = match("Exposure",names(xdf) )
  cutoff = which( colnames(xdf)=="exposure" )
  aftercut = as.numeric(cutoff + 1)

  wave_lengths = colnames(xdf)[aftercut:length(colnames(xdf))]

  wl_vector = c()
  for (i in wave_lengths) {
    i = gsub('x','',i)
    wl_vector = c(wl_vector, as.numeric(i))
  }

  wave_lengths = wl_vector
  wave_lengths = as.data.frame(wave_lengths)

  return(wave_lengths)

}

#' Title: Make wavelength
#'
#' @author Tingwei Adeck
#'
#' @return A numeric data frame for the wavelength attribute.
#'
#' @export
#'
#' @examples
#' wl = make_wavelength()

make_wavelength = function(){

  wave_lengths = seq(from=220,to=350,by=1)
  wave_lengths = as.data.frame(wave_lengths)
  return(wave_lengths)

}

#' Title: Min-Max normalization of attributes that require normalization
#'
#' @author Tingwei Adeck (Adapted from Statology)
#'
#' @param x A single value from an attribute passed in the function for normalization.
#'
#' @return A normalized value (value between 1 and 0)
#'
#' @export
#'
#' @note lapply is needed to apply the function across several columns in a data set.
#'
#'
#' @examples test_df <- as.data.frame(c(seq(40)))
#' colnames(test_df) <- "test"
#' test_df_norm <- lapply(test_df[1:ncol(test_df)], min_max_norm)
#'
#' @references https://www.statology.org/how-to-normalize-data-in-r/

min_max_norm <- function(x){
  (x - min(x)) / (max(x) - min(x))
}

#' Title: File Extension Finder
#'
#' @author Tingwei Adeck
#'
#' @param epath File path.
#'
#' @return A string representing the file extension.
#'
#' @export
#'
#' @examples
#' fpath <- system.file("extdata", "rnaspec2018.csv", package = "tidyDenovix", mustWork = TRUE)
#' ext = file_ext(fpath)

file_ext <- function(epath) {
  sub(pattern = "^(.*\\.|[^.]+)(?=[^.]*)", replacement = "", epath, perl = TRUE)
}
