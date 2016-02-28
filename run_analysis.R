# A script to tidy data from the "Human Activity Recognition Using Smartphones" data set

library(dplyr)
library(stringr)

# Read feature names
features  <- read.csv("features.txt", stringsAsFactors = FALSE, header = FALSE, sep = "")
featuresNames <- features[, 2]

activities <- read.csv("activity_labels.txt", stringsAsFactors = FALSE, header = FALSE, sep = "")
activityLabels <- activities[, 2]

#Read testData
testSubs <- read.csv("test/subject_test.txt", stringsAsFactors = FALSE, header = FALSE)
names(testSubs) <- c("Subject")
testX  <- read.csv("test/X_test.txt", stringsAsFactors = FALSE, header = FALSE, sep = "")
names(testX) <- featuresNames
testLabels <- read.csv("test/y_test.txt", stringsAsFactors = FALSE, header = FALSE, sep = "")
names(testLabels) <- c("Activity")
testData <- cbind(testSubs, testLabels, testX)

#Read training data
trainSubs <- read.csv("train/subject_train.txt", stringsAsFactors = FALSE, header = FALSE)
names(trainSubs) <- c("Subject")
trainX  <- read.csv("train/X_train.txt", stringsAsFactors = FALSE, header = FALSE, sep = "")
names(trainX) <- featuresNames
trainLabels <- read.csv("train/y_train.txt", stringsAsFactors = FALSE, header = FALSE, sep = "")
names(trainLabels) <- c("Activity")
trainData <- cbind(trainSubs, trainLabels, trainX)

# Merge the two data sets
combinedData <- rbind(trainData, testData)

# Create dplyr table
dataTable <- tbl_df(combinedData)

# Clean up column names
names(dataTable) <- make.names(names(dataTable), unique = TRUE)

# Label activities correctly
dataTable <- mutate(dataTable, Activity = activityLabels[Activity])

# Select only mean and std values
validNames <- c(1, 2, grep(pattern = "mean|std", names(dataTable)))
meansAndSDs <- select(dataTable, validNames)

# Group by Subject and Activity
grouped <- group_by(meansAndSDs, Subject, Activity)

# Summarize each column
summary <- summarise_each(grouped, funs(mean))

# Write output
write.table(summary, file = "tidy-result.txt", row.names = FALSE)