---
date: "2023-08-01T00:00:00Z"
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
summary: FX Rates vis-a-vis major trading partners
tags:
- FX
title: FX Rates
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

Featured below is the value of one Swiss Franc in the foreign currencies
of major trading partners.

### Market FX Rates vs PPP-implied FX Rates

<br>

<button onclick="toggleFullscreen(&#39;iframe1&#39;)" style="font-size: 14px; padding: 5px 15px; border: none; border-radius: 20px; background-color: #1664c0; color: white; cursor: pointer; transition: background-color 0.3s;" onmouseover="this.style.backgroundColor=&#39;#0056b3&#39;" onmouseout="this.style.backgroundColor=&#39;#007BFF&#39;">
Open in Fullscreen
</button>
<iframe id="iframe1" src="PPPvsMarketFXRate1.html" width="100%" height="600px" frameborder="0">
</iframe>

<br> <br> Last update: 2024-07-14 18:18:16 CET

#### Data Sources:

- Exchange Rates: [Yahoo Finance](https://finance.yahoo.com/)
- PPP Conversion Factors: [World
  Bank](https://data.worldbank.org/indicator/PA.NUS.PPP)

------------------------------------------------------------------------

### Deviation of Market FX Rates from PPP-implied FX Rates

<br>

<button onclick="toggleFullscreen(&#39;iframe2&#39;)" style="font-size: 14px; padding: 5px 15px; border: none; border-radius: 20px; background-color: #1664c0; color: white; cursor: pointer; transition: background-color 0.3s;" onmouseover="this.style.backgroundColor=&#39;#0056b3&#39;" onmouseout="this.style.backgroundColor=&#39;#007BFF&#39;">
Open in Fullscreen
</button>
<iframe id="iframe2" src="PPPvsMarketFXRate2.html" width="100%" height="600px" frameborder="0">
</iframe>

<br> <br> Last update: 2024-07-14 18:18:23 CET

#### Data Sources:

- Exchange Rates: [Yahoo Finance](https://finance.yahoo.com/)
- PPP Conversion Factors: [World
  Bank](https://data.worldbank.org/indicator/PA.NUS.PPP)
