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
dashboardSidebar(),

#--------------------------------------------------------------------------------
#--------------------------------------------------------------------------------
# The body - has the graphs and other output info
#--------------------------------------------------------------------------------
#--------------------------------------------------------------------------------
dashboardBody(
) # end dashboardBody
) # end dashboardPage