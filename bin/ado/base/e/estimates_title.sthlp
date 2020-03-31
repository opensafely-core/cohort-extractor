{smcl}
{* *! version 2.1.6  19oct2017}{...}
{viewerdialog "estimates title" "dialog estimates_title"}{...}
{vieweralsosee "[R] estimates title" "mansection R estimatestitle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estimates" "help estimates"}{...}
{viewerjumpto "Syntax" "estimates_title##syntax"}{...}
{viewerjumpto "Menu" "estimates_title##menu"}{...}
{viewerjumpto "Description" "estimates_title##description"}{...}
{viewerjumpto "Links to PDF documentation" "estimates_title##linkspdf"}{...}
{viewerjumpto "Remarks" "estimates_title##remarks"}{...}
{viewerjumpto "Example" "estimates_title##example"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[R] estimates title} {hline 2}}Set title for estimation results{p_end}
{p2col:}({mansection R estimatestitle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{opt est:imates} {cmd:title:}
[{it:text}]

{p 8 12 2}
{opt est:imates} {cmd:title}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estimates} {cmd:title:} (note the colon) sets or clears the 
title for the current estimation results.  The title is used
by 
{helpb estimates table}
and
{helpb estimates stats}.

{pstd}
{cmd:estimates} {cmd:title} without the colon displays the current 
title.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R estimatestitleQuickstart:Quick start}

        {mansection R estimatestitleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
After setting the title, if estimates have been stored, do not 
forget to store them again.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress mpg gear turn}

{pstd}Add a title to estimates and store the results{p_end}
{phang2}{cmd:. estimates title: The final model}{p_end}
{phang2}{cmd:. estimates store reg}

{pstd}Replay results{p_end}
{phang2}{cmd:. estimates replay reg}{p_end}
