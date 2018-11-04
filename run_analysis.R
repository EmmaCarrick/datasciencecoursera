run_analysis<- function(){
##load required libraries
library(dplyr)

##fetch the dataset
if(!file.exists("./wearables")){dir.create("./wearables")}
fileloc <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileloc, destfile = "wearables/dataset.zip")

##extract the datasets from the zip
unzip(zipfile = "./wearables/dataset.zip", exdir = "./wearables")

##read in the training and test data sets and give out column names that are OK for now
features <- read.csv("./wearables/UCI HAR Dataset/features.txt", header= FALSE, sep="")
trainset <- read.csv("./wearables/UCI HAR Dataset/train/X_train.txt", header= FALSE, sep="", col.names=features$V2)
testset <- read.csv("./wearables/UCI HAR Dataset/test/X_test.txt", header= FALSE, sep="", col.names=features$V2)
trainlabel <- read.csv("./wearables/UCI HAR Dataset/train/y_train.txt", header= FALSE, col.names = c("label"))
testlabel <- read.csv("./wearables/UCI HAR Dataset/test/y_test.txt", header= FALSE, col.names = c("label"))
trainsubj <- read.csv("./wearables/UCI HAR Dataset/train/subject_train.txt", header= FALSE, col.names = c("subject"))
testsubj <- read.csv("./wearables/UCI HAR Dataset/test/subject_test.txt", header= FALSE, col.names = c("subject"))

##bind the sets together
alltest<- cbind(testlabel, testsubj, testset)
alltrain<- cbind(trainlabel, trainsubj, trainset)
alldata <- rbind(alltest, alltrain)

##drop columns I dont want
alldata <- select(alldata, -contains("min"), -contains("max"), -contains("Coeff"), -contains("mad"), -contains("sma"),  -contains("nergy"), -contains("iqr"), -contains("entropy"), -contains("correl"), -contains("skew"),-contains("urtos"),-contains("Freq"))

#get activity names and swap them out - to do:  change to a loop
activity <- read.csv("./wearables/UCI HAR Dataset/activity_labels.txt", header = FALSE, sep="")
alldata$label <- gsub("1", activity[1,2], alldata$label)
alldata$label <- gsub("2", activity[2,2], alldata$label)
alldata$label <- gsub("3", activity[3,2], alldata$label)
alldata$label <- gsub("4", activity[4,2], alldata$label)
alldata$label <- gsub("5", activity[5,2], alldata$label)
alldata$label <- gsub("6", activity[6,2], alldata$label)

#fix up names, including writing the name mapping and the results to file.
nicenames <- c("activity","subject","meanbodyaccelerationxaxis","meanbodyaccelerationyaxis","meanbodyaccelerationzaxis"," stdevbodyaccelerationxaxis","stdevbodyaccelerationyaxis","stdevbodyaccelerationzaxis","meangravityaccelerationxaxis","meangravityaccelerationyaxis","meangravityaccelerationzaxis","stdevgravityaccelerationxaxis","stdevgravityaccelerationyaxis","stdevgravityaccelerationzaxis","meanbodyaccelerationjerkxaxis","meanbodyaccelerationjerkyaxis","meanbodyaccelerationjerkzaxis","stdevbodyaccelerationjerkxaxis","stdevbodyaccelerationjerkyaxis","stdevbodyaccelerationjerkzaxis","meanbodygyroscopexaxis","meanbodygyroscopeyaxis","meanbodygyroscopezaxis","stdevbodygyroscopexaxis","stdevbodygyroscopeyaxis","stdevbodygyroscopezaxis","meanbodygyroscopejerkxaxis","meanbodygyroscopejerkyaxis","meanbodygyroscopejerkzaxis","stdevbodygyroscopejerkxaxis","stdevbodygyroscopejerkyaxis","stdevbodygyroscopejerkzaxis","meanbodyaccelerationmagneticnetic","stdevbodyaccelerationmagnetic","meangravityaccelerationmagnetic","stdevgravityaccelerationmagnetic","meanbodyaccelerationjerkmagnetic","stdevbodyaccelerationjerkmagnetic","meanbodygyroscopemagnetic","stdevbodygyroscopemagnetic","meanbodygyroscopejerkmagnetic","stdevbodygyroscopejerkmagnetic","meanfbodyaccelerationxaxis","meanfbodyaccelerationyaxis","meanfbodyaccelerationzaxis","stdevfbodyaccelerationxaxis","stdevfbodyaccelerationyaxis","stdevfbodyaccelerationzaxis","meanfbodyaccelerationjerkxaxis","meanfbodyaccelerationjerkyaxis","meanfbodyaccelerationjerkzaxis","stdevfbodyaccelerationjerkxaxis","stdevfbodyaccelerationjerkyaxis","stdevfbodyaccelerationjerkzaxis","meanfbodygyroscopexaxis","meanfbodygyroscopeyaxis","meanfbodygyroscopezaxis","stdevfbodygyroscopexaxis","stdevfbodygyroscopeyaxis","stdevfbodygyroscopezaxis","meanfbodyaccelerationmagnetic","stdevfbodyaccelerationmagnetic","meanfbodybodyaccelerationjerkmagnetic","stdevfbodybodyaccelerationjerkmagnetic","meanfbodybodygyroscopemagnetic","stdevfbodybodygyroscopemagnetic","meanfbodybodygyroscopejerkmagnetic","stdevfbodybodygyroscopejerkmagnetic","anglebetweenmeanbodyaccelerationandmeangravity","anglebetweenmeanbodyaccelerationjerkandmeangravity","anglebetweenmeanbodygyroscopeandmeangravity","anglebeweenmeanbodygyroscopejerkandmeangravity","meananglexaxisgravity","meanangleyaxisgravity","meananglezaxisgravity")
originalnames <- names(alldata)
originalnames <- cbind(originalnames, nicenames)
write.csv(originalnames, "./wearables/namemapping.txt")
names(alldata) <- nicenames
write.csv(alldata, "./wearables/alldata.txt")

#make a separate summary table inc writing out to file
groupeddata<- alldata %>% group_by(activity, subject)
groupeddata <- groupeddata %>% summarise_all(mean)
write.csv(groupeddata, "./wearables/groupedmeans.txt")
groupeddata
}