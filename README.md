# Extrovert Introvert Behavior
An analysis of the differences in social behavior between extroverted and introverted individuals, using SQL for data cleaning and analysis as well as Tableau for building a dashboard to identify trends and outliers.

## Table of Contents
* [About the Project](https://github.com/Kaileyv/extrovert-introvert-behavior/tree/main?tab=readme-ov-file#about-the-project)
* [Data Source](https://github.com/Kaileyv/extrovert-introvert-behavior/tree/main?tab=readme-ov-file#data-source)
* [Tools Used](https://github.com/Kaileyv/extrovert-introvert-behavior/tree/main?tab=readme-ov-file#tools-used)
* [Project Structure](https://github.com/Kaileyv/extrovert-introvert-behavior/tree/main?tab=readme-ov-file#project-structure)
* [Tableau Dashboard](https://github.com/Kaileyv/extrovert-introvert-behavior/tree/main?tab=readme-ov-file#tableau-dashboard)
* [Key Insights](https://github.com/Kaileyv/extrovert-introvert-behavior/tree/main?tab=readme-ov-file#key-insights)

## About the Project
This project examines the relation between social behavior and personality prediction by utilizing the key indicators of extroversion and introversion, improving our understanding of how social behavior reflects individual traits.

## Data Source
The data was sourced from Kaggle.com and contains:
* personality_dataset.csv

## Tools Used
* **SQL (MySQL)** - Performed data cleaning, complex querying using Common Table Expressions (CTEs), table joins, and aggregations to extract and structure insights
* **Tableau** - Designed dashboard and conveyed insights through visual storytelling

## Project Structure
```
extrovert-introvert-behavior/
│
├── data/                
│   └── personality_dataset.csv                      # Original dataset
│
├── sql/                  
│   └── personality.sql                              # SQL cleaning and queries  
│
├── tableau/               
│   └── Extrovert Introvert Behavior.twbx            # Tableau dashboard
│
├── images/               
│   └── extrovert_introvert_behavior_dashboard.png   # Tableau dashboard image
│
└── README.md                                        # Project overview
```
## Tableau Dashboard
[View Dashboard on Tableau Public](https://public.tableau.com/views/ExtrovertIntrovertBehavior/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

![](https://github.com/Kaileyv/extrovert-introvert-behavior/blob/main/images/extrovert_introvert_behavior_dashboard.png)

## Key Insights
* _**Extroverts**_ are more likely to attend social events, post on social media, go outside, and have bigger social circles compared to introverts

* _**Introverts**_ are more likely to spend time alone, have stage fear, and become drained after socializing

* Findings reveal that _**"introverted" extroverts**_ and _**"introverted" introverts**_ have similar social behavior across all key personality indicators, and vice versa, where _**"extroverted" introverts**_ and _**"extroverted" extroverts**_ also have similar social behavior across all key personality indicators

