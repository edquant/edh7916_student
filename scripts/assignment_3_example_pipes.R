################################################################################
##
## <PROJ> EDH7916: Data Wrangling I: Enter the {tidyverse}
## <FILE> assignment_3_example_pipes.R
## <INIT> 27 January 2020
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

library(tidyverse)

## ---------------------------
## directory paths
## ---------------------------

## assume we're running this script from the ./scripts subdirectory
dat_dir <- file.path("..", "data")

## -----------------------------------------------------------------------------
## Answer assignment 3 questions
## -----------------------------------------------------------------------------

## ---------------------------
## input
## ---------------------------

## data are CSV, so we use readr::read_csv()
df <- read_csv(file.path(dat_dir, "hsls_small.csv"))

## ---------------------------
## process
## ---------------------------

## ------------
## (1)
## ------------

df %>%
    ## remove missing values (which are less than 0)
    filter(x1txmtscor > 0) %>%
    ## get average
    summarize(test_scr_mean = mean(x1txmtscor))

## ------------
## (2)
## ------------

df %>%
    ## remove missing values (which are less than 0 for both)
    filter(x1txmtscor > 0, x1sex > 0) %>%
    ## group by gender
    group_by(x1sex) %>%
    ## same as for (1), but will be within gender since we set as group
    summarize(test_scr_mean = mean(x1txmtscor))

## ------------
## (3)
## ------------

df %>%
    ## remove missing values (which are less than 0)
    filter(x1stdob > 0) %>%
    ## we can use max() and min() with mutate() to get youngest/oldest...
    mutate(x1stdob_oldest = min(x1stdob),
           x1stdob_youngest = max(x1stdob)) %>%
    ## select our new columns to show
    select(x1stdob_oldest, x1stdob_youngest)

## NB: "00" isn't a month (see our min value), so looking at the code
## book, we find that "In cases where the student questionnaire birth
## date is entirely missing, only the birth year is provided from the
## sampling roster, and X1STDOB is filled with YYYY00." So if we want
## to be -very- precise, then we would drop DOB values that had "00"
## as the last two digits. We'll work on this in our lesson on working
## with strings.

## ------------
## (4)
## ------------

df %>%
    ## only want below 185 poverty line and non-missing income values
    filter(x1poverty185 == 1, x1famincome > 0) %>%
    ## get median of remaining income values
    summarize(faminc_med = median(x1famincome))

## ------------
## (5)
## ------------

## I'm only going to give the most compact way to answer this two part
## question:

## (a: overall)
df %>%
    ## keep only non-missing
    filter(x4hscompstat > 0) %>%
    ## create values for those who completed: TRUE (1) vs FALSE (0)
    mutate(hs_comp = (x4hscompstat < 3)) %>%
    ## directly compute GED % while summarizing using the sum() function
    summarise(ged_pct = sum(x4hscompstat == 2) / sum(hs_comp) * 100)

## (b: by region)
df %>%
    ## keep only non-missing
    filter(x4hscompstat > 0) %>%
    ## create values for those who completed: TRUE (1) vs FALSE (0)
    mutate(hs_comp = (x4hscompstat < 3)) %>%
    ## EXTRA STEP HERE: group by region
    group_by(x1region) %>%
    ## directly compute GED % while summarizing using the sum() function
    summarise(ged_pct = sum(x4hscompstat == 2) / sum(hs_comp) * 100)

## ------------
## (6)
## ------------

## As with (5) above, I'm only going to give the most compact version

df %>%
    ## keep only non-missing values
    filter(x4evratndclg >= 0, x1famincome > 0) %>%
    ## create indicator (dummy) variable that is TRUE (1) when family
    ## income is <= $35k and FALSE (0) otherwise
    mutate(lowinc = (x1famincome <= 2)) %>%
    ## group by region and our new low income indicator
    group_by(x1region, lowinc) %>%
    ## divide sum of attendance indicator (1 == YES) by total, n(), to get %
    summarise(att_pct = sum(x4evratndclg) / n() * 100)

## -----------------------------------------------------------------------------
## END SCRIPT
################################################################################
