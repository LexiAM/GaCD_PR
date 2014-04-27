GaCD_PR
========================================================

Getting and Cleaning Data Peer Review Assignment
------------------------------------------------

This repository contains "DataAverage.txt" file containing a dataset obtained by running the "run_analysis.R" script on the UCI HAR Dataset stored in the './UCI HAR Dataset/' subfolder of the R working directory. UCI HAR Dataset contrains a data set on Human Activity Reconginition using Samsung Smartphone Accelerometer and Gyroscope signals. The data set was downloaded on Monday April 21, 2014, 10:03:30PM from
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


### 'run_analysis.R' script performs the following functions:
* Reads in locally stored UCI HAR Dataset
* Combines training and test data sets into a single data frame
* Retains only features measuring mean or standard deviation of measurements
  * Determination to retain or remove feature from the set is determined by examining feature names contained in features.txt file. 
  * Only features with names that contain strings "mean()" or "std()" are retained. 
  * As a result, "meanFreq" features are dropped, since information they contain can be found by manipulat ng other features.
* A second "tidy" data set named 'Data.Average' that contains an average of each variable for each activity and each subject is created. The new "tidy" data set is then written to 'DataAverage.txt' output file in the R working directory



### 'DataAverage.txt' is:
* Space delitmited text file
* Contains **average** of means or standard deviations of each smartphone signal measured for each subject and activity
* Header containing varaible names is located on the first line: "SubjectID", "Activity", "ActivityName", "Average_[Measurement#1]", "Average_[Measurement#2]", ..., "Average_[Measurement#66]"


