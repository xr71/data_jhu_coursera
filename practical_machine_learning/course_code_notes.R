# Practical machine learning
# course 8

setwd("~/OneDrive/Coursera/JHU_DataSpecialization/data_science_jhu_repo/practical_machine_learning/")
getwd()
list.files()


require(kernlab)
require(caret)
data(spam)
head(spam)

ggplot(data=spam, aes(charDollar, colour=type)) + geom_density()
ggplot(data=spam, aes(charDollar, colour=type)) + geom_density() + xlim(0,1)

# most simple model
prediction <- ifelse(spam$charDollar > 0.1, "spam", "nonspam")
table(prediction)
table(prediction, spam$type)
mean(prediction==spam$type)
# using just visualization and a single predictor, we scored 77.5% accurately



###############################################################################
# The caret package
# caret will allow you to make predictions without specifying all the parameters
# there is a universal syntax for training the data set into a model

inTrain <- createDataPartition(y=spam$type, p=0.6, list=F)
inTrain
training <- spam[inTrain,]
testing <- spam[-inTrain,]
summary(training)
dim(training)
summary(testing)
dim(testing)


# modeling using glm
set.seed(3234)
modelFit <- train(type ~ . , data=training, method="glm")
modelFit

modelFit2 <- train(type ~ address + our + free + business + your + num000 + money + hp + hpl + george + num650 + technology + pm + meeting + project + re + edu + conference + charExclamation + charDollar + charHash + capitalAve + capitalLong + capitalTotal, data=training, method="glm")
modelFit2
modelFit2$finalModel
predictions <- predict(modelFit2, newdata=testing)
table(predictions)
cm <- confusionMatrix(predictions, testing$type)
accuracy <- cm$overall[1]
accuracy





###############################################################################
# data slicing

# creating k folds validation
set.seed(32323)
folds <- createFolds(y=spam$type, k=10, list=T, returnTrain=T)

sapply(folds, length)


folds <- createFolds(y = spam$type, k=10, list=T, returnTrain=F)
sapply(folds, length)

folds[[1]]

# for bootstrap
folds <- createResample(y = spam$type, times = 10, list = T)
sapply(folds, length)

# use createTimeSlices() to create blocks of time series data 




#####################################################################
# training options
args(train.default)
# metric options here include Rsq and RMSE
# and for categorical, Accuracy and Kappa

# trainControl function for parameter trControl= trainControl()
args(trainControl)



# very important to explore first by plotting the predictors
require(ISLR)
data(Wage)
head(Wage)
ggplot(data=Wage, aes(wage, colour=jobclass)) + geom_density()
qplot(data=Wage, age, wage, colour=jobclass, geom = "point")

ggplot(data=Wage, aes(age, wage, colour=education)) + geom_point()

# feature plot from Caret
featurePlot(x=Wage[, c("age", "wage")], y=Wage$wage)
featurePlot(x=Wage[, c("age", "jobclass", "maritl", "race")], y=Wage$wage, "pairs", jitter=T)




# cutting the data set
require(Hmisc)
cutWage <- cut2(Wage$wage, g=5)
cuts <- cut(Wage$wage, 5)
table(cuts)
table(cutWage)

Wage$wage_cuts <- cuts

wage_cut_sum <- Wage %>% group_by(wage_cuts) %>% summarise(count=n(), mean_wage=mean(wage))

hist(Wage$wage)
abline(v=mean(Wage$wage), lwd=5, col="red")
abline(v=median(Wage$wage), lwd=5)

ggplot(data=Wage, aes(age, wage, colour=jobclass)) + geom_point(size=3, alpha=0.5, position="jitter") + facet_wrap(~wage_cuts)

ggplot(data=Wage, aes(cutWage, age)) + geom_point(position="jitter") + geom_boxplot(aes(fill=cutWage), alpha=0.8)

prop.table(table(cutWage, Wage$jobclass), 1)
prop.table(table(cutWage, Wage$jobclass), 2)
prop.table(table(cutWage, Wage$jobclass))


