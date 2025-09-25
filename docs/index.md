# Resilience for Hydrologic Events Management

<p style="text-align: right;"><a href="https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/edit/main/docs/index.md" title="Edit this page">✏️</a></p>

<!-- =========================================================
HERO (Swap hero.jpg, title, strapline, and the three links)
========================================================= -->

![Wide banner of the study system](https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/blob/main/documentation/images/Headwaters.png)

**Impact:** In three days, Group 15 is prototyping data stories and decision aids that help water managers study hydrologic extremes and plan resilient responses.

**[Project brief (PDF)](assets/Seven%20ways%20to%20measure%20fire%20polygon%20velocity-4.pdfa) · [View code](https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/blob/main/code/fired_time_hull_panel.ipynb) · [Explore data](https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/blob/main/code/prism_quicklook.py)**

> **About:** This is a public, in-progress record of a 3-day project at the Innovation Summit. Edit everything here in your browser: open a file → pencil icon → Commit changes.

---

## Day 1 — Define & Explore
*Focus: questions, hypotheses, context; add at least one visual (photo of whiteboard/notes).*
![initial whiteboard](https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/blob/main/documentation/images/Group15.png)
![revised whiteboard](https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/blob/main/documentation/images/revisedGroup15.png)
![more notes](https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/blob/main/documentation/images/Group15Notes.png)

### Our product 📣
This is a comparative study of the Snake, Green, and Wind River Basins in the western U.S. Our goal is to examine how hydrology, governance, and management interact within and across these basins. We are focusing on three main aspects: hydrology; water management, and socioeconomic/legal frameworks. We are intersted in how these aspects interact to influence snowpack, climate dynamics, and streamflow. Data sources include but are not limited to: USGS streamflow and groundwater records, NOAA/NCEI climate data, PRISM and/or Daymet for weather, calculated indices like NDWI, soils and soil moisture, and ESA WorldCover, amongst others.

### Our question(s) 📣
- How are current river management practices affecting communities and ecosystems?
- What is the response of river communities and ecosystems to hydrologic and meteorologic events?
- How do we measure response and resilience?

### Hypotheses / intentions [Optional: probably not relevant if you are creating an educational tool]
- We think that combining NOAA Atlas 14 design storms with updated climate projections will reveal emerging risk hotspots.
- We intend to test whether infrastructure-critical assets align with high social vulnerability scores.
- We will know we’re onto something if partners can quickly point to actionable “next step” mitigation actions from our visuals.

### Why this matters (the “upshot”) 📣
Extreme hydrologic events are becoming less predictable, stressing emergency management capacity. Highlighting the intersection of exposure, vulnerability, and infrastructure sensitivity helps local leaders justify investments in resilient design and community preparedness.

