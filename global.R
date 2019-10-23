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

# deploy_test <- curl('https://deq1.bse.vt.edu/drought/state/images/maps/')
# 
# #open(deploy_test)
# 
# out <- readLines(deploy_test)

deploy_test <- curl_fetch_memory('https://deq1.bse.vt.edu/')
  #'https://deq1.bse.vt.edu/drought/state/images/maps/')

#parse_headers(out_mem$headers)#[15:30])

#rawToChar(deploy_test$content)