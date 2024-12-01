# Dependencies:
# install.packages("readxl")
# install.packages("ggplot2")
# install.packages("knitr")
# install.packages("reshape2")

# while (dev.cur() > 1) dev.off() (resets all the plots)

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

simulate_league <- function(numSimuls) {
  # Initialize an empty matrix to store the total points
  team_points <- setNames(rep(0, nrow(team_stats)), team_stats$Squad)
  # Run simulations for each pair of teams (home vs away)
  for (i in 1:nrow(team_stats)) {
    for (j in 1:nrow(team_stats)) {
      if (i != j) {
        home_team <- team_stats$Squad[i]
        away_team <- team_stats$Squad[j]
        
        # Simulate the match for the specified number of simulations
        home_points_sim <- numeric(numSimuls)
        away_points_sim <- numeric(numSimuls)
        for (k in 1:numSimuls) {
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
  return (team_points)
}
#--------------------------------------------------------------------------------------

#Create a list containing all the team names
t_list <- list()
for(name in team_stats$Squad){
  t_list[[name]] <- numeric()
}
empty_list <- t_list

#Run simulation 30 times, where matches are simulated 100 times
for(i in 1:30){
  team_points <- simulate_league(100)
  for(name in team_stats$Squad)
  {
    t_list[[name]] <- c( t_list[[name]],team_points[name])
  }
}
result_1 <- data.frame( avg_points = sapply(t_list,mean), 
                        std_dev =  sapply(t_list,sd))

result_1$MOE <- 1.96*result_1$std_dev/sqrt(30)

result_1 <- result_1[order(result_1$avg_points, decreasing = TRUE), ]
message("Simulation Completed Successfully (100 Matches)!")


#Run simulation 30 times, where matches are simulated 50 times
t_list <- empty_list

for(i in 1:30){
  team_points <- simulate_league(50)
  for(name in team_stats$Squad)
  {
    t_list[[name]] <- c( t_list[[name]],team_points[name])
  }
}
result_2 <- data.frame( avg_points = sapply(t_list,mean), 
                        std_dev =  sapply(t_list,sd))
result_2$MOE <- 1.96*result_2$std_dev/sqrt(30)
result_2 <- result_2[order(result_1$avg_points, decreasing = TRUE), ]
message("Simulation Completed Successfully (50 Matches)!")
# - - - - - - - - - - -

