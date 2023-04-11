################################################################################
##
## <PROJ> EDH7916: Data Wrangling I: Enter the {tidyverse}
## <FILE> assignment_3_example.R
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

## checking codebook, we know that -8 are missing values for test
## score; since all non-missing test scores are above zero, we can
## just select observations where the score is > 0
df_tmp <- filter(df, x1txmtscor > 0)

## get average
summarize(df_tmp, test_scr_mean = mean(x1txmtscor))

## ------------
## (2)
## ------------

## checking codebook, we know that -9 are missing values for gender;
## same as with test score, non-missing values of gender are either 1
## or 2, so we can filter to only positive values again (don't forget
## about filtering test scores again since we're starting from the
## main data frame)
df_tmp <- filter(df, x1txmtscor > 0, x1sex > 0)

## group by gender
df_tmp <- group_by(df_tmp, x1sex)

## get average by the groups we set
summarize(df_tmp, test_scr_mean = mean(x1txmtscor))

## ------------
## (3)
## ------------

## checking codebook, we know that -9 are missing values for dob and
## all other are positive in the form of YYYYMM
df_tmp <- filter(df, x1stdob > 0)

## we can use max() and min() with mutate() to get youngest/oldest...
df_tmp <- mutate(df_tmp,
                 x1stdob_oldest = min(x1stdob),
                 x1stdob_youngest = max(x1stdob))

## select our new columns
select(df_tmp, x1stdob_oldest, x1stdob_youngest)

## ...or, we can use arrange() to sort values and take top value...
arrange(df_tmp, x1stdob)                # oldest (top row)
arrange(df_tmp, desc(x1stdob))          # youngest (top row)

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

## checking codebook, we know that -8 & -9 are missing values for 185%
## poverty line measure; however, since only want students under 185%
## of the federal poverty line, we can just choose == 1; we also know
## that -8 & -9 are also missing values for categories of family
## income
df_tmp <- filter(df, x1poverty185 == 1, x1famincome > 0)

## now that we only have obs under 185% line, get median of remaining
## income values
summarize(df_tmp, faminc_med = median(x1famincome))

## ------------
## (5)
## ------------

## (a, v.1)
## 1) checking codebook, we drop -8 as missing values for x4hscompstat
df_tmp <- filter(df, x4hscompstat > 0)

## 2) create values for those who completed: TRUE (1) vs FALSE (0)
df_tmp <- mutate(df_tmp, hs_comp = ifelse(x4hscompstat < 3,
                                          1,
                                          0))

## 3) get total counts of completers and GED-only completers...
df_tmp <- summarize(df_tmp,
                    hs_comp_tot = sum(hs_comp),
                    ged_comp_tot = sum(x4hscompstat == 2))

## 4) compute GED %
mutate(df_tmp, ged_pct = ged_comp_tot / hs_comp_tot * 100)

## (a, v.2)
## 1) checking codebook, we drop -8 as missing values for x4hscompstat
df_tmp <- filter(df, x4hscompstat > 0)

## 2) create values for those who completed: TRUE (1) vs FALSE (0)
df_tmp <- mutate(df_tmp, hs_comp = ifelse(x4hscompstat < 3,
                                          1,
                                          0))

## 3) directly compute GED % while summarizing using the sum() function
summarise(df_tmp, ged_pct = sum(x4hscompstat == 2) / sum(hs_comp) * 100)

## (b) since we didn't save the prior step (a, v.2, step 3), all we
## need to do now is group by region, and then repeat the last step:

## group
df_tmp <- group_by(df_tmp, x1region)

## repeat (a, v.2, step 3)
summarise(df_tmp, ged_pct = sum(x4hscompstat == 2) / sum(hs_comp) * 100)

## ------------
## (6)
## ------------

## checking codebook, we can drop the following missing values:
## x1famincome := -8 & -9
## x4evratndclg := -8
df_tmp <- filter(df, x4evratndclg >= 0, x1famincome > 0)

## create indicator (dummy) variable that is TRUE (1) when family
## income is <= $35k and FALSE (0) otherwise
df_tmp <- mutate(df_tmp, lowinc = ifelse(x1famincome <= 2,
                                         1,
                                         0))

## (v1) since we want to compare low to high-income with region, we group by both
df_tmp <- group_by(df_tmp, x1region, lowinc)

## now we can get our percentages of attendance via summary; we'll use
## the compact version like 5.a.v2 above; first, however, need to make
## a column we can sum to get the total for our denominator
df_tmp <- mutate(df_tmp, count_var = 1)

## summarize, summing our count_var to make our denominator
summarize(df_tmp, att_pct = sum(x4evratndclg) / sum(count_var) * 100)

## (v2) dplyr has nice helper function, n(), that will give us a total
## for our denominator without having to make and sum() our own
## count_var; here's a version using it --- the answers should be the same
summarise(df_tmp, att_pct = sum(x4evratndclg) / n() * 100)

## -----------------------------------------------------------------------------
## END SCRIPT
################################################################################
