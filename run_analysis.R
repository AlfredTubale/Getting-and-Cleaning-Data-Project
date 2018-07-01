# 1.) Downloading and Unzipping the Data

  #create new local folder named on the current working directory
  if(!file.exists("./data")){dir.create("./data")}   

  #download the dataset and place it on the created local folder with name "Dataset.zip"
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl,destfile="./data/Dataset.zip") #

  #Unzip dataset and place it under the /data directory
  unzip(zipfile="./data/Dataset.zip",exdir="./data") 


#2.) Merges the training and the test sets to create one data set
  
  #Reading all the necessary files
  
      # Read test tables:
      X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
      Y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
      subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
      
      
      # Read training tables:
      X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
      Y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
      subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
      
      # Read features:
      features <- read.table('./data/UCI HAR Dataset/features.txt')
      
      # Read activity labels:
      activity_labels = read.table('./data/UCI HAR Dataset/activity_labels.txt')
      

  #Assigning appropriate column names
 
      #Use fields of features table to replace column names of X_test
      colnames(X_test) <- features[,2] 
      #Assign activityID as the name for Y_test
      colnames(Y_test) <- "activityId"
      #Each row identifies the subject who performed the activity for each window sample
      colnames(subject_test) <- "subjectId"

      
      #Use fields of features table to replace column names of X_train      
      colnames(X_train) <- features[,2] 
      #Assign activityID as the name for Y_train
      colnames(Y_train) <-"activityId"
      #Each row identifies the subject who performed the activity for each window sample
      colnames(subject_train) <- "subjectId"
      
      
      colnames(activity_labels) <- c('activityId','activityType')
      
  #Merging test and training data into one 

      merged_test <- cbind(Y_test, subject_test, X_test)      
      merged_train <- cbind(Y_train, subject_train, X_train)
      merged_train_test <- rbind(merged_train,merged_test)
      

#3.) Keeps only those columns that reflects mean and standard deviation measurement

  #Setting up all the COlumns Names  
      
      colNames <- colnames(merged_train_test)
      
  #Creating a vector that will define what column names matches the pattern ID, mean and std
  #This will return a set of logical values  (TRUE or FALSE) correspondent to each column name
      colnames_for_mean_and_std <- (grepl("activityId" , colNames) | 
                         grepl("subjectId" , colNames) | 
                         grepl("mean.." , colNames) | 
                         grepl("std.." , colNames) 
                      )
      
  #Create subset of the merged_train_test table that will only return TRUE 
  #TRUE means columns with names that matches the pattern ID, mean and std
      table_for_mean_and_std<- merged_train_test[ , colnames_for_mean_and_std == TRUE]
      
#4.) Uses descriptive activity names to name the activities in the data set.

  
  #Add the variable activity_labels using 'activityID' as the joining variable
      with_activitynames <- merge(table_for_mean_and_std, activity_labels,
                                    by='activityId',
                                    all.x=TRUE)
      
  #Rearrange columns (Subjectid,AcitivityType,Features...)
  #Note this will eliminate activityID
      with_activitynames2 <- with_activitynames[,c(2,82,3:81)]
      
  #Rename SubjecID to Subject
      colnames(with_activitynames2)[colnames(with_activitynames2)=="subjectId"] <- "Subject"
      
  #Rename activityType to Actvity
      colnames(with_activitynames2)[colnames(with_activitynames2)=="activityType"] <- "Activity"   
      
      
#5.) create a second, independent tidy data set with the average of each variable for each activity and each subject.
      

  #Provide the mean of each  unique subject and activity 
      Tidy <- aggregate(. ~Subject + Activity, with_activitynames2, mean)
      
  #Order rows by subject and activity for easy reading  
      Tidy<- Tidy[order(Tidy$Subject, Tidy$Activity),]
      
    
#6.) Extract tidy dataset in a txt file
      write.table(Tidy, "Tidy.txt", row.name=FALSE)
      