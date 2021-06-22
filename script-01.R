# dir.create("data")
# dir.create("data_output")
# dir.create("fig_output")

# download.file("https://ndownloader.figshare.com/files/11492171",
#              "data/SAFI_clean.csv", mode = "wb")

# install.packages("here")

# these are some notes
3 + 5
12/7

area_hectares <- 1.0
Area_hectares <- 1.0

area_hectares

2.47 * area_hectares

area_hectares <- 2.5

area_acres <- 2.47 * area_hectares

# checking out what happens to objects
area_hectares <- 50 # store 50 in area_hectares
area_acres <- 2.47 * area_hectares
area_acres

b <- sqrt(4)

round(3.14159)
args(round)
round(3.14159, digits = 2)
?round

round(digits = 2, x = 3.14159)

hh_members <- c(3, 7, 10, 6)
hh_members

respondent_wall_type <- c("muddaub", "burntbricks", "sunbricks")

length(hh_members)
length(respondent_wall_type)

class(hh_members)
class(respondent_wall_type)

possessions <- c("bicycle", "radio", "television")
possessions <- c(possessions, "mobile phone")
possessions
possessions <- c("car", possessions)
possessions

logical_vector <- c(TRUE, FALSE, TRUE, TRUE)


num_char <- c(1, 2, 3, "a")
num_logical <- c(1, 2, 3, TRUE)
char_logical <- c("a", "b", "c", TRUE)
tricky <- c(1, 2, 3, "4")

class(num_char)

respondent_wall_type[1]
respondent_wall_type[c(2,3)]
respondent_wall_type[c(3,2)]
respondent_wall_type[c(1,1,1,1,3,2,3,3)]

hh_members
hh_members[c(TRUE, FALSE, TRUE, TRUE)]

hh_members > 5
hh_members[hh_members > 5]

hh_members[hh_members < 4 | hh_members > 7]
hh_members[hh_members > 4 & hh_members < 7]

possessions
possessions[possessions == "car" | possessions == "bicycle"]
# %in%
possessions %in% c("car", "bicycle")
possessions[possessions %in% c("car", "bicycle")]

rooms <- c(2, 1, 1, NA, 7)
rooms
mean(rooms)
mean(rooms, na.rm = TRUE)

is.na(rooms)
!is.na(rooms)
mean(rooms[!is.na(rooms)])
rooms_complete <- rooms[!is.na(rooms)]


interviews <- read_csv("data/SAFI_clean.csv")
library(tidyverse)
interviews <- read_csv("data/SAFI_clean.csv", na = "NULL")
class(interviews)

dim(interviews)
nrow(interviews)

head(interviews)
args(head)
head(interviews, 10)
tail(interviews, 10)

str(interviews)
summary(interviews)

interviews[1,1]
interviews[1,6]
interviews[[1]]
interviews[[6]]

interviews[1:3, 7]

interviews[3, ]
interviews[ , 7]
interviews[-3, ]

interviews[ , "village"]
interviews$village

respondent_floor_type <- factor(c("earth", "cement", "cement", "earth"))
levels(respondent_floor_type)
respondent_floor_type <- c(respondent_floor_type, "wood")
respondent_floor_type

respondent_floor_type <- factor(respondent_floor_type, ordered = TRUE)
respondent_floor_type

as.character(respondent_floor_type)

year_fct <- factor(c(1990, 1983, 1977, 1998, 1990))
as.numeric(year_fct)
as.numeric(as.character(year_fct))
