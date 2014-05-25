
# Course Project

# Ignore Both Inertial Signals Folders
# Open and read the following textfiles manually: 
#        README file, features_info, activity_labels
# data.table and reshape2 packages should be installed - if not install using install.packages("data.table") and install.packages("reshape2")

# 1) Merges the training and the test sets to create one data set.
features <- read.table("features.txt") #561 rows by 2 columns(1st column is just counting the rows)
x_train <- read.table("./train/X_train.txt") #7352 by 561
y_train <- read.table("./train/y_train.txt") #7352 by 1 values range(1:6)
subject_train <- read.table("./train/subject_train.txt") #7352 by 1 vr(1:30) #subject_train and subject_test values are mutually exclusive between 1 and 30
x_test <- read.table("./test/X_test.txt") #2947 by 561 
y_test <- read.table("./test/y_test.txt") #2947 by 1 vr (1:6)
subject_test <- read.table("./test/subject_test.txt") #2947 by 1 vr (1:30)
features <- features$V2 # keep names only (remove row count) 561 by 1
colnames(x_train) <- features #names the future big df columns
colnames(x_test) <- features #prepares 2 dfs for binding
features <- as.character(features) #change from factor
bindxx <- rbind(x_train, x_test) #bind x_train and x_test vr 10299 by 561
bindsubj <- rbind(subject_train, subject_test)
colnames(bindsubj) <- "Subject"
bindyy <- rbind(y_train, y_test) #bind y_train and y_test vr 10299 by 1
colnames(bindyy) <- "Activity"
bindxs <- cbind(bindxx, bindsubj) #bind xx to subjects
onedataset <- cbind(bindxs, bindyy) #bind xs to yy to get one data set

# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
getmean <- grep("mean()",colnames(onedataset),ignore.case=TRUE) #get column indeces showing mean values (53)
getstd <- grep("std()", colnames(onedataset),ignore.case=TRUE) # get column indeces showing std values (33)
mean_std_col <- c(getmean, getstd, 562, 563) # put column indeces for means, stds, subject, and activity in one vector
msdf <- onedataset[mean_std_col] # extract data frame from

# 3) Uses descriptive activity names to name the activities in the data set
#use "activity labels" text file to get descriptions of coded activities in onedataset
msdf$Activity <- gsub("1","WALKING", msdf$Activity) # Change each 'factor integer' into corresponding activity name
msdf$Activity <- gsub("2","WALKING_UPSTAIRS", msdf$Activity) # Change each 'factor integer' into corresponding activity name
msdf$Activity <- gsub("3","WALKING_DOWNSTAIRS", msdf$Activity) # Change each 'factor integer' into corresponding activity name
msdf$Activity <- gsub("4","SITTING", msdf$Activity) # Change each 'factor integer' into corresponding activity name
msdf$Activity <- gsub("5","STANDING", msdf$Activity) # Change each 'factor integer' into corresponding activity name
msdf$Activity <- gsub("6","LAYING", msdf$Activity)  # Change each 'factor integer' into corresponding activity name

# 4) Appropriately labels the data set with descriptive activity names.
names(msdf) <- tolower(names(msdf)) #make column names all lower case
names(msdf) <- gsub("-", " ", names(msdf)) #get rid of "-" and replace with space for more clarity
names(msdf) <- gsub("\\()", " ", names(msdf)) #get rid of "()" and replace with space
names(msdf) <- gsub("\\(", " ", names(msdf)) #get rid of "(" and replace with space
names(msdf) <- gsub("\\)", "", names(msdf)) #get rid of ")"

# 5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(data.table)
library(reshape2)
melted <- melt(msdf, id.vars = c("subject", "activity")) #melt dataset into 4 columns
melts <- as.data.table(melted) # change class to data table to prepare for dcast
final.output <- dcast.data.table(melts, subject + activity ~ variable, fun.aggregate=mean) # cast data into desired output
final.output.textfile <- write.table(final.output, "run_analysis_output.txt") # write ouput to a text file