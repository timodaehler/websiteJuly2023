---
date: "2023-08-31T00:00:00Z"
external_link: ""
image: 
  caption: Photo by rawpixel on Unsplash
  focal_point: Smart
links:
# - icon: twitter
#   icon_pack: fab
#   name: Follow
#   url: https://twitter.com/georgecushen
# slides: example
summary: Buffett Indicators for the US and Switzerland
tags:
- MARKETS
title: Buffett Indicators
url_code: ""
url_pdf: ""
url_slides: ""
url_video: ""
---

<!-- {{< load-plotly >}} -->
<!-- Load Plotly JavaScript library -->
<script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
<!-- Add the toggle fullscreen function -->
<script>
    function toggleFullscreen(iframeId) {
        let iframe = document.getElementById(iframeId);
        if (iframe.requestFullscreen) {
            iframe.requestFullscreen();
        } else if (iframe.mozRequestFullScreen) { /* Firefox */
            iframe.mozRequestFullScreen();
        } else if (iframe.webkitRequestFullscreen) { /* Chrome, Safari & Opera */
            iframe.webkitRequestFullscreen();
        } else if (iframe.msRequestFullscreen) { /* IE/Edge */
            iframe.msRequestFullscreen();
        }
    }
</script>

Featured below are some Buffett Indicators

### Swiss Buffett Indicator

<br>

<button onclick="toggleFullscreen(&#39;iframe1&#39;)" style="font-size: 14px; padding: 5px 15px; border: none; border-radius: 20px; background-color: #1664c0; color: white; cursor: pointer; transition: background-color 0.3s;" onmouseover="this.style.backgroundColor=&#39;#0056b3&#39;" onmouseout="this.style.backgroundColor=&#39;#007BFF&#39;">
Open in Fullscreen
</button>
<iframe id="iframe1" src="BuffettIndicators1.html" width="100%" height="600px" frameborder="0">
</iframe>

<br> <br> Last update: 2024-07-14 18:01:43 CET

#### Data Sources:

- SPI Market Cap: [Yahoo Finance](https://finance.yahoo.com)
- SPI: [SNB](https://data.snb.ch/api/cube/capchstocki/data/csv/de)
- GDP: [World
  Bank](https://data.worldbank.org/indicator/NY.GDP.MKTP.CD.)

------------------------------------------------------------------------

### US Buffett Indicator

<br>

<button onclick="toggleFullscreen(&#39;iframe2&#39;)" style="font-size: 14px; padding: 5px 15px; border: none; border-radius: 20px; background-color: #1664c0; color: white; cursor: pointer; transition: background-color 0.3s;" onmouseover="this.style.backgroundColor=&#39;#0056b3&#39;" onmouseout="this.style.backgroundColor=&#39;#007BFF&#39;">
Open in Fullscreen
</button>
<iframe id="iframe2" src="BuffettIndicators2.html" width="100%" height="600px" frameborder="0">
</iframe>

<br> <br> Last update: 2024-03-09 21:33:49 CET

#### Data Sources:

- Wilshire 5000 Market Cap: [Federal Reserve Bank of
  St. Louis](https://fred.stlouisfed.org/series/WILL5000PR)
- GDP: [Federal Reserve Bank of
  St. Louis](https://fred.stlouisfed.org/series/GDP)
