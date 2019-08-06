install.packages("httr")
install.packages("jsonlite")

library(httr)
library(jsonlite)
library(googleAuthR)


### set up your credentials (client id and client secret from Google Developer Console)
options("googleAuthR.client_id" = "667235664106-od6l95g7smm567do3eu2otfr9kd3uh25.apps.googleusercontent.com")
options("googleAuthR.client_secret" = "goFM_igE4N8n46GIfh0znepz")

options("googleAuthR.scopes.selected" = c("https://www.googleapis.com/auth/cloud-platform"))

googleAuthR::gar_auth() #Authentication

res<-GET

getGoogleVisionResponse("https://pbs.twimg.com/media/D-4L1ONWsAYwtR-.jpg", feature="LABEL_DETECTION")

("https://pbs.twimg.com/media/D-4L1ONWsAYwtR-.jpg", feature="LABEL_DETECTION")



resp <- GET("https://api.companieshouse.gov.uk/company/05141488", authenticate("q3LHh0aXgO8d2OI_Mq4uTJb_Mw-sNZPLTKzrb1Fl", ""), accept_json())

cont <- content(resp, as = "parsed", type = "application/json") # convert from json to list 
#explicit convertion to data frame
dataFrame <- data.frame(cont) #convert to data.frame