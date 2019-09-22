library(shiny)
library(shinythemes)

ui <- navbarPage(theme = shinytheme("slate"),
                 selected = "Main",
                 "Text Prediction Model",
                 footer = p(style = "position: fixed; bottom: 0; width:100%; text-align: center",
                            "JHU Data Science Specialisation Capstone Project,", 
                            em("Kyle Kaicheng Bao,"), "22 September 2019"),

                 tabPanel("Main",
                          verticalLayout(
                            
                            wellPanel(
                              textInput("text",
                                        label = h3("Input text: ")),
                              p(strong(em("Note: ")), "Please add a ", strong("<space>"), "after the last word to predict the next word. If no space is entered, the model will predict the last word currently being typed.")
                              ),
                            
                            tabsetPanel(type = "pills",
                                        tabPanel("Predicted Words",
                                                 conditionalPanel("input.text != ''",
                                                                  wellPanel(
                                                                    fluidRow(column(width = 3, strong("Next word: ")),
                                                                             column(width = 2, tableOutput("result.text1"))),
                                                                    hr(),
                                                                    fluidRow(column(width = 3, strong("Other likely words: ")),
                                                                             column(width = 2, tableOutput("result.table")))
                                                                    )
                                                                  )
                                                 ),
                                        tabPanel("Debug",
                                                 conditionalPanel("input.text != ''",
                                                                  wellPanel(
                                                                    tableOutput("result.table2")
                                                                    )
                                                                  )
                                                 )
                                        )
                            )
                          ),
                 
                 tabPanel("About",
                          p("This application was created for the Johns Hopkins University Data Science Specialisation Capstone Project."),
                          p("The application allows the user to input text and receive near-real-time predictions of the next word, or word currently being typed. 
                            This application aims to replicate the typing suggestions feature found in smartphones."),
                          p("To view the companion slide decks, please visit: ", a(href="https://8kyle8.github.io/10TextPredictionApp/slideDeck/slideDeck.html", "https://8kyle8.github.io/10TextPredictionApp/slideDeck/slideDeck.html"))
                          )
)