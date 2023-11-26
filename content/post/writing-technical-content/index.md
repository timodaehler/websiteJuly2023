---
date: "2019-07-12"
image:
  caption: 'Image credit: [**John Moeses Bauan**](https://unsplash.com/photos/OGZtQF8iC0g)'
  placement: 2
math: true
title: Das ist der Titel
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


<br>

<button onclick="toggleFullscreen(&#39;iframe1&#39;)" style="font-size: 14px; padding: 5px 15px; border: none; border-radius: 20px; background-color: #1664c0; color: white; cursor: pointer; transition: background-color 0.3s;" onmouseover="this.style.backgroundColor=&#39;#0056b3&#39;" onmouseout="this.style.backgroundColor=&#39;#007BFF&#39;">
Open in Fullscreen
</button>
<iframe id="iframe1" src="USFederalDeficit1.html" width="100%" height="600px" frameborder="0">
</iframe>






