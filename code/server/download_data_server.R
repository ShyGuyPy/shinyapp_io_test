###-----------------------tab for downloading withdrawal and flows data from Sarah's Drupal site------------------------------------


#---------------------------------------download data from withdrawal_data----------------------------------------------------------

###download the data
observeEvent(input$download_data_w, {
  
  #import the withdrawal data from sarah's site
  withProgress(message = "downloading withdawals data", value = 0, {
    #increment progress bar
    incProgress(1/2)
  withdrawals.df <- data.table::fread("http://icprbcoop.org/drupal4/products/coop_pot_withdrawals.csv",
                                      header = TRUE,
                                      na.strings = c("eqp", "Ice", "Bkw", "", "#N/A", -999999),
                                      data.table = FALSE) #, colClasses = list_gage_locations)
  
  #holds the values in wide format and addes dummy rows for formatting purposes
  withdrawals_actual.df <-  withdrawals.df #%>%
  #   add_row(DateTime = rep("dummy-row", 10), .before=1)
  
  #writes wide/formatted data
  write.csv(withdrawals_actual.df, paste0(ts_path, "download_data_w_actual.csv"), row.names=FALSE)
  
  #clear unneeded duplicate columns
  # withdrawals.df <- withdrawals.df %>%
  #   select(-V1)
  
  #gather the data into long format for plotting
  withdrawals.df <- gather(withdrawals.df,site, flow, 2:6)

  #select only essential(prevents duplicate numbering v1 column)
  withdrawals.df <- withdrawals.df %>%
    select(c(DateTime, site, flow))
  
  # #turn dates to date_time type
  # withdrawals.df$DateTime <- as_datetime(as.character(withdrawals.df$DateTime))
  
  #write dataframe to file
  write.csv(withdrawals.df, paste0(ts_path, "download_data_w_temp.csv"), row.names=FALSE)
  
  #increment progress bar
  incProgress(1/2)
}) #end of withProgress
})
#----------------------------------------------------------------------------------------

###---------------------------------plot the withdrawals data------------------------------------------
observeEvent(input$view_data_w, {
  
  #read file
  withdrawals.df <- data.table::fread(paste0(ts_path, "download_data_w_temp.csv"),
                                      header = TRUE,
                                  data.table = FALSE)
  
  #select only essential(prevents duplicate numbering v1 column)
  withdrawals.df <- withdrawals.df %>%
    select(c(DateTime, site, flow))
  
  #if older data exist in directory
  if(file.exists(paste0(ts_path, "download_data_w_old.csv"))){
    #grab old withdrawal data from app
    withdrawals_old.df <- data.table::fread(paste0(ts_path, "download_data_w_old.csv"),
                                            header = TRUE,
                                        data.table = FALSE)
    
    # withdrawals_old.df <- withdrawals_old.df %>%
    #   select(-V1)
    
    #gather the old data into long format
    withdrawals_old.df <- gather(withdrawals_old.df,site, flow, 2:6)
    
    #select only essential(prevents duplicate numbering v1 column)
    withdrawals_old.df <- withdrawals_old.df %>%
      select(c(DateTime, site, flow))
    
    #change site names to be unique from new data (e.g 'lfalls' becomes 'lfalls_old')
    withdrawals_old.df <- withdrawals_old.df %>%
      mutate( site =  paste0(site, "_old"))
    
    #turn dates to date_time type
    withdrawals_old.df$DateTime <- as_datetime(as.character(withdrawals_old.df$DateTime))
  
  } 
  
  #change DateTime column format to as_datetime
  withdrawals.df$DateTime <- as_datetime(as.character(withdrawals.df$DateTime))
  
  if(file.exists(paste0(ts_path, "download_data_w_old.csv"))){
    
    withdrawals_new_and_old.df <- full_join(withdrawals.df, withdrawals_old.df)#, by = c(DateTime, site, flow))
    
    output$withdrawal_plot <- renderPlot({ggplot(withdrawals_new_and_old.df, aes(x = DateTime, y = flow)) + geom_line(aes(linetype = site, colour = site)) 
    })
  } else {
    output$withdrawal_plot <- renderPlot({ggplot(withdrawals.df, aes(x = DateTime, y = flow)) + geom_line(aes(linetype = site, colour = site))
    })
  }  
  
})
#------------------------------------------------------------------------------------------


