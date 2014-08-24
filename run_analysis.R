library("data.table")
library("plyr")

# Important! Your working directory initially should be set to the data's location ("UCI HAR Dataset" directory)
# For example:
#setwd("/Users/dennis/github/datasciencecoursera/Getting data project/UCI HAR Dataset/")

#load test data set
subject_test <- read.table('./test/subject_test.txt')
X_test <- read.table('./test/X_test.txt')
Y_test <- read.table('./test/Y_test.txt')

#load train data set
subject_train <- read.table('./train/subject_train.txt')
X_train <- read.table('./train/X_train.txt')
Y_train <- read.table('./train/Y_train.txt')

#load activity labels
activity_label <- read.table('activity_labels.txt')

#merge data sets from test and train folders
subject <- rbind(subject_train,subject_test)
X <- rbind(X_train,X_test)
Y <- rbind(Y_train,Y_test)

#give a column name for subject and Y data sets
names(subject) <- 'subject'
names(Y) <- 'activity_label'

#load features and transform variables names to the more descriptive format
features <- read.table("features.txt")
features <- features[,2]

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

#use the result as variable names
names(X) <- features

#select only mean and standard deviation variables
std_mean_column_names <- grep("std|mean",names(X),value=TRUE)
datasummary <- X[std_mean_column_names]

#add subject and activiti labels
datasummary <- cbind(subject,Y,datasummary)

#transfer activity from number to a descriptive name
get_activity <- function(x) {as.character(activity_label[activity_label[,1]==x,2])}
datasummary$activity_label <- as.character(lapply(datasummary$activity_label,get_activity))

#creating summary table by subject and activity label
sumdata <- ddply(datasummary,.(subject,activity_label),numcolwise(mean))

#writing the result as "datasummary.txt" into the working directory
write.table(sumdata,"./datasummary.txt",row.names=FALSE)