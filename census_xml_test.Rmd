---
title: "Census_Language_Data"
author: "Jill Davis"
date: "3/25/2025"
output: html_document
---

#### R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

# Voting Rights Act Minority Language by Jurisdiction

This document converts the table from <https://www.federalregister.gov/documents/full_text/xml/2021/12/08/2021-26547.xml> into a static data frame for analysis.

After converting the table to a data frame, this program takes just the data for Illinois and converts it into an Excel (.xlsx) file. However, the data frame can be filtered to any state using the same method. 

## Load required packages
```{r load xml2}
#install.packages("xml2")
library(xml2)
```

## Read in the data
```{r read xml}
# Read the XML file
xml_file <- read_xml("/Users/jill/Downloads/census_xml_file_test.xml")
```

## Extract relevant xml nodes
```{r extract data}
# We want to extract all ROW nodes
rows <- xml_find_all(xml_file, "//ROW")
```

## Create vectors to prepare data frame
```{r initialize vectors}
# Initialize vectors
state_list <- c()
subdivision_list <- c()
language_list <- c()
current_state <- NA # Not all ROW nodes have a state listed, so we will set the value for current_state as NA to start
```

## Clean the data by appending missing values to each node
```{r clean the data}
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
```

## Create a data frame from the vectors
```{r transform data}
# Create a data frame
df <- data.frame(State = state_list, Subdivision = subdivision_list, Language = language_list, stringsAsFactors = FALSE)

# Print first few rows
head(df)
```

## Filter by State
```{r filtered}
texas_df = df[df$State == "Texas:", ]
head(texas_df)

```
```{r illinois}
illinois_df = df[df$State == "Illinois:", ]
head(illinois_df)
```
## Load to an Excel file
```{r load to excel}
#install.packages("writexl")
library(writexl)
write_xlsx(illinois_df, "/Users/jill/Downloads/illinois_languages_census.xlsx")
```
