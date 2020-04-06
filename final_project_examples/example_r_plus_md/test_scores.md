# Test scores from 1980-1985
#### Benjamin Skinner | 30 March 2020

From 1980 to 1985, students at four schools took end of year exams in
three subjects --- math, reading, and science. While these tests did
not affect students' grades or promotion, they were meant to measure
what students had learned over the course of the school year. In each
year, only 9th grade students took the exam. This means that each year
of data represents a different cohort of 9th grade students. Because
test scores are standardized within subject area, student cohorts can
be compared across time. See the data file `all_schools.csv` in the `data`
directory for all test scores for this period.

The tests are scaled as follows (observed averages and standard
deviations are somewhat different due to natural variation):

- **Math** --- mean: 500; standard deviation: 10
- **Reading** --- mean: 300; standard deviation: 20
- **Science** --- mean: 800; standard deviation: 15

# Test score averages by school

Across the six years of data, Bend Gate had the highest average math
score (502); East Heights had the highest average reading score (308);
and Bend Gate had the highest average science score (801). However,
these six year averages cover a fair amount of variation within
schools across time. In the next sections, I'll investigate this
variation. See the table `test_score_means_by_school.csv` in the
`tables` directory for all values.

# Test score trends

Considering test score trends over time, shown in the
`fig-unadjusted.pdf` in the `figures` directory, I note three
important points:

1. First, test scores varied across schools in each testing year. This
is true of all tests.
2. Second, test score varied within schools across time. Again, this
   is true across tests.
3. Third, no single school consistently performed better or worse than
   other schools. Each school had up and down periods and when
   performing well on one test, often performed less well on another.
   
# Test score trends: adjusted to 1980

All tests were revamped for the year 1980 to account for a significant
curriculum change in the 1979-1980 school year. This is why data begin
in this year, even though the district tested 9th graders in math,
reading, and science from 1970. Because of these changes, it makes
sense to compare score trends from a starting point of 1980.

Two schools, Bend Gate and Niagara, show a general downward trend in
math scores over time (see figure `fig-adjusted.pdf` in the `figures`
directory). East Heights, after an initial drop in math scores from
1980 to 1981, however, steadily increased students' math scores over
time. East Heights also had generally strong science scores, though
with a dip after an initial increase. Niagara should also be noted for
its increasing science scores after an initial drop. Though there is a
large single year dip in math scores for Spottsville in 1984, I note
that the drop may be attributed to a school emergency that interrupted
testing on the day the math exam was given.

# Recommendations

Despite variation across years, there is evidence that each school
tended to peform better (or worse) in some subject areas than in
others. Furthermore, schools differed in their relative strengths (and
weaknesses). Though more formal analyses are warranted, these
descriptive analyses suggest that district students may benefit from
more cross-school interaction among teachers, particularly so that
successful subject-specific practices and lessons may be replicated
in classrooms across the district.
