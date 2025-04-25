install.packages(c("ISLR", "e1071"))
library(ISLR)
set.seed(12345)
# Generate our data
x = matrix(runif(40*2),ncol = 2)
y = c(rep(-1, 20), rep(1, 20))
x[y == 1, ] = x[y == 1, ] + 0.5
plot(x, col = (3 - y))
dat = data.frame(x = x, y = as.factor(y))
library(e1071)
# cost here is C in the above SVM formulation
# linear SVM
svmfit = svm(
  y ~ .,
  data = dat,
  kernel = "linear",
  cost = 10,
  scale = FALSE
)
plot(svmfit, dat)
# which vectors are the support vectors ? ( this will
# give the row numbers )
svmfit$index
summary(svmfit)
# change C
svmfit = svm(
  y ~ .,
  data = dat,
  kernel = "linear",
  cost = 0.1,
  scale = FALSE
)
plot(svmfit, dat)
# more support vectors !
svmfit$index
# How to choose a best C ?
# run the SVM with a bunch of different C values
tune.out = tune(svm,
                y ~ .,
                data = dat,
                kernel = "linear",
                ranges = list(cost = c(0.001, 0.01, 0.1, 1, 10, 100)))
summary(tune.out)
# which model is best ?
best = tune.out$best.model
summary(best)

# How well do we do in classifying ?
# make some test data
xtest = matrix (runif (100 * 2) , ncol = 2)
ytest = c(rep(-1, 50), rep(1, 50))
xtest [ytest == 1, ] = xtest[ytest == 1, ] + 0.5
plot(xtest, col = (3 - ytest))
testdata = data.frame(x = xtest, y = as.factor(ytest))
# run our best model to fit the test data
ypred = predict (best, testdata)
table(predict = ypred, truth = testdata$y)
svmfit = svm(
  y ~ .,
  data = dat,
  kernel = "linear",
  cost = 10,
  scale = FALSE
)
ypred = predict (svmfit, testdata)
table (predicted = ypred, truth = testdata$y)

