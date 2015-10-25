library(reshape2)

filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
#if (!file.exists(filename)){
 # fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  #download.file(fileURL, filename, method="curl")
#}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Load activity labels + features
aL <- read.table("UCI HAR Dataset/activity_labels.txt")
aL[,2] <- as.character(aL[,2])
feat <- read.table("UCI HAR Dataset/features.txt")
feat[,2] <- as.character(feat[,2])

# Extract only the data on mean and standard deviation
fW <- grep(".*mean.*|.*std.*", feat[,2])
fW.names <- features[fW,2]
fW.names = gsub('-mean', 'Mean', fW.names)
fW.names = gsub('-std', 'Std', fW.names)
fW.names <- gsub('[-()]', '', fW.names)


# Load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[fW]
trainAct <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSub <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSub, trainAct, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[fW]
testAct <- read.table("UCI HAR Dataset/test/y_test.txt")
testSub <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSub, testAct, test)

# merge datasets and add labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", fW.names)

# turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = aL[,1], labels = aL[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)