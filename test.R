# this is a test

library(tidyverse)

library(readr)
rne <- read_csv("~/Downloads/Repertoire-national-des-elus_unicode.csv")

# TIDY DATA:
# dplyr & tidyr
# the pipe (CTL + SHIFT + M = %>%) -- create data pipelines 
# verbs: distinct (de-deduplicate data), mutate (create/transform variables), sample_n/sample_frac (random from big data)

rne_female <- rne %>% 
  filter(`Code sexe` %in% "F") %>% 
  filter(!(`Date de naissance` %in% lubridate::ymd("1900-01-01"))) %>% # ! -- is NOT, negate condition
  mutate(`Code sexe` = recode(`Code sexe`, "F" = "Female")) %>% 
  arrange(`Date de naissance`) %>% 
#  select(`Code sexe`, `Date de naissance`, `Libellé de la profession`) %>% 
  group_by(`Libellé de la profession`) %>% 
  summarise(n = n(), age = mean(Age), sd_age = sd(Age)) %>% 
  arrange(desc(n))

# large format (e.g. by country) vs long format (e.g. by observation)
#   pivoting functions: gather() -- large to long and spread() -- long to large

rne %>%
  gather("mandat", "value", `Conseiller Municipal`:Maire) %>% 
  filter(value %in% TRUE) %>% 
  select(-value) %>%
  group_by(mandat) %>% 
  filter(is.na(Age)) %>% 
  summarize(n=n())

rne %>% #average number of mandats by occupation and gender
  gather("mandat", "value", `Conseiller Municipal`:Maire) %>% 
  filter(value %in% TRUE) %>% 
  select(-value) %>% 
  #group by unique identifier
  group_by(Identifiant) %>% 
  summarise(offices = n(), occupation = unique(`Libellé de la profession`), gender = unique(`Code sexe`)) %>% 
  ungroup() %>% 
  group_by(occupation, gender) %>% 
  summarise(offices = mean(offices))
  arrange(desc(offices))

#find second youngest woman in each profession
rne %>% 
  filter(`Code sexe` %in% "F") %>% 
  group_by(`Libellé de la profession`) %>% 
  arrange(Age) %>% 
  slice(2) %>% #keep only second row
  View

rne %>% 
  filter(`Code sexe` %in% "F") %>% 
  group_by(`Libellé de la profession`) %>% 
  arrange(desc(Age)) %>%
  mutate(rank = 1:n()) %>% 
  filter(rank %in% 2)
  View
  
#case_when function: complex transformation of a variable
rne %>%
  mutate(number = case_when(`Nombre de mandats` %in% 1 - "one"),
                            `Nombre de mandats` %in% 2 - "two",
                            `Nombre de mandats` %in% 3 - "three",
                            `Nombre de mandats` %in% 4 - "four")
