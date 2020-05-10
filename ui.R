library("shinyWidgets")
library("shiny")
library("shinydashboard")
library("pdftools")


shinyUI(
  dashboardPage(
    dashboardHeader(title = "IIIT Bhubaneswar Exam Archive", titleWidth = "98%"),
    dashboardSidebar(
      width = 300,
      tags$img(src = "logo.jpg", height = 200, width = 300, align = "bottom"),
      sidebarMenu(
        menuItem(h4("Upload Question Papers"),
                 icon = icon("file"),
                 menuSubItem(h4("Upload Single Question Paper"),
                             tabName = "up_qp_sin",
                             icon = icon("upload")),
                 menuSubItem(h4("Upload Multiple Question Papers"),
                             tabName = "up_qp_mul",
                             icon = icon("cloud-upload"))
                 ),
        menuItem(h4("Download Question Papers"),
                 icon = icon("box"),
                 menuSubItem(h4("Download Subject Wise"),
                             tabName = "down_qp_sin",
                             icon = icon("box-open")),
                 menuSubItem(h4("Download Semester Wise"),
                             tabName = "down_qp_mul",
                             icon = icon("boxes"))
        ),
        menuItem(h4("Solutions"),
                 icon = icon("brain"),
                 menuSubItem(h4("Upload Solutions"),
                             tabName = "up_s",
                             icon = icon("pen")),
                 menuSubItem(h4("Download Solutions"),
                             tabName = "down_s",
                             icon = icon("dolly"))
        ),
        menuItem(h4("Class Notes"),
                 icon = icon("book"),
                 menuSubItem(h4("Upload Class Notes"),
                             tabName = "up_notes",
                             icon = icon("book-reader")),
                 menuSubItem(h4("Download Class Notes"),
                             tabName = "down_notes",
                             icon = icon("dolly"))
        ),
        menuItem(h4("About"), tabName = "about", icon = icon("clipboard", class = "fa-spin"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          tabName = "up_qp_sin",
          fluidRow(box(br(),h4(tags$b("Select the semester of your question paper")),br(),br(),br(),  uiOutput("semester_select"), width = 4, height = 250, background = "blue"), 
                   box(br(),h4(tags$b("Select the branch of your question paper")),br(),br(),br(),  uiOutput("branch_select"), width = 4, height = 250, background = "blue"),
                   box(br(),h4(tags$b("Select the year of your question paper")),br(),br(),br(),  uiOutput("year_select"), width = 4, height = 250, background = "blue")),
          
          fluidRow(box(br(),h4(tags$b("Select the examination type")), br(),br(),br(), uiOutput("exam_select"), width = 6, height = 250, background = "light-blue"),
                   box(br(),h4(tags$b("Select the subject")), br(),br(),br(), uiOutput("subject_select"), width = 6, height = 250, background = "light-blue")),
          
          fluidRow(column(width = 6,
                      box(
                        width = NULL,
                        title = h4(tags$b("Upload your paper here")),
                        fileInput(
                          inputId = "sin_sol_id",
                          label = "Please upload question papers available with you :)",
                          accept = c('application/pdf'),
                          buttonLabel = "Upload Paper")
                      ))
          )),
        tabItem(
          tabName = "up_qp_mul",
                fluidRow(box(br(),h4(tags$b("Select the semester for your question papers")), br(),br(),br(), uiOutput("semester_select_mul"), width = 6, height = 250, background = "blue"),
                         box(br(),h4(tags$b("Select the type of Examination")), br(),br(),br(), uiOutput("exam_select_mul"), width = 6, height = 250, background = "blue")),
                fluidRow(box(br(),h4(tags$b("Please provide your display name")), br(),br(),br(), uiOutput("name_select_ques"), width = 6, height = 250, background = "light-blue"),
                  box(br(),h4(tags$b("Upload your paper set here")), br(),br(),br(), uiOutput("upload_questionSet_button"), height = 250))),
        tabItem(
          tabName = "up_s",
          fluidRow(box(br(),h4(tags$b("Select semester of your solution")),br(),br(),br(),  uiOutput("semester_select_sol_sin"), width = 4, height = 250, background = "blue"), 
                   box(br(),h4(tags$b("Select branch of your paper")),br(),br(),br(),  uiOutput("branch_select_sol_sin"), width = 4, height = 250, background = "blue"),
                   box(br(),h4(tags$b("Select year of your solution")),br(),br(),br(),  uiOutput("year_select_sol_sin"), width = 4, height = 250, background = "blue")),
          
          fluidRow(box(br(),h4(tags$b("Select examination type")), br(),br(),br(), uiOutput("exam_select_sol_sin"), width = 4, height = 250, background = "light-blue"),
                   box(br(),h4(tags$b("Select subject")), br(),br(),br(), uiOutput("subject_select_sol_sin"), width = 4, height = 250, background = "light-blue"),
                   box(br(),h4(tags$b("Enter your Display Name")), br(), br(), br(), uiOutput("name_select_sol_sin"), width = 4, height = 250, background = "light-blue")),
          
          fluidRow(box(br(),h4(tags$b("Upload your solution here")), br(),br(),br(), uiOutput("upload_solution_button"), height = 250))
        ),
        tabItem(tabName = "down_qp_sin", 
                fluidRow(box(br(),h4(tags$b("Select Semester")), br(),br(),br(), uiOutput("semester_select_sol_sin_down"), width = 6, height = 250, background = "blue"),
                         box(br(),h4(tags$b("Select subject")), br(),br(),br(), uiOutput("subject_select_sol_sin_down"), width = 6, height = 250, background = "blue")),
                
                fluidRow(box(br(),h4(tags$b("Select one of the available papers for download")), br(), br(), br(), uiOutput("available_paper"), width = 6, height = 250, background = "light-blue")),
                
                tags$br(),tags$br(),
                
                uiOutput("download_single_qp_button")
                ),
        tabItem(tabName = "down_qp_mul",
                fluidRow(box(br(),h4(tags$b("Select semester")),br(),br(),br(), uiOutput("semester_select_sol_mul_down"), width = 6, height = 250, background = "blue"),
                         box(br(),h4(tags$b("Select one of the available question sets for download")),br(),br(),br(), uiOutput("available_papers"), width = 6, height = 250, background = "blue")),
                
                tags$br(),tags$br(),
                downloadBttn(
                  outputId = "qp_down_mul", label = "Download Question Set :)", style = "float", color = "warning", size = "lg", no_outline = FALSE)
                ),
        tabItem(tabName = "down_s",
                fluidRow(box(br(),h4(tags$b("Select the semester of solution")),br(),br(),br(),  uiOutput("semester_select_down"), width = 6, height = 250, background = "blue"), 
                         box(br(),h4(tags$b("Select the subject")), br(),br(),br(), uiOutput("subject_select_down"), width = 6, height = 250, background = "blue")),
                
                fluidRow(box(br(),h4(tags$b("Select one of the available solutions for download")), br(),br(),br(), uiOutput("available_solutions"), width = 6, height = 250, background = "light-blue")),
              
                 tags$br(),tags$br(),
               
                downloadBttn(
                  outputId = "sol_down", label = "Download Solution :)", style = "float", color = "warning", size = "lg", no_outline = FALSE
                )
      ),
      tabItem(tabName = "up_notes",
              fluidRow(box(br(),h4(tags$b("Enter your Display Name")), br(),br(),br(), uiOutput("name_select_up"), width = 6, height = 250, background = "blue"),
                       box(br(),h4(tags$b("Select semester")), br(),br(),br(), uiOutput("semester_select_up_notes"), width = 6, height = 250, background = "blue")),
              fluidRow(box(br(),h4(tags$b("Select the exam type")), br(),br(),br(), uiOutput("exam_select_up_notes"), width = 6, height = 250, background = "light-blue"),
                       box(br(),h4(tags$b("Select the subject")), br(),br(),br(), uiOutput("subject_select_up_notes"), width = 6, height = 250, background = "light-blue"),
                       box(br(),h4(tags$b("Upload your class notes here")), br(),br(),br(), uiOutput("upload_notes_button"), height = 250))
              ),
      tabItem(tabName = "down_notes", 
              fluidRow(box(br(),h4(tags$b("Select Semester")), br(),br(),br(), uiOutput("semester_select_down_notes"), width = 6, height = 250, background = "blue"),
                       box(br(),h4(tags$b("Select Subject")), br(),br(),br(), uiOutput("subject_select_down_notes"), width = 6, height = 250, background = "blue")),
              fluidRow(box(br(),h4(tags$b("Select one of the available notes for download")), br(),br(),br(), uiOutput("available_notes"), width = 6, height = 250, background = "light-blue")),
              downloadBttn(
                outputId = "notes_down", label = "Download Notes....", style = "float", color = "warning", size = "lg", no_outline = FALSE
              )
              ),
        tabItem(
          tabName = "about",
              tags$div(
                tags$h2(tags$u("General Guidelines: ")),
                tags$ul(
                  tags$li(h3("This is not an official app from IIIT Bhubaneswar and does not in any way represent the institute or it's policies")),
                  tags$li(h3("Please use this app responsibly and do not upload anything irrelevant")),
                  tags$li(h3("To successfully upload the PDFs, you have to enter your display name wherever asked")),
                  tags$li(h3("A file is uploaded successfully after you get Success Prompt with a green tick only. The progress bar is not a definite indicator of upload success")),
                  tags$li(h3("Use the Solutions on your discretion, I do not, in any way, assess the correctness of any solution that is uploaded on this app"))
                ),
                tags$br(),
                tags$h2(tags$u("Contact Me: ")),
                h3("Found some bug/issue/security flaw in the app ?"),
                h3(tags$a(href="https://github.com/hinduBale/iiit-bh_exam_archive/issues/new", "Let me know here")),tags$br(),
                h3("Want to discuss something ? I can be reached at  "),
                h3(tags$a(href="mailto:saxenism@gmail.com?Subject=ExamPrep%20Discussions",target="_top", "saxenism@gmail.com")),tags$br(),tags$br(),
                tags$h2(tags$u("About the Developer: ")),
                h3("Ciao, I'm", tags$b("Rahul Saxena"), ", a 3rd year Computer Science undergraduate at IIIT-Bhubaneswar. I love meddling with data and gaining unique insights from it. I've also had a background in cyber security."),
                h3("Apart from testing my newly acquired R skills, this web app is my way of helping out my college-mates, both present and future, by aiding their exam preparations and promoting an overall positive environment in the college itself."),
                h3("You can find me on ") ,
                h3(tags$a(href="https://github.com/hinduBale", "Github")),
                h3(tags$a(href="https://www.linkedin.com/in/saxena-rahul/", "LinkedIn")),
                h3(tags$a(href="https://twitter.com/hinduBale", "Twitter")),
                h3(tags$a(href="https://medium.com/@rahulsaxena.hindubale", "Medium")),
                h3(tags$a(href="https://www.instagram.com/saxenism/", "Instagram")),
                h3("If you liked my work, consider starring", tags$a(href = "https://github.com/hinduBale/iiit-bh_exam_archive", "the repo."), ", or treating me to Mazhar's Biryani someday :P"),
                h3("Thanks for dropping by. Peace _/\\_")
                )

        )
      )
    )
  )
)