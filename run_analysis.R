## FILENAME: run_analysis.R
## COURSERA - GETTING AND CLEANING DATA
## COURSE PROJECT 1
## DUE DATE: MONDAY, MAY 26TH

## MERGE TRAINING SETS AND TEST SETS TO CREATE 1 DATASET

# Unzip original datasets
unzip("getdata-projectfiles-UCI HAR Dataset.zip")

# Combine the test set results with subject and activities
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
test_set <- cbind(subject_test, y_test, x_test)

# Combine the training set results with subject and activities
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
train_set <- cbind(subject_train, y_train, x_train)

# Merge training and test sets
compiled_set <- rbind(train_set, test_set)

# Assign Column Names
features <- read.table("./UCI HAR Dataset/features.txt")
colnames(compiled_set) <- c("subject", "activity", as.character(features[,2]))


## EXTRACT MEAN AND STANDARD DEVIATION OF EACH MEASUREMENT

dataMean <- compiled_set[,grepl("mean[^Freq]", colnames(compiled_set))]
dataStd <- compiled_set[,grep("std",colnames(compiled_set))]
dataSubject <- compiled_set[,grep("subject",colnames(compiled_set))]
dataActivity <- compiled_set[,grep("activity",colnames(compiled_set))]
extMeanStd <- cbind(dataSubject, dataActivity, dataMean, dataStd)
names(extMeanStd)[1] <- "subject"
names(extMeanStd)[2] <- "activity"


## USE DESCRIPTIVE ACTIVITY NAMES TO NAME ACTIVITIES

# Load activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Change column names
colnames(activity_labels) <- c("activity","activityLabels")

# Merge activity labels with extracted data
extMeanStd <- merge(activity_labels,extMeanStd,by.x="activity",by.y="activity")

# Remove unwanted columns
extMeanStd[,1] = NULL


## LABEL DATASET WITH DESCRIPTIVE ACTIVITIES

# Replace 't' with 'time'
colnames(extMeanStd) <- sub("^t","time",colnames(extMeanStd))

# Replace 'f' with 'frequency'
colnames(extMeanStd) <- sub("^f","frequency",colnames(extMeanStd))

# Replace 'Acc' with 'Accelerometer'
colnames(extMeanStd) <- sub("Acc","Accelerometer",colnames(extMeanStd))

# Replace 'Gyro' with 'Gyroscope'
colnames(extMeanStd) <- sub("Gyro","Gyroscope",colnames(extMeanStd))

# Replace 'mag' with 'Magnitude'
colnames(extMeanStd) <- sub("Mag","Magnitude",colnames(extMeanStd))

# Remove brackets and hiphens in labels
colnames(extMeanStd) <- gsub("\\-std\\(\\)(\\-)?","Std",colnames(extMeanStd))
colnames(extMeanStd) <- gsub("\\-mean\\(\\)(\\-)?","Mean",colnames(extMeanStd))

# Labels have not been converted to lowercase to maintain readability, and that
# every word is easily identified.

# Remove all unwanted objects
remove(activity_labels,compiled_set,dataMean,dataStd,features,subject_test,
       subject_train,test_set,train_set,x_test,x_train,y_test,y_train,
       dataActivity,dataSubject)

# Write data to file
write.table(extMeanStd,"tidyset1.txt")


## CREATE SECOND INDEPENDENT TIDY DATASET WITH AVERAGE OF EACH VARIABLE OF EACH
## ACTIVITY AND EACH SUBJECT

# Get average data
avgMeanData <- aggregate(extMeanStd,list(extMeanStd$activityLabels, 
                                         extMeanStd$subject),mean)

# Remove unwanted columns
avgMeanData[,3] = NULL
avgMeanData[,3] = NULL

# Add column names
colnames(avgMeanData)[1:2] <- c("activity","subject")

#Write data to file
write.table(avgMeanData,"tidyset.txt")