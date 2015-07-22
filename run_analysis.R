library(plyr)
library(dplyr)

# You may need to change the workspace that suits your need
setwd("C:/tmp2/coursera/UCI HAR Dataset")

#---1.Merges the training and the test sets to create one data set.-----------------------------#

# Read test data
f_subj_test <- "./test/subject_test.txt"
tb_subjtest <- read.table(f_subj_test, header=FALSE, stringsAsFactors=FALSE)
colnames(tb_subjtest)[colnames(tb_subjtest)=="V1"] <- "SubjectId"  # Add column name for subject file

f_x_test <- "./test/X_test.txt"
tb_x_test <- read.table(f_x_test, header=FALSE, stringsAsFactors=FALSE)

f_y_test <- "./test/y_test.txt"
tb_y_test <- read.table(f_y_test, header=FALSE, stringsAsFactors=FALSE)
colnames(tb_y_test)[colnames(tb_y_test)=="V1"] <- "Activity"  # Add column name for label file

# Binding columns into a test data set
tb_test_dat <- cbind(tb_x_test, tb_y_test, tb_subjtest)


# Read train data
f_subj_train <- "./train/subject_train.txt"
tb_subjtrain <- read.table(f_subj_train, header=FALSE, stringsAsFactors=FALSE)
colnames(tb_subjtrain)[colnames(tb_subjtrain)=="V1"] <- "SubjectId"  # Add column name for subject file

f_x_train <- "./train/X_train.txt"
tb_x_train <- read.table(f_x_train, header=FALSE, stringsAsFactors=FALSE)

f_y_train <- "./train/y_train.txt"
tb_y_train <- read.table(f_y_train, header=FALSE, stringsAsFactors=FALSE)
colnames(tb_y_train)[colnames(tb_y_train)=="V1"] <- "Activity"  # Add column name for label file

# Binding columns into a train data set
tb_train_dat <- cbind(tb_x_train, tb_y_train, tb_subjtrain)

# Combine test and train data into one data set
tb_combine_dat <- rbind(tb_test_dat, tb_train_dat)


#-----------------------------------------------------------------------------------------------#
#---2.Extracts only the measurements on the mean and standard deviation for each measurement.---#

f_features <- "features.txt"
tb_features <- read.table(f_features, header=FALSE, stringsAsFactors=FALSE)
idx_mean_std <- tb_features[grep("mean|std", tb_features$V2, value=F),][1]


#-----------------------------------------------------------------------------------------------#
#---3.Uses descriptive activity names to name the activities in the data set--------------------#

f_activity_lbl <- "activity_labels.txt"
tb_activity_lbl <- read.table(f_activity_lbl, header=FALSE, stringsAsFactors=FALSE)

activity_n <- tb_activity_lbl$V1  # keys
activity_name <- tb_activity_lbl$V2  # values
activity_map <- setNames(activity_name, activity_n)  # Make a new key-value pairs for the activities

# Convert the activity column from Integer to its corresponding character names
tb_combine_dat$Activity <- activity_map[tb_combine_dat$Activity]  


#-----------------------------------------------------------------------------------------------#
#---4.Appropriately labels the data set with descriptive variable names.------------------------#

# To make features name more readable, replace "-" with "..", and remove parenthesis
tb_features$name <- gsub("-","..",gsub("[)(]","",tb_features$V2))

features_n <- tb_features$V1  # keys
features_name <- tb_features$name  # values
features_map <- setNames(features_name, features_n)  # Make a new key-value pairs for the features

# For each column name that starts with "V", 
# - remove character "V"; 
# - convert it to an integer;
# - and retrieve its corresponding features name.
# Otherwise just use the original column name
FUN <- function(x) { if (grepl("^V", x)) { features_map[as.numeric(gsub("V","", x))] } else { x } }
names(tb_combine_dat) <- lapply(names(tb_combine_dat), FUN)


#------------------------------------------------------------------------------------------------------------------------------------#
#---5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity---#

# Extract columns which have "mean" or "std" in their name, 
# and preserve the columns for SubjectId and Activity
mean_std_dat <- tb_combine_dat[,c(idx_mean_std[1]$V1, 562, 563)]  

# Change column position by moving column 'SubjectId' and 'Activity' to the beginning of the data table
tidy_dat <- ( mean_std_dat %>%
                      select(SubjectId, Activity, everything()))

# Calculate the average of each variable for each activity and subject 
avg_vars <- ddply(tidy_dat, c("SubjectId","Activity"), numcolwise(mean))

# Write the tidy data set to a text file
write.table(avg_vars, "tidy_data.txt", row.name=FALSE)
