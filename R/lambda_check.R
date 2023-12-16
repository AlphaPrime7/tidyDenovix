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

  if('RNA' %in% sample_type && 'lax' %in% check_level){
    for (i in 1:nrow(qdf)) {
      for (j in 1:ncol(qdf)) {
        if( i== 3){
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
        if( i== 5){
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
        if( i== 5){
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
        if( i== 3){
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
        if( i== 3){
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
