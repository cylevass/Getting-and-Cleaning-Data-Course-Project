### Created by Cyril ; 2016-07-28
### Goal : 
### 1. Merges the training and the test sets to create one data set.
### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
### 3. Uses descriptive activity names to name the activities in the data set
### 4. Appropriately labels the data set with descriptive variable names.
### 5. From the data set in step 4, creates a second, independent tidy data set with the
### average of each variable for each activity and each subject.


### 1. Merges the training and the test sets to create one data set.
### Load the 2 files (test and train) and bind them 
my_data_test <- read.csv(file = "./UCI HAR Dataset/test/X_test.txt",header = FALSE,sep = "")
###sep = "" to avoid the multiples spaces
my_data_train <- read.csv(file = "./UCI HAR Dataset/train/X_train.txt",header = FALSE,sep = "")

### bind of the 2 dataframes
my_data_total <- rbind(my_data_test,my_data_train)

### load of the names of the columns which are the variables defined in features.txt
my_col_name <- read.csv(file = "./UCI HAR Dataset/features.txt",header = FALSE,sep = "")
### rename of the columns (which corresponds to the point 4.)
names(my_data_total) <- my_col_name[,2]

### 2. Extracts only the measurements on the mean and standard deviation for each measurement
### we keep only the data of the columns that contain "mean" or "std" in their names
my_data_total_subset <- my_data_total[,grep(pattern = "mean|std",x = names(my_data_total))]

### now we are going to add the column ID.Volunteer
### this data in stored in subject_test.txt and subject_train.txt
my_subject_test <- read.csv(file = "./UCI HAR Dataset/test/subject_test.txt",header = FALSE,sep = "")
my_subject_train <- read.csv(file = "./UCI HAR Dataset/train/subject_train.txt",header = FALSE,sep = "")
### bind of the 2 dataframes
my_subject_total <- rbind(my_subject_test,my_subject_train)
### rename the column
names(my_subject_total) = "Id.Volunteer"

### now we are going to add the column Activity
### this data in stored in y_test.txt and y_train.txt
my_activities_test <- read.csv(file = "./UCI HAR Dataset/test/y_test.txt",header = FALSE,sep = "")
my_activities_train <- read.csv(file = "./UCI HAR Dataset/train/y_train.txt",header = FALSE,sep = "")
### bind of the dataframes
my_activities_total <- rbind(my_activities_test,my_activities_train)

#3. Uses descriptive activity names to name the activities in the data set
my_activity_labels <- read.csv(file = "./UCI HAR Dataset/activity_labels.txt",header = FALSE,sep = "")
my_activities_total_with_labels <- merge(x = my_activities_total,y = my_activity_labels,by.x = "V1",by.y = "V1",all.x = TRUE, sort = FALSE)
names(my_activities_total_with_labels) <- c("Id.Activity","Activity")

### Final binding of all the dataframes
my_tidy_data_set <- cbind(my_subject_total,my_position_total_labels$Activity,my_data_total_subset)
names(my_tidy_data_set)[2] <- "Activity"


### 5. From the data set in step 4, creates a second, independent tidy data set with the
### average of each variable for each activity and each subject.
### use of the package dplyr, which contains the function summarise_each that permitts to do the job in one line
library(dplyr)
my_means_by_Volunteer_and_Activity <- my_tidy_data_set %>%
    group_by(Id.Volunteer,Activity) %>% 
        summarise_each(funs(mean))

### First rows and columns of the data_set are these
### > my_tidy_data_set[1:5,1:10]

# Id.Volunteer Activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y
# 1            2 STANDING         0.2571778       -0.02328523       -0.01465376       -0.9384040       -0.9200908
# 2            2 STANDING         0.2860267       -0.01316336       -0.11908252       -0.9754147       -0.9674579
# 3            2 STANDING         0.2754848       -0.02605042       -0.11815167       -0.9938190       -0.9699255
# 4            2 STANDING         0.2702982       -0.03261387       -0.11752018       -0.9947428       -0.9732676
# 5            2 STANDING         0.2748330       -0.02784779       -0.12952716       -0.9938525       -0.9674455

### First rows and columns of the data_set summarised are these
### > my_means_by_Volunteer_and_Activity[1:5,1:10]
# Id.Volunteer Activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y
# <int>   <fctr>             <dbl>             <dbl>             <dbl>            <dbl>            <dbl>
# 1            1  SITTING         0.2656969       -0.01829817        -0.1078457       -0.5457953       -0.3677162
# 2            2 STANDING         0.2731131       -0.01913232        -0.1156500       -0.6055865       -0.4289630
# 3            3  SITTING         0.2734287       -0.01785607        -0.1064926       -0.6234136       -0.4800159
# 4            4 STANDING         0.2741831       -0.01480815        -0.1075214       -0.6052117       -0.5099294
# 5            5   LAYING         0.2796301       -0.01731959        -0.1048186       -0.4207361       -0.3182870

### > write.table(x = my_tidy_data_set, file = "./my_tidy_data_set.csv", row.name=FALSE)
### > write.table(x = my_means_by_Volunteer_and_Activity, file = "./my_means_by_Volunteer_and_Activity.csv", row.name=FALSE)
