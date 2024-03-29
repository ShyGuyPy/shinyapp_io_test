#******************************************************************
# server.R defines reactive values & uses observeEvent to do simulation,
# then produces output
#******************************************************************
shinyServer(function(input, output, session) {
  # multi-use
  source("code/server/dates_server.R", local = TRUE)
  source("code/server/flow_recessions.R")
  
  #situational awareness tab
  source("code/server/situational_awareness/1st_sim.R", local=TRUE)
  source("code/server/situational_awareness/2nd_plot.R", local=TRUE)
  source("code/server/situational_awareness/3rd_output1.R", local=TRUE)
  source("code/server/situational_awareness/4th_output2.R", local=TRUE)
  source("code/server/situational_awareness/5th_output3.R", local=TRUE)
  
  #one day tab
  
  #ten day tab
  
  source("code/server/ten_day_ops_server.R", local=TRUE)
  
  #long term tab
  
  source("code/server/demands/demands_server.R", local=TRUE)
  
  #download flows/withdrawals tab
  
  source("code/server/download_data_server.R", local=TRUE)
  
  }) # end shinyServer

