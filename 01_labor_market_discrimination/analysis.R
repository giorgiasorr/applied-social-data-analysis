# Labor Market Discrimination: Criminal Record Audit Study


# 1. SETUP  --------------------------------------------------

# Load libraries
library(ggplot2)

# Load data 

# Uncomment if using simulated data 
# applications <- read.csv("simulated_applications.csv")

# Otherwise:
applications <- read.csv("applications.csv") # This dataset is not included in repo due to restrictions

# 2. DATA INSPECTION --------------------------------

# Structure of dataset
head(applications)
dim(applications)

# Variables:
# job_id: job identifier
# criminal: 1 = has criminal record, 0 = no record
# race: "white" or "black"
# call: 1 = callback received, 0 = no callback

# 3. DESCRIPTIVE ANALYSIS -------------------------------------

# Overall callback rate
mean(applications$call)

# Callback rate by criminal record
mean(applications$call[applications$criminal == 1])
mean(applications$call[applications$criminal == 0])

# Subset data by race
applications_white <- applications[applications$race == "white", ]
applications_black <- applications[applications$race == "black", ]

# 4. CAUSAL ANALYSIS (DIFFERENCE-IN-MEANS) -----------------------

# White applicants
mean_white_criminal <- mean(applications_white$call[applications_white$criminal == 1])
mean_white_noncriminal <- mean(applications_white$call[applications_white$criminal == 0])

ate_white <- mean_white_criminal - mean_white_noncriminal

# Black applicants
mean_black_criminal <- mean(applications_black$call[applications_black$criminal == 1])
mean_black_noncriminal <- mean(applications_black$call[applications_black$criminal == 0])

ate_black <- mean_black_criminal - mean_black_noncriminal

# 5. REGRESSION APPROACH ---------------------------------------

# White applicants
fit_white <- lm(call ~ criminal, data = applications_white)
summary(fit_white)

# Black applicants
fit_black <- lm(call ~ criminal, data = applications_black)
summary(fit_black)

# 6. INTERPRETATION --------------------------------------------

# The coefficient on 'criminal' represents the average treatment effect.
# Because treatment is randomly assigned, this estimate can be interpreted causally.

# 7. VISUALIZATIONS -------------------------------------

# Create figures folder if it doesn't exist
if (!dir.exists("figures")) {
  dir.create("figures")
}

# Callback rates of white applicants

# Summary data
white_summary <- data.frame(
  group = c("No Record", "Criminal Record"),
  rate = c(mean_white_noncriminal, mean_white_criminal)
)

# Plot
p_white <- ggplot(white_summary, aes(x = group, y = rate, fill = group)) +
  geom_col() +
  geom_text(aes(label = round(rate, 2)), vjust = -0.5) +
  scale_fill_manual(values = c("#0072B2", "#D55E00")) +
  expand_limits(y = 0) +
  labs(
    title = "Callback Rates (White Applicants)",
    x = "",
    y = "Probability of Callback"
  ) +
  theme_classic() +
  theme(legend.position = "none")


# Callback rates of black applicants

# Summary data
black_summary <- data.frame(
  group = c("No Record", "Criminal Record"),
  rate = c(mean_black_noncriminal, mean_black_criminal)
)

# Plot
p_black <- ggplot(black_summary, aes(x = group, y = rate, fill = group)) +
  geom_col() +
  geom_text(aes(label = round(rate, 2)), vjust = -0.5) +
  scale_fill_manual(values = c("#0072B2", "#D55E00")) +
  expand_limits(y = 0) +
  labs(
    title = "Callback Rates (Black Applicants)",
    x = "",
    y = "Probability of Callback"
  ) +
  theme_classic() +
  theme(legend.position = "none")

# Save plots
ggsave("figures/callback_white.png", plot = p_white, width = 6, height = 4)
ggsave("figures/callback_black.png", plot = p_black, width = 6, height = 4)
