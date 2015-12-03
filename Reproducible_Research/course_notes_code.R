# Reproducible research
# course 5

# prevent losing a little code here and there
# make all things reproducible, use knitr

# it's about communicating exactly what you have done
# so someone else can fully understand what you have done

# the ultimate standard in science is REPLICATION!
# other scientists will need to investigate the same question
# especially important in studies with policy or regulatory ramification

# reproduce the analytical code and process
# since replication is not always possible due to
#   time, money, unique situations

# For every field X, there is a field Computational X
# computing power has also allowed us to create much more complex
# and sophisticated models and analyses


setwd("~/OneDrive/Coursera/JHU_DataSpecialization/data_science_jhu_repo/Reproducible_Research/")
getwd()
list.files()



require(kernlab)
data(spam)
head(spam)
??spam
table(spam$type)
table(spam$type) / nrow(spam)

# set seed and create test and training
set.seed(1234)
trainIndicator <- rbinom(4601, size=1, prob=0.5)

trainSpam <- spam[trainIndicator==1,]
testSpam <- spam[trainIndicator==0, ]
names(trainSpam)
table(trainSpam$type)

plot(log10(trainSpam$capitalAve+1)~trainSpam$type)
hclust <- hclust(dist(t(log10(trainSpam[,1:55]+1))))
plot(hclust)
hclust

trainSpam$numType <- ifelse(trainSpam$type == "spam", 1, 0)

# use charDollar and capitalAve for logistic regression
predictModel <- glm(numType~charDollar + capitalAve, data=trainSpam, family = "binomial")
predictTest <- predict(predictModel, testSpam, type="response")
predictTest
predictedSpam <- rep("nonspam", dim(testSpam)[1])
predictedSpam[predictTest > 0.5] <- "spam"
predictedSpam
table(predictedSpam, testSpam$type)

# error rate
1-mean(predictedSpam==testSpam$type)
# accuracy rate
mean(predictedSpam == testSpam$type)





