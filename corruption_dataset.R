#################################################################################################################################
# Corruption and Natural Resource Rents - by Natalia Alvarado and Gabriel Tarriba
# This file gathers data from various sources (World Governance Indicators and World Development Indicators), cleans it, merges
# it and organizes it for analysis (Section 1). Then, it carries out analyses on the data (Section 2)
#################################################################################################################################

################################
# Section I: Data preparation  #
################################

# 1. Set working directory
getwd()
try(setwd("C:\Users\Natalia\Documents\GitHub\Third-Assignment"), silent = TRUE)
try(setwd("/Users/Gabriel/Desktop/Third-Assignment"), silent = TRUE)

# 2. Load libraries
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
library(dplyr)
library(Hmisc)
library(WDI)
library(xlsxjars)
library(rJava)

#######################################################################################################
# Subsection I.1 -  Loading dataset of Control of Corruption - the World Bank's Governance Indicators
######################################################################################################

# 1. Get the datafile from an URL and set it as a Dataframe

try(URL <- "http://info.worldbank.org/governance/wgi/index.aspx?fileName=wgidataset.xlsx", silent = TRUE)
fname <- "worldbank_wgidataset.xlsx"
if (!(file.exists(fname))) {
  fname <- tempfile()
  download.file(URL, fname, mode='wb')
}
controlc <- read.xlsx2(fname, 7, sheetName = NULL, startRow = 14, endRow = 230, colIndex = NULL, as.data.frame = TRUE, header = FALSE)

# 2. Keep only relevant variables
cc <- controlc[c(2, 1, 3, 9, 15, 21, 27, 33, 39, 45, 51, 57, 63, 69, 75, 81, 87, 93)]

# 3. Set the years as an observation 
names(cc) = as.character(unlist(cc[1,]))
cc = cc[-1,]
row.names(cc) <- NULL
colnames(cc)[1] <- "wbcode"
colnames(cc)[2] <- "country"

# 5. Set the years as an observation and ordering the data
cc <- gather(cc, Year, Estimate, 3:18)
cc <- cc[order(cc$country, cc$Year), ]
row.names(cc) <- NULL

# 6. Create ID for each observation and matching country codes
cc <- mutate(cc, ID = rownames(cc))
cc <- cc[c(5,1,2,3,4)]
cc$iso2c <- countrycode(cc$wbcode, origin = "wb",destination = "iso2c", warn = TRUE)
cc$country <- countrycode(cc$iso2c, origin = "iso2c",destination = "country.name", warn = TRUE)
cc <- cc[c(1,6,2,3,4,5)]
cc <- cc[-c(3)]
colnames(cc)[1] <- "id"
colnames(cc)[4] <- "year"
colnames(cc)[5] <- "estimate"



#########################################################################################
# Section WDI Data from World Bank (for GDP per capita and Natural Resource Rents)    
# This section gathers WDI Data from the World Bank, cleans it, orders it and merges it
#########################################################################################

# 1. Download the relevant variables for our project:

# 1.1 Total natural resources rents (% of GDP) - 
# "Total natural resources rents are the sum of oil rents, 
# natural gas rents, coal rents (hard and soft), mineral rents, and forest rents".
totrents <- WDI(indicator = 'NY.GDP.TOTL.RT.ZS')

# 1.2 Oil rents (% of GDP) - 
# "Oil rents are the difference between the value of
# oil production at world prices and total costs of production.".
oilrents <- WDI(indicator = 'NY.GDP.PETR.RT.ZS')

# 1.3 Natural gas rents (% of GDP) - 
# "Natural gas rents are the difference between the value of
# natural gas production at world prices and total costs of production.".
gasrents <- WDI(indicator = 'NY.GDP.NGAS.RT.ZS')

# 1.4 GDP per capita (constant 2005 US$)
# "GDP per capita is gross domestic product divided by midyear population. 
# GDP is the sum of gross value added by all resident producers in the economy 
# plus any product taxes and minus any subsidies not included in the value of 
# the products. It is calculated without making deductions for depreciation of 
# fabricated assets or for depletion and degradation of natural resources. Data 
# are in constant 2005 U.S. dollars".
gdppc <- WDI(indicator = 'NY.GDP.PCAP.KD')

# 1.5 Unemployment, total (% of total labor force) (modeled ILO estimate)
# Unemployment refers to the share of the labor force that is without 
# work but available for and seeking employment.
unemp <- WDI(indicator = 'SL.UEM.TOTL.ZS')

# 1.6 CPIA transparency, accountability, and corruption 
# in the public sector rating (1=low to 6=high)
# "Transparency, accountability, and corruption in the public sector assess 
# the extent to which the executive can be held accountable for its use of 
# funds and for the results of its actions by the electorate and by the 
# legislature and judiciary, and the extent to which public employees within
# the executive are required to account for administrative decisions, use of 
# resources, and results obtained. The three main dimensions assessed here
# are the accountability of the executive to oversight institutions and of 
# public employees for their performance, access of civil society to 
# information on public affairs, and state capture by narrow vested interests".
governance <- WDI(indicator = 'IQ.CPA.TRAN.XQ')

# 2. Merge the six data frames into one using country code and year

wdi <- merge(gasrents, gdppc,by=c("iso2c","year","country"), all = TRUE)
wdi <- merge(wdi, governance,by=c("iso2c","year","country"), all = TRUE)
wdi <- merge(wdi, oilrents,by=c("iso2c","year","country"), all = TRUE)
wdi <- merge(wdi, totrents,by=c("iso2c","year","country"), all = TRUE)
wdi <- merge(wdi, unemp,by=c("iso2c","year","country"), all = TRUE)

# Make the variable "country" in both datasets match
wdi$country <- countrycode(wdi$iso2c, origin = "iso2c",destination = "country.name", warn = TRUE)

# Make last merge
wdi <- merge(wdi, cc,by=c("iso2c","year", "country"), all = TRUE)

# 3. Rename the variables so they are easy to identify
# merge two data frames by ID and Country
wdi <- rename  (wdi,
                totrents = NY.GDP.TOTL.RT.ZS,
                oilrents = NY.GDP.PETR.RT.ZS,
                gasrents = NY.GDP.NGAS.RT.ZS,
                gdppc = NY.GDP.PCAP.KD,
                unemp = SL.UEM.TOTL.ZS,
                governance = IQ.CPA.TRAN.XQ,
                corrupest = estimate,
                country = country)
wdi <- wdi[-c(6, 10)]
wdi <- wdi[c(1,2,3,9,4,5,6,7,8)]

# Elimiate observations not belonging to a
wdi <- wdi[- grep("1", wdi$iso2c),]
wdi <- wdi[- grep("4", wdi$iso2c),]
wdi <- wdi[- grep("7", wdi$iso2c),]
wdi <- wdi[- grep("8", wdi$iso2c),]

# Eliminate all missing cases
wdi <- na.omit(wdi)


############################################################################################
############################################################################################

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


