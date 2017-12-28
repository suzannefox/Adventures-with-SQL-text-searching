
# ====================================================================
# libraries
# ====================================================================

library(RODBC)
library(tidyverse)
library(data.table)

# ====================================================================
# data sub samples
# ====================================================================

lines.max <- 1000000

bool_Loadblpu <- FALSE
bool_LoadSample <- FALSE
if (bool_LoadSample==FALSE) lines.max <- -1

# ==============================================
# Load CSV files
# ==============================================

# ===============================
# blpu
if (bool_Loadblpu==TRUE) {
  path.dir <- "D:\\Suzanne\\AddressSearching\\AddressBase\\"
  path.file <- "ID21_BLPU_Records.csv"
  blpu <-  fread(paste0(path.dir,path.file), 
                 colClasses=c(UPRN="character",
                              PARENT_UPRN="character"),
                 nrows=lines.max)
}

# ===============================
# delivery_point
# reads 1,000,000 records in 4 seconds
# reads 28,739,141 records in 3:18 minutes (3.724 GB)

path.dir <- "D:\\Suzanne\\AddressSearching\\AddressBase\\"
path.file <- "ID28_DPA_Records.csv"

print("")
print(paste0("Reading ",lines.max," records from ",path.dir,path.file))
print("")
delivery_point <-  fread(paste0(path.dir,path.file),
                         colClasses=c(UPRN="character"),
                         nrows=lines.max)

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

# ===============================
# blpu

if (bool_Loadblpu==TRUE) {

  dbhandle <- odbcDriverConnect(SqlConnection)
  print(paste("START",Sys.time()))
  sqlSave(dbhandle, 
          blpu, 
          rownames = FALSE, 
          verbose = FALSE, 
          append =  TRUE)
  close(dbhandle)
  print(paste("FINISH",Sys.time()))
}

# ===============================
# delivery_point
# loads 1,000,000 records into SQL in 4 minutes with Id_Identity

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
