# Test scores from 1980-1985: a descriptive analysis

This repository contains the replication files for the report "Test
scores from 1980-1985: a descriptive analysis." See the instructions
below for downloading the required data, making all tables and
figures, and reading the report.

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
|__/tables
|   |--+ README.md
|
|--+ test_scores.R
|--+ test_scores.md
```

All document tables and figures will be stored in the `tables` and
`figures` directories, respectively.

## Get data

By default, `test_scores.R` will check for presence of
`all_schools.csv` in the `data/` folder. If it doesn't find it, it
will download it and place it in the correct location. 

To download the data manually, `all_schools.csv` is available from the following link:

- https://github.com/edquant/edh7916/blob/master/data/sch_test/all_schools.csv

At the link, right-click the "Raw" button and choose to "Download
linked file." Once downloaded, move the file the `data/` folder in
this repository.

## Create tables and figures

To make the report's tables and figures, open `test_scores.R` in
RStudio and click the button to "Run."

### Required R packages

To compile the report, you'll need the following R package: 

- [tidyverse](https://CRAN.R-project.org/package=tidyverse)

You can install it by running the following code in the RStudio
console before running the main code:

```r
install.packages("tidyverse")
```

## Read report

You can either read the report `test_scores.md` in plain text or
compile to PDF or HTML. To compile, open with RStudio click the
"Preview" button.
