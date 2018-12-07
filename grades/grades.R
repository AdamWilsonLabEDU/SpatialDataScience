#  Process grade-related things....
#  
#  
## Participation grade
## 
## 

library(tidyverse)
library(tidyjson)
library(foreach)
source("grades/secrets.R") 


# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/AdamWilsonLabEDU/repos?per_page=1000", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
d = jsonlite::fromJSON(jsonlite::toJSON(json1))%>%
  select(-c(`owner`, `mirror_url`, `license`, `permissions`))%>%
  select(c(`full_name`, `html_url`, `forks_url`, `collaborators_url`,`commits_url`,`pulls_url`,`pushed_at`,`homepage`,`size`,`forks_count`))%>%
  as.tibble()%>%
  mutate(type=ifelse(grepl("finalproject",full_name),
                     "final_project","class"),
         user=gsub("AdamWilsonLabEDU/geo503-2018-","",gsub("finalproject-","",full_name)))

class=d%>%
  filter(type=="class")

project=d%>%
  filter(type=="final_project")


# copy repository structure repo somewhere
setwd("~/Documents/Work/courses/201809/GEO511/repos/")
i=1
#system(paste("git remote add -f",class$user[i]," ",class$html_url[i]))
#system("git remote update")
#system(paste0("git diff master remotes/",class$user[i],"/master"))
#system(paste("git remote rm ",class$user[i]))

# check out repository diffs, one by one
if(F){
for(i in 1:nrow(class))
  system(paste0("meld SpatialDataScience_Structure GEO503-2018-12-07-2018-10-23-37/",class$user[i]," &"))
}

# get class contents
class_summary <- foreach(i=1:nrow(class)) %do% {
  content <- GET("https://api.github.com/repos/AdamWilsonLabEDU/geo503-2018-acerpovicz/contents/week_04/case_study", gtoken)%>%
  content()%>%toJSON()%>%fromJSON()%>%
    select(name,path)%>%filter(name!="README.md")%>%
      mutate(user=class$user[i])
  }



# summarize pull requests?
# get class contents
  repo_url="https://api.github.com/repos/AdamWilsonLabEDU/geo503-2018-finalproject-acerpovicz"
  repo_url=project$pulls_url[3]
  
  fpull=function(repo_url){

    print(repo_url)
    pull_requests <- GET(paste0(gsub("\\{\\/number\\}","",repo_url)), gtoken)%>%
    content()%>%toJSON()%>%fromJSON()
    if(length(pull_requests)==0) return(NA)
    
  comments_url=pull_requests$review_comments_url
  pull_comments=
    lapply(comments_url,FUN=function(j){
      pull_comments <- GET(j[[1]], gtoken)%>%
    content()%>%toJSON()%>%fromJSON()
    unlist(pull_comments$body)
  })

  results=data.frame(
    reviewed=gsub("^.*project-","",gsub("\\/p.*$","",repo_url)),
    reviewer=unlist(pull_requests$user$login),
    description=paste(unlist(pull_requests$body)),
    comment=unlist(lapply(pull_comments,FUN=paste,collapse=";")),
    comment_count=unlist(lapply(pull_comments,FUN=length)),stringsAsFactors = F)%>%    
    mutate(
      description_words=lengths(strsplit(description, "\\W+")),
      comments_words=lengths(strsplit(comment, "\\W+")),
      total_words=description_words)%>%
      select(-description_words,-comments_words)
  
  return(results)
  }

  # get and 
  review=do.call(rbind.data.frame,lapply(project$pulls_url,FUN=fpull))
  
  review%>%
    group_by(reviewer)%>%
      summarize(pull_requests=n(),comments=sum(comment_count),words=sum(total_words))
  
  
  filter(review,reviewer=="acerpovicz")
  