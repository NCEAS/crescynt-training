library(dplyr)
library(tidyr)
library(readxl)



## CONSTANTS ----
meas_names <- c("transect", "data_id", "card_nb", "intercept_distance_cm","species_code",
  "growth_form1","growth_form23","colony_color","stomodael_color", "M_laevis")

coral_file <- "~/Data/coral-rescue/V_Transect-Data-Mannularis_Dancing-Lady-Reef_1972.xls"


## MAIN ----

# Read the data
coral_xls <- read_xls(coral_file, 
                      sheet = 1, 
                      skip = 21)


# Drop the columns with summary stats
coral_xls <- coral_xls %>% select(-(X__5:X__9), -starts_with("My work"))


# Extract measurement 1
meas1 <- select(coral_xls, 1:10) 
# Rename the columns
names(meas1) <- meas_names

# Add column for measuremnt and split growth form
meas1 <- meas1 %>%
  # split the columns that were misaligned by Excel
  mutate(growth_form_2 = growth_form23 %/% 10) %>%
  mutate(growth_form_3 = growth_form23 %% 10) %>%
  mutate(measurement_number = 1) %>%
  select(-growth_form23)


# Extract measurement 2
meas2 <- select(coral_xls, c(1:3, 12:18))
# Rename the columns
names(meas2) <- meas_names
# Add column for measuremnt and split growth form
meas2 <- meas2 %>%
  # split the columns that were misaligned by Excel
  mutate(growth_form_2 = growth_form23 %/% 10) %>%
  mutate(growth_form_3 = growth_form23 %% 10) %>%
  mutate(measurement_number = 2) %>%
  select(-growth_form23)


# Append the two dataframes
coral_measurement <- rbind(meas1, meas2)
  
names(coral_measurement)
# Some Cleaning
# sort by transect
coral_measurement <- coral_measurement %>%
  # sort data
  arrange(transect,data_id,card_nb,measurement_number) %>%
  # rearrange columns
  select(transect,data_id,card_nb,measurement_number,intercept_distance_cm,species_code,
         growth_form1,growth_form_2,growth_form_3,
         colony_color,stomodael_color,M_laevis)





  
  
