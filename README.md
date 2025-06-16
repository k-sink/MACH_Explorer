# 🔹 MACH EXPLORER DESKTOP APPLICATION 🔹

The Mach Explorer is a desktop application developed in tandem with the MACH dataset (Sink et al, 2025). This app allows users to navigate
and manipulate the MACH dataset, which contains daily climate and streamflow data (1980-2023) and catchment attributes for 1,014 watersheds, along with 
daily climate and streamflow data (1949-1979) for 395 watersheds within the United States.  

<br>

## 🔹DATASET IMPORT TAB
Enables the application to access timeseries data located on a user's local machine. The folder location(s) are necessary for the data tabs. Only time series data needs to be downloaded. All other data is included with the app with 
the exception of the detailed dam information, which can be found on zenodo. 

### Data Import
**The Daily Data, Monthly Data, and Annual Data tabs use data from the MACH timeseries.** 
* Prior to utilizing any of these tabs, download the  *MACH_ts.zip*  folder from https://zenodo.org/records/15311986.
* Unzip the folder to your local machine, making sure to retain the 'MACH_ts' folder name and the 1,014 csv files within.

**The MOPEX tab uses data from the MOPEX timeseries.**
* Prior to utilizing this tab, download the *MOPEX_ts.zip* folder from https://zenodo.org/records/15311986.
* Unzip the folder to your local machine, making sure to retain the 'MOPEX_ts' folder name and the 395 csv files within.

### Locate Files
* Click on the 'BROWSE FOR MACH DATA FOLDER' button to establish the filepath to the MACH timeseries folder.
* Click on the 'BROWSE FOR MOPEX DATA FOLDER' button to establish the filepath to the MOPEX timeseries folder. 

<br>

## 🔹SITE SELECTION TAB
Allows users to filter and select watersheds (sites) from the MACH dataset. ***All subsequent tabs retrieve data based on the sites selected here.***

### USGS Stream Gauging Site Locations
The Leaflet map displays the sites listed in the 'Selected Stream Gauging Sites' table. The locations represent the latitude and longitude for the USGS stream gauging site. Clicking directly on a blue point will display a pop-up box
that includes the 8-digit gauge id, the gauge name, and the coordinates. The map display will update automatically as filtering criteria are selected. 
* Basemap options include the 'OpenStreetMap' and 'EsriTopo'.
* Basin delineations can be toggled on/off using the Basin Delineations box. 

### Filter Sites
The 1,014 watersheds can be filtered using one or more of the spatial filters available. 
* State: Select site(s) by state using the dropdown menu. Allows for multiple selections. Click in the box and use backspace to remove a selection.
* Latitude (N): Select site(s) by latitude range in decimal degrees.
* Longitude (W): Select site(s) by longitude range in decimal degrees.
* Mean Elevation: Select site(s) by mean elevation in meters above sea level.
* Drainage Area: Select site(s) by basin drainage area in square kilometers.
* Mean Slope: Select site(s) by mean slope in percent.
* The RESET FILTERS button will clear all selected filters, displaying all 1,014 sites.

### Edit Site Selections
Manually add or remove a site by entering the site number. This allows users to refine their selections. 
* Manually Add Site: Enter 8-digit site number (leading zeros are not required) and then click the ADD SITE button.
* Manually Remove Site: Enter 8-digit site number and then click the REMOVE SITE button.
* The REMOVE ALL SITES button will clear all sites, resulting in a blank map display and tables.
* The RESET FILTERS button can be pressed at any time to display all 1,014 sites.

### Selected Stream Gauging Sites
* This table displays the sites based on 'Filter Sites' and 'Edit Site Selections' information.
* The displayed attributes include the USGS site number (SITENO), Name, State, Latitude, Longitude, Elevation, Area, and Slope. 

### Stream Discharge Record
* This table displays the selected sites and the streamflow record information, which includes the number of records (count_rec), the first and last available dates, and the number of records for each calendar year
(365 days or 366 days for leap years represent a complete year). A complete record will have 16,071 streamflow days. Missing streamflow records in retrieved data will be shown as NA. 
* The number of displayed records (entries) options are 5, 10, 20, or 50 using the drop down.
* The diamond buttons next to the column headers can be used to sort the column values.

<br>

