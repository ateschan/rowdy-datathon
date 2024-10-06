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
  separate(StateCode, into = c("State", "Year"), sep = "(?<=[A-Z])(?=[0-99])", remove = TRUE)

data <- data %>%
  filter(grepl("22", Year))

# data <- data %>%
#   filter(grepl("CA", State))

for (i in 1:nrow(data)) {
  if (data[i, 5] == "T") {
    data[i, 4] <- data[i, 4] * 1000
  }
}

#par(mfrow = c(ceiling(length(unique_states) / 2), 2))

# x = 0
# for (state in unique_states) {
#   x + 1
# }
print(data)
