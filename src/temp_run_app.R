Sys.setenv(R_HOME = file.path(getwd(), "..", "R"))
Sys.setenv(PATH = paste(Sys.getenv("PATH"), file.path(getwd(), "..", "R", "bin"), sep = ";"))
.libPaths(file.path(getwd(), "..", "R", "library"))

library(shiny)
library(httpuv)

port <- httpuv::randomPort()
cat("Using port:", port, "\n")

setwd(file.path(getwd(), "..", "shiny"))

runApp("app.R", port = port, host = "127.0.0.1", launch.browser = FALSE)
