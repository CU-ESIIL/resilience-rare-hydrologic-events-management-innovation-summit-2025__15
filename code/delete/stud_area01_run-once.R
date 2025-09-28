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
# --- load libraries ---
suppressPackageStartupMessages({
  library(here)
  library(tidyverse)
  library(sf)
  library(janitor)
})
# ------------------------------------------------------------------------------
# 1. Run Once -- Clean up the nonsense
# ------------------------------------------------------------------------------
# rewrite each layer into one .gpkg (overwrite if it exists)
# gpkg_path <- here("data", "study_area", "study_area.gpkg")
# 
# st_write(hucs, gpkg_path,
#          layer = "project_hucs",
#          delete_dsn = file.exists(gpkg_path))
# 
# # append second layer
# st_write(outline, gpkg_path, layer = "project_outline", append = TRUE)

# ------------------------------------------------------------------------------
# 1. Define paths
# ------------------------------------------------------------------------------
gpkg <- here("data", "study_area", "study_area.gpkg")

# list all layers inside the GeoPackage
st_layers(gpkg)


# --- load hucs ---
hucs <- st_read(gpkg,
                layer = "project_hucs")

# --- show the CRS should be in WGS84 Geographic ---
head(hucs)

# ------------------------------------------------------------------------------
# 1. Run Once -- Clean up the other nonsense
# ------------------------------------------------------------------------------
# --- read the HUCs layer ---
hucs <- st_read(gpkg, layer = "project_hucs", quiet = TRUE)

# --- clean it up ---
# - drop HTML `description` + GE/KML fields
# - normalize names
# - drop Z/M to 2D
# - keep only the columns you want
# hucs_clean <-
#   hucs %>%
#   clean_names() %>%
#   select(name, geom) %>%   # keep the useful bits
#   st_zm(drop = TRUE, what = "ZM")                   # MULTIPOLYGON (2D)
#
# --- ensure valid geometries ---
hucs_clean <- st_make_valid(hucs_clean)

# write back to the same gpkg
# use delete_layer=TRUE to replace the original layer,
# or append=TRUE to keep both versions (with a new name)
st_write(
  hucs_clean,
  dsn   = gpkg,
  layer = "project_hucs",
  delete_layer = TRUE
)




