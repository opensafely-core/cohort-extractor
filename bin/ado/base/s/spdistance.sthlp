{smcl}
{* *! version 1.0.4  11may2018}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spdistance" "mansection SP spdistance"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "[SP] spset" "help spset"}{...}
{viewerjumpto "Syntax" "spdistance##syntax"}{...}
{viewerjumpto "Menu" "spdistance##menu"}{...}
{viewerjumpto "Description" "spdistance##description"}{...}
{viewerjumpto "Links to PDF documentation" "spdistance##linkspdf"}{...}
{viewerjumpto "Example" "spdistance##example"}{...}
{viewerjumpto "Stored results" "spdistance##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[SP] spdistance} {hline 2}}Calculator for distance between
places{p_end}
{p2col:}({mansection SP spdistance:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:spdistance} {it:#1} {it:#2}

{phang}
{it:#1} and {it:#2} are two {cmd:_ID} values.


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spdistance} {it:#1} {it:#2} reports the distance
between the areas {cmd:_ID} = {it:#1} and {cmd:_ID} = {it:#2}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spdistanceQuickstart:Quick start}

        {mansection SP spdistanceRemarksandexamples:Remarks and examples}

        {mansection SP spdistanceMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

{pstd}
From a city dataset in which Los Angeles and New York have {cmd:_ID}
values 1 and 79, obtain the distance between them{p_end}
{phang2}
{cmd:. spdistance 1 79}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:spdistance} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(dist)}}distance between{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(coordsys)}}{cmd:planar} or {cmd:latlong}{p_end}
{synopt:{cmd:r(dunits)}}{cmd:miles} or {cmd:kilometers} if
   {cmd:r(coordsys)} = {cmd:latlong}{p_end}
{p2colreset}{...}
