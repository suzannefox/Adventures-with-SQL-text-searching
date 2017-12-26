
# ====================================================================
# libraries
# ====================================================================

library(RODBC)
library(tidyverse)
library(data.table)

# ==============================================
# Load  into SQL
# ==============================================

SqlServer <- ".\\SQLEXPRESS"
SqlDatabase <- 'abp'

SqlConnection <- paste0('driver={SQL Server};server=',
                       SqlServer,
                       ';database=',
                       SqlDatabase,
                       ';trusted_connection=true;rows_at_time=1')

# ==============================================
# Load blpu
# ==============================================
path.file <- "ID21_BLPU_Records.csv"
blpu <-  fread(path.file, 
               colClasses=c(UPRN="character",
                            PARENT_UPRN="character"))

blpu <- tibble::rowid_to_column(blpu, "Id_Identity")

dbhandle <- odbcDriverConnect(SqlConnection)
print(paste("START",Sys.time()))
sqlSave(dbhandle, 
        blpu, 
        rownames = FALSE, 
        verbose = FALSE, 
        append =  TRUE)
close(dbhandle)
print(paste("FINISH",Sys.time()))

# ==============================================
# Load delivery_point
# ==============================================
path.file <- "ID28_DPA_Records.csv"
delivery_point <-  fread(path.file,
                         colClasses=c(UPRN="character"))

delivery_point <- tibble::rowid_to_column(delivery_point, "Id_Identity")

print(paste("START",Sys.time()))
dbhandle <- odbcDriverConnect(SqlConnection)
sqlSave(dbhandle, 
        delivery_point, 
        rownames = FALSE, 
        verbose = FALSE, 
        append = TRUE)
close(dbhandle)
print(paste("FINISH",Sys.time()))
# ==============================================
