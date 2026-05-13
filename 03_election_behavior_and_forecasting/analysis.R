# Predicting Elections Using Betting Markets

# 1. SETUP --------------------------------------------------

library(ggplot2)

# Load data

# Uncomment if using simulated data 
# intrade <- read.csv("intrade_simulated.csv")  

# Otherwise:
intrade <- read.csv("intrade.csv")  ## This dataset is not included in repo due to restrictions

# 2. DATA INSPECTION ----------------------------------------

head(intrade)
dim(intrade)

# 3. VARIABLE CONSTRUCTION ----------------------------------

intrade$expected_margin <- intrade$D_expected - intrade$R_expected
intrade$real_margin <- intrade$D_real - intrade$R_real

# Unit: percentage points

# 4. DESCRIPTIVE ANALYSIS -----------------------------------

# Prediction error
intrade$error <- intrade$real_margin - intrade$expected_margin

# Correlation
cor(intrade$expected_margin, intrade$real_margin)

# MAE
mean(abs(intrade$error))  

# 5. MODEL --------------------------------------------------

fit <- lm(real_margin ~ expected_margin, data = intrade)
summary(fit)

# Extract coefficients
intercept <- coef(fit)[1]
slope <- coef(fit)[2]

# 6. PREDICTIONS --------------------------------------------

# Prediction for expected margin = 20
predicted_margin_20 <- intercept + slope * 20

# Marginal effect (increase of 10 points)
change_10 <- slope * 10

# R-squared
r_squared <- summary(fit)$r.squared

# 7. VISUALIZATIONS -----------------------------------------

# Load shared color palette
source("../00_utils/theme.R")

# Create figures folder if it doesn't exist
if (!dir.exists("figures")) dir.create("figures")

# Histogram of prediction error
p1 <- ggplot(intrade, aes(x = error)) +
  geom_histogram(
    bins = 20,
    fill = okabe_ito["blue"],
    color = "white"
  ) +
  theme_classic() +
  labs(
    title = "Prediction Error (Real - Expected Margin)",
    x = "Error (percentage points)",
    y = "Count"
  )

ggsave("figures/error_distribution.png", p1, width = 6, height = 4)


# Scatter plot with regression line
p2 <- ggplot(intrade, aes(x = expected_margin, y = real_margin)) +
  geom_point(
    alpha = 0.6,
    color = okabe_ito["blue"]
  ) +
  geom_smooth(
    method = "lm",
    se = FALSE,
    color = okabe_ito["orange"]
  ) +
  theme_classic() +
  labs(
    title = "Expected vs Real Democratic Margin",
    x = "Expected Margin (Betting Market)",
    y = "Real Margin"
  )

ggsave("figures/prediction_scatter.png", p2, width = 6, height = 4)
