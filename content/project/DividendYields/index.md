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
summary: Dividend Yields for the US and Swiss Equity Markets
tags:
- MARKETS
title: Dividend Yields
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

Featured below are some Dividend yields

### SPI Dividend Yield

<br>

<button onclick="toggleFullscreen(&#39;iframe1&#39;)" style="font-size: 14px; padding: 5px 15px; border: none; border-radius: 20px; background-color: #1664c0; color: white; cursor: pointer; transition: background-color 0.3s;" onmouseover="this.style.backgroundColor=&#39;#0056b3&#39;" onmouseout="this.style.backgroundColor=&#39;#007BFF&#39;">
Open in Fullscreen
</button>
<iframe id="iframe1" src="DividendYields1.html" width="100%" height="600px" frameborder="0">
</iframe>

<br> <br> Last update: 2023-11-19 13:16:11 CET

#### Data Sources:

- Dividends:
  [UBS](https://www.ubs.com/ch/en/assetmanagement/funds/etf/ch0130595124-ubs-etf-ch-spi-mid-pd001.html#Holdings)
- Prices: [Yahoo
  Finance](https://finance.yahoo.com/quote/SPMCHA.SW?p=SPMCHA.SW&.tsrc=fin-srch)

------------------------------------------------------------------------

### S&P500 Dividend Yield

<br>

<button onclick="toggleFullscreen(&#39;iframe2&#39;)" style="font-size: 14px; padding: 5px 15px; border: none; border-radius: 20px; background-color: #1664c0; color: white; cursor: pointer; transition: background-color 0.3s;" onmouseover="this.style.backgroundColor=&#39;#0056b3&#39;" onmouseout="this.style.backgroundColor=&#39;#007BFF&#39;">
Open in Fullscreen
</button>
<iframe id="iframe2" src="DividendYields2.html" width="100%" height="600px" frameborder="0">
</iframe>

<br> <br> Last update: 2023-11-19 13:16:13 CET

#### Data Sources:

- Dividend Yields: [Nasdaq Data
  Link](https://data.nasdaq.com/data/MULTPL/SP500_DIV_YIELD_MONTH-sp-500-dividend-yield-by-month)
