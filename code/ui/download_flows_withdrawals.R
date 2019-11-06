tabPanel("Download Data",
         fluidRow( # major row that contains whole body
           column( # major column that contains whole body
             width = 12,
             
             column(  # this is the 1st main column - with the buttons
               width = 6,
               
               actionButton("download_data",
                            "Download data",
                            icon = NULL,
                            width = "220px"),
               actionButton("view_data",
                            "Observe the data",
                            icon = NULL,
                            width = "220px"),
               actionButton("accept_data",
                            "Accept and save the data",
                            icon = NULL,
                            width = "220px"),
               ),
             
             column( # this is the 2nd main column - with the plotted data
               width = 6,
               fluidRow( # row with withdrawal data
                 box(
                   title = "Withdrawal data",
                   width = NULL,
                   plotOutput("withdrawal_plot", height = plot.height, width = plot.width)
                  
                 ) #box end
               ) #this is the end of row with withdrawal data
               ) # this is the end of 2nd main column
             
             
           ) # end of major column that contains whole body
           ) # end of major row that contains whole body
         )# end of tab panel