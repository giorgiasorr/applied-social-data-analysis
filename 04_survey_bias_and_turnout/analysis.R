# Survey Bias and Voter Turnout (ANES 1980–2004)

# 1. SETUP ------------------------------------------------

library(tidyverse)

# Load data 

# Uncomment if using simulated data 
# anes <- read.csv("anes_simulated.csv")

# Otherwise:
anes <- read.csv("ANES.csv") # This dataset is not included in repo due to restrictions

# 2. DATA INSPECTION --------------------------------------

head(anes)
dim(anes)
str(anes)

# 3. CONSTRUCT TURNOUT MEASURES ---------------------------

# Official turnout (VEP-based)
anes$VEP_turnout <- (anes$votes / anes$VEP) * 100

# Alternative turnout (VAP-based)
anes$VAP_turnout <- (anes$votes / anes$VAP) * 100

# Self-reported bias (measurement error proxy)
anes$turnout_bias <- anes$ANES_turnout - anes$VEP_turnout

# Election type indicator for heterogeneity analysis (presidential vs midterm elections)
anes$election_type <- ifelse(anes$presidential == 1, "Presidential", "Midterm")

# 4. DESCRIPTIVE STATISTICS -------------------------------

mean(anes$ANES_turnout)
mean(anes$VEP_turnout)
mean(anes$VAP_turnout)


# 5. VISUALIZATION ----------------------------------------

# Create figures folder if it doesn't exist
if (!dir.exists("figures")) dir.create("figures")

# Load shared color palette
source("../00_utils/theme.R")

# Distribution of reporting bias in self-reported turnout (measurement error visualization)
p1 <- ggplot(anes, aes(x = turnout_bias)) +
  geom_histogram(
    bins = 20,
    fill = okabe_ito["blue"],
    color = "white"
  ) +
  theme_classic() +
  geom_vline(xintercept = 0, linetype = "dashed") +
  labs(
    title = "Distribution of Turnout Reporting Bias",
    x = "Self-reported - Official turnout (percentage points)",
    y = "Count"
  )

ggsave(
  filename = "figures/turnout_bias_distribution.png",
  plot = p1,
  width = 6,
  height = 4
)

# Time trend of turnout reporting bias across U.S. federal elections (1980–2004)
p2 <- ggplot(anes, aes(x = year, y = turnout_bias)) +
  geom_line() +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = okabe_ito["orange"]) +
  theme_classic() +
  labs(
    title = "Turnout Reporting Bias Over Time",
    x = "Year",
    y = "Bias (percentage points)"
  )

ggsave(
  filename = "figures/bias_over_time.png",
  plot = p2,
  width = 6,
  height = 4
)

# 6. HETEROGENEITY: PRESIDENTIAL VS MIDTERM ---------------

presidential <- filter(anes, presidential == 1)
midterm <- filter(anes, midterm == 1)

# Presidential elections
mean(presidential$ANES_turnout)
mean(presidential$VEP_turnout)
mean(presidential$turnout_bias)

# Midterm elections
mean(midterm$ANES_turnout)
mean(midterm$VEP_turnout)
mean(midterm$turnout_bias)

# 7. EXTENSIONS (EXPLORATORY ANALYSIS) ---------------

# Correlation
bias_turnout_cor <- cor(anes$turnout_bias, anes$VEP_turnout)
bias_turnout_cor

# Trend regression
bias_trend <- lm(turnout_bias ~ year, data = anes)
summary(bias_trend)
