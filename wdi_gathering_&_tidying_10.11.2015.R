#########################################################################################
# WDI Data from World Bank (for GDP per capita and Natural Resource Rents)    
# This file gathers WDI Data from the World Bank, cleans it, orders it and merges it
#########################################################################################

# 1. Download WDI package and the required RJSONIO package
install.packages("WDI", "RJSONIO")
install.packages("Hmisc")

# 2. Load packages
library(WDI)
library(dplyr)
library(Hmisc)

# 3. Download the relevant variables for our project:

# 3.1 Total natural resources rents (% of GDP) - 
# "Total natural resources rents are the sum of oil rents, 
# natural gas rents, coal rents (hard and soft), mineral rents, and forest rents".
totrents <- WDI(indicator = 'NY.GDP.TOTL.RT.ZS')

# 3.2 Oil rents (% of GDP) - 
# "Oil rents are the difference between the value of
# oil production at world prices and total costs of production.".
oilrents <- WDI(indicator = 'NY.GDP.PETR.RT.ZS')

# 3.2 Natural gas rents (% of GDP) - 
# "Natural gas rents are the difference between the value of
# natural gas production at world prices and total costs of production.".
gasrents <- WDI(indicator = 'NY.GDP.NGAS.RT.ZS')

# 3.3 GNI per capita, PPP (constant 2011 international $)
# "GNI per capita based on purchasing power parity (PPP). 
# PPP GNI is gross national income (GNI) converted to international
# dollars using purchasing power parity rates. An international dollar
# has the same purchasing power over GNI as a U.S. dollar has in the
# United States. GNI is the sum of value added by all resident producers
# plus any product taxes (less subsidies) not included in the valuation of
# output plus net receipts of primary income (compensation of employees 
# and property income) from abroad. Data are in constant 2011 international dollars".
gnipc <- WDI(indicator = 'NY.GNP.PCAP.PP.KD')

# 3.4 Unemployment, total (% of total labor force) (modeled ILO estimate)
# Unemployment refers to the share of the labor force that is without 
# work but available for and seeking employment.
unemp <- WDI(indicator = 'SL.UEM.TOTL.ZS')

# 3.5 CPIA transparency, accountability, and corruption 
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

# 4. Merge the six data frames into one using country code and year
# We can't merge all six at once, so we merge two dataframes at a time, in five steps
wdi <- merge(gasrents, gnipc,by=c("iso2c","year","country"))
wdi <- merge(wdi, governance,by=c("iso2c","year","country"))
wdi <- merge(wdi, oilrents,by=c("iso2c","year","country"))
wdi <- merge(wdi, totrents,by=c("iso2c","year","country"))
wdi <- merge(wdi, unemp,by=c("iso2c","year","country"))

# 5. Let's rename the variables so they are easy to identify
# merge two data frames by ID and Country
wdi <- rename  (wdi,
              totrents = NY.GDP.TOTL.RT.ZS,
              oilrents = NY.GDP.PETR.RT.ZS,
              gasrents = NY.GDP.NGAS.RT.ZS,
              gnipc = NY.GNP.PCAP.PP.KD,
              unemp = SL.UEM.TOTL.ZS,
              governance = IQ.CPA.TRAN.XQ)

# 6. We label the variables using the WDI World Bank definitions




