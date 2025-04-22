# Voting Rights Act Minority Language Data Parser

This project parses a public XML dataset from the Federal Register on jurisdictions covered under Section 203 of the Voting Rights Act, which requires certain areas to provide bilingual voting materials. The XML contains data on state/subdivision and the covered minority language.

## 🔍 What it Does

- Reads in the [2021 Section 203 Federal Register XML](https://www.federalregister.gov/documents/full_text/xml/2021/12/08/2021-26547.xml)
- Extracts subdivision names and their associated minority language(s)
- Handles missing or repeated state names by tracking state-level context across XML nodes
- Outputs a clean, filterable DataFrame
- Exports results to Excel (`.xlsx`) for easy sharing and analysis

## 💡 Why it Matters

Language access is a core tenet of equitable voting rights. This tool allows researchers, voting rights advocates, and election officials to quickly isolate the data by state and analyze language coverage across jurisdictions.

## 📁 Example Output

The current script filters for Illinois and outputs to:
output/illinois_languages_census.xlsx

This file can be generated for any state by modifying the filter at the end of the script.

## 🛠️ Tech Stack

- R
- xml2
- writexl
- RMarkdown
- 
---
✍️ Author: Jillian Davis  
📅 March 2025
