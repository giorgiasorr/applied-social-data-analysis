# Applied Data Analysis in Social Science  
### Causal Inference, Predictive Modeling & Empirical Research (R & Python)

This repository contains a collection of applied data analysis projects in R and Python, focused on causal inference, statistical modeling, and empirical research in social science.

The portfolio combines:

- Projects that originate from a graduate-level course in statistical data analysis and causal inference, systematically extended into research-style analyses  
- Fully self-directed projects in new domains, such as digital communication and social media data  

Across projects, the original analyses have been reworked to reflect real-world analytical workflows, with emphasis on:

- clean and structured data pipelines  
- reproducible synthetic datasets  
- clear visualization and interpretation of results  
- explicit methodological framing  
- critical and ethical reflection on data use and inference  


## Research Focus

This repository explores how **institutions, behavior, and social structures shape unequal outcomes**.

Across projects, I analyze:

- Discrimination in labor markets  
- Political representation and policy outcomes  
- Electoral behavior and forecasting  
- Measurement error in survey data  
- Institutional persistence and political change  
- Data integrity and replication in research  
- Digital communication patterns in political contexts  
- Predictive relationships in educational outcomes  

The unifying theme is the application of **quantitative methods to socially relevant questions**, with a strong emphasis on **causal reasoning and empirical validity**.


## Projects

### 01 — Labor Market Discrimination  
**Audit experiment on criminal records and hiring callbacks**

- Randomized field experiment (Milwaukee)  
- Clear causal identification (ATE)  
- Subgroup analysis by race  
- Strong example of experimental design in practice  

### 02 — Gender and Policy Impact  
**Effect of female leadership on public goods provision (India)**

- Randomized institutional setting  
- Policy outcome analysis (water vs irrigation)  
- Demonstrates how representation shapes resource allocation  

### 03 — Election Forecasting  
**Predictive power of betting markets (U.S. 2008 election)**

- Regression-based forecasting  
- Model evaluation using R² and prediction error  
- Distinction between prediction and causality  

### 04 — Survey Bias and Turnout  
**Measurement error in self-reported voting behavior (ANES)**

- Systematic overreporting analysis  
- Construction of turnout bias measures  
- Time trends and heterogeneity analysis  

### 05 — Grade Prediction Models  
**Predicting academic outcomes using midterm scores**

- Linear regression and probability models  
- Model evaluation and interpretation  
- Clear example of predictive (non-causal) analysis  

### 06 — Leader Death and Democracy  
**Effect of assassination outcomes on political institutions**

- Observational causal inference  
- Confounding and model adjustment  
- Institutional persistence vs individual effects  

### 07 — Replication Crisis Case Study  
**Detecting irregularities in experimental data**

- Distributional diagnostics  
- Panel stability analysis  
- Simulation of suspicious data-generating processes  
- Research integrity and reproducibility focus  

### 08 — Digital Democracy Analysis  
**Social media activity during Poland’s 2023 elections**

- Exploratory data analysis (Python)  
- Temporal and actor-based communication patterns  
- Basic NLP and coordination diagnostics  
- Purely descriptive analytical framework  


## Methodological Approach

Across projects, the following principles are emphasized:

### Causal Inference
- Randomized experiments  
- Observational causal designs  
- Difference-in-means estimation  
- Regression as causal estimator  
- Confounding and identification strategies  

### Predictive Modeling
- Linear regression models  
- Model evaluation (R², residuals, error analysis)  
- Distinction between prediction and causation  

### Data Analysis & Workflows
- Structured analytical pipelines  
- Reproducible research design  
- Data simulation to preserve empirical structure  
- Visualization for interpretation  


## Comparative Perspective

Across projects, similar methodological tools are applied to substantively different domains:

- **Labor markets** → identifying discrimination in hiring outcomes  
- **Political institutions** → evaluating how representation shapes policy decisions  
- **Electoral behavior** → assessing forecasting accuracy and market expectations  
- **Survey research** → detecting measurement error in self-reported behavior  
- **Education data** → modeling and predicting performance outcomes  
- **Historical political events** → estimating causal effects in observational settings  
- **Research integrity** → identifying irregularities in experimental data  
- **Digital communication** → analyzing structural patterns in online political discourse  

Despite these differences in context, the projects share a common goal:

→ **Using data to distinguish between correlation, prediction, and causal effects in socially relevant settings.**

This highlights how a consistent analytical framework can be adapted across domains while maintaining methodological rigor.


## Reproducibility

All projects are designed to be **fully reproducible**.

- Analyses are implemented as complete pipelines (`analysis.R` / `analysis.py`)  
- Synthetic datasets are used where original data cannot be shared  
- Simulations preserve:
  - data structure  
  - statistical relationships  
  - empirical logic of the analysis  

Typical workflow:

```r
source("simulate_data.R")
source("analysis.R")
```

## Project Structure

```text
applied-social-data-analysis/
│
├── 00_utils/
├── 01_labor_market_discrimination/
├── 02_gender_and_policy_impact/
├── 03_election_behavior_and_forecasting/
├── 04_survey_bias_and_turnout/
├── 05_grade_prediction_models/
├── 06_leader_death_and_democracy/
├── 07_replication_crisis_case_study/
├── 08_digital_democracy_social_media_analysis/
│
├── setup.R
├── .gitignore
└── README.md
```

Each folder represents a self-contained project with its own data generation, analysis, and documentation.


## Skills Demonstrated

- Causal inference (experimental & observational)  
- Regression modeling and statistical inference  
- Predictive modeling and evaluation  
- Measurement error analysis  
- Exploratory data analysis (EDA)  
- Data visualization (ggplot2, matplotlib)  
- Data simulation and reproducibility design  
- Research communication and structured reporting  
- Critical evaluation of empirical evidence  


## Tools Used

### R
- Base R  
- ggplot2  
- tidyverse (in selected projects)  

### Python
- pandas  
- matplotlib  
- seaborn  
- scikit-learn  


## Author

**Giorgia Sorrentino**
MSc Computational Linguistics 
