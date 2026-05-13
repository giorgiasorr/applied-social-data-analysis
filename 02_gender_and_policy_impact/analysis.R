# Gender and Public Goods Provision in India


# 1. SETUP  --------------------------------------------

# Load libraries
library(ggplot2)

# Load data 

# Uncomment if using simulated data 
# india <- read.csv("india_simulated.csv")

# Otherwise:
india <- read.csv("india.csv") # This dataset is not included in repo due to restrictions

# Load shared color palette
source("../00_utils/theme.R")

# 2. DATA INSPECTION --------------------------------

head(india)
dim(india)
str(india)

# 2. SUMMARY STATISTICS --------------------------------

mean(india$female)
mean(india$water)
mean(india$irrigation)


# 3. CAUSAL ANALYSIS (DIFFERENCE-IN-MEANS) --------------


# Water
mean_water_female <- mean(india$water[india$female == 1])
mean_water_male   <- mean(india$water[india$female == 0])
ate_water <- mean_water_female - mean_water_male
ate_water

# Irrigation
mean_irrig_female <- mean(india$irrigation[india$female == 1])
mean_irrig_male   <- mean(india$irrigation[india$female == 0])
ate_irrig <- mean_irrig_female - mean_irrig_male
ate_irrig

# 4. GROUP MEANS  ----------------------------

tapply(india$water, india$female, mean)
tapply(india$irrigation, india$female, mean)

# 5. REGRESSION ANALYSIS ------------------

model_water <- lm(water ~ female, data = india)
summary(model_water)

model_irrigation <- lm(irrigation ~ female, data = india)
summary(model_irrigation)

# 6. CORRELATION ------------------------------------

cor(india$water, india$irrigation)

# 7. VISUALIZATIONS ------------------------------------

# Create figures folder if it doesn't exist
if (!dir.exists("figures")) dir.create("figures")

# Water distribution

p1 <- ggplot(india, aes(x = water)) +
  geom_histogram(
    bins = 30,
    fill = okabe_ito["blue"],
    color = "white"
  ) +
  theme_classic() +
  labs(
    title = "Distribution of Drinking Water Facilities",
    x = "Number of facilities",
    y = "Count"
  )

ggsave("figures/water_distribution.png", p1, width = 6, height = 4)

# Water vs irrigation

p2 <- ggplot(india, aes(x = water, y = irrigation)) +
  geom_point(
    alpha = 0.5,
    color = okabe_ito["blue"]
  ) +
  geom_smooth(
    method = "lm",
    se = FALSE,
    color = okabe_ito["orange"]
  ) +
  theme_classic() +
  labs(
    title = "Relationship between Water and Irrigation Facilities",
    x = "Water facilities",
    y = "Irrigation facilities"
  )

ggsave("figures/water_irrigation_scatter.png", p2, width = 6, height = 4)
