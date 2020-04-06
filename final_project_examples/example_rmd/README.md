# Test scores from 1980-1985: a descriptive analysis

This repository contains the replication files for the report "Test
scores from 1980-1985: a descriptive analysis." See the instructions
below for downloading the required data and compiling the report.

## Directory structure

This repository should have the following folders and files:

```
./example_rmd
|
|__/data
|   |--+ README.md
|
|__/figures
|   |--+ README.md
|
|--+ test_scores.Rmd
```

All document figures will be stored in the `figures` directory.

## Get data

By default, `test_scores.Rmd` will check for presence of
`all_schools.csv` in the `data/` folder. If it doesn't find it, it
will download it and place it in the correct location. 

To download the data manually, `all_schools.csv` is available from the following link:

- https://github.com/edquant/edh7916/blob/master/data/sch_test/all_schools.csv

At the link, right-click the "Raw" button and choose to "Download
linked file." Once downloaded, move the file the `data/` folder in
this repository.

## Compile Report

To compile the report, open `test_scores.Rmd` in RStudio and "Knit"
using the icon button, By default, the document will attempt to
compile to PDF. If you don't have a
[LaTeX](https://www.latex-project.org/get/) distribution on your
machine, you can also choose to compile to Word (if you have MS Word
on your machine) or HTML.

### Required R packages

To compile the report, you'll need the following R packages: 

- [tidyverse](https://CRAN.R-project.org/package=tidyverse)
- [knitr](https://CRAN.R-project.org/package=knitr)

You can install them by running the following code in the RStudio
console before knitting the main document:

```r
install.packages(c("tidyverse","knitr"))
```
