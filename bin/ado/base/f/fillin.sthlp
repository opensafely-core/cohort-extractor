{smcl}
{* *! version 1.1.8  19oct2017}{...}
{viewerdialog fillin "dialog fillin"}{...}
{vieweralsosee "[D] fillin" "mansection D fillin"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] cross" "help cross"}{...}
{vieweralsosee "[D] expand" "help expand"}{...}
{vieweralsosee "[D] joinby" "help joinby"}{...}
{vieweralsosee "[D] save" "help save"}{...}
{viewerjumpto "Syntax" "fillin##syntax"}{...}
{viewerjumpto "Menu" "fillin##menu"}{...}
{viewerjumpto "Description" "fillin##description"}{...}
{viewerjumpto "Links to PDF documentation" "fillin##linkspdf"}{...}
{viewerjumpto "Examples" "fillin##examples"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] fillin} {hline 2}}Rectangularize dataset{p_end}
{p2col:}({mansection D fillin:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:fillin} {varlist}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Other variable-transformation commands}
     {bf:> Rectangularize dataset}


{marker description}{...}
{title:Description}

{pstd}
{opt fillin} adds observations with missing data so that all interactions
of {varlist} exist, thus making a complete rectangularization of
{it:varlist}.  {opt fillin} also adds the variable {opt _fillin} to the
dataset.  {opt _fillin} is 1 for observations created by using {opt fillin}
and 0 for previously existing observations.

{pstd}
{it:varlist} may not contain {helpb data types:strL}s.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D fillinQuickstart:Quick start}

        {mansection D fillinRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse fillin1}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Create observations with missing values for all combinations of
{cmd:sex}, {cmd:race}, and {cmd:age_group} that are in the dataset{p_end}
{phang2}{cmd:. fillin sex race age_group}

{pstd}List the data{p_end}
{phang2}{cmd:. list}{p_end}
