################################################################################
##
## [ PROJ ] EDH 7916: Organizing
## [ FILE ] organizing_hw_example.R
## [ AUTH ] Benjamin Skinner (@btskinner)
## [ INIT ] 13 January 2020
## [ REVN ] 19 January 2022
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
## scripts directory, that is <path>/<to>/student_skinner/scripts
##
## If you want to test that you are in the correct spot, uncomment the
## next line and run the function:

## list.files()

## You should see, (perhaps among other things), a listing of the
## scripts we've used in class so far, including "intro_r.R".

## If you are not in the correct working directory, you can navigate
## to it using the bottom right panel in RStudio. Once there, click
## the gear with "More" and select "Set as Working Directory"

## Remember: file.path() is just a smart function that builds a path
## for you based on what your operating system requires. Separate each
## level, which is surrounded by quotes, with a comma. Remember that a
## single dot is a relative path symbol meaning "start HERE in this
## directory"

## (4)
dat_dir <- file.path("..", "data")
fig_dir <- file.path("..", "figures")
tab_dir <- file.path("..", "tables")

## ---------------------------
## settings/macros
## ---------------------------

## The original score ratio was 1.1 (10% higher); let's change it 1.2
## (15% higher)

## (5)
old_to_new_score_ratio <- 1.15

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
df <- readRDS(file.path(dat_dir, "test_scores.RDS"))

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

## (8, version 1 using base R) -------------------
df$test_scores_new_2 <- old_to_new_score(df$test_score, old_to_new_score_ratio)

## (8, version 2, using tidyverse) ---------------

## we didn't learn this way, but previewing the next lesson, we could
## also use the tidyverse language to add a new column; we'll use a
## different name so we can compare later
df <- df %>%
  mutate(test_scores_new_3 = old_to_new_score(test_score, old_to_new_score_ratio))

## for comparison, test_scores_new_2 and test_scores_new_3 should be the same
df

## we can test more formally using the identical() function
identical(df$test_scores_new_2, df$test_scores_new_3)

## ---------------------------
## output
## ---------------------------

## NB: this won't push to your GitHub repo b/c of the settings .gitignore,
## but it will be on your local computer.
saveRDS(df, file.path(dat_dir, "test_scores_final.RDS"))

## -----------------------------------------------------------------------------
## END SCRIPT
## -----------------------------------------------------------------------------
