library(dplyr)
library(tidyr)
library(readxl)



## CONSTANTS ----
meas_names <- c("transect", "data_id", "card_nb", "intercept_distance_cm","species_code",
  "growth_form1","growth_form23","colony_color","stomodael_color", "M_laevis", "species_name")

coral_path <- "/Users/brun/Data/coral-rescue"
coral_filename <- "QC_Transect-Data-Mannularis_Dancing-Lady-Reef_1972.xlsx"
coral_file <- file.path(coral_path,coral_filename)


## MAIN ----

## Measurement table ##

# Read the data
coral_xls <- read_xlsx(coral_file, 
                      sheet = "Data")


# Drop the extra columns with summary stats
coral_xls <- coral_xls %>% select(-starts_with("X__"))


# Extract measurement 1
meas1 <- select(coral_xls, c(1:10,21)) 
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
meas2 <- select(coral_xls, c(1:3, 12:18,22))
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
# sort by transect
coral_measurement <- coral_measurement %>%
  # sort data
  arrange(transect, data_id, card_nb, measurement_number)


## Species table ##
# read
species_codes <- read_xlsx(coral_file, 
                      sheet = "Species_Codes") %>%
  select(1:2) %>%
  na.omit() 
names(species_codes) <- c("key", "species_names")
  
# Join to measurement table
coral_measurement <- coral_measurement %>%
  # left_join(species_codes, by = c("species_code" = "key")) %>%
  # rearrange columns
  select(transect,data_id,card_nb,measurement_number,intercept_distance_cm,species_code,species_name,
         growth_form1,growth_form_2,growth_form_3,
         colony_color,stomodael_color,M_laevis)
  
  
## Transects table ##
transect_info <- read_xlsx(coral_file, 
                            sheet = "Transects") %>%
    na.omit() 

## Growth table ##
growth_info <- read_xlsx(coral_file, 
                          sheet = "tidy_growth_form") 

## Color table ##
color_info <- read_xlsx(coral_file, 
                        sheet = "tidy_color_codes") 



## Write files
write_csv(coral_measurement, "~/Data/coral-rescue/V_Transect-Data-Mannularis_Dancing-Lady-Reef_1972_measurements.csv")
write_csv(species_codes, "~/Data/coral-rescue/V_Transect-Data-Mannularis_Dancing-Lady-Reef_1972_species_codes.csv")
write_csv(species_codes, "~/Data/coral-rescue/V_Transect-Data-Mannularis_Dancing-Lady-Reef_1972_transects_info.csv")
write_csv(species_codes, "~/Data/coral-rescue/V_Transect-Data-Mannularis_Dancing-Lady-Reef_1972_growth-form_codes.csv")
write_csv(species_codes, "~/Data/coral-rescue/V_Transect-Data-Mannularis_Dancing-Lady-Reef_1972_color_codes.csv")

