#----Load packages  
source("code/global/import_packages.R", local = TRUE)
#----------------------------------------------------------------------

#this is the date today.  it is the one and only.  use this
date_today0 <- as.Date(today())

#-------------
source("code/functions/display/md_drought_map_func.R", local = TRUE)
source("code/functions/display/va_drought_map_func.R", local = TRUE)
#----------------------------------------------------------------------------

#-----define paths, define parameters, and import data ----------------------
source("config/paths.R", local = TRUE)
source("input/parameters/parameters.R", local = TRUE)
source("code/global/import_data.R", local = TRUE)#
source("input/parameters/css_ui_values.R", local = TRUE)
#----------------------------------------------------------------------------


# Read classes and functions --------------------------------------------------
source("code/classes/reservoir_class.R", local = TRUE)
source("code/functions/reservoir_ops/reservoir_ops_init_func.R", local = TRUE)
source("code/functions/reservoir_ops/reservoir_ops_today_func.R", local = TRUE)
source("code/functions/reservoir_ops/jrr_reservoir_ops_today_func.R", local = TRUE)
source("code/functions/reservoir_ops/jrr_reservoir_ops_today_func2.R", local = TRUE)
source("code/functions/forecast/forecasts_demands_func.R", local = TRUE)
source("code/functions/forecast/forecasts_flows_func.R", local = TRUE)
source("code/functions/state/state_indices_update_func.R", local = TRUE)
source("code/functions/simulation/estimate_need_func.R", local = TRUE)
source("code/functions/simulation/restriction_flow_benefits_func.R", local = TRUE)
source("code/functions/simulation/sim_main_func.R", local = TRUE)
source("code/functions/simulation/simulation_func.R", local = TRUE)
source("code/functions/simulation/sim_add_days_func.R", local = TRUE)
source("code/functions/simulation/rule_curve_func.R", local = TRUE)
source("code/functions/simulation/nbr_rule_curve_func.R", local = TRUE)
source("code/functions/display/display_graph_res_func.R", local = TRUE)

# Functions added by Luke -----------------------------------------------------
source("code/functions/display/date_func.R", local = TRUE)
source("code/functions/display/warning_color_func.R", local = TRUE)
# this is a lazy Friday fix that should be changed later:
source("code/functions/display/warning_color_map_func.R", local = TRUE)


#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
# Create things that need to be accessed by everything
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------

# # Define today's date ---------------------------------------------------------
# #   - will usually be today
# #   - but want option to change to fake date for exercises
# 
# #---toggle
# date_today <- today()
# # date_today <- as.date("1999-07-01")
# #----

# Make reservoir objects and time series df's ---------------------------------
#   - the reservoir objects are jrr, sen, occ, pat
#   - the ts dfs are 
source("code/server/reservoirs_make.R", local = TRUE) 
# What this does is create the reservoir "objects", jrr, sen, occ, pat
#    and the reservor time series, res.ts.df
#    e.g., sen.ts.df - initialized with first day of ops time series

# Make the Potomac input data and flow time series dataframes -----------------
source("code/server/potomac_flows_init.R", local = TRUE)
# What this does is create:
# potomac.data.df - filled with all nat flow, trib flow data
# potomac.ts.df - initialized with first day of flows
#    - contains lfalls_obs, sen_outflow, jrr_outflow

# Make and initialize state drought status time series dataframes -------------
source("code/server/state_status_ts_init.R", local = TRUE)
# What this does is create:
# state.ts.df - filled with status indices:
#    - 0 = Normal
#    - 1 = Watch
#    - 0 = Warning
#    - 0 = Emergency

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
# A few needed inputs which will probably be moved at some point
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------













# deploy_test <- curl('https://deq1.bse.vt.edu/drought/state/images/maps/')
# 
# #open(deploy_test)
# 
# out <- readLines(deploy_test)

# deploy_test <- curl_fetch_memory('https://deq1.bse.vt.edu/')
  #'https://deq1.bse.vt.edu/drought/state/images/maps/')

#parse_headers(out_mem$headers)#[15:30])

#rawToChar(deploy_test$content)