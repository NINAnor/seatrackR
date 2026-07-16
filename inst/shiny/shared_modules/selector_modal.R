selector_modal_ui <- function(id, button_label = "open filter") {
    ns <- NS(id)

    actionButton(ns("open_button"), button_label, class = "btn-sm")
}


selector_modal_server <- function(id, modal_choices, modal_selected = NULL, on_close = function(chosen) {}, modal_title = "Filter", reset_signal = NULL) {
    ns <- NS(id)
    moduleServer(id, function(input, output, session) {

        close_and_select <- function(new_val){
            
            if(!is.null(new_val)){
                shinyjs::addClass(id = "open_button", "btn-primary")
            }else{
                shinyjs::removeClass(id = "open_button", "btn-primary")
            }
            on_close(new_val)
            removeModal()
        }

        print(paste("Starting server", id))
        observe({
            print(paste("Show filter modal", id))
            print(modal_choices)
            if (is.function(modal_choices)) {
                available_choices <- modal_choices()
            } else {
                available_choices <- modal_choices
            }

            if (is.function(modal_selected)) {
                available_selected <- modal_selected()
            } else {
                available_selected <- modal_selected
            }

            showModal(
                modalDialog(
                    p(modal_title),
                    checkboxGroupInput(
                        inputId = session$ns("modal_choices"),
                        label = NULL,
                        choices = available_choices,
                        selected = available_selected
                    ),
                    layout_columns(actionButton(session$ns("clear"), "Clear", class = "btn-danger")),
                    layout_columns(
                        actionButton(session$ns("cancel"), "Cancel"),
                        actionButton(session$ns("apply"), "Apply"),
                        class = "m-0"
                    ),
                    title = NULL,
                    easyClose = FALSE,
                    footer = NULL,
                    fade = FALSE
                )
            )
        }) |> bindEvent(input$open_button)


        observe({
            removeModal()
        }) |>
            bindEvent(input$cancel)

        observe({
            close_and_select(input$modal_choices)
        }) |>
            bindEvent(input$apply)

        observe({
            updateCheckboxGroupInput(selected=character(0), inputId = "modal_choices")
            close_and_select(NULL)
        }) |>
            bindEvent(input$clear)

        if(!is.null(reset_signal)){
            
            observeEvent(reset_signal(), {
                
                if(reset_signal()){
                    
                    close_and_select(NULL)
                }
            })
        }



    })
}
