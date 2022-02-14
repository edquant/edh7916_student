################################################################################
##
## <PROJ> EDH7916: Data visualization with ggplot
## <FILE> assignment_5_example.R
## <INIT> 2 July 2020
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

library(tidyverse)
library(haven)

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
df <- read_dta(file.path(dat_dir, "hsls_small.dta"))

## ---------------------------
## process
## ---------------------------

## ------------
## (1)
## ------------

## Q: What is the distribution of household size among students in the sample?

## Because we're looking at the distribution of a (roughly) continuous
## variable on its own, we'll use a histogram. We'll drop the missing
## values using drop_na().

## minimal version
g <- ggplot(data = df %>% drop_na(x1hhnumber),
            mapping = aes(x = x1hhnumber)) +
    geom_histogram()
g

## better looking
## (1) add color to edges and fill
## (2) choose binwidth == 1 since we know we our "continuous" variable only
##     takes on discrete integers
## (3) set our x-scale to run from 2 to 11 since we know that's the range
## (4) better axis labels and title
g <- ggplot(data = df %>% drop_na(x1hhnumber),
            mapping = aes(x = x1hhnumber)) +
    geom_histogram(binwidth = 1,
            colour = "black",
            fill = "white") +
    scale_x_continuous(breaks = 2:11) +
    labs(title = "Distribution of student household sizes",
         subtitle = "(Variable: x1hhnumber)",
         caption = "Data from NCES HSLS09",
         x = "Household size",
         y = "Number of observations in sample")
g

## In the unweighted sample, most students report a household size of
## 3-5 persons.

## ------------
## (2)
## ------------

## Q: How does student socioeconomic status differ between students
## who ever attended college and those who did not?

## We want to compare a continuous distribution between two groups. We
## could use a boxplot, but we'll use a histogram again except this
## time split by group (so we end up with two distributions that we
## can compare).


## minimal
g <- ggplot(data = df %>% drop_na(x1ses, x4evratndclg),
            mapping = aes(x = x1ses, fill = as_factor(x4evratndclg))) +
    geom_histogram(stat = "density", position = "identity", alpha = 0.5)
g

## better looking
## (1) better axis labels and title
## (2) better legend title and labels
g <- ggplot(data = df %>% drop_na(x1ses, x4evratndclg),
            mapping = aes(x = x1ses, fill = as_factor(x4evratndclg))) +
    geom_histogram(stat = "density", position = "identity", alpha = 0.5) +
    scale_fill_discrete(name = "Ever attended college") +
    labs(title = "Socioeconomic status by college attendance",
         subtitle = "(Variables: x1ses, x4evratndclg)",
         caption = "Data from NCES HSLS09",
         x = "Student socioeconomic status (base year)",
         y = "Density")
g

## In the unweighted sample, students who ever attended college tend
## to have had a higher socioeconomic status in early high school than
## those who did not ever attend. However, there is a fair amount of
## overlap between the groups meaning that many students with a lower
## SES attended college while those with a higher comparative SES did
## not.

## ------------
## (3)
## ------------

## Q: How do parental educational expectations differ across region?

## --------------------------
## Version 1: using histogram
## --------------------------

## To answer this question, we'll first use a histogram with facets (one
## facet per region); we'll leave 11 "Don't know" as is so it remains
## on the figure.

## (barely) minimal
g <- ggplot(data = df %>%
                drop_na(x1paredexpct),
            mapping = aes(x = x1paredexpct)) +
    facet_wrap(~ x1region) +
    geom_histogram()
g


## better looking (and more useful)
## (1) better axis labels and title
## (2) better legend title and labels
## (3) choose binwidth == 1 since we know we our "continuous" variable only
##     takes on discrete integers
## (4) set our x-scale to run from 1 to 11 since we know that's the range
g <- ggplot(data = df %>%
                drop_na(x1paredexpct),
            mapping = aes(x = x1paredexpct)) +
    facet_wrap(~ as_factor(x1region)) +
    geom_histogram(aes(fill = as_factor(x1paredexpct)),
                   binwidth = 1,
                   colour = "black",
                   alpha = 0.5,
                   position = "identity") +
    scale_x_continuous(breaks = 1:11) +
    scale_fill_discrete(name = "Parental expectation") +
    labs(title = "Parental educational expectations for students by region",
         subtitle = "(Variables: x1paredexpct, x1region)",
         caption = "Data from NCES HSLS09",
         x = "Parental educational expectation",
         y = "Number of observations in sample")
g

## --------------------------
## Version 2: using boxplot
## --------------------------

## We can also use a boxplot to answer this question, though it will
## require that we adjust or remove 11 "Don't know" from the options
## so that it doesn't skew our distributions in a way that's difficult
## to parse with a box and whiskers plot

## minimal
g <- ggplot(data = df %>%
                filter(x1paredexpct != 11) %>%
                drop_na(x1paredexpct),
            mapping = aes(x = as.factor(x1region),
                          y = x1paredexpct,
                          fill = as_factor(x1region))) +
    geom_boxplot()
g

## better
## (1) better axis labels and title
## (2) better legend title and labels
## (3) set our y-scale to have breaks at 1 to 10 since we know those are the values
g <- ggplot(data = df %>%
                filter(x1paredexpct != 11) %>%
                drop_na(x1paredexpct),
            mapping = aes(x = as_factor(x1region),
                          y = x1paredexpct,
                          fill = as_factor(x1region))) +
    geom_boxplot() +
    scale_y_continuous(breaks = 1:10) +
    scale_fill_discrete(name = "Region") +
    labs(title = "Parental educational expectations for students by region",
         subtitle = "(Variables: x1paredexpct, x1region)",
         caption = "Data from NCES HSLS09",
         x = "Region",
         y = "Parental educational expectations")
g

## Across all regions in the unweighted sample, parents much more
## likely to expect a completed degree, whatever it may be, than a
## started degree. Across all regions, parental expectations tend to
## be a Bachelor's degree or higher, with parents in the Northeast and
## South being comparatively more likely to expect that their students
## will complete a professional degree than parents in other regions.

## ------------
## (4)
## ------------

## Q: How does the relationship between socioeconomic status and math
## test score differ across region (use a smoothing line to help show
## any relationship)?

## minimal
g <- ggplot(data = df %>% drop_na(x1ses, x1txmtscor),
            mapping = aes(x = x1ses,
                          y = x1txmtscor)) +
    facet_wrap(~ x1region) +
    geom_point() +
    geom_smooth(method = "loess")
g

## better looking
## (1) better axis labels and title
## (2) better legend title and labels
## (3) set point shape to 21 (circle with edge) so that we can set the
##     perimeter and fill separately
## (4) set point alpha to 0.2 to be more transparent since there are so many
g <- ggplot(data = df %>% drop_na(x1ses, x1txmtscor),
            mapping = aes(x = x1ses,
                          y = x1txmtscor)) +
    facet_wrap(~ as_factor(x1region)) +
    geom_point(alpha = 0.2,
               shape = 21,
               colour = "black",
               fill = "gray50") +
    geom_smooth(method = "loess") +
    labs(title = "Test scores by socioeconomic status within region",
         subtitle = "(Variables: x1txmtscor, x1ses, x1region)",
         caption = "Data from NCES HSLS09",
         x = "Student socioeconomic status (base year)",
         y = "Student math test score (base year)")
g

## In the unweighted data, we see a generally positive correlation
## between SES and math scores, which is highlighted by the LOESS
## line. This relationship appears generally homogenous across
## regions.

## ------------
## (5)
## ------------

## Q: Among students who ever attended college, how does socioeconomic
## status differ between those who delayed postsecondary enrollment
## and those who did not delay, when delay is defined as:
## - more than 6 months between high school graduation and
##   postsecondary enrollment?
## - more than 12 months?

## make plot data

## version 1: using nested ifelse() statements. Remember that ifelse()
## works with three arguments: ifelse(< test >, < if true, this >, <
## if false, this >). If you have a secondary condition such as "if
## TRUE, do this, but if FALSE, then check for ..." then a nested
## ifelse() can be used. There's no limit to the number that you can
## use, but it can become hard to parse, plus one can lose track of
## the closing parentheses.
plot_df <- df %>%
  drop_na(x1ses, x4hs2psmos) %>%
  filter(x4evratndclg == 1) %>%
  mutate(delay = ifelse(x4hs2psmos <= 6, # Test
                        "No delay",      # if T: this
                        ifelse(x4hs2psmos > 6 & x4hs2psmos <= 12, # if F: new ifelse()
                               "Delay: 7-12 months",              # if T: this
                               "Delay: > 1 year")))               # if F: that

## version 2: using case_when(), which is like ifelse(), but can handle more conditions.
##
## case_when(
##     <test 1> ~ <return X if TRUE>,
##     <test 2> ~ <return Y if TRUE>,
##     <test 3> ~ <return Z if TRUE>,
##     ...
##     )
plot_df <- df %>%
    drop_na(x1ses, x4hs2psmos) %>%
    filter(x4evratndclg == 1) %>%
    mutate(delay = case_when(
               x4hs2psmos <= 6 ~ "No delay",
               x4hs2psmos > 6 & x4hs2psmos <= 12 ~ "Delay: 7-12 months",
               x4hs2psmos > 12 ~ "Delay: > 1 year"))

## minimal
g <- ggplot(data = plot_df,
            mapping = aes(x = x1ses,
                          fill = delay)) +
    geom_histogram()
g

## better
## (1) better axis labels and title
## (2) better legend title
g <- ggplot(data = plot_df,
            mapping = aes(x = x1ses,
                          fill = delay)) +
    geom_histogram(stat = "density",
                   position = "identity",
                   alpha = 0.3) +
    scale_fill_discrete(name = "Delay status") +
    labs(title = "Socioeconomic status by delayed college attendance",
         subtitle = "(Variables: x1ses, x4evratndclg)",
         caption = "Data from NCES HSLS09",
         x = "Student socioeconomic status (base year)",
         y = "Density")
g

## In the unweighted sample, it appears that those who delayed college
## enrollment had lower average SES values in the base year than those
## who attended within 6 months of HS graduation. There is a great
## deal of overlap between these groups, however, which many
## non-delayers having relatively lower SES values than those who
## delayed by 6 months or greater than a year.

## -----------------------------------------------------------------------------
## END SCRIPT
################################################################################
