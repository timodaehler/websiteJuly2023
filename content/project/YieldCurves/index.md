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
summary: Yield curve for the US and Switzerland
tags:
- MARKETS
title: Yields
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

Featured below are some yields

### Swiss Yield Curve

<br>

<button onclick="toggleFullscreen(&#39;iframe1&#39;)" style="font-size: 14px; padding: 5px 15px; border: none; border-radius: 20px; background-color: #1664c0; color: white; cursor: pointer; transition: background-color 0.3s;" onmouseover="this.style.backgroundColor=&#39;#0056b3&#39;" onmouseout="this.style.backgroundColor=&#39;#007BFF&#39;">
Open in Fullscreen
</button>
<iframe id="iframe1" src="plot_3d_Swiss_yield_curve.html" width="100%" height="600px" frameborder="0">
</iframe>

<br>

<button onclick="toggleFullscreen(&#39;iframe2&#39;)" style="font-size: 14px; padding: 5px 15px; border: none; border-radius: 20px; background-color: #1664c0; color: white; cursor: pointer; transition: background-color 0.3s;" onmouseover="this.style.backgroundColor=&#39;#0056b3&#39;" onmouseout="this.style.backgroundColor=&#39;#007BFF&#39;">
Open in Fullscreen
</button>
<iframe id="iframe2" src="plot_simple_Swiss_yield_curve.html" width="100%" height="600px" frameborder="0">
</iframe>

<br> <br> Last update: 2024-02-25 21:10:05 CET

#### Data Sources:

- Yields: [SNB](https://data.snb.ch/api/cube/rendoblid/data/csv/de)

------------------------------------------------------------------------

### US Yield Curve

<br>

<button onclick="toggleFullscreen(&#39;iframe3&#39;)" style="font-size: 14px; padding: 5px 15px; border: none; border-radius: 20px; background-color: #1664c0; color: white; cursor: pointer; transition: background-color 0.3s;" onmouseover="this.style.backgroundColor=&#39;#0056b3&#39;" onmouseout="this.style.backgroundColor=&#39;#007BFF&#39;">
Open in Fullscreen
</button>
<iframe id="iframe3" src="plot_3d_US_yield_curve.html" width="100%" height="600px" frameborder="0">
</iframe>

<br>

<button onclick="toggleFullscreen(&#39;iframe4&#39;)" style="font-size: 14px; padding: 5px 15px; border: none; border-radius: 20px; background-color: #1664c0; color: white; cursor: pointer; transition: background-color 0.3s;" onmouseover="this.style.backgroundColor=&#39;#0056b3&#39;" onmouseout="this.style.backgroundColor=&#39;#007BFF&#39;">
Open in Fullscreen
</button>
<iframe id="iframe4" src="plot_simple_US_yield_curve.html" width="100%" height="600px" frameborder="0">
</iframe>

<br> <br> Last update: 2024-02-25 21:10:09 CET

#### Data Sources:

- Yields: [Federal Reserve Bank of
  St. Louis](https://fred.stlouisfed.org/searchresults/?st=Market%20Yield%20on%20U.S.%20Treasury%20Securities)