prop.table(table(cuts, Wage$jobclass), 1)
prop.table(table(cuts, Wage$jobclass), 2)
prop.table(table(cuts, Wage$jobclass))


smoothScatter(Wage$age, Wage$wage)
?smoothScatter
pairs(Wage[, c(5, 2, 12)], diag.panel = function(...) {smoothScatter(..., add=T)})
names(Wage)
pairs(Wage[, c(2,11,12)], panel = function(...) {smoothScatter(..., add=T)})

#####################################################################
# feature creation
# creating tidy data for machine learning algorithms

# Level 1
#   Raw Data --> features
#       identify features of email, images, frequency of raw
#       this is about summarization, not information loss
#       when in doubt, err on side of more features!
# Level 2
#   Tidy Data --> new features
#       more necessary for some methods like regression or svm
#       should be done only on the training set!
#       best approach is through exploratory analysis
#       new covariates should be added to training dataframe



# one of the most common feature creation step is to create dummy variables out of 
#   classification variables
# another common feature creation step is to remove variables with zero or 
#   near zero variaiblity

nearZeroVar(Wage, saveMetrics = T)

# look at the gam() method for multi-variate smoothing





#####################################################################
# PCA
#   Create a new combined variable from variables that are closely related
#   First goal is statitiscal, second goal is compression
#   1. find a new set of multivariates that are uncorrelated but explain high variance
#   2. put the variables in a matrix and find the best subset matrix

# take a look at prComp
# prComp$rotation shows the summation in a matrix

typeColor <- ifelse(spam$type == "spam", 2, 1)
prComp <- prcomp(log10(spam[,-58]+1))
prComp$rotation
plot(prComp$x[,1], prComp$x[,2], col=typeColor)

# you can also do this using the method="pca"
# in the preProcess function in the caret package







#####################################################################
# learning using regression
data(faithful)
set.seed(333)
inTrain <- createDataPartition(y=faithful$waiting, p=0.5, list=F)
trainFaithful <- faithful[inTrain,]
testFaithful <- faithful[-inTrain,]
head(trainFaithful)

plot(trainFaithful$waiting, trainFaithful$eruptions)
lm1 <- lm(eruptions~waiting, data=trainFaithful)
lm1
summary(lm1)
abline(lm1)

plot(trainFaithful$waiting,trainFaithful$eruptions)
lines(trainFaithful$waiting, lm1$fitted)
coef(lm1)
coef(lm1)[1]
coef(lm1)[2]


# assess on the test set
mean(testFaithful$eruptions)
sqrt(sum((lm1$fitted-trainFaithful$eruptions)^2))
sqrt(sum((predict(lm1, newdata=testFaithful)-testFaithful$eruptions)^2))
# very good validation
#   training RMSE is 5.75186
#   testing RMSE is 5.838559
pred_int <- predict(lm1, newdata=testFaithful, interval = "prediction")
pred_int
ord <- order(testFaithful$waiting)
plot(testFaithful$waiting, testFaithful$eruptions)
matlines(testFaithful$waiting, pred_int, type='l')



# in a multivariate regression modeling setting, it is even
# more important to focus on which predictors to choose
# that goes into the model in the first place

summary(Wage)
wage.analysis <- Wage
wage.analysis$logwage <- log10(wage.analysis$wage)
summary(wage.analysis$logwage)
hist(wage.analysis$logwage)

set.seed(123)
inTrain <- createDataPartition(y=Wage$wage, p=0.6, list=F)
training <- Wage[inTrain,]
testing <- Wage[-inTrain,]
dim(training)
dim(testing)

featurePlot(x=training[, c("age", "education")], y=training$wage, plot="pairs")

plot(training$age, log10(training$wage), col=training$jobclass)

ggplot(data=training, aes(age, wage, colour=education)) + geom_point() + scale_y_log10() + facet_wrap(~jobclass)



# multivariate regression
multifit <- train(wage ~ age + education + jobclass, data=training,method="glm")
multifit
multi_final <- multifit$finalModel
print(multi_final)

