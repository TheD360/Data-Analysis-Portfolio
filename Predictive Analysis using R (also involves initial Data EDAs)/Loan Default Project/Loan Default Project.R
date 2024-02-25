library (caret)
library(tidyverse)
library(skimr)
library(glmnet)
library(Matrix)
library(ROCR)
library(ggplot2)


loan_default <- read_csv (file = "loan_default.csv")

# step 0 Exploratory data analysis (EDA)
skim(loan_default)
summary(loan_default)

#Finding missing values
missing_values <- sum(is.na(Loan_data))
missing_values

# make cat. variables that R missed to be cat. using factor function
loan_default <- loan_default %>% mutate_at (c(1, 7:10), as.factor)


options(scipen=999)#Turn off scientific notation as global setting

# Basic EDA
# Using a boxplot helps DAnalysts see if there are outliers in a variable or Dataset.
# this works best if the variable/dataset is numerical (boxplots do not work very well on categorical data).
boxplot(loan_default$Checking_amount, ylab="Checking_amount")

boxplot(loan_default$Term, ylab="Term")

boxplot(loan_default$Credit_score, ylab="Credit_score")

boxplot(loan_default$Amount, ylab="Amount")

boxplot(loan_default$Saving_amount, ylab="Saving_amount")

boxplot(loan_default$Emp_duration, ylab="Emp_duration")

boxplot(loan_default$Age, ylab="Age")

boxplot(loan_default$No_of_credit_acc, ylab="No_of_credit_acc")

# This creates a table that shows how many ones and zeros are in the Default variable
table(loan_default$Default)


boxplot(loan_default$Credit_score ~ loan_default$Default, 
        main = "Box plot showing customers' credit scores \nby loan default status",
        xlab = "Loan default",
        ylab = "Credit score")


# Calculating the upper bound and lower bound of the response variable plotted against the Credit_score variable.
# this allowed me to know what the upper bound and lower bound credit score was for each of the two default variable entries.
# Calculate the IQR for the entire dataset
iqr_value <- IQR(loan_default$Credit_score)

# Define the lower and upper bounds for each group
lower_bound_0 <- quantile(loan_default$Credit_score[loan_default$Default == 0])[2] - 1.5 * iqr_value
upper_bound_0 <- quantile(loan_default$Credit_score[loan_default$Default == 0])[4] + 1.5 * iqr_value

lower_bound_1 <- quantile(loan_default$Credit_score[loan_default$Default == 1])[2] - 1.5 * iqr_value
upper_bound_1 <- quantile(loan_default$Credit_score[loan_default$Default == 1])[4] + 1.5 * iqr_value

# Print the bounds
cat("Lower bound for default=0:", lower_bound_0, "\n")
cat("Upper bound for default=0:", upper_bound_0, "\n")
cat("Lower bound for default=1:", lower_bound_1, "\n")
cat("Upper bound for default=1:", upper_bound_1, "\n")


#loan_default (this is name of my dataframe)
# Default (response variable)


# Modeling

#Step 1 Creating dummy variables
Ldefault_predictors_dummy <- model.matrix(Default~ ., data = loan_default )#create dummy variables expect for the response
Ldefault_predictors_dummy<- data.frame(Ldefault_predictors_dummy[,-1]) #get rid of intercept and make data frame
loan_default <- cbind(Default=loan_default$Default, Ldefault_predictors_dummy)


Ldefault_predictors_dummy <- model.matrix(Default ~ .,
                                        data = loan_default)


Ldefault_predictors_dummy <- data.frame(Ldefault_predictors_dummy[,-1])
loan_default <-cbind(Default = loan_default$Default, Ldefault_predictors_dummy)


# Partition Data (Training & Testing)
set.seed(99)
index <- createDataPartition(loan_default$Default, p = .8, list=FALSE) #It should always be the respons variable
Ldefault_train <- loan_default[index,]
Ldefault_test <- loan_default [-index,]


# Check unique values of Default variable
unique_levels <- unique(Ldefault_train$Default)

# Convert to valid R variable names
valid_levels <- make.names(unique_levels)

# Update Default variable with valid levels
Ldefault_train$Default <- factor(Ldefault_train$Default, levels = unique_levels, labels = valid_levels)


# step 2 train the model (forward selection)
# install.packages("MASS")
# install.packages("ipred")
# Backward selection
library(MASS)

set.seed(10)
subset_model <- train(Default ~ .,
                      data = Ldefault_train,
                      method = "glmStepAIC",
                      direction="forward",
                      trControl =trainControl(method = "none",
                                              classProbs = TRUE,
                                              summaryFunction = twoClassSummary),
                      metric="ROC")

# Display coefficients for the final model
coef(subset_mode$finalModel)
# Ending of subset modeling (forward selection)



# Going back to step 2 of the predictive analytics process to try a different model.
# step 2 train the model with backward elimination
set.seed(10)
subset_model_backward <- train(Default ~ .,
                              data = Loan_train,
                              method = "glmStepAIC",
                              direction="backward",
                              trControl =trainControl(method = "none",
                                                      classProbs = TRUE,
                                                      summaryFunction = twoClassSummary),
                              metric="ROC")

# Display coefficients for the final model
coef(subset_model_backward$finalModel)
# End for Backward Elimination



#Going back to step 2 again to try the LASSO model
#Step 2 train the model using LASSO
# LASSO modeling - Linear Regression
#install.packages("e1071")
library(e1071)
#install.packages("glmnet")
library(glmnet)
#install.packages("Matrix")
library(Matrix)


set.seed(10) # how do you choose what set.seed number to use
lasso_model <- train(Default ~ .,
                     data = Ldefault_train,
                     method = "glmnet",
                     standardize=T,
                     tuneGrid = expand.grid(alpha=1,
                                            lambda = seq(0.0001,1,length=20)),
                     trControl =trainControl(method = "cv",
                                             number = 5,
                                             classProbs=T,
                                             summaryFunction = twoClassSummary),
                     metric="ROC") # "forward"

lasso_model

coef(lasso_model$finalModel, lasso_model$bestTune$lambda)
lasso_model$bestTune$lambda


# Install and load the pROC package
# install.packages("pROC")
library(pROC)


#Step 3: Predicted probability of default on test set
loan_predicted_probability <- predict(Loan_model, Loan_test, type = "prob")
loan_predicted_probability <- as.data.frame(loan_predicted_probability)


#Step 4: Get AUC and ROC curve for LASSO Model

#Get the ROC
library(ROCR)
loan_pred_lasso <- prediction(loan_predicted_probability[, "default"],
                              as.factor(Loan_test$Default),
                              label.ordering = c("notdefault", "default"))

loan_perf_lasso <- performance(loan_pred_lasso, "tpr", "fpr")
plot(loan_perf_lasso, colorize = TRUE)

#Get the AUC
loan_auc_lasso <- performance(loan_pred_lasso, "auc")@y.values[[1]]
loan_auc_lasso

















