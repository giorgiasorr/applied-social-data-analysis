# Investigating Data Irregularities in Survey Experiments
# Replication-style analysis of LaCour & Green (2014)

# 1. SETUP ------------------------------------------------

# Load libraries
library(tidyverse)

# Load data

# Uncomment if using simulated data 
# panel <- read.csv("panel_simulated.csv")
# ccap <- read.csv("ccap_simulated.csv")

# Otherwise:
panel <- read.csv("attitude_panel_experiment.csv")
ccap  <- read.csv("CCAP.csv") # Original datasets are not included due to usage restrictions

# Load shared color palette
source("../00_utils/theme.R")

# Create figures folder if it doesn't exist
if (!dir.exists("figures")) dir.create("figures")

# 2. DATA OVERVIEW ---------------------------------------

head(panel)
str(panel)
dim(panel)

head(ccap)
str(ccap)
dim(ccap)

# 3. VARIABLE CREATION -----------------------------------

# Key variables:
# CCAP: feel
# Attitude panel experiment: feel1–feel4

# Control group subset
panel_control <- panel |>
  filter(treatment == "No Contact")

# 4. DESCRIPTIVE ANALYSIS -------------------------------

# Distributions: CCAP vs baseline (feel1)

p_hist_ccap <- ggplot(ccap, aes(x = feel)) +
  geom_histogram(aes(y = ..density..), bins = 10,
                 fill = okabe_ito["blue"], alpha = 0.6) +
  theme_classic() +
  labs(title = "CCAP Feelings Distribution", x = "Feelings", y = "Density")

ggsave("figures/hist_ccap.png", p_hist_ccap, width = 6, height = 4)


p_hist_panel <- ggplot(panel, aes(x = feel1)) +
  geom_histogram(aes(y = ..density..), bins = 10,
                 fill = okabe_ito["orange"], alpha = 0.6) +
  theme_classic() +
  labs(title = "Panel Baseline Feelings Distribution", x = "Feel1", y = "Density")

ggsave("figures/hist_panel.png", p_hist_panel, width = 6, height = 4)

# Summary statistics

mean(ccap$feel, na.rm = TRUE)
median(ccap$feel, na.rm = TRUE)
sd(ccap$feel, na.rm = TRUE)

mean(panel$feel1, na.rm = TRUE)
median(panel$feel1, na.rm = TRUE)
sd(panel$feel1, na.rm = TRUE)

# 5. BASELINE COMPARISON -------------------------------

# Comparison based on:
# - visual inspection (histograms)
# - summary statistics (mean, median, sd)

summary(ccap$feel)
summary(panel$feel1)

# 6. STABILITY OVER TIME (CONTROL GROUP ONLY) ----------

# Scatter plots: stability of attitudes over time

p1 <- ggplot(panel_control, aes(feel1, feel2)) +
  geom_point(alpha = 0.5) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  geom_smooth(method = "lm", se = FALSE, color = okabe_ito["red"]) +
  theme_classic() +
  labs(title = "Feel1 vs Feel2 (Control Group)")

ggsave("figures/stability_3weeks.png", p1, width = 6, height = 4)

p2 <- ggplot(panel_control, aes(feel1, feel3)) +
  geom_point(alpha = 0.5) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  geom_smooth(method = "lm", se = FALSE, color = okabe_ito["blue"]) +
  theme_classic() +
  labs(title = "Feel1 vs Feel3 (Control Group)")

ggsave("figures/stability_6weeks.png", p2, width = 6, height = 4)

p3 <- ggplot(panel_control, aes(feel1, feel4)) +
  geom_point(alpha = 0.5) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  geom_smooth(method = "lm", se = FALSE, color = okabe_ito["green"]) +
  theme_classic() +
  labs(title = "Feel1 vs Feel4 (Control Group)")

ggsave("figures/stability_9months.png", p3, width = 6, height = 4)

# 7. CORRELATIONS OVER TIME -----------------------------

cor(panel_control$feel1, panel_control$feel2, use = "complete.obs")
cor(panel_control$feel1, panel_control$feel3, use = "complete.obs")
cor(panel_control$feel1, panel_control$feel4, use = "complete.obs")

# 8. INTERPRETATION METRICS -----------------------------

# Stability summary
c(
  cor_3_weeks = cor(panel_control$feel1, panel_control$feel2, use = "complete.obs"),
  cor_6_weeks = cor(panel_control$feel1, panel_control$feel3, use = "complete.obs"),
  cor_9_months = cor(panel_control$feel1, panel_control$feel4, use = "complete.obs")
)

# Interpretation support

summary(panel_control$feel1)
summary(panel_control$feel2)
summary(panel_control$feel3)
summary(panel_control$feel4)
