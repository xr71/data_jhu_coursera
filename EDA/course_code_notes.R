# Exploratory data analysis

setwd("~/OneDrive/Coursera/JHU_DataSpecialization/data_science_jhu_repo/EDA/")
getwd()
list.files()


require(UsingR)

help(package=UsingR)

data(airquality)

air.analysis <- airquality

air.analysis <- complete.cases(air.analysis)
air.naremoved <- airquality[air.analysis,]
summary(air.naremoved)


# base graphics boxplot
boxplot(air.naremoved$Ozone)
boxplot(air.naremoved$Temp, col="blue")

# base graphics histogram
hist(air.naremoved$Wind)
rug(air.naremoved$Wind)

hist(air.naremoved$Wind, breaks=35, col="green")
rug(air.naremoved$Wind)


# base graphics abline
boxplot(air.naremoved$Temp)
abline(h=75)
# overlaying 
hist(air.naremoved$Wind)
abline(v=12, col="green", lwd=3)
abline(v=median(air.naremoved$Wind), lwd=4, col="red")


# base barplot
barplot(table(air.naremoved$Month), main="Number of records in each month", col="wheat")


# multiple plots
boxplot(Wind~Month, data=air.naremoved)

par(mfrow = c(2,1))
hist(subset(air.naremoved, Month==5)$Temp, col="green", breaks=15)
hist(subset(air.naremoved, Month==8)$Temp, col="red", breaks = 15)


# scatterplot
par(mfrow=c(1,1))
with(air.naremoved, plot((jitter(Month*20)), jitter(Temp)))
with(air.naremoved, plot( Wind, Temp, col=Month))
abline(h=75, v=12)





# Base graphics
# start with the plot function, initialization
# then annotation functions

?par

hist(air.naremoved$Ozone)
plot(air.naremoved$Ozone, air.naremoved$Wind)
# plot puts x,y on a scatter plot
boxplot(Ozone~Month, air.naremoved, xlab="Month", ylab="Ozone")
# most used pars
#   pch - plotting symbol
#   lty - line type
#   lwd - line width
#   col - color
#   xlab - x-axis label
#   ylab - y-axis label

# import par() functions, global
#   las - the orientation of axis
#   bg - background color
#   mar - margin size
#   oma - the outter margin size
#   mfrow - the number of plots per row, column, plots row wise
#   mfcol - the number of plots per row, column, plots column wise


# base plotting functions
#   plot
#   lines - adds to a plot
#   points - adds points to a plot
#   text - add labels
#   title - add annotations
#   mtext - add margin text
#   axis - specify axis ticks
with(air.naremoved, plot(Wind, Ozone, type="n"))
with(subset(air.naremoved, Month == 5), points(Wind, Ozone, col="blue"))
with(subset(air.naremoved, Month != 5), points(Wind, Ozone, col="red"))
legend("topright", pch=1, col=c("blue", "red"), legend=c("May", "Other months"))

# overlay model regression
with(air.naremoved, plot(Wind, Ozone))
lm1 <- lm(Ozone~Wind, air.naremoved)
# abline can interpret the regression coef
abline(lm1, lwd=3)

par(mfrow = c(1,3), oma = c(2,2,2,2), mar = c(4,4,4,4))
with(air.naremoved, {
    plot(Wind, Ozone)
    plot(Wind, Temp)
    plot(Ozone, Solar.R)
    mtext("Wind, Ozone, Temp, and Solar.R in NYC", outer=TRUE)
})

#####################################################################
# simulate a demonstration of base plot

# reset par
par(mfrow = c(1,1))
set.seed(123)
x <- rnorm(1000)
hist(x)

y <- rnorm(1000)

plot(jitter(x), jitter(y), col = rgb(0,0,0, alpha=0.5), pch=20, lwd=3)
title("Random Scatterplot")
legend("topleft", pch=20, legend="RNORM Data")
?points

par("mar")
par("mfrow")


# grDevices
library(datasets)
library(grDevices)
pdf(file="oldfaithful_plot.pdf")
with(faithful, plot(eruptions, waiting))
dev.off() # turn off the pdf output file
list.files()


# lattice plotting system 

require(lattice)
xyplot(Ozone ~ Solar.R | as.factor(Month), data=air.naremoved, layout=c(5,1))

data(iris)
iris.analysis <- iris
xyplot(Petal.Length~Petal.Width | Species, data=iris.analysis)

x <- rnorm(100)
f <- rep(0:1, each=50)
y <- x + f - (f*x+rnorm(100, sd=0.5))
f <- factor(f)
xyplot(y~x | f)

# custom lattice functions
xyplot(y~x | f, panel=function(x,y,...){
    panel.xyplot(x, y, ...)
    panel.lmline(x,y,col=2)
})



#####################################################################
# ggplot2

require(ggplot2)

data(mpg)
mpg.analysis <- mpg
str(mpg)
qplot(displ, hwy, data=mpg, colour=drv)
# facets
qplot(displ, hwy, data=mpg, facets=.~drv)
qplot(displ, hwy, data=mpg, facets=drv~.)

# points and smoothing
qplot(displ, hwy, data=mpg, colour=drv, geom=c("point", "smooth"), method="lm")
qplot(Petal.Length, Petal.Width, data=iris.analysis, colour=Species, geom=c("point", "smooth"), method="lm")

# points, smoothing, facets
qplot(displ, hwy, data=mpg, geom=c("point", "smooth"), method="lm", facets=.~drv)

# ggplot()
# modify aesthetics inside the geom function
# or apply as a dimension inside the aes()
ggplot(data=mpg, aes(displ, hwy)) + geom_point(aes(colour=drv)) + ggtitle("DISPL BY HWY in MPG") + theme_bw()

