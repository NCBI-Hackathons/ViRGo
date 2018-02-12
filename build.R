#! /usr/bin/env Rscript 
library(rsconnect)

rsconnect::setAccountInfo(
  name='hsiao yi',
  token='FF2A18BB7133019B3CECB2149910DF2E',
  secret=Sys.getenv("SHINYAPPS_SECRET"))

rsconnect::deployApp(appName='virgo')