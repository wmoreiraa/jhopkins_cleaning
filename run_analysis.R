# Author : Walber Moreira
# Date : 2020-05-30
# Getting and cleaning Data Course Project


# Packages ----

library(markdown)
library(tidyverse)
library(janitor)

# Importing -----
feat_names <- read_delim(file = "rdata/features.txt",
                         delim = " ",
                         col_names = FALSE,
                         trim_ws = TRUE)

feat_names <- feat_names$X2

train_x <- read_delim(file = "rdata/train/X_train.txt",
                    delim = " ",
                    col_names = feat_names,
                    trim_ws = TRUE)

test_x <- read_delim(file = "rdata/test/X_test.txt",
                      delim = " ",
                      col_names = feat_names,
                      trim_ws = TRUE)

test_y <- read_delim(file = "rdata/test/y_test.txt",
                                delim = "\n",
                                col_names = "label")


train_y <- read_delim(file = "rdata/train/y_train.txt",
                      delim = "\n",
                      col_names = "label")

train_subject <- read_delim(file = "rdata/train/subject_train.txt",
                            delim = "\n",
                            col_names = "subject")

test_subject <- read_delim(file = "rdata/test/subject_test.txt",
                           delim = "\n",
                           col_names = "subject")  

# Wrangling -----

## 1. Merge both the datasets into one

# Now we have the train predictors dataset with column names,
# we need to join with the row labels.


train_df <- bind_cols(train_y, train_x)
test_df <- bind_cols(test_y, test_x)

# Now we have the train dataset with labels and column names.


# We need to  bind the subject.

test_df <- bind_cols(test_subject, test_df)
train_df <- bind_cols(train_subject, train_df)

# Bind into the complete dataset

complete_df <- bind_rows(train_df,test_df)

# We will use the janitor::clean_names so the features names become readable.

complete_df <- complete_df %>% clean_names()

## 2. Extract only the measuraments on mean and std

avg_df <- complete_df %>% 
   select(contains(c("mean","std"))) %>%
   select(-contains(c("mean_freq","angle"))) %>%
   bind_cols(subject = complete_df$subject) %>%
   bind_cols(label = complete_df$label)
   
## 3. Uses descriptive activity names to name the activities in the data set

avg_df <- avg_df %>%
   mutate(
      activity_name = case_when( label == 1 ~ "walking",
                                 label == 2 ~ "walking_upstairs",
                                 label == 3 ~ "walking_downstairs",
                                 label == 4 ~ "sitting",
                                 label == 5 ~ "standing",
                                 label == 6 ~ "laying")
   )

## 4. Appropriately labels the data set with descriptive variable names.

avg_df %>% names

# We will change some understandable parts of the variable name to one more
#compreheensible 

# gyro = gyroscope
# acc = accelerometer 
# mag = magnitude 
# body_body = body
# t_ = time
# f_ = frequency 

# Renaming:
names(avg_df) <- names(avg_df) %>% str_replace_all(pattern = "gyro", replacement = "gyroscope")
names(avg_df) <- names(avg_df) %>% str_replace_all(pattern = "acc", replacement = "accelerometer")
names(avg_df) <- names(avg_df) %>% str_replace_all(pattern = "mag", replacement = "magnitude")
names(avg_df) <- names(avg_df) %>% str_replace_all(pattern = "body_body", replacement = "body")
names(avg_df) <- names(avg_df) %>% str_replace_all(pattern = "t_", replacement = "time_")
names(avg_df) <- names(avg_df) %>% str_replace_all(pattern = "f_", replacement = "frequency_")

# 5. From the data set in step 4, creates a second, independent tidy data 
#set with the average of each variable for each activity and each subject.

avg_grouped_df <- avg_df %>%
   select(-label) %>%
   group_by(subject, activity_name) %>%
   summarize_all(.funs = mean)


final_tidydata <- avg_grouped_df
final_mergeddata <- avg_df %>% select(-label)

# Exporting to txt submission files

write_tsv(final_tidydata, path = "final_tidy.txt", col_names = TRUE)
write_tsv(final_mergeddata, path = "final_merged.txt", col_names = TRUE)




                 