plot(multi_final)

# plot residuals by other variables
ggplot(aes(multi_final$fitted, multi_final$residuals, colour=race), data=training) + geom_point(alpha=0.7, position="jitter")

smoothScatter(multi_final$fitted, multi_final$residuals)


# plot residuals by index
plot(multi_final$residuals, pch=19)
# notice the end tail patterns
# some variable is probably missing

plot(predict(multi_final), training$wage)

# multivariate regression is best when blended with other machine learning algorithms




#####################################################################
# Decision Trees
# splits are based on Information Gain or I-Gain
#   purity mesurement or entropy reduction

data(iris)
tree_mod <- train(Species ~ ., method = "rpart", data=iris)
plot(tree_mod$finalModel, uniform=T)
require(rattle)
fancyRpartPlot(tree_mod$finalModel)
tree_mod$finalModel



# bagging
# combined word known as bootstrap aggregating
require(ElemStatLearn)
data(ozone, package = "ElemStatLearn")
head(ozone)
# we can use various bagging functions here 




# random forrests
# multiple decision trees
#   bootstrap samples
#   at each split, bootstrap variables
#   grow multiple tress and vote

rf_mod <- train(Species ~ ., data=iris, method="rf", prox=T)
rf_mod
rf_mod$finalModel
cc <- classCenter(iris[, c(3,4)], iris$Species, rf_mod$finalModel$prox)
plot(cc)
plot(iris$Petal.Length, iris$Petal.Width, col=iris$Species)
points(cc, col="blue", pch="+", cex=2)



# use random forrest cross validation to prevent overfitting
??rfcv



#####################################################################
# boosting
#   take lots of potentially weak predictors
#   weight them and add them up
#   get a strong predictor

# most common is adaboost
#   rmeir boosting tutorial

# boosting libraries
#   gbm for boosting with tress
#   mboost for model based boosting
#   ada for additive logistic regression boosting
#   gamBoost for generalized additive models boosting
data(Wage)
head(Wage)
wage.analysis <- subset(Wage, select = -c(logwage))
head(wage.analysis)
inTrain <- createDataPartition(y=wage.analysis$wage, p=0.6, list=F)
training <- wage.analysis[inTrain, ]
testing <- wage.analysis[-inTrain, ]
modFitBoost <- train(wage~., method="gbm", data=training, verbose=F)

modFitBoost
modFitBoost$finalModel



#####################################################################
# model based predictions 

# basic idea is to 
#   1. assume that the data follow a probabilistic model
#   2. Use bayes' theorem to identify optimal classifiers
#
# approach
#   1. parametric model that P(Y=k|X=x)
#   2. apply bayes theorem
#   3. prior probabilities set in advance
#   4. common choice for fk(x) is the gaussian distribution
#   5. estimate the parameters from the data
#   6. calculate the probability that y belongs to any given class given predictor variable(s)

# LDA (linear discriminant analysis) follows this approach
data(iris)
modlda <- train(Species ~ ., data=iris, method="lda")
modlda$finalModel
table(predict(modlda, iris))
table(predict(modlda, iris), iris$Species)
mean(predict(modlda, iris) == iris$Species)

modnb <- train(Species~., data=iris, method="nb")
modnb$finalModel
table(predict(modnb, iris))
table(predict(modnb, iris), iris$Species)
mean(predict(modnb, iris) == iris$Species)



#####################################################################
# regularization



#####################################################################
# 




#####################################################################
# forecasting
require(quantmod)
from.date <- as.Date("01/01/2013", "%m/%d/%Y")
to.date <- as.Date("12/31/2014", "%m/%d/%Y")

getSymbols("FULT", src="google", from=from.date, to=to.date)
head(FULT)
summary(FULT)

dFULT <- to.daily(FULT)
opFULT <- Op(dFULT)
ts1 <- ts(opFULT)
head(ts1)
plot(ts1)

plot(decompose(ts1))

# look up Rob Hyndman's Forecasting Principles and Practices

# look up quandmod and quandl packages
