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

summaryTable <- function(ta){
  
  med15 <- round(median(ta$aika15), digits = 3)
  med16 <- round(median(ta$aika16), digits = 3)
  
  mean15 <- round(mean(ta$aika15), digits = 3)
  mean16 <- round(mean(ta$aika16), digits = 3)
  
  sij15 <- round(median(ta$sij15),digits = 1)
  sij16 <- round(median(ta$sij16), digits = 1)
  
  t15 <- c(med15, mean15, sij15)
  t16 <- c(med16, mean16, sij16)
  
  t <- data.frame(t15, t16, row.names = c("median", "mean", "rank"))
  colnames(t) <- c("2015", "2016")
  return(t)
}

#runners2 <- runners[order(runners$suhtTimeDif, decreasing = TRUE),]