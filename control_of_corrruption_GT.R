
# Find working directory
getwd()
try(setwd("C:\Users\Natalia\Documents\GitHub\Third-Assignment"), silent = TRUE)
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
library(countrycode)

# Loading dataset of Control of Corruption - the World Bank's Governance Indicators

try(URL <- "http://info.worldbank.org/governance/wgi/index.aspx?fileName=wgidataset.xlsx", silent = TRUE)
temp <- tempfile()
download.file(URL, temp, mode='wb')
controlc <- read.xlsx2(temp, 7, sheetName = NULL, startRow = 14, endRow = 230, colIndex = NULL, as.data.frame = TRUE, header = FALSE)
unlink(temp)

# Cleaning the data of Control of Corruption

# Keeping only neccesary variables
cc <- controlc[c(2, 1, 3, 9, 15, 21, 27, 33, 39, 45, 51, 57, 63, 69, 75, 81, 87, 93)]

# Setting the years as an observation 
names(cc) = as.character(unlist(cc[1,]))
cc = cc[-1,]
row.names(cc) <- NULL
colnames(cc)[1] <- "WBCode"
colnames(cc)[2] <- "Country"

# Setting the years as an observation and ordering the data

cc <- gather(cc, Year, Estimate, 3:18)
cc <- cc[order(cc$Country, cc$Year), ]
row.names(cc) <- NULL

# Creating ID for each observation and matching coutry codes
cc <- mutate(cc, ID = rownames(cc))
cc <- cc[c(5,1,2,3,4)]

countrycode(cc$Country, "country.name","iso2c")
countrycode(cc$Country, "wb","iso2c")


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


