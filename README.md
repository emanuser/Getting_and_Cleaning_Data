# Getting and Cleaning Data Course Project
### Johns Hopkins University | Coursera

## The purpose of this project 
I was required  to demonstrate an ability to collect, work with, and clean a data set, with the end goal of preparing  a tidy data that can be used for later analysis.


 For this project, an R script called run_analysis.R was created, and it does the following: 
 
1. Merges the training and the test sets to create one data set.
2. Appropriately labels the data set with descriptive variable names. 
3. Uses descriptive activity names to name the activities in the data set
4. Extracts only the measurements on the mean and standard deviation for each measurement. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The above steps were acomplised with the use of three main user defined  functions, along with the data.table and dplyr packages

1. data_subject_activity <- function(X, y, subjTxt, features = "features.txt")
2. remove_columns <- function(x = full_dataset)
3. avreg_activity_subject <- function(list_d_frames = first_split)

The first function is for combining the supplied text files into one dataframe, and is applied separately to testing and training data, which are then comdined in to one datatable named full_dataset.
The second functionis for extracting the mean and standard deviation from the full_dataset.
The third function is for building a tidy dataframe with each subjects calculated mean corresponding to each of the six activities, this is accomplished by iteratively stepping through three nested loops.

