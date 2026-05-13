# Simulate Data: Leader Death and Democracy

set.seed(123)

# 1. PARAMETERS -------------------------------------------

n <- 250  # Number of observations

# 2. GENERATE BASE VARIABLES -------------------------------

# Polity before: roughly centered slightly below 0
politybefore <- round(rnorm(n, mean = -1.5, sd = 5))

# Keep within valid range [-10, 10]
politybefore <- pmax(pmin(politybefore, 10), -10)

# 3. TREATMENT (DEATH) ------------------------------------

# Probability of death depends slightly on politybefore (confounding)
# More democratic countries → slightly higher probability
prob_died <- plogis(-1.3 + 0.1 * politybefore)

died <- rbinom(n, size = 1, prob = prob_died)

# Approximate rate (should be ~0.20–0.25)
mean(died)

# 4. OUTCOME (POLITY AFTER) -------------------------------

# Strong persistence + small treatment effect + noise
polityafter <- 0.8 * politybefore +
  0.3 * died +
  rnorm(n, mean = 0, sd = 3)

# Keep within valid range
polityafter <- pmax(pmin(polityafter, 10), -10)

# 5. OTHER VARIABLES --------------------------------------

year <- sample(1875:2004, n, replace = TRUE)

country <- paste0("Country_", sample(1:60, n, replace = TRUE))
leadername <- paste0("Leader_", sample(1:200, n, replace = TRUE))

# 6. BUILD DATAFRAME --------------------------------------

leaders_sim <- data.frame(
  year = year,
  country = country,
  leadername = leadername,
  died = died,
  politybefore = politybefore,
  polityafter = polityafter
)

# 7. SAVE DATA --------------------------------------------

write.csv(leaders_sim, "leaders_simulated.csv", row.names = FALSE)

# 8. QUICK CHECKS -----------------------------------------

summary(leaders_sim)

# Correlation
cor(leaders_sim$politybefore, leaders_sim$polityafter)

# Treatment effect (naive)
mean(leaders_sim$polityafter[leaders_sim$died == 1]) -
  mean(leaders_sim$polityafter[leaders_sim$died == 0])

# Regression check
summary(lm(polityafter ~ died + politybefore, data = leaders_sim))
