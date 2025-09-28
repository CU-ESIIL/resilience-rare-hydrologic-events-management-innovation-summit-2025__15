# ==============================================================================
# Script Name:     stud-area01a_clean_raw_HUC_data.R
# Author:          Charles Jason Tinant — with ChatGPT 4o
# Date Created:    April 2025
# Last Update:     2025-09-24
# Change Log:
# - 2025-07-23     Move notes to notes/script-notes_and_developer-log.
# - 2025-07-28     Update script to use {here} consistently;
#                  Run {styler}.
# - 2025-09-24     Ported over from a prior codebase.
# - 2025-09-28     Update metadata
#
# Purpose:         Identify, downloads and combine USGS daily flow data for
#                  stream gages located in the study area.
#
# Workflow Summary:
# 1. Load KML/KMZ file of HUCS.
# 2. Export results as a GPKG.
#
# Input/Data URLs
# - data/study_area/project_hucs.kmz
# Outputs:
# - data/study_area/study_area_raw.gpkg
#
# Dependencies:
# - here           Robust file paths
# - janitor        Cleans up dirty data
# - sf             Spatial data (simple features)
# - tidyverse      Data wrangling & visualization
#
# ==============================================================================
# --- load libraries ---
suppressPackageStartupMessages({
  library(here)
  library(janitor)
  library(sf)
  library(tidyverse)
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

# # ------------------------------------------------------------------------------
# # 1. Define paths and project CRS.
# # ------------------------------------------------------------------------------
# gpkg <- here("data", "study_area", "study_area.gpkg")
# 
# # list all layers inside the GeoPackage
# st_layers(gpkg)
# 
# 
# # --- load hucs ---
# hucs <- st_read(gpkg,
#                 layer = "project_hucs")
# 
# # --- show the CRS should be in WGS84 Geographic ---
# head(hucs)

# ------------------------------------------------------------------------------
# 1. Run Once -- Clean up the other nonsense
# ------------------------------------------------------------------------------
# --- read the HUCs layer ---
hucs <- st_read(gpkg, layer = "project_hucs", quiet = TRUE)

# clean it up:
# - drop HTML `description` + GE/KML fields
# - normalize names
# - drop Z/M to 2D
# - keep only the columns you want
hucs_clean <- hucs %>%
  clean_names() %>%
  select(name, geom) %>%   # keep the useful bits
  st_zm(drop = TRUE, what = "ZM")                   # MULTIPOLYGON (2D)

# --- ensure valid geometries ---
hucs_clean <- st_make_valid(hucs_clean)

# write back to the same gpkg
# use delete_layer=TRUE to replace the original layer,
# or append=TRUE to keep both versions (with a new name)
# st_write(
#   hucs_clean,
#   dsn   = gpkg,
#   layer = "project_hucs",
#   delete_layer = TRUE
# )
