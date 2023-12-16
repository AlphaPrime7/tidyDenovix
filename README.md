Tingwei Adeck
December 16, 2023

<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyDenovix

[![Project
status](https://www.repostatus.org/badges/latest/concept.svg)](https://github.com/AlphaPrime7/tidyDenovix/graphs/commit-activity)
[![Project
Status](https://www.repostatus.org/badges/latest/wip.svg)](https://github.com/AlphaPrime7/tidyDenovix/graphs/commit-activity)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/AlphaPrime7/tidyDenovix/graphs/commit-activity)

The goal of
[`{tidyDenovix}`](https://github.com/AlphaPrime7/tidyDenovix) is to
clean data obtained from the Denovix spectrophotometry instrument. This
package should clean data for RNA or DNA samples. At the moment users
should use the ‘lax’ option for quality control.

## Installation

You can install the development version of tidyDenovix from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("AlphaPrime7/tidyDenovix")
```

## Raison-Etre

- Upon using the Denovix, the user can take screenshots of the screen if
  they intend to present this data at a conference or seminar. However,
  the screenshots taken are not very professional and will likely not
  look good at a conference.
- As an undergraduate student I was faced with this issue and with poor
  programming skills, I had a hodgepodge of code lines that created an
  image but was not reproducible even by me because I had no idea what I
  was doing.
- Fast forward today and this package will accomplish cleaning this type
  of data making it ready for plotting and presenting to faculty and
  peers.

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(tidyDenovix)
## basic example code
fpath <- system.file("extdata", "rnaspec2018.csv", package = "tidyDenovix", mustWork = TRUE)
rna_data = tidyDenovix(fpath, file_type = 'csv', sample_type = 'RNA', check_level = 'lax')
```

## Quality Control

- As always quality is important so there are some quality parameters.
  Play around with the check_level parameter as ‘lax’ vs ‘strict’ to
  determine the level of quality needed for the final output.

- The ‘strict’ option right now does not retain sample names but that
  will be worked on before the initial final release. If not that will
  be worked on later.

## References

(Dowle and Srinivasan 2023) (Firke 2023) (Wickham et al. 2019)

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-datatable" class="csl-entry">

Dowle, Matt, and Arun Srinivasan. 2023.
*<span class="nocase">data.table</span>: Extension of
“<span class="nocase">data.frame</span>”*.
<https://CRAN.R-project.org/package=data.table>.

</div>

<div id="ref-janitor" class="csl-entry">

Firke, Sam. 2023. *<span class="nocase">janitor</span>: Simple Tools for
Examining and Cleaning Dirty Data*.
<https://CRAN.R-project.org/package=janitor>.

</div>

<div id="ref-tidyverse" class="csl-entry">

Wickham, Hadley, Mara Averick, Jennifer Bryan, Winston Chang, Lucy
D’Agostino McGowan, Romain François, Garrett Grolemund, et al. 2019.
“Welcome to the <span class="nocase">tidyverse</span>.” *Journal of Open
Source Software* 4 (43): 1686. <https://doi.org/10.21105/joss.01686>.

</div>

</div>
