**Project Overview**

This repository contains the R scripts used for the data analysis presented in the associated article.

The study identified altered metabolite signatures in clinically depressed adolescents compared to healthy adolescents. Serum metabolite profiling was performed using a high-throughput targeted NMR platform.

Both multivariate and univariate statistical approaches were applied:

Linear regression models for metabolite-specific association testing

Orthogonal Partial Least Squares Discriminant Analysis (OPLS-DA) for multivariate pattern recognition




**Statistical Methods**

**Univariate Analysis**

Linear regression models were fitted for each metabolite using the ggforestplot R package, adjusting for relevant covariates (e.g., age, sex, BMI). False discovery rate (FDR) correction was applied using the Benjamini–Hochberg method.

**Multivariate Analysis**

OPLS-DA was performed using the ropls R package. Models were validated using permutation testing, and Variable Importance in Projection (VIP) scores were used to identify discriminating metabolites.


**Repository Structure**

01_linear_regression – Univariate regression models

02_OPLSDA – Multivariate analysis (OPLS-DA)

README.md – Project description



**Data Availability**

Due to ethical and privacy restrictions, raw metabolomics data are not publicly available.
