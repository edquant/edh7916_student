################################################################################
##
## <PROJ> EDH7916: Data Wrangling III: Working with strings and dates
## <FILE> assignment_5_example.R
## <INIT> 17 February 2020
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

library(tidyverse)
library(lubridate)

## ---------------------------
## directory paths
## ---------------------------

## assume we're running this script from the ./scripts subdirectory
dat_dir <- file.path("..", "data")

## -----------------------------------------------------------------------------
## Answer assignment 5 questions
## -----------------------------------------------------------------------------

## ---------------------------
## input
## ---------------------------

## read in data and join
df <- read_csv(file.path(dat_dir, "hd2007.csv")) %>%
    ## lower names
    rename_all(tolower) %>%
    ## join with mission statment data (note how you join to a data
    ## frame you read in)
    left_join(read_csv(file.path(dat_dir, "ic2007mission.csv")),
              by = "unitid")

## ---------------------------
## process
## ---------------------------

## ------------
## (1)
## ------------

dr_names <- df %>%
    ## get distinct names so we don't double/triple count
    distinct(chfnm) %>%
    ## filter on lowered column strings
    filter(str_detect(str_to_lower(chfnm), "^dr\\.?[^ew]")) %>%
    ## pull out values
    pull(chfnm)

## see
dr_names

## count
length(dr_names)

## NOTE ON PATTERN: "^dr\\.?[^ew]"
##
## ^     := at the start of the string
## \\.   := a period is a special character that means "anything" in regex,
##          so use \\ to escape and mean "a period"
## ?     := you may see what comes before (the period) 0 or more times
## [^ew] := NOT any of the letters in the []
##
## This pattern should only match versions of "Dr" at the beginning of
## the string only. Versions should include
##
## - DR
## - dr
## - Dr
## - DR.
## - dr.
## - Dr.
##
## The [^ew] part comes from seeing that "^dr\\.?" picks up a few "Drew"s

## ------------
## (2)
## ------------

phd_names <- df %>%
    ## get distinct names so we don't double/triple count
    distinct(chfnm) %>%
    ## filter on lowered column strings
    filter(str_detect(str_to_lower(chfnm), "^.+ph\\.? ?d\\.? ?$")) %>%
    ## pull out values
    pull(chfnm)

## see
phd_names

## count
length(phd_names)

## NOTE ON PATTERN: "^.+ph\\.? ?d\\.? ?$"
##
## ^       := at the start of the string
## \\.     := a period is a special character that means "anything" in regex,
##            so use \\ to escape and mean "a period"
## ?       := you may see what comes before (the period) 0 or more times
## <space> := a space
## $       := at the end of the string
##
## This pattern should only match versions of "PhD" at the end of the
## string only. Versions should include
##
## - PhD
## - PHD
## - Phd
## - phd
## - Ph D
## - PH D
## - Ph d
## - ph d
## - same as above, but with periods after "H/h" and/or "D/d"

## ------------
## (3)
## ------------

## (1)
df %>%
    ## keep only schools that give mission statement
    filter(!is.na(mission)) %>%
    ## keep only those in which we find the school name in the mission statement
    filter(str_detect(str_to_lower(mission), str_to_lower(instnm))) %>%
    ## get row number
    nrow

## (2)
df %>%
    ## keep only schools that give mission statement
    filter(!is.na(mission)) %>%
    ## keep only those in which we find the school name in the mission statement
    filter(str_detect(str_to_lower(mission), "civic")) %>%
    ## get row number
    nrow

## (3)
df %>%
    ## keep only schools that give mission statement
    filter(!is.na(mission)) %>%
    ## keep only those in which we find the school name in the mission statement
    filter(str_detect(str_to_lower(mission), "future")) %>%
    ## get counts
    count(stabbr) %>%
    ## arrange in descending order so we can see top 3
    arrange(desc(n))

## (4)
df %>%
    ## keep only schools that give mission statement
    filter(!is.na(mission)) %>%
    ## keep only those in which we find the school name in the mission statement
    filter(str_detect(str_to_lower(mission), "skill")) %>%
    ## get counts
    count(control) %>%
    ## arrange in descending order so we can see top 3
    arrange(desc(n))

## ------------
## (4)
## ------------

## (1)
df %>%
    ## filter to those with non-missing close dat
    filter(closedat != -2) %>%
    ## convert closdat to month/year --- add fake day so it will work
    mutate(date_close = str_replace(closedat, "-", "-01-"),
           date_close = mdy(date_close)) %>%
    ## drop those that didn't convert (year only)
    filter(!is.na(date_close)) %>%
    ## get days/months since close date --- use time_length() to convert to mos
    mutate(days_from_close = mdy("02-01-2020") - date_close,
           months_from_close = time_length(days_from_close, unit = "months")) %>%
    ## arrange by date
    arrange(date_close) %>%
    ## select only a few so we can see answer
    select(instnm, date_close, days_from_close, months_from_close)


## (2)
df %>%
    ## filter to those with non-missing close dat
    filter(closedat != -2) %>%
    ## convert closdat to month/year --- add fake day so it will work
    mutate(date_close = str_replace(closedat, "-", "-01-"),
           date_close = mdy(date_close)) %>%
    ## drop those that didn't convert (year only)
    filter(!is.na(date_close)) %>%
    ## get days/months since close date
    mutate(first_close = min(date_close),
           last_close = max(date_close),
           diff_close = last_close - first_close) %>%
    ## filter to keep applicable names (just so we can see better)
    filter(first_close == date_close | last_close == date_close) %>%
    ## select key vars
    select(instnm, contains("_close"))

## -----------------------------------------------------------------------------
## END SCRIPT
################################################################################
