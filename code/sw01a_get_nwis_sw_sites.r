# ==============================================================================
# Script Name:     sw01a_get_nwis_sw_sites.R
# Author:          Charles Jason Tinant — with ChatGPT 5 - thinking
# Date Created:    2025-07-23
# Last Update:     2025-09-28
# Change Log:
# - 2025-07-23     Initial commit in FFA project.
# - 2025-09-25     Copied over to wakpala_yamni_kin project (this project).
#                  Update bounding box (bbox) download code to match study area.
# - 2025-09-26     Update metadata. Add filter bbox results to HUC multipolygon
#                  boundaries.
# - 2025-09-28     Update QA map. Update metadata.

# Purpose:         Identify gage sites within three HUC-6 watersheds: Green River
#                  (140401), Wind River (100800), Snake River (170401).
#
# Workflow Summary:
# 1. Define paths -- Load study area. The study area is defined by Hydrologic
#    Unit Codes (HUCs) The three HUC-6 watersheds in the study area: Green River
#    (140401), Wind River (100800), Snake River (170401).
# 2. Prepare HUCs -- remove cruft from prior conversion to 
# 3. Prepare bounding box -- dataRetrieval can use a bounding box to find and 
#    download NWIS data.
# 3. Get sites in bounding box using a script so not to overload the server
# 4. Filter within study area HUCs and split streams and canals
# 5. Make a visual check of downloads
# 6. Export results
#
# Input/Data URLs:
# - data/study_area/study_area_orig.gpkg
# Outputs:
# - All NWIS surface water sites in HUCs - data/raw/sites_all_in_huc.csv
# - NWIS canals and ditches in HUCs      - data/raw/sites_not_ST_in_huc.csv
# - NWIS stream discharge sites in HUCs  - data/raw/sites_ST_in_huc.csv
# - QA plot                              - output/qa_checks/sites_in_hucs_qa.png
# - HUCs gpkg updated with project info  - data/study_area/study_area.gpkg
# - Description of colors used in map    - data/map_colors.csv"
#
# Useful websites: 
# - WhoCanUse.com -- A tool that brings attention and understanding to how color
#   contrast can affect different people with visual impairments
# - https://www.whocanuse.com/?bg=92b649&fg=34ecda&fs=16&fw=
#
# Dependencies:
# - dataRetreval   Retrieval functions for USGS and EPA hydrology and WQ data
# - ggspatial      Easier mapping of spatial object data in a ggplot2 framework.
# - here           Robust file paths
# - janitor        Cleans up dirty data
# - sf             Spatial data (simple features)
# - tidyverse      Data wrangling & visualization
#
# Related Files:
#
# Notes/Next Steps:
# - Move over data dictionary etc. 
# - Look up gages vs sites distinction
# - fix warning: In whatNWISsites(bBox = bbox_vector, siteType = "ST",
# parameterCd = "00060") : NWIS servers are slated for decommission. Please
#  begin to migrate to read_waterdata_monitoring_location
# ==============================================================================
# --- load libraries ---
suppressPackageStartupMessages({
  library(dataRetrieval)
  library(ggspatial)
  library(here)
  library(janitor)
  library(sf)
  library(tidyverse)
})

# ------------------------------------------------------------------------------
# 1. Define paths -- load data
# ------------------------------------------------------------------------------
gpkg <- here("data", "study_area", "study_area.gpkg")

# list all layers inside the GeoPackage
st_layers(gpkg)

# --- load hucs ---
hucs_orig <- st_read(gpkg,
                     layer = "project_hucs")

# ------------------------------------------------------------------------------
# 2. Prepare HUCs 
# ------------------------------------------------------------------------------
# --- show the CRS should be in WGS84 Geographic ---
head(hucs_orig)

#  --- set coordinate system for transform ---
crs_new <- 4326 # WGS 84 Geographic; Unit: degree

# --- Transform projection to geographic ---
hucs <- st_transform(hucs_orig, crs = crs_new)

# --- make names ---
names <- tibble(Name = hucs$Name) %>%
  mutate(wtsd_name = c("Wind River", "Green River", "Snake River"))

hucs <- hucs %>%
  left_join(names, by = join_by(Name)) %>%
  select(-c(description:icon))

# --- prepare for plotting ---
# --- make some styles ---
huc_styles <- tibble::tibble(
  wtsd_name    = c("Snake River", "Wind River", "Green River"),
  RAD_strategy = c("Resist", "Accept", "Direct"),
  fill         = c("#B22222", "#34ecda", "#92b649") # red, turquoise, green
)

