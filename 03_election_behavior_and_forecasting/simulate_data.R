# Simulated dataset for election prediction using betting markets

set.seed(123)  # reproducibility

n <- 51  # 50 states + DC

# State labels
states <- c(state.abb, "DC")

# 1. Generate expected margins (X) -----------------------------

# Approximate realistic betting market spread
expected_margin <- rnorm(n, mean = 0, sd = 40)

# 2. Generate real margins (Y) based on the estimated model: -------------
#    real_margin = 1.3 + 0.229 * expected_margin + noise

intercept <- 1.3
slope <- 0.229

noise_sd <- 11.6

real_margin <- intercept + slope * expected_margin +
  rnorm(n, mean = 0, sd = noise_sd)

# 3. Convert margins into vote shares  --------------------


D_expected <- (expected_margin + 100) / 2
R_expected <- 100 - D_expected

D_real <- (real_margin + 100) / 2
R_real <- 100 - D_real

# Keep values in [0,100]
D_expected <- pmin(pmax(D_expected, 0), 100)
D_real <- pmin(pmax(D_real, 0), 100)
R_expected <- 100 - D_expected
R_real <- 100 - D_real

# 4. Build dataset -------------------------------------------

intrade_simulated <- data.frame(
  state = states,
  D_expected = round(D_expected, 1),
  R_expected = round(R_expected, 1),
  D_real = round(D_real, 0),
  R_real = round(R_real, 0)
)

# 5. Save ---------------------------------------------------

write.csv(intrade_simulated, "intrade_simulated.csv", row.names = FALSE)
