---
title: "Dynamic Visualization"
---




[<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> The R Script associated with this page is available here](scripts/12_DynamicVisualization.R).  Download this file and open it (or copy-paste into a new script) with RStudio so you can follow along.  

# Introduction

In this module we will explore several ways to generate dynamic and interactive data displays.  These include making maps and graphs that you can pan/zoom, select features for more information, and interact with in other ways.  The most common output format is HTML, which can easily be embedded in a website (such as your final project!).


```r
library(dplyr)
library(ggplot2)
library(ggmap)
library(htmlwidgets)
library(widgetframe)
```

If you don't have the packages above, install them in the package manager or by running `install.packages("doParallel")`. 

# DataTables

[DataTables](http://rstudio.github.io/DT/) display R data frames as interactive HTML tables (with filtering, pagination, sorting, and search).  This is a great way to make your raw data browsable without using too much space.


```r
library(DT)
datatable(iris, options = list(pageLength = 5))
```

<!--html_preserve--><div id="htmlwidget-e907524724b8692d9096" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-e907524724b8692d9096">{"x":{"filter":"none","data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","119","120","121","122","123","124","125","126","127","128","129","130","131","132","133","134","135","136","137","138","139","140","141","142","143","144","145","146","147","148","149","150"],[5.1,4.9,4.7,4.6,5,5.4,4.6,5,4.4,4.9,5.4,4.8,4.8,4.3,5.8,5.7,5.4,5.1,5.7,5.1,5.4,5.1,4.6,5.1,4.8,5,5,5.2,5.2,4.7,4.8,5.4,5.2,5.5,4.9,5,5.5,4.9,4.4,5.1,5,4.5,4.4,5,5.1,4.8,5.1,4.6,5.3,5,7,6.4,6.9,5.5,6.5,5.7,6.3,4.9,6.6,5.2,5,5.9,6,6.1,5.6,6.7,5.6,5.8,6.2,5.6,5.9,6.1,6.3,6.1,6.4,6.6,6.8,6.7,6,5.7,5.5,5.5,5.8,6,5.4,6,6.7,6.3,5.6,5.5,5.5,6.1,5.8,5,5.6,5.7,5.7,6.2,5.1,5.7,6.3,5.8,7.1,6.3,6.5,7.6,4.9,7.3,6.7,7.2,6.5,6.4,6.8,5.7,5.8,6.4,6.5,7.7,7.7,6,6.9,5.6,7.7,6.3,6.7,7.2,6.2,6.1,6.4,7.2,7.4,7.9,6.4,6.3,6.1,7.7,6.3,6.4,6,6.9,6.7,6.9,5.8,6.8,6.7,6.7,6.3,6.5,6.2,5.9],[3.5,3,3.2,3.1,3.6,3.9,3.4,3.4,2.9,3.1,3.7,3.4,3,3,4,4.4,3.9,3.5,3.8,3.8,3.4,3.7,3.6,3.3,3.4,3,3.4,3.5,3.4,3.2,3.1,3.4,4.1,4.2,3.1,3.2,3.5,3.6,3,3.4,3.5,2.3,3.2,3.5,3.8,3,3.8,3.2,3.7,3.3,3.2,3.2,3.1,2.3,2.8,2.8,3.3,2.4,2.9,2.7,2,3,2.2,2.9,2.9,3.1,3,2.7,2.2,2.5,3.2,2.8,2.5,2.8,2.9,3,2.8,3,2.9,2.6,2.4,2.4,2.7,2.7,3,3.4,3.1,2.3,3,2.5,2.6,3,2.6,2.3,2.7,3,2.9,2.9,2.5,2.8,3.3,2.7,3,2.9,3,3,2.5,2.9,2.5,3.6,3.2,2.7,3,2.5,2.8,3.2,3,3.8,2.6,2.2,3.2,2.8,2.8,2.7,3.3,3.2,2.8,3,2.8,3,2.8,3.8,2.8,2.8,2.6,3,3.4,3.1,3,3.1,3.1,3.1,2.7,3.2,3.3,3,2.5,3,3.4,3],[1.4,1.4,1.3,1.5,1.4,1.7,1.4,1.5,1.4,1.5,1.5,1.6,1.4,1.1,1.2,1.5,1.3,1.4,1.7,1.5,1.7,1.5,1,1.7,1.9,1.6,1.6,1.5,1.4,1.6,1.6,1.5,1.5,1.4,1.5,1.2,1.3,1.4,1.3,1.5,1.3,1.3,1.3,1.6,1.9,1.4,1.6,1.4,1.5,1.4,4.7,4.5,4.9,4,4.6,4.5,4.7,3.3,4.6,3.9,3.5,4.2,4,4.7,3.6,4.4,4.5,4.1,4.5,3.9,4.8,4,4.9,4.7,4.3,4.4,4.8,5,4.5,3.5,3.8,3.7,3.9,5.1,4.5,4.5,4.7,4.4,4.1,4,4.4,4.6,4,3.3,4.2,4.2,4.2,4.3,3,4.1,6,5.1,5.9,5.6,5.8,6.6,4.5,6.3,5.8,6.1,5.1,5.3,5.5,5,5.1,5.3,5.5,6.7,6.9,5,5.7,4.9,6.7,4.9,5.7,6,4.8,4.9,5.6,5.8,6.1,6.4,5.6,5.1,5.6,6.1,5.6,5.5,4.8,5.4,5.6,5.1,5.1,5.9,5.7,5.2,5,5.2,5.4,5.1],[0.2,0.2,0.2,0.2,0.2,0.4,0.3,0.2,0.2,0.1,0.2,0.2,0.1,0.1,0.2,0.4,0.4,0.3,0.3,0.3,0.2,0.4,0.2,0.5,0.2,0.2,0.4,0.2,0.2,0.2,0.2,0.4,0.1,0.2,0.2,0.2,0.2,0.1,0.2,0.2,0.3,0.3,0.2,0.6,0.4,0.3,0.2,0.2,0.2,0.2,1.4,1.5,1.5,1.3,1.5,1.3,1.6,1,1.3,1.4,1,1.5,1,1.4,1.3,1.4,1.5,1,1.5,1.1,1.8,1.3,1.5,1.2,1.3,1.4,1.4,1.7,1.5,1,1.1,1,1.2,1.6,1.5,1.6,1.5,1.3,1.3,1.3,1.2,1.4,1.2,1,1.3,1.2,1.3,1.3,1.1,1.3,2.5,1.9,2.1,1.8,2.2,2.1,1.7,1.8,1.8,2.5,2,1.9,2.1,2,2.4,2.3,1.8,2.2,2.3,1.5,2.3,2,2,1.8,2.1,1.8,1.8,1.8,2.1,1.6,1.9,2,2.2,1.5,1.4,2.3,2.4,1.8,1.8,2.1,2.4,2.3,1.9,2.3,2.5,2.3,1.9,2,2.3,1.8],["setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>Sepal.Length<\/th>\n      <th>Sepal.Width<\/th>\n      <th>Petal.Length<\/th>\n      <th>Petal.Width<\/th>\n      <th>Species<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":5,"columnDefs":[{"className":"dt-right","targets":[1,2,3,4]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false,"lengthMenu":[5,10,25,50,100]},"selection":{"mode":"multiple","selected":null,"target":"row"}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

# rbokeh

Interface to the [Bokeh](http://hafen.github.io/rbokeh) library for making interactive graphics.


```r
library(rbokeh)
figure(width = 400, height=400) %>%
  ly_points(Sepal.Length, Sepal.Width, data = iris,
    color = Species, glyph = Species,
    hover = list(Sepal.Length, Sepal.Width))
```

<!--html_preserve--><div id="htmlwidget-5df978fd3f7ccaf1fe9e" style="width:400px;height:400px;" class="rbokeh html-widget"></div>
<script type="application/json" data-for="htmlwidget-5df978fd3f7ccaf1fe9e">{"x":{"elementid":"da7ba1810f5833d8ce48f210d936edec","modeltype":"Plot","modelid":"6e2445197878a52fcf46ea1afd04b546","docid":"df111eb2bc6e1a78c7f015fedf4f158d","docs_json":{"df111eb2bc6e1a78c7f015fedf4f158d":{"version":"0.12.2","title":"Bokeh Figure","roots":{"root_ids":["6e2445197878a52fcf46ea1afd04b546"],"references":[{"type":"Plot","id":"6e2445197878a52fcf46ea1afd04b546","attributes":{"id":"6e2445197878a52fcf46ea1afd04b546","plot_width":400,"plot_height":400,"sizing_mode":"scale_both","x_range":{"type":"Range1d","id":"948ada425c8019e8a2cf2c27f0b53b4a"},"y_range":{"type":"Range1d","id":"c7517c10066408ddf16c29b4522ccf1b"},"left":[{"type":"LinearAxis","id":"afdbf1a689b020f61498454449615074"}],"below":[{"type":"LinearAxis","id":"00a7e71f34f0a42ccb3b6fa81a584214"}],"right":[],"above":[],"renderers":[{"type":"BoxAnnotation","id":"10257aa14f289b86c1b8e1050a248520"},{"type":"GlyphRenderer","id":"4b24f7b0ffc47181f90234557c7ff7d6"},{"type":"GlyphRenderer","id":"db7844fda417b6ed9f222213c2e4af84"},{"type":"GlyphRenderer","id":"5f63198e21ef0041718bc349c2b70553"},{"type":"GlyphRenderer","id":"78ff104c512d026b7ab0259e6bf57848"},{"type":"GlyphRenderer","id":"74b15a97032f6786a1d9d679e63f9f5c"},{"type":"GlyphRenderer","id":"0f68b5736be473e5d13d03c5d4a1e08d"},{"type":"Legend","id":"1db855fb2ba38e69d65e1e1afc6d29e3"},{"type":"LinearAxis","id":"00a7e71f34f0a42ccb3b6fa81a584214"},{"type":"Grid","id":"f42e0c974ef7c1392fa15bd28fccdec3"},{"type":"LinearAxis","id":"afdbf1a689b020f61498454449615074"},{"type":"Grid","id":"0022f330173ffb5a4d66459d9c50c182"}],"extra_y_ranges":{},"extra_x_ranges":{},"tags":[],"min_border_left":4,"min_border_right":4,"min_border_top":4,"min_border_bottom":4,"lod_threshold":null,"toolbar":{"type":"Toolbar","id":"6263733484d6164a6ec9f3abe825f819"},"tool_events":{"type":"ToolEvents","id":"b95b17613e7fb54550de31688d5f74a4"}},"subtype":"Figure"},{"type":"Toolbar","id":"6263733484d6164a6ec9f3abe825f819","attributes":{"id":"6263733484d6164a6ec9f3abe825f819","tags":[],"active_drag":"auto","active_scroll":"auto","active_tap":"auto","tools":[{"type":"PanTool","id":"1b156595b85e734281782d6e21620baf"},{"type":"WheelZoomTool","id":"f4fc8744e63c280590cf877c196e4a65"},{"type":"BoxZoomTool","id":"302695f7b11ee19f2c3f35f1bfbe06c2"},{"type":"ResetTool","id":"d864ba586b1a2e7bf3dfd6c96f5d6f89"},{"type":"SaveTool","id":"17ace6d0a135227343bfa26d0b6bbec5"},{"type":"HelpTool","id":"2108bf2909a70531af9e824f71f15fde"},{"type":"HoverTool","id":"564ebc34dbdc746f1115aa446826efeb"},{"type":"HoverTool","id":"ac5a8c0946594566c767cc22654bd6b1"},{"type":"HoverTool","id":"1a8410ec33c28de78ac398cb1005ec17"}],"logo":null}},{"type":"PanTool","id":"1b156595b85e734281782d6e21620baf","attributes":{"id":"1b156595b85e734281782d6e21620baf","tags":[],"plot":{"type":"Plot","id":"6e2445197878a52fcf46ea1afd04b546","subtype":"Figure"},"dimensions":["width","height"]}},{"type":"ToolEvents","id":"b95b17613e7fb54550de31688d5f74a4","attributes":{"id":"b95b17613e7fb54550de31688d5f74a4","tags":[]},"geometries":[]},{"type":"WheelZoomTool","id":"f4fc8744e63c280590cf877c196e4a65","attributes":{"id":"f4fc8744e63c280590cf877c196e4a65","tags":[],"plot":{"type":"Plot","id":"6e2445197878a52fcf46ea1afd04b546","subtype":"Figure"},"dimensions":["width","height"]}},{"type":"BoxAnnotation","id":"10257aa14f289b86c1b8e1050a248520","attributes":{"id":"10257aa14f289b86c1b8e1050a248520","tags":[],"line_color":{"units":"data","value":"black"},"line_alpha":{"units":"data","value":1},"fill_color":{"units":"data","value":"lightgrey"},"fill_alpha":{"units":"data","value":0.5},"line_dash":[4,4],"line_width":{"units":"data","value":2},"level":"overlay","top_units":"screen","bottom_units":"screen","left_units":"screen","right_units":"screen","render_mode":"css"}},{"type":"BoxZoomTool","id":"302695f7b11ee19f2c3f35f1bfbe06c2","attributes":{"id":"302695f7b11ee19f2c3f35f1bfbe06c2","tags":[],"plot":{"type":"Plot","id":"6e2445197878a52fcf46ea1afd04b546","subtype":"Figure"},"overlay":{"type":"BoxAnnotation","id":"10257aa14f289b86c1b8e1050a248520"}}},{"type":"ResetTool","id":"d864ba586b1a2e7bf3dfd6c96f5d6f89","attributes":{"id":"d864ba586b1a2e7bf3dfd6c96f5d6f89","tags":[],"plot":{"type":"Plot","id":"6e2445197878a52fcf46ea1afd04b546","subtype":"Figure"}}},{"type":"SaveTool","id":"17ace6d0a135227343bfa26d0b6bbec5","attributes":{"id":"17ace6d0a135227343bfa26d0b6bbec5","tags":[],"plot":{"type":"Plot","id":"6e2445197878a52fcf46ea1afd04b546","subtype":"Figure"}}},{"type":"HelpTool","id":"2108bf2909a70531af9e824f71f15fde","attributes":{"id":"2108bf2909a70531af9e824f71f15fde","tags":[],"plot":{"type":"Plot","id":"6e2445197878a52fcf46ea1afd04b546","subtype":"Figure"},"redirect":"http://hafen.github.io/rbokeh","help_tooltip":"Click to learn more about rbokeh."}},{"type":"HoverTool","id":"564ebc34dbdc746f1115aa446826efeb","attributes":{"id":"564ebc34dbdc746f1115aa446826efeb","tags":[],"plot":{"type":"Plot","id":"6e2445197878a52fcf46ea1afd04b546","subtype":"Figure"},"renderers":[{"type":"GlyphRenderer","id":"4b24f7b0ffc47181f90234557c7ff7d6"}],"names":[],"anchor":"center","attachment":"horizontal","line_policy":"prev","mode":"mouse","point_policy":"snap_to_data","tooltips":[["Sepal.Length","@hover_col_1"],["Sepal.Width","@hover_col_2"]]}},{"type":"ColumnDataSource","id":"b3e0dcedff57409667a0c010962ebc84","attributes":{"id":"b3e0dcedff57409667a0c010962ebc84","tags":[],"column_names":["x","y","line_color","fill_color","hover_col_1","hover_col_2"],"selected":[],"data":{"x":[5.1,4.9,4.7,4.6,5,5.4,4.6,5,4.4,4.9,5.4,4.8,4.8,4.3,5.8,5.7,5.4,5.1,5.7,5.1,5.4,5.1,4.6,5.1,4.8,5,5,5.2,5.2,4.7,4.8,5.4,5.2,5.5,4.9,5,5.5,4.9,4.4,5.1,5,4.5,4.4,5,5.1,4.8,5.1,4.6,5.3,5],"y":[3.5,3,3.2,3.1,3.6,3.9,3.4,3.4,2.9,3.1,3.7,3.4,3,3,4,4.4,3.9,3.5,3.8,3.8,3.4,3.7,3.6,3.3,3.4,3,3.4,3.5,3.4,3.2,3.1,3.4,4.1,4.2,3.1,3.2,3.5,3.6,3,3.4,3.5,2.3,3.2,3.5,3.8,3,3.8,3.2,3.7,3.3],"line_color":["#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4"],"fill_color":["#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4","#1F77B4"],"hover_col_1":["5.1","4.9","4.7","4.6","5.0","5.4","4.6","5.0","4.4","4.9","5.4","4.8","4.8","4.3","5.8","5.7","5.4","5.1","5.7","5.1","5.4","5.1","4.6","5.1","4.8","5.0","5.0","5.2","5.2","4.7","4.8","5.4","5.2","5.5","4.9","5.0","5.5","4.9","4.4","5.1","5.0","4.5","4.4","5.0","5.1","4.8","5.1","4.6","5.3","5.0"],"hover_col_2":["3.5","3.0","3.2","3.1","3.6","3.9","3.4","3.4","2.9","3.1","3.7","3.4","3.0","3.0","4.0","4.4","3.9","3.5","3.8","3.8","3.4","3.7","3.6","3.3","3.4","3.0","3.4","3.5","3.4","3.2","3.1","3.4","4.1","4.2","3.1","3.2","3.5","3.6","3.0","3.4","3.5","2.3","3.2","3.5","3.8","3.0","3.8","3.2","3.7","3.3"]}}},{"type":"Circle","id":"24333af7361d4778b904093206ce6104","attributes":{"id":"24333af7361d4778b904093206ce6104","tags":[],"size":{"units":"screen","value":10},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":0.5},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"},"line_color":{"units":"data","field":"line_color"},"fill_color":{"units":"data","field":"fill_color"}}},{"type":"Circle","id":"2af3906e7a314ff96273ce69c7fc4688","attributes":{"id":"2af3906e7a314ff96273ce69c7fc4688","tags":[],"size":{"units":"screen","value":10},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":0.5},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"},"line_color":{"units":"data","value":"#e1e1e1"},"fill_color":{"units":"data","value":"#e1e1e1"}}},{"type":"Circle","id":"3b55630652bcc4b3abde4f3140009231","attributes":{"id":"3b55630652bcc4b3abde4f3140009231","tags":[],"size":{"units":"screen","value":10},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":1},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"},"line_color":{"units":"data","field":"line_color"},"fill_color":{"units":"data","field":"fill_color"}}},{"type":"GlyphRenderer","id":"4b24f7b0ffc47181f90234557c7ff7d6","attributes":{"id":"4b24f7b0ffc47181f90234557c7ff7d6","tags":[],"selection_glyph":null,"nonselection_glyph":{"type":"Circle","id":"2af3906e7a314ff96273ce69c7fc4688"},"hover_glyph":{"type":"Circle","id":"3b55630652bcc4b3abde4f3140009231"},"name":null,"data_source":{"type":"ColumnDataSource","id":"b3e0dcedff57409667a0c010962ebc84"},"glyph":{"type":"Circle","id":"24333af7361d4778b904093206ce6104"}}},{"type":"HoverTool","id":"ac5a8c0946594566c767cc22654bd6b1","attributes":{"id":"ac5a8c0946594566c767cc22654bd6b1","tags":[],"plot":{"type":"Plot","id":"6e2445197878a52fcf46ea1afd04b546","subtype":"Figure"},"renderers":[{"type":"GlyphRenderer","id":"db7844fda417b6ed9f222213c2e4af84"}],"names":[],"anchor":"center","attachment":"horizontal","line_policy":"prev","mode":"mouse","point_policy":"snap_to_data","tooltips":[["Sepal.Length","@hover_col_1"],["Sepal.Width","@hover_col_2"]]}},{"type":"ColumnDataSource","id":"df24da7e82adc376728612fa8206f92f","attributes":{"id":"df24da7e82adc376728612fa8206f92f","tags":[],"column_names":["x","y","line_color","fill_color","hover_col_1","hover_col_2"],"selected":[],"data":{"x":[7,6.4,6.9,5.5,6.5,5.7,6.3,4.9,6.6,5.2,5,5.9,6,6.1,5.6,6.7,5.6,5.8,6.2,5.6,5.9,6.1,6.3,6.1,6.4,6.6,6.8,6.7,6,5.7,5.5,5.5,5.8,6,5.4,6,6.7,6.3,5.6,5.5,5.5,6.1,5.8,5,5.6,5.7,5.7,6.2,5.1,5.7],"y":[3.2,3.2,3.1,2.3,2.8,2.8,3.3,2.4,2.9,2.7,2,3,2.2,2.9,2.9,3.1,3,2.7,2.2,2.5,3.2,2.8,2.5,2.8,2.9,3,2.8,3,2.9,2.6,2.4,2.4,2.7,2.7,3,3.4,3.1,2.3,3,2.5,2.6,3,2.6,2.3,2.7,3,2.9,2.9,2.5,2.8],"line_color":["#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E"],"fill_color":["#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E","#FF7F0E"],"hover_col_1":["7.0","6.4","6.9","5.5","6.5","5.7","6.3","4.9","6.6","5.2","5.0","5.9","6.0","6.1","5.6","6.7","5.6","5.8","6.2","5.6","5.9","6.1","6.3","6.1","6.4","6.6","6.8","6.7","6.0","5.7","5.5","5.5","5.8","6.0","5.4","6.0","6.7","6.3","5.6","5.5","5.5","6.1","5.8","5.0","5.6","5.7","5.7","6.2","5.1","5.7"],"hover_col_2":["3.2","3.2","3.1","2.3","2.8","2.8","3.3","2.4","2.9","2.7","2.0","3.0","2.2","2.9","2.9","3.1","3.0","2.7","2.2","2.5","3.2","2.8","2.5","2.8","2.9","3.0","2.8","3.0","2.9","2.6","2.4","2.4","2.7","2.7","3.0","3.4","3.1","2.3","3.0","2.5","2.6","3.0","2.6","2.3","2.7","3.0","2.9","2.9","2.5","2.8"]}}},{"type":"Square","id":"7d51812fe50287b5d99010d0352f22e1","attributes":{"id":"7d51812fe50287b5d99010d0352f22e1","tags":[],"size":{"units":"screen","value":10},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":0.5},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"},"line_color":{"units":"data","field":"line_color"},"fill_color":{"units":"data","field":"fill_color"}}},{"type":"Square","id":"4ddcc1d3b8c30b6ab335997678af3113","attributes":{"id":"4ddcc1d3b8c30b6ab335997678af3113","tags":[],"size":{"units":"screen","value":10},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":0.5},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"},"line_color":{"units":"data","value":"#e1e1e1"},"fill_color":{"units":"data","value":"#e1e1e1"}}},{"type":"Square","id":"1dc9c7aa53ce983a5c9edf7f43fba815","attributes":{"id":"1dc9c7aa53ce983a5c9edf7f43fba815","tags":[],"size":{"units":"screen","value":10},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":1},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"},"line_color":{"units":"data","field":"line_color"},"fill_color":{"units":"data","field":"fill_color"}}},{"type":"GlyphRenderer","id":"db7844fda417b6ed9f222213c2e4af84","attributes":{"id":"db7844fda417b6ed9f222213c2e4af84","tags":[],"selection_glyph":null,"nonselection_glyph":{"type":"Square","id":"4ddcc1d3b8c30b6ab335997678af3113"},"hover_glyph":{"type":"Square","id":"1dc9c7aa53ce983a5c9edf7f43fba815"},"name":null,"data_source":{"type":"ColumnDataSource","id":"df24da7e82adc376728612fa8206f92f"},"glyph":{"type":"Square","id":"7d51812fe50287b5d99010d0352f22e1"}}},{"type":"HoverTool","id":"1a8410ec33c28de78ac398cb1005ec17","attributes":{"id":"1a8410ec33c28de78ac398cb1005ec17","tags":[],"plot":{"type":"Plot","id":"6e2445197878a52fcf46ea1afd04b546","subtype":"Figure"},"renderers":[{"type":"GlyphRenderer","id":"5f63198e21ef0041718bc349c2b70553"}],"names":[],"anchor":"center","attachment":"horizontal","line_policy":"prev","mode":"mouse","point_policy":"snap_to_data","tooltips":[["Sepal.Length","@hover_col_1"],["Sepal.Width","@hover_col_2"]]}},{"type":"ColumnDataSource","id":"307282d4b9fff68ef078bde41075132f","attributes":{"id":"307282d4b9fff68ef078bde41075132f","tags":[],"column_names":["x","y","line_color","fill_color","hover_col_1","hover_col_2"],"selected":[],"data":{"x":[6.3,5.8,7.1,6.3,6.5,7.6,4.9,7.3,6.7,7.2,6.5,6.4,6.8,5.7,5.8,6.4,6.5,7.7,7.7,6,6.9,5.6,7.7,6.3,6.7,7.2,6.2,6.1,6.4,7.2,7.4,7.9,6.4,6.3,6.1,7.7,6.3,6.4,6,6.9,6.7,6.9,5.8,6.8,6.7,6.7,6.3,6.5,6.2,5.9],"y":[3.3,2.7,3,2.9,3,3,2.5,2.9,2.5,3.6,3.2,2.7,3,2.5,2.8,3.2,3,3.8,2.6,2.2,3.2,2.8,2.8,2.7,3.3,3.2,2.8,3,2.8,3,2.8,3.8,2.8,2.8,2.6,3,3.4,3.1,3,3.1,3.1,3.1,2.7,3.2,3.3,3,2.5,3,3.4,3],"line_color":["#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C"],"fill_color":["#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C","#2CA02C"],"hover_col_1":["6.3","5.8","7.1","6.3","6.5","7.6","4.9","7.3","6.7","7.2","6.5","6.4","6.8","5.7","5.8","6.4","6.5","7.7","7.7","6.0","6.9","5.6","7.7","6.3","6.7","7.2","6.2","6.1","6.4","7.2","7.4","7.9","6.4","6.3","6.1","7.7","6.3","6.4","6.0","6.9","6.7","6.9","5.8","6.8","6.7","6.7","6.3","6.5","6.2","5.9"],"hover_col_2":["3.3","2.7","3.0","2.9","3.0","3.0","2.5","2.9","2.5","3.6","3.2","2.7","3.0","2.5","2.8","3.2","3.0","3.8","2.6","2.2","3.2","2.8","2.8","2.7","3.3","3.2","2.8","3.0","2.8","3.0","2.8","3.8","2.8","2.8","2.6","3.0","3.4","3.1","3.0","3.1","3.1","3.1","2.7","3.2","3.3","3.0","2.5","3.0","3.4","3.0"]}}},{"type":"Triangle","id":"0faa3aa13a21c349449bf9923f2ceec7","attributes":{"id":"0faa3aa13a21c349449bf9923f2ceec7","tags":[],"size":{"units":"screen","value":10},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":0.5},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"},"line_color":{"units":"data","field":"line_color"},"fill_color":{"units":"data","field":"fill_color"}}},{"type":"Triangle","id":"23286b15d25dae43bc8c131d0c12e7da","attributes":{"id":"23286b15d25dae43bc8c131d0c12e7da","tags":[],"size":{"units":"screen","value":10},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":0.5},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"},"line_color":{"units":"data","value":"#e1e1e1"},"fill_color":{"units":"data","value":"#e1e1e1"}}},{"type":"Triangle","id":"db2bba047ace6a2c2cd4dd90a00d0f41","attributes":{"id":"db2bba047ace6a2c2cd4dd90a00d0f41","tags":[],"size":{"units":"screen","value":10},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":1},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"},"line_color":{"units":"data","field":"line_color"},"fill_color":{"units":"data","field":"fill_color"}}},{"type":"GlyphRenderer","id":"5f63198e21ef0041718bc349c2b70553","attributes":{"id":"5f63198e21ef0041718bc349c2b70553","tags":[],"selection_glyph":null,"nonselection_glyph":{"type":"Triangle","id":"23286b15d25dae43bc8c131d0c12e7da"},"hover_glyph":{"type":"Triangle","id":"db2bba047ace6a2c2cd4dd90a00d0f41"},"name":null,"data_source":{"type":"ColumnDataSource","id":"307282d4b9fff68ef078bde41075132f"},"glyph":{"type":"Triangle","id":"0faa3aa13a21c349449bf9923f2ceec7"}}},{"type":"ColumnDataSource","id":"c2a568730e8393f49fe9eb3738395137","attributes":{"id":"c2a568730e8393f49fe9eb3738395137","tags":[],"column_names":["x","y"],"selected":[],"data":{"x":[null,null],"y":[null,null]}}},{"type":"Circle","id":"4fb9769a9a667888fca87076f1fa640a","attributes":{"id":"4fb9769a9a667888fca87076f1fa640a","tags":[],"size":{"units":"screen","value":0},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":0.5},"line_color":{"units":"data","value":"#1F77B4"},"fill_color":{"units":"data","value":"#1F77B4"},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"}}},{"type":"Circle","id":"bc08857452aea739e44098ff26ffc46d","attributes":{"id":"bc08857452aea739e44098ff26ffc46d","tags":[],"size":{"units":"screen","value":0},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":0.5},"line_color":{"units":"data","value":"#e1e1e1"},"fill_color":{"units":"data","value":"#e1e1e1"},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"}}},{"type":"Circle","id":"27d12ef6772ec2479910ca194d785541","attributes":{"id":"27d12ef6772ec2479910ca194d785541","tags":[],"size":{"units":"screen","value":0},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":1},"line_color":{"units":"data","value":"#1F77B4"},"fill_color":{"units":"data","value":"#1F77B4"},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"}}},{"type":"GlyphRenderer","id":"78ff104c512d026b7ab0259e6bf57848","attributes":{"id":"78ff104c512d026b7ab0259e6bf57848","tags":[],"selection_glyph":null,"nonselection_glyph":{"type":"Circle","id":"bc08857452aea739e44098ff26ffc46d"},"hover_glyph":{"type":"Circle","id":"27d12ef6772ec2479910ca194d785541"},"name":null,"data_source":{"type":"ColumnDataSource","id":"c2a568730e8393f49fe9eb3738395137"},"glyph":{"type":"Circle","id":"4fb9769a9a667888fca87076f1fa640a"}}},{"type":"Square","id":"8627f8aa5760cd04139ff2f863c9b2ed","attributes":{"id":"8627f8aa5760cd04139ff2f863c9b2ed","tags":[],"size":{"units":"screen","value":0},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":0.5},"line_color":{"units":"data","value":"#FF7F0E"},"fill_color":{"units":"data","value":"#FF7F0E"},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"}}},{"type":"Square","id":"b5430aa994aee6695eae2196f1e4f4e7","attributes":{"id":"b5430aa994aee6695eae2196f1e4f4e7","tags":[],"size":{"units":"screen","value":0},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":0.5},"line_color":{"units":"data","value":"#e1e1e1"},"fill_color":{"units":"data","value":"#e1e1e1"},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"}}},{"type":"Square","id":"655f80fb0cbf497720007f6e46fba055","attributes":{"id":"655f80fb0cbf497720007f6e46fba055","tags":[],"size":{"units":"screen","value":0},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":1},"line_color":{"units":"data","value":"#FF7F0E"},"fill_color":{"units":"data","value":"#FF7F0E"},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"}}},{"type":"GlyphRenderer","id":"74b15a97032f6786a1d9d679e63f9f5c","attributes":{"id":"74b15a97032f6786a1d9d679e63f9f5c","tags":[],"selection_glyph":null,"nonselection_glyph":{"type":"Square","id":"b5430aa994aee6695eae2196f1e4f4e7"},"hover_glyph":{"type":"Square","id":"655f80fb0cbf497720007f6e46fba055"},"name":null,"data_source":{"type":"ColumnDataSource","id":"c2a568730e8393f49fe9eb3738395137"},"glyph":{"type":"Square","id":"8627f8aa5760cd04139ff2f863c9b2ed"}}},{"type":"Triangle","id":"4befa891e4b7b407ccd6e185fddb8997","attributes":{"id":"4befa891e4b7b407ccd6e185fddb8997","tags":[],"size":{"units":"screen","value":0},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":0.5},"line_color":{"units":"data","value":"#2CA02C"},"fill_color":{"units":"data","value":"#2CA02C"},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"}}},{"type":"Triangle","id":"312509cafe4cd438edd6874b598c1b01","attributes":{"id":"312509cafe4cd438edd6874b598c1b01","tags":[],"size":{"units":"screen","value":0},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":0.5},"line_color":{"units":"data","value":"#e1e1e1"},"fill_color":{"units":"data","value":"#e1e1e1"},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"}}},{"type":"Triangle","id":"99ce6d963e7fa26e4d8479243b820d3a","attributes":{"id":"99ce6d963e7fa26e4d8479243b820d3a","tags":[],"size":{"units":"screen","value":0},"visible":true,"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":1},"line_color":{"units":"data","value":"#2CA02C"},"fill_color":{"units":"data","value":"#2CA02C"},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"}}},{"type":"GlyphRenderer","id":"0f68b5736be473e5d13d03c5d4a1e08d","attributes":{"id":"0f68b5736be473e5d13d03c5d4a1e08d","tags":[],"selection_glyph":null,"nonselection_glyph":{"type":"Triangle","id":"312509cafe4cd438edd6874b598c1b01"},"hover_glyph":{"type":"Triangle","id":"99ce6d963e7fa26e4d8479243b820d3a"},"name":null,"data_source":{"type":"ColumnDataSource","id":"c2a568730e8393f49fe9eb3738395137"},"glyph":{"type":"Triangle","id":"4befa891e4b7b407ccd6e185fddb8997"}}},{"type":"Legend","id":"1db855fb2ba38e69d65e1e1afc6d29e3","attributes":{"id":"1db855fb2ba38e69d65e1e1afc6d29e3","tags":[],"plot":{"type":"Plot","id":"6e2445197878a52fcf46ea1afd04b546","subtype":"Figure"},"legends":[["Species",[]],[" setosa",[{"type":"GlyphRenderer","id":"78ff104c512d026b7ab0259e6bf57848"}]],[" versicolor",[{"type":"GlyphRenderer","id":"74b15a97032f6786a1d9d679e63f9f5c"}]],[" virginica",[{"type":"GlyphRenderer","id":"0f68b5736be473e5d13d03c5d4a1e08d"}]]],"location":"top_right"}},{"type":"Range1d","id":"948ada425c8019e8a2cf2c27f0b53b4a","attributes":{"id":"948ada425c8019e8a2cf2c27f0b53b4a","tags":[],"start":4.048,"end":8.152}},{"type":"Range1d","id":"c7517c10066408ddf16c29b4522ccf1b","attributes":{"id":"c7517c10066408ddf16c29b4522ccf1b","tags":[],"start":1.832,"end":4.568}},{"type":"LinearAxis","id":"00a7e71f34f0a42ccb3b6fa81a584214","attributes":{"id":"00a7e71f34f0a42ccb3b6fa81a584214","tags":[],"plot":{"type":"Plot","id":"6e2445197878a52fcf46ea1afd04b546","subtype":"Figure"},"axis_label":"Sepal.Length","formatter":{"type":"BasicTickFormatter","id":"dfd2af4ae662c3f01ccb9d548dc88c87"},"ticker":{"type":"BasicTicker","id":"36766ef9bac319a015c3d7b885fc7c2f"},"visible":true,"axis_label_text_font_size":"12pt"}},{"type":"BasicTickFormatter","id":"dfd2af4ae662c3f01ccb9d548dc88c87","attributes":{"id":"dfd2af4ae662c3f01ccb9d548dc88c87","tags":[]}},{"type":"BasicTicker","id":"36766ef9bac319a015c3d7b885fc7c2f","attributes":{"id":"36766ef9bac319a015c3d7b885fc7c2f","tags":[],"num_minor_ticks":5}},{"type":"Grid","id":"f42e0c974ef7c1392fa15bd28fccdec3","attributes":{"id":"f42e0c974ef7c1392fa15bd28fccdec3","tags":[],"dimension":0,"plot":{"type":"Plot","id":"6e2445197878a52fcf46ea1afd04b546","subtype":"Figure"},"ticker":{"type":"BasicTicker","id":"36766ef9bac319a015c3d7b885fc7c2f"}}},{"type":"LinearAxis","id":"afdbf1a689b020f61498454449615074","attributes":{"id":"afdbf1a689b020f61498454449615074","tags":[],"plot":{"type":"Plot","id":"6e2445197878a52fcf46ea1afd04b546","subtype":"Figure"},"axis_label":"Sepal.Width","formatter":{"type":"BasicTickFormatter","id":"6ea894b764c4f00a32543d455350aeed"},"ticker":{"type":"BasicTicker","id":"ec1f754c55ad11a86af6764038d8a2ab"},"visible":true,"axis_label_text_font_size":"12pt"}},{"type":"BasicTickFormatter","id":"6ea894b764c4f00a32543d455350aeed","attributes":{"id":"6ea894b764c4f00a32543d455350aeed","tags":[]}},{"type":"BasicTicker","id":"ec1f754c55ad11a86af6764038d8a2ab","attributes":{"id":"ec1f754c55ad11a86af6764038d8a2ab","tags":[],"num_minor_ticks":5}},{"type":"Grid","id":"0022f330173ffb5a4d66459d9c50c182","attributes":{"id":"0022f330173ffb5a4d66459d9c50c182","tags":[],"dimension":1,"plot":{"type":"Plot","id":"6e2445197878a52fcf46ea1afd04b546","subtype":"Figure"},"ticker":{"type":"BasicTicker","id":"ec1f754c55ad11a86af6764038d8a2ab"}}}]}}},"debug":false},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


# Leaflet

[Leaflet](http://rstudio.github.io/leaflet/) is a really powerful JavaScript library for creating dynamic maps that support panning and zooming along with various annotations like markers, polygons, and popups.  The example below were adapted from the [leaflet vignettes](http://rstudio.github.io/leaflet).


```r
library(leaflet)
geocode("Buffalo, NY")
```

```
##         lon      lat
## 1 -78.87837 42.88645
```

```r
m <- leaflet() %>% setView(lng = -78.87837, lat = 42.88645, zoom = 12) %>% 
  addTiles()
frameWidget(m,height =500)
```

<!--html_preserve--><div id="htmlwidget-529e1b2842b5ac56b65b" style="width:100%;height:500px;" class="widgetframe html-widget"></div>
<script type="application/json" data-for="htmlwidget-529e1b2842b5ac56b65b">{"x":{"url":"12_DynamicVisualization_files/figure-html//widgets/widget_unnamed-chunk-5.html","options":{"xdomain":"*","allowfullscreen":false,"lazyload":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


<div class="well">
## Your turn
This example only scratches the surface of what is possible with leaflet.  Consider whether you can use an leaflet maps in your project.  

* Browse the [Leaflet website](http://rstudio.github.io/leaflet/) 
* What data could you use? 
* How would you display it?
</div>


# dygraphs
An R interface to the 'dygraphs' JavaScript charting library. Provides rich facilities for charting time-series data in R, including highly configurable series- and axis-display and interactive features like zoom/pan and series/point highlighting.
    

```r
library(dygraphs)
dygraph(nhtemp, main = "New Haven Temperatures",height = 100) %>% 
  dyRangeSelector(dateWindow = c("1920-01-01", "1960-01-01"))%>%
  frameWidget(height =500)
```

<!--html_preserve--><div id="htmlwidget-8e14d6ef512560b732b0" style="width:100%;height:500px;" class="widgetframe html-widget"></div>
<script type="application/json" data-for="htmlwidget-8e14d6ef512560b732b0">{"x":{"url":"12_DynamicVisualization_files/figure-html//widgets/widget_unnamed-chunk-6.html","options":{"xdomain":"*","allowfullscreen":false,"lazyload":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

<div class="well">
## Your turn
Make a dygraph of recent daily maximum temperature data from Buffalo, NY.

Hints:

* Use the following code to download the daily weather data (if this is taking too long, you can use the nhtemps object loaded above)

```r
library(rnoaa)
library(xts)

d=meteo_tidy_ghcnd("USW00014733",
                   date_min = "2016-01-01", 
                   var = c("TMAX"),
                   keep_flags=T)
d$date=as.Date(d$date)
```

* create a `xts` time series object as required by `dygraph()` using `xts()` and specify the vector of data and the date column (see `?xts` for help). 
* use `dygraph()` to draw the plot
* add a `dyRangeSelector()` with a `dateWindow` of `c("2017-01-01", "2017-12-31")`

<button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo2">Show Solution</button>
<div id="demo2" class="collapse">


```r
# Convert to a xts time series object as required by dygraph
dt=xts(d$tmax,order.by=d$date)

dygraph(dt, main = "Daily Maximum Temperature in Buffalo, NY") %>% 
  dyRangeSelector(dateWindow = c("2017-01-01", "2017-12-31"))%>%
  frameWidget(height =500)
```

<!--html_preserve--><div id="htmlwidget-6c9ccf74152594a7a09c" style="width:100%;height:500px;" class="widgetframe html-widget"></div>
<script type="application/json" data-for="htmlwidget-6c9ccf74152594a7a09c">{"x":{"url":"12_DynamicVisualization_files/figure-html//widgets/widget_unnamed-chunk-8.html","options":{"xdomain":"*","allowfullscreen":false,"lazyload":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
</div>
</div>

# rthreejs

Create interactive 3D scatter plots, network plots, and globes using the ['three.js' visualization library](https://threejs.org).
    

```r
#devtools::install_github("bwlewis/rthreejs")
library(threejs)
z <- seq(-10, 10, 0.1)
x <- cos(z)
y <- sin(z)
scatterplot3js(x, y, z, color=rainbow(length(z)))
```

# networkD3

Creates 'D3' 'JavaScript' network, tree, dendrogram, and Sankey graphs from 'R'.
    

```r
library(igraph)
library(networkD3)
```


## Load example network
This loads an example social network of friendships between 34 members of a karate club at a US university in the 1970s. See W. W. Zachary, An information flow model for conflict and fission in small groups, Journal of Anthropological Research 33, 452-473 (1977).


```r
karate <- make_graph("Zachary")
wc <- cluster_walktrap(karate)
members <- membership(wc)

# Convert to object suitable for networkD3
karate_d3 <- igraph_to_networkD3(karate, group = members)
```

## Force directed network plot


```r
forceNetwork(Links = karate_d3$links, Nodes = karate_d3$nodes,
             Source = 'source', Target = 'target', NodeID = 'name',
             Group = 'group')%>%
  frameWidget(height =500)
```

<!--html_preserve--><div id="htmlwidget-b0364c1cde27c3681984" style="width:100%;height:500px;" class="widgetframe html-widget"></div>
<script type="application/json" data-for="htmlwidget-b0364c1cde27c3681984">{"x":{"url":"12_DynamicVisualization_files/figure-html//widgets/widget_unnamed-chunk-12.html","options":{"xdomain":"*","allowfullscreen":false,"lazyload":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


## Sankey Network graph

Sankey diagrams are flow diagrams in which the width of the arrows is shown proportionally to the flow quantity.


```r
# Load energy projection data
library(jsonlite)
URL <- paste0(
        "https://cdn.rawgit.com/christophergandrud/networkD3/",
        "master/JSONdata/energy.json")
Energy <- fromJSON(URL)
```


```r
sankeyNetwork(Links = Energy$links, Nodes = Energy$nodes, Source = "source",
             Target = "target", Value = "value", NodeID = "name",
             units = "TWh", fontSize = 12, nodeWidth = 30)%>%
  frameWidget(height =500)
```

<!--html_preserve--><div id="htmlwidget-18981351778c33a30094" style="width:100%;height:500px;" class="widgetframe html-widget"></div>
<script type="application/json" data-for="htmlwidget-18981351778c33a30094">{"x":{"url":"12_DynamicVisualization_files/figure-html//widgets/widget_unnamed-chunk-14.html","options":{"xdomain":"*","allowfullscreen":false,"lazyload":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

## Radial Network

```r
URL <- paste0(
        "https://cdn.rawgit.com/christophergandrud/networkD3/",
        "master/JSONdata//flare.json")

## Convert to list format
Flare <- jsonlite::fromJSON(URL, simplifyDataFrame = FALSE)
```



```r
# Use subset of data for more readable diagram
Flare$children = Flare$children[1:3]

radialNetwork(List = Flare, fontSize = 10, opacity = 0.9, height = 400, width=400)
```

<!--html_preserve--><div id="htmlwidget-24a660bb1cd97caad23f" style="width:400px;height:400px;" class="radialNetwork html-widget"></div>
<script type="application/json" data-for="htmlwidget-24a660bb1cd97caad23f">{"x":{"root":{"name":"flare","children":[{"name":"analytics","children":[{"name":"cluster","children":[{"name":"AgglomerativeCluster","size":3938},{"name":"CommunityStructure","size":3812},{"name":"HierarchicalCluster","size":6714},{"name":"MergeEdge","size":743}]},{"name":"graph","children":[{"name":"BetweennessCentrality","size":3534},{"name":"LinkDistance","size":5731},{"name":"MaxFlowMinCut","size":7840},{"name":"ShortestPaths","size":5914},{"name":"SpanningTree","size":3416}]},{"name":"optimization","children":[{"name":"AspectRatioBanker","size":7074}]}]},{"name":"animate","children":[{"name":"Easing","size":17010},{"name":"FunctionSequence","size":5842},{"name":"interpolate","children":[{"name":"ArrayInterpolator","size":1983},{"name":"ColorInterpolator","size":2047},{"name":"DateInterpolator","size":1375},{"name":"Interpolator","size":8746},{"name":"MatrixInterpolator","size":2202},{"name":"NumberInterpolator","size":1382},{"name":"ObjectInterpolator","size":1629},{"name":"PointInterpolator","size":1675},{"name":"RectangleInterpolator","size":2042}]},{"name":"ISchedulable","size":1041},{"name":"Parallel","size":5176},{"name":"Pause","size":449},{"name":"Scheduler","size":5593},{"name":"Sequence","size":5534},{"name":"Transition","size":9201},{"name":"Transitioner","size":19975},{"name":"TransitionEvent","size":1116},{"name":"Tween","size":6006}]},{"name":"data","children":[{"name":"converters","children":[{"name":"Converters","size":721},{"name":"DelimitedTextConverter","size":4294},{"name":"GraphMLConverter","size":9800},{"name":"IDataConverter","size":1314},{"name":"JSONConverter","size":2220}]},{"name":"DataField","size":1759},{"name":"DataSchema","size":2165},{"name":"DataSet","size":586},{"name":"DataSource","size":3331},{"name":"DataTable","size":772},{"name":"DataUtil","size":3322}]}]},"options":{"height":400,"width":400,"fontSize":10,"fontFamily":"serif","linkColour":"#ccc","nodeColour":"#fff","nodeStroke":"steelblue","textColour":"#111","margin":{"top":null,"right":null,"bottom":null,"left":null},"opacity":0.9}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

# Diagonal Network

```r
diagonalNetwork(List = Flare, fontSize = 10, opacity = 0.9, height = 400, width=400)
```

<!--html_preserve--><div id="htmlwidget-9ed993d0aeda375982bd" style="width:400px;height:400px;" class="diagonalNetwork html-widget"></div>
<script type="application/json" data-for="htmlwidget-9ed993d0aeda375982bd">{"x":{"root":{"name":"flare","children":[{"name":"analytics","children":[{"name":"cluster","children":[{"name":"AgglomerativeCluster","size":3938},{"name":"CommunityStructure","size":3812},{"name":"HierarchicalCluster","size":6714},{"name":"MergeEdge","size":743}]},{"name":"graph","children":[{"name":"BetweennessCentrality","size":3534},{"name":"LinkDistance","size":5731},{"name":"MaxFlowMinCut","size":7840},{"name":"ShortestPaths","size":5914},{"name":"SpanningTree","size":3416}]},{"name":"optimization","children":[{"name":"AspectRatioBanker","size":7074}]}]},{"name":"animate","children":[{"name":"Easing","size":17010},{"name":"FunctionSequence","size":5842},{"name":"interpolate","children":[{"name":"ArrayInterpolator","size":1983},{"name":"ColorInterpolator","size":2047},{"name":"DateInterpolator","size":1375},{"name":"Interpolator","size":8746},{"name":"MatrixInterpolator","size":2202},{"name":"NumberInterpolator","size":1382},{"name":"ObjectInterpolator","size":1629},{"name":"PointInterpolator","size":1675},{"name":"RectangleInterpolator","size":2042}]},{"name":"ISchedulable","size":1041},{"name":"Parallel","size":5176},{"name":"Pause","size":449},{"name":"Scheduler","size":5593},{"name":"Sequence","size":5534},{"name":"Transition","size":9201},{"name":"Transitioner","size":19975},{"name":"TransitionEvent","size":1116},{"name":"Tween","size":6006}]},{"name":"data","children":[{"name":"converters","children":[{"name":"Converters","size":721},{"name":"DelimitedTextConverter","size":4294},{"name":"GraphMLConverter","size":9800},{"name":"IDataConverter","size":1314},{"name":"JSONConverter","size":2220}]},{"name":"DataField","size":1759},{"name":"DataSchema","size":2165},{"name":"DataSet","size":586},{"name":"DataSource","size":3331},{"name":"DataTable","size":772},{"name":"DataUtil","size":3322}]}]},"options":{"height":400,"width":400,"fontSize":10,"fontFamily":"serif","linkColour":"#ccc","nodeColour":"#fff","nodeStroke":"steelblue","textColour":"#111","margin":{"top":null,"right":null,"bottom":null,"left":null},"opacity":0.9}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


# rglwidget

RGL provides 3D interactive graphics, including functions modelled on base graphics (`plot3d()`, etc.) as well as functions for constructing representations of geometric objects (`cube3d()`, etc.).  You may need to install [XQuartz](https://www.xquartz.org/).


```r
library(rgl)
library(rglwidget)
library(htmltools)

# Load a low-resolution elevation dataset of a volcano
data(volcano)
```

## Plot an interactive 3D _surface_

```r
persp3d(volcano, type="s",col="green3")
rglwidget(elementId = "example", width = 500, height = 400)%>%
  frameWidget()
```

<!--html_preserve--><div id="htmlwidget-80050a20417aef9e3d08" style="width:100%;height:400px;" class="widgetframe html-widget"></div>
<script type="application/json" data-for="htmlwidget-80050a20417aef9e3d08">{"x":{"url":"12_DynamicVisualization_files/figure-html//widgets/widget_unnamed-chunk-19.html","options":{"xdomain":"*","allowfullscreen":false,"lazyload":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


<div class="well">
## Your turn

Check out the [HTML Widgets page](http://gallery.htmlwidgets.org/) for many more examples.

Which can you use in your project?

</div>


