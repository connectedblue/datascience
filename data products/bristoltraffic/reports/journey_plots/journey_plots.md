---
title: "Plots of Journey times"
author: "Chris Shaw"
date: "19 August 2016"
output: html_document
---



## Plots of journey times



```r
routes <- summary$section_id
```

```
## Error in summary$section_id: object of type 'closure' is not subsettable
```

```r
for (r in routes) {
        hist_norm(journeys[journeys$section_id==r,]$est_speed_mph, 40)
}
```

```
## Error in eval(expr, envir, enclos): object 'routes' not found
```
