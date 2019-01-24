#Crime Data: Île de France

library(readxl)
crime <- read_excel("data/tableaux-4001-ts.xlsx")

library(dplyr)
library(tidyverse)
library(hrbrthemes)

crime$a2018 <- rowSums(crime[,c(3:14)])
crime$a2017 <- rowSums(crime[,c(15:26)])
crime$a2000 <- rowSums(crime[,c(219:230)])

# Download all crimes in 2017 and 2018. Focus on departments: 75, 77, 78, 91, 92, 93, 94, 95

library(readxl)
dep75 <- read_excel("data/tableaux-4001-ts.xlsx", 
                    sheet = "75")
dep75$a2018 <- rowSums(dep75[,c(3:14)])
dep75$a2017 <- rowSums(dep75[,c(15:26)])

dep77 <- read_excel("data/tableaux-4001-ts.xlsx", 
                    sheet = "77")
dep77$a2018 <- rowSums(dep77[,c(3:14)])
dep77$a2017 <- rowSums(dep77[,c(15:26)])

dep78 <- read_excel("data/tableaux-4001-ts.xlsx", 
                    sheet = "78")
dep78$a2018 <- rowSums(dep78[,c(3:14)])
dep78$a2017 <- rowSums(dep78[,c(15:26)])

dep91 <- read_excel("data/tableaux-4001-ts.xlsx", 
                    sheet = "91")
dep91$a2018 <- rowSums(dep91[,c(3:14)])
dep91$a2017 <- rowSums(dep91[,c(15:26)])

dep92 <- read_excel("data/tableaux-4001-ts.xlsx", 
                    sheet = "92")
dep92$a2018 <- rowSums(dep92[,c(3:14)])
dep92$a2017 <- rowSums(dep92[,c(15:26)])

dep93 <- read_excel("data/tableaux-4001-ts.xlsx", 
                    sheet = "93")
dep93$a2018 <- rowSums(dep93[,c(3:14)])
dep93$a2017 <- rowSums(dep93[,c(15:26)])

dep94 <- read_excel("data/tableaux-4001-ts.xlsx", 
                    sheet = "94")
dep94$a2018 <- rowSums(dep94[,c(3:14)])
dep94$a2017 <- rowSums(dep94[,c(15:26)])

dep95 <- read_excel("data/tableaux-4001-ts.xlsx", 
                    sheet = "95")
dep95$a2018 <- rowSums(dep95[,c(3:14)])
dep95$a2017 <- rowSums(dep95[,c(15:26)])


#import burglaries and housing prices
library(readxl)
burglaries <- read_excel("data/Burglaries IDF.18.xls")
housing_prices <- read_excel("data/housing prices.xlsx")


#import Khartis basemap
library(readr)
france <- read_csv("data/Khartis_template_france-dept.csv")

#merge datasets
colnames(housing_prices)[colnames(housing_prices)=="Département"] <- "Insee"
colnames(burglaries)[colnames(burglaries)=="Département"] <- "Insee"
colnames(burglaries)[colnames(burglaries)=="Burglaries"] <- "Burglaries 2017"
burglaries$Burglaries <- c("10089", "5944", "4352", "4807", "5272", "7640", "5662", "4500")
colnames(burglaries)[colnames(burglaries)=="Burglaries"] <- "Burglaries 2018"

housing_prices$Insee <- as.character(housing_prices$Insee)
burglaries$Insee <- as.character(burglaries$Insee)
fr_house <- full_join(france, housing_prices)
master <- full_join(fr_house, burglaries)
shortmaster <- head(master,7)








  


  
  
    
