---
title: "Getting and Cleaning Data - Course Project - the code book"
author: "Denys Liubyvyi"
github user: denniskorablev
date: "August 23, 2014"
---

*"run_analysis.R"* performs analysis for data collected from the accelerometers
from the Samsung Galaxy S smartphone as a Course Project for Getting
and Cleaning Data course on Coursera.

We load data from the following files located at "test" and "train" subfolders of the data:

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

From the 561 variables from the X dataset we select only those that contain "mean" and "std" (for standard deviation) codes. 

After adding subject and Y (activity codes) we receiver the *datasummary* data frame with 88 variables and 10299 records. 

All the variables names are transformed to lower letters with underscores as separators.

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
The final summary table  is created from datasummary data frame and called sumdata. It contactains means of all 'mean' and 'std' variables by subject and activity label.

The result will be saved into the working directory under filename *"datasummary.txt"*

More details about the script look at *README.md* and in script's comments.