###--------------------------------------------accept and save the withdrawals data---------------------------------
observeEvent(input$accept_data_w, {
  
  #read old data file
  withdrawals.df <- data.table::fread(paste0(ts_path, "coop_pot_withdrawals.csv"),
                                  data.table = FALSE)
  #write old dataframe to old dataframe location 
  write.csv(withdrawals.df, paste0(ts_path, "download_data_w_old.csv"), row.names=FALSE)
  
  #read temp file(grabbing the data that has added dummy rows and is still in wide format)
  withdrawals.df <- data.table::fread(paste0(ts_path, "download_data_w_actual.csv"),
                                  data.table = FALSE)
  #add dummyrows to match format
  withdrawals.df <- withdrawals.df %>%
  add_row(DateTime = rep("dummy-row", 10), .before=1)
  
  #overwrite dataframe to latest(active) data position
  write.csv(withdrawals.df, paste0(ts_path, "coop_pot_withdrawals_unformatted.csv"), row.names=FALSE)
  
  #reload import_data
  source("code/global/import_data.R", local = TRUE)#
})

#------------------------------------------------------------------------------------------------------------------------------------



















#----------------------------------------------download data from flows daily------------------------------------------------------

###download the data
observeEvent(input$download_data_fd, {
  #creates a progess bar for data download
  withProgress(message = "downloading flows daily data", value = 0, {
    #increment progress bar
    incProgress(1/2)
  
  #construct path for daily flows data
  first_of_year = as.Date("2019-1-1")
  
  daily_start = paste0(format(first_of_year,"%m"),"%2F",format(first_of_year,"%d"), "%2F",format(first_of_year,"20%y"))
  print(daily_start)
  
  daily_end = paste0(format(date_today0,"%m"),"%2F",format(date_today0,"%d"), "%2F",format(date_today0,"20%y"))
  
  full_daily_url = paste0("http://icprbcoop.org/drupal4/icprb/flow-data?","startdate=", daily_start,"&enddate=" ,daily_end, "&format=daily&submit=Submit")
  
  #import the data from sarah's site
  flows_daily.df <- data.table::fread(full_daily_url, header = TRUE,
                                      data.table = FALSE,   colClasses = c("character", rep("numeric", 31)), # force cols 2-32 numeric
                                      na.strings = c("eqp", "Ice", "Bkw", "", "#N/A", -999999),
                                      col.names = list_gage_locations)
  
  #holds the values in wide format and addes dummy rows for formatting purposes
  flows_daily_actual.df <-  flows_daily.df #%>%
  #   add_row(date = rep("dummy-row", 10), .before=1)
  
  #writes wide/formatted data
  write.csv(flows_daily_actual.df, paste0(ts_path, "download_data_fd_actual.csv"), row.names=FALSE)
  
  
  # flows_daily.df <- flows_daily.df %>%
  #   select(-V1)
  
  #gather the data into long format for plotting
  flows_daily.df <- gather(flows_daily.df,site, flow, 2:6)
  
  #select only essential(prevents duplicate numbering v1 column)
  flows_daily.df <- flows_daily.df %>%
    select(c(date, site, flow))
  
  # #turn dates to date_time type
  # flows_daily.df$date <- as_datetime(as.character(flows_daily.df$date))
  
  #write dataframe to file
  write.csv(flows_daily.df, paste0(ts_path, "download_data_fd_temp.csv"), row.names=FALSE)
  
  #increment progress bar
  incProgress(1/2)
  
  }) #end of withProgress
})
#-------------------------------------------------------------------------------------------

