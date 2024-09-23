# load datasets from project folder "datasets"

datasets <- c("maternalmortality.csv", "infantmortality.csv", "neonatalmortality.csv", "under5mortality.csv")
datasets <- lapply(here("datasets", datasets), read.csv)
names(datasets) <- c("Maternal Mortality", "Infant Mortality", "Neonatal Mortality", "Under 5 Mortality")

datasets

summary(datasets)
lapply(datasets, summary)

#function to subset data for only country name and years 2000-2019 and transpose data, create 4 new data sets 

sub_datasets <- lapply(datasets, select, Country.Name, X2000:X2019)
summary(sub_datasets)
lapply(sub_datasets, summary)

# transpose year and maternal mortality data using pivot_data and change name to Year and count to MatMort

pivot_datasets <- lapply(sub_datasets, pivot_longer, cols = starts_with("X"), names_to = "Year", names_prefix = "X", values_to = "Mortality Rate")

summary(pivot_datasets)
lapply(pivot_datasets, summary)

lapply(pivot_datasets, head)


#Combining datasets into one dataframe and reducing variables 
combo_df <- pivot_datasets %>% reduce(full_join, by=c('Country.Name', 'Year'))
colnames(combo_df) <- c("Country", "Year", "Maternal Mortality", "Infant Mortality", "Neonatal Mortality", "Under 5 Mortality")
combo_df

#Add country code and remove Country data

library(countrycode)
combo_df$ISO <- countrycode(combo_df$Country,
                            origin = "country.name",
                            destination = "iso3c")
combo_dfISO <- subset(combo_df, select = -Country)
combo_dfISO