# remember, ggplot treats xlim and ylim (axis limits)
# very differently from the base R graphics
# use coord_cartesian() to limit just the axis, but not a subset of the data

# use the cut() function to create quantiles of continuous variables
ggplot(data=iris.analysis, aes(Petal.Length, Petal.Width)) + geom_point(aes(colour=Species)) + geom_smooth(method="lm", se=FALSE, col="steelblue") + facet_wrap(~Species) + theme_bw()











# hierarchical clusteirng
set.seed(1234)
x <- rnorm(120, mean=rep(1:3, each=4), sd=0.5)
y <- rnorm(120, mean=rep(c(1,2,1), each=4), sd=0.5)
plot(x,y, col="blue", pch=20, cex=2)

clustdf <- data.frame(x,y)
distxy <- dist(clustdf)
hcluster <- hclust(distxy)
plot(hcluster)

# look online for more fancy dendrograms
# colored dendrograms


# headmap() function
# runs a cluster analysis on the rows and columns of the data
heatmap(as.matrix(clustdf))

# hclustering is best for exploratory
# where to cut and how many times to cut is not an obvious choice




# kmeans clustering
# kmeans() function in R
#   returns a list with a number of elements
#   like cluster, centers
kmeansobj <- kmeans(clustdf, centers=3)
kmeansobj$centers
plot(x,y, col=kmeansobj$cluster)
points(kmeansobj$centers, col=1:3, pch=3, lwd=3, cex=3)
image(as.matrix(clustdf))
image(as.matrix(clustdf[order(kmeansobj$cluster),]))


data(iris)
iris.analysis <- iris
require(rpart)
tree.iris <- rpart(Species ~ Petal.Length + Petal.Width + I(Petal.Length * Petal.Width), data=iris.analysis)
summary(tree.iris)
par(mar = c(4,4,4,4))
plot(tree.iris)
text(tree.iris, cex=0.8)
iris.analysis$petal.interact <- iris.analysis$Petal.Length * iris.analysis$Petal.Width
plot(iris.analysis, col=iris.analysis$Species)









# working with colors in R
#   heat.colors()
#   topo.colros()

require(grDevices)
# colorRamp and colorRampPalette
colors()
pal <- colorRamp(c("red", "blue"))
pal(0)
pal(1)
pal(0.5)
pal(seq(0, 1, len=10))

pal <- colorRampPalette(c("red", "blue"))
pal(2)
pal(10)

# RColorBrewer
require(RColorBrewer)
smoothScatter(clustdf) 
?smoothScatter

# also use the rgb() function to control color as well as transparency (alpha)



# EDA case study, clustering
setwd("../../courses/04_ExploratoryAnalysis/CaseStudy/pm25_data/")
files <- list.files()
files[1]
files[2]

# read in PM 1999
pm0 <- read.table(files[1], comment.char = "#", na.strings = "", sep="|", header=FALSE)
cnames <- readLines(files[1], 1)
cnames
cnames <- strsplit(cnames, split = "|", fixed = TRUE)
cnames <- make.names(cnames[[1]])
names(pm0) <- cnames
# are missing values a problem here???
# does an occaisional missing value on a particular day make a big difference?
# all this depends on the type of questions we are trying to answer
mean(is.na(pm0$Sample.Value))

# read in PM 2012
pm1 <- read.table(files[2], sep="|", na.strings = "", header=FALSE, comment.char = "#")
names(pm1) <- cnames
object.size(pm1)

# Sample Value analysis
analysis0 <- pm0$Sample.Value
analysis1 <- pm1$Sample.Value

summary(analysis0)
summary(analysis1)

dates1 <- pm1$Date
dates1 <- as.Date(as.character(dates1), "%Y%m%d")

site0 <- unique(subset(pm0, State.Code == 36, c(County.Code, Site.ID)))
site0 <- paste(site0[,1], site0[,2], sep=".")
site1 <- unique(subset(pm1, State.Code ==36, c(County.Code, Site.ID)))
site1 <- paste(site1[,1], site1[,2], sep=".")

both.sites <- intersect(site0, site1)
both.sites

pm0$County.Site <- with(pm0, paste(County.Code, Site.ID, sep="."))
pm1$County.Site <- with(pm1, paste(County.Code, Site.ID, sep="."))

pm.subset0 <- subset(pm0, State.Code == 36 & County.Site %in% both.sites)
pm.subset1 <- subset(pm1, State.Code == 36 & County.Site %in% both.sites)

# let us analyze 63.2008
pm.subset.analysis0 <- subset(pm0, State.Code==36 & County.Code==63 & Site.ID==2008)
pm.subset.analysis1 <- subset(pm1, State.Code==36 & County.Code==63 & Site.ID==2008)

# remember that %in% produces a logical vector



# means
mn0 <- tapply(pm0$Sample.Value, pm0$State.Code, mean, na.rm=TRUE)
mn0
mn1 <- tapply(pm1$Sample.Value, pm1$State.Code, mean, na.rm=TRUE)
mn1

# create dataframes out of tapply means
d0 <- data.frame(state = names(mn0), value=mn0)
d1 <- data.frame(state = names(mn1), value=mn1)
merged <- merge(d0, d1, by="state")
merged
with(merged, plot(value.x, value.y))

# connect dot plot
with(merged, plot(rep(1999, 52), merged[,2], xlim=c(1998,2013)))
with(merged, points(rep(2012, 52), merged[,3]))
segments(rep(1999,52), merged[,2], rep(2012, 52), merged[,3])
