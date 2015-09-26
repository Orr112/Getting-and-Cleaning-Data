library(dplyr)
### Part 1: Merging Data Sets.

# Download Test and Training Data Set
testData <- read.table("./Project/X_test.txt")
trainData <- read.table("./Project/X_train.txt")

# Merger Data Sets
mrgData <- merge(trainData, testData, all=TRUE)

### Part 2: Extraction of Mean and Standard Deviation.

#subject test
##sbt <- read.table("./Project/subject_test.txt")
head(sbt)

# Download Feastures List
ftr <- read.table("./Project/features.txt", col.names=c("Col.Nu","Name"))
ftr


# Extracting Mean and Standard Deviation objects from features file
ftrMS <- ftr[grepl("mean",ftr$Name,fixed=TRUE) |
                 grepl("std",ftr$Name, fixed =TRUE),]

# Extract columns 
ftrX <- mrgData[,ftrMS$Col.Nu]

### Part 3: Relabel Activity labels

# Read Activity Labels
actL <- read.table("./Project/activity_labels.txt", col.names=c("Label","Activity"))
str(atcL)


#Bind Activity labels for Test and Training Data
ytest <- read.table("./Project/y_test.txt", col.names="id") 
ytrain <- read.table("./Project/y_train.txt", col.names="id")
mrgAL <- rbind(ytrain,ytest)



#Relabel factors
library(plyr)
mrgAL$id[mrgAL$id ==1] <- "WALKING"
mrgAL$id[mrgAL$id ==2] <- "WALKING_UPSTAIRS"
mrgAL$id[mrgAL$id ==3] <- "WALKING_DOWNSTAIRS"
mrgAL$id[mrgAL$id ==4] <-"SITTING"
mrgAL$id[mrgAL$id ==5] <- "STANDING"
mrgAL$id[mrgAL$id ==6] <- "LAYING"

### Part 4: Label Data Set with Descriptive Variable Names.

#Read Subject Test and Training Data
testSBJ <- read.table("./Project/subject_test.txt")
trainSBJ <- read.table("./Project/subject_train.txt")


#Row Binding Test and Training Data sets
rbSBJ <- rbind(trainSBJ,testSBJ)
str(sbjRB)


#Column Bind Data on Subjects, Activities and Mean
tData <- cbind(rbSBJ, mrgAL,ftrX)


#Naming Data variables/columns
names(tData) <- c("Subject","Activity",as.character(ftrMS$Name))
a)


###Part 5 - Create Second Data Set of Means
# Pipe Average into grouped Subjects and Activites of 1st Data Set
tData2 <- tData %>% group_by(Subject, Activity) %>% summarise_each(funs(mean))


# Name variables for Second Data set.
names(tData2) <- c("Subject","Activity", sapply(ftrMS$Name, function(name) paste('avg', name, sep='.')))

### Saving File

#Write 2nd Data Set to File
write.table(tData2,file="tData2.txt", row.names=FALSE)
