
# Find working directory
getwd()
# try(setwd("C:/Users/Natalia etc"), silent = TRUE)
try(setwd("/Users/Gabriel/Desktop/Third-Assignment"), silent = TRUE)

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
library(plm)
library(tidyr)

# Loading dataset of Control of Corruption - the World Bank's Governance Indicators

URL <- "http://info.worldbank.org/governance/wgi/index.aspx?fileName=wgidataset.xlsx"
temp <- tempfile()
download.file(URL, temp, mode='wb')
controlc <- read.xlsx2(temp, 7, sheetName = NULL, startRow = 14, endRow = 230, colIndex = NULL, as.data.frame = TRUE, header = FALSE)
unlink(temp)

# Cleaning the data of Control of Corruption

# Changing the order of rows 1 and 2 
controlc <- rbind(controlc[c(2,1),], controlc[-c(1,2),])
row.names(controlc) <- NULL

# Setting the new row 1 as header
names(controlc) = as.character(unlist(controlc[1,]))
controlc = controlc[-1,] 
row.names(controlc) <- NULL

# Keeping only neccesary variables
cc <- controlc[c(1, 2, 3, 9, 15, 21, 27, 33, 39, 45, 51, 57, 63, 69, 75, 81, 87, 93)]

# Setting the years as an observation 
names(cc) = as.character(unlist(cc[1,]))
cc = cc[-1,]
row.names(cc) <- NULL
colnames(cc)[1] <- "Country"
colnames(cc)[2] <- "WBCode"

# Setting the years as an observation and ordering the data

cc <- gather(cc, Year, Estimate, 3:18)
cc <- cc[order(cc$Country, cc$Year), ]
row.names(cc) <- NULL

cc <- gather(controlc, Country/Territory, WBCode, Estimate, StdErr, NumSrc, Rank, Lower, Upper, 1996:2014)





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


