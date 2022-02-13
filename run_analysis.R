library(dplyr)
library(reshape2)
library(readr)
# library(stringr)


# reading
base_path <- "./data/UCI HAR Dataset/"
train_data_path <- paste0(base_path,"train/")
test_data_path <- paste0(base_path,"test/")

# meta files
feature_names <- read_table(paste0(base_path,"features.txt"), col_names = c("idx","attrName"))
subject_train <- read_table(paste0(train_data_path,"subject_train.txt"), col_names = "subCode")
subject_test <- read_table(paste0(test_data_path,"subject_test.txt"), col_names = "subCode")

# data files (training)
trainX_path <- paste0(train_data_path,"X_train.txt")
trainY_path <- paste0(train_data_path,"y_train.txt")

# data files (testing)
testX_path <- paste0(test_data_path,"X_test.txt")
testY_path <- paste0(test_data_path,"y_test.txt")

# reading into data frame
trainX_df <- read_table(trainX_path,col_names = feature_names$attrName)
trainY_df <- read_table(trainY_path, col_names = "Target")

testX_df <- read_table(testX_path, col_names=feature_names$attrName)
testY_df <- read_table(testY_path, col_names = "Target")

# get variable names that contains mean and std (case insensitive)
var_name_mean <- grep("[Mm]ean",names(trainX_df),value = T)
var_name_std <- grep("[Ss]td",names(trainX_df),value = T)

# select subset of columns that contains mean and standard dev.
mean_std_measures_train <- trainX_df[,c(var_name_mean,var_name_std)]
mean_std_measures_test <- testX_df[,c(var_name_mean,var_name_std)]

# combine measurement, subject, and activity information into one single data frame
train_Xy <- cbind(mean_std_measures_train,subject_train,trainY_df)
test_Xy <- cbind(mean_std_measures_test,subject_test,testY_df)

# combine training and test datasets together
train_test <- rbind(train_Xy,test_Xy)
# number of columns (use later)
num_columns <- ncol(train_test)

# translate the activity code to actual text for readability
# following info are from activity_labels.txt file
# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING
train_test$Target <- sapply(train_test$Target, function(x){
  if(x == 1){return("WALKING")}
  else if(x == 2){return("WALKING_UPSTAIRS")}
  else if(x == 3){return("WALKING_DOWNSTAIRS")}
  else if(x == 4){return("SITTING")}
  else if(x == 5){return("STANDING")}
  else if(x == 6){return("LAYING")}
  else{return("UNDEFINE")}
})

# remove the last 2 columns (which are subject code and activity)
variable_cols <- names(train_test[,c(-num_columns, -(num_columns-1))])

melt_df <- melt(train_test,id=c("subCode","Target"),measure.vars = mvars)

# average of each variable by subject code and activity
g_subCode_Target <- melt_df %>% group_by(subCode, Target) %>% dplyr::summarize(mean=mean(value))
g_subCode_Target

write.table(g_subCode_Target,file = "result.txt", row.names = F)
