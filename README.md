projectgettingcleaningdata
==========================

Course Project Getting and Cleaning Data 

## Using the run_analysis.R scrpit
* Ignore Both Inertial Signals Folders
* Open and read the following .txt files manually:  README file, features_info, activity_labels
* data.table and reshape2 packages should be installed - if not install using install.packages("data.table") and install.packages("reshape2")

# Variable Names

## 1) Merges the training and the test sets to create one data set.

* features: reads features.txt into R - 561 rows by 2 columns(1st column is just counting the rows)
* x_train: reads X_train.txt into R - 7352 by 561
* y_train: reads y_train.txt into R 7352 by 1, values range(1:6)
* subject_train: reads subject_train.txt into R - 7352 by 1, vr(1:30) #subject_train and subject_test values are mutually exclusive between 1 and 30
* x_test: reads X_test.txt into R - 2947 by 561 
* y_test: : reads X_test.txt into R - 2947 by 1, vr (1:6)
* subject_test: reads subject_test.txt into R - 2947 by 1, vr (1:30)
* features: keeps names only (remove row count) in features 561 by 1
* colnames(x_train): names the x_train column data according to the features
* colnames(x_test): names the x_test column data according to the features
* features: changes featuresfrom factor to character
* bindxx: bind x_train and x_test
* bindsubj: binds subject_train and subject_test
* colnames(bindsubj): changes bindsubj column names to "subject"
* bindyy: bind y_train and y_test
* colnames(bindyy): changes bindyy column names to "Activity"
* bindxs: bind xx to subjects
* onedataset: bind xs to yy to get one data set

## 2) Extracts only the measurements on the mean and standard deviation for each measurement. 

* getmean: get column indeces showing mean values 
* getstd: get column indeces showing std values
* mean_std_col: put column indeces for means, stds, subject, and activity in one vector
* msdf: extract mean and std values from onedataset

## 3) Uses descriptive activity names to name the activities in the data set
*use "activity labels" text file to get descriptions of coded activities in onedataset

* msdf$Activity <- gsub("1","WALKING", msdf$Activity) # Change each 'factor integer' into corresponding activity name
* msdf$Activity <- gsub("2","WALKING_UPSTAIRS", msdf$Activity) # Change each 'factor integer' into corresponding activity name
* msdf$Activity <- gsub("3","WALKING_DOWNSTAIRS", msdf$Activity) # Change each 'factor integer' into corresponding activity name
* msdf$Activity <- gsub("4","SITTING", msdf$Activity) # Change each 'factor integer' into corresponding activity name
* msdf$Activity <- gsub("5","STANDING", msdf$Activity) # Change each 'factor integer' into corresponding activity name
* msdf$Activity <- gsub("6","LAYING", msdf$Activity)  # Change each 'factor integer' into corresponding activity name

## 4) Appropriately labels the data set with descriptive activity names.
* names(msdf) <- tolower(names(msdf)) #make column names all lower case
* names(msdf) <- gsub("-", " ", names(msdf)) #get rid of "-" and replace with space for more clarity
* names(msdf) <- gsub("\\()", " ", names(msdf)) #get rid of "()" and replace with space
* names(msdf) <- gsub("\\(", " ", names(msdf)) #get rid of "(" and replace with space
* names(msdf) <- gsub("\\)", "", names(msdf)) #get rid of ")"

## 5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
* library(data.table): access data.table library
* library(reshape2): access reshape2 library
* melted: melt dataset into 4 columns
* melts: change class to data table to prepare for dcast
* final.output: cast data into desired output
* final.output.textfile: write ouput to a text file