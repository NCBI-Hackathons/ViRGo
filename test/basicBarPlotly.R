library(plotly)

data <- data.frame(
  time = factor(c("Lunch","Dinner"), levels=c("Lunch","Dinner")),
  total_bill = c(14.89, 17.23)
)

p <- ggplot(data=data, aes(x=time, y=total_bill)) +
  geom_bar(stat="identity")

p <- ggplotly(p)
