# Getting Data and cleaning data


setwd("~/OneDrive/Coursera/JHU_DataSpecialization/data_science_jhu_repo/Getting_Data/")
getwd()
list.files()

require(swirl)
require(UsingR)

# use read.table()
# this is very flexible but requires more parameters
# it is not the best for reading extremely large files
cameradata <- read.table("cameras.csv", sep=",", header=TRUE)
head(cameradata)



# use library(xlsx) for reading excel files
require(xlsx)

# read.xlsx("", sheetIndex=1, colIndex=2:3, rowIndex=1:4)

# use write.xlsx()



# reading XML
# useful for web-scraping
# components include markup and content
# use tags, elements, attributes
require(XML)
xmlurl <- "http://www.w3schools.com/xml/simple.xml"
xmlfile <- xmlTreeParse(xmlurl)
head(xmlfile)
rootNode <- xmlRoot(xmlfile)
rootNode
names(rootNode)
xmlName(rootNode)


# use the library(jsonLite) package
require(jsonlite)
jsondata <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsondata)
jsondata$owner$login
jsondata$owner$id

# turn datasets into JSON
myjson <- toJSON(iris, pretty=TRUE)
myjson



# using data.table package
# inherents from data.frame
# written in C so it is much faster
# much faster at subsetting, grouping, summarizing
require(data.table)
DT <- data.table(x=rnorm(9), y=rep(c("a","b", "c")), z=rep(c(1,2,3), each=3))
DT
tables()

# viewing rows
DT[2,]

# summarization
DT[, list(mean(x), sum(z))]

# subsetting
DT[DT$y=="a"]


# creating new variables using the := notation
DT[, w:=x^2] 
DT
DT[, m:={temp <- (x+z); log2(temp) + 5}]
DT
DT[, bin := x > 0]
DT
DT[, b := mean(x),by=bin]
DT

# Special variables
dim(DT)
set.seed(123)
DT <- data.table(x=sample(letters[1:3], 1E5, TRUE))
dim(DT)
head(DT)
DT[, .N, by=x]
nrow(DT)




# RMySql
install.packages("RMySQL")
require(RMySQL)
# use dbConnect(MySQL(), user, host)
# dbGetQuery(db, "show databases")
# dbDisconnect(db)
# make sure to clear queries each time, dbClearResult()
# dbDisconnect(), make sure to close connection asap





# HDF5
# useful for storing large data sets, structured, along with metadata
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
require(rhdf5)

hdf5ex <- h5createFile("example_xr.h5")
hdf5ex
hdf5ex <- h5createGroup("example_xr.h5", "foo")
hdf5ex <- h5createGroup("example_xr.h5", "bar")
hdf5ex <- h5createGroup("example_xr.h5", "foo/foobar")
h5ls("example_xr.h5")

A <- matrix(1:10, 5,2)
A
h5write(A, "example_xr.h5", "foo/A")
B <- array(seq(0.1, 2.0, by=0.1), dim=c(5,2,2))
B
attr(B, "scale") <- "liter"
h5write(B, "example_xr.h5", "foo/foobar/B")
h5ls("example_xr.h5")


readA <- h5read("example_xr.h5", "foo/A")
readDF <- h5read("example.h5", "df")
readA
readDF

H5close()

h5write(c(12,13,14), "example_xr.h5", "foo/A", index=list(1:3,1))
h5read("example_xr.h5", "foo/A")

H5close()




#####################################################################
# Manipulating data with dplyr

# dplyr allows you to work with tabular data from a variety of sources, including data frames
# data tables, databases, and multidimensional arrays

mydf <- read.csv(path2csv, stringsAsFactors = FALSE)

dim(mydf)
head(mydf)

library(dplyr)

packageVersion("dplyr")

cran <- tbl_df(mydf)

# this will remove the original data.frame so as to avoid confusion
rm("mydf")

?tbl_df

cran


# philosophy of dplyr is to have small functions that each do one thing well
# they are based on five verbs
#   select, filter, arrange, mutate, summarize

?select
# use the following function to select just the variables from ip_id,
# package, and country from the tbl_df, cran
select(cran, ip_id, package, country)

select(cran, r_arch:country)
select(cran, country:r_arch)

cran
# you can also specify which columns to throw away
select(cran, -time)

# use the negative sign outside of the vector to drop all of those columns
select(cran, -(X:size))



# Let us now "filter" by rows, aka subsetting
filter(cran, package=="swirl")
filter(cran, r_version=="3.1.1", country=="US")

?Comparison

filter(cran, country=="IN", r_version <= "3.0.2")

filter(cran, country=="US" | country=="IN")
filter(cran, size > 100500, r_os == "linux-gnu")

is.na(c(3,5, NA, 10))
!is.na(c(3,5, NA, 10))
filter(cran, !is.na(r_version))

