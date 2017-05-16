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


ui<-shinyUI(
  navbarPage("Seatrack visualization - V.04",
             tabPanel('Seatrack data download',
                      sidebarLayout(
                        sidebarPanel(width=2, dateRangeInput("daterange", "Date range:",
                                                             start = Sys.Date() -365,
                                                             end   = Sys.Date()),
                                     #selectInput('species', 'Species', c("All", "Common eider"),selected="All"),
                                     uiOutput("choose_species"),
                                     uiOutput("choose_colony"),
                                     uiOutput("choose_data_responsible"),
                                     uiOutput("choose_ring_number"),
                                     checkboxInput("limit500", "Limit display to 500 random records", value = T, width = NULL),

                                     downloadButton('downloadData', 'Last ned CSV')),

                        mainPanel(
                          fluidRow(column(12, h4("Kartet viser som default 500 tilfeldige punkter av valgt data."))),
                          fluidRow(column(12,leafletOutput("mymap", height=600))
                          )
                          ,
                          fluidRow(column(1,offset=0,"Database dialog:"),column(11,verbatimTextOutput("nText"))))
                      )

             ),
             tabPanel("Database stats",
                      tableOutput('shortTable'),
                      tableOutput('shortTableEqfilter3'),
                      tableOutput('longerTable')
             )
  ))






server<-function(input, output, session) {

  con <- seatrackConnect(Username = "testreader", Password = "testreader")


  datasetInput <- reactive({
    fields()$fields})

  output$downloadData <- downloadHandler(
    filename = function() { "Seatrack_data.csv" },
    content = function(file) {
      write.csv(datasetInput(), file, row.names=F)})


  select_categories<-function(){




    dbGetQuery(con,"SET search_path = seatrack, public;")


    cat.query<-"SELECT  species as species_cat, colony as colony_cat, data_responsible as responsible_cat
    , ring_number as ring_number_cat
    FROM positions.postable
    GROUP BY species, colony, data_responsible, ring_number
    "

    suppressWarnings(categories<-dbGetQuery(con, cat.query))

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


  output$shortTable <- renderTable({

    #   shortSum <-"
    #   SELECT count(distinct(species)) \"Antall arter\", count(distinct(colony)) \"Antall kolonier\",
    # count(distinct(year_tracked)) \"Antall år\", count(*) \"Antall positions\",
    #   count(distinct(ring_number)) \"Antall individer\"
    #   FROM postable"

    shortSum <- "
    SELECT * FROM
    shorttable"

    shortTable <- dbGetQuery(con, shortSum)
    rownames(shortTable) <- ""
    colnames(shortTable) <- c("Antall arter", "Antall kolonier", "Antall år", "Antall posisjoner", "Antall individer")

    shortTable

  },
  caption = "Summeringstabell for alle funn",
  caption.placement = getOption("xtable.caption.placement", "bottom"),
  caption.width = getOption("xtable.caption.width", NULL))


  output$shortTableEqfilter3 <- renderTable({


    # shortSumEqfilter3 <-"
    # SELECT count(distinct(species)) antall_arter, count(distinct(colony)) antall_kolonier, count(distinct(year_tracked)) antall_år, count(*) antall_positions,
    # count(distinct(ring_number)) antall_individer
    # FROM postable
    # WHERE eqfilter3 = 1"

    shortSumEqfilter3 <- "
    SELECT *
    FROM shorttableeqfilter3"

    shortTable <- dbGetQuery(con, shortSumEqfilter3)
    rownames(shortTable) <- ""
    colnames(shortTable) <- c("Antall arter", "Antall kolonier", "Antall år", "Antall posisjoner", "Antall individer")
    shortTable


  },
  caption = "Summeringstabell for alle funn med eqfilter = 3",
  caption.placement = getOption("xtable.caption.placement", "bottom"),
  caption.width = getOption("xtable.caption.width", NULL))



  output$longerTable <- renderTable({

    # longerSum <-"
    # SELECT year_tracked år, species, count(distinct(ring_number)) antall_unike_ring_nummer, count(*) antall_posisjoner, count(distinct(colony)) antall_kolonier
    # FROM postable
    # GROUP BY år, species
    # ORDER BY år, species"

    longerSum <- "
    SELECT *
    FROM longersum
    "

    longerTable <- dbGetQuery(con, longerSum)
    #rownames(shortTable) <- ""
    colnames(longerTable) <- c("Logger-år", "Art", "Antall individer", "Antall posisjoner", "Antall kolonier")
    longerTable

  },


  caption = "Tabell over ringer",
  caption.placement = getOption("xtable.caption.placement", "bottom"),
  caption.width = getOption("xtable.caption.width", NULL))



  query<-reactive({
    if (is.null(input$species)){
      return(NULL)
    } else

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
      ring.number <- paste0("\n AND ring_number = '", as.character(input$ring_number), "'")
    }

    limit<-"\n AND lon_smooth2 is not null
    AND lat_smooth2 is not null
    AND eqfilter3 = 1
    "
    ##ring_number as name, species, date_time, lat_smooth2 as lat, lon_smooth2 as lon

    fetch.q<-paste("SELECT *
                   FROM positions.postable"
                   ,group.sub,date_range, colony.sub, responsible.sub, ring.number, limit,sep="")

    fetch.q

  })



  fields<-reactive({
    if (is.null(input$species)){
      return(NULL)
    } else


    dbGetQuery(con, "SET CLIENT_ENCODING TO 'UTF8'")

    suppressWarnings(post.fields <- dbGetQuery(con,as.character(query())))

    if(input$limit500 == TRUE){

      if(nrow(post.fields)<500){
        list(fields=post.fields, fields.subset=post.fields)
      } else
        list(fields=post.fields, fields.subset=post.fields[sample(x=1:nrow(post.fields),size=500),])
    }
    else list(fields=post.fields, fields.subset=post.fields)


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

        if (nrow(fields()$fields)>500){
          my.fields<-fields()$fields.subset

          leaflet() %>%
            addProviderTiles("Esri.NatGeoWorldMap") %>%
            #addProviderTiles("MapQuestOpen.OSM") %>%  # Add MapBox map tiles
            addCircleMarkers(radius=6, stroke= FALSE, fillOpacity=0.5, lng=my.fields$lon_smooth2, lat=my.fields$lat_smooth2
                             , popup=paste("Ring ID: ",as.character(my.fields$ring_number),"<br> Species: ", my.fields$species,
                                           "<br> Time: ", my.fields$date_time), col = "#E57200")
        } else
        {
          leaflet() %>%
            addProviderTiles("Esri.NatGeoWorldMap") %>%
            #addProviderTiles("MapQuestOpen.OSM") %>%
            addCircleMarkers(radius=6, stroke= FALSE, fillOpacity=0.5, lng=fields()$fields$lon_smooth2, lat=fields()$fields$lat_smooth2
                             , popup=paste("Ring ID: ",as.character(fields()[1]$ring_number),"<br> Species: ", fields()$fields$species,
                                           "<br> Time: ", fields()$fields$date_time), col = "#E57200"
            )

        }



  })


  ntext<-reactive(
    query()

  )

  output$nText <- renderText({
    ntext()
  })

}

shinyApp(ui= ui, server= server)

