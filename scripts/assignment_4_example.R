################################################################################
##
## <PROJ> EDH7916: Data Wrangling II: Appending, joining, and reshaping data
## <FILE> assignment_4_example.R
## <INIT> 17 February 2020
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
## Answer assignment 4 questions
## -----------------------------------------------------------------------------

## ---------------------------
## input
## ---------------------------

## read in data
df <- read_csv(file.path(dat_dir, "hsls_small.csv"))

## ---------------------------
## process
## ---------------------------

## ------------
## (1)
## ------------

df_region <- df %>%
    ## filter out missing scores
    filter(x1txmtscor > 0) %>%
    ## group by region
    group_by(x1region) %>%
    ## get mean test score by region
    summarise(test_scr_mean = mean(x1txmtscor))

df %>%
    ## need to filter out missing scores again because we only saved in other df
    filter(x1txmtscor > 0) %>%
    ## join back in regional averages
    left_join(df_region, by = "x1region") %>%
    ## get differences between test scores and regional average
    mutate(test_scr_diff = x1txmtscor - test_scr_mean) %>%
    ## group by region again
    group_by(x1region) %>%
    ## get summary by region of the test score difference
    summarise(test_scr_diff_mean = mean(test_scr_diff))

## Since the scores are normalized, the average difference between
## test scores and the average score should be the mean test score.
## We've effectively de-meaned the test score data --- centering it on
## 0 --- so taking the average of the de-meaned data, we should get 0!
## This only works because we are averaging raw differences. We should
## expect a different answer if averaging the abolute value of the
## differences.

## ------------
## (2)
## ------------

df_region <- df %>%
    ## filter out missing scores and missing family incomes
    filter(x1txmtscor > 0, x1famincome > 0) %>%
    ## group by region AND family income
    group_by(x1region, x1famincome) %>%
    ## get mean test score by region
    summarise(test_scr_mean = mean(x1txmtscor))

df %>%
    ## join summary values by both keys
    left_join(df_region, by = c("x1region", "x1famincome")) %>%
    ## select key variables so we can see them better
    select(stu_id, x1region, x1famincome, test_scr_mean)

## As a point of comparison, note that the values of test_scr_mean in
## rows 7 and 10 are the same.

## ------------
## (3)
## ------------

df_long <- df %>%
    ## select vars
    select(stu_id, x1stuedexpct, x1paredexpct, x4evratndclg) %>%
    ## reshape long
    pivot_longer(cols = starts_with("x1"),
                 names_to = "postsec_expects_var",
                 values_to = "postsec_expects_val")

## show
df_long

## To confirm, we can divide the number of rows in df_long by df; the
## result should equal 2

(nrow(df_long) / nrow(df) == 2)

## -----------------------------------------------------------------------------
## END SCRIPT
################################################################################
