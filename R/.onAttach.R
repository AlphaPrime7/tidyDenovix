#' visit https://martinctc.github.io/blog/make-package-even-more-awesome/
#' some packages for this are enrichR,CPAT etc.
#' @import userhooks 
.onAttach <- function(libname, pkgname) {
  msg <- paste0(
    "\n",
    "== Welcome to tidyDenovix ===========================================================================",
    "\nIf you find this package useful, please leave a star: ",
    "\n   https://github.com/AlphaPrime7/tidyDenovix'",
    "\n",
    "\nIf you encounter a bug or want to request an enhancement please file an issue at:",
    "\n   https://github.com/AlphaPrime7/tidyDenovix/issues",
    "\n",
    "\n",
    "\nThank you for using tidyDenovix!",
    "\n"
  )

  packageStartupMessage(msg)
}