# MACH EXPLORER DESKTOP APPLICATION

The Mach Explorer is a desktop application developed in tandem with the MACH dataset (Sink et al, 2025). This app allows users to navigate
and manipulate the MACH dataset, which contains daily climate and streamflow data (January 1, 1980 to December 31, 2023) along with catchment attributes for 1,014 watersheds within 
the United States. 


## DATASET IMPORT TAB
Enables the application to access timeseries data located on a user's local machine. The folder location(s) are necessary for the data tabs. 

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



## SITE SELECTION TAB
Allows users to filter and select watersheds (sites) from the MACH dataset. ***All subsequent tabs retrieve data based on the sites selected here.***

### USGS Stream Gauging Site Locations
The Leaflet map displays the sites listed in the 'Selected Stream Gauging Sites' table. The locations represent the latitude and longitude for the USGS stream gauging site. Clicking directly on a blue point will display a pop-up box
that includes the 8-digit gauge id, the gauge name, and the coordinates. The map display will update automatically as filtering criteria are selected. 
* Basemap options include the 'OpenStreetMap' and 'EsriTopo' and the basin delineations can be toggled on/off using the Basin Delineations box. 

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


## DAILY DATA TAB
Returns daily data values for the filtered sites chosen in the 'Site Selection' tab. The RETRIEVE AND VIEW DATA button must be pressed to retrieve data and whenever variable or time period selections are modified. 
Please note that retrieving large amounts of daily data (millions of records) will take the program a few minutes. Any additional actions during this retrieval period are not recommended because they will be delayed. 

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


## MONTHLY DATA TAB
Returns daily data values by month for the filtered sites chosen in the 'Site Selection' tab. The RETRIEVE AND VIEW DATA button must be pressed to retrieve data and whenever variable or time period selections are modified. 

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


## ANNUAL DATA TAB
Returns daily data values by year for the filtered sites chosen in the 'Site Selection' tab. The RETRIEVE AND VIEW DATA button must be pressed to retrieve data and whenever variable or time period selections are modified. 

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


## MOPEX TAB
Returns daily data values (January 1, 1948 to December 31, 1979) for watersheds derived from the original MOPEX dataset. The sites are returned based on the 'Site Selection' tab. 
Any filtered sites with site numbers also present in the 395 original MOPEX watersheds included in the MACH dataset will be retrieved. No data will be returned if none of the 
'Selected Stream Gauging Sites' appear in MOPEX. Variables returned are precipitation in millimeters (PRCP), observed streamflow discharge in millimeters (OBSQ), minimum air temperature in 
degrees Celsius (TMIN), and maximum air temperature in degrees Celsius (TMAX). 

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

