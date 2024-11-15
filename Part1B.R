# Set up parameters
num_simulations <- 5000         # Number of Monte Carlo simulations
delta_ts <- c(0.01, 0.001, 0.0001) # Values for delta t
Tmax_results <- list()           # Store Tmax for each delta t

# Function to simulate one path and find Tmax
simulate_path <- function(delta_t) {
  times <- seq(0, 1, by = delta_t)        # Generate time steps
  X <- numeric(length(times))             # Temperature values for each time step
  X[1] <- 0                               # Start with X(0) = 0
  
  # Generate the temperature process
  for (i in 2:length(times)) {
    X[i] <- X[i - 1] + rnorm(1, mean = 0, sd = sqrt(delta_t)) # Normal increment
  }
  
  # Find Tmax (time when temperature is maximum)
  Tmax <- times[which.max(X)]   # Time at which X(t) is max
  return(Tmax)
}

# Run the simulation for each delta t
for (delta_t in delta_ts) {
  Tmax_vals <- replicate(num_simulations, simulate_path(delta_t))
  Tmax_results[[as.character(delta_t)]] <- Tmax_vals
}

# Plot histograms for each delta t value  
par(mfrow = c(1, length(delta_ts)))  # Arrange plots side by side
for (delta_t in delta_ts) {
  hist(Tmax_results[[as.character(delta_t)]], breaks = 20, 
       main = paste("Histogram of Tmax for ∆t =", delta_t), 
       xlab = "Tmax", col = "skyblue", probability = TRUE)
  lines(density(Tmax_results[[as.character(delta_t)]]), col = "blue", lwd = 2)
}
