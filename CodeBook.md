# Code Book - 'Getting and Cleaning Data' Course Project
# Part of Data Science Specialization by Johns Hopkins University via Coursera 

## Introduction

This CodeBook is not only a guide to describe the variables and data used in this project, but also explains the transformations performed on the data to make it ready for data analysis.

The intention for writing this document is to clearly explain the entire process of collecting, working and cleaning the data, of which the resulting dataset is provided in the pertaining GitHub repository named ['*tidydata.txt*'](https://github.com/irtizak/GetCleanDataProject/blob/master/tidyset.txt). For any further details that you may not be able to find here, kindly refer to the ['*Readme file*'](https://github.com/irtizak/GetCleanDataProject/blob/master/Readme.md) provided in the same GitHub repository.


## Data Source

The data used in this project belongs to a Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors. The experiments were video-recorded to label the data manually. The obtained dataset was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

It is a time-series dataset with a total of 561 variables and 10299 
observations. 

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

### For each record it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

### What is required is to create an R Script called 'run_analysis.R' that does the following:
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive activity names. 
- Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


## Variables

The variables in this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

- timeBodyAccelerometerXYZ
- timeGravityAccelerometerXYZ
- timeBodyAccelerometerJerkXYZ
- timeBodyGyroscopeXYZ
- timeBodyGyroscopeJerkXYZ
- timeBodyAccelerometerMagnitude
- timeGravityAccelerometerMagnitude
- timeBodyAccelerometerJerkMagnitude
- timeBodyGyroscopeMagnitude
- timeBodyGyroscopeJerkMagnitude
- frequencyBodyAccelerometerXYZ
- frequencyBodyAccelerometerJerkXYZ
- frequencyBodyGyroscopeXYZ
- frequencyBodyAccelerometerMagnitude
- frequencyBodyAccelerometerJerkMagnitude
- frequencyBodyGyroscopeMagnitude
- frequencyBodyGyroscopeJerkMagnitude

_NOTE: We will later see in the 'Process' section how the above mentioned variables were derived from the original dataset._

The set of variables that were extracted from the original dataset are:

- mean: Mean value
- std: Standard deviation

The complete list of variables can be viewed in the original [dataset zip file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).


## Assumptions

The entire data cleansing process assumes that the [dataset zip file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) is _already_ downloaded and saved in the _working_ directory. 


## Process

### Merge training sets and test sets to create 1 dataset

The first step is to extract the data to the root folder using the 'unzip' command:

```r

unzip("getdata-projectfiles-UCI HAR Dataset.zip")
```


Once the directory is fully extracted, we need to transform the test and training datasets in a readable format, so it may be subsequently be used in data analyses.

The test dataset is combined with the subject IDs and activity IDs and saved in the 'test_set' variable:

```r
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
test_set <- cbind(subject_test, y_test, x_test)
```


The similar process is performed on the training dataset, which is saved in the 'train_set' variable:

```r
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
train_set <- cbind(subject_train, y_train, x_train)
```


Once the test and training datasets are converted in readable formats, they are both combined to make one consolidated dataset called 'compiled_set'...

```r
compiled_set <- rbind(train_set, test_set)
```


...and the columns are named appropriately:

```r
features <- read.table("./UCI HAR Dataset/features.txt")
colnames(compiled_set) <- c("subject", "activity", as.character(features[, 2]))
```



### Extract mean and standard deviation of each measurement

Now once we have given shape to the dataset, we need to filter out the variables relevant to the '_mean_' and '_standard deviation_'. These are the variables whose names either have 'mean()' or 'std()' in them.

_NOTE: Variables pertaining to_ **_'meanFreq()'_** _were not included in the extraction since it pertains to 'weighted average' means whereas the Course Project guidelines clearly specificy 'mean' and 'standard deviation'. Had they wanted to include 'meanFreq()' variables as well, it would have been explicitly specified; and as a result been included in the data gathering._

The mean, standard deviation, subject, and activity variables are extracted from the consolidated data,...

```r
dataMean <- compiled_set[, grepl("mean[^Freq]", colnames(compiled_set))]
dataStd <- compiled_set[, grep("std", colnames(compiled_set))]
dataSubject <- compiled_set[, grep("subject", colnames(compiled_set))]
dataActivity <- compiled_set[, grep("activity", colnames(compiled_set))]
```


...combined together...

```r
extMeanStd <- cbind(dataSubject, dataActivity, dataMean, dataStd)
```


...and appropriate column names are assigned to 'subject' and 'activity' variables.

```r
names(extMeanStd)[1] <- "subject"
names(extMeanStd)[2] <- "activity"
```



### Use descriptive activity names to name activities

In this task, the activity names and their respective IDs are loaded from the original source files...

```r
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels) <- c("activity", "activityLabels")
```


...and merged with the extracted data based on common activity IDs between the two tables. 

```r
extMeanStd <- merge(activity_labels, extMeanStd, by.x = "activity", by.y = "activity")
```


When merged, the activity ID variable does not have much value since the descriptive variable is now included. Therefore, it is removed from the table.

```r
extMeanStd[, 1] = NULL
```


### Label dataset with descriptive activities

Since the variable names are not elaborative and do not tell much about the data, we rename them for clarity. 

The renaming is done by expanding the abbreviations...

**_NOTE: The Readme file provided with the [source dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and the 3^rd section in this document encapsulates details through which the aforementioned abbreviations have been inferred and elaborated upon._**

```r
# Replace 't' with 'time'
colnames(extMeanStd) <- sub("^t", "time", colnames(extMeanStd))

# Replace 'f' with 'frequency'
colnames(extMeanStd) <- sub("^f", "frequency", colnames(extMeanStd))

# Replace 'Acc' with 'Accelerometer'
colnames(extMeanStd) <- sub("Acc", "Accelerometer", colnames(extMeanStd))

# Replace 'Gyro' with 'Gyroscope'
colnames(extMeanStd) <- sub("Gyro", "Gyroscope", colnames(extMeanStd))

# Replace 'mag' with 'Magnitude'
colnames(extMeanStd) <- sub("Mag", "Magnitude", colnames(extMeanStd))
```


...and removing unnecessary symbols and words.

```r
# Remove brackets and hiphens in labels
colnames(extMeanStd) <- gsub("\\-std\\(\\)(\\-)?", "Std", colnames(extMeanStd))
colnames(extMeanStd) <- gsub("\\-mean\\(\\)(\\-)?", "Mean", colnames(extMeanStd))
```


**_NOTE: Labels have been left in proper case to maintain readability, and that every word is easily identified. It is also more suitable to join variable names together rather than having them spaced out._**


### Create second independent tidy dataset with average of each variable of each activity and each subject.

Taking the averages of each variable of each activity and each subject becomes very simple by using the `aggregate()` function as shown below:

```r
avgMeanData <- aggregate(extMeanStd, list(extMeanStd$activityLabels, extMeanStd$subject), 
    mean)
```


Further, any unwanted columns are removed...

```r
avgMeanData[, 3] = NULL
avgMeanData[, 3] = NULL
```


...and suitable column names are added

```r
colnames(avgMeanData)[1:2] <- c("activity", "subject")
```


Finally, the final extracted data is saved:

```r
write.table(avgMeanData, "tidyset.txt")
```