### Inspirations (papers, datasets, tools)
- Publication: [NOAA Atlas 14 Guidance](https://hdsc.nws.noaa.gov/hdsc/pfds/)
- Dataset portal: [USGS StreamStats](https://streamstats.usgs.gov/)
- Tool/tech: [FEMA Hazus flood mitigation library](https://www.fema.gov/flood-maps/tools-resources/hazus)

### Field notes / visuals
![Whiteboard brainstorm summarizing stakeholder questions](assets/day1_whiteboard.jpg)
[Raw photo location: day1_whiteboard.jpg](https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/blob/main/docs/assets/day1_whiteboard.jpg)
*Caption: Initial framing of community partners, target outcomes, and constraints.*

> **Different perspectives:** Capture alternative framings from emergency managers, hydrologists, and community leaders—they often surface new leverage points.

---

## Day 2 — Data & Methods
*Focus: what we’re testing and building; show a first visual (plot/map/screenshot/GIF).*

### Data sources we’re exploring 📣
<!-- EDIT: Link each source; add size/notes if relevant. -->
- **Source A**
- Source B — link and 1-line description

- **NOAA Atlas 14 extreme precipitation grids** — baseline design storms to benchmark current planning thresholds.

  ![Pattern revealed during exploration](assets/explore_data_plot.png)
  [Raw photo location: explore_data_plot.png](https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/blob/main/docs/assets/explore_data_plot.png)
  *Snapshot: 24-hour return-period rainfall values for pilot watersheds.*

- **NASA IMERG precipitation time series** — near-real-time anomaly tracking for event attribution.
- **US Census SVI indicators** — spatial context for vulnerable populations potentially affected by flash flooding.

### Methods / technologies we’re testing 📣
- Approach 1 (e.g., time-series break detection)
- Approach 2 (e.g., random forest on features)
- Visualization (e.g., map tiles, small multiples)

### Challenges identified
- Data gaps / quality issues
- Method limitations / compute constraints
- Open questions we need to decide on

### Methods / technologies we’re testing 📣
- Rainfall frequency adjustment factors derived from downscaled climate projections.
- Rapid flood exposure mapping using Google Earth Engine and publicly available elevation models.
- Lightweight dashboards assembled with Plotly Express for communicating uncertainty.

### Challenges identified
- Reconciling spatial resolution differences between gridded precipitation and community-level indicators.
- Limited compute time for running high-resolution hydrologic models within the sprint window.
- Need for vetted narratives that balance urgency with uncertainty when briefing decision makers.

### Visuals
<!-- EDIT: Swap examples; keep file sizes modest. -->

#### Static figure
![Initial exposure overlay of critical facilities and extreme rainfall thresholds](assets/figure1.png)
[Raw photo location: figure1.png](https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/blob/main/docs/assets/figure1.png)
*Figure 1.* One line on what this suggests.

#### Animated change (GIF)
![Animation of cumulative rainfall anomalies during a historic event](assets/change.gif)
[Raw photo location: change.gif](https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/blob/main/docs/assets/change.gif)
*Figure 2.* One line on what changes across time.

#### Interactive map (iframe)
<iframe
  title="Study area (OpenStreetMap)"
  src="https://www.openstreetmap.org/export/embed.html?bbox=-105.35%2C39.90%2C-105.10%2C40.10&layer=mapnik&marker=40.000%2C-105.225"
  width="100%" height="360" frameborder="0"></iframe>
<p><a href="https://www.openstreetmap.org/?mlat=40.000&mlon=-105.225#map=12/40.0000/-105.2250">Open full map</a></p>

> If an embed doesn’t load, place the standard link immediately below it.

---

## Final Share Out — Insights & Sharing
*Focus: synthesis; highlight 2–3 visuals that tell the story; keep text crisp. Practice a 2-minute walkthrough of the homepage 📣: Why → Questions → Data/Methods → Findings → Next.*

![Team photo at start of Day 3](assets/team_photo.jpg)
[Raw photo location: team_photo.jpg](https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/blob/main/docs/assets/team_photo.jpg)

### Findings at a glance 📣
<!-- EDIT: 2–4 bullets, each a headline in plain language with a number if possible. -->
- Headline 1 — what, where, how much
- Headline 2 — change/trend/contrast
- Headline 3 — implication for practice or policy
  
### Visuals that tell the story 📣
![Lead conclusion visual showing combined hazard and exposure](assets/fire_hull.png)
[Raw photo location: fire_hull.png](https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/blob/main/docs/assets/fire_hull.png)
*Visual 1.* Swap in the primary graphic that clearly communicates your core takeaway.

![Supporting panels summarizing risk tiers and response options](assets/hull_panels.png)
[Raw photo location: hull_panels.png](https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/blob/main/docs/assets/hull_panels.png)
*Visual 2.* Use a complementary panel, collage, or set of snapshots that reinforces supporting evidence.

![Complementary result comparing modeled and observed peak flows](assets/main_result.png)
[Raw photo location: main_result.png](https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/blob/main/docs/assets/main_result.png)
*Visual 3.* Highlight an additional visual that captures a secondary insight or next step.

<iframe
  title="Short explainer video (optional)"
  width="100%" height="360"
  src="https://www.youtube.com/embed/ASTGFZ0d6Ps"
  frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
  allowfullscreen></iframe>

### What’s next? 📣
- Immediate follow-ups
- What we would do with one more week/month
- Who should see this next

---

## Featured links (image buttons)
<table>
<tr>
<td align="center" width="33%">
  <a href="assets/Seven%20ways%20to%20measure%20fire%20polygon%20velocity-4.pdfa"><img src="assets/button_brief.gif" alt="Project brief PDF" width="240"><br><strong>Read the brief</strong></a>
</td>
<td align="center" width="33%">
  <a href="https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/blob/main/code/fired_time_hull_panel.ipynb"><img src="assets/button_code.gif" alt="View code" width="240"><br><strong>View code</strong></a>
</td>
<td align="center" width="33%">
  <a href="https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/blob/main/code/prism_quicklook.py"><img src="assets/button_data.gif" alt="Explore data" width="240"><br><strong>Explore data</strong></a>
</td>
</tr>
</table>

---

## Team
| Name | Role | Contact | GitHub |
|------|------|---------|--------|
| Jane Doe | Lead | jane.doe@example.org | @janedoe |
| John Smith | Analyst | john.smith@example.org | @jsmith |

---

## Storage

Code
Keep shared scripts, notebooks, and utilities in the [`code/`](https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/tree/main/code) directory. Document how to run them in a README or within the files so teammates and visitors can reproduce your workflow.

Documentation
Use the [`docs/`](https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/tree/main/docs) folder to publish project updates on this site. Longer internal notes can live in [`documentation/`](https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15/tree/main/documentation); summarize key takeaways here so the public story stays current.

---

## Cite & reuse
If you use these materials, please cite:

> Innovation Summit 2025 Team 15. (2025). *Resilience for Rare Hydrologic Events Management*. https://github.com/CU-ESIIL/resilience-rare-hydrologic-events-management-innovation-summit-2025__15

License: CC-BY-4.0 unless noted. See dataset licenses on the **[Data](data.md)** page.

---

<!-- EDIT HINTS
- Upload images to docs/assets/ and reference as assets/filename.png
- Replace placeholder content with your team's updates after each sprint session.
- Summaries should be short and action-focused so visitors can quickly understand your progress.
-->
