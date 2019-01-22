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
  mutate(number = case_when(`Nombre de mandats` %in% 1 - "one",
                            `Nombre de mandats` %in% 2 - "two",
                            `Nombre de mandats` %in% 3 - "three",
                            `Nombre de mandats` %in% 4 - "four",
                            TRUE - NA_character_)) %>% 
  View

#merging datasets: primary key = unique ID, foreign key = allows you to join with another dataset 
#inner join: only keep observations that are present in both datasets
#outer join: left, right, full
#semi join: only keep values on left is present on right
#anti join: only keep values on left if NOT present on right

#binding: join same kind of dataset
#same variables but different observations (bind rows)
#different variables but different observations (bind columns) 

rne_f <- rne %>%
  filter(`Code sexe` = "F")


# DATA VISUALIZATION (useing aes function to map)

library(ggplot2)
rne %>% 
  count(`Libellé de la profession`, sort = TRUE) %>% 
  filter(!is.na(`Libellé de la profession`)) %>% 
  arrange(n) %>% 
  filter(n > 1000) %>% 
  mutate(occupation = fct_inorder(`Libellé de la profession`)) %>% 
  mutate(coord = if_else(n > 40000, n - 2000, n + 2000), colour = if_else(n > 4000, "white", "black")) %>% 
  ggplot(aes(x = occupation, y = n)) + 
  geom_bar(stat = "identity", width = 0.8, fill = "#41a6f4") + #rbg color picker
  scale_y_continuous (labels = scales::comma) +
    coord_flip() +
  geom_text(aes(label = occupation, y = coord, colour = colour), hjust = "inward", 
            size = 2)  +
  scale_color_manual(values = c("black", "white"), guide = FALSE) +
  xlab("") +
  ylab("") +
  ylim(0, NA) +
  scale_x_discrete(labels = NULL) +
  theme(axis.ticks.y = element_blank()) +
  scale_x_discrete(labels = NULL) +
  theme(axis.ticks.y = element_blank()) +
  theme_ipsum(grid="X") +
  labs(title = "Most elected officials are employees, farmers or retired.", subtitle = "Number of elected officials in France in 2018 by occupation", caption = "Source: RNE(Ministère de l'intérieur, computation by Sciences Po students")
  dev.off()
  
  #Joel's code

library(hrbrthemes)
  
cairo_pdf(file = "./plot1.pdf", width = 12, height = 7)
  rne %>% 
    mutate(gender = recode(`Code sexe`, "M" = "Male", "F" = "Female")) %>% 
    count(`Libellé de la profession`, gender, sort = TRUE) %>% 
    filter(!is.na(`Libellé de la profession`)) %>%
    ungroup %>% 
    arrange(gender, n) %>% 
    filter(n > 1000) %>% 
    mutate(order = row_number()) %>% 
    mutate(occupation = fct_inorder(`Libellé de la profession`)) %>% 
    mutate(coord = if_else(n > 22000, n - 1000, n + 1000),
           colour = if_else(n > 22000, "white", "black")) %>% 
    ggplot(aes(x = order, y = n)) +
    geom_bar(aes(fill = gender), stat = "identity", width = 0.8) +
    scale_fill_discrete(guide = FALSE) + 
    scale_y_continuous(labels = scales::comma) +
    coord_flip() +
    geom_text(aes(label = occupation, y = coord, colour = colour), hjust = "inward", vjust = "center", size = 2) +
    scale_color_manual(values = c("black", "white"), guide = FALSE) +
    facet_wrap(facets = vars(gender), scales = "free_y") +
    xlab("") +
    ylab("") +
    ylim(0, NA) +
    scale_x_discrete(labels = NULL) +
    theme(axis.ticks.y = element_blank()) +
    theme_ipsum(grid = "X") +
    labs(title = "Most elected officials are employees, farmers or retired.", subtitle = "Number of elected officials in France in 2018 by occupation.", caption = "Source: RNE (Ministère de l'intérieur), computation by Sciences Po students.")
dev.off()





  

