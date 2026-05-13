# Simulated dataset for Predicting Course Grades Using Midterm Scores

set.seed(123)

# 1. SIMULATE SAMPLE SIZE --------------------------------

n <- 76

# 2. SIMULATE MIDTERM SCORES -----------------------------

midterm <- rnorm(n, mean = 80, sd = 12)
midterm <- pmin(pmax(midterm, 0), 100)  # keep within 0–100

# 3. SIMULATE FINAL SCORES -------------------------------
# based on real model: final = -6 + 0.97 * midterm + noise

final <- -6 + 0.97 * midterm + rnorm(n, mean = 0, sd = 14)
final <- pmin(pmax(final, 0), 100)

# 4. SIMULATE OVERALL SCORES -----------------------------
# based on real model: overall = 30 + 0.66 * midterm + noise

overall <- 30 + 0.6565 * midterm + rnorm(n, mean = 0, sd = 6)
overall <- pmin(pmax(overall, 0), 100)

# 5. SIMULATE GRADE A (BINARY OUTCOME) -------------------
# logistic-style probability based on midterm

prob_A <- plogis(-5 + 0.06 * midterm)
gradeA <- rbinom(n, size = 1, prob = prob_A)

# 6. BUILD DATA FRAME ------------------------------------

grades <- data.frame(
  midterm = midterm,
  final = final,
  overall = overall,
  gradeA = gradeA
)

# 7. SAVE -------------------------------------------------

write.csv(grades, "grades_simulated.csv", row.names = FALSE)

# 8. QUICK CHECK ------------------------------------------

head(grades)
summary(grades)
cor(grades$midterm, grades$final)
cor(grades$midterm, grades$overall)
cor(grades$midterm, grades$gradeA)
