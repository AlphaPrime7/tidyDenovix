Tingwei Adeck
July 14, 2024

<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyDenovix <img src="man/figures/logo.png" align="right" width="180"/>

[![Demandez moi n’importe
quoi!](https://img.shields.io/badge/Demandez%20moi-n'%20importe%20quoi-1abc9c.svg)](mailto:awesome.tingwei@outlook.com)
[![Project
status](https://www.repostatus.org/badges/latest/concept.svg)](https://github.com/AlphaPrime7/tidyDenovix/graphs/commit-activity)
[![Project
Status](https://www.repostatus.org/badges/latest/wip.svg)](https://github.com/AlphaPrime7/tidyDenovix/graphs/commit-activity)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/AlphaPrime7/tidyDenovix/graphs/commit-activity)
[![CRAN \[\](https://mit-license.org/)
status](https://www.r-pkg.org/badges/version/tidyDenovix)](https://CRAN.R-project.org/package=tidyDenovix)
[![CRAN RStudio mirror
downloads](https://cranlogs.r-pkg.org/badges/last-week/tidyDenovix?color=blue)](https://r-pkg.org/pkg/tidyDenovix)
[![CRAN RStudio mirror
downloads](https://cranlogs.r-pkg.org/badges/last-month/tidyDenovix?color=blue)](https://r-pkg.org/pkg/tidyDenovix)
[![CRAN RStudio mirror
downloads](https://cranlogs.r-pkg.org/badges/grand-total/tidyDenovix?color=blue)](https://r-pkg.org/pkg/tidyDenovix)

<a href="https://www.buymeacoffee.com/tingweiadeck"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&amp;emoji=&amp;slug=tingweiadeck&amp;button_colour=FFDD00&amp;font_colour=000000&amp;font_family=Cookie&amp;outline_colour=000000&amp;coffee_colour=ffffff" width="100" height="50"/></a>
<a href="https://www.buymeacoffee.com/tingweiadeck"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a Pizza&amp;emoji=🍕&amp;slug=tingweiadeck&amp;button_colour=FFDD00&amp;font_colour=000000&amp;font_family=Cookie&amp;outline_colour=000000&amp;coffee_colour=ffffff" width="100" height="50"/></a>

The goal of
[`{tidyDenovix}`](https://github.com/AlphaPrime7/tidyDenovix) is to
clean data obtained from the Denovix spectrophotometry instrument. This
package should clean data for RNA or DNA samples. At the moment users
should use the ‘lax’ option for quality control.

## Installation

You can install the development version of tidyDenovix from
[GitHub](https://github.com/AlphaPrime7/tidyDenovix) with:

``` r
devtools::install_github("AlphaPrime7/tidyDenovix")
```

You can install from CRAN with:

``` r
install.packages("tidyDenovix")
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
- Use the normalization parameter to find abnormal samples, meaning this
  package can be used to detect quality RNA isolates. This readme
  document will provide some code for plotting and enjoying
  visualizations while also accounting for quality of RNA isolates.

## Quality Control

- As always quality is important so there are some quality parameters.
  Play around with the check_level parameter as ‘lax’ vs ‘strict’ to
  determine the level of quality needed for the final output.

## Example-Base

This is a basic example which shows you how to solve a common problem:

``` r
library(tidyDenovix)
#> 
#> == Welcome to tidyDenovix ===========================================================================
#> If you find this package useful, please leave a star: 
#>    https://github.com/AlphaPrime7/tidyDenovix'
#> 
#> If you encounter a bug or want to request an enhancement please file an issue at:
#>    https://github.com/AlphaPrime7/tidyDenovix/issues
#> 
#> 
#> Thank you for using tidyDenovix!
## basic example code
fpath <- system.file("extdata", "rnaspec2018.csv", package = "tidyDenovix", mustWork = TRUE)
rna_data = tidyDenovix(fpath, file_type = 'csv', sample_type = 'RNA', check_level = 'lax')
```

## Example-Normalized

This examples implements normalization for Quality Control of RNA
isolates:

``` r
library(tidyDenovix)
## basic example code
fpath <- system.file("extdata", "rnaspec2018.csv", package = "tidyDenovix", mustWork = TRUE)
rna_data = tidyDenovix(fpath, sample_type = 'RNA',check_level = 'strict', qc_omit = 'no', normalized = 'yes')
```

## Example-Plotting Data for QC visualization (Spectral Profiling)

- Visualization of normalized data for QC. Spectrophotometry can help in
  knowing if the sample in hand is RNA vs DNA but that is not the most
  sound approach. More will be discussed below on this.

- Simply look for samples that look different and “viola” those are your
  problems. These samples will not be primed candidates for cDNA
  synthesis and most likely not useful for qPCR.

- The other aspect of QC will be ensuring that the kit used in RNA
  isolation is the right kit and actually yields RNA. This can only be
  done using gel electrophoresis and this is NOT the scope of this
  package OR is it even possible using this package. The user will need
  to physically run gels and confirm the presence of rRNA bands. In
  fact, it is resource smart to run gels first to confirm you have the
  right type of sample before determining if the samples meet the right
  quality needed for further probing.

``` r
library(tidyDenovix)
## basic example code
fpath <- system.file("extdata", "rnaspec2018.csv", package = "tidyDenovix", mustWork = TRUE)
rna_data = tidyDenovix(fpath, sample_type = 'RNA',check_level = 'strict', qc_omit = 'no', normalized = 'yes')

#PLOT-rnaspec2018.csv 'strict'
library(ggplot2)
library(plotly)
library(htmlwidgets)
rnaqcplot = ggplot(rna_data, aes(x=wave_length)) + 
  geom_line(aes(y=zt2_3, color='zt2_3')) + 
  geom_line(aes(y=zt14_2, color='zt14_2')) + 
  geom_line(aes(y=zt14_2_2, color='zt14_2_2')) +
  geom_line(aes(y=cal_rna_12ul, color='cal_rna_12ul')) +
  geom_line(aes(y=zt6_3, color='zt6_3'))  + 
  geom_line(aes(y=zt6_3_2, color='zt6_3_2')) + 
  geom_line(aes(y=zt10_3, color='zt10_3')) + 
  geom_line(aes(y=zt10_3_2, color='zt10_3_2')) +
  labs(title = 'Absorbance vs Wavelength', x = 'Wavelength', y='10 mm Absorbance', color='Circadian Times')
#saveWidget(ggplotly(rnaqcplot), file = "rnaplot.html", selfcontained = F, libdir = "lib")
#ggplotly(rnaqcplot)
rnaqcplot
```

<figure>
<img src="man/figures/example3-1.png" alt="Results Demo." />
<figcaption aria-hidden="true">Results Demo.</figcaption>
</figure>

- The image above clearly shows that no samples were trying to be
  mavericks and all the samples behave similarly. All the samples above
  are quality samples at least based on spectrophotometry and ONLY gel
  electrophoresis rRNA band intensity can tell more about sample
  quality.

``` r
#PLOT dark mode-rnaspec2018.csv 'strict'
library(ggplot2)
library(plotly)
library(ggdark)
library(ggthemes)
library(htmlwidgets)
library(widgetframe)
#library(hrbrthemes)
#old <- theme_set(theme_dark())
rnaqcplot = ggplot(rna_data, aes(x=wave_length)) + 
  geom_line(aes(y=zt2_3, color='zt2_3')) + 
  geom_line(aes(y=zt14_2, color='zt14_2')) + 
  geom_line(aes(y=zt14_2_2, color='zt14_2_2')) +
  geom_line(aes(y=cal_rna_12ul, color='cal_rna_12ul')) +
  geom_line(aes(y=zt6_3, color='zt6_3'))  + 
  geom_line(aes(y=zt6_3_2, color='zt6_3_2')) + 
  geom_line(aes(y=zt10_3, color='zt10_3')) + 
  geom_line(aes(y=zt10_3_2, color='zt10_3_2')) +
  dark_mode() +
  labs(title = 'Absorbance vs Wavelength', x = 'Wavelength', y='10 mm Absorbance', color='Circadian Times')
#saveWidget(ggplotly(rnaqcplot), file = "rnaplot.html", selfcontained = F, libdir = "lib")
#frameWidget(ggplotly(rnaqcplot))
#ggplotly(rnaqcplot)
rnaqcplot
```

<figure>
<img src="man/figures/example4-1.png" alt="Results Demo." />
<figcaption aria-hidden="true">Results Demo.</figcaption>
</figure>

## Conclusion

- Finally, a programmatic solution to the problem of RNA quality
  checking.
- As always, credit to the Denovix team for making a machine that
  performs RNA QC checking. As always, these products come within their
  scope and programmers like me have to push this envelope in order to
  gain insight on these experiments hence tidyDenovix.
- Thanks for the support in advance, on to the next one.

## References

(Dowle and Srinivasan 2023) (Firke 2023) (Wickham et al. 2019)

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0">

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