###---------------------------------------plot the daily flows data-------------------------------------
observeEvent(input$view_data_fd, {
  
  #read file
  flows_daily.df <- data.table::fread(paste0(ts_path, "download_data_fd_temp.csv"),
                                      header = TRUE,
                                  data.table = FALSE)
  
  # flows_daily.df <- flows_daily.df %>%
  #   select(-V1)
  
  #select only essential(prevents duplicate numbering v1 column)
  flows_daily.df <- flows_daily.df %>%
    select(c(date, site, flow))
  
  #if older data exist in directory
  if(file.exists(paste0(ts_path, "download_data_fd_old.csv"))){
    #grab old flows daily data from app
    flows_daily_old.df <- data.table::fread(paste0(ts_path, "download_data_fd_old.csv"),
                                            header = TRUE,
                                            data.table = FALSE)
    
    #gather the old data into long format
    flows_daily_old.df <- gather(flows_daily_old.df,site, flow, 2:32)
    
    #change site names to be unique from new data (e.g 'lfalls' becomes 'lfalls_old')
    flows_daily_old.df <- flows_daily_old.df %>%
      mutate( site =  paste0(site, "_old"))
    
    #select only essential(prevents duplicate numbering v1 column)
    flows_daily_old.df <- flows_daily_old.df %>%
      select(c(date, site, flow))
  
    #turn dates to date_time type
    flows_daily_old.df$date <- as_datetime(as.character(flows_daily_old.df$date))
    
    #filter down to only 2 sites
    flows_daily_old.df <-  flows_daily_old.df %>%
      filter(site == "lfalls" | site == "por")
    
  }
  
  # 
  #turn dates to date_time type
  flows_daily.df$date <- as_datetime(as.character(flows_daily.df$date))
  
  #filter down to only 2 sites
  flows_daily.df <-  flows_daily.df %>%
    filter(site == "lfalls" | site == "por")
  
  #plot the data
  # #button interaction needs to be conditional on data being readable in directory
  # output$flows_daily_plot <- renderPlot({ ggplot(flows_daily.df, aes(x = date, y = flow)) + geom_line(aes(linetype = site, colour = site))
    # })
  
  if(file.exists(paste0(ts_path, "download_data_fd_old.csv"))){
    
    flows_daily_new_and_old.df <- full_join(flows_daily.df, flows_daily_old.df)#, by = c(date, site, flow))
    
    output$flows_daily_plot <- renderPlot({ggplot(flows_daily_new_and_old.df, aes(x = date, y = flow)) + geom_line(aes(linetype = site, colour = site)) 
    })
  } else {
    output$flows_daily_plot <- renderPlot({ggplot(flows_daily.df, aes(x = date, y = flow)) + geom_line(aes(linetype = site, colour = site))
    })
  }
})
#--------------------------------------------------------------------------------------------

###-----------------------------------------accept and save the daily flows data------------------------------------
observeEvent(input$accept_data_fd, {
  
  #read old data file
  flows_daily.df <- data.table::fread(paste0(ts_path, "flows_daily_cfs.csv"),
                                      data.table = FALSE)
  #write old dataframe to old dataframe location 
  write.csv(flows_daily.df, paste0(ts_path, "download_data_fd_old.csv"), row.names=FALSE)
  
  #read temp file
  flows_daily.df <- data.table::fread(paste0(ts_path, "download_data_fd_actual.csv"),
                                  data.table = FALSE)
  #overwrite dataframe to latest(active) data position
  write.csv(flows_daily.df, paste0(ts_path, "flows_daily_cfs_unformatted.csv"), row.names=FALSE)
  
  #reload import_data
  source("code/global/import_data.R", local = TRUE)#
})

#---------------------------------------------------------------------------------------------------------------------------

















#---------------------------------------------------download data flows hourly---------------------------------------------
###download the data
observeEvent(input$download_data_fh, {
  #creates a progess bar for data download
  withProgress(message = "downloading flows hourly data", value = 0, {
    #increment progress bar
    incProgress(1/2)
  
  #construct file path
  date_minus_five = date_today0 - 5
  hourly_start = paste0(format(date_minus_five,"%m"),"%2F",format(date_minus_five,"%d"), "%2F",format(date_minus_five,"20%y"))
  
  hourly_end = paste0(format(date_today0,"%m"),"%2F",format(date_today0,"%d"), "%2F",format(date_today0,"20%y"))
  
  full_hourly_url = paste0("http://icprbcoop.org/drupal4/icprb/flow-data?","startdate=", hourly_start,"&enddate=" ,hourly_end, "&format=hourly&submit=Submit")
  
  #import the hourly flows data from sarah's site
  flows_hourly.df <- data.table::fread(full_hourly_url, header = TRUE,
                                      data.table = FALSE, colClasses = c("character", rep("numeric", 31)), # force cols 2-32 numeric
                                      na.strings = c("eqp", "Ice", "Bkw", "", "#N/A", -999999),
                                      col.names = list_gage_locations)
  
  #holds the values in wide format and addes dummy rows for formatting purposes
  flows_hourly_actual.df <-  flows_hourly.df #%>%
  #   add_row(date = rep("dummy-row", 10), .before=1)
  
  #writes wide/formatted data
  write.csv(flows_hourly_actual.df, paste0(ts_path, "download_data_fh_actual.csv"), row.names=FALSE)
  
  # flows_hourly.df <- flows_hourly.df %>%
  #   select(-V1)
  
  #gather the data into long format for plotting
  flows_hourly.df <- gather(flows_hourly.df,site, flow, 2:6)
  
  #select only essential(prevents duplicate numbering v1 column)
  flows_hourly.df <- flows_hourly.df %>%
    select(c(date, site, flow))
  
  # #turn dates to date_time type
  # flows_hourly.df$date <- as_datetime(as.character(flows_hourly.df$date))
  
  #write dataframe to file
  write.csv(flows_hourly.df, paste0(ts_path, "download_data_fh_temp.csv"), row.names=FALSE)
  

  
  #increment progress bar
  incProgress(1/2)
  }) #end of withProgress
})
#------------------------------------------------------------------------------------------

