#install necessary libraries
library(plyr)

# create the datasets from the text files
xtest<-read.table("./UCI HAR Dataset/test/X_test.txt")
xtrain<-read.table("./UCI HAR Dataset/train/X_train.txt")
activity_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
activity_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
features<-read.table("./UCI HAR Dataset/features.txt")
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")
names(activity_labels)<-c("activity_num","activity_name")

#combine subjects, activities and results in 1 table for both test and training data
test_data<-cbind(subject_test,cbind(activity_test,xtest))
train_data<-cbind(subject_train,cbind(activity_train,xtrain))

#combine test and train datasets
merged_data<-rbind(test_data,train_data)

#name merged data set
names(merged_data)<-c("subject_num","activity_num",as.character(features[,2]))

#subset merged_data set to only include means and std
idx_mean<-grep("mean", names(merged_data))
idx_Mean<-grep("Mean", names(merged_data))
idx_std<-grep("std", names(merged_data))
extracted_data<-merged_data[,c(1,2,sort(c(idx_mean,idx_Mean,idx_std)))]

#Change activity numbers to descriptive activity names
friendly_data<-join(extracted_data, activity_labels, by = "activity_num", type = "left", match = "all")
friendly_data<-friendly_data[,c(1,89,3:88)]

#Create a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data<-aggregate(friendly_data[,3:88],by=list(friendly_data$subject_num,friendly_data$activity_name),mean,simplify=TRUE)
names(tidy_data)[1]<-"subject"
names(tidy_data)[2]<-"activity"
