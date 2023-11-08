library(shiny)

shinyUI(fluidPage(

    # Application title
    titlePanel("Averaging density and density fluctuations"),
    sidebarLayout(
        sidebarPanel(
            p("INSTRUCTIONS:"),
            p("------------------------------------------"),
            h5("Move the markers to select the range of times from the dataset to be used in the calculation of the density average and standard deviation (fluctuations)"),
            h5("The selected data is enclosed between the vertical red-dashed lines in the figure on the top."),
            h5("This is meant to explore the effect of (inclusion/exclusion of) transients in the density/density flcutuations behaviour."),

            sliderInput("sliderX","Pick minimum-maximum time-range for averages", 1,200,value=c(1,200)),
            p("------------------------------------------"),
            h3(" "),
            h5("Select one or few points (corresponding to regions in the system) from the figures below"),
            h5("The corresponding selection will be highlighted in the other figure."),
            h5("Only the density evolution of the selected reion will be now shown in the top figure. "),
            h5("This is meant to explore the isolated behaviour of the corresponding region and investigate the time evolution leading to specific values
               of the density and denstiy-fluctuations."),
            h3("Region(s) selected"),
            textOutput("Regions")
        ),
        mainPanel(
            tabsetPanel(type="tabs",
                        tabPanel("Macroscopic behaviour", 
                                 fluidRow(
                                     column(12,
                                            h3("density evolution"),
                                            plotOutput("plot_density_evolution")
                                     )),
                                 fluidRow(
                                 column(6,
                                        h3("density vs. region"),
                                        plotOutput("plot_density", brush=brushOpts(id="brush_plot_density"))
                                        ),
                                 column(6,
                                        h3("density fluctuations vs. region"),
                                        plotOutput("plot_density_fluctuations", brush=brushOpts(id="brush_plot_density_fluctuations"))
                                 )                                 
                                 )
                              ),
                        tabPanel("Getting Started",
                                 p("This app studies the density evolution (density as a function of time) 
                                   corresponding to a granular pile and shows the average density and 
                                   density fluctuations (standard deviation), measured over different 'time ranges' and along the pile height. 
                                   The pile is separated in (9) horizontal regions (layers) and the density of each one of those regions is tracked over time.
                                   The pile is perturbed through the application of (200) discrete tappings (==time) of constant intensity. "),
                                   p("By controling the sliders", span("minimum/maximum tap range", style = "color:blue"),
                                   "different time-ranges are selected (marked by the red-vertical-dashed-lines).
                                   Average and standard deviation of the data selected are plot in the figure below (left and rigth, respectively).
                                   Does the shape of these curves change with the time-range selected? Does it change quantitatively? 
                                   Specific points can be selected from the figures below to isolate the 
                                   corresponding time-evolution of the selected region.")
                                  )
                     )
            )
        )
))

