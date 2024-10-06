library(ggplot2)
library(dplyr)
library(tidyr)

options(scipen = 999)

data <- read.csv("MonarchsJourneyNorth.csv")

data$Year <- as.numeric(data$Year) + 2000

data <- data %>%
  filter(Year >= 2006)

data <- data %>%
  filter(Year <= 2022)

avg_sightings <- data %>%
  group_by(Year) %>%
  summarise(avg_sightings = mean(Sightings, na.rm = TRUE))

print(avg_sightings)

ggplot(avg_sightings, aes(x = Year, y = avg_sightings)) +
  geom_line(color = "black") +
  geom_point(color = "blue") +
  labs(title = "Average Number of Sightings per Year",
       x = "Year",
       y = "Average Sightings") +
  theme_minimal() +
  scale_x_continuous(breaks = seq(2000, 2022, by = 1)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
