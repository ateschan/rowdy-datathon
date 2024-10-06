library(ggplot2)
library(dplyr)
library(tidyr)

options(scipen=999)

data<-read.csv("MonarchsJourneyNorth.csv")


# Check the data before summarizing
print(data)

# Calculate the average number of sightings per year
avg_sightings <- data %>%
  group_by(Year) %>%
  summarise(avg_sightings = mean(NumSightings, na.rm = TRUE))

# Check the results of the average calculation
print(avg_sightings)

# Plot the average sightings per year
ggplot(avg_sightings, aes(x = Year, y = avg_sightings)) +
  geom_line() +
  geom_point() +
  labs(title = "Average Number of Sightings per Year",
       x = "Year",
       y = "Average Sightings") +
  theme_minimal() +
  scale_x_continuous(breaks = seq(2000, 2006, by = 1))  
