# read csv file 
install.packages("csv")
library(csv)
mydata = read.csv("refine_original.csv")
install.packages("dplyr")
library(dplyr)
install.packages("tidyr")
library(tidyr)
#------------------------------------------
#1:Clean up brand names
refine_df1 <- mydata %>%
  # Extract first letter of company name
    mutate(first_letter = substr(tolower(company),1,1)) %>%
  # Modify the company name based on the first letter
    mutate(company = ifelse(first_letter == "p" | first_letter == "f", "philips",
                   ifelse(first_letter == "a", "akzo",
                   ifelse(first_letter == "v", "van houten",
                   ifelse(first_letter == "u", "unilever","unknown")))))
    refine_df1

#2:Separate Product code and number
refine_df2 <- refine_df1 %>%
  # Use separate from tidyr to split the column
    separate(Product.code...number,c("Product code", "Product Number"), sep = "-", remove = TRUE)
    refine_df2

#3:Add Product Categories
refine_df3 <- refine_df2 %>%
  # Add a new column Product Category based on the Product Column.
    mutate(Product_Category = ifelse(`Product code`== "p","Smartphone",
                                            ifelse(`Product code`=="x","Laptop",
                                            ifelse(`Product code`=="v", "TV",
                                            ifelse(`Product code`== "q", "Tablet", "Unknown")))))
    refine_df3

#4:Add full address for geocoding
    refine_df4 <- 
  # Add a new column full_address that concatenates the three address fields (address, city, country), separated by commas
  # using the unite function in tidyr
    unite(refine_df3, "full_address", 4:6, sep =",")
    refine_df4

#5: Create dummy variables for company and product category
    refine_df5 <- refine_df4 %>%
    mutate(company_philips = as.integer(company == "philips"),
          company_akzo = as.integer(company== "akzo"),
          company_van_houten= as.integer(company=="van houten"),
          company_unilever= as.integer(company == "unilever"),
          product_smartphone= as.integer(Product_Category=="Smartphone"),
          product_laptop= as.integer(Product_Category=="Laptop"),
          product_tv= as.integer(Product_Category=="TV"),
          product_tablet= as.integer(Product_Category=="Tablet"))

    refine_df5


#6: Write the clean data_frame to the csv

    refine_df <- write.csv(refine_df5, file ="refine_clean.csv", row.names = FALSE)
