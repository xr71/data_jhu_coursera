# statistical inference
# course 6

#####################################################################
# probability

# given a random experiment, a probability measure is a population
#   quantity that summarizes the randomness
# so this is not the measure in your data, but some conceptual
#   existence in the real world

# RULES
#   nothing occurs is 0
#   something occurs is 1
#   probability that something happens is 1 minus the opposite
#   the probability that at least one of a set of things that cannot 
#       simultaneously happen (mutual exclusive) is the sum of their 
#       respective probabilities
#   if event A implies the occurence of event B, then the probability
#       of A occuring is less than the probability that B occurs
#   for any two events, the probability that at least one occurs is the
#       sume of their respective probabilities minus their intersection




# Probability calculus - mass functions
#   random variable - the outcome of an experiment (numeric)

coin <- rbinom(100, 1, 0.5)
mean(coin)

x <- matrix(0, 1, 100)
for (i in 1:100) {
    coin <- rbinom(i, 1, 0.5)
    print(mean(coin))
    x[i] <- mean(coin)
}
hist(x)

# a probability mass function
#   must always be equal to or larger than 0
#   the sum of all possible values that the variable can take 
#       must add up to 1


# pdf (probability density function)
#   continuous random variables
#       total area under density is 1
#       must be larger or equal to 0 everywhere

# the probability measurement is not about the data
# but rather the "truth" of the population at large

pbeta
# a beta distribution
pbeta(0.75, 2, 1)
qbeta(0.5, 2, 1)
pbeta(0.5, 2, 1)



# Bayes' rule
# reverse conditional probabilities
# we have P(A|B) --> P(B|A)

# note sensitivity and specificity
#   sensitivity is P(+|D)
#   specificity is P(-|~D)

# concern is P(D|+)
# concern is P(~D|-)
# prevalance of disease then is simply P(D)

#   P(D|+) = P(+|D) * P(D) / ( P(+|D) * P(D) + (1-P(+|D)) * (1-P(D)) )


# likelihood ratios
# P(D|+) / P(~D|+) = P(+|D)/P(+|~D) * P(D)/P(~D)

# therefore: post test odds of D = DLR_+ * pre test odds of D

# DLR_- is then (1-P(+|D))/(P(-|~D))





require(UsingR)
require(swirl)
# Introduction Probability 
# statistical inference involves formulating conclusions using data
# AND quantifying the uncertainty associated with those conclusions

# KEY POINTS
#   1. a statistic (singular) is a number computed from a sample of data
#       We use statistics to infer information about a population
#   2. a random variable is an outcome from an experiment
#       deterministic processes, applied to random variables, produce
#       additional random variables which have their own distributions
#       It is very important to keep straight which distributions you're talking about


# TWO BROAD FLAVORS OF INFERENCE
#   1. frequency - uses long run proportion of times an event occurs
#       in independent, identically distributed repetitions
#   2. bayesian - the probability estimate for a hypothesis is updated
#       as additional evidence is acquired
# both flavors require an understanding of probability



# Probability part 1
# PROBABILITY - is the study of quantifying the likelihood of particular events occuring


# P(E) is always between 0 and 1
# the sum of all P(E) is 1
# if A and B are two independent events, then 
#   P(A&B) = P(A) * P(B)

# For example, rolling two 4's is 1/36
# but rolling two same numbers if 1 * 1/6 = 1/6

# If E occur in more than one way, and they are disjoint (mutually exclusive)
#   P(E) is then the sum of the probabilities of each of the ways
#   in which it can occur

# The probability of at least one of two events, A and B, occuring
#   is the sum of their individual probabilities minus their
#    intersection probability
#   P(A U B) = P(A) + P(B) - P(A&B)


# However, if A and B are disjoint or mutually exclusive
#   then P(A U B) = P(A) + P(B)

# For example, the probability of rolling a number greater
#   than 10 is 2/36 + 1/36 or 3/36
# It then follows that the probability of rolling a number
#   equal to and less than 10 (q) is 1-3/36 or 33/36


# 52 cards in a deck, 4 suits of 13 cards each
#   two red suits, diamonds and hearts
#    two black suits, spades and clbus
#
# examples:
# probability of drawing a face card is 12/52
# probability of drawing a second face card without replacement is 11/51
# probabiliy of drawing a face card of same suit without replacement 
#   is 2/51




#####################################################################
# a random variable is simply the numerical outcome of an experiment
# it can be discrete or continuous

