# install.packages("skimr")
# install.packages("caret")

# Purpose of this project: To perform exploratory data analysis(EDA) on the dataset and see its distribution and
# composition or make up.

# I also went on to perform a multi-linear regression model on the dataset. Predicting Sales prices based on CompPrice, Urban, US.


library(skimr)
library(tidyverse)
library(caret)

# install.packages("GGally")
library(GGally)


Salesq <- read.csv(file = "Salesq.csv") # After working directory has been set/established
skim(Salesq)

#Created a table of the categorical variable of the dataset to see how the various observations within the categorical variables fall.
# This would help us find out the number of 'Yeses' and 'Nos' in a variable/column (Finds the breakdown of the categorical variable/column)
table(Salesq$Urban)
table(Salesq$US)

# Partitioning my data set into testing data and training data
set.seed(16) # Set a seed for random reproducibility

index <- createDataPartition(Salesq$Sales, p = .8, list = FALSE)
Salesq_train <- Salesq[index,] 
Salesq_test <- Salesq[-index,]

# train model on train set (your partitioned data use the train set to train your model about your data)
Salesq_model <- train(Sales  ~ .,
                      data = Salesq_train,
                      method = "lm",
                      trControl = trainControl (method = "none"))

summary(Salesq_model)

# Predicting sales on the test set based on CompPrice, Urban, US variables
Sales_predictions <- predict(Salesq_model, Salesq_test)

MSE ((Sales_predictions - Salesq_test$Sales)^2)
# Mean Square Error = 8.729







