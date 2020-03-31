{smcl}
{* *! version 1.0.8  17may2019}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spcompress" "mansection SP spcompress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] compress" "help compress"}{...}
{viewerjumpto "Syntax" "spcompress##syntax"}{...}
{viewerjumpto "Menu" "spcompress##menu"}{...}
{viewerjumpto "Description" "spcompress##description"}{...}
{viewerjumpto "Links to PDF documentation" "spcompress##linkspdf"}{...}
{viewerjumpto "Option" "spcompress##option"}{...}
{viewerjumpto "Example" "spcompress##example"}{...}
{viewerjumpto "Stored results" "spcompress##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[SP] spcompress} {hline 2}}Compress Stata-format
shapefile{p_end}
{p2col:}({mansection SP spcompress:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:spcompress}
[{cmd:,} {cmd:force}]


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spcompress} creates a new Stata-format shapefile omitting places
(geographical units) that do not appear in the Sp data in memory.  The
new shapefile will be named after the data in memory.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spcompressQuickstart:Quick start}

        {mansection SP spcompressRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt force} allows replacing an existing shapefile.  {opt force} is the option
name StataCorp uses when you should think twice before specifying it.  In
most cases, you want to create a new shapefile.


{marker example}{...}
{title:Example}

{pstd}
In your browser, search for "shapefile U.S. counties census".  From the
results, select
{browse "https://catalog.data.gov/dataset/tiger-line-shapefile-2016-nation-u-s-current-county-and-equivalent-national-shapefile":{it:TIGER/Line Shapefile, 2016, nation, U.S., Current County and Equivalent National Shapefile}}.
On the resulting page, click to download the {bf:Shapefile Zip File} from the
{bf:Downloads & Resources} section.  File {cmd:tl_2016_us_county.zip} is
downloaded to the {cmd:Downloads} directory on our computer.

{pstd}
You must be in the {cmd:Downloads} directory (that is, the same directory as
this file) to run the spatial commands.

{pstd}Dataset setup{p_end}
{phang2}{cmd:. unzipfile tl_2016_us_county.zip}{p_end}
{phang2}{cmd:. spshape2dta tl_2016_us_county}{p_end}

{pstd}Create a subset of {cmd:tl_2016_us_county.dta}{p_end}
{phang2}{cmd:. use tl_2016_us_county}{p_end}
{phang2}{cmd:. keep if STATEFP == "48"}{p_end}

{pstd}Compress the spatial data{p_end}
{phang2}{cmd:. spcompress}{p_end}

{pstd}This produces an error message because the data are linked 
to {cmd:tl_2016_us_county_shp.dta}, which already exists.  You could
use the {cmd:force} option with {cmd:spcompress} above, but a safer
alternative to this process would be the following:{p_end}
{phang2}{cmd:. use tl_2016_us_county}{p_end}
{phang2}{cmd:. keep if STATEFP == "48"}{p_end}
{phang2}{cmd:. save texas}{p_end}
{phang2}{cmd:. spcompress}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{opt spcompress} stores the following in {opt r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(num_drop_ids)}}{it:#} of {help sp_glossary##spatial_units:spatial units} dropped{p_end}
{synopt:{cmd:r(num_ids)}}{it:#} of {help sp_glossary##spatial_units:spatial units} remaining{p_end}
{p2colreset}{...}