## 🔹DAILY DATA TAB
Returns daily data values for the filtered sites chosen in the 'Site Selection' tab. The RETRIEVE AND VIEW DATA button must be pressed to retrieve data and whenever variable or time period selections are modified. 
Please note that retrieving large amounts of daily data (millions of records) will take the program a few minutes. Any additional actions during this retrieval period are not recommended because they will be delayed. 
**The MACH_ts data folder must be downloaded and extracted prior to utilizing this tab. The filepath is established using the BROWSE FOR MACH DATA FOLDER button on the Dataset Import tab.**

### Select Variable(s)
Click in the box to select a variable. Variables can be filtered by range using the slider bars, which defaults to all available data values.
* Precipitation (PRCP): total daily precipitation in millimeters per day, sum of all forms converted to water equivalent.
* Mean Temperature (TAIR): mean daily air temperature in degrees Celsius.
* Minimum Temperature (TMIN): minimum daily air temperature in degrees Celsius.
* Maximum Temperature (TMAX): maximum daily air temperature in degrees Celsius.
* Potential Evapotranspiration (PET): total daily potential evapotranspiration in millimeters per day.
* Actual Evapotranspiration (AET): total daily actual evapotranspiration in millimeters per day.
* Observed Discharge (OBSQ): total daily streamflow discharge in millimeters per day. Converted from cubic feet per second using basin drainage area.
* Snow Water Equivalent (SWE): snow water equivalent in millimeters (equal to kilograms per square meter), the amount of water contained within the snowpack.
* Shortwave Radiation (SRAD): incident shortwave radiation flux density in watts per square meter, average over the daylight period of the day.
* Water Vapor Pressure (VP): daily average partial pressure of water vapor in pascals.
* Day Length (DAYL): duration of the daylight period in seconds per day, based on the period of the day during which the sun is above a hypothetical flat horizon.

### Select Time Period(s)
Daily data can be filtered temporally using one or more options. Retrieval will default to the entire record. 
* Date Range: select a beginning and ending date.
* Calendar Year: select one or more calendar years (January to December). If used with the Date Range and a selected year falls outside of the calendar range, that year will not be returned. 
* Month: select one or more months.

### Filtered Daily Data 
This table will display the site number, date, and selected variables. Note that streamflow data may be incomplete and display as a blank cell. Missing records will be indicated by NA in exported files.  

### Download Daily Data 
* The EXPORT AS CSV button will download the data displayed in the table as one single csv file.
* The EXPORT AS SEPARATE CSV FILES button will download the data displayed in the table as separate csv files for each site, compressed into a single zip file.

<br>

## 🔹MONTHLY DATA TAB
Returns daily data values by month for the filtered sites chosen in the 'Site Selection' tab. The RETRIEVE AND VIEW DATA button must be pressed to retrieve data and whenever variable or time period selections are modified. 
**The MACH_ts data folder must be downloaded and extracted prior to utilizing this tab. The filepath is established using the BROWSE FOR MACH DATA FOLDER button on the Dataset Import tab.**

### Select Statistic
Use the drop down to select a statistic for the data. Defaults to mean. 
* Mean: overall daily mean value for each month.
* Minimum: overall daily minimum value for each month.
* Maximum: overall daily maximum value for each month.
* Median: overall daily median value for each month.
* Total: overall total of daily values for each month. Note that for any temperature variables (TAIR, TMIN, TMAX), this option will return the mean.

### Select Variable(s)
Select one or more variables to retrieve. No range options. 

### Select Time Period(s)
Daily data can be filtered temporally using one or more options. Retrieval will default to the entire record. 
* Calendar Year: select one or more calendar years.
* Month: select one or more months. 

### Filtered Monthly Data 
This table will display the site number, calendar year, month, and selected variables. Note that streamflow data may be incomplete and display as a blank cell. Missing records will be indicated by NA in exported files.  

### Download Monthly Data 
* The EXPORT AS CSV button will download the data displayed in the table as one single csv file.
* The EXPORT AS SEPARATE CSV FILES button will download the data displayed in the table as separate csv files for each site, compressed into a single zip file.

<br>

