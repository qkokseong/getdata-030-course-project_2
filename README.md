## Class Project for "Getting and Cleaning Data"

### Abstract

Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

### Explanation of each file

* `features.txt` : Names of the 561 features.
* `activity_labels.txt` : Names and IDs for each of the 6 activities.
* `train/X_train.txt` : 7352 observations of the 561 features, for 21 of the 30 volunteers.
* `train/subject_train.txt` : A vector of 7352 integers, denoting the ID of the volunteer related to each of the observations in `X_train.txt`.
* `train/y_train.txt` : A vector of 7352 integers, denoting the ID of the activity related to each of the observations in `X_train.txt`.
* `test/X_test.txt` : 2947 observations of the 561 features, for 9 of the 30 volunteers.
* `test/subject_test.txt` : A vector of 2947 integers, denoting the ID of the volunteer related to each of the observations in `X_test.txt`.
* `test/y_test.txt` : A vector of 2947 integers, denoting the ID of the activity related to each of the observations in `X_test.txt`.

### Data files that were not used

The raw signal data is not used, so the data files in the "Inertial Signals" folders were ignored.

### Pre-requisite before running the R script

1. Download the zip file from [this URL](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
2. Unzip the file to the desired destination, for example, "C:\coursera\UCI HAR Dataset" in Windows platform.  __Note__ that you will need to use this path on line#5 in calling setwd() function in the run_analysis.R script
3. Copy the run_analysis.R script into the directory "UCI HAR Dataset", the file structure will become:-
	> `UCI HAR Dataset` (directory)
	> + `test` (directory)
	> + `train` (directory)
	> + activity_labels.txt
	> + features.txt
	> + features_info.txt
	> + README.txt
	> + __run_analysis.R__

4. Run the R script ([run_analysis.R](run_analysis.R)).
- __Note__ that it requires the [dplyr package](http://cran.r-project.org/web/packages/dplyr/index.html), which needs to be installed before running the R script.

### Processing steps in the R script

1. Merges the training and the test sets to create one data set.
	- Read from __test__ directory...
	- Read test data file into a data table
	- Read subject file into a data table and assign meaningful header to it
	- Read label file into a data table and assign meaningful header to it
    - Bind columns of test data file, subject file and label file into a __test data set__

	* Read from __train__ directory...
	* Read train data file into a data table
	* Read subject file into a data table and assign meaningful header to it
	* Read label file into a data table and assign meaningful header to it
	* Bind columns of train data file, subject file and label file into a __train data set__

	+ __Combine test and train data into one data set__


2. Extracts only the measurements on the mean and standard deviation for each measurement.
	- Read __features__ file into a data table
	- Extract the index of features columns which have the string "__mean__" or "__std__" in its column names, which will be used in the later step.


3. Uses descriptive activity names to name the activities in the data set
	- Read __activity__ labels file into a data table
	- Make a new key-value pairs for the activities, for example 1 corresponding to 'WALKING', 2 to 'WALKING_UPSTAIRS', etc.
	- In the combined data set, use the mapping of the activity key-value pairs to __convert the activity column from Integer to its corresponding character names__

4. Appropriately labels the data set with descriptive variable names.
	- In the __features__ data table, change its column name to be more readable, replace "-" with "..", and remove parenthesis
	- Make a new key-value pairs for the features
	- In the combined data set, for each column name that starts with "V", 
 		* remove character "V"; 
 		* convert it to an integer;
 		* retrieve its corresponding __features name__ by using the mapping of the features key-value pairs
 		* Otherwise retain the original column name

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity
	- In the combined data set, extract columns which have "mean" or "std" in their name by using the index obtained from the __step-2__ above. 
	- Change column position by moving column 'SubjectId' and 'Activity' to the beginning of the data table
	- Calculate the average of each variable for each activity and subject 
	- Write the tidy data set to a text file









