library (caret)
library(tidyverse)
library(skimr)
library(glmnet)
library(Matrix)
library(ROCR)
library(ggplot2)


loan_default <- read_csv (file = "loan_default.csv")

# EDA skipped was done in the other R script
# the purpose of this script is to work on the data modeling from a different angle.
# The update and reworking was done around the ROC and AUC evaluation of the model and doing a more accurate evaluation.


#loan_default (this is name of my data frame)
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
loan_predicted_probability <- predict(lasso_model, Ldefault_test, type = "prob")
loan_predicted_probability <- as.data.frame(loan_predicted_probability)


#Step 4: Get AUC and ROC curve for LASSO Model

#Get the ROC
library(ROCR)

# reassign column names
names(loan_predicted_probability) <- c("Default_0", "Default_1")

# Now you can access the "Default_0" or "Default_1" column
loan_pred_lasso <- prediction(loan_predicted_probability[, "Default_1"],
                              as.factor(Ldefault_test$Default),
                              label.ordering = c("notdefault", "default"))

# Check levels and ordering of class labels in the test set
levels(Ldefault_test$Default)

# Ensure that the order of class labels in the prediction matches those in the test set
loan_pred_lasso <- prediction(loan_predicted_probability[, "Default_1"],
                              as.factor(Ldefault_test$Default),
                              label.ordering = c("default", "notdefault"))

# Ensure that the order of class labels in the prediction matches those in the test set
loan_pred_lasso <- prediction(loan_predicted_probability[, "Default_1"],
                              as.factor(Ldefault_test$Default),
                              label.ordering = c("0", "1"))


loan_perf_lasso <- performance(loan_pred_lasso, "tpr", "fpr")
plot(loan_perf_lasso, colorize = TRUE)

#Get the AUC
loan_auc_lasso <- performance(loan_pred_lasso, "auc")@y.values[[1]]
loan_auc_lasso

















