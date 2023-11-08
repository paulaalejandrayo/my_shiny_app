library(shiny)
library(ggplot2)
library(dplyr)

colours<-c("green", "blue", "red", "pink", "aquamarine3", "antiquewhite4", "black", "deeppink", "darkmagenta", "darkorange", "cyan", "darkslateblue", "darkolivegreen1", "darkred", "blue4", "coral")

datax<-read.table(file="results_amplitude_16.dat", header = TRUE)
normalisation<-(9.8*4./3.*3.1416*2500*0.0005^3*0.001)
datax$Keff_per_unit.Joules.<-datax$Keff_per_unit.Joules./normalisation
datax<-datax[datax$realisation==1,]
names(datax)[3]<-"Keff"
datax$color<-colours[datax$layer]
datax<-datax[datax$layer>1 & datax$layer<9,]
names(colours) <- as.character(1:16)


shinyServer(function(input,output) {

  #Brush used in Plot 2 to select specific layers
  
    Layers<-reactive({
        brushed_data<-brushedPoints(subset_data2(), input$brush_plot_density_fluctuations, xvar="layer", yvar="fluctuations")
        values<-c((brushed_data$layer))
        values
    })
    Layers2<-reactive({
      brushed_data<-brushedPoints(subset_data2(), input$brush_plot_density, xvar="layer", yvar="phi")
      values<-c((brushed_data$layer))
      values
    })

    subset_data<-reactive({
      if(length(Layers())==0 & length(Layers2())==0 ){
        layer<-c(1:9)
      } else {
        layer<- unique(c (Layers(), Layers2()) )
      } 
      data<-datax[datax$layer %in% layer,]
      data
    }) 

 
    
    subset_data2<-reactive({
      Fluct<-datax[datax$tap>range()[1] & datax$tap<range()[2],] %>% group_by(layer) %>% summarise(mean(Keff),sd(phi),mean(phi)) 
      names(Fluct)[2:4]<-c("Keff", "fluctuations", "phi")
      Fluct
    })   

#########
    subset_data3<-reactive({
      data<-subset_data2()
      if(length(Layers())==0 & length(Layers2())==0 ){
        layer<-c(1:9)
      } else {
        layer<- unique(c (Layers(), Layers2()) )
      } 
      size<-ifelse(data$layer %in% layer, 3,2)
      size
    })

############################### Inputs   
#Range for averages 
    range<-reactive({
      minX<-input$sliderX[1]
      maxX<-input$sliderX[2]
      range<-c(minX, maxX)
      range
    })  
    
###### OUTPUT  
#layer(s) selected
    output$Layer<-renderText({
      if(length(Layers())==0 & length(Layers2())==0 ){
        "1-9"
      } else {
        layer<- sort(unique(c (Layers(), Layers2()) ))
      }
    })  
    

##############PLOTS
    output$plot_density_evolution<- renderPlot({
      data<-subset_data()
      g<-ggplot(data=data , aes(x=tap, y=phi, col=as.character(layer)))+xlab("tap")+ylab("density (a.u.)")
      g<-g+geom_point( )+scale_color_manual(values=colours) +labs(col = "Region")
      g<-g+ geom_vline(xintercept = range()[1], col="red",linetype=5  , linewidth=2)
      g<-g+ geom_vline(xintercept = range()[2], col="red",linetype=5  , linewidth=2)
      g
    })   
    output$plot_density<- renderPlot({
      data<-subset_data2()
      f<-ggplot(data=data, aes(x=layer, y=phi  )) + xlab("region") + ylab("density (a.u.)")
      f<-f+geom_line(col="grey",linewidth=2, linetype=5 )+geom_point(  aes(col=as.character(layer), size=subset_data3()) )
      f<-f+ylim(0.5,0.725)+scale_color_manual(values=colours) + theme(legend.position = "none")
      f<-f+xlim(1,9)+ylim(0.57,0.72)
      f
    })
    
    output$plot_density_fluctuations<- renderPlot({
      data<-subset_data2()
      g<-ggplot(data=data, aes(x=layer, y=fluctuations  )) + xlab("region") + ylab("density fluctuations (a.u.)")
      g<-g+geom_line(col="grey",linewidth=2, linetype=5 )+geom_point(  aes(col=as.character(layer), size=subset_data3()))
      g<-g+scale_color_manual(values=colours) + theme(legend.position = "none")
      g<-g+xlim(1,9)+ylim(0,0.03)
      g
    })
    

})




