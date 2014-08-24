---
title: "Getting and Cleaning Data - Course Project - the code book"
author: "Denys Liubyvyi"
github user: denniskorablev
date: "August 23, 2014"
---

"run_analysis.R" performs analysis for data collected from the accelerometers
from the Samsung Galaxy S smartphone as a Course Project for Getting
and Cleaning Data course on Coursera.

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here is the data itself: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The script does the following:
1 - Merges the training and the test sets to create one data set.
2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
3 - Uses descriptive activity names to name the activities in the data set
4 - Appropriately labels the data set with descriptive variable names. 
5 - Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

Here is more detailed description how the script performs these tasks:

### 1 - Merging the training and the test sets to create one data set.

The script loads data from the following files located at "test" and "train" subfolders of the data:

- /test/subject_test.txt
- /test/X_test.txt
- /test/Y_test.txt
- /train/subject_train.txt
- /train/X_train.txt
- /train/Y_train.txt
- activity_labels.txt

Then the data sets from test and train folders are merged into following data sets accordingly:
- subject
- X
- Y

All them later will be merged into one data set called 'datasummary'

### 2 - Extracting only the measurements on the mean and standard deviation for each measurement
I firstly transform variables names to the more descriptive format (see step 3) and then select only columns that contain "mean" or "std" with the following code:
```
std_mean_column_names <- grep("std|mean",names(X),value=TRUE)
datasummary <- X[std_mean_column_names]
```

###3 - Using descriptive activity names to name the activities in the data set
From the very beginning I loaded activity names from the file 'activity_labels.txt':
```
activity_label <- read.table('activity_labels.txt')
```

Later I transfer activities from number to a descriptive name in our data frame by building function 'get_activity' and applying it to the all activity codes:
```
get_activity <- function(x) {as.character(activity_label[activity_label[,1]==x,2])}
datasummary$activity_label <- as.character(lapply(datasummary$activity_label,get_activity))
```

###4 - Appropriately labeling the data set with descriptive variable names. 
I selected format with all small letters and underscores betweeen words. This format for author's personal opinion looks the best in this data frame.

The script also changes "t" at the beginning of a variable name to more descriptive "time" to denote time-related variables and "f" at the beginning of a variable name to more descriptive "freq" to indicate variables with frequency domain signals.

To permorm the transformation to the selected format I using mostly *gsub* function and regular expressions. 
```
#remove (), capital letters, -, commas, double underscores
features <- gsub("[()]", "", features)
features <- gsub("([A-Z])", "_\\1",features)
features <- gsub("[-,]", "_", features)
features <- gsub("__", "_", features)

#change "t" at the beginning of a variable name to more descriptive "time" to denote time-related variables
features <- gsub("(^t_)", "time_", features)

#change "f" at the beginning of a variable name to more descriptive "freq" to indicate variables with frequency domain signals
features <- gsub("(^f_)", "freq_", features)

#make all letters small in the variable names
features <- tolower(features)
```
This is how the result looks like (few examples):
```
"subject"                                 
"activity_label"                         
"time_body_acc_mean_x"                    
"time_body_acc_mean_y"                   
"time_body_acc_mean_z" 
...
"time_body_acc_mag_mean"                  
"time_body_acc_mag_std"                  
"time_gravity_acc_mag_mean"               
"time_gravity_acc_mag_std"               
...
"freq_body_acc_mean_x"                    
"freq_body_acc_mean_y"                   
"freq_body_acc_mean_z"
...
```

### 5 - Creating a second, independent tidy data set with the average of each variable for each activity and each subject

For making the summary table with the average of each variable for each activity and each subject I used *ddply* function from the *plyr* package:
```
#creating summary table by subject and activity label
sumdata <- ddply(datasummary,.(subject,activity_label),numcolwise(mean))
```
To write the file the sript uses *write.table* function:
```
#writing the result as "datasummary.txt" into the working directory
write.table(sumdata,"./datasummary.txt",row.names=FALSE)
```