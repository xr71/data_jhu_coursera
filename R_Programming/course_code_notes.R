setwd("~/OneDrive/Coursera/JHU_DataSpecialization/data_science_jhu_repo/R_Programming/")
old.dir <- getwd()

# create a directory in the current directory
dir.create("testdir1")
list.files()
# confirm that the directory has been created
file.exists("testdir1")

# create a file
file.create("testscript.R")
list.files()
file.exists("testscript.R")

# remove the directory
# using recursive=TRUE will allow R to properly remove any sub dirs / files
unlink("testdir1", recursive=TRUE)
# check if testdir1 still exists
file.exists("testdir1")
# we use the unlink() because of Unix history

# remove the file
file.remove("testscript.R", recursive=TRUE)
file.exists("testscript.R")

#####################################################################
# Sequencing Numbers
1:20
pi:10
15:1

# the seq function gives us more control
seq(1,20)
seq(0, 10, by=0.5)
my_seq <- seq(5, 10, length=30)
length(my_seq)

# we can use the seq(along.with = ) function parameter to generate 
# another sequence with the length of a preset variable
seq(along.with = my_seq)
# but it's more efficient to just use seq_along()
seq_along(my_seq)

# another similar function is the replicate funciton, rep()
rep(0, times=40)
rep(c(0,1,2), times=10)
rep(c(0,1,2), each=10)


#####################################################################
# All about vectors
num_vect <- c(0.5,55,-10,6)
tf <- num_vect < 1
# use the & or the | for "and" and "or" logical operations

# char vectors
my_char <- c("My", "name", "is")
# use the paste() function to join lengths of a vector
paste(my_char, collapse = " ")

my_name <- c(my_char, "Xu")
paste(my_name, collapse=" ")

paste(c(1:3), c("X", "Y", "Z"), sep="")
# paste also works with vector recycling when vectors have different lengths
paste(LETTERS, 1:4, sep="-")



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Week 2:
# Control structures and functions in R
# remember the following commands
#   if, else
#   for
#   while
#   repeat
#   break
#   next
#   return
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# in R, you can store an entire function inside a variable
# the following if else command is stored in the var y (the value 10 or 0)
y <- if (x<3) {
    10
} else {
    0
}

# for loops
for (i in 1:10) {
    print(i)
}

# you can iterative over each element inside a for loop
x <- c("a", "b", "c", "d")
for(letter in x) {
    print(letter)
}
# this is similar to python

# here is another way to do it
for(i in seq_along(x)) {
    print(x[i])
}


# for single for loop, you can skip the curly braces
for (i in 1:4) print(x[i])


# nested for loops
v <- matrix(1:6, 2,3)
for (i in seq_len(nrow(v))) {
    for (j in seq_len(ncol(v))) {
        print(v[i,j])
    }
}


#####################################################################
# While loops
count <- 0
while (count < 10) {
    print(count)
    count <- count+1
}

# while loops can have conditionals inside
z <- 5
while (z >= 3 && z <= 10) {
    print (z)
    coin <- rbinom(1,1,0.5)
    
    if(coin == 1) {
        z <- z+1
    } else {
        z <- z-1
    }
}


# repeat, next, and break
x <- 1
repeat {
    if (x >= 10) {
        break
    } else {
        print(x)
        x <- x+1
    }
}

# next
for (i in 1:25) {
    if(i<=20) {
        next
        # this will skip the first 20 iterations
    } 
    print(i)
    print("hello world")
}

#####################################################################
# Functions
# more useful in independent R scripts or eventually in R packages
add2 <- function(x,y) {
    x+y
}
add2(10,5)


# a function of above 10 vector
above10 <- function(vector) {
    use <- vector>10
    vector[use]
}
x <- seq(1,50)
above10(x)


# a function that returns a vector of a user set numeric threshold
aboveN <- function(vector, n=10) {
    use <- vector > n
    vector[use]
}


colMean <- function(y) {
    nc <- ncol(y)
    means <- numeric(nc)
    
    for(i in 1:nc) {
        means[i] <- mean(y[,i])
    }
    
    means
}

# an improved colMean function that removes NA
colMean <- function(y, removeNA = TRUE) {
    nc <- ncol(y)
    means <- numeric(nc)
    
    for(i in 1:nc) {
        means[i] <- mean(y[,i], na.rm = removeNA)
    }  
    means
}


# functions turn you from an R user to an R Programmer
# all functions are directive and get stored as an object (first class)
# pass functions as variables into other functions
# functions can be nested, lexicon scoping
# functions can have named arguments but most of them can have default values
# formal arguments are the ones included inside the function
# for example, use the formals() on a function to see the arguments
formals(lm)
formals(sd)

# you can also set the default value of an argument to NULL

# R has lazy evaluation
# arguments are only evaluated as needed
f <- function(a,b) {
    a^2
}
f(2)
# nothing happens to b here because the funciton never needs to evaluate b

# in R, you can use the ... argument 
# this will pass a generic number of arguments that are usually passed
# on to other functions

#NOTE!
# You cannot use partial matching after ... arguments, you must use 
# named matching


#####################################################################
# Scoping Rules

# symbol binding
# R will search through a series of environments to bind value to a symbol
# R searches the global environment first to detect if there is a matching symbol
# If the symbol could NOT be found in the global environment
# it will then search through the namespaces environment (search())
# it will search through all the packages, with the base package last

# R can have both a symbol in the global environment as well as the 
# namespace environemtn, like c the vector and c() the function


# What are scoping rules???
# R uses static or lexical scoping
# This simplifies calculations
# how R binds variables in the list to bind a value to a symbol

# Lexical scoping means:
# the values of free variables are searched for in the environment in which the function was defined
# So then what is an environment???
#   Environment is a collection of (symbol, value) pairs
#   Environment has a parent environment
#   The only environment that does not have a parent is the EMPTY environment
#   A function + environment = a closure, or a function closure

# So what happens when R searches for a free variable inside a function
#   If the value of that variable is not found in the environment in which the function is defined, it will then search the parent environment
#   The search continues the parent chain until we hit a top-level environment, usually the global or the namespace environment
#   After the top-level environment, the search continues down the search list until we hit the empty environment
#   If a value of the variable cannot be found even at the empty environment, then an error is tossed

# This means that functions in R can return more functions 
# or constructor functions

make.power <- function(n) {
    pow <- function(x) {
        x^n
    }
    pow
}

quinto <- make.power(n = 5)
quinto(2)

ls(environment(quinto))
get("n", environment(quinto))

# What is then dynamic scoping?
# Dynamic scoping looks for the variable within its call environment, thus it is locally scoped to be whatever value it is defined within the scope of that function


# The consequence of this lexical scoping is that everything must be stored in memory
# Thus there must be a pointer to everything that is stored in memory


# Optimization -- scoping rules 
# optim, nlm, optimize
# it is useful to let the end user to hold certain parameters fixed


# REMEMBER: each function should do one logical step
# this will really help you debug 


#####################################################################
# DATES in R are set as n days from  1970-01-01
# dates are stored in POSIXct (integer) or POSIXlt (list)
weekdays
x <- Sys.time()
x
xp <- as.POSIXlt(x)
names(unclass(xp))
unclass(x)
strptime # this takes string convertions of datetime
?strptime # check the help to look up the %format of strptime
# using datetime classes will take care of leap years and timezones
# very handy!


# More on dates and times
# especially useful for analyzing time series data because of object recognition in graphics
# this is considered a DATE CLASS in R
d1 <- Sys.Date()
class(d1)
unclass(d1)
# so as you can see, internally, R treats the date class as an integer in number of days since 1970-01-01

d2 <- as.Date("1969-01-01")
unclass(d2)

t1 <- Sys.time()
t1
class(t1)
unclass(t1) 
t2 <- as.POSIXlt(Sys.time())
class(t2)
t2
unclass(t2)
# POSIXlt gives all of the contents of the date var in a list
str(unclass(t2))

t2$min # this will return just the minutes of the date var

weekdays(d1)
months(t1)
quarters(t2)

# help R recognize the data string 
t3 <- "October 17, 1986 08:24"
t4 <- strptime(t3, "%B %d, %Y %H:%M")
t4
class(t4)
# we have turned a string vector, t3, into a date class variable, t4
Sys.time() > t1
Sys.time() - t1
difftime(Sys.time(), t1, units = "days")




#####################################################################
# Simulating and sampling random numbers from distributions in R

rbinom(n=100, size=1, prob=0.7)
rnorm(10, 100, 25)
rnorm(10)
rpois(n=5, lambda = 10)
my_pois <- replicate(100, rpois(5, 10))
cm <- colMeans(my_pois)
hist(cm)




#####################################################################
# All about subsetting
# There exists a vector x
x
x[1:10]
x[is.na(x)]

y <- x[!is.na(x)]
y[y>0]

x[!is.na(x) & x>0]

# Remember, R is 1-based indexing
x[c(3,5,7)]
x[c(-2,-10)]
x[-c(2,10)]


vect <- c(foo=11, bar=2, norf=NA)
# use the identical function to check that two vectors are the same
?identical





#####################################################################
# lapply and sapply
# vapply and tapply

# split apply and combine strategy
# each of these functions here will split up the data into smaller pieces, 
# apply a function to each piece, then combine the results

data(flags)
head(flags)
dim(flags)
class(flags)

# we can check the class of each column in the dataframe using a loop
cls_list <- lapply(flags, class)
cls_list
# as you can now see, the l in lapply stands for list
class(cls_list)

# we can simplify the cls_list object into a character vector
as.character(cls_list)
# HOWEVER, we can do better by simply using the sapply() function
# sapply allows you to simplify the list, hence the s in sapply is for simplify
cls_vect <- sapply(flags, class)
class(cls_vect)


