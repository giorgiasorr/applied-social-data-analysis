# Setup script for reproducibility

# Install required packages (run once)
packages <- c("tidyverse")

installed <- packages %in% rownames(installed.packages())

if (any(!installed)) {
  install.packages(packages[!installed])
}

# Load libraries
library(tidyverse)
library(ggplot2)