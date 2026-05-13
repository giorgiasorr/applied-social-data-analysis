# Leader Death and Democracy

# 1. SETUP ------------------------------------------------

# Load libraries
library(tidyverse)

# Load data

# Uncomment if using simulated data 
# leaders <- read.csv("leaders_simulated.csv")

# Otherwise:
leaders <- read.csv("leaders.csv") # This dataset is not included in repo due to restrictions

# Load shared color palette
source("../00_utils/theme.R")

# Create figures folder if it doesn't exist
if (!dir.exists("figures")) dir.create("figures")

# 2. DATA OVERVIEW ---------------------------------------

head(leaders)
str(leaders)
dim(leaders)

# Number of assassination attempts
nrow(leaders)

# Frequency of leader death
table(leaders$died)

# Success rate
mean(leaders$died, na.rm = TRUE)

# 3. DESCRIPTIVE ANALYSIS --------------------------------

# Split data
leaders_dead     <- leaders |> filter(died == 1)
leaders_survived <- leaders |> filter(died == 0)

# Histograms: politybefore by outcome

p_dead <- ggplot(leaders_dead, aes(x = politybefore)) +
  geom_histogram(aes(y = after_stat(density)),
                 bins = 10,
                 fill = okabe_ito["orange"],
                 alpha = 0.6) +
  theme_classic() +
  labs(title = "Polity Before (Leader Died)",
       x = "Polity Score",
       y = "Density")

print(p_dead)
ggsave("figures/politybefore_dead.png", p_dead, width = 6, height = 4)


p_survived <- ggplot(leaders_survived, aes(x = politybefore)) +
  geom_histogram(aes(y = after_stat(density)),
                 bins = 10,
                 fill = okabe_ito["blue"],
                 alpha = 0.6) +
  theme_classic() +
  labs(title = "Polity Before (Leader Survived)",
       x = "Polity Score",
       y = "Density")

print(p_survived)
ggsave("figures/politybefore_survived.png", p_survived, width = 6, height = 4)


# Mean comparison
mean(leaders_dead$politybefore, na.rm = TRUE)
mean(leaders_survived$politybefore, na.rm = TRUE)

# 4. RELATIONSHIP: BEFORE vs AFTER ------------------------

p_scatter <- ggplot(leaders, aes(x = politybefore, y = polityafter)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE, color = okabe_ito["orange"]) +
  theme_classic() +
  labs(title = "Polity Before vs After",
       x = "Polity Before",
       y = "Polity After")

ggsave("figures/polity_scatter.png", p_scatter, width = 6, height = 4)

# Correlation
cor(leaders$politybefore, leaders$polityafter, use = "complete.obs")

# 5. CAUSAL ESTIMATION -----------------------------------

# Difference-in-means
ate_naive <- mean(leaders$polityafter[leaders$died == 1], na.rm = TRUE) -
  mean(leaders$polityafter[leaders$died == 0], na.rm = TRUE)

ate_naive

# Linear model
model_simple <- lm(polityafter ~ died, data = leaders)
summary(model_simple)

# 6. CONTROLLING FOR CONFOUNDER --------------------------

model_control <- lm(polityafter ~ died + politybefore, data = leaders)
summary(model_control)

# 7. KEY RESULTS SUMMARY ---------------------------------

results <- list(
  success_rate = mean(leaders$died, na.rm = TRUE),
  ate_naive = ate_naive,
  ate_controlled = coef(model_control)["died"],
  correlation = cor(leaders$politybefore, leaders$polityafter, use = "complete.obs")
)

results
