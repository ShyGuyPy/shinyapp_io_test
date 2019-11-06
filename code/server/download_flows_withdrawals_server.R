# download data from withdrawal_data
# 

observeEvent(input$download_data, {
  #import the data from sarah's site
  demands_raw.df <- data.table::fread("http://icprbcoop.org/drupal4/products/coop_pot_withdrawals.csv",
                                      data.table = FALSE)
  
  #gather the data into long format
  demands.df <- gather(demands_raw.df,site, flow, 2:6)

  # #turn dates to date_time type
  # demands.df$DateTime <- as_datetime(as.character(demands.df$DateTime))
  
  #write dataframe to file
  write.csv(demands.df, paste(ts_output, "download_data_temp.csv"))
})

observeEvent(input$view_data, {
  
  #read file
  demands.df <- data.table::fread(paste(ts_output, "download_data_temp.csv"),
                                  data.table = FALSE)
  
  #turn dates to date_time type
  demands.df$DateTime <- as_datetime(as.character(demands.df$DateTime))
  
  #plot the data
  #button interaction needs to be conditional on data being readable in directory
  output$withdrawal_plot <- renderPlot({ ggplot(demands.df, aes(x = DateTime, y = flow)) + geom_line(aes(linetype = site, colour = site))
    
  })
})

observeEvent(input$accept_data, {
})
#read file
demands.df <- data.table::fread(paste(ts_output, "download_data_temp.csv"),
                                data.table = FALSE)
#write dataframe to file
write.csv(demands.df, paste(ts_output, "download_data.csv"))

# save to ts_path