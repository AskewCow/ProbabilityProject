# Dependencies:
# install.packages("readxl")
# install.packages("ggplot2")
# install.packages("knitr")
# install.packages("reshape2")

# while (dev.cur() > 1) dev.off() (resets all the plots)

# Load necessary libraries
library(readxl)
library(ggplot2)
library(knitr)
library(reshape2)

# Import the dataset
team_stats <- read_excel("team_stats.xls")

# Define the number of simulations
simulations <- 100

# Function to calculate points based on goals scored
calculate_points <- function(home_goals, away_goals) {
  if (home_goals > away_goals) {
    return(c(3, 0))  # Home team wins
  } else if (home_goals < away_goals) {
    return(c(0, 3))  # Away team wins
  } else {
    return(c(1, 1))  # Draw
  }
}

# Function to simulate a match between home and away teams
simulate_match <- function(home_team, away_team) {
  # Get the attacking and defensive strengths for both teams
  home_attack_strength <- team_stats$`Attacking Strength`[team_stats$Squad == home_team]
  away_defense_strength <- team_stats$`Defensive Strength`[team_stats$Squad == away_team]
  away_attack_strength <- team_stats$`Attacking Strength`[team_stats$Squad == away_team]
  home_defense_strength <- team_stats$`Defensive Strength`[team_stats$Squad == home_team]
  
  # Calculate expected goals for both teams
  home_xG <- home_attack_strength * away_defense_strength
  away_xG <- away_attack_strength * home_defense_strength
  
  # Simulate the number of goals using Poisson distribution
  home_goals <- rpois(1, home_xG)
  away_goals <- rpois(1, away_xG)
  
  # Calculate points for the match
  points <- calculate_points(home_goals, away_goals)
  
  return(points)
}

# Initialize an empty matrix to store the total points
team_points <- setNames(rep(0, nrow(team_stats)), team_stats$Squad)

# Run simulations for each pair of teams (home vs away)
for (i in 1:nrow(team_stats)) {
  for (j in 1:nrow(team_stats)) {
    if (i != j) {
      home_team <- team_stats$Squad[i]
      away_team <- team_stats$Squad[j]
      
      # Simulate the match for the specified number of simulations
      home_points_sim <- numeric(simulations)
      away_points_sim <- numeric(simulations)
      
      for (k in 1:simulations) {
        points <- simulate_match(home_team, away_team)
        home_points_sim[k] <- points[1]
        away_points_sim[k] <- points[2]
      }
      
      # Calculate average points for the home and away teams across simulations
      avg_home_points <- mean(home_points_sim)
      avg_away_points <- mean(away_points_sim)
      
      # Update the total points for both home and away teams
      team_points[home_team] <- team_points[home_team] + avg_home_points
      team_points[away_team] <- team_points[away_team] + avg_away_points
    }
  }
}

# Print the final points after all simulations
print(team_points)

# You can save the results to a file if desired
write.csv(team_points, "final_team_points.csv", row.names = TRUE)

message("Simulation Completed Successfully!")

# - - - - - - - - - - -


# Create a bar plot for final team points
ggplot(data.frame(Team = names(team_points), Points = team_points), aes(x = reorder(Team, -Points), y = Points)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  labs(title = "Predicted Final Points for Each Team", x = "Team", y = "Points") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Rotate x labels for better readability



# Create a density plot to visualize the distribution of points across all teams
simulated_points <- rep(team_points, each = simulations)  # Replicate points for each simulation

# Create a dataframe with the replicated points for plotting
points_data <- data.frame(Team = rep(names(team_points), each = simulations), Points = simulated_points)

# Create the density plot
ggplot(points_data, aes(x = Points)) +
  geom_density(fill = "lightblue", alpha = 0.7) +
  facet_wrap(~ Team) +
  theme_minimal() +
  labs(title = "Distribution of Simulated Points for Each Team", x = "Points", y = "Density")



# Convert the team_points into a data frame
team_points_df <- data.frame(Team = names(team_points), Points = team_points)

# Print the table
kable(team_points_df, caption = "Final Predicted Points for Each Team", format = "html")



# Create a matrix to store the average points for home and away teams
home_away_points <- matrix(0, nrow = nrow(team_stats), ncol = nrow(team_stats))
rownames(home_away_points) <- team_stats$Squad
colnames(home_away_points) <- team_stats$Squad

# Populate the matrix with average points
for (i in 1:nrow(team_stats)) {
  for (j in 1:nrow(team_stats)) {
    if (i != j) {
      home_team <- team_stats$Squad[i]
      away_team <- team_stats$Squad[j]
      
      # Simulate the match for the specified number of simulations
      home_points_sim <- numeric(simulations)
      away_points_sim <- numeric(simulations)
      
      for (k in 1:simulations) {
        points <- simulate_match(home_team, away_team)
        home_points_sim[k] <- points[1]
        away_points_sim[k] <- points[2]
      }
      
      # Calculate average points for home and away teams
      avg_home_points <- mean(home_points_sim)
      avg_away_points <- mean(away_points_sim)
      
      # Update the matrix
      home_away_points[home_team, away_team] <- avg_home_points
      home_away_points[away_team, home_team] <- avg_away_points
    }
  }
}

# Create a heatmap of the home vs away average points
# Reshape data for ggplot
home_away_points_melted <- melt(home_away_points)

# Annotated heatmap with average points displayed on tiles
ggplot(home_away_points_melted, aes(Var1, Var2, fill = value)) +
  geom_tile(color = "white") +
  geom_text(aes(label = round(value, 1)), color = "black", size = 3) +  # Add annotations
  scale_fill_gradient(low = "lightblue", high = "darkblue", name = "Avg Points") +
  labs(
    title = "Home vs Away Average Points",
    x = "Home Team",
    y = "Away Team"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),  # Angled for readability
    axis.text.y = element_text(hjust = 1),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )



# Convert the team_points vector into a dataframe for easy viewing
final_results <- data.frame(Team = names(team_points), PredictedPoints = team_points)

# You can view it or export to a CSV
write.csv(final_results, "final_results.csv", row.names = FALSE)

# Optional: print the table for review
print(final_results)
