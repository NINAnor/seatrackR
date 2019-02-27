require(leaflet)
require(maps)
require(shiny)
require(seatrackR)
#require(magrittr)
require(xtable)
require(DBI)
require(RPostgres)
require(dplyr)

#tags$head(tags$link(rel='stylesheet', type='text/css', href='styles.css')),

######
require(tools)

Logged = FALSE;
load("shinyPass.Rdata")

ui1 <- function(){
  tagList(
    div(id = "login",
        wellPanel(textInput("userName", "Username"),
                  passwordInput("passwd", "Password"),
                  br(),actionButton("Login", "Log in"))),
    tags$style(type="text/css", "#login {font-size:10px;   text-align: left;position:absolute;top: 40%;left: 50%;margin-top: -100px;margin-left: -150px;}")
  )}

ui2 <- function(){tagList(tabPanel("Test"))}

ui = (htmlOutput("page"))
server = (function(input, output,session) {

  USER <- reactiveValues(Logged = Logged)

  observe({
    if (USER$Logged == FALSE) {
      if (!is.null(input$Login)) {
        if (input$Login > 0) {
          Username <- isolate(input$userName)
          Password <- isolate(input$passwd)
          Id.username <- which(my_username == Username)
          Id.password <- which(my_password == Password)
          if (length(Id.username) > 0 & length(Id.password) > 0) {
            if (Id.username == Id.password) {
              USER$Logged <- TRUE
            }
          }
        }
      }
    }
  })
  observe({
    if (USER$Logged == FALSE) {

      output$page <- renderUI({
        div(class="outer",do.call(bootstrapPage,c("",ui1())))
      })
    }
    if (USER$Logged == TRUE)
    {
##############END LOGIN STUFF, begin ui part#####################

      output$page <- renderUI({navbarPage("Seatrack visualization - V.06",
                                          tabPanel('Seatrack data download',
                                                   sidebarLayout(
                                                     sidebarPanel(width=2, dateRangeInput("daterange", "Date range:",
                                                                                          start = "2010-01-01",
                                                                                          end   = Sys.Date()),
                                                                  #selectInput('species', 'Species', c("All", "Common eider"),selected="All"),
                                                                  uiOutput("choose_species"),
                                                                  uiOutput("choose_colony"),
                                                                  uiOutput("choose_data_responsible"),
                                                                  uiOutput("choose_ring_number"),
                                                                  uiOutput("legend"),
                                                                  uiOutput("number_of_rows"),
                                                                  checkboxInput("limit500", "Limit display to 500 random points", value = T, width = NULL),
                                                                  downloadButton('downloadData', 'Last ned CSV')),

                                                     mainPanel(
                                                       fluidRow(column(12, h4("The default map (selecting all records) is always limited to roughly 500 points. Keep this box ticked for most subselections."))),
                                                       fluidRow(column(12,leafletOutput("mymap", height=600))
                                                       )
                                                       ,
                                                       fluidRow(column(1,offset=0,"Database dialog:"),column(11,verbatimTextOutput("nText"))))
                                                   )

                                          ),
                                          tabPanel("Active logger sessions",
                                                   DT::dataTableOutput('activeLoggingSessions')
                                          ),
                                          tabPanel("Allocation deployment mismatches",
                                                   DT::dataTableOutput('allDeplMismatch')
                                          ),
                                          tabPanel("Database stats",
                                                   DT::DTOutput('shortTable'),
                                                   DT::DTOutput('shortTableEqfilter3'),
                                                   DT::DTOutput('longerTable')
                                          )
      )

      })

#######BELOW IS server part##############



 connectSeatrack(Username = "shinyuser", Password = "shinyuser", host = "ninseatrack01.nina.no")


  datasetInput <- reactive({
    fields()$fields})

  output$downloadData <- downloadHandler(
    filename = function() { "Seatrack_data.csv" },
    content = function(file) {
      write.csv(datasetInput(), file, row.names=F)})


  select_categories<-function(){

    dbSendStatement(con,"SET search_path = positions, public;")


    cat.query <- "SELECT * FROM views.categories"

    suppressWarnings(categories <- dbGetQuery(con, cat.query))

    #categories<-fetch(res,-1)
    #dbClearResult(res)

    categories
  }


  output$choose_species<- renderUI({
    selectInput('species', 'Species', c("All", sort(as.character(unique(select_categories()$species_cat)))), selected="All")
  })

  output$choose_colony<- renderUI({
    selectInput('colony', 'Colony', c("All", sort(as.character(unique(select_categories()$colony_cat)))), selected="All")
  })

  output$choose_data_responsible<- renderUI({
    selectInput('data_responsible', 'Data responsible', c("All", sort(as.character(unique(select_categories()$responsible_cat)))), selected="All")
  })

  output$choose_ring_number <- renderUI({
    selectInput('ring_number', 'Ring number', c("All", sort(as.character(unique(select_categories()$ring_number)))), selected="All")
  })

  output$legend <- renderUI({
    radioButtons('legend', 'Figure legend', choices = c("None", "Species", "Colony", "Date"), selected="None")
  })


  output$activeLoggingSessions <- DT::renderDataTable({
    sessions <- dbGetQuery(con, "SELECT * FROM views.active_logging_sessions")
    sessions
    })

  output$allDeplMismatch <- DT::renderDataTable({
    mismatch <- dbGetQuery(con, "SELECT * FROM views.all_depl_mismatch")
    mismatch
  })

  output$shortTable <- DT::renderDT({

    #   shortSum <-"
    #   SELECT count(distinct(species)) \"Antall arter\", count(distinct(colony)) \"Antall kolonier\",
    # count(distinct(year_tracked)) \"Antall år\", count(*) \"Antall positions\",
    #   count(distinct(ring_number)) \"Antall individer\"
    #   FROM postable"

     shortSum <- "
     SELECT *
    FROM views.shorttable"

    shortTable <- dbGetQuery(con, shortSum)
    rownames(shortTable) <- ""
    colnames(shortTable) <- c("Antall arter", "Antall kolonier", "Antall år", "Antall posisjoner", "Antall individer", "Antall tracks")

    DT::datatable(shortTable)

  }
 ,
  caption = "Summeringstabell for alle funn",
 rownames = F
  # caption.placement = getOption("xtable.caption.placement", "bottom"),
  # caption.width = getOption("xtable.caption.width", NULL)
  )


  output$shortTableEqfilter3 <- DT::renderDT({


    # shortSumEqfilter3 <-"
    # SELECT count(distinct(species)) antall_arter, count(distinct(colony)) antall_kolonier, count(distinct(year_tracked)) antall_år, count(*) antall_positions,
    # count(distinct(ring_number)) antall_individer
    # FROM postable
    # WHERE eqfilter3 = 1"

     shortSumEqfilter3 <- "
     SELECT *
     FROM views.shorttableeqfilter3"

    shortTable <- dbGetQuery(con, shortSumEqfilter3)
    rownames(shortTable) <- ""
    colnames(shortTable) <- c("Antall arter", "Antall kolonier", "Antall år", "Antall posisjoner", "Antall individer", "Antall tracks")
    shortTable


  }
  ,
  caption = "Summeringstabell for alle funn med eqfilter = 3",
  rownames = F
  # caption.placement = getOption("xtable.caption.placement", "bottom"),
  # caption.width = getOption("xtable.caption.width", NULL)
  )



  output$longerTable <- DT::renderDT({

    # longerSum <-"
    # SELECT year_tracked år, species, count(distinct(ring_number)) antall_unike_ring_nummer, count(*) antall_posisjoner, count(distinct(colony)) antall_kolonier
    # FROM postable
    # GROUP BY år, species
    # ORDER BY år, species"

     longerSum <- "
     SELECT *
     FROM views.longersum
     "

    longerTable <- dbGetQuery(con, longerSum)
    #rownames(shortTable) <- ""
    colnames(longerTable) <- c("Logger-år", "Art", "Antall individer", "Antall posisjoner", "Antall kolonier")
    longerTable

  }
  ,
  caption = "Tabell over ringer",
  rownames = F
  # caption.placement = getOption("xtable.caption.placement", "bottom"),
  # caption.width = getOption("xtable.caption.width", NULL)
  )

  output$number_of_rows <- renderText(paste("Number of records in selection:", nrow(fields()$fields)))

  query <- reactive({
    if (is.null(input$species)){
      return(NULL)
    } else

      if(input$species=="All" &
         input$colony=="All" &
         input$data_responsible=="All" &
         input$ring_number =="All" &
         input$daterange[1] == "2010-01-01"
         ) {
        fetch.q <- "SELECT * FROM positions.postable TABLESAMPLE SYSTEM_ROWS(700)
                    WHERE eqfilter3 = 1
                    AND lon_smooth2 is not null
                    AND lat_smooth2 is not null"

      } else {

      start_time<-as.character(input$daterange[1])
      end_time<-as.character(input$daterange[2])


    if (input$species=="All"){
      group.sub=""
      date_range<-paste("\n WHERE date_time::date >= '", start_time,"' ", "AND date_time::date <= '", end_time, "'",sep="")

    } else {
      group.sub<-paste("\n WHERE species = '",as.character(gsub("'", "''", input$species)), "'",sep="")
      date_range<-paste("\n AND date_time::date >= '", start_time,"' ", "AND date_time::date <= '", end_time, "'",sep="")
    }


    if (input$colony=="All"){
      colony.sub<-""
    } else {

      colony.sub<- paste0("\n AND colony = '", as.character(input$colony), "'")
    }

    if (input$data_responsible=="All"){
      responsible.sub<-""
    } else {

      responsible.sub<- paste0("\n AND data_responsible = '", as.character(input$data_responsible), "'")
    }

    if (input$ring_number =="All"){
      ring.number <-""
    } else {
      ring.number <- paste0("\n AND ring_number = '",
                            as.character(input$ring_number),
                            "'")
    }

    limit<-"\n AND lon_smooth2 is not null
    AND lat_smooth2 is not null
    AND eqfilter3 = 1
    "
    ##ring_number as name, species, date_time, lat_smooth2 as lat, lon_smooth2 as lon

    fetch.q<-paste("SELECT *
                   FROM positions.postable",
                   group.sub,
                   date_range,
                   colony.sub,
                   responsible.sub,
                   ring.number,
                   limit,
                   sep="")
      }
    return(fetch.q)

  })



  fields <- reactive({
    if (is.null(input$species)){
      return(NULL)
    } else


    dbSendQuery(con, "SET CLIENT_ENCODING TO 'UTF8'")

    suppressWarnings(post.fields <- dbGetQuery(con, as.character(query())))

    if(input$limit500 == TRUE){

      if(nrow(post.fields)<500){
        out <- list(fields = post.fields, fields.subset = post.fields)
      } else
        out <- list(fields = post.fields, fields.subset = post.fields[sample(x = 1:nrow(post.fields), size = 500), ])
    }
    else out <- list(fields = post.fields, fields.subset = post.fields)

    return(out)

  })


  output$mymap<-renderLeaflet({
    if (is.null(input$species)){
      return(NULL)

    } else


      if (nrow(fields()$fields)<1) {
        content<-paste(sep="<br/>", "<br> No Data! </br>", "Change data subset")
        leaflet() %>%
          addProviderTiles("OpenStreetMap.Mapnik") %>%
          addPopups(10.406467, 63.414108, content,
                    options = popupOptions(closeButton = FALSE)
          )
      } else

        ##Make palette based on tickmark choices.
        dates <- data.frame("julian" = as.numeric(julian(fields()$fields.subset$date_time, origin = input$daterange[1])))
        specPal <- colorFactor(palette = rainbow(11), domain = fields()$fields.subset$species)
        datePal <- colorNumeric(palette = rainbow(7), domain = dates$julian)
        colPal <- colorFactor(palette = topo.colors(length(unique(fields()$fields.subset$colony))), domain = fields()$fields.subset$colony)

        myLabelFormat <- function(..., dates = F){
          if(dates){
            function(type = "numeric", cuts){
              as.Date(cuts, origin =input$daterange[1])
            }
          } else {
            labelFormat(...)
          }
        }


        if(input$legend == "None"){
          chosenPal <- "#E57200"
          legendPal <- "#E57200"
          chosenLegendVal <- fields()$fields$species
          legendTitle <- "Positions"
          labelFormat <- myLabelFormat(dates = F)
        }

        if(input$legend == "Species"){
          chosenPal <- ~specPal(species)
          legendPal <- specPal
          chosenLegendVal <- fields()$fields$species
          legendTitle <- "Species"
          labelFormat <- myLabelFormat(dates = F)
        }

        if(input$legend == "Date"){
          chosenPal <- ~ datePal(dates$julian)
          legendPal <- datePal
          chosenLegendVal <- dates$julian
          legendTitle <- "Date"
          labelFormat <- myLabelFormat(dates = T)
        }

        if(input$legend == "Colony"){
          chosenPal <- ~ colPal(colony)
          legendPal <- colPal
          chosenLegendVal <- fields()$fields$colony
          legendTitle <- "Colony"
          labelFormat <- myLabelFormat(dates = F)
        }


        if (nrow(fields()$fields)>500){
          my.fields <- fields()$fields.subset

         p <- leaflet(fields()$fields.subset) %>%
            addProviderTiles("Esri.NatGeoWorldMap") %>%
            #addProviderTiles("MapQuestOpen.OSM") %>%  # Add MapBox map tiles
            addCircleMarkers(radius=6, stroke= FALSE,
                             fillOpacity=0.5,
                             lng=my.fields$lon_smooth2,
                             lat=my.fields$lat_smooth2,
                             popup=paste("Ring ID: ",
                                         as.character(fields()$fields.subset$ring_number),
                                         "<br> Species: ", fields()$fields.subset$species,
                                           "<br> Time: ", fields()$fields.subset$date_time),
                             color = chosenPal)
          if(input$legend != "None"){
        p <- p %>%  addLegend("bottomright", pal = legendPal, values = chosenLegendVal,
                      title = legendTitle,
                      opacity = 1,
                      labFormat = labelFormat)
          }
         p
        } else
        {
         p <- leaflet(fields()$fields.subset) %>%
            addProviderTiles("Esri.NatGeoWorldMap") %>%
            #addProviderTiles("MapQuestOpen.OSM") %>%
            addCircleMarkers(radius=6, stroke= FALSE,
                             fillOpacity=0.5,
                             lng=fields()$fields$lon_smooth2,
                             lat=fields()$fields$lat_smooth2,
                             popup=paste("Ring ID: ",
                                         as.character(fields()$fields$ring_number),
                                         "<br> Species: ", fields()$fields$species,
                                           "<br> Time: ", fields()$fields$date_time),
                             color = chosenPal)
          if(input$legend != "None"){
         p <- p %>% addLegend("bottomright", pal = legendPal, values = chosenLegendVal,
                      title = legendTitle,
                      opacity = 1,
                      labFormat = labelFormat)
          }
         p

        }



  })


  ntext<-reactive(
    query()

  )

  output$nText <- renderText({
    ntext()
  })

}

})
})

shinyApp(ui= ui, server= server)
