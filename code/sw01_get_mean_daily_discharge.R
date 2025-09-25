# ==============================================================================
# Script Name:     download_daily_flow_data.R
# Author:          Charles Jason Tinant — with ChatGPT 4o
# Date Created:    April 2025
# Last Update:     2025-09-24
# Change Log:
# - 2025-07-23     Move notes to notes/script-notes_and_developer-log.
# - 2025-07-28     Update script to use {here} consistently;
#                  Run {styler}.
# - 2025-09-24     Ported over from a prior codebase.
#
# Purpose:         Identify, downloads and combine USGS daily flow data for
#                  stream gages located in the study area.
#
# UPDATE THIS
# Workflow Summary:
# 1. Load cleaned site metadata for Great Plains stream gages (ST only)
# 2. Extract unique site IDs and divide into API-safe batches
# 3. Query USGS NWIS for peak flow data using `readNWISpeak()`
# 4. Combine all returned results into a single tidy dataframe
# 5. Attempt date parsing; retain raw strings for diagnostics
# 6. Export the combined dataset for further processing
#
# Input/Data URLs
# - data/raw/peakflow_gages/usgs_sites_pk_ST_only.csv
# Site list is derived from `usgs_site_metadata.csv` (script 01c).
# Outputs:
# - data/raw/peakflow_gages/data_pk_all.csv — all retrieved peak flow records
#
# Dependencies:
# - dataRetrieval  Access USGS NWIS data
# - here           Robust file paths
# - sf             Spatial data (simple features)
# - tidyverse      Data wrangling & visualization
#
# Related Milestone Reports:
# - milestone_01_download_prepare_covariates.pdf
# ==============================================================================
# --- Load required libraries ---
library(dataRetrieval)
library(here)
library(sf)
library(tidyverse)


# --- load libraries ---
suppressPackageStartupMessages({
  library(here)
  library(tidyverse)
  library(sf)
  library(janitor)
  library(units)
  library(skimr)
})
# ------------------------------------------------------------------------------
# 0. Define paths and project CRS.
# ------------------------------------------------------------------------------
in_gage_csv <- here("data", "processed", "peakflow_gages", "gage_summary_skew.csv")

out_dir <- here("data", "processed", "peakflow_gages")
out_csv <- file.path(out_dir, "stations_covars.csv")
out_gpkg <- file.path(out_dir, "stations_covars.gpkg")
out_layer <- "stations_covars"

crs_nad83 <- 4269 # NAD83 geographic (decimal degrees)
crs_wgs84 <- 4326 # WGS84 geographic (decimal degrees)
crs_nad27 <- 4267 # NAD27 geographic (Clarke 1866)
crs_out   <- 5070 # CONUS Albers Equal Area (repo standard)













