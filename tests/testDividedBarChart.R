# make some data
months <-rep(c("jan", "feb", "mar", "apr", "may", "jun", 
               "jul", "aug", "sep", "oct", "nov", "dec"), 2)
chickens <-c(1, 2, 3, 3, 3, 4, 5, 4, 3, 4, 2, 2)
eggs <-c(0, 8, 10, 13, 16, 20, 25, 20, 18, 16, 10, 8)
values <-c(chickens, eggs)
type <-c(rep("chickens", 12), rep("eggs", 12))
mydata <-data.frame(months, values)

library(ggplot2)
p <- ggplot(mydata, aes(months, values)) + geom_bar(stat = "identity")

# Reorder months
mydata$months <- factor(mydata$months, levels = c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"))

p <- ggplot(mydata, aes(months, values)) + geom_bar(stat = "identity", aes(fill = type))


##############

g <- ggplot(mpg, aes(class))
# Number of cars in each class:
g + geom_bar()

g + geom_bar(aes(weight = displ))

g + geom_bar(aes(fill = drv))
