---
# @Timo: In diesem Skript kann ich auswählen, welche Teile der Website angezeigt werden und welche nicht

date: "2022-10-24"
sections:

- block: about.biography
  content:
    title: Grüezi & Welcome
    username: admin
  id: about

- block: portfolio
  content:
    buttons:
    - name: All
      tag: '*'
    - name: MACRO
      tag: MACRO
    - name: MARKETS
      tag: MARKETS
    - name: FX
      tag: FX
    default_button_index: 0
    filters:
      folders:
      - project
    title: Financial Charts
  design:
    columns: "1"
    flip_alt_rows: false
    view: showcase
  id: FinancialCharts
  
  
  
# - block: collection
#   content:
#     count: 5
#     filters:
#       author: ""
#       category: ""
#       exclude_featured: false
#       exclude_future: false
#       exclude_past: false
#       folders:
#       - post
#       publication_type: ""
#       tag: ""
#     offset: 0
#     order: desc
#     subtitle: ""
#     text: ""
#     title: Recent Posts
#   design:
#     columns: "2"
#     view: compact
#   id: posts
  
  
  
- block: experience
  content:
    date_format: Jan 2006
    items:
    - company: Raiffeisen Switzerland
      company_logo: 
      company_url: ""
      date_start: '2022-10-01'
      date_end: ''
      location: Zurich, Switzerland
      title: Quantitative Analyst 
    - company: KPMG Switzerland
      company_logo: 
      company_url: ""
      date_start: '2021-10-01'
      date_end: '2022-09-30'
      location: Zurich, Switzerland
      title: Consultant in Financial Services Risk Consulting
    - company: University of Southern California
      company_logo: org-usc-color
      company_url: ""
      date_start: '2018-01-01'
      date_end: '2021-08-01'
      description: |2-
          Dissertation:
          * Essays on Sovereign Debt
          * Committee: Joshua Aizenman, Saori Katada, Pablo Barberá & Jeff Nugent  
  
          Teaching:
          * Intermediate Macroeconomics
          * Introduction to Macroeconomics
          * International Economics
      location: Los Angeles, CA
      title: PhD in International Political Economy
      
    - company: University of Southern California
      company_url: ''
      company_logo: org-usc-color
      location: Los Angeles, CA
      date_start: '2016-08-01'
      date_end: '2017-12-31'
      title: MA in Economics
      
    - company: UBS
      company_logo: 
      company_url: ""
      date_start: '2015-06-01'
      date_end: '2015-12-30'
      location: Zurich, Switzerland
      title: Analyst Intern in CIO EM FX & FIXED INCOME
      
    - company: Harvard University
      company_logo: org-harvard
      company_url: ""
      date_start: '2015-01-01'
      date_end: '2015-05-30'
      location: Cambridge, MA
      title: Visiting Undergraduate Student
      
    - company: TCW
      company_logo: 
      company_url: ""
      date_start: '2013-07-01'
      date_end: '2013-09-30'
      location: New York, NY
      title: Equity Analyst Intern
      
    - title: BA in Economics
      company: University of St. Gallen
      company_url: ''
      company_logo: org-hsg-color
      location: St. Gallen, Switzerland
      date_start: '2011-09-01'
      date_end: '2014-12-30'
      description: 
    title: Experience
  design:
    columns: "2"
  id: experience
  
  

# - block: accomplishments
#   content:
#     date_format: Jan 2006
#     items:
#     - certificate_url: https://www.coursera.org
#       date_end: ""
#       date_start: "2021-01-25"
#       description: ""
#       organization: Coursera
#       organization_url: https://www.coursera.org
#       title: Neural Networks and Deep Learning
#       url: ""
#     - certificate_url: https://www.edx.org
#       date_end: ""
#       date_start: "2021-01-01"
#       description: Formulated informed blockchain models, hypotheses, and use cases.
#       organization: edX
#       organization_url: https://www.edx.org
#       title: Blockchain Fundamentals
#       url: https://www.edx.org/professional-certificate/uc-berkeleyx-blockchain-fundamentals
#     - certificate_url: https://www.datacamp.com
#       date_end: "2020-12-21"
#       date_start: "2020-07-01"
#       description: ""
#       organization: DataCamp
#       organization_url: https://www.datacamp.com
#       title: Object-Oriented Programming in R
#       url: ""
#     subtitle: null
#     title: Accomplish&shy;ments
#   design:
#     columns: "2"


  
# - block: markdown
#   content:
#     subtitle: ""
#     text: '{{< gallery album="demo" >}}'
#     title: Gallery
#   design:
#     columns: "1"


# - block: markdown
#   content:
#     subtitle: "Exchange Rates"
#     text: |
#       <div style="display: flex; flex-wrap: wrap; justify-content: space-between;">
#         <div style="width: 48%; margin-bottom: 20px;">
#           <iframe src="/uploads/myplot3.html" width="100%" height="600px" frameborder="0"></iframe>
#         </div>
#         <div style="width: 48%; margin-bottom: 20px;">
#           <iframe src="/uploads/myplot3.html" width="100%" height="600px" frameborder="0"></iframe>
#         </div>
#         <div style="width: 48%; margin-bottom: 20px;">
#           <iframe src="/uploads/myplot3.html" width="100%" height="600px" frameborder="0"></iframe>
#         </div>
#         <div style="width: 48%; margin-bottom: 20px;">
#           <iframe src="/uploads/myplot3.html" width="100%" height="600px" frameborder="0"></iframe>
#         </div>
#       </div>
#     title: "Latest Exchange Rates Against Swiss Franc (Shown Four Times)"
#   design:
#     columns: "1"



