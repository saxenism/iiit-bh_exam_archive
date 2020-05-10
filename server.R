first_sem_subjects <- c("Mathematics 1", "C Programming", "Basic Electronics", "Physics", "BME", "Oral Business Communication(CS 1)")
second_sem_subjects <- c("Mathematics 2", "Data Structures", "EES", "Electrical", "Written Business Communication (CS 2)")
third_sem_subjects  <- c("Critical Reading", "Digital Electronic Circuit", "Introduction to Programming - II", "Probability and Statistics", "Scientific Computing with Python", "Advanced Material Chemistry", "Entrepreneurship Development", "Network Theory")
fourth_sem_subjects <- c("Culture and Communication", "Basics of Management for Engineers", "Design and Analysis of Algorithms", "Relational Database Management System", "Computer Organisation and Architecture", "Discrete Structure", "Energy Conversion Devices", "Digital Signal Processing")
fifth_sem_subjects <- c("Digital Marketing", "Data and Web Mining", "Relational Database Management System", "Compiler Design", "Java Programming", "Computer Organization", "Renewable Energy Source", "IOT")
sixth_sem_subjects <- c("MPMC", "Operating System", "Data Communication and Computer Network", "Environmental Engineering and Safety", "Control System Engineering", "Mobile Computing", "Pattern Recognition")
seventh_sem_subjects <- c("Optimization in Engineering", "Seminar and Technical Writing", "Principles of Soft Computing", "Principles and Practices in Software Engineering", "Project Management", "Digital Image Processing", "Software Project Management")

third_sem_eee <- c("ME", "CPP", "Network Theory", "AEC", "Maths", "Communication Engineering", "Python", "Chemistry")
fourth_sem_eee <- c("EM", "EEM", "EMFW", "DEC", "Maths", "CS")
fifth_sem_eee <- c("Power Electronics", "Control System", "Renewable Energy Sources", "Electrical Machines 2", "Enivronmental Engineering", "Digital Marketing", "Artificial Intelligence")
sixth_sem_eee <- c("MPMC", "Internet and Web Technology(IWT)", "Electrical Power Transmission and Distribution(EPTD)", "Optimization Engineering", "Digital Signal Processing(DSP)", "Electrical Drives")
seventh_sem_eee <- c("Power System Control", "Power Station Engineering", "Electrical Power Quality", "Soft Computing", "Power System Protection", "Communication Engineering")

third_sem_etc <- c("Maths", "NT", "AEC", "C++", "CS", "Python")
fourth_sem_etc <- c("Probability", "DEC", "DSP", "ACT", "EEM", "CS", "EMFW")
fifth_sem_etc <- c("MPMC", "Advanced Electronics", "Control System", "Renewable Enegy sources", "Digital Marketing", "Digital Communication Techniques")
sixth_sem_etc <- c("Very Large Scale Integration", "Optimization Engineering", "Microwave Engineering", "Radar and Communication", "Digital Signal Processing", "Information Theory and Coding", "Power Electronics" )
seventh_sem_etc <- c("Antenna and Wave Propagation", "Fundamentals of Image Processing", "Advanced Signal Processing", "Mobile Computing", "Project Management")

#Increasing the PDF file size to 30MB
options(shiny.maxRequestSize=30*1024^2) 