# Use arrange() to sort by column(s)
cran2 <- select(cran, size:ip_id)
arrange(cran2, ip_id)
arrange(cran2, desc(ip_id))
arrange(cran2, package, ip_id)
arrange(cran2, country, desc(r_version), ip_id)




# use mutate
cran3 <- select(cran, ip_id, package, size)
cran3
mutate(cran3, size_mb = size/2^20)
mutate(cran3, size_mb = size/2^20, size_gb = size_mb/2^10)

mutate(cran3, correct_size = size + 1000)



# use summarize
summarize(cran, avg_bytes = mean(size))


#####################################################################
# grouping and chaining with dplyr

cran <- tbl_df(mydf)
rm("mydf")
cran


?group_by
by_package <- group_by(cran, package)
by_package
summarize(by_package, mean(size))



pack_sum <- summarize(by_package,
                      count = n(),
                      unique = n_distinct(ip_id),
                      countries = n_distinct(country),
                      avg_bytes = mean(size))


quantile(pack_sum$count, probs=0.99)
top_counts <- filter(pack_sum, count>679)
top_counts
View(top_counts)
top_counts_sorted <- arrange(top_counts, desc(count))
View(top_counts_sorted)


quantile(pack_sum$unique, probs=0.99)
top_unique <- filter(pack_sum, unique > 465)
View(top_unique)
top_unique_sorted <- arrange(top_unique, desc(unique))
View(top_unique_sorted)



# PIPING!
result3 <-
    cran %>%
    group_by(package) %>%
    summarize(count = n(),
              unique = n_distinct(ip_id),
              countries = n_distinct(country),
              avg_bytes = mean(size)
    ) %>%
    filter(countries > 60) %>%
    arrange(desc(countries), avg_bytes)

# Print result to console
print(result3)


data(iris)
irisG <- iris %>%
    group_by(Species) %>%
        summarize(count=n(), avgPetal.Length = mean(Petal.Length), avgPetal.Width = mean(Petal.Width)) %>%
            arrange(desc(avgPetal.Length))
irisG




# web scraping
con <- url("http://www.xuren.me")
htmlcode <- readLines(con)
require(XML)
html <- htmlTreeParse("http://www.xuren.me", useInternalNodes = TRUE)
html
xpathSApply(html, "//title")
close(con)

require(httr)
html2 <- GET("http://www.xuren.me")
contenthtml <- content(html2, as="text")
parsedhtml <- htmlParse(contenthtml)
parsedhtml


# reading from APIs
# application programming interfaces, like Twitter, NYT
# use the oauth_app() function
# use the sign_oauth1.0() function  {httr}  
# use the GET command





# subsetting and ordering
V <- matrix(1:40, 5, 8)
V
X <- V[sample(1:5), ]
X
X[,3] <- X[,3] * rnorm(5,1,1)
X

X[order(X[,3]),]

X <- cbind(X, rnorm(5))
X





#####################################################################
# more on summarizing
restaurant_baltimore <- read.csv("../../courses/03_GettingData/03_02_summarizingData/data/restaurants.csv")
head(restaurant_baltimore)

quantile(restaurant_baltimore$councilDistrict, na.rm=TRUE)
table(restaurant_baltimore$zipCode, useNA = "ifany")
any(is.na(restaurant_baltimore$councilDistrict))
all(restaurant_baltimore$zipCode > 0)
# the all() above returns a false because we have ONE negative coded zipcode

table(restaurant_baltimore$zipCode %in% "21228")
table(restaurant_baltimore$zipCode %in% "21212")
table(restaurant_baltimore$zipCode %in% c("21212", "21213"))
restaurant_baltimore[restaurant_baltimore$zipCode %in% "21212",]

# making crosstabs using xtabs()
xtabs(zipCode~neighborhood, data=restaurant_baltimore)

# flatten the crosstab using ftable()
ftable(xtabs(zipCode~neighborhood, data=restaurant_baltimore))



#####################################################################
# creating new variables
# creating bins, factors, missing flags, applying transformations
restaurant_baltimore$zipGroups <- cut(restaurant_baltimore$zipCode, breaks = quantile(restaurant_baltimore$zipCode))
table(restaurant_baltimore$zipGroups)
# use cut(), cut2(), mutate, relevel, factor, as.numeric()
# using transformations:
#   floor, ceiling, trunctating, log, log10, log2


#####################################################################
# using tidyr
library(tidyr)

# http://vita.had.co.nz/papers/tidy-data.pdf
# principles of tidy data
#   each variables forms a column
#   each observation forms a row
#   each type of observational unit forms a table

# we need to always have one column for each variable
?gather
gather(students, sex, count, -grade)

# gather() uses the data= statement for the dataframe
# the key and value arguments (sex and count) gives the new names for our tidy columns
# the final argument, (-grade) says that we want to gather all columns EXCEPT the grade column
# since (grade) is already in a proper column

res <- gather(students2, sex_class, count, -grade)
res
# this only got us half way
# we now need the separate() function for the purpose
# of separating one column into multiple columns
?separate
separate(res, col=sex_class, into=c("sex", "class"))
# by default, separate(into) separates based on non-alphanumeric values

# we can combine all this into one step using piping
students2 %>%
    gather( sex_class, count, -grade) %>%
    separate( sex_class, c("sex", "class")) %>%
    print


# sometimes, messy data can have variables stored both
# in rows and in columns
students3 %>%
    gather( class, grade, class1:class5 , na.rm = TRUE) %>%
    print

# spread
?spread
students3 %>%
    gather(class, grade, class1:class5, na.rm = TRUE) %>%
    spread( test, grade) %>%
    print

# using mutate at the end
students3 %>%
    gather(class, grade, class1:class5, na.rm = TRUE) %>%
    spread(test, grade) %>%
    mutate(class=extract_numeric(class)) %>%
    print


# sometimes messy data can have multiple observational units
# separate the unique aspects from the non-unique
student_info <- students4 %>%
    select(id, name, sex) %>%
    unique() %>%
    print
gradebook <- students4 %>%
    select(id, class, midterm, final) %>%
    print
# id will function as the primary key in both tables



# messy data may also have a single observational unit
# that is stored in multiple tables
passed <- mutate(passed, status="passed")
failed <- mutate(failed, status="failed")

bind_rows(passed, failed)

#####################################################################
# TIDY DATA Practice
# SAT Scores
# http://research.collegeboard.org/programs/sat/data/cb-seniors-2013

sat
sat %>%
    select(-contains("total")) %>%
    gather(part_sex, count, -score_range) %>%
    separate(part_sex, c("part", "sex")) %>%
    group_by(part, sex) %>%
    mutate(total=sum(count),
           prop=count/total
    ) %>% print



#####################################################################
# Using lubridate
Sys.getlocale("LC_TIME")
library(lubridate)

help(package = lubridate)
# today() function returns todays date
this_day <- today()
# stored as year, month, and day
year(this_day); month(this_day); day(this_day)
wday(this_day) # day one of week is Sunday
wday(this_day, label=TRUE)

# date-times combinations
this_moment <- now()
this_moment
hour(this_moment)

# working with date strings
my_date <- ymd("1989-05-17")
my_date
class(my_date)

ymd("1989 May 17")
mdy("March 12, 1975")
dmy(25081985)
ymd("192012") # this will return an error
ymd("1920/1/2")


# parsing date-time objects
dt1
# "2014-08-23 17:23:02"
ymd_hms(dt1)
hms("03:22:14")

# vector of dates
dt2
ymd(dt2)

# update function allows us to update components of date-time
update(this_moment, hours=8, minutes=34, seconds=55)
this_moment

this_moment <- update(this_moment, hours=10, minutes=16, seconds=0)
this_moment


nyc <- now(tzone = "America/New_York")
nyc
depart <- nyc+days(2)
depart

depart <- update(depart, hours=17, minutes=34)
depart

arrive <- depart+hours(15)+minutes(50)
arrive

?with_tz
arrive <- with_tz(arrive, tzone="Asia/Hong_Kong")
arrive

last_time <- mdy("June 17, 2008", tz = "Singapore")
last_time
?new_interval
how_long <- new_interval(last_time, arrive)
# the as.period function shows you how long it's been
as.period(how_long)







#####################################################################
# more on reshaping data and cleaning data structure
#
library(reshape2)
data(mtcars)
head(mtcars)
dim(mtcars)

# melt the dataset
carsMelt <- melt(mtcars, id = c("gear", "cyl"), measure = c("mpg", "hp"))
head(carsMelt)
tail(carsMelt)
dim(carsMelt)



# casting data sets
dcast(data = carsMelt, formula = cyl~variable, mean)




# plyr
library(plyr)
?ddply
ddply(carsMelt, .(cyl, variable), summarize, mean=mean(value))



# dplyr
#   look up documentation on the "verbs" of dplyr




# merging data
#   lookup documentation for the merge() function
#   by.x= with by.y=











# CLUSTERING
require(class)
require(caret)

iris_analysis <- iris

knn.iris <- kmeans(iris_analysis[,3:4], 3)
iris_analysis$test.species <- knn.iris$cluster
table(iris_analysis$Species, iris_analysis$test.species)

require(cluster)
require(fpc)
clusplot(iris, knn.iris$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

data(iris)
inTrain <- createDataPartition(y=iris$Species, p=0.6, list=FALSE)
iris_train <- iris[inTrain,]
iris_test <- iris[-inTrain,]
nrow(iris_train); nrow(iris_test)
