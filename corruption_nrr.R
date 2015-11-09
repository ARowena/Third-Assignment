# Find working directory
getwd()

# Set root as working directory
setwd('/')

# Load libraries
library(httr)
library(dplyr)
library(xlsx)
library(rio)
library(stargazer)
library(Zelig)
library(repmis)
library(tidyr)

# Loading dataset of Control of Corruption - the World Bank

URL <- "http://info.worldbank.org/governance/wgi/index.aspx?fileName=wgidataset.xlsx"
temp <- tempfile()
download.file(URL, temp, mode='wb')
controlc <- read.xlsx2(temp, 7, sheetName = NULL, startRow = 14, endRow = 230, colIndex = NULL, as.data.frame = TRUE, header = FALSE)
unlink(temp)

# Cleaning the data
controlc %>% arrange()
rownames()
controlc2 <- gather(controlc, "Estimate", "Std. Error", NumSrc, Rank, Lower, Upper, 1996:2014)





names(controlc) <- c("Country", "WBCode", "Estimate", "Std. Error", "NumSrc", "Rank", "Lower", "Upper")

# World Bank Dataset
data("XXXXXX")
# To see the name of variables
names("XXXXXXXXXX")
# Histogram
hist(xxx$yyyyy)
# Mean
mean(XXX$yyyy)
#boxplot
boxplot(swiss$Examination, main = 'blah')



?Wages
summary(Wages)
M1 <- lm(lwage ~ ed, data = Wages)
M2 <- lm(lwage ~ ed + exp, data = Wages)
summary(M1)
confint(M1)

labels <- c('')
stargazer::stargazer(M1, M2, title='OLS regression of the Percentage of Wages Variation', type= 'html', digits=2, header = FALSE)

###Panel Data###

ts(data = Wages, start = (1976), end = (1982), frequency = 4165,
   deltat = 1, ts.eps = getOption("ts.eps"), class = , names = )
M3 <- plm(lwage ~ exp, data = Wages)
summary(M1)
confint(M1)
