#Crime Data: France

library(dplyr)
library(tidyverse)
library(hrbrthemes)


# Download data for burglaries in 2017 and 2018. Focus on departments: 75, 77, 78, 91, 92, 93, 94, 95


#import burglaries and housing prices for Ile de France
library(readxl)
burglaries <- read_excel("data/Burglaries IDF.18.xls")
housing_prices <- read_excel("data/housing prices.xlsx")

#import burglaries and population for all of France
library(readr)
burglaries_france2018 <- read_csv("~/Downloads/burglaries2018.csv")
burglaries_france2018$X3 <- NULL
colnames(burglaries_france2018)[colnames(burglaries_france2018)=="221747"] <- "Burglaries"
colnames(burglaries_france2018)[colnames(burglaries_france2018)=="France"] <- "Insee"
population2018 <- read_delim("~/Downloads/population2018.csv", 
                             ";", escape_double = FALSE, trim_ws = TRUE)
View(population2018)

#import Khartis basemap template
library(readr)
france <- read_csv("data/Khartis_template_france-dept.csv")

#merge datasets for Khartis
colnames(housing_prices)[colnames(housing_prices)=="Département"] <- "Insee"
colnames(burglaries)[colnames(burglaries)=="Département"] <- "Insee"
colnames(burglaries)[colnames(burglaries)=="Burglaries"] <- "Burglaries 2017"
burglaries$Burglaries <- c("10089", "5944", "4352", "4807", "5272", "7640", "5662", "4500")        #values from final.csv (glitchy format)
colnames(burglaries)[colnames(burglaries)=="Burglaries"] <- "Burglaries 2018"
burglaries$`Burglaries 2018`<- as.numeric(burglaries$`Burglaries 2018`)

housing_prices$Insee <- as.character(housing_prices$Insee)
burglaries$Insee <- as.character(burglaries$Insee)
fr_house <- full_join(france, housing_prices)
master <- full_join(fr_house, burglaries)
fr_burg <- full_join(france, burglaries_france2018)
master2 <- full_join(fr_burg, population2018)
shortmaster <- head(master,7)

#calculate burglary to population ratio
shortmaster$burgpop2017 <- shortmaster$`Burglaries 2017`/shortmaster$Population
shortmaster$burgpop2018 <- shortmaster$`Burglaries 2018`/shortmaster$Population

master2$Burglaries <- as.numeric(master2$Burglaries)
master2$burgpop2018 <- master2$Burglaries/master2$`Population 2018`
final_master<-head(master2,101)

#export in CSV format --> upload to Khartis
write.csv(final_master,"final_master2.csv")
write.csv(shortmaster, "shortmaster2.csv")








  


  
  
    
