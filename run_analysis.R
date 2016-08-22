## Coursera Reading and working with data course 
## August 22nd, 2016
## Jason Oliveira

## The project requested that the student achieve the following objectives: 
##  1) Merges the training and the test sets to create one data set.
##  2) Extracts only the measurements on the mean and standard deviation for each measurement.
##  3) Uses descriptive activity names to name the activities in the data set
##  4) Appropriately labels the data set with descriptive variable names.
##  5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## This resulting tidy data set was uploaded as part of the project submission

## Download the data in a default directory called /data. Check if it exists first off the current getwd() path

if(!file.exists("./data")){dir.create("./data")}

## assign the file name provided in the assignment
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## Download the file to the /data directory
download.file(URL,destfile="./data/week4dataset.zip")

## it is a zipped file, unzip it in place
unzip(zipfile="./data/week4dataset.zip",exdir="./data")

## There is a new subdirectory, set it for future reference
pathds <- file.path("./data" , "UCI HAR Dataset")

## let us store a list of the files
dsfiles<-list.files(pathds, recursive=TRUE)

## Read the three subject area files for test and train data:activity, subject, features

## Read activities
activitytest  <- read.table(file.path(pathds, "test" , "Y_test.txt" ),header = FALSE)
activitytrain <- read.table(file.path(pathds, "train", "Y_train.txt"),header = FALSE)
## Read Subjects
subjecttrain <- read.table(file.path(pathds, "train", "subject_train.txt"),header = FALSE)
subjecttest  <- read.table(file.path(pathds, "test" , "subject_test.txt"),header = FALSE)
## Read Features
featurestest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
featurestrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)


## 1.  Merge the test and training data sets for the three subject areas
subjectmrg <- rbind(subjecttrain, subjecttest)
activitymrg <- rbind(activitytrain, activitytest)
featuresmrg<- rbind(featurestrain, featurestest)

##  Give the v1 default name a more meaningful name
names(subjectmrg)<-c("subject")
names(activitymrg)<- c("activity")

## read the variable names of features which has many variables
featuresvarnames <- read.table(file.path(pathds, "features.txt"),head=FALSE)
names(featuresmrg)<- featuresvarnames$V2

## Finally, merge all three data sets
combinedds2 <- cbind(subjectmrg, activitymrg)
combinedds3 <- cbind(featuresmrg, combinedds2)

## 2.  Extract only the mean and stdv measures
##  First find the variable names for mean and std using the patterns
meanstdfeaturesnames<- featuresvarnames$V2[grep("mean\\(\\)|std\\(\\)", featuresvarnames$V2)]

##  Use the select function to take only those measures for mean and stf
selectednames<-c(as.character(meanstdfeaturesnames), "subject", "activity" )
finalds <- subset(combinedds3,select=selectednames)

## 3. Create more descriptive activity names as a factored vector
## Transform activities into more descriptive factor labels
l <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
factor(finalds$activity,labels=l)

## 4. transform the feature column names to more descriptive ones
names(finalds)<-gsub("^t", "time", names(finalds))
names(finalds)<-gsub("^f", "frequency", names(finalds))
names(finalds)<-gsub("Acc", "Accelerometer", names(finalds))
names(finalds)<-gsub("Gyro", "Gyroscope", names(finalds))
names(finalds)<-gsub("Mag", "Magnitude", names(finalds))
names(finalds)<-gsub("BodyBody", "Body", names(finalds))

## 5.  Create the tidy data set
library(plyr)
meands<-aggregate(. ~subject + activity, finalds, mean)
meands<-meands[order(meands$subject,meands$activity),]
write.table(meands, file = "tidy_data Oliveira.txt",row.name=FALSE)



## end assignment 
