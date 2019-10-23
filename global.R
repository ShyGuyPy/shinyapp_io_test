#----Load packages  
source("code/global/import_packages.R", local = TRUE)
#----------------------------------------------------------------------

#-----define paths, define parameters, and import data ----------------------
source("config/paths.R", local = TRUE)
source("input/parameters/parameters.R", local = TRUE)
source("code/global/import_data.R", local = TRUE)#
#----------------------------------------------------------------------------


source("code/functions/display/md_drought_map_func.R", local = TRUE)
source("code/functions/display/va_drought_map_func.R", local = TRUE)

deploy_test <- curl::curl_download('https://deq1.bse.vt.edu/drought/state/images/maps/')

open(deploy_test)