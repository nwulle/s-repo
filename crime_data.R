#Crime Data: Île de France

library(readxl)
crime <- read_excel("data/tableaux-4001-ts.xlsx")

library(dplyr)
library(tidyverse)
library(hrbrthemes)

crime$a2018 <- rowSums(crime[,c(3:14)])
crime$a2017 <- rowSums(crime[,c(15:26)])
crime$a2000 <- rowSums(crime[,c(219:230)])

crime %>% 
  select(`libellé index`, a2018, a2017) %>% 
  mutate(offence = fct_inorder(`libellé index`)) %>% 
  mutate(coord = if_else(n > 22000, n - 1000, n + 1000),
         colour = if_else(n > 22000, "white", "black")) %>% 
  ggplot(aes(x = offence)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::comma) +
  geom_text(aes(label = offence)) +
  scale_color_manual(values = c("black", "white"), guide = FALSE) +
  xlab("") +
  ylab("") +
  ylim(0, NA) +
  scale_x_discrete(labels = NULL)


# Focus on departments: 75, 77, 78, 91, 92, 93, 94, 95

library(readxl)
paris <- read_excel("data/tableaux-4001-ts.xlsx", 
                    sheet = "75")
paris$a2018 <- rowSums(paris[,c(3:14)])
paris$a2017 <- rowSums(paris[,c(15:26)])

paris %>% 
  select(`libellé index`, a2018, a2017) %>% 
  View


  


  
  
    
