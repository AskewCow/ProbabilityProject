# Probability Project 📊
The study applies probability theory to understand how variables, such as temperature, evolve unpredictably over time, using assumptions like initial conditions and specific statistical characteristics for incremental changes.

# Part 1A) ✅
This file uses Monte Carlo simulation to produce a graph for the proportion of temperatures above 0 for each time increment from [0, 1]. It can produce more than one graph based on the time increment and amount of times to run the simulation for a given time increment.

# Part 1b) ✅
This R script performs a Monte Carlo simulation to study the behaviour of a temperature process 𝑋(𝑡) that evolves randomly over the time interval [0,1].

# Part 2 ✅
## Model Description 📄
The model we have developed is a Monte Carlo simulation that predicts the final points for each Premier League team in the 2024-2025 season. The simulation is based on the idea that the outcome of each match (win, loss, or draw) is determined by the attacking and defensive strengths of the two competing teams, combined with randomness through a Poisson distribution to model the number of goals scored.

### Breakdown of the model:
Team Strength Calculation: We utilize each team's Attacking Strength and Defensive Strength as key parameters. These are derived from historical data and performance statistics of teams in the current season (e.g., goals scored and conceded). These strengths help estimate the expected number of goals each team will score in a match.

Poisson Distribution: The expected goals for both the home and away teams are calculated by multiplying the home team's attacking strength by the away team's defensive strength, and vice versa for the away team's attacking and the home team's defensive strength. These expected goals (xG and xGA) are used as the rate parameters in the Poisson distribution, which simulates the actual number of goals scored in a match.

Simulating Matches: For each match-up, the model runs multiple simulations (10,000 in this case) to generate a range of possible outcomes, capturing the inherent uncertainty and variability of football matches. For each simulation, the goals for both teams are drawn from a Poisson distribution, and the corresponding points (3 for a win, 1 for a draw, 0 for a loss) are assigned.

Aggregate Results: After all simulations, the average points across simulations are calculated for each team, representing their projected performance over the course of the season.

### Why We Chose This Model
We initially considered using historical data, including factors like the number of shots, expected goals (xG), and key passes, which could give us a detailed understanding of team performance. However, the decision to focus on attacking and defensive strength was driven by the following factors:

Simplicity and Robustness: The attacking and defensive strengths are derived from the team's performance statistics in the current season, which already provide a good representation of how teams have been performing so far. This approach captures the key aspects of team strength (attacking and defensive capabilities) while avoiding the complexity of handling too many variables.

Real-Time Performance: Using the current season's data allows the model to reflect how teams are performing in the present moment, making it more relevant for forecasting future matches.

Monte Carlo Simulation: This method is well-suited for capturing the inherent randomness in football outcomes, allowing us to run a large number of simulations and generate a distribution of possible outcomes. This gives a much more reliable forecast compared to deterministic models.

Flexibility: The model is flexible and can easily be adapted to include other factors, such as injuries, home advantage, or changes in form, by incorporating additional variables.

### Advantages of This Model 🟢
Incorporates Team Strengths: The model uses attacking and defensive strength, which are direct indicators of a team's capability and current form, allowing for more realistic simulations.

Handles Uncertainty: By using a Poisson distribution, the model acknowledges the randomness in football results, such as unexpected goals or defensive mistakes, providing more robust predictions that account for the inherent uncertainty of the sport.

Simple and Efficient: Compared to other more complex models, this approach is computationally efficient while still producing meaningful predictions. It avoids overfitting to historical data or relying on too many uncertain variables.

Scalable: The model is easily scalable for a larger dataset or adjusted to account for new factors, like player injuries or transfers.

Monte Carlo Simulations: By running a large number of simulations, we obtain a range of outcomes, which provides a more nuanced prediction than a single outcome-based model.

### Limitations of This Model ⛔
Simplified Assumptions: The model assumes that team strengths (attacking and defensive) remain constant throughout the season, ignoring factors like injuries, transfers, or tactical changes that could significantly affect performance.

No Consideration of Individual Player Performance: The model does not account for individual player performances, which could be crucial in determining the outcome of matches (e.g., a star player being unavailable or in exceptional form).

Poisson Distribution Assumption: The Poisson distribution assumes that goals are independent events, which may not always be the case in football, where momentum, team morale, and other factors can influence goal-scoring patterns.

No Home/ Away Context for Strengths: While we account for home and away factors in terms of team strengths, the model does not differentiate as explicitly between how home and away teams might behave (e.g., home teams may have a slight advantage in the form of crowd support or familiarity with the pitch).

Doesn't Account for Match Context: External factors like match importance (e.g., a relegation battle or title race) are not included in the model. These factors could lead to different performances than expected based purely on team strength.

Randomness vs. Predictability: While the model captures randomness, football is sometimes more predictable than the Poisson distribution assumes. Teams with vastly different strengths may have more predictable outcomes than the model indicates.

### Conclusion 📜
This model provides a straightforward yet effective method for simulating football match outcomes, forecasting team points, and ultimately predicting league standings. While it has limitations, particularly around dynamic team changes and external factors, it balances simplicity with the ability to capture the core elements of team performance and match uncertainty.