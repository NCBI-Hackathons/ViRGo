myList = c(c("ABE;HED;WJG;WEGJEI"),c(""),c("1253;hre;OIJIOE"),c(""))
Status = c("Working", "NotWorking", "Working", "NotWorking")
myDat = data.frame(myList=myList, Status=Status)

strsplit(myDat$myList, split = ";")

myList = c(c("ABE;HED;WJG;WEGJEI"),c(""),c("1253;hre;OIJIOE"),c(""))
Status = c("Working", "NotWorking", "Working", "NotWorking")
myDat = data.frame(myList=myList, Status=Status)

strsplit(myDat$myList, split = ",")

myDat %>% 
  mutate(myList = strsplit(as.character(myList), ";")) %>% 
  unnest(myList)


myList2 = c(c("ABE",c("HED"),c("WJG"),c("WEGJEI"),c(""),c("1253"),c("hre"),c("OIJIOE"),c("")))
Status2 = c(c("Working"),c("Working"),c("Working"),c("Working"),c("NotWorking"),c("Working"),c("Working"),c("Working"),c("NotWorking"))
myDat2 = data.frame(myList=myList2, Status=Status2)