shinyServer(function(input, output, session) {
  
###########################################################################################################################################################################
# Helper Functions 
###########################################################################################################################################################################
  subject_selector <- function(sem_helper, helper_id) {
    if(sem_helper == 1) {
      selectInput(helper_id, "* Required Field", sort(first_sem_subjects))
    } else if(sem_helper == 2) {
      selectInput(helper_id, "* Required Field", sort(second_sem_subjects))
    } else if(sem_helper == 3) {
      selectInput(helper_id, "* Required Field", sort(unique(append(append(third_sem_subjects, third_sem_eee), third_sem_etc))))
    } else if(sem_helper == 4) {
      selectInput(helper_id, "* Required Field", sort(unique(append(append(fourth_sem_subjects, fourth_sem_eee), fourth_sem_etc))))
    } else if(sem_helper == 5) {
      selectInput(helper_id, "* Required Field", sort(unique(append(append(fifth_sem_subjects, fifth_sem_eee), fifth_sem_etc))))
    } else if(sem_helper == 6) {
      selectInput(helper_id, "* Required Field", sort(unique(append(append(sixth_sem_subjects, sixth_sem_eee), sixth_sem_etc))))
    } else if(sem_helper == 7) {
      selectInput(helper_id, "* Required Field", sort(unique(append(append(seventh_sem_subjects, seventh_sem_eee), seventh_sem_etc))))
    } else {
      selectInput(helper_id, "* Required Field", c("Areyy aap log maze karo o_0"))
    }
  }
  
###########################################################################################################################################################################
# Upload Single Question Paper 
###########################################################################################################################################################################
  
  observeEvent(input$sin_sol_id, {
    fileName_sin_q <- sprintf("www//%s//%s_%s_%s_%s_%s.pdf", input$sem_select, input$sub_select, input$exam_select, input$year_select, input$sem_select, input$bra_select)
    pages_sin_q <- pdf_info(input$sin_sol_id$datapath)$pages
    pdf_subset(input$sin_sol_id$datapath, pages = 1:pages_sin_q, output = fileName_sin_q)
  })
  
  observeEvent(input$sin_sol_id, {
    sendSweetAlert(session = session, title = "Success !!", text = "The Upload was successful ^_^", type = "success") 
  })
  
  output$semester_select <- renderUI({
    pickerInput(inputId = "sem_select", label = "Select Semester", choices = 1:7)
  })
  
  output$branch_select <- renderUI({
    pickerInput(inputId = "bra_select", label = "Select Branch", choices = c("CSE", "IT", "CE", "EEE", "ETC", "All Branches", "CSE&CE", "CSE&IT", "CE&IT", "EEE&ETC"))
  })
  
  output$year_select <- renderUI({
    pickerInput(inputId = "year_select", label = "Select Year", choices = 2009:2020)
  })
  
  output$exam_select <- renderUI({
    pickerInput(inputId = "exam_select", label = "Select type of Examination", choices = c("Mid Semester Examination", "End Semester Examination"))
  })
  
  output$subject_select <- renderUI({
    req(input$sem_select)
    subject_selector(input$sem_select, "sub_select")
  })
  
  
###########################################################################################################################################################################
# Upload Multiple Question Papers 
###########################################################################################################################################################################

  output$semester_select_mul <- renderUI({
    selectInput("sem_select_mul", "* Required Field", 1:8)
  })
  
  output$exam_select_mul <- renderUI({
    selectInput(inputId = "exam_select_mul", label = "* Required Field", choices =  c("Mid Semester Examination", "End Semester Examination"))
  })
  
  output$name_select_ques <- renderUI({
    textInput(inputId = "display_name_ques", label = "* Required", placeholder = "Enter your display name")
  })
  
  output$upload_questionSet_button <- renderUI({
    validate(
      need(input$display_name_ques != "", "Please enter the display name of the uploader")
    )
    fileInput( inputId = "multi_sol_id",
               label = "Please upload the question set available with you :) (PDFs only)",
               multiple = TRUE,
               accept = c(".pdf"),
               buttonLabel = "Upload Papers")
  })
  
  observeEvent(input$multi_sol_id, {
    fileName_set <- sprintf("www/%s/questionSet_%s_%s.pdf", input$sem_select_mul,input$exam_select_mul, input$display_name_ques)
    pages_set <- pdf_info(input$multi_sol_id$datapath)$pages
    pdf_subset(input$multi_sol_id$datapath, pages = 1:pages_set, output = fileName_set)
  })
  
  observeEvent(input$multi_sol_id, {
    sendSweetAlert(session = session, title = "Success !!", text = "Question Set uploaded. Good work ;)", type = "success") 
  })
  
  
###########################################################################################################################################################################
# Upload Solution 
###########################################################################################################################################################################
  
  output$branch_select_sol_sin <- renderUI({
    selectInput("branch_select_solution_single", "* Required Field", c("CSE", "IT", "CE", "EEE", "ETC", "All Branches", "CSE&CE", "CSE&IT", "CE&IT", "EEE&ETC"))
  })
  output$year_select_sol_sin <- renderUI({
    selectInput("year_select_solution", "* Required Field", 2009:2020)
  })
  output$exam_select_sol_sin <- renderUI({
    selectInput("exam_select_solution", "* Required Field", c("Mid Semester Examination", "End Semester Examination"))
  })
  output$semester_select_sol_sin <- renderUI({
    selectInput("sem_select_solution", "* Required Field", 1:7)
  })
  output$subject_select_sol_sin <- renderUI({
    req(input$sem_select_solution)
    subject_selector(input$sem_select_solution, "sub_select_sol_sin")
  })
  output$name_select_sol_sin <- renderUI({
    textInput("display_name_sol_sin", "* Required Field", placeholder = "Please enter the display name of the solver")
  })
  output$upload_solution_button <- renderUI({
    validate(
      need(input$display_name_sol_sin != "", "Please enter the name of the solver")
    )
    fileInput(inputId = "sol_id_sin",
              label = "Please upload the solutions available with you :) (Only PDF format)",
              accept = (".pdf"),
              buttonLabel = "Upload solution")
  })
  
  observeEvent(input$sol_id_sin, {
    req(input$branch_select_solution_single, input$year_select_solution, input$exam_select_solution, input$sem_select_solution, input$sub_select_sol_sin, input$display_name_sol_sin)
    fileName_sol <- sprintf("www//%s//solution_%s_%s_%s_%s_%s.pdf", input$sem_select_solution, input$sub_select_sol_sin, input$exam_select_solution, input$year_select_solution, input$sem_select_solution, input$branch_select_solution_single)
    pages_sol <- pdf_info(input$sol_id_sin$datapath)$pages
    pdf_subset(input$sol_id_sin$datapath, pages = 1:pages_sol, output = fileName_sol)
  })
  
  observeEvent(input$sol_id_sin, {
    req(input$branch_select_solution_single, input$year_select_solution, input$exam_select_solution, input$sem_select_solution, input$sub_select_sol_sin, input$display_name_sol_sin)
    sendSweetAlert(session = session, title = "Solution Uploaded !!", text = "You are now eligible for a lot of treats :P", type = "success") 
  })
  
##########################################################################################################################################################################
# Download Single Question Paper
##########################################################################################################################################################################

  output$semester_select_sol_sin_down <- renderUI({
    selectInput("sem_select_solution", "* Required Field", 1:8)
  })
  output$subject_select_sol_sin_down <- renderUI({
    req(input$sem_select_solution)
    subject_selector(input$sem_select_solution, "sub_select_sol_sin_down")
  })
  output$available_paper <- renderUI({
    req(input$sem_select_solution, input$sub_select_sol_sin_down)
    selectInput("avail_paper", "* Choose only one", choices = list.files(path = sprintf("www/%s", input$sem_select_solution), pattern = sprintf("%s", input$sub_select_sol_sin_down)))
  })
  
  output$download_single_qp_button <- renderUI({
    downloadBttn(
      outputId = "qp_down_sin", 
      label = "Download Question Paper :)", 
      style = "float", 
      color = "warning", 
      size = "lg", 
      no_outline = FALSE)                
  })

  output$qp_down_sin <- downloadHandler(
    filename <- function(){
      search_ques_fileName <- sprintf("www/%s/%s",
                                      input$sem_select_solution,
                                      input$avail_paper)
      return (search_ques_fileName)
    },
    content <- function(file) {
      file.copy(filename(), file)
    },
    contentType = "application/pdf"
  )
  
##########################################################################################################################################################################
# Download Multiple Question Papers
##########################################################################################################################################################################
  
  output$semester_select_sol_mul_down <- renderUI({
    selectInput("semester_select_solution_multiple", "* Required Field", choices = 1:7)
  })
  
  output$available_papers <- renderUI({
    req(input$semester_select_solution_multiple)
    selectInput("avail_papers", "* Choose only one", choices = list.files(path = sprintf("www/%s", input$semester_select_solution_multiple), pattern = sprintf("questionSet")))
  })
  
  output$qp_down_mul <- downloadHandler(
    filename <- function(){
      search_papers_fileName <- sprintf("www/%s/%s",
                                          input$semester_select_solution_multiple,
                                          input$avail_papers)
      return (search_papers_fileName)
    },
    content = function(file){
      file.copy(filename(), file)
    })
    
###########################################################################################################################################################################
# Download Solution 
###########################################################################################################################################################################
  
  output$semester_select_down <- renderUI({
    pickerInput(inputId = "sem_select_down", label = "Select Semester", choices = 1:7)
  })

  output$subject_select_down <- renderUI({
    req(input$sem_select_down)
    subject_selector(input$sem_select_down, "sub_select_down")
  })
  
  output$available_solutions <- renderUI({
    req(input$sem_select_down, input$sub_select_down)
    selectInput("avail_solutions", "* Choose only one", choices = list.files(path = sprintf("www/%s", input$sem_select_down), pattern = sprintf("solution_%s", input$sub_select_down)))
  })
  
  output$sol_down <- downloadHandler(
    filename <- function(){
      search_solution_fileName <- sprintf("www/%s/%s",
                                       input$sem_select_down,
                                       input$avail_solutions)
      return (search_solution_fileName)
    },
    content <- function(file){
      file.copy(filename(), file)
    },
    contentType = "application/pdf"
  )

###########################################################################################################################################################################
# Upload Notes 
###########################################################################################################################################################################
  
  output$name_select_up <- renderUI({
    textInput("display_name", "* Required Field")
  })
  
  output$semester_select_up_notes <- renderUI({
    selectInput("sem_select_up_notes", "* Required Field", 1:7)
  })
  
  output$subject_select_up_notes <- renderUI({
    req(input$sem_select_up_notes)
    subject_selector(input$sem_select_up_notes, "sub_select_up_notes")
  })
  
  output$exam_select_up_notes <- renderUI({
    pickerInput(inputId = "exam_select_up_notes", label = "* Required", choices = c("Mid Semester Examination", "End Semester Examination"))
  })
  
  output$upload_notes_button <- renderUI({
    validate(
      need(input$display_name != "", "Please enter the display name of the writer")
    )
    fileInput(inputId = "notes_id",
               label = "Please upload the notes available with you :) (PDFs only)",
               multiple = TRUE,
               accept = c(".pdf"),
               buttonLabel = "Upload Notes")
  })
  
  observeEvent(input$notes_id, {
    req(input$display_name, input$sem_select_up_notes, input$sub_select_up_notes, input$exam_select_up_notes)
    fileName_notes <- sprintf("www/%s/classNotes_%s_%s_%s.pdf", input$sem_select_up_notes, input$sub_select_up_notes, input$exam_select_up_notes, input$display_name)
    pages_notes <- pdf_info(input$notes_id$datapath)$pages
    pdf_subset(input$notes_id$datapath, pages = 1:pages_notes, output = fileName_notes)
  })
  
  observeEvent(input$notes_id, {
    req(input$display_name, input$sem_select_up_notes, input$sub_select_up_notes, input$exam_select_up_notes)
    sendSweetAlert(session = session, title = "Success !!", text = "Notes uploaded. You're a good man!", type = "success") 
  })
  
###########################################################################################################################################################################
# Download Notes 
###########################################################################################################################################################################
  
  output$semester_select_down_notes <- renderUI({
    selectInput("sem_sel_down_notes", "* Required Field", choices = 1:7)
  })

  output$subject_select_down_notes <- renderUI({
    req(input$sem_sel_down_notes)
    subject_selector(input$sem_sel_down_notes, "sub_select_down_notes")
  })
  
  output$available_notes <- renderUI({
    req(input$sem_sel_down_notes, input$sub_select_down_notes)
    selectInput("avail_notes", "* Choose only one", choices = list.files(path = sprintf("www/%s", input$sem_sel_down_notes), pattern = sprintf("classNotes_%s", input$sub_select_down_notes)))
  })
  
  output$notes_down <- downloadHandler(
    filename <- function(){
      search_notes_fileName <- sprintf("www/%s/%s",
                                      input$sem_sel_down_notes,
                                      input$avail_notes)
      return (search_notes_fileName)
    },
    content <- function(file){
      file.copy(filename(), file)
    },
    contentType = "application/pdf"
  )
})