#Load Packages
library(shiny)
library(shinythemes)
library(tidyverse)
library(jsonlite)
library(DT)

#NYT KEY
KEY <- "oZ6c0FgayC1zkrhn3lGBM0s07BXlL9e4"

#Creates a dataframe when keyword is given
keywordDF <- function(keyword){
  #paste together url
  url <- paste0("https://api.nytimes.com/svc/search/v2/articlesearch.json?q=", keyword,"&api-key=",KEY, sep="")
  
  fromJSON(url, flatten = T) %>% 
    data.frame() %>% 
    select(response.docs.abstract, response.docs.web_url)%>%
    rename("Abstract" = response.docs.abstract, "Link"= response.docs.web_url)
  }
  


# User Interface
ui <- fluidPage(
  titlePanel("New York Times Articles"),
  sidebarLayout(
        sidebarPanel(("Enter a keyword to access articles"),
                     textInput("keyword", "Enter one keyword:", ""),
                     actionButton("search", "Lets GO!")),
        mainPanel(
          h1("NYT Article Abstracts and Links"),
          DT::dataTableOutput("dataframe")
        )
    )
)

# Define server
server <- function(input, output) {
  articles <- reactive({
    input$search
    
    keyword <- isolate(input$keyword)
    
    keywordDF(keyword)
    })
    
    output$dataframe <- renderDT(articles())

}

# Run the application 
shinyApp(ui = ui, server = server)
