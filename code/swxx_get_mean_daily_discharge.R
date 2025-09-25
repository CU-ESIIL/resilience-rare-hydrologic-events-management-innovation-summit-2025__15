# ==============================================================================
# Script Name:     01b_download_USGS_gage_data.R
# Author:          Charles Jason Tinant
# Date Created:    April 2025
# Last update:     July 28, 2025
# Change Log:
# - 2025-06-13     Update script to fit with folder structure.
# - 2025-07-23     Move notes to notes/script-notes_and_developer-log.
# - 2025-07-28     Update script to use {here} consistently;
#                  Run {styler}
#
# Purpose:         This script downloads, processes, and filters USGS peak flow
#                  gage data within the GP Level 1 Ecoregion. It uses spatial
#                  data to define the AOI and queries USGS National Water
#                  Information System (NWIS) services for peak flow gage data.
#
# Workflow Summary:
# 1. Load Level 1 Ecoregion shapefile and isolate Great Plains extent.
# 2. Generate bounding box grid tiles across Great Plains extent.
# 3. Download USGS site data within each tile
#    (siteType = "ST" parameterCd = "00060").
# 4. Filter to remove canals, ditches, and sites without peak flow records.
# 5. Download peak flow records for filtered sites (service = "pk").
# 6. Convert sites to spatial format and clip to Great Plains extent.
# 7. Export CSV outputs for all sites, peakflow-only sites, and clipped sites.
#
# Input/Data URLs:
# - data/processed/ecoregions/us-eco-levels.gpkg
# Output Files:
# - data/sites_all_in_bb.csv           All USGS sites within bounding box
# - data/sites_all_peak_in_bb.csv      Sites with peak flow data in bounding box
# - data/sites_pk_eco_only.csv         Peak flow sites within GP Ecoregion
#
# Dependencies:
# - dataRetrieval  Access USGS NWIS data
# - dplyr:         Data manipulation
# - here:          Consistent relative paths
# - purrr:         Functional programming toolkit
# - sf:            Spatial data (simple features)
#
# Helper Functions:
# - metadata/process_geometries.R:  Custom helper functions for cleaning sf geometries
#
# Related Milestone Reports:
# - milestone_01_download_prepare_covariates.pdf
# ==============================================================================
# --- Load libraries ---
library(dataRetrieval)
library(dplyr)
library(here)
library(purrr)
library(sf)