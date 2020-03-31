{smcl}
{* *! version 1.0.5  17may2019}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spshape2dta" "mansection SP spshape2dta"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro 3" "mansection SP Intro3"}{...}
{vieweralsosee "[SP] Intro 4" "mansection SP Intro4"}{...}
{viewerjumpto "Syntax" "spshape2dta##syntax"}{...}
{viewerjumpto "Menu" "spshape2dta##menu"}{...}
{viewerjumpto "Description" "spshape2dta##description"}{...}
{viewerjumpto "Links to PDF documentation" "spshape2dta##linkspdf"}{...}
{viewerjumpto "Options" "spshape2dta##options"}{...}
{viewerjumpto "Example" "spshape2dta##example"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[SP] spshape2dta} {hline 2}}Translate shapefile to Stata
format{p_end}
{p2col:}({mansection SP spshape2dta:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:spshape2dta} {it:name}
[{cmd:,} {it:options}]

{synoptset 16}{...}
{synopthdr}
{synoptline}
{synopt :{opt clear}}clear existing data from memory{p_end}
{synopt :{opt replace}}if {it:name}{cmd:.dta} or {it:name}{cmd:_shp.dta}
exists, replace them{p_end}
{synopt :{opt saving(name2)}}create new files named {it:name2}{cmd:.dta}
and {it:name2}{cmd:_shp.dta} instead of {it:name}{cmd:.dta} and
{it:name}{cmd:_shp.dta}{p_end}
{synoptline}
{p2colreset}{...}

{phang}
     {cmd:spshape2dta} translates files {it:name}{cmd:.shp} and
     {it:name}{cmd:.dbf}.  They must be in the current directory.

{phang}
     {cmd:spshape2dta} creates files {it:name}{cmd:.dta} and
     {it:name}{cmd:_shp.dta}.  They will be created in the current directory.
     The data in memory, if any, remain unchanged.


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spshape2dta} {it:name} reads files {it:name}{cmd:.shp} and
{it:name}{cmd:.dbf} and creates Sp dataset {it:name}{cmd:.dta} and translated
shapefile {it:name}{cmd:_shp.dta}.  The translated shapefile will be linked
to the Sp dataset {it:name}{cmd:.dta}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spshape2dtaQuickstart:Quick start}

        {mansection SP spshape2dtaRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt clear} specifies to clear any data in memory.

{phang}
{opt replace} specifies that if the new files being created already
exist on disk, they can be replaced.

{phang}
{opt saving(name2)} specifies that rather than the new files being
named {it:name}{cmd:.dta} and {it:name}{cmd:_shp.dta}, they be named
{it:name2}{cmd:.dta} and {it:name2}{cmd:_shp.dta}.


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

{pstd}Unzip the files{p_end}
{phang2}{cmd:. unzipfile tl_2016_us_county.zip}{p_end}

{pstd}Dataset setup{p_end}
{phang2}{cmd:. spshape2dta tl_2016_us_county}{p_end}
