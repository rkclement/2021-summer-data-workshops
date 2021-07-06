library(tidyverse)

interviews_plotting <- read_csv("data_output/interviews_plotting.csv")

interviews_plotting <- read_csv("https://raw.githubusercontent.com/rkclement/2021-summer-data-workshops/main/data_output/interviews_plotting.csv")

interviews_plotting %>%
  ggplot(aes(x = no_membrs, y = number_items)) +
  geom_point(alpha = 0.5)

interviews_plotting %>%
  ggplot(aes(x = no_membrs, y = number_items)) +
  geom_jitter(alpha = 0.5, width = 0.2, height = 0.2, color = "blue")

interviews_plotting %>%
  ggplot(aes(x = no_membrs, y = number_items, color = village)) +
  geom_jitter(alpha = 0.5, width = 0.2, height = 0.2)

interviews_plotting %>%
  ggplot(aes(x = village, y = rooms)) +
  geom_jitter(alpha = 0.5, 
              width = 0.2, 
              height = 0.2, 
              aes(color = respondent_wall_type))

interviews_plotting %>%
  ggplot(aes(x = village, y = rooms)) +
  geom_count(alpha = 0.5, 
              width = 0.2, 
              height = 0.2, 
              aes(color = respondent_wall_type))

interviews_plotting %>%
  ggplot(aes(x = village, y = rooms)) +
  geom_jitter(alpha = 0.5, 
             width = 0.2, 
             height = 0.2, 
             aes(color = respondent_wall_type))

# boxplots
interviews_plotting %>%
  ggplot(aes(x = respondent_wall_type, y = rooms)) +
  geom_boxplot(alpha = 0) + 
  geom_jitter(alpha = 0.5,
              color = "tomato",
              width = 0.2,
              height = 0.2)

# violin plot
interviews_plotting %>%
  ggplot(aes(x = respondent_wall_type, y = rooms)) +
  geom_violin(alpha = 0) +
  geom_jitter(alpha = 0.5,
              color = "violet",
              width = 0.2,
              height = 0.2)

interviews_plotting %>%
  ggplot(aes(x = respondent_wall_type, y = liv_count)) +
  geom_boxplot(alpha = 0) + 
  geom_jitter(aes(color = memb_assoc),
              width = 0.2,
              height = 0.2)

# barplot
interviews_plotting %>%
  ggplot(aes(x = respondent_wall_type)) +
  geom_bar(aes(fill = village))

interviews_plotting %>%
  ggplot(aes(x = respondent_wall_type)) +
  geom_bar(aes(fill = village), position = "dodge")

percent_wall_type <- interviews_plotting %>%
  filter(respondent_wall_type %in% c("burntbricks", 
                                     "muddaub", 
                                     "sunbricks")) %>%
  count(village, respondent_wall_type) %>%
  group_by(village) %>%
  mutate(percent = n/sum(n)) %>%
  ungroup()

percent_wall_type %>%
  ggplot(aes(x = village, y = percent, fill = respondent_wall_type)) +
  geom_bar(position = "dodge", stat = "identity")

percent_memb_assoc <- interviews_plotting %>%
  filter(!is.na(memb_assoc)) %>%
  count(village, memb_assoc) %>%
  group_by(village) %>%
  mutate(percent = n/sum(n) * 100) %>%
  ungroup()
View(percent_memb_assoc)

percent_memb_assoc %>%
  ggplot(aes(x = village, y = percent, fill = memb_assoc)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Percentage of households in an association",
       y = "Percent",
       x = "", 
       fill = "Member of an association?") + 
  scale_fill_manual(values = c("orange", "green"),
                    labels = c("No", "Yes"))

library(ggthemes)
# faceting
my_plot <- percent_memb_assoc %>%
  ggplot(aes(x = memb_assoc, y = percent)) +
  geom_bar(stat = "identity", position = "dodge") + 
  labs(title = "My title",
       y = "Percent",
       x = "") +
  facet_wrap(~ village) + 
  theme_economist()

ggsave(filename = "fig_output/my_graph.png",
       my_plot,
       width = 15,
       height = 10,
       units = "in",
       dpi = 300)
