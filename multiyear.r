library(ggplot2)
library(dplyr)
library(tidyr)

options(scipen=999)

data<-read.csv("USDA_PDP_AnalyticalResults.csv")

data <- data[, c("Sample.ID", "Pesticide.Name", "Concentration", "pp_")]
colnames(data) <- c("StateCode", "Pesticide", "Concentration", "Unit")


data <- data %>%
  filter(Pesticide %in% c("Thiamethoxam", "Clothianidin", "Imidacloprid"))

data$StateCode <- substr(data$StateCode, 1, 4)


data <- data %>%
    separate(StateCode, into = c("State", "Year"), sep = "(?<=\\D)(?=\\d{2})", remove = TRUE)


data$Year <- as.numeric(data$Year)

data <- data %>%
  filter(Year >= 06)

data <- data %>%
  mutate(Concentration = ifelse(Unit == "T", Concentration / 1000, Concentration)) %>%
  mutate(Concentration = ifelse(Concentration > 1.0, 0.10, Concentration))

ggplot(data, aes(x = factor(Year), y = Concentration, fill = Pesticide)) +
  geom_boxplot(outlier.shape = NA) +
  labs(title = "Neonicotinoid Concentration by Year and Pesticide",
       x = "Year",
       y = "Concentration (ppm)",
       fill = "Pesticide") +
  ylim(0, 0.25) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
