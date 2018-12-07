#  Process grade-related things....
#  
#  
## Participation grade
## 
## 
library(tidyverse)
library(tidyjson)

source("grades/secrets.R") 


# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/AdamWilsonLabEDU/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
d = jsonlite::fromJSON(jsonlite::toJSON(json1))%>%
  mutate(type=ifelse(grepl("finalproject",full_name),
                     "final_project","case_study"))

# Subset data.frame
mutate_at(d,grepl("geo503-2018")
       