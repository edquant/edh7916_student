################################################################################
##
## <PROJ> EDH7916: Functional programming
## <FILE> assignment_6_example.R
## <INIT> 18 February 2020
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
sch_dir <- file.path(dat_dir, "sch_test")
bys_dir <- file.path(sch_dir, "by_school")

## -----------------------------------------------------------------------------
## Answer assignment 6 questions
## -----------------------------------------------------------------------------

## ------------
## (1)
## ------------

## get files
files <- list.files(bys_dir, "bend_gate|niagara", full.names = TRUE)

## init list
df_list <- list()

## loop
for (i in 1:length(files)) {
    ## read in each file to list, adding column along the way
    df_list[[i]] <- read_csv(files[i]) %>%
        ## add column
        mutate(relative_path = files[i])
}

## bind together
df <- bind_rows(df_list)

## ------------
## (2)
## ------------

## get files
files <- list.files(bys_dir, "bend_gate|niagara", full.names = TRUE)

## using purrr::map()
df <- map(files,
          ~ read_csv(.x) %>%
              ## add column WITHIN map() function
              mutate(relative_path = .x)) %>%
    ## bind everything together AFTER map() function
    bind_rows

## ------------
## (3)
## ------------

## (1)

## set up fix_missing() function (from class)
fix_missing <- function(x, miss_val) {
    x <- ifelse(x %in% miss_val,
                NA,
                x)
    return(x)
}

## read in hsls data
df <- read_csv(file.path(dat_dir, "hsls_small.csv"))

## show missing
df %>%
    ## count x1ses unique values
    count(x1ses) %>%
    ## arrage descending
    arrange(desc(n))

## NOTE: We know that x1ses is continuous and standard normal, so most
## values should be close to 0, have multiple decimal places, and not
## be repeated that often. When we take the count and show the the
## value that occurs the most at the top, we see that -8 is the most
## often by far and breaks out other rules. We'll use this to compare
## our fix

## remove missing in x1ses using fix_missing()
df %>%
    mutate(x1ses = fix_missing(x1ses, -8)) %>%
    ## count x1ses unique values
    count(x1ses) %>%
    ## arrage descending
    arrange(desc(n))

## (2.1)

test_scr <- df %>%
   filter(row_number() <= 50) %>%
    pull(x1txmtscor)

## (2.2)

for (i in 1:length(test_scr)) {
    if (test_scr[i] == -8) {
        print(i)
    }
}

## (2.3)

for (i in 1:length(test_scr)) {
    if (test_scr[i] == -8) {
        print(i)
    } else {
        print(test_scr[i])
    }
}

## (2.4)

for (i in 1:length(test_scr)) {
    if (test_scr[i] == -8) {
        print("Flag: missing value")
    } else if (test_scr[i] < 40){
        print("Flag: low score")
    } else {
        print(test_scr[i])
    }
}


## (3)

## version 1: this one doesn't not account for missing values
return_higher <- function(value_1, value_2){
    ifelse(value_1 > value_2,           # is value_1 bigger than value_2?
           value_1,                     # YES: return value_1
           value_2)                     # NO: return value_2
}

df %>%
    ## remove missing using our fix_missing() function
    mutate(x1stuedexpct = fix_missing(x1stuedexpct, -8),
           x1paredexpct = fix_missing(x1paredexpct, -8)) %>%
    ## filter our missing since our function can't account for them
    filter(!is.na(x1stuedexpct), !is.na(x1paredexpct)) %>%
    ## use our function to get higher value
    mutate(high_expct = return_higher(x1stuedexpct, x1paredexpct)) %>%
    ## select key vars to show
    select(x1stuedexpct, x1paredexpct, high_expct)


## BONUS / MORE ADVANCED

## I don't expect that you will have done it this way (or know how),
## but I do want you to see a more sophisticated version.

## version 2: this one handles missing values and returns non-missing

return_higher <- function(value_1, value_2){
    ## case_when() is a more sophisticated way to do ifelse() statements
    ## without having to nest a bunch. It evaluates on the LHS of the ~
    ## and then, if TRUE, returns what's on the RHS of the ~
    ##
    ## Two notes:
    ##
    ## (1) It can't return just NA, but has to know which type of NA;
    ##     since the other values are numbers, I've given it NA_real_
    ## (2) The final TRUE just means "everything else"; I know the various
    ##     options well enough to know that if it isn't the first 4, then
    ##     it has to be the last value.
    case_when(
        (is.na(value_1) & is.na(value_2)) ~ NA_real_,
        (is.na(value_1) & !is.na(value_2)) ~ value_2,
        (!is.na(value_1) & is.na(value_2)) ~ value_1,
        (value_1 > value_2) ~ value_1,
        TRUE ~ value_2
    )
}

df %>%
    ## remove missing using our fix_missing() function
    mutate(x1stuedexpct = fix_missing(x1stuedexpct, -8),
           x1paredexpct = fix_missing(x1paredexpct, -8)) %>%
    ## use our function to get higher value
    mutate(high_expct = return_higher(x1stuedexpct, x1paredexpct)) %>%
    ## select key vars to show
    select(x1stuedexpct, x1paredexpct, high_expct) %>%
    ## show more than 10 so can see an NA
    head(20)

## -----------------------------------------------------------------------------
## END SCRIPT
################################################################################
