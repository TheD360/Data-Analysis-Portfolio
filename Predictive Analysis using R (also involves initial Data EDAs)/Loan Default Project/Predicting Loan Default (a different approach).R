library (caret)
library(tidyverse)
library(skimr)
library(glmnet)
library(Matrix)
library(ROCR)
library(ggplot2)

#This project is a look into customer loan default data of a big bank in America
#and predicting what type of customer would default on their loans and what type would not.


loan_default <- read_csv (file = "loan_default.csv")

# step 0 Exploratory data analysis (EDA)
skim(loan_default)
summary(loan_default)

# make cat. variables that R missed to be cat. using factor function
loan_default <- loan_default %>% mutate_at (c(1, 7:10), as.factor)

skim(loan_default)

options(scipen=999)#Turn off scientific notation as global setting

# EDA performed in the first R script

# Where the rework was done.
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

# step 2 train the model
# install.packages("MASS")
# install.packages("ipred")
# Backward selection
library(MASS)

# Check the levels of the response variable
levels(Ldefault_train$Default)

# Make sure levels are valid R variable names
Ldefault_train$Default <- make.names(Ldefault_train$Default)

# Now, train your model
set.seed(10)
subset_model <- train(Default ~ .,
                      data = Ldefault_train,
                      method = "glmStepAIC",
                      direction = "forward",
                      trControl = trainControl(method = "none",
                                               classProbs = TRUE,
                                               summaryFunction = twoClassSummary),
                      metric = "ROC")

#this helps me see the coefficients of the independent variables in my dataset 
#and how significant they are to my entire model. # we also see our z-values here and out AIC as well.
# The number of fisher scoring iterations is also included in the summary of the "subset_model" returned 
summary(subset_model)


#step 3 Getting predictions on the testing set of my dataset 
Ldefault_pred <- predict(subset_model, Ldefault_test)
Ldefault_pred


# step 4 Evaluating the performance of our model on the testing set
# There are various ways you can evaluate your predictive model. 
# Confusion Matrix: This method/tool woudl summary the performance of a classification algorithm.
#It would provide the count of true positives, true negatives, false positives and false negatives.

# Confusion Matrix:
# Convert predicted values and actual test set labels to factors
Ldefault_pred <- as.factor(Ldefault_pred)
Ldefault_test$Default <- as.factor(Ldefault_test$Default)

# Check if levels match and if not, make them match
if (!all(levels(Ldefault_pred) %in% levels(Ldefault_test$Default))) {
  levels(Ldefault_pred) <- levels(Ldefault_test$Default)
} else if (!all(levels(Ldefault_test$Default) %in% levels(Ldefault_pred))) {
  levels(Ldefault_test$Default) <- levels(Ldefault_pred)
}

# Now, calculate confusion matrix
conf_matrix <- confusionMatrix(Ldefault_pred, Ldefault_test$Default)
print(conf_matrix)


# ROC Curve and AUC
library(pROC)
roc_curve <- roc(Ldefault_test$Default, as.numeric(as.character(Ldefault_pred)))
auc_roc <- auc(roc_curve)
plot(roc_curve)
print(auc_roc)

# Precision-Recall Curve and AUC
pr_curve <- pr.curve(Ldefault_test$Default, as.numeric(as.character(Ldefault_pred)))
plot(pr_curve$recall, pr_curve$precision, type='l', ylim=c(0,1), xlim=c(0,1), xlab='Recall', ylab='Precision')
auc_pr <- pr_curve$auc.integral
print(auc_pr)