# A probability mass function (PMF) gives the probability 
# that a discrete random variable is exactly equal to some value

# PDF is a function that describes the relative likelihood for this 
# random variable to take on a given value
# The probability of the random varialbe falling within a particular
# range of values is given by the area under the density function
# but above the horizontal axis and between the lowest and greatest values

# IN OTHER WORDS, it must be non-negative everywhere
#   and the area under it must equal one




# The cumulative distribution function (CDF) of a random variable X,
# is the function F(x) equal to the probability that X is less than
# or equal to x

# The CDF can be derived to the PDF when X is continuous
# so integrating the PDF yields the CDF

mypdf <- function(x) {x/2}
integrate(mypdf, 0, 1.6)



# The survivor function, S(x) is then the complement of CDF F(x)
# And the percentile is simply the number expected to fall to the left of F(x)




#####################################################################
# Conditional probability
# The probability of rolling a 3 is 1/6
#   But the probability of rolling a 3 given the roll is odd is now 1/3
# Hence, the probability of this second event is conditional on this new information
# Probability of A given that B occurred is P(A|B)


# P(A|B) = P(A&B) / P(B)

# So, what is the probability of rolling a 3 and the die being odd
# Given that rolling a 3 is a subset of rolling an odd, the probability
#   of both A and B is simply the probability of A



# P(A|B) = P(A&B) / P(B) 
#   Therefore:
# P(A&B) = P(A|B) * P(B) 
#   So:
# P(B|A) = P(B&A) / P(A) = (P(A|B) * P(B)) / P(A)

# This is a simplified Bayes' Rule, which relates the two
#   conditional probabilities




# Suppose we only know P(A|B) and P(A|~B) 
# We can then express:
#   P(A) = P(A|B) * P(B) + P(B) + P(A|~B)

# P(B|A) = P(A|B) * P(B) / (P(A|B) * P(B) + P(A|~B) * P(~B))







# Suppose we know the positive result when the patient has HIV
# and the negative result when the patient deson't have HIV
#   These are referred to as test sensitivity and specificity

# Therefore, we know:
#   P(+|D) and P(-|~D)   where D is the event that the patient has HIV

# So if we want to know if a patient actually has D given a + test
# by bayes theorem:
# P(D|+) = P(+|D) * P(D) / ( P(+|D) * P(D) + P(+|~D) * P(~D) )

# So, we now have what we need!
#   Disease prevalence is 0.001
#   Test sensitivity is 99.7%
#   Test specificity is 98.5% (P(-|D))
#
# So, P(+|D) * P(D) = 0.997 * 0.001
# and the P(+|~D) * P(~D) = (1-.985) * 0.999


# Now, probability of disease given a positive test result
# P(D|+) = (P(+|D) * P(D)) / ( (P(+|D) * P(D) + P(+|~D) * P(~D)) )
(0.997*0.001) / ( (0.997*0.001) + (.015 * 0.999) )

# So, the positive predictive value is roughly 6%
# P(~D|-) i then called the negative predictive value









# Basic Independence
# Two events are independent if P(A&B) = P(A) * P(B)
# Thus, P(A|B) is equal to simply P(A)

# IID is "independent and identically distributed"






#####################################################################
# Expected Values


# the expected value is p

# expected values are properties of distributions
# averages of random variables themselves are random variables and therefore have expected values
# center of this distribution is roughly the same as its original distribution
#       when this happens, the estimator is UNBIASED

# a mean is an expected value if all the numbers used to get E(X) are equally weighted

# expected value operation is linear
#   if c is a constant, then E(cX) = c*E(X)
#   if X and Y are two random variables, then 
#       E(X+Y) = E(X) + E(Y)
#   it follows then that
#       E(aX+bY) = aE(X) + bE(Y)


# for a continuous variable, the expected value integrates over a continuous function
#   so, E(X) = t*f(t) where f(t) is the PDF of X


# the expected value or mean of the sample mean is the population
# this sample mean is an unbiased estimator of the population mean


# an estimator e of some parameter v is unbiased if its
#   expected value equals v, i.e. E(e) = v

# the mean mu, of X_1, X_2, ..., X_n is (X_1 + X_2 +...+X_n) / n
#   1/n * (E(X_1) + E(X_2) + ... + E(X_n)) 
# therefore: (1/n)*n*mu = mu



# RECAP: 
#   expected values are properties of distributions
#   The average or mean of random variables is itself a random varialbe
#   and its associated distribution itself has an expected value


