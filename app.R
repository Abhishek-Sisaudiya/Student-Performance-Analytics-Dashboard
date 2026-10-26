# Interactive R Shiny Dashboard Application
library(shiny)

ui <- fluidPage(
  titlePanel("Student Performance Analytics Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("subject", "Select Subject for Analysis:", 
                  choices = c("Maths", "Science", "English", "Percentage")),
      sliderInput("min_score", "Filter Minimum Score/Percentage:",
                  min = 0, max = 100, value = 50)
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Data Table", tableOutput("studentTable")),
        tabPanel("Grade Chart", plotOutput("gradePlot")),
        tabPanel("Score Distribution", plotOutput("scorePlot"))
      )
    )
  )
)

server <- function(input, output) {
  
  # Load & Process Data
  studentData <- reactive({
    df <- read.csv("data/students.csv")
    df$Total <- df$Maths + df$Science + df$English
    df$Percentage <- round(df$Total / 3, 2)
    df$Grade <- ifelse(df$Percentage >= 85, "A+",
                ifelse(df$Percentage >= 70, "A",
                ifelse(df$Percentage >= 50, "B", "C")))
    
    # Filter by selected threshold
    df[df[[input$subject]] >= input$min_score, ]
  })
  
  output$studentTable <- renderTable({
    studentData()
  })
  
  output$gradePlot <- renderPlot({
    df <- studentData()
    grade_counts <- table(df$Grade)
    barplot(grade_counts, 
            main = "Grade Distribution", 
            xlab = "Grade", 
            ylab = "Student Count", 
            col = "steelblue", 
            border = "white")
  })
  
  output$scorePlot <- renderPlot({
    df <- studentData()
    hist(df[[input$subject]], 
         main = paste("Histogram of", input$subject), 
         xlab = input$subject, 
         col = "lightgreen", 
         border = "white")
  })
}

shinyApp(ui = ui, server = server)
