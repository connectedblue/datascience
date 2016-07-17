library('ProjectTemplate')
load.project()

# Explore the training set

# Number of rows per user_name and outcome classe

summary <- pml.training %>% group_by(user_name, classe) %>% summarise(rows=n())

# Find which columns have missing values

na_cols <-colnames(pml.training)[colSums(is.na(pml.training)) > 0]

# Find which columns are factors

factor_cols <- names(Filter(is.factor, pml.training))



