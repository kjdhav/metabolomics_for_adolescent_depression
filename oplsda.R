#for OPLSDA using the ropls package

library (ropls)
library(dplyr)
library(tidyselect)


#load your file which has all the NMR data and metadata like age, sex, BMI, group, etc.

metabolite_file<- read.csv("my_NMR_file.csv")

#select metabolite cols only

biomarkers_for_reg <- colnames(metabolite_file) [3:175]



#log transform the raw data file 

metabolite_file_log <- metabolite_file %>%
  dplyr::select(tidyselect::all_of(biomarkers_for_reg), covariate1, covariate2, group) %>%        
  dplyr::mutate_at(
    .vars = dplyr::vars(tidyselect::all_of(biomarkers_for_reg)),
    .funs = ~ .x %>% log1p() %>% as.numeric()
  )

#create residual matrix

metab_matrix <- metabolite_file_log[, biomarkers_for_reg]



residual_matrix <- as.data.frame(matrix(NA, 
                                    nrow = nrow(metab_matrix), 
                                    ncol = ncol(metab_matrix)))

colnames(residual_matrix) <- biomarkers_for_reg
rownames(residual_matrix) <- rownames(metabolite_file_log)

#regress using the same covariates as used in lm, except the predictor

for (metab in biomarkers_for_reg) {
  model <- lm(as.formula(paste0(metab, " ~ covariate1 + covariate2")), data = metabolite_file_log)
  residual_matrix[[metab]] <- resid(model)
}

residual_matrix$group <- metabolite_file_log$group



#for oplsda

# metabolite measures

metabolite_measures<- residual_matrix[, biomarkers_for_reg]

# group labels as a factor
condition <- as.factor(residual_matrix$group)

#for pca
opls_pca <- ropls::opls(metabolite_measures)

# plot PCA scores
plot(opls_pca, 
     typeVc = "x-score", 
     parAsColFcVn = condition)


#perform oplsda

results_oplsda <- ropls::opls(metabolite_measures, 
                             condition, 
                             predI = 1, 
                             orthoI = NA, 
                             permI = 500)                                    #run model 500 times


#check OPLSDA output, check Q2 values (<0.4 = not the best model, >0.4 = acceptable), and permuted R2 and Q2 values

#find the metabolites above VIP 1.0 that are more important, considering the multivariate results

vips <- getVipVn(results_oplsda)