hucs <- hucs %>%
  dplyr::left_join(huc_styles, by = "wtsd_name")

# ------------------------------------------------------------------------------
# 3. Prepare bounding box
# ------------------------------------------------------------------------------
# -- Define a Bounding Box ---
bbox <- st_bbox(hucs)

# --- add a safety factor ---
bbox[c(
  "xmin","ymin","xmax","ymax")] <- bbox[c(
    "xmin","ymin","xmax","ymax")] + c(
      -0.5, -0.5, 1.0, 1.0
)

# --- Set resolution for horizontal (lon) and vertical (lat) splits ---
max_width <- 1.0 # degrees longitude
max_height <- 2.5 # degrees latitude

# --- Create sequences of breakpoints ---
xmin_seq <- seq(bbox["xmin"], bbox["xmax"] - max_width, by = max_width)
xmax_seq <- pmin(xmin_seq + max_width, bbox["xmax"])

ymin_seq <- seq(bbox["ymin"], bbox["ymax"] - max_height, by = max_height)
ymax_seq <- pmin(ymin_seq + max_height, bbox["ymax"])

# --- Create all combinations of xmin/xmax and ymin/ymax ----------------------
grid_boxes <- expand.grid(
  xmin = xmin_seq,
  ymin = ymin_seq
) %>%
  mutate(
    xmax = xmin + max_width,
    ymax = ymin + max_height,
    index = row_number()
  )

# --- clean up environment ---
rm(hucs_orig, gpkg)

# ------------------------------------------------------------------------------
# 4. Get sites in bounding box
# ------------------------------------------------------------------------------
sites_data_list <- vector("list", nrow(grid_boxes))

for (i in seq_len(nrow(grid_boxes))) {
  bbox_row <- grid_boxes[i, ]
  
  # numeric vector for dataRetrieval
  bbox_vec <- c(bbox_row$xmin, bbox_row$ymin, bbox_row$xmax, bbox_row$ymax)
  
  message("Trying grid tile ", i, " with bbox: ",
          paste(bbox_vec, collapse = ","))
  
  sites_data <- tryCatch(
    {
      whatNWISsites(
        bBox       = bbox_vec,      # numeric vector
        siteType   = "ST",          # streams
        parameterCd = "00060"       # discharge
      )
    },
    error = function(e) {
      message(paste("Error in grid tile", i, ":", e$message))
      NULL
    }
  )
  
  if (!is.null(sites_data) && nrow(sites_data) > 0) {
    sites_data$tile_id <- i
    sites_data_list[[i]] <- sites_data
  }
  
  Sys.sleep(0.5) # be kind to the API
}

# --- Combine all site data into a single data frame ---
sites_all_in_bb <- bind_rows(sites_data_list) %>%
  select(-tile_id)                     # drop unneeded fields

# --- clean up environment ---
rm(
  bbox_row,
  grid_boxes,
  sites_data,
  i,
  max_height,
  max_width,
  xmax_seq,
  xmin_seq,
  ymax_seq,
  ymin_seq
)

# -----------------------------------------------------------------------------
# 5. Filter within study area HUCs and split streams and canals
# -----------------------------------------------------------------------------
# --- keep sites inside of HUCs ---
# convert stations into a spatial format (sf) object
sites_all_in_bb_sf <- st_as_sf(sites_all_in_bb,
                                coords = c(
                                  "dec_long_va", # note x goes first
                                  "dec_lat_va"
                                ),
                                crs = crs_new, # WGS 84 Geographic; Unit: degree
                                remove = FALSE   # don't remove lat/lon cols
) 

sites_all_in_huc_sf <- st_intersection(sites_all_in_bb_sf, hucs)

# --- Drop canal ditch sites ---
sites_st_only_in_huc_sf <- sites_all_in_huc_sf %>%
  filter(site_tp_cd == "ST")

sites_not_ST_in_huc_sf <- sites_all_in_huc_sf %>%
  filter(site_tp_cd != "ST")

# -----------------------------------------------------------------------------
# 6. Make a visual check of downloads
# -----------------------------------------------------------------------------
# --- make outline and point colors ---
col_site       <- "#FDB813"    # warm sunflower
col_outline    <- "#5C5C5C"   # soft charcoal
col_haze       <- "#BFBFBF"    # light gray for context

