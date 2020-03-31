{smcl}
{* *! version 1.0.2  15mar2017}{...}
{vieweralsosee "undocumented" "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] import dbase" "help import dbase"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{viewerjumpto "Syntax" "import_shp##syntax"}{...}
{viewerjumpto "Description" "import_shp##description"}{...}
{viewerjumpto "Options" "import_shp##options"}{...}
{viewerjumpto "Examples" "import_shp##examples"}{...}
{title:Title}

{p 4 22 2}
{hi:[D] import shp} {hline 2} Import and export a shapefile


{marker syntax}{...}
{title:Syntax}

{phang}
Load a shapefile

{p 8 16 2}
{cmd:import} {cmd:shp} [{cmd:using}] {it:{help filename}}
[{cmd:,} {opt clear}]


{phang}
Save data in memory to a shapefile

{p 8 16 2}
{cmd:export} {cmd:shp} [{cmd:using}] {it:{help filename}}
[{cmd:,} {opt replace}]


{pstd}
If {it:{help filename}} is specified without an extension, then {cmd:.shp} is
assumed for both {cmd:import shp} and {cmd:export shp}.  If {it:filename}
contains embedded spaces, enclose it in double quotes.


{marker description}{...}
{title:Description}

{pstd}
{cmd:import shp} reads into memory a shapefile ({cmd:.shp}).  Shapefiles are
the nontopological format for storing the geometric location and attribute
information of geographic features.  Geographic features in a shapefile may be
represented by points, lines, or polygons (areas).  Shapefiles are usually
paired with  dBase files, which can store additional attributes that can be
joined to shapefile's features.  See {helpb import dbase} for information
about importing dBase files into Stata.

{pstd}
Stata has other commands for importing data.  If you are not sure that
{cmd:import shp} will do what you need, see
{manhelp import D} and {findalias frdatain}.


{marker options}{...}
{title:Options}

{phang}
{opt clear} is for use with {cmd:import shp} and specifies that it is okay to
replace the data in memory, even though the current data have not been saved
to disk.

{phang}
{opt replace} is for use with {cmd:export shp} and specifies that
{it:{help filename}} be replaced if it already exists.


{marker examples}{...}
{title:Examples}

{pstd}
Read file {cmd:point.shp} into memory{p_end}
{phang2}{cmd:. import shp point}

{pstd}
Export shapefile in memory to file {bf:mypoint.shp}{p_end}
{phang2}{cmd:. export shp mypoint}
{p_end}
