#helpers

hoursToTime <- function(hours){
  
  h <- floor(hours)
  min <- (hours - h)*60
  sec <- (min - floor(min))*60
  
  
  return (paste(h,"tuntia",floor(min),"min",floor(sec),"sec"))
}

orderTable <- function(x, a){
  
  ab <- switch(a,
         "aika 15" = "aika15",
         "aika 16" = "aika16",
         "sij 15" = "sij15",
         "sij 16" = "sij16",
         "aika ero" = "timeDif",
         "suht. aika ero" = "suhtTimeDif",
         "adj. aika" = "adjTime16")
  
 
  runners2 <- x[order(x[ab], 
                    decreasing = ifelse((ab == "timeDif" | ab == "suhtTimeDif"), 
                                        TRUE, FALSE)),]
  
  t <- cbind(c(1:length(runners2$name)),runners2["name"],runners2[ab])
  colnames(t) <-  c("N.", "Nimi", a)
  return(t)
}

#runners2 <- runners[order(runners$suhtTimeDif, decreasing = TRUE),]