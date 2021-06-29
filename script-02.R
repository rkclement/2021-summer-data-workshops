library(tidyverse)

interviews <- read_csv("data/SAFI_clean.csv", na = "NULL")

interviews

View(interviews)

interviews[2, ]
interviews[ ,2]
interviews[interviews$village == "God", ]

select(interviews, village, no_membrs, months_lack_food)
select(interviews, village:respondent_wall_type)

filter(interviews, village == "God")
filter(interviews, village == "God" & rooms > 1 & no_meals > 2)
filter(interviews, village == "God" | village == "Chirodzo")

interviews2 <- filter(interviews, village == "Chirodzo")
interviews3 <- select(interviews2, village:respondent_wall_type)

interviews4 <- select(filter(interviews, village == "Chirodzo"), 
                      village:respondent_wall_type)

# pipe operator: %>%

interviews5 <- interviews %>%
  filter(village == "Chirodzo") %>%
  select(village:respondent_wall_type)

interviews6 <- interviews %>%
  filter(memb_assoc == "yes") %>%
  select(affect_conflicts, liv_count, no_meals)

interviews6 <- interviews %>%
  select(affect_conflicts, liv_count, no_meals) %>%
  filter(memb_assoc == "yes")

# mutate

interviews <- interviews %>%
  mutate(people_per_room = no_membrs/rooms)

interviews %>%
  filter(!is.na(memb_assoc)) %>%
  mutate(people_per_room = no_membrs/rooms)

# exercise #2
interviews8 <- interviews %>%
  mutate(total_meals = no_membrs * no_meals) %>%
  select(village, total_meals) %>%
  filter(total_meals > 20)
View(interviews8)

interviews %>%
  group_by(village) %>%
  summarize(mean_no_membrs = mean(no_membrs))

interviews %>%
  filter(!is.na(memb_assoc)) %>%
  group_by(village, memb_assoc) %>%
  summarize(mean_no_membrs = mean(no_membrs),
            min_membrs = min(no_membrs)) %>%
  ungroup() %>%
  arrange(desc(min_membrs))

interviews %>%
  count(village, sort = TRUE)

unique(interviews$no_meals)

interviews %>%
  count(no_meals)

interviews %>%
  group_by(village) %>%
  summarize(mean_no_members = mean(no_membrs),
            min_membrs = min(no_membrs),
            max_membrs = max(no_membrs),
            n = n())
interviews

interviews %>%
  select(key_ID, village, interview_date, instanceID)

interviews_wide <- interviews %>%
  mutate(wall_type_logical = TRUE) %>%
  pivot_wider(names_from = respondent_wall_type,
              values_from = wall_type_logical,
              values_fill = list(wall_type_logical = FALSE))
  
View(interviews_wide)

interviews_long <- interviews_wide %>%
  pivot_longer(cols = muddaub:cement,
               names_to = "respondent_wall_type",
               values_to = "wall_type_logical")

View(interviews_long)

interviews_long <- interviews_wide %>%
  pivot_longer(cols = muddaub:cement,
               names_to = "respondent_wall_type",
               values_to = "wall_type_logical") %>%
  filter(wall_type_logical == TRUE) %>%
  select(-wall_type_logical)

interviews_items_owned <- interviews %>%
  separate_rows(items_owned, sep = ";") %>%
  replace_na(list(items_owned = "no_listed_items")) %>%
  mutate(items_owned_logical = TRUE) %>%
  pivot_wider(names_from = items_owned,
              values_from = items_owned_logical,
              values_fill = list(items_owned_logical = FALSE))

interviews_plotting <- interviews %>%
  ## pivot wider by items_owned
  separate_rows(items_owned, sep = ";") %>%
  ## if there were no items listed, changing NA to no_listed_items
  replace_na(list(items_owned = "no_listed_items")) %>%
  mutate(items_owned_logical = TRUE) %>%
  pivot_wider(names_from = items_owned,
              values_from = items_owned_logical,
              values_fill = list(items_owned_logical = FALSE)) %>%
  ## pivot wider by months_lack_food
  separate_rows(months_lack_food, sep = ";") %>%
  mutate(months_lack_food_logical = TRUE) %>%
  pivot_wider(names_from = months_lack_food,
              values_from = months_lack_food_logical,
              values_fill = list(months_lack_food_logical = FALSE)) %>%
  ## add some summary columns
  mutate(number_months_lack_food = rowSums(select(., Jan:May))) %>%
  mutate(number_items = rowSums(select(., bicycle:car)))

write_csv(interviews_plotting, file = "data_output/interviews_plotting.csv")
