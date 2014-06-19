# -------------------------------------------------------------------------------
# get the code locally
# -----------------------------------------------------------------
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
local_name <- "HAR.zip"
download.file(url=url,dest=local_name)
# unzip the file --------------------
unzip(local_name)
# --- names of the files --------------
# -- "X_test.txt"                                                                                  
# -- "X_train.txt"                                                                                 
# -- "y_test.txt"                                                                                  
# -- "y_train.txt"
# -- "subject_test.txt"                                                                            
# -- "subject_train.txt"
# - y_train/test text file,        it contains  activity id 
# - subject_test/train text files, it contains  subject IDs   
# - features.txt                   it contains 561 col names

# - readin files test 2947 Rows x=561cols y=1col s=1col
x_test<-read.table("X_test.txt")
y_test<-read.table("y_test.txt")
s_test<-read.table("subject_test.txt")
# - readin files train 7352 Rows x=561cols y=1col s=1col
x_train<-read.table("X_train.txt")
y_train<-read.table("y_train.txt")
s_train<-read.table("subject_train.txt")

#-- get column names and make ik character vector --------------
feat<-read.table("features.txt")
featn<-as.character(feat$V2)

# -- replace activity id with correct name
# -- rbind y-test and y-train 10299/1
y_test_train<-rbind(y_test,y_train)
s_test_train<-rbind(s_test,s_train)

c_y_test_train<-as.character(y_test_train$V1)
c1_test_train <-gsub("1","WALKING",c_y_test_train)
c2_test_train <-gsub("2","WALKING_UPSTAIRS",c1_test_train)
c3_test_train <-gsub("3","WALKING_DOWNSTAIRS",c2_test_train)
c4_test_train <-gsub("4","SITTING",c3_test_train)
c5_test_train <-gsub("5","STANDING",c4_test_train)
df_test_train <-gsub("6","LAYING",c5_test_train)
colnames(df_test_train)<-"activity_id"
# -- change header names

names(s_test)<-"S1"

# - rbind x_test x_train  together  10299/561
test_train<-rbind(x_test,x_train)

# dim test        2947 561
# dim train       7352 561
# dim test_train 10299 561


# -- select columns based on name 
mean_test_train<-test_train[ , grep("-mean", names(test_train)) ] 
std_test_train<-test_train[ , grep("-std", names(test_train)) ] 
mean_std_test_train<-cbind(mean_test_train,std_test_train)

# - dim 10299    79     mean=46 std=33 rows=10299
tot_df<-cbind(mean_std_test_train,df_test_train,s_test_train)
# -- assign colnames to df
#featn[length(featn)+1]<-"activity_id"
colnames(test_train)<-featn
names(tot_df)[names(tot_df) == 'df_test_train' ] <-'activity_id'
names(tot_df)[names(tot_df) == 'V1' ] <-'subject_id'

write.table(tot_df,file="Mean_std.txt")


n_test_train<-cbind(test_train,df_test_train,s_test_train)
names(n_test_train)[names(n_test_train) == 'df_test_train' ] <-'activity_id'
names(n_test_train)[names(n_test_train) == 'V1' ] <-'subject_id'
dt<-data.table(n_test_train)
dm<-dt[,list(mean=mean(1:561)),by="activity_id,subject_id"]

write.table(dm,file="mean_act_subj.txt")