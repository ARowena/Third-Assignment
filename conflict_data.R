#########################################################################################
# UCDP/PRIO Armed Conflict Dataset: Data Gathering, Tidying and Preparing for Merge
# ***UCDP/PRIO Armed Conflict Dataset v.4-2015, 1946 – 2014***
# Content: a conflict-year dataset with information on armed conflict where at 
# least one party is the government of a state in the time period 1946-2014. 
# The most recent is version 4-2015.
#########################################################################################

# 1. Download the data from website of Uppsala University's Department of Peace and Conflict Research
download.file("http://www.pcr.uu.se/digitalAssets/124/124920_1ucdp-prio-2015.rdata", "temp.rData")
load("temp.rData")



