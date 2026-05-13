# Simulate ANES Turnout Data (1980–2004 style)

set.seed(123)

# Number of elections
n <- 13

# Create election years (every 2 years)
year <- seq(1980, by = 2, length.out = n)

# Presidential vs midterm
presidential <- ifelse(year %% 4 == 0, 1, 0)
midterm <- ifelse(presidential == 1, 0, 1)

# 1. Simulate population variables (smooth upward trend) ----------------------
VEP <- seq(160000, 200000, length.out = n) + rnorm(n, 0, 2000)
VAP <- VEP + rnorm(n, 5000, 1000)

felons <- seq(800, 3000, length.out = n) + rnorm(n, 0, 100)
noncitizens <- seq(6000, 15000, length.out = n) + rnorm(n, 0, 500)

# 2. TRUE turnout (VEP-based) -------------------------------

# Presidential elections have higher turnout
VEP_turnout <- ifelse(
  presidential == 1,
  rnorm(n, mean = 55, sd = 3),
  rnorm(n, mean = 40, sd = 3)
)

# Compute votes from turnout
votes <- (VEP_turnout / 100) * VEP

# 3. SELF-REPORTED turnout (ANES) -------------------------------

# Add systematic overreporting bias
turnout_bias <- ifelse(
  presidential == 1,
  rnorm(n, mean = 18, sd = 2),
  rnorm(n, mean = 15, sd = 2)
)

ANES_turnout <- VEP_turnout + turnout_bias

# 4. Combine dataset -------------------------------

anes_simulated <- data.frame(
  year,
  presidential,
  midterm,
  ANES_turnout,
  votes = round(votes),
  VEP = round(VEP),
  VAP = round(VAP),
  felons = round(felons),
  noncitizens = round(noncitizens)
)

# 5. Save dataset -------------------------------

write.csv(anes_simulated, "anes_simulated.csv", row.names = FALSE)
