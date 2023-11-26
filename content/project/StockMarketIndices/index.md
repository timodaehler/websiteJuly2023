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
summary: Standardized Index Values of Major Stock Market Indices
tags:
- MARKETS
title: Stock Markets
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

Featured below are the indeces of major stock marekts around the world.

### Equity Indices (Normalized 2007-01-04 = 100%)

<br>

<button onclick="toggleFullscreen(&#39;iframe1&#39;)" style="font-size: 14px; padding: 5px 15px; border: none; border-radius: 20px; background-color: #1664c0; color: white; cursor: pointer; transition: background-color 0.3s;" onmouseover="this.style.backgroundColor=&#39;#0056b3&#39;" onmouseout="this.style.backgroundColor=&#39;#007BFF&#39;">
Open in Fullscreen
</button>
<iframe id="iframe1" src="StockMarketIndices1.html" width="100%" height="600px" frameborder="0">
</iframe>

<br> <br> Last update: 2023-11-26 20:35:10 CET

#### Data Sources:

- Stock Market Indices: [Yahoo Finance](https://finance.yahoo.com)

------------------------------------------------------------------------

### Equity Indices

<br>

<button onclick="toggleFullscreen(&#39;iframe2&#39;)" style="font-size: 14px; padding: 5px 15px; border: none; border-radius: 20px; background-color: #1664c0; color: white; cursor: pointer; transition: background-color 0.3s;" onmouseover="this.style.backgroundColor=&#39;#0056b3&#39;" onmouseout="this.style.backgroundColor=&#39;#007BFF&#39;">
Open in Fullscreen
</button>
<iframe id="iframe2" src="StockMarketIndices2.html" width="100%" height="600px" frameborder="0">
</iframe>

<br> <br> Last update: 2023-11-26 20:35:12 CET

#### Data Sources:

- Stock Market Indices: [Yahoo Finance](https://finance.yahoo.com)