## 🔹ANNUAL DATA TAB
Returns daily data values by year for the filtered sites chosen in the 'Site Selection' tab. The RETRIEVE AND VIEW DATA button must be pressed to retrieve data and whenever variable or time period selections are modified. 
**The MACH_ts data folder must be downloaded and extracted prior to utilizing this tab. The filepath is established using the BROWSE FOR MACH DATA FOLDER button on the Dataset Import tab.**

### Annual Aggregation
Use the radio button to select aggregation of daily data over water year (October 1 to September 30) or calendar year. Defaults to water year. 

### Select Statistic
Use the drop down to select a statistic for the data. Defaults to mean. 
* Mean: overall daily mean value for each year.
* Minimum: overall daily minimum value for each year.
* Maximum: overall daily maximum value for each year.
* Median: overall daily median value for each year.
* Total: overall total of daily values for each year. Note that for any temperature variables (TAIR, TMIN, TMAX), this option will return the mean.

### Select Variable(s)
Select one or more variables to retrieve. No range options. 

### Select Time Period(s)
Daily data can be filtered temporally by year and the available option will reflect the aggregation selection. Retrieval will default to the entire record. 
* Calendar Year: select one or more calendar years.
* Water Year: select one or more water years. 

### Filtered Annual Data 
This table will display the site number, calendar year or water year, and selected variables. Note that streamflow data may be incomplete and display as a blank cell. Missing records will be indicated by NA in exported files.  

### Download Annual Data 
* The EXPORT AS CSV button will download the data displayed in the table as one single csv file.
* The EXPORT AS SEPARATE CSV FILES button will download the data displayed in the table as separate csv files for each site, compressed into a single zip file.

<br>

## 🔹MOPEX TAB
Returns daily data values (January 1, 1948 to December 31, 1979) for watersheds derived from the original MOPEX dataset. The sites are returned based on the 'Site Selection' tab. 
Any filtered sites with site numbers also present in the 395 original MOPEX watersheds included in the MACH dataset will be retrieved. No data will be returned if none of the 
'Selected Stream Gauging Sites' appear in MOPEX. Variables returned are precipitation in millimeters (PRCP), observed streamflow discharge in millimeters (OBSQ), minimum air temperature in 
degrees Celsius (TMIN), and maximum air temperature in degrees Celsius (TMAX). **The MOPEX_ts data folder must be downloaded and extracted prior to utilizing this tab. The filepath is 
established using the BROWSE FOR MOPEX DATA FOLDER button on the Dataset Import tab.** If the MOPEX & MACH export option is selected, the MACH_ts data must also be downloaded and extracted. 

### Select Export Option
Select an export option for the MOPEX data using the drop down. Only one selection can be made. Defaults to MOPEX only. 
* If 'MOPEX only' is selected, daily values for 1948-1979 will be returned for the available MOPEX sites in the filtered site results.
* If 'MOPEX & MACH' is selected, daily values for 1980-2023 from MACH will be appended to the MOPEX data from 1948-1979 and returned for the available MOPEX sites in the filtered site results.
* The RETRIEVE AND VIEW DATA button must be pressed to retrieve data and if the export option is changed.

### MOPEX Basins Data
This table will display the site number, date, and all variables for the applicable MOPEX sites. Note that data may be incomplete and display as a blank cell. Missing records will be indicated by NA in exported files.  

### Download MOPEX
* The EXPORT AS CSV button will download the data displayed in the table as one single csv file.
* The EXPORT AS SEPARATE CSV FILES button will download the data displayed in the table as separate csv files for each site, compressed into a single zip file.

<br>

## 🔹ATTRIBUTES TAB
Returns catchments attributes for filtered sites chosen in the 'Site Selection' tab. Attribute data does NOT need to be downloaded for this tab. 

### Select Attribute Type 
Attributes can be retrieved by type using the radio button. Only one selection can be made at a time. 
* Single Value per Site: returns a single value for an attribute or characteristic for the period of record (1980 to 2023).
* Monthly Value per Site: returns attributes or characteristics on a monthly scale, representing the average of that month for the period of record.
* Annual Value per Site: returns attributes or characteristics on an annual scale, representing the average of that year for the period of record.

