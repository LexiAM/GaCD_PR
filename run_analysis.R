# 'run_analysis.R' script reads in locally stored UCI HAR Dataset (Human Activity Reconginition
# using Samsung Smartphone Dataset from UCI). Data must be stored in the subdirectory "/UCI HAR Dataset/"
# of the R working directory.
#
# The training and test data sets are combined, in that order, into a single data frame. 
#
# Only features measuring mean or standard deviation of measurements are retained. Determination to
# retain or remove feature from the set is determined by examining feature names
# contained in features.txt file. Only features with names that contain strings "mean()" or "std()"
# are retained. As a result, "meanFreq" features are dropped, since information they contain can be found
# by manipulating other features.
#
# Subsequently, a second "tidy" data set 'Data.Average' that contains an average of each variable
# for each activity and each subject is created. The new "tidy" data set is then written to
# 'DataAverage.txt' output file in the R working directory
#

# load data.table library for faster table manipulation
library(data.table)

# clean memory
rm(list=ls())


# Read in and training and test feature sets

##read in training and test feature sets: X_train and X_test
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)

## Combine training and test sets
X <- rbind(X_train, X_test)

rm(X_train, X_test) #clean memory


# Extract only mean and standard devaition measures for each measurement type

## read in list of feature names
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)

## select only feature names that contain 'mean(' or 'std('
features.select <- features[which(grepl("mean\\(|std\\(",features[[2]])>0),]

rm(features) # clean memory

## keep only selected features
X <- X[,features.select[[1]]]



# Create descriptive feature names

mygsub <- function(z){
    # mygsub function takes a string argument
    # containing an abbreviated feature name and 
    # converts it into a descriptive name
  
    z <- gsub("^t", "Time_Domain_", z)
    z <- gsub("^f", "FFT_", z)
    z <- gsub("Body|BodyBody", "Body_", z)
    z <- gsub("Acc-|Acc", "Acceleration_",z)
    z <- gsub("Gravity", "Gravity_",z)
    z <- gsub("Gyro-|Gyro", "Gyroscope_",z)
    z <- gsub("Jerk-|Jerk", "Jerk_",z)
    z <- gsub("Mag-|Mag", "Magnitude_",z)
    z <- gsub("mean\\(\\)", "Mean", z)
    z <- gsub("std\\(\\)", "Standard_Deviation", z)
}

## create a list of descriptive feature names
feature.names <- sapply(features.select$V2, function(x) mygsub(x))

rm(features.select, mygsub) #clean memory


# Read in human subject identifiers (1:30) for each sample
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test<- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

## Combine training and test sets
subject <- rbind(subject_train, subject_test)

rm(subject_train, subject_test) #clean memory



# Read in Activity Classes and label with descriptions

## read in training and test labels sets
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)

## read in activity names for class labels 
activity_labels <- data.table(read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE))

## update activity class labels 'y' with class names for both training and test data
setkey(activity_labels)
y.named <- activity_labels[rbind(y_train, y_test)]

rm(y_train, y_test, activity_labels)


# Combine training and test sets into a single data table
# with columns in the following order:
# subject ID, activity class labels and names, and features
# 
Data <- data.table(cbind(subject, y.named, X))

rm(subject, y.named, X)

## Add column names
setnames(Data, c("SubjectID", "Activity", "ActivityName", feature.names))

rm(feature.names) #clean memory



# Create a second dataset 'Data.Average' that contains an average of each variable
# for each activity and each subject
Data.Average<- Data[, lapply(.SD,mean), by = list(SubjectID, Activity, ActivityName)]

## Set column names: "Average_[colname from original data table 'Data']"
setnames(Data.Average,paste0(c(rep("",3), rep("Average_",ncol(Data.Average)-3)), names(Data.Average)))


# Write Data.Average to text file
write.table(Data.Average,"DataAverage.txt", row.names=FALSE)

