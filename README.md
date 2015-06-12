# `bdsns`
Harvesting Biodiversity Records from Social Networking Sites

Google Summer of Code 2015

## Install

### Install the development version using `install_github` within Hadley's [devtools](https://github.com/hadley/devtools) package.

```R
install.packages("devtools")
require(devtools)

install_github("vijaybarve/bdvis")
require(bdvis)
```

Note: 

Windows users have to first install [Rtools](http://cran.r-project.org/bin/windows/Rtools/).


### Functions currently available

#### flickerlist
```r
flickrlist(myapikey,"Danaus chrysippus")
```

