# Simulate data for project "Investigating Data Irregularities in Survey Experiments"

library(tidyverse)

set.seed(123)

# 1. SIMULATE CCAP DATA ----------------------------------

n_ccap <- 44000

ccap_simulated <- tibble(
  feel = rnorm(n_ccap, mean = 58, sd = 28)
) |>
  mutate(
    feel = pmin(pmax(round(feel), 0), 100)  # bound 0–100
  )

write.csv(ccap_simulated, "ccap_simulated.csv", row.names = FALSE)


# 2. SIMULATE PANEL DATA ---------------------------------

n_panel <- 2441

# Treatment groups
treatments <- c(
  "No Contact",
  "Same-Sex Marriage Script by Gay Canvasser",
  "Same-Sex Marriage Script by Straight Canvasser",
  "Recycling Script by Gay Canvasser",
  "Recycling Script by Straight Canvasser"
)

panel_simulated <- tibble(
  treatment = sample(treatments, n_panel, replace = TRUE)
)

# Baseline drawn from CCAP-like distribution
panel_simulated <- panel_simulated |>
  mutate(
    feel1 = sample(ccap_simulated$feel, n_panel, replace = TRUE)
  )

# Generate follow-up waves with small noise (high stability)
panel_simulated <- panel_simulated |>
  mutate(
    feel2 = feel1 + rnorm(n_panel, 0, 5),
    feel3 = feel1 + rnorm(n_panel, 0, 6),
    feel4 = feel1 + rnorm(n_panel, 0, 7)
  )

# Clamp values to 0–100
panel_simulated <- panel_simulated |>
  mutate(
    across(starts_with("feel"),
           ~ pmin(pmax(round(.), 0), 100))
  )

# Introduce some missingness (to simulate real data)
panel_simulated <- panel_simulated |>
  mutate(
    feel3 = ifelse(runif(n_panel) < 0.06, NA, feel3),
    feel4 = ifelse(runif(n_panel) < 0.05, NA, feel4)
  )

write.csv(panel_simulated, "panel_simulated.csv", row.names = FALSE)
