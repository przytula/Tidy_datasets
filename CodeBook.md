-------------------------------------------------------------------------
COOKBOOK -  Getting and cleaning data : assignment project - tidy datasets
-------------------------------------------------------------------------
# -------------------------------------------------------------------------------
# get the data locally
# -----------------------------------------------------------------
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
First we get the data from indicated URL and get it to your working directory
unzip the file and get a file structure : train - test and other
# unzip the file --------------------
# --- names of the files ---------------------------------------------------------------
# -- "X_test.txt"                  this file keeps all measurements                                                                
# -- "X_train.txt"                 this file keeps all measurements                                                                
# -- "y_test.txt"                  activity id                                                                
# -- "y_train.txt"                 activity id
# -- "subject_test.txt"            subject ID                                                                
# -- "subject_train.txt"           subject ID
# - y_train/test text file,        it contains  activity id 
# - subject_test/train text files, it contains  subject IDs   
# - features.txt                   it contains 561 col names
# ------------------------------------------------------------------------------------
# - readin files all files with read.table
# - x_test y_test s_test x_train y_train s_train : x_%%%.txt  y_%%%.txt  subject_%%%.txt   feat from features.txt
# -- test = 2947 Rows x=561 cols y=1 col s=1 col
# -- train = 7352 Rows x=561 cols y=1 col s=1 col
# -------------------------------------------------------------------------------------
x_test<-read.table("X_test.txt")
y_test<-read.table("y_test.txt")
s_test<-read.table("subject_test.txt")
x_train<-read.table("X_train.txt")
y_train<-read.table("y_train.txt")
s_train<-read.table("subject_train.txt")
feat<-read.table("features.txt")
# --------------------------------------------------------------------
# -- translate the column with column headers to character vector ------------------
# --------------------------------------------------------------------
featn<-as.character(feat$V2)
# --------------------------------------------------------------------
# -- rbind y-test and y-train 10299/1
# --------------------------------------------------------------------
y_test_train<-rbind(y_test,y_train)
s_test_train<-rbind(s_test,s_train)
# --------------------------------------------------------------------
# -- replace activity id with correct name
# --------------------------------------------------------------------
c_y_test_train<-as.character(y_test_train$V1)
c1_test_train <-gsub("1","WALKING",c_y_test_train)
c2_test_train <-gsub("2","WALKING_UPSTAIRS",c1_test_train)
c3_test_train <-gsub("3","WALKING_DOWNSTAIRS",c2_test_train)
c4_test_train <-gsub("4","SITTING",c3_test_train)
c5_test_train <-gsub("5","STANDING",c4_test_train)
df_test_train <-gsub("6","LAYING",c5_test_train)
colnames(df_test_train)<-"activity_id"
# ------------------------------------------------------------------------------------------
# -- change header names
# ------------------------------------------------------------------------------------------
names(y_test)<-"Y1"
names(s_test)<-"S1"
# ------------------------------------------------------------------------------------------
# - cbind x-y-subject together test
# ------------------------------------------------------------------------------------------
test<-cbind(x_test,y_test,s_test)
# ------------------------------------------------------------------------------------------
# - cbind x-y-subject together train
# ------------------------------------------------------------------------------------------
train<-cbind(x_train,y_train,s_train)
# ------------------------------------------------------------------------------------------
# - rbind test train  together  10299/561
# ------------------------------------------------------------------------------------------
test_train<-rbind(test,train)
# ------------------------------------------------------------------------------------------
# dim test        2947 561
# dim train       7352 561
# dim test_train 10299 561
# ------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------
# -- assign colnames to df : we take the data from feature vector and use it as column names
# ------------------------------------------------------------------------------------------
colnames(test_train)<-featn
# ------------------------------------------------------------------------------------------
# -- select columns based on name : we only need the mean and std measurements in a different dataset
# ------------------------------------------------------------------------------------------
mean_test_train<-test_train[ , grep("-mean", names(test_train)) ] 
std_test_train<-test_train[ , grep("-std", names(test_train)) ] 
# ----------------------------------------------------------------------------
# - dim 10299    79     mean=46 std=33 rows=10299
# ------------------------------------------------------------------------------------------
# create df from selected columns
# ------------------------------------------------------------------------------------------
tot_df<-cbind(mean_std_test_train,df_test_train,s_test_train)
# ------------------------------------------------------------------------------------------
# -- assign colnames to df
# ------------------------------------------------------------------------------------------
names(tot_df)[names(tot_df) == 'df_test_train' ] <-'activity_id'
names(tot_df)[names(tot_df) == 'V1' ] <-'subject_id'
# -----------------------------------------------------------------------------------------
#  write out the df to a file 
# ------------------------------------------------------------------------------------------
write.table(tot_df,file="Mean_std.txt")


# ------------------------------------------------------------------------------------------
# for the second dataset we can re-use part of the data
# ------------------------------------------------------------------------------------------
n_test_train<-cbind(test_train,df_test_train,s_test_train)
names(n_test_train)[names(n_test_train) == 'df_test_train' ] <-'activity_id'
names(n_test_train)[names(n_test_train) == 'V1' ] <-'subject_id'
# ------------------------------------------------------------------------------------------
# now calculate the mean and group by activity and subject
# ------------------------------------------------------------------------------------------
dt<-data.table(n_test_train)
dm<-dt[,list(mean=mean(1:561)),by="activity_id,subject_id"]
# ------------------------------------------------------------------------------------------
# write out the df to file
# ------------------------------------------------------------------------------------------
write.table(dm,file="mean_act_subj.txt")
