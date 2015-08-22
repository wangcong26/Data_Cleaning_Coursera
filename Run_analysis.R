
#0.read dataset
features <- read.table("features.txt")
activities <- read.table("activity_labels.txt")
xtrain<-read.table("X_train.txt")
subject_train <- read.table("subject_train.txt")
ytrain <- read.table("y_train.txt")
xtest<-read.table("X_test.txt")
subject_test<-read.table("subject_test.txt")
ytest <- read.table("y_test.txt")

#1.merge two dataset
test=cbind(ytest,subject_test,xtest)
train=cbind(ytrain,subject_train,xtrain)
final_merged=rbind(test,train)
final_merged_label=colnames(final_merged)

#2.Extract only the measurements on the mean and standard deviation for each measurement.
std_mean_label <- grep(".*mean.*|.*std.*", features[,2])
sub_xtrain <- xtrain[std_mean_label]
sub_xtest <-xtest[std_mean_label]
final_train <-cbind(subject_train,ytrain,sub_xtrain)
final_test <-cbind(subject_test,ytest,sub_xtest)
alldata <- rbind(final_train, final_test)

#3.Uses descriptive activity names to name the activities in the data set
alldata[,2] <- activities[alldata[,2], 2]


#4.Appropriately labels the data set with descriptive variable names.  

sub_label<-as.character(features[std_mean_label,2])
final_merged_label<-c("subject", "activity", sub_label)
colnames(alldata)<-final_merged_label

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
averages_data <- ddply(alldata, .(subject, activity), function(x) colMeans(x[, 3:81]))
write.table(averages_data, "averages_data.txt", row.name=FALSE)