# we can know the total number of countries with the color orange in their flags
sum(flags$orange)
# but we can do better by knowing the total number of countries for each color
flag_colors <- flags[, 11:17]
head(flag_colors)
lapply(flag_colors, sum)
sapply(flag_colors, sum)
sapply(flag_colors, mean)


flag_shapes <- flags[, 19:23]

lapply(flag_shapes, range)
shape_mat <- sapply(flag_shapes, range)
shape_mat



# what happens when sapply cannot simplify a vector returned by lapply
unique(c(3,4,5,5,5,6,6))
unique_vals <- lapply(flags, unique)
unique_vals
sapply(unique_vals, length)
# because the length of each vector in the list are different, this will pose a real problem for sapply
sapply(flags, unique)
# you can also use anonymous functions within the lapply and sapply functions




###############################################################################
# vapply and tapply

# vapply allows the user to specify the format explicity
# vapply will stop the operation if there is mis-match
vapply(flags, unique, numeric(1)) # for example, this willl throw an error

sapply(flags, class)
vapply(flags, class, character(1))

# tapply applies a function over a ragged array
table(flags$landmass)
table(flags$animate)
tapply(flags$animate, flags$landmass, mean)
# the above function applies the mean function to animate, separated by the six landmass groups

tapply(flags$population, flags$red, summary)
tapply(flags$population, flags$landmass, summary)


# More about loop functions
# the generic apply, the multivariate mapply, and the split function

x <- 1:4
lapply(x, runif)
# we can do the following function because of the ... pass in lapply
lapply(x, runif, min=0, max=10)

# the apply functions use a lot of anonymous functions

matrix <- matrix(rnorm(200), 20, 10)
matrix

apply(matrix, 2, mean)
apply(matrix, 1, sum)
apply(matrix, 1, quantile, probs=c(0.25, 0.75))
# in short, the apply function calculates along the margins of matrices



# mapply can use more than just a single element
mapply(rep,1:4, 4:1)
# use mapply to generate random noise
noise <- function(n, mean, sd) {
    rnorm(n, mean, sd)
}
noise(5,1,2)
# I can instantly vectorize this function
mapply(noise, 1:5, 1:5, 2)
# make sure to passing matching dimensions 
mapply(noise, 1:5, 1:1, 2)



# tapply 
x <- seq(1:30)
gr <- gl(3, 10)
tapply(x, gr, mean)




# the split function
newx <- split(x, gr)
newx
data(airquality)
s <- split(airquality, airquality$Month)
sapply(s, function(x) colMeans(x[, c("Ozone", "Wind", "Temp")], na.rm = TRUE))




#####################################################################
# Looking at Data, the mighty str()

data(plants)
class(plants) # it is a data.frame
# data.frame is rectangular, it has two dimensions (row by column)
dim(plants)
nrow(plants)
ncol(plants)
object.size(plants)
names(plants)

# let's preview just the top
head(plants)
head(x = plants, n = 10)
tail(plants, 15)
summary(plants)

# explore categorical variables
table(plants$Active_Growth_Period)

str(plants)





#####################################################################
# R profiler
# Note that you should not use Rprof() and the sys.time() together

# premature optimization is the root of all evil

system.time(for(i in 1:10000) print(i)) 

Rprof(for(i in 1:10000) print(i))
summaryRprof(for(i in 1:10000) print(i))






#####################################################################
# DEBUGGING

# message, warning, error, condition (programmers created)

# use the invisible() function to prevent printing

# Debugging requires:
#   What did you ACTUALLY fed into the function?
#   How did you call the function?
#   What were you expecting?
#   What did you actually get?
#   How does it differ?
#   Perhaps your expectations were wrong in the first place
#   Can you reproduce the problem (exactly)?

# This should remind us that set.seed() is very important

# Primary debugging tools include:
#   traceback
#   debug
#   browser
#   trace
#   recover

rm(list=ls())
mean(x)
traceback()
# traceback will only give you the most recent error
# so call traceback() right away

lm(y~x)
traceback()


debug(lm)
lm(y~x)


options(error=recover)
read.csv("nosuchfile")





#####################################################################
# BASE Graphics

data(cars)
?cars
head(cars)
plot(cars)
plot(x = cars$speed, y = cars$dist)
plot(x = cars$speed, y = cars$dist, xlab = "Speed")
plot(x = cars$speed, y = cars$dist, ylab = "Stopping Distance")
plot(x = cars$speed, y = cars$dist, xlab = "Speed", ylab = "Stopping Distance")

# Use main to add a title
plot(cars, main = "My Plot" )

# Use sub to add a subtitle
plot(cars, sub = "My Plot Subtitle")

plot(cars, col=2)
plot(cars, xlim=c(10,15))
plot(cars, pch=2)


data(mtcars)
boxplot(mpg~cyl, data=mtcars)
hist(mtcars$mpg)
