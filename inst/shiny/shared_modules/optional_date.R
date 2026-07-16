optional_date_selector <- function(id, input_label = "Date range") {
    ns <- NS(id)
    
        layout_columns(
            shinyjs::disabled(
                dateRangeInput(inputId = ns("date_input"), label = NULL, start = as.Date("2000-01-01"))
            ),
            checkboxInput(inputId = ns("enable_input"), label = input_label),
            fillable = FALSE
        )
    
}

optional_date_selector_server <- function(id, on_select = function(chosen) {}, reset_signal = NULL) {
    ns <- NS(id)
    moduleServer(id, function(input, output, session) {
    active <- reactiveVal(FALSE)

    observeEvent(input$date_input, {
        if(active()){
            on_select(input$date_input)
        }else{
            on_select(NULL)
        }
    })

    observeEvent(input$enable_input, {
        print("checkbox")
        active(input$enable_input)
    })

    observeEvent(active(),{
        print(active())
        if(active()){
            
            shinyjs::enable(id="date_input")
            on_select(input$date_input)
        }else{
            shinyjs::disable(id="date_input")
            on_select(NULL)
        }
    })

    if(!is.null(reset_signal)){
        
        observeEvent(reset_signal(), {
            
            if(reset_signal()){
                updateDateRangeInput(inputId = "date_input", start = as.Date("2000-01-01"), end = NA)
                updateCheckboxInput(inputId = "enable_input", value = FALSE)
                
                on_select(NULL)
            }
        })
    }
    })
}