# - block: markdown
#   content:
#     subtitle: "Exchange Rates"
#     text: |
#       <div style="display: flex; flex-wrap: wrap; justify-content: space-between;">
#         <div style="width: 48%; margin-bottom: 20px;">
#           <iframe src="/uploads/myplot3.html" width="100%" height="600px" frameborder="0"></iframe>
#         </div>
#       </div>
#     title: "Latest Exchange Rates Against Swiss Franc (Shown Four Times)"
#   design:
#     columns: "1"



    
# - block: collection
#   content:
#     filters:
#       featured_only: true
#       folders:
#       - publication
#     title: Featured Publications
#   design:
#     columns: "2"
#     view: card
#   id: featured

# - block: collection
#   content:
#     filters:
#       exclude_featured: true
#       folders:
#       - publication
#     text: |-
#       {{% callout note %}}
#       Quickly discover relevant content by [filtering publications](./publication/).
#       {{% /callout %}}
#     title: Recent Publications
#   design:
#     columns: "2"
#     view: citation

# - block: collection
#   content:
#     filters:
#       folders:
#       - event
#     title: Recent & Upcoming Talks
#   design:
#     columns: "2"
#     view: compact
#   id: talks
    
# - block: contact
#   content:
#     address:
#       city: Stanford
#       country: United States
#       country_code: US
#       postcode: "94305"
#       region: CA
#       street: 450 Serra Mall
#     appointment_url: https://calendly.com
#     autolink: true
#     contact_links:
#     - icon: twitter
#       icon_pack: fab
#       link: https://twitter.com/Twitter
#       name: DM Me
#     - icon: skype
#       icon_pack: fab
#       link: skype:echo123?call
#       name: Skype Me
#     - icon: video
#       icon_pack: fas
#       link: https://zoom.com
#       name: Zoom Me
#     directions: Enter Building 1 and take the stairs to Office 200 on Floor 2
#     email: test@example.org
#     form:
#       formspree:
#         id: null
#       netlify:
#         captcha: false
#       provider: netlify
#     office_hours:
#     - Monday 10:00 to 13:00
#     - Wednesday 09:00 to 10:00
#     phone: 888 888 88 88
#     subtitle: null
#     text: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam mi diam, venenatis
#       ut magna et, vehicula efficitur enim.
#     title: Contact
#   design:
#     columns: "2"
#   id: contact

# - block: hero
#   content:
#     cta:
#       label: '**Get Started**'
#       url: https://wowchemy.com/templates/
#     cta_alt:
#       label: Ask a question
#       url: https://discord.gg/z8wNYzb
#     cta_note:
#       label: '<div style="text-shadow: none;"><a class="github-button" href="https://github.com/wowchemy/wowchemy-hugo-themes"
#         data-icon="octicon-star" data-size="large" data-show-count="true" aria-label="Star">Star
#         Wowchemy Website Builder</a></div><div style="text-shadow: none;"><a class="github-button"
#         href="https://github.com/wowchemy/starter-hugo-academic" data-icon="octicon-star"
#         data-size="large" data-show-count="true" aria-label="Star">Star the Academic
#         template</a></div>'
#     image:
#       filename: hero-academic.png
#     text: |-
#       **Generated by Wowchemy - the FREE, Hugo-based open source website builder trusted by 500,000+ sites.**
# 
#       **Easily build anything with blocks - no-code required!**
# 
#       From landing pages, second brains, and courses to academic resumés, conferences, and tech blogs.
# 
#       <!--Custom spacing-->
#       <div class="mb-3"></div>
#       <!--GitHub Button JS-->
#       <script async defer src="https://buttons.github.io/buttons.js"></script>
#     title: Hugo Academic Theme
#   design:
#     background:
#       gradient_end: '#1976d2'
#       gradient_start: '#004ba0'
#       text_color_light: true
# - block: about.biography
#   content:
#     title: Biography
#     username: admin
#   id: about

# - block: features
#   content:
#     items:
#     - description: 90%
#       icon: r-project
#       icon_pack: fab
#       name: R
#     - description: 100%
#       icon: chart-line
#       icon_pack: fas
#       name: Statistics
#     - description: 10%
#       icon: camera-retro
#       icon_pack: fas
#       name: Photography
#     title: Skills




# - block: markdown
#   content:
#     subtitle: "Global Stock Indices Performance"
#     text: |
#     
#       <div style="display: flex; flex-wrap: wrap; justify-content: space-between;">
#         <div style="width: 100%; margin-bottom: 20px;">
#           <iframe src="/uploads/my_map.html" width="100%" height="600px" frameborder="0"></iframe>
#         </div>
#       </div>
#     
# 
#     title: "Performance of Various Global Stock Indices"
#   design:
#     columns: "1"
#     
#         #   <div style="display: flex; flex-wrap: wrap; justify-content: space-between;">
#         # <div style="width: 100%; margin-bottom: 20px;">
#         #   <iframe src="/uploads/current_index_performances.html" width="100%" height="600px" frameborder="0"></iframe>
#         # </div>

    


# - block: tag_cloud
#   content:
#     title: Popular Topics
#   design:
#     columns: "2"
    


title: null
type: landing
---
