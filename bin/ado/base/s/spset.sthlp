{smcl}
{* *! version 1.1.6  31jul2019}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spset" "mansection SP spset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro 3" "mansection SP Intro3"}{...}
{vieweralsosee "[SP] Intro 4" "mansection SP Intro4"}{...}
{vieweralsosee "[SP] Intro 5" "mansection SP Intro5"}{...}
{vieweralsosee "[SP] Intro 6" "mansection SP Intro6"}{...}
{vieweralsosee "[SP] Intro 7" "mansection SP Intro7"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] spbalance" "help spbalance"}{...}
{vieweralsosee "[SP] spdistance" "help spdistance"}{...}
{vieweralsosee "[SP] spshape2dta" "help spshape2dta"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "spset##syntax"}{...}
{viewerjumpto "Menu" "spset##menu"}{...}
{viewerjumpto "Description" "spset##description"}{...}
{viewerjumpto "Links to PDF documentation" "spset##linkspdf"}{...}
{viewerjumpto "Options" "spset##options"}{...}
{viewerjumpto "Examples" "spset##examples"}{...}
{viewerjumpto "Stored results" "spset##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[SP] spset} {hline 2}}Declare data to be Sp spatial data{p_end}
{p2col:}({mansection SP spset:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Display the current setting

{p 12 16 2}
{cmd:spset}


{phang}
Set data with shapefiles

{p 12 56 2}
{cmd:spshape2dta} ...{space 26}(see {manhelp spshape2dta SP})


{phang}
Set data without shapefiles

{p 12 16 2}
{cmd:spset} {it:idvar} [{cmd:,}
{help spset##options_table:{it:options}}]


{phang}
Modify how data are set with shapefiles

{p 12 56 2}
{cmd:spset} [{it:idvar}]{cmd:,} {cmd:modify}
[{help spset##shpmodoptions:{it:shpmodoptions}}]


{phang}
Modify how data are set without shapefiles

{p 12 16 2}
{cmd:spset}{cmd:,} {cmd:modify}
[{help spset##modoptions:{it:modoptions}}]


{phang}
Clear the setting

{p 12 16 2}
{cmd:spset,} {cmd:clear}


{phang}
  {it:idvar} is an existing, numeric variable that uniquely 
      identifies the geographic units, meaning the observations
      in cross-sectional data and the panels in panel data.

{phang}
   {it:shapefile} refers to a Stata-format shapefile, specified 
      with or without the {cmd:.dta} suffix.  Such files usually
      have names of the form {it:name}{cmd:_shp.dta}.

{marker options_table}{...}
{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt :{opt coord(xvar yvar)}}designate {it:xvar} and {it:yvar} as the location coordinates{p_end}
{synopt :{opth coordsys:(spset##coordsys:coordsys)}}specify how coordinates are interpreted{p_end}
{synoptline}

{marker shpmodoptions}{...}
{synopthdr:shpmodoptions}
{synoptline}
{synopt :{opth coordsys:(spset##coordsys:coordsys)}}change how coordinates are interpreted{p_end}
{synopt :{opt noshpfile}}break link with shapefile{p_end}
{synopt :{opt replace}}replace current geographic identifier with {it:idvar}{p_end}
{synoptline}

{marker modoptions}{...}
{synopthdr:modoptions}
{synoptline}
{synopt :{opt coord(xvar yvar)}}replace location coordinates with {it:xvar} and {it:yvar}{p_end}
{synopt :{opth coordsys:(spset##coordsys:coordsys)}}change how coordinates are interpreted{p_end}
{synopt :{opt nocoord}}clear coordinate settings{p_end}
{synopt :{opt shpfile(shapefile)}}establish link to shapefile{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
Data must be {cmd:spset} before you can use the other Sp commands.
The {cmd:spset} command serves three purposes:

{phang2}
1.  It reports whether the data are {cmd:spset} and if so, how.

{phang2}
2.  It sets the spatial data for the first time.

{phang2}
3.  It modifies how the data are {cmd:spset} at any time.

{pstd}
Data that are {cmd:spset} are called Sp data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spsetQuickstart:Quick start}

        {mansection SP spsetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt coord(xvar yvar)} and {cmd:nocoord}
 specify coordinates.  {cmd:coord()} specifies the variables
 recording the x and y coordinates or the longitude and
 latitude.  {cmd:nocoord} specifies that previously
 set coordinates be forgotten.

{pmore}
 {opt coord(xvar yvar)} creates or replaces the 
 contents of Sp variables {cmd:_CX} and {cmd:_CY}.
  
{pmore}
 {opt coord()} and {opt nocoord} are allowed only if the data
 are not linked to a shapefile.  If you want to use different
 coordinates than the shapefile provides, break the connection
 to the shapefile by typing

{pmore3}
{cmd:. spset, modify noshpfile}

{pmore}
 and then use {cmd:spset,} {cmd:modify} {opt coord(xvar yvar)}.
 You can later use {cmd:spset,} {cmd:modify} {opt shpfile(shapefile)}
 to reestablish the link.  Relinking to the shapefiles reestablishes the
 original coordinates stored in {cmd:_CX} and {cmd:_CY}.

{marker coordsys}{...}
{phang}
{opt coordsys(coordsys)} 
specifies how to interpret coordinates.  You may
specify {cmd:coordsys()} regardless of whether you are linked to a shapefile.
{cmd:coordsys()} syntax is

            {cmd:coordsys(planar)}               (default)
            {cmd:coordsys(latlong)}              (kilometers implied)
            {cmd:coordsys(latlong, kilometers)}
            {cmd:coordsys(latlong, miles)}

{pmore}
 {cmd:coordsys(latlong)} specifies latitude and longitude
 coordinates.  {cmd:kilometers} and {cmd:miles} specify 
 the units in which distances should be calculated.
 Distances for {cmd:planar} coordinates are always in the 
 units of the planar coordinates.

{phang}
{opt modify} 
  specifies that existing {opt spset} settings are 
  to be modified.  Omitting {opt modify} means that the data 
  are being {opt spset} for the first time.

{pmore}
  You can modify Sp settings as often as you wish.

{phang}
{opt clear} 
   clears all Sp settings.  It drops the variables {cmd:_ID}, 
   {cmd:_CX}, and {cmd:_CY} that {opt spset} previously created.

{phang}
{opt replace} replaces the current geographic identifier with {it:idvar}.

{phang}
{opt noshpfile} 
breaks the link to the Stata-format shapefile, the file that
usually has {it:shapefile}{cmd:_shp.dta}.  Data that were
linked to a shapefile will be just as if they had never been
linked to it.  Before breaking the link, you should make a note of
the shapefile's name:

           {cmd:. spset}          (make a note of the shapefile's name)
           {cmd:. spset, modify noshpfile}

{pmore}
The shapefile might have been named {it:shapefile}{cmd:_shp.dta}.
You will need the name later should you wish to reestablish the 
link.

{phang}
{opt shpfile(shapefile)} and {opt drop} are for linking or relinking to a
shapefile.  To reestablish the link to the shapefile that was just
unlinked above, you would type

            {cmd:. spset, modify shpfile(}{it:shapefile}{cmd:_shp)}

{pmore}
The shapefile will be relinked, and the coordinates stored in
{cmd:_CX} and {cmd:_CY} will be restored.

{pmore}
{opt shpfile()} will refuse to link the shapefile if the data in memory
contain observations for {cmd:_ID} values not found in the shapefile.  In this
case, specify {opt shpfile()} and {opt drop} if you are willing to drop the
extra observations from the data in memory.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/homicide1990.dta .}
{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/homicide1990_shp.dta .}
{p_end}
{phang2}{cmd:. use homicide1990}
{p_end}

{pstd}Check the Sp setting of the data{p_end}
{phang2}{cmd:. spset}
{p_end}

{pstd}Convert the coordinates to latitude and longitude and measure
the distance in miles{p_end}
{phang2}{cmd:. spset, modify coordsys(latlong, miles)}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:spset} stores the following in {cmd:r()}:

{synoptset 24 tabbed}{...}
{p2col 5 24 28 2: Macros}{p_end}
{synopt:{cmd:r(sp_ver)}}{cmd:1}{p_end}
{synopt:{cmd:r(sp_id)}}{cmd:_ID}{p_end}
{synopt:{cmd:r(sp_id_var)}}{it:varname} or empty{p_end}
{synopt:{cmd:r(sp_shp_dta_path)}}path to {cmd:_shp.dta} file{p_end}
{synopt:{cmd:r(sp_shp_dta)}}{it:shapefile}{cmd:_shp.dta}{p_end}
{synopt:{cmd:r(sp_cx)}}{cmd:_CX} or empty{p_end}
{synopt:{cmd:r(sp_cy)}}{cmd:_CY} or empty{p_end}
{synopt:{cmd:r(sp_coord_sys)}}{cmd:planar} or {cmd:latlong}{p_end}
{synopt:{cmd:r(sp_coord_sys_dunit)}}{cmd:kilometers} or {cmd:miles} if
{cmd:r(sp_coord_sys)} = {cmd:latlong}{p_end}
{p2colreset}{...}