### Select Site Attribute(s)
Available attributes will change depending on the 'Select Attribute Type' option chosen. Multiple attribute selections can be made. The RETRIEVE ATTRIBUTES button must be pressed if selections are changed. Please refer to the README.csv file for detailed attribute information including descriptions of the names displayed in the drop down menus. The csv is available from https://zenodo.org/records/15311986. 
* Overall Site Attributes 
  * *Catchment*: site number, COMID, dataset, hydrologic unit, station name, state, latitude, longitude, gauge altitude, slope, elevation, drainage area, upstream sites, number of upstream sites, time zone. 
  * *Climate*: 30-year mean annual precipitation, min/max/mean temperature, potential evapotranspiration, actual evapotranspiration (1981-2010, 1991-2020), percentage of days when tmin/tmax <10th percentile,  tmin/tmax >90th percentile (1980-2023).
  * *Hydrology*: mean stream slope, total stream length, stream density, sinuosity, base flow index, average depth to water table, estimated recharge, saturation overland flow, topographic wetness index, infiltration-excess overland flow, contact time, R factor, FDSS: L-moment coefficient of variation, skewness, kurtosis, autoregressive lag one correlation coefficient, amplitude of seasonal signal, phase of seasonal signal, mean daily streamflow, slope of flow duration curve, mean half-flow date, 5% flow quantile, 95% flow quantile, frequency of high-flow/low-flow days, average duration of high-flow/low-flow events, frequency of zero flow days.
  * *Soil*: soil texture (n=3), percent by weight (n=4), hydrologic group (HG) based on infiltration rates (n=10), soil erodibility, permeability, thickness, water capacity, bulk density, salinity, pH. 
  * *Geology*: percent of catchment underlain by principal water yielding aquifers rock type (n=7), percent of catchment underlain by shallowest aquifer group (AQ) based on location (n=63), geology type based on generalized lithology (n=10), percent of catchment overlain by surficial sediment (SOLLER) based on material type and thickness (n=50).
  * *Regional*: hydrologic landscape regions (HLR) based on similar land surface form, geologic texture, and climate characteristics (n=20), physiographic divisions (PHYSIO) based on common topography, rock types/ structure, and geologic/geomorphic history (n=25).
  * *Anthropogenic*: population density (n=3), road density (n=14), Reference or non-reference watershed classification, annual data report information and screening comments (GAGESII), number of dams per catchment, maximum and minimum storage for all dams in catchment (NID). 
* Monthly Site Attributes
  * Monthly maximum value of daily max temp/daily min temp, monthly minimum value of daily max temp/daily min temp, monthly mean temperature difference. 
* Annual Site Attributes
  * Number of consecutive wet/dry days, cold spell duration index, frost days, growing season length, icing days, zero precipitation, precipitation ≥ 1mm/10mm/20mm, summer days, tropical nights, wet spell duration index, standardized precipitation evapotranspiration index, standardized precipitation index, total precipitation >95th percentile, > 99th, simple duration intensity index.  

### Selected Attributes
This table will display the site number and all attributes selected for the filtered sites. 

### Download Attributes
* Export the attributes displayed in the table as a single csv file.

<br>

## 🔹LAND COVER TAB
Returns land cover percent coverage for filtered sites chosen in the 'Site Selection' tab. Land cover data does NOT need to be downloaded for this tab. 

### Select Calendar Year(s)
Select one or more calendar years for land cover data. Data availability begins in 1985. 

