#' Title: Wavelength quality control
#'
#' @author Tingwei Adeck
#'
#' @importFrom dplyr filter
#'
#' @param odf A data frame with quality attributes.
#' @param sample_type The type of sample under investigation.
#' @param check_level The level of strictness based on sample type.
#'
#' @return A vector of sample names for the different QC criteria.
#'
#' @export
#'
#' @note Some key assumptions are made about quality for RNA or DNA.
#' At the moment column names is the main issue found with using this approach.
#'
#'
#' @examples
#' fpath <- system.file("extdata", "rnaspec2018.csv", package = "tidyDenovix", mustWork = TRUE)
#' rna_data = read_denovix_data(fpath, file_type = 'csv')
#' qc_check = lambda_check_source(rna_data,sample_type='RNA',check_level='lax')

lambda_check_source = function(odf, sample_type = c('RNA','DNA'), check_level = c('strict','lax')){

  #x260_280_alert <- x260_230_alert <- NULL

  odf = odf %>%
    janitor::clean_names()

  if('RNA' %in% sample_type && 'lax' %in% check_level){
    odf = odf %>% dplyr::filter(x260_280_alert == 'Met criteria')
    sample_names = odf[, c("sample_name")]

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

  } else if('RNA' %in% sample_type && 'strict' %in% check_level){
    odf = odf %>% dplyr::filter(x260_230_alert == 'Met criteria')
    sample_names = odf[, c("sample_name")]

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

  } else if('DNA' %in% sample_type && 'lax' %in% check_level){
    odf = odf %>% dplyr::filter(x260_230_alert == 'Met criteria')
    sample_names = odf[, c("sample_name")]

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

  } else if('DNA' %in% sample_type && 'strict' %in% check_level){
    odf = odf %>% dplyr::filter(x260_280_alert == 'Met criteria')
    sample_names = odf[, c("sample_name")]

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

  } else {
    odf = odf %>% dplyr::filter(x260_280_alert == 'Met criteria')
    sample_names = odf[, c("sample_name")]

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

}

#' Title: Wavelength quality control
#'
#' @author Tingwei Adeck
#'
#' @param qdf A data frame with quality attributes.
#' @param sample_type The type of sample under investigation.
#' @param check_level The level of strictness based on sample type.
#'
#' @return A data frame that meets the quality check criteria.
#'
#' @export
#'
#' @note Some key assumptions are made about quality for RNA or DNA.
#' At the moment column names is the main issue found with using this approach.
#'
#'
#' @examples
#' fpath <- system.file("extdata", "rnaspec2018.csv", package = "tidyDenovix", mustWork = TRUE)
#' rna_data = read_denovix_data(fpath, file_type = 'csv')
#' qc_check = lambda_check(rna_data,sample_type='RNA',check_level='lax')

lambda_check = function(qdf, sample_type = c('RNA','DNA'), check_level = c('strict','lax')){

  pass_data = data.frame()

  qc_cols = list('x260_280_alert' = 3, 'x260_230_alert' = 5)
  qc_enum = REnum(qc_cols)

  if('RNA' %in% sample_type && 'lax' %in% check_level){
    for (i in 1:nrow(qdf)) {
      for (j in 1:ncol(qdf)) {
        if( i== qc_enum$x260_280_alert ){
          if(qdf[i,j] == 'Met criteria'){
            pass_data = rbind(pass_data,qdf[,j])
          }
        }
      }
    }
    pass_data = data.table::transpose(pass_data)
    return(pass_data)

  } else if('RNA' %in% sample_type && 'strict' %in% check_level){
    for (i in 1:nrow(qdf)) {
      for (j in 1:ncol(qdf)) {
        if( i== qc_enum$x260_230_alert){
          if(qdf[i,j] == 'Met criteria'){
            pass_data = rbind(pass_data,qdf[,j])
          }
        }
      }
    }

    pass_data = data.table::transpose(pass_data)
    return(pass_data)

  } else if('DNA' %in% sample_type && 'lax' %in% check_level){
    for (i in 1:nrow(qdf)) {
      for (j in 1:ncol(qdf)) {
        if( i== qc_enum$x260_230_alert){
          if(qdf[i,j] == 'Met criteria'){
            pass_data = rbind(pass_data,qdf[,j])
          }
        }
      }
    }

    pass_data = data.table::transpose(pass_data)
    return(pass_data)

  } else if('DNA' %in% sample_type && 'strict' %in% check_level){
    for (i in 1:nrow(qdf)) {
      for (j in 1:ncol(qdf)) {
        if( i== qc_enum$x260_280_alert ){
          if(qdf[i,j] == 'Met criteria'){
            pass_data = rbind(pass_data,qdf[,j])
          }
        }
      }
    }
    pass_data = data.table::transpose(pass_data)
    return(pass_data)

  } else {
    for (i in 1:nrow(qdf)) {
      for (j in 1:ncol(qdf)) {
        if( i== qc_enum$x260_280_alert ){
          if(qdf[i,j] == 'Met criteria'){
            pass_data = rbind(pass_data,qdf[,j])
          }
        }
      }
    }
    pass_data = data.table::transpose(pass_data)
    return(pass_data)

  }

}
