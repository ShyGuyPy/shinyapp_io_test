#--------------------------------------------------------------------------------
dashboardPage(skin = "blue",
              dashboardHeader(title = "CO-OP Operations",
                              .list = NULL, 
                              #this space is for outputting the date to the login bar
                              #it needs to be an html list item(li) with class dropdown
                              #to output properly
                              tags$li(textOutput("date_text"),
                                      class = "dropdown")
              ),
#--------------------------------------------------------------------------------
#--------------------------------------------------------------------------------
# The sidebar - has the user inputs and controls
#--------------------------------------------------------------------------------
#--------------------------------------------------------------------------------
dashboardSidebar(
  width = 250,
  dateRangeInput("plot_range",
                 "Specify plot range",
                 start = date_start,
                 #               start = "2019-05-01",
                 #               end = "1930-12-31",
                 # start = date_start,
                 end = date_end,
                 format = "yyyy-mm-dd",
                 width = NULL),
  dateInput("DREXtoday",
            "Select end date of simulation (> yesterday)",
            width = "200px",
            value = date_today0, # date_today0 = today() - set in parameters.R
            #          value = "1930-02-15",
            #          min = "1929-10-02",
            #          max = "1931-12-31",
            min = date_start,
            max = date_end,
            format = "yyyy-mm-dd"),
  
  actionButton("run_main",
               "Run simulation",
               icon = NULL,
               width = "220px"),
  br(),
  numericInput("chunkofdays",
               "Chunk of days",
               value = 7,
               min = 1,
               max = 30,
               width = "220px"),
  actionButton("run_add",
               "Add chunk of days to simulation",
               icon = NULL,
               width = "220px"),
  br(),
  numericInput("dr_va",
               "Demand reduction, VA-Shenandoah (%)",
               value = dr_va0,
               min = 0,
               max = 20,
               width = "220px"),
  numericInput("dr_md_cent",
               "Demand reduction, MD-Central (%)",
               value = dr_md_cent0,
               min = 0,
               max = 20,
               width = "220px"),
  numericInput("dr_md_west",
               "Demand reduction, MD-Western (%)",
               value = dr_md_west0,
               min = 0,
               max = 20,
               width = "220px"),
  br(), 
  numericInput("mos_1day",
               "1 day margin of safety (MGD)",
               value = mos_1day0,
               min = 0,
               max = 140,
               width = "220px"),
  numericInput("dr_wma_override",
               "Demand reduction override, WMA (%)",
               value = dr_wma_override0,
               min = 0,
               max = 20,
               width = "220px"),
  br(), br(),
  br(), br(),
  actionButton("write_ts",
               "Write output time series",
               icon = NULL,
               width = "220px")
),

#--------------------------------------------------------------------------------
#--------------------------------------------------------------------------------
# The body - has the graphs and other output info
#--------------------------------------------------------------------------------
#--------------------------------------------------------------------------------
dashboardBody(
  tags$head(
    #this links the shiny app to main.css which can be used to easily define and 
    #alter styles(color,font size, alignments) across allui/server elements
    tags$link(rel = "stylesheet", type = "text/css", href = "CSS/main.css")),
  
    navbarPage(title=NULL,
             
             source("code/ui/situational_awareness_ui.R", local = TRUE)$value,
             source("code/ui/one_day_operations.R", local = TRUE)$value,
             source("code/ui/ten_day_ops_ui.R", local = TRUE)$value,
             source("code/ui/long_term_operations.R", local = TRUE)$value,
             source("code/ui/demands.R", local = TRUE)$value,
             source("code/ui/download_data_ui.R", local = TRUE)$value
             
  )
  
  
) # end dashboardBody
) # end dashboardPage