# Function to simulate the temperature process and calculate P
simulate_p <- function(t_increment, repeat_num) {
  amount_of_increments <- 1 / t_increment   # Number of increments from 0 to 1
  p_values <- numeric(repeat_num)  # To store proportion of
  # time with positive temperature

  # Monte Carlo simulation
  for (i in 1:repeat_num) {
    temperature <- numeric(amount_of_increments + 1)
    for (j in 2:(amount_of_increments + 1)) {
      temperature[j] <- temperature[j - 1] +
        rnorm(1, mean = 0, sd = sqrt(t_increment))
      # normal distribution with variance increment
    }
    # Calculate P for this number
    p_values[i] <- mean(temperature > 0)  # Proportion of time with X(t) > 0
  }

  return(p_values)
}

# Parameters (change these)
increments <- c(0.01, 0.001)  # Different t_increment values
repeat_num <- 10000 # Number of times to simulate

# Simulate for each t_increment and store results
results <- list()
for (t_increment in increments) {
  cat("Simulating for t_increment =", t_increment, "\n")
  p_values <- simulate_p(t_increment, repeat_num)
  results[[as.character(t_increment)]] <- p_values
}

# Plotting the results for each t_increment
par(mfrow = c(1, length(increments)))  # Set up a plot for each t_increment
for (t_increment in increments) {
  hist(results[[as.character(t_increment)]],
       breaks = (1 / t_increment), probability = TRUE,
       main = paste("Distribution of P (t_increment =", t_increment, ")"),
       xlab = "Proportion of time with positive temperature",
       ylab = "Frequency of Proportion P",
       col = "#1d0fdf", border = "#000000")
}

#Describing the p distribution

stats <- list()
for(i in increments){
  stat<- as.list(summary(results[[as.character(i)]]))
  stat$variance <- var(results[[as.character(i)]])
  stat$stdDev <- sd(results[[as.character(i)]])
  stats[[as.character(i)]] <-  stat
}
results_table <- as.data.frame(lapply(stats, unlist))


