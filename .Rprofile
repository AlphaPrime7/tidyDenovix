options(scipen=999)

silentLoad <- function(p) {
  cat(paste('Loading package:',p,'\n'))
  suppressWarnings(suppressPackageStartupMessages(library(p, character.only = T)))
}

.First <- function() {
  silentLoad('tibble')
}

.Last <- function() {
  cat('Bye now.')
}

#.First.sys()
#old <- getOption("defaultPackages")
#options(defaultPackages = c(old, "tidyverse"))