###---------------------------------plot the flows hourly data-------------------------------------------
observeEvent(input$view_data_fh, {
  
  #read file
  flows_hourly.df <- data.table::fread(paste0(ts_path, "download_data_fh_temp.csv"),
                                       header = TRUE,
                                  data.table = FALSE)
  
  #select only essential(prevents duplicate numbering v1 column)
  flows_hourly.df <- flows_hourly.df %>%
    select(c(date, site, flow))
  
  #if older data exist in directory
  if(file.exists(paste0(ts_path, "download_data_fh_old.csv"))){
    #grab old flows hourly data from app
    flows_hourly_old.df <- data.table::fread(paste0(ts_path, "download_data_fh_old.csv"),
                                             header = TRUE,
                                            data.table = FALSE)
    
    #gather the data into long format
    flows_hourly_old.df <- gather(flows_hourly_old.df,site, flow, 2:32)
    
    #select only essential(prevents duplicate numbering v1 column)
    flows_hourly_old.df <- flows_hourly_old.df %>%
      select(c(date, site, flow))
    
    #change site names to be unique from new data (e.g 'lfalls' becomes 'lfalls_old')
    flows_hourly_old.df <- flows_hourly_old.df %>%
      mutate( site =  paste0(site, "_old"))
    
    #turn dates to date_time type
    flows_hourly_old.df$date <- as_datetime(as.character(flows_hourly_old.df$date))
    
    #filter down to only 2 sites
    flows_hourly_old.df <-  flows_hourly_old.df %>%
      filter(site  == "lfalls" | site == "por")
    
  }
  
  #turn dates to date_time type
  flows_hourly.df$date <- as_datetime(as.character(flows_hourly.df$date))
  
  #filter down to only 2 sites
  flows_hourly.df <-  flows_hourly.df %>%
    filter(site  == "lfalls" | site == "por")
  
  #plot the data
  #button interaction needs to be conditional on data being readable in directory
  # output$flows_hourly_plot <- renderPlot({ ggplot(flows_hourly.df, aes(x = date, y = flow)) + geom_line(aes(linetype = site, colour = site))
  #})
  
  if(file.exists(paste0(ts_path, "download_data_fh_old.csv"))){
    
    flows_hourly_new_and_old.df <- full_join(flows_hourly.df, flows_hourly_old.df)#, by = c(date, site, flow))
    
    output$flows_hourly_plot <- renderPlot({ggplot(flows_hourly_new_and_old.df, aes(x = date, y = flow)) + geom_line(aes(linetype = site, colour = site)) 
    })
  } else {
    output$flows_hourly_plot <- renderPlot({ggplot(flows_hourly.df, aes(x = date, y = flow)) + geom_line(aes(linetype = site, colour = site))
    })
  }
})
#------------------------------------------------------------------------------------------

###--------------------------------------save and accept the flows hourly data-------------------------------------
observeEvent(input$accept_data_fh, {
  
  #read old data file
  flows_hourly.df <- data.table::fread(paste0(ts_path, "flows_hourly_cfs.csv"),
                                      data.table = FALSE)
  #write old dataframe to old dataframe location 
  write.csv(flows_hourly.df, paste0(ts_path, "download_data_fh_old.csv"), row.names=FALSE)
  
  #read temp file(grabbing the data that has added dummy rows and is still in wide format)
  flows_hourly.df <- data.table::fread(paste0(ts_path, "download_data_fh_actual.csv"),
                                      data.table = FALSE)
  
  ################# need code to append new data to old data
  ######requires a join to existing data
  
  #write dataframe to file
  write.csv(flows_hourly.df, paste0(ts_path, "flows_hourly_cfs_unformatted.csv"), row.names=FALSE)
  
  #reload import_data
  source("code/global/import_data.R", local = TRUE)#
})

#--------------------------------------------------------------------------------------------------------------------------------










