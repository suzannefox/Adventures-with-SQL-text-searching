# ====================================================================
# libraries
# ====================================================================

library(RODBC)
library(tidyverse)
library(data.table)

# ====================================================================
# read file
path.dir <- "D:\\Suzanne\\AddressSearching\\AddressBase\\TestMatching\\"
path.file <- "sample.csv"
origdata.test <-  fread(paste0(path.dir,path.file))

# ====================================================================
# test file
data.test <- origdata.test %>%
  select(V1, ttwa11nm, country, property_number, street_name, post_town,  outcode,  incode, displayable_address) %>%
  mutate(test_address=paste(property_number, displayable_address))

# ====================================================================
# have a look at those with no country
data.foreign <- origdata.test %>%
  filter(country == '') 

# ==============================================
# Setup SQL
# ==============================================

SqlServer <- ".\\SQLEXPRESS"
SqlDatabase <- 'abp_search'

SqlConnection <- paste0('driver={SQL Server};server=',
                        SqlServer,
                        ';database=',
                        SqlDatabase,
                        ';trusted_connection=true;rows_at_time=1')

# ==============================================
# Queries

dbhandle <- odbcDriverConnect(SqlConnection)

for (i in 1:nrow(data.test)) {
  SqlAddress <- data.test[i,c("test_address")]
  SqlQuery <- paste0("exec usp_SearchForAddress '",SqlAddress,"'")
  print(SqlQuery)

  #                   "exec usp_SearchForAddress '2 church street shipston-on-stour'",
  
  data.query <- sqlQuery(dbhandle,
                         SqlQuery,
                         as.is=T)
  
  if (is.null(nrow(data.query))) {
    xx <- data.frame(SearchAddress=SqlAddress,
                     RecordsMatched=0,
                     ReturnedAddress="SQL ERROR",
                     stringsAsFactors = FALSE)
  } else{
    myResult <- "INVALID"
    if (nrow(data.query)==1) myResult <- data.query[1,c("SEARCH")]
    
    xx <- data.frame(SearchAddress=SqlAddress,
                     RecordsMatched=nrow(data),
                     ReturnedAddress=myResult,
                     stringsAsFactors = FALSE)
  }

  # bind to dataframe  
  if (i==1) {
    data.Search <- xx
  } else {
    data.Search <- bind_rows(data.Search, xx)
  }
  
    
  #if (i > 30) break
}

close(dbhandle)
# ==============================================
# Close

exists("data.query")
