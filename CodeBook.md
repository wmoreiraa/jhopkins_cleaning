CodeBook
--------

-   The first few lines of code is the task of importing the variables
    and assigning them to temporary variables
-   After reading the data, we have two datasets named train\_df and
    test\_df. The dimonensions of each dataset is listed below. Both of
    the datasets already contains the activity label.

<!-- -->

    dim(test_df)

    ## [1] 2947  562

    dim(train_df)

    ## [1] 7352  562

-   Then, we bind use tidyverse::bind\_rows(test\_df, train\_df) to
    create the complete\_df dataframe.

-   Now the step **2** says to only extract the measurements on mean and
    std. Because of this, there’s two interpretations possible: With and
    without the angle measurements. I understood that angle(mean,
    random\_vector) it is not a measurement on mean as required.
    Consequently:

<!-- -->

    read_tsv("final_merged.txt") %>% dim

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_double(),
    ##   activity_name = col_character()
    ## )

    ## See spec(...) for full column specifications.

    ## [1] 10299    68

-   Read the acitivity\_labels.txt and assign correspondent label to the
    dataframe.

<!-- -->

    avg_df <- avg_df %>% 
       mutate( 
          activity_name = case_when( label == 1 ~ "walking",
                                     label == 2 ~ "walking_upstairs",
                                     label == 3 ~ "walking_downstairs",
                                     label == 4 ~ "sitting",
                                     label == 5 ~ "standing",
                                     label == 6 ~ "laying"))

-   We clean the names of the dataset using the function
    janitor::clean\_names()
-   Then, we change to be more readable:

gyro = gyroscope acc = accelerometer mag = magnitude body\_body = body
t\_ = time f\_ = frequency

-   Finally, we create the final\_tidy.txt . The first column is the
    “subject” ID and the second one is the activity\_name. The others 66
    variables are the grouped measurements.

**All the code uses only tidyverse and janitor packages.**
