

require(data.table)
require(dplyr)


## Function for combining supplied text files into one dataframe, applied separately to testing and training data
data_subject_activity <- function(X, y, subjTxt, features = "features.txt") {
  data <- read.table(X)  ### load main data 
  col_names <- read.table(features, colClasses = "character") 
  colnames(data) <- col_names[, 2]  ### set features.txt as column names in main data set
  subject <- read.table(subjTxt)
  colnames(subject) <- "subject"
  
  assigned_names <- read.table(y, colClasses = "character") ### load numeric activity data set and convert to text
  assigned_names <- gsub("1", "WALKING", assigned_names[,1])
  assigned_names <- gsub("2", "WALKING_UPSTAIRS", assigned_names)
  assigned_names <- gsub("3", "WALKING_DOWNSTAIRS", assigned_names)
  assigned_names <- gsub("4", "SITTING", assigned_names)
  assigned_names <- gsub("5", "STANDING", assigned_names)
  assigned_names <- gsub("6", "LAYING", assigned_names)
 
 
  all <- data.table(subject, assigned_names, data)
}

## Function for extracting the mean and standard deviation
remove_columns <- function(x = full_dataset) {
  mean_std_ <- grep("mean()|std()" , colnames(x), ignore.case = FALSE, fixed = FALSE) ### serch for columns we want
  all_columns  <- 1:length(x) 
  columns_we_dont_want <- all_columns[-c(mean_std_, 1:2)] ### subtract columns (we want) form the (ones we don't)
  x[, - columns_we_dont_want] ### remove ones we dont want from full_dataset
}

## Function for building a tidy dataframe with each subjects calculated mean corresponding to each of the six activities
### this is accomplished by iteratively stepping through three nested loops
avreg_activity_subject <- function(list_d_frames = first_split) {
  activity_names <- read.table("activity_labels.txt", colClasses = "character")
  index.activity <- sapply(1:length(activity_names[,2]), function(x) activity_names[x, 2]) ### create index of activity names for loop function
  index.colnames <- colnames(Extract_mean_std[-c(1:2)])
  calculate_means <- function(x) colMeans(x[, index.colnames], na.rm = TRUE) ### function to be used on sceond second_split
  do.call("rbind", 
          lapply(1:30, 
                 function(i) {
                   each_subject <- as.data.frame(first_split[i]) ### loop through each subjects data frame from the first_split
                   colnames(each_subject) <- colnames(Extract_mean_std)
                   second_split <- lapply(1:6, 
                                          function(x) 
                                            filter(each_subject, assigned_names == index.activity[x])) ### subset or split each_subject by activity
                   
                   mean_of_activity_by_person <- as.data.frame(do.call("rbind",
                                                                       lapply(second_split,calculate_means))) ## call function "calculate_means" and rbind all subjects and activitys 
                   activity <- as.data.frame(index.activity) ### create activity dataframe corresponding calculated means
                   names(activity) <- gsub("index.activity" , "activity", names(activity)) ### change column name 
                   subject <- data_frame(c(i,i,i,i,i,i)) ### create subject dataframe corresponding to six activities
                   colnames(subject) <- "subject" ### change column name 
                   bind_cols( subject, activity, mean_of_activity_by_person) ## create tidy-dataframe
                 }
                 )
  )
}




all_test <- data_subject_activity("X_test.txt", "y_test.txt", "subject_test.txt")
all_train <- data_subject_activity("X_train.txt", "y_train.txt", "subject_train.txt")

full_dataset <- as_data_frame(rbind(all_test, all_train))

Extract_mean_std <- remove_columns()

rm(all_test, all_train, full_dataset)

first_split <- split(Extract_mean_std, Extract_mean_std$subject) ## split by subject

part_5 <- avreg_activity_subject()


rm(first_split)


write.table(part_5, file = "./tidy_data_set.txt", row.name=FALSE)
