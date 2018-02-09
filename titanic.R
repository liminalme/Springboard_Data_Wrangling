# read csv file 
install.packages("csv")
library(csv)
mydata = read.csv("titanic_original.csv")
View(mydata)
install.packages("dplyr")
library(dplyr)
install.packages("tidyr")
library(tidyr)

refine <- mydata %>% 
  mutate(
    #1: Port of embarkation 
        embarked= replace(embarked,embarked == "","S"),
    #2: Age
       age= replace(age, is.na(age), round(mean(age,na.rm= TRUE))),
    #3: Lifeboat
        boat= replace(boat, boat =="", "None"),
    #4: Cabin
        has_cabin_number = ifelse(cabin == "",0,1)) %>% trunc(age)

refine_df <- write.csv(refine, file ="titanic_clean.csv", row.names = FALSE)