### Select Land Cover Class(es)
Select one or more land cover classes. 
* Open Water (11): Areas of open water, generally with less than 25% cover of vegetation or soil.
* Perennial Ice/Snow (12): Areas characterized by a perennial cover of ice and/or snow, generally greater than 25% of total cover.
* Developed, Open Space (21): Areas with a mixture of some constructed materials, but mostly vegetation in the form of lawn grasses. Impervious surfaces account for less than 20% of total cover. 
* Developed, Low Intensity (22): Areas with a mixture of constructed materials and vegetation. Impervious surfaces account for 20% to 49% percent of total cover. 
* Developed, Medium Intensity (23): Areas with a mixture of constructed materials and vegetation. Impervious surfaces account for 50% to 79% of the total cover. 
* Developed, High Intensity (24): Highly developed areas where people reside or work in high numbers. Impervious surfaces account for 80% to 100% of the total cover.
* Barren (31): Areas of bedrock, desert pavement, scarps, talus, slides, volcanic material, glacial debris, sand dunes, strip mines, gravel pits and other accumulations of earthen material. Generally, vegetation accounts for less than 15% of total cover.
* Deciduous Forest (41): Areas dominated by trees generally greater than 5 meters tall, and greater than 20% of total vegetation cover. More than 75% of the tree species shed foliage simultaneously in response to seasonal change.
* Evergreen Forest (42): Areas dominated by trees generally greater than 5 meters tall, and greater than 20% of total vegetation cover. More than 75% of the tree species maintain their leaves all year. Canopy is never without green foliage.
* Mixed Forest (43): Areas dominated by trees generally greater than 5 meters tall and greater than 20% of total vegetation cover. Neither deciduous nor evergreen species are greater than 75% of total tree cover.
* Shrubland (52): Areas dominated by shrubs; less than 5 meters tall with shrub canopy typically greater than 20% of total vegetation. 
* Grassland (71): Areas dominated by graminoid or herbaceous vegetation, generally greater than 80% of total vegetation. These areas are not subject to intensive management such as tilling but can be utilized for grazing.
* Pasture/Hay (81): Areas of grasses, legumes, or grass-legume mixtures planted for livestock grazing or the production of seed or hay crops, typically on a perennial cycle. Pasture/hay vegetation accounts for greater than 20% of total vegetation.
* Cultivated Crops (82): Areas used for the production of annual crops and also perennial woody crops. Crop vegetation accounts for greater than 20% of total vegetation. This class also includes all land being actively tilled.
* Woody Wetlands (90): Areas where forest or shrubland vegetation accounts for greater than 20% of vegetative cover and the soil or substrate is periodically saturated with or covered with water.
* Emergent Herbaceous Wetlands (95): Areas where perennial herbaceous vegetation accounts for greater than 80% of vegetative cover and the soil or substrate is periodically saturated with or covered with water.

### Selected Land Cover Data
This table displays the site number, year, and selected land cover classes (percent of total basin area) for filtered sites. 

### Download Attributes
Land cover attributes will be downloaded for all sites as a single csv file. 

<br>

## 🔹DOCUMENTATION
The MACH Explorer and the MACH dataset were developed by Katharine Sink and are detailed in the following publication (TBD). Please send any questions or comments to katharine.sink@utdallas.edu :sunglasses:
Dataset Citation: Sink, K. (2025). MACH hydrometeorological dataset for 1,014 catchments in the United States (1.0) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.15311986. This app uses data downloaded and processed from the following sources: 

### App Development
* Shiny R package https://shiny.posit.co/
* Electron https://www.electronjs.org/

### Climate
* Daymet: Daily Surface Weather Data on a 1-km Grid for North America, Version 4 R1 https://doi.org/10.3334/ORNLDAAC/2129, available at https://daymet.ornl.gov/
* Gleam: Miralles, D.G., Bonte, O., Koppa, A., Baez-Villanueva, O.M., Tronquo, E., Zhong, F., Beck, H.E., Hulsman, P., Dorigo, W.A., Verhoest, N.E.C., Haghdoost, S.,  GLEAM4: global land evaporation and soil moisture dataset at 0.1° resolution from 1980 to near present, Scientific Data, 12, 416, 2025, available at https://www.gleam.eu/#home
* MOPEX: Schaake, J, Cong, S, & Duan, Q (2006). U.S. MOPEX DATA SET. IAHS Publication Series, vol. 307, N/A, November 1, 2006, pp. 9-28

### Streamflow
* U.S. Geological Survey National Water Information System, available at https://waterdata.usgs.gov/nwis

### Attributes
* U.S. Geological Survey NHDPlus Version 2.1: McKay, L., Bondelid, T., Dewald, T., Johnston, J., Moore, R., and Rea, A., 2012, NHDPlus Version 2: User Guide, https://www.epa.gov/waterdata/nhdplus-national-hydrography-dataset-plus 
* Multi-Resolution Land Characteristics Consortium (MRLC): U.S. Geological Survey (USGS), 2024, Annual NLCD Collection 1 Science Products: U.S. Geological Survey data release, https://doi.org/10.5066/P94UXNTS
* U.S. Army Corps of Engineers (USACE) National Inventory of Dams (NID), available at https://nid.sec.usace.army.mil/#/



