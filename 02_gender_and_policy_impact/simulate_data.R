# Simulated dataset: Gender and Policy Experiment (India)

set.seed(123)

n <- 322

# Treatment: randomized assignment of female leader
female <- rbinom(n, 1, 0.335)

# Outcomes generated with treatment effect
water <- rpois(n, lambda = 15 + 8 * female)
irrigation <- rpois(n, lambda = 10 + 3 * female)

# Village IDs
village <- paste0("GP", sample(1:50, n, replace = TRUE),
                  "_village", sample(1:10, n, replace = TRUE))

# Create dataset
india_simulated <- data.frame(
  village = village,
  female = female,
  water = water,
  irrigation = irrigation
)

# Save
write.csv(india_simulated, "india_simulated.csv", row.names = FALSE)
