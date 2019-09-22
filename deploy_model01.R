# load required libraries
library(dplyr)

# load required dataframes
my.dir <- "model01"

message("Loading required dataframes...")

load(file = paste0(my.dir, "/", "df_n1.rda"), verbose = TRUE)
load(file = paste0(my.dir, "/", "df_n2.rda"), verbose = TRUE)
load(file = paste0(my.dir, "/", "df_n3.rda"), verbose = TRUE)
load(file = paste0(my.dir, "/", "df_n4.rda"), verbose = TRUE)

message("Dataframes successfully loaded!")

# NEXT
