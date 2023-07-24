library(devtools)
library(blogdown)

blogdown::install_hugo() 
# Die Version wird später noch wichtig sein: 
# The latest Hugo version is v0.115.4 

# Jetzt gehen wir auf https://themes.gohugo.io 
# # Wir wollen ein Theme dass kürzlich geupdated wurde 
# # Ich habe mich für das Academic Theme entschieden 
# 
blogdown::new_site(theme = "wowchemy/starter-hugo-academic") 
# Jetzt wird die Website erstellt und alle Ordner werden 
# heruntergeladen 
# 
# Converting all metadata to the YAML format 
# Adding netlify.toml in case you want to deploy the site to Netlify 
# | Adding .Rprofile to set options() for blogdown