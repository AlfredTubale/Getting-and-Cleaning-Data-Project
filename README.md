# Getting-and-Cleaning-Data-Project

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, does the following:

1. Downloads the dataset if it does not already exist in the working directory and Unzips the dataset
2. Assigns appropriate column names on the 2 datasets (training and the test) and merges them to create one data set
3. Keeps only those columns that reflects mean and standard deviation measurement
4. Uses descriptive activity names to name the activities in the data set.
5. Creates an independent tidy data set with the average of each variable for each `activity` and each `subject`.
6. Extract tidy dataset in a txt file - "Tidy.txt".
      
