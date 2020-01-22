################################################################################
##
## [ PROJ ] EDH 7916: Organizing
## [ FILE ] organizing_hw_example.R
## [ AUTH ] Benjamin Skinner (@btskinner)
## [ INIT ] 13 January 2020
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

## (3)
library(tidyverse)

## ---------------------------
## directory paths
## ---------------------------

## NB: This script assumes that your working directory is the
## top-level course directory, that is <path>/<to>/edh7916
##
## If you want to test that you are in the correct spot, uncomment the
## next line and run the function:

## list.files()

## You should see, among other things, a listing of folders that
## includes "assignments", "lessons", "scripts", and "data".

## If you are not in the correct working directory, you can navigate
## to it using the bottom right panel in RStudio. Once there, click
## the gear with "More" and select "Set as Working Directory"

## Remember: file.path() is just a smart function that builds a path
## for you based on what your operating system requires. Separate each
## level, which is surrounded by quotes, with a comma. Remember that a
## single dot is a relative path symbol meaning "start HERE in this
## directory"

## (4)
dat_dir <- file.path(".", "data")
fig_dir <- file.path(".", "figures")
tab_dir <- file.path(".", "tables")

## ---------------------------
## settings/macros
## ---------------------------

## The original score ratio was 1.1 (10% higher); let's change it 1.2
## (15% higher)

## (5)
old_to_new_score_ratio <- 1.15

## Let's also add a macro for the amount of extra credit we're giving
## as well as one for the IDs of the students who earn it.

## (9)
extra_credit_val <- 2
extra_credit_ids <- c(1,7)              # c() concatenates all values into single object


## ---------------------------
## functions
## ---------------------------

## This function is copied directly from the class lesson; b/c its
## output only changes based on the arguments we give it (<test_score>
## and <ratio>), we can reuse it as is, only changing the
## old_to_new_score_ratio to change the result. This is one key
## benefit of using functions over "magic numbers."

## (6)
old_to_new_score <- function(test_score, ratio) {
    return(test_score * ratio)
}

## -----------------------------------------------------------------------------
## BODY
## -----------------------------------------------------------------------------

## ---------------------------
## input
## ---------------------------

## In class (organizing.R), we've already updated our original data
## file and saved an updated copy; we read that in here.

## (7)
df <- readRDS(file.path(dat_dir, "test_scores_updated.RDS"))

## ---------------------------
## process
## ---------------------------

## This line is cut-pasted from the class script; the only change is
## the name of the new column, from "test_scores_new" to
## "test_scores_new_2". Everything else is the same:
##
## - same data frame                  := df
## - same function                    := old_to_new_score()
## - same starting column to modify   := df$test_score
## - same macro (but different value) := old_to_new_score_ratio

## (8)
df$test_scores_new_2 <- old_to_new_score(df$test_score, old_to_new_score_ratio)

## (9, version 1) --------------------------------

## Update test scores for just those IDs that have earned it
## NB: this only works b/c our stu_ids == the data frame row number (a
## more sophisticated version is below)
df$test_scores_final <- df$test_scores_new_2
df$test_scores_final[extra_credit_ids] <- df$test_scores_final[extra_credit_ids] + extra_credit_val

## Use ifelse() to set scores above 100 to 100 and round all others
df$test_scores_final <- ifelse(df$test_scores_final > 100,  # is score above 100?
                               100,                         # TRUE: make it 100
                               round(df$test_scores_final)) # FALSE: round()

## (9, version 2) --------------------------------

## Update test scores for just those IDs that have earned it. This
## time, we don't rely on the fact that our stu_id value == row
## number; instead, we only change values when stu_id ==
## extra_credit_ids. This is more robust (less likely to break if your
## data rows were shuffled, for example).

## -%in%- is a special R operator that roughly means "matches"; so the
## code inside the brackets says, "which stu_ids in the data frame
## match the values in extra_credit_ids?" (technically, it's a test
## like the ones we've used so far with ifelse()). The answer R
## returns is NOT the stu_id values, but rather the row numbers in
## which the matching stu_ids are found. This is a subtle distinction
## in this case since stu_id == row number, but it matters.

## Imagine a scenario in which the stu_ids weren't numbers but instead
## were letters: "a", "b", "c", etc. In that case, extra_credit_ids
## might be c("a", "g"). The code in the brackets would then be asking
## the same question, but matching based on letters instead of
## numbers. However, the results returned would still be the row
## numbers in which the stu_ids == "a" or "g", and the bracket would
## filter the column values as it did before.
df$test_scores_final <- df$test_scores_new_2
df$test_scores_final[df$stu_id %in% extra_credit_ids] <- df$test_scores_final[df$stu_id %in% extra_credit_ids] + extra_credit_val

## Same as v.1: use ifelse() to set scores above 100 to 100 and round all others
df$test_scores_final <- ifelse(df$test_scores_final > 100,  # is score above 100?
                               100,                         # TRUE: make it 100
                               round(df$test_scores_final)) # FALSE: round()

## (9, version 3) --------------------------------

## Finally, we can do this in a single line if we want to use nested
## ifelse statements. I personally don't find this very clear, but I
## want to show that it is possible.

## ifelse(< 1st arg >, < 2nd arg >, < 3rd arg >) asks:
## 1st arg: is the stu_id == to one in our list?
## if stu_id is in our list (TRUE), do the 2nd arg:
## - return the minimum of
##   - rounded new test score + extra credit
##   - 100
## if stu_id is not in our list (TRUE), do the 3rd arg:
## - return the minimum of
##   - rounded new test score (no extra credit)
##   - 100

## NB: pmin() is a special version of min() that returns the minimum
## value; we use so that if our final test score, either with or w/o
## extra credit, never goes above 100.

df$test_scores_final <- ifelse(df$stu_id %in% extra_credit_ids,
                               pmin(round(df$test_scores_new_2 + extra_credit_val), 100),
                               pmin(round(df$test_scores_new_2), 100))

## ---------------------------
## output
## ---------------------------

saveRDS(df, file.path(dat_dir, "test_scores_final.RDS"))

## -----------------------------------------------------------------------------
## END SCRIPT
## -----------------------------------------------------------------------------
