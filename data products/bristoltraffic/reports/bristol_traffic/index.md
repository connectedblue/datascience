---
title       : Car journey times in Bristol, UK
subtitle    : Understanding traffic profiles
author      : Chris Shaw
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---



## Introduction

* Bristol has deployed multiple sensors around the city and made data available in an open data project (https://opendata.bristol.gov.uk/)
* One dataset collects journey times from 51 different routes, varying in length from 0.3 to 3.2 miles.  This data is collected every ten minutes, 24 hours a day, seven days a week.
* We introduce today a brand new application that makes use of the historical journey times data to build up a profile of average traffic conditions in Bristol for every hour in every day.
*  It's expected that this application will be used by commuters, small businesses and local government planners amongst others.
* The application can be accessed at https://connectedblue.shinyapps.io/bristoltraffic/
* The following slides demonstrate how the application works

---

## Route data

* Bristol have installed Automatic Number Plate recognition at various points around the city.  From this they are able to track accurate mean journey times across various routes at all times of day and night.
* This data is published in raw form to the Open Data website.  The following table shows a summary of some example routes:


|Route                                                     | Distance | Average Speed | Average journey time |
|:---------------------------------------------------------|:--------:|:-------------:|:--------------------:|
|M32 Newfoundland Circus IB to Old Market St West WB       |   0.4    |     12.1      |          2           |
|M32 Newfoundland Circus IB to Avon St OB                  |   0.7    |     19.8      |          3           |
|M32 Newfoundland Circus IB to Bond St at Gloucester St WB |   0.4    |     26.4      |          3           |
|Bond St at Gloucester St EB to M32 Newfoundland Circus OB |   0.4    |     23.1      |          2           |
|Old Market St East IB to M32 Newfoundland Circus OB       |   0.4    |      4.2      |          8           |
|Old Market St East IB to Avon St OB                       |   0.3    |      3.5      |          7           |
|Old Mkt East IB to Cattlemarket Rd OB                     |   0.7    |      7.1      |          7           |
|Old Market St West EB to Bond St at Gloucester St WB      |   0.4    |      8.3      |          5           |

---

## Determining route status: red/amber/green

* Each route is analysed individually by day and hour.  The speed for each timeslot is compared to the overall route average speed.
* If it's greater than the mean speed, the status is green. If it's less than the mean minus half a standard deviation, the status is red. Otherwise it's orange.


* Here's an example for one route: M32 Newfoundland Circus IB to Old Market St West WB, on a Monday:


|        | Speed|Status |          | Speed|Status |         | Speed|Status |
|:-------|-----:|:------|:---------|-----:|:------|:--------|-----:|:------|
|4 - 5am |  15.0|green  |8 - 9am   |   9.6|red    |12 - 1pm |  11.0|orange |
|5 - 6am |  15.3|green  |9 - 10am  |   9.8|red    |1 - 2pm  |  10.3|orange |
|6 - 7am |  13.9|green  |10 - 11am |  10.8|orange |2 - 3pm  |  10.6|orange |
|7 - 8am |  11.0|orange |11 - 12am |  11.0|orange |3 - 4pm  |  10.8|orange |

* The average speed for this route overall is 12.1mph, and the standard deviation is 4.2.  This means if an individual hour records an average of less than 10mph, then the status is shown as red.

---

## Using the application

* There are two main ways to view the data:  A map view and a bar chart view.  Both views can be changed dynamically by selecting the desired day from the panel of the left, and also the hour can be changed in the slider to see how traffic changes during the day.

* The map view shows the geographic locations of each route, with red, orange or green circles showing the status at any particular time.  If you click on a circle, you can see more details about the average speed and journey time during that particular hour.

* The bar chart view shows an ordered view, from the slowest to the fastest routes.  This allows you to see at a glance which are the most busiest routes for any particular hour.

