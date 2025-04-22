## Load required packages
#install.packages("xml2")
library(xml2)

## Read in the data
xml_file <- read_xml("/Users/jill/Downloads/census_xml_file_test.xml")

## Extract relevant xml nodes
# We want to extract all ROW nodes
rows <- xml_find_all(xml_file, "//ROW")

## Create vectors to prepare data frame
# Initialize vectors
state_list <- c()
subdivision_list <- c()
language_list <- c()
current_state <- NA # Not all ROW nodes have a state listed, so we will set the value for current_state as NA to start


## Clean the data by appending missing values to each node
# Iterate through each ROW node
for (row in rows) {
  # Check if the row contains a state (ENT with I="22") and update current_state
  state_node <- xml_find_first(row, "ENT[@I='22']")
  if (!is.na(state_node)) {
    current_state <- xml_text(state_node)
  }
  
  # Extract subdivision names (ENT with I="03")
  subdivision_nodes <- xml_find_all(row, "ENT[@I='03']")
  
  # Extract only the SECOND `<ENT>` as language (if it exists)
  language_node <- xml_find_all(row, "ENT[position()=2]")
  
  # Pair each subdivision with its corresponding language(s)
  for (sub_node in subdivision_nodes) {
    subdivision_name <- xml_text(sub_node)
    
    if (length(language_node) > 0) {  # Ensure there is a second ENT element
      language <- xml_text(language_node)
    } else {
      language <- NA  # Assign NA if no valid language found
    }
    
    # Append to lists
    state_list <- c(state_list, current_state)
    subdivision_list <- c(subdivision_list, subdivision_name)
    language_list <- c(language_list, language)
  }
}

## Create a data frame from the vectors
df <- data.frame(State = state_list, Subdivision = subdivision_list, Language = language_list, stringsAsFactors = FALSE)

# Print first few rows
head(df)

## Filter by State
texas_df = df[df$State == "Texas:", ]
head(texas_df)

illinois_df = df[df$State == "Illinois:", ]
head(illinois_df)

## Load to an Excel file
#install.packages("writexl")
library(writexl)
write_xlsx(illinois_df, "/Users/jill/Downloads/illinois_languages_census.xlsx")
