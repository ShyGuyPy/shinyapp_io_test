# *****************************************************************************
# DESCRIPTION
# *****************************************************************************
# Create two dataframes: Potomac River flows inflow & outflow data
#    and Potomac River simulated flow time series
# *****************************************************************************
# INPUTS
# *****************************************************************************
# flows.daily.mgd.df - has the USGS flow data
# demands.daily.df - has recent daily average demands
#    - TEMPORARY: both of these dfs have values for all 365 days of
#      current year to keep app from breaking;
#      real values are from Drupal and rest are dummy values
#******************************************************************************
# OUTPUTS
#******************************************************************************
# potomac.data.df - just the flow data we need, plus total WMA demand
# potomac.ts.df0
# potomac.ts.df
#******************************************************************************

#------------------------------------------------------------------------------
# Create df of key Potomac River flows and demands
#------------------------------------------------------------------------------

# Add flows to the df ---------------------------------------------------------
potomac.data.df <- flows.daily.mgd.df %>%
  dplyr::mutate(por_nat = por, below_por = mon_jug + goose) %>%  
  dplyr:: select(date_time, por_nat, below_por, lfalls)

# Add the total daily WMA demand ----------------------------------------------
potomac.data.df <- left_join(potomac.data.df, 
                             demands.daily.df,
                             by = "date_time") %>%
  mutate(lfalls_nat = lfalls + d_total) %>%
  select(date_time, por_nat, below_por, 
         lfalls_nat, d_total)
#
# Want to change initialization of this key df to just passively graph up to yesterday
#   - in 2018drex was initialized with just 1 row of values (for date_start)
#   - now want it initialized with rows from date_start to 
#     "yesterday" = (date_today0 - 1)
#     in order to have time series for graphing purposes
#     (for the time being there will be some dummy values - see code below,
#     but ok since they won't be used)
potomac.data.df00 <- potomac.data.df %>%
  filter(date_time < date_today0)

n_today <- length(potomac.data.df00$date_time)

#--------------------------------------------------------------------------------
# Create and initialize dataframe of Potomac simulated flow time series
#--------------------------------------------------------------------------------
#   - date_time - initialized as date_start
#   - lfalls_nat - for QAing
#   - demand - actual & maybe fc'd demands, incl. restrictions
#   - lfalls_adj - lfalls "adjusted" - without effect of COOP withdrawals
#   - lfalls_obs
#   - lfalls_obs_fc9 - our 9-day fc for lfalls
#   - sen_outflow
#   - jrr_outflow
#   - jrr_outflow_lagged
#--------------------------------------------------------------------------------
jrr_outflow_lagged_default <- 129
sen_outflow_lagged_default <- 9
sen_other <- sen_other_watershed_flows # from parameters.R
#
# potomac.ts.df0 <- potomac.data.df0[1,] %>%
potomac.ts.df0 <- potomac.data.df00 %>%
  mutate(lfalls_adj = lfalls_nat,
         qad = date_start,  # a slot for debugging dates
         qav = 9999.9,  # a slot for debugging values
         dQ_va = 0.0, # water use restriction benefits, mgd
         dQ_md = 0.0, # ''
         lfalls_obs_fc9 = 1000,
         lfalls_obs_fc1 = 1000,
         demand = d_total, # 
         sen_outflow = 0.0, # represents reservoir outflow
         sen_outflow_lagged = sen_outflow_lagged_default, # one-day lag
         sen_watershed = sen_other, # represents other seneca cr watershed flows
         jrr_outflow = 120,
         savage_outflow = 50,
         jrr_outflow_lagged = jrr_outflow_lagged_default,
         savage_outflow_lagged = 50,
         # creating Potomac withdrawals with reasonable start day values:
         withdr_pot_fw = 100,
         withdr_pot_fw_lagged = 100,
         withdr_pot_wssc = 100,
         need_0day = 0.0,
         need_1day = 0.0,
         withdr_pot_wa = 100,
         lfalls_obs = lfalls_nat - 300) %>%
  select(date_time, qad, qav, dQ_va, dQ_md,
         lfalls_nat, por_nat, below_por, demand, 
         lfalls_adj, lfalls_obs, 
         lfalls_obs_fc9, lfalls_obs_fc1,
         sen_outflow, sen_outflow_lagged, sen_watershed, 
         jrr_outflow, jrr_outflow_lagged,
         savage_outflow, savage_outflow_lagged,
         withdr_pot_fw, withdr_pot_fw_lagged,
         withdr_pot_wssc, need_0day, need_1day, withdr_pot_wa)
potomac.ts.df <- potomac.ts.df0

