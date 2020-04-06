################################################################################
##
## [ PROJ ] Test scores from 1980-1985
## [ FILE ] test_scores.R
## [ AUTH ] Benjamin Skinner
## [ DATE ] 30 March 2020
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

library(tidyverse)

## ---------------------------
## settings/macros
## ---------------------------

fig_width <- 7.5
fig_units <- "in"
fig_device <- "pdf"
fig_dpi  <- 300

## ---------------------------
## directory paths
## ---------------------------

## NB: notice how we start in this (".") directory
dat_dir <- file.path(".", "data")
fig_dir <- file.path(".", "figures")
tab_dir <- file.path(".", "tables")

## ---------------------------
## input
## ---------------------------

## check for data and download if not present

if (!file.exists(file.path(dat_dir, "all_schools.csv"))) {

    ## file name
    file_name <- "all_schools.csv"
    ## repo path
    repo_url <- "https://raw.githubusercontent.com/edquant/edh7916/master/data/sch_test"
    ## combine repo path + file name for full url
    url <- file.path(repo_url, file_name)
    ## download file to data directory
    download.file(url = url, destfile = file.path(dat_dir, file_name))

}

## read in data
df <- read_csv(file.path(dat_dir, "all_schools.csv"))

## -----------------------------------------------------------------------------
## TABLES
## -----------------------------------------------------------------------------

## ---------------------------
## make table of all scores
## ---------------------------

## no need since this will be the same as the input file

## ---------------------------
## make table of averages
## ---------------------------

df_tab <- df %>%
    ## group by school
    group_by(school) %>%
    ## get average across years; rounding for table output
    summarise(math_mean = mean(math) %>% round,
              read_mean = mean(read) %>% round,
              science_mean = mean(science) %>% round)

## write abbreviated table to table dir
write_csv(df_tab %>% select(school, ends_with("_mean")),
          path = file.path(tab_dir, "test_score_means_by_school.csv"))

## -----------------------------------------------------------------------------
## FIGURES
## -----------------------------------------------------------------------------

## ---------------------------
## fig: unadjusted
## ---------------------------

## reshape data long for figure
df_long <- df %>%
    pivot_longer(cols = c("math","read","science"), # cols to pivot long
                 names_to = "test",                 # where col names go
                 values_to = "score")               # where col values go

## facet line graph, with one column so they stack
p <- ggplot(data = df_long,
            mapping = aes(x = year, y = score, colour = school)) +
    facet_wrap(~ test, ncol = 1, scales = "free_y",
               ## assign test score names new values for facet titles
               labeller = labeller(test = c(math = "Math",
                                            read = "Reading",
                                            science = "Science"))) +
    geom_line() +
    labs(y = "Test score (normalized within test)",
         x = "Test year (spring)",
         ## assign legend title to match aes mapping: colour
         colour = "School",
         ## title since figure is separate
         title = "Test score trends")

## save figure
ggsave(filename = paste0("fig-unadjusted", ".", fig_device),
       plot = p,
       device = fig_device,
       path = fig_dir,
       width = fig_width,
       dpi = fig_dpi)

## ---------------------------
## fig: adjusted to first year
## ---------------------------

## standardize to first year for figure
df_long <- df_long %>%
    group_by(test, school) %>%
    arrange(year) %>%
    mutate(score_year_one = first(score),
           score_std_sch = (score - score_year_one) / sd(score)) %>%
    ungroup

## facet line graph
p <- ggplot(data = df_long,
            mapping = aes(x = year, y = score_std_sch, colour = test)) +
    facet_wrap(~ school) +
    scale_colour_discrete(breaks = c("math", "read", "science"),
                          labels = c("Math", "Reading", "Science")) +
    geom_line() +
    labs(y = "Test score (rescaled and centered at 1980)",
         x = "Test year (spring)",
         ## assign legend title to match aes mapping: colour
         colour = "Test",
         ## title since figure is separate
         title = "Test score trends",
         subtitle = "Rescaled and adjusted to 1980")

ggsave(filename = paste0("fig-adjusted", ".", fig_device),
       plot = p,
       device = fig_device,
       path = fig_dir,
       width = fig_width,
       dpi = fig_dpi)

## -----------------------------------------------------------------------------
## END SCRIPT
################################################################################
