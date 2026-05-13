# Predicting Course Grades Using Midterm Scores

# 1. SETUP ------------------------------------------------

# Load libraries
library(tidyverse)

# Load data 

# Uncomment if using simulated data 
# grades <- read.csv("grades_simulated.csv")

# Otherwise:
grades <- read.csv("grades.csv") # This dataset is not included in repo due to restrictions

# 2. DATA OVERVIEW ---------------------------------------

head(grades)
dim(grades)
str(grades)


# 3. VARIABLE DEFINITION -----------------------------------

# Predictor (X): midterm score
# Outcomes (Y):
# - final (continuous)
# - overall (continuous)
# - gradeA (binary)


# 4. DESCRIPTIVE ANALYSIS -------------------------------

# Correlations
cor(grades$midterm, grades$final)
cor(grades$midterm, grades$overall)
cor(grades$midterm, grades$gradeA)

# Summary stats
summary(grades)


# 5. MODEL: Predicting Final Exam Scores ----------------------------------------

fit_final <- lm(final ~ midterm, data = grades)
summary(fit_final)

# Predictions
pred_final_80 <- coef(fit_final)[1] + coef(fit_final)[2] * 80
pred_final_90 <- coef(fit_final)[1] + coef(fit_final)[2] * 90
change_final_10 <- coef(fit_final)[2] * 10

summary(fit_final)$r.squared


# 6. MODEL: Predicting Overall Scores --------------------------------------

fit_overall <- lm(overall ~ midterm, data = grades)
summary(fit_overall)

# Predictions
pred_overall_80 <- coef(fit_overall)[1] + coef(fit_overall)[2] * 80
pred_overall_90 <- coef(fit_overall)[1] + coef(fit_overall)[2] * 90
change_overall_10 <- coef(fit_overall)[2] * 10

summary(fit_overall)$r.squared


# 7. MODEL: Binary Outcome ------------------------------

fit_gradeA <- lm(gradeA ~ midterm, data = grades)
summary(fit_gradeA)

# Predictions
pred_gradeA_80 <- coef(fit_gradeA)[1] + coef(fit_gradeA)[2] * 80
pred_gradeA_90 <- coef(fit_gradeA)[1] + coef(fit_gradeA)[2] * 90
change_gradeA_10 <- coef(fit_gradeA)[2] * 10

summary(fit_gradeA)$r.squared


# 8. VISUALIZATION ---------------------------------------

# Load shared color palette
source("../00_utils/theme.R")

# Create figures folder if it doesn't exist
if (!dir.exists("figures")) dir.create("figures")

# Plot 1 for Predicting Final Exam Scores Model
p1 <- ggplot(grades, aes(x = midterm, y = final)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE,
              color = okabe_ito["orange"]) +
  theme_classic() +
  labs(
    title = "Final Exam Score vs Midterm Score",
    x = "Midterm Score",
    y = "Final Score"
  )

ggsave("figures/final_vs_midterm.png", p1, width = 6, height = 4)

# Plot 2 for Predicting Overall Scores Model
p2 <- ggplot(grades, aes(x = midterm, y = overall)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE,
              color = okabe_ito["blue"]) +
  theme_classic() +
  labs(
    title = "Overall Score vs Midterm Score",
    x = "Midterm Score",
    y = "Overall Score"
  )

ggsave("figures/overall_vs_midterm.png", p2, width = 6, height = 4)

# Plot 3 for Binary Outcome Model
p3 <- ggplot(grades, aes(x = midterm, y = gradeA)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE,
              color = okabe_ito["red"]) +
  theme_classic() +
  labs(
    title = "Probability of A/A- vs Midterm Score",
    x = "Midterm Score",
    y = "Probability of A/A-"
  )

ggsave("figures/gradeA_vs_midterm.png", p3, width = 6, height = 4)

# 9. EXTENSIONS ------------------------------

# Correlation matrix style checks
cor(grades$midterm, grades$final)
cor(grades$midterm, grades$overall)
cor(grades$midterm, grades$gradeA)

# Fit comparison
list(
  final = fit_final,
  overall = fit_overall,
  gradeA = fit_gradeA
)