qa_plot <- ggplot() +
  # HUCs: crisp outline, subtle fill so points pop
  geom_sf(data = hucs,
          aes(fill = RAD_strategy),
          alpha    = 0.9,
          linewidth= 0.35,
          color    = col_outline) +
  scale_fill_manual(
    name   = "RAD Strategy",
    values = setNames(huc_styles$fill, huc_styles$RAD_strategy)
  ) +
  # all sites in bbox: faint background “field”
  geom_sf(data = sites_all_in_bb_sf,
          color = col_haze,
          size  = 0.45,
          alpha = 0.25) +
  # non-ST sites in HUCs: mid emphasis
  geom_sf(data = sites_not_ST_in_huc_sf,
          color = col_outline,
          size  = 0.8,
          alpha = 0.55) +
  # ST sites in HUCs: sunflower dots with charcoal stroke (gentle glow)
  geom_sf(data = sites_st_only_in_huc_sf,
          aes(),         # keep sf geometry
          shape = 21,    # lets us set fill + outline
          fill  = col_sunflower,
          color = col_rabbit,
          stroke = 0.25,
          size   = 1.4,
          alpha  = 0.95) +
  labs(
    title    = "Visual check: NWIS sites within Study Area HUCS",
    subtitle = "Snake (Resist) • Wind (Accept) • Green (Direct)",
    caption = "NWIS surface water gage sites shown as Orange Dots\nProjection: as shown • North arrow for orientation"
  ) +
  coord_sf(expand = FALSE) +
  theme_minimal() +
  # small north arrow (no scale bar in lat/lon)
  annotation_north_arrow(
    location = "tr",
    pad_x = unit(4, "mm"),
    pad_y = unit(4, "mm"),
    height = unit(12, "mm"),
    width  = unit(12, "mm"),
    style = north_arrow_fancy_orienteering
  ) +
  # tidy, map-forward theme: no gridlines; clear ticks/labels
  theme_classic(base_size = 11) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title       = element_blank(),
    plot.title.position = "plot",
    plot.title       = element_text(face = "bold"),
    plot.subtitle    = element_text(margin = margin(t = 4, b = 6)),
    plot.caption     = element_text(color = "gray30", size = 9)
  )

qa_plot

# -----------------------------------------------------------------------------
# 7. Export results
# -----------------------------------------------------------------------------

# --- run once::make output dirs ---
#output_dir <- here("data", "raw")
#output_fold <- here("output")
# qa_fold <- here("output", "qa_checks")

#fs::dir_create(output_dir)
#fs::dir_create(output_fold)
#fs::dir_create(qa_fold)

# --- prep for export::drop geometry --- 
sites_all_in_huc    <- st_drop_geometry(sites_all_in_huc_sf)
sites_not_ST_in_huc <- st_drop_geometry(sites_not_ST_in_huc_sf)

# --- make output links ---
output_sites_all    <- here("data", "raw", "sites_all_in_huc.csv")
output_sites_not_ST <- here("data", "raw", "sites_not_ST_in_huc.csv")
output_sites_ST     <- here("data", "raw", "sites_ST_in_huc.csv")
output_qa_plot      <- here("output", "qa_checks", "sites_in_hucs_qa.png")
output_hucs         <- here("data", "study_area", "study_area.gpkg")
output_map_cols     <- here("data", "map_colors.csv")

# --- write site locations ---
write_csv(sites_all_in_huc, output_sites_all)
write_csv(sites_not_ST_in_huc, output_sites_not_ST)
write_csv(sites_st_only_in_huc, output_sites_ST)

# --- write QA check ---
ggsave(
  filename = output_qa_plot,
  plot = qa_plot,
  width = 5, height = 6, dpi = 300,
  bg = "white"   # <- ensures background is white
)

# --- write HUCs ---
trib_huc_id   <- tribble(~wtsd_name, ~huc_id,
                         "Green River", 140401,
                         "Wind River",  100800,
                         "Snake River", 170401
)

hucs <- hucs %>%
  left_join(trib_huc_id,
            by = join_by(wtsd_name)
)

st_write(hucs,
         dsn = output_hucs,
         layer = "project_hucs",
#         append=FALSE   # overwrites layer and append=TRUE appends the layer
         )

# --- write outline and point colors ---
trib_col   <- tribble(~use_case, "col_main_point", "col_outline", "col_haze")
trib_hex   <- tribble(~hex_code, col_site, col_outline, col_haze)
trib_descr <- tribble(~description, "warm sunflower", "soft charcoal", 
                      "light gray for context")

map_cols <- bind_cols(trib_col, trib_hex, trib_descr)

write_csv(map_cols, output_map_cols)
