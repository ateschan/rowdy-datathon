library(ggplot2)
library(dplyr)
library(tidyr)

options(scipen = 999)

data <- read.csv("USDA_PDP_AnalyticalResults.csv")

data <- data[, c("Sample.ID", "Pesticide.Name", "Concentration", "pp_")]
colnames(data) <- c("StateCode", "Pesticide", "Concentration", "Unit")

data <- data %>%
  filter(Pesticide %in% c("Thiamethoxam", "Clothianidin", "Imidacloprid"))

data$StateCode <- substr(data$StateCode, 1, 4)

data <- data %>%
  separate(StateCode, into = c("State", "Year"),
           sep = "(?<=\\D)(?=\\d{2})", remove = TRUE)

data$Year <- as.numeric(data$Year) + 2000

data <- data %>%
  filter(Year >= 2006)

data <- data %>%
  filter(Year <= 2022)

#States within the butterfly migraton path
migration_states <- c("ND", "SD", "MN", "WI", "IA", "MI", "IL", "IN", "OH",
  "NY", "PA", "MO", "KS", "NE", "CO", "OK", "AR", "TX", "CA"
)

data <- data %>%
  filter(State %in% migration_states)

data <- data %>%
  mutate(Concentration = ifelse(Unit == "T", Concentration / 1000,
                                Concentration)) %>%
  mutate(Concentration = ifelse(Concentration > 1.0, 0.10, Concentration))

avg_concentration <- data %>%
  group_by(Year) %>%
  summarize(Average_Concentration = mean(Concentration, na.rm = TRUE)) %>%
  ungroup()

ggplot(avg_concentration, aes(x = factor(Year), y = Average_Concentration,
                              group = 1)) +
  geom_line(color = "black") +
  geom_point(color = "red") +
  labs(title = "Average Concentration of Pesticides per Year",
       x = "Year",
       y = "Average Concentration") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
