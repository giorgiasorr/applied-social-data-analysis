# Simulated dataset for audit study (demonstration purposes)

set.seed(123)  # reproducibility

n <- 500

# Create race
race <- sample(c("white", "black"), n, replace = TRUE)

# Assign treatment (criminal record)
# Keep it balanced overall
criminal <- rbinom(n, 1, 0.5)

# Define baseline probabilities by race
base_prob <- ifelse(race == "white", 0.25, 0.15)

# Treatment effect
treatment_effect <- -0.10  # average penalty of criminal record

# Construct probability of callback
prob_call <- base_prob + treatment_effect * criminal

# Ensure probabilities stay in valid range [0,1]
prob_call <- pmin(pmax(prob_call, 0), 1)

# Generate outcome
call <- rbinom(n, 1, prob_call)

# Build dataset
simulated_applications <- data.frame(
  job_id = 1:n,
  race = race,
  criminal = criminal,
  call = call
)

# Save dataset
write.csv(simulated_applications, "simulated_applications.csv", row.names = FALSE)
