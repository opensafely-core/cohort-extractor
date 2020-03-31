{smcl}
{* *! version 1.1.7  19oct2017}{...}
{viewerdialog xttab "dialog xttab"}{...}
{viewerdialog xttrans "dialog xttrans"}{...}
{vieweralsosee "[XT] xttab" "mansection XT xttab"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtdescribe" "help xtdescribe"}{...}
{vieweralsosee "[XT] xtsum" "help xtsum"}{...}
{viewerjumpto "Syntax" "xttab##syntax"}{...}
{viewerjumpto "Menu" "xttab##menu"}{...}
{viewerjumpto "Description" "xttab##description"}{...}
{viewerjumpto "Links to PDF documentation" "xttab##linkspdf"}{...}
{viewerjumpto "Option" "xttab##option"}{...}
{viewerjumpto "Examples" "xttab##examples"}{...}
{viewerjumpto "Stored results" "xttab##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[XT] xttab} {hline 2}}Tabulate xt data{p_end}
{p2col:}({mansection XT xttab:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:xttab} {varname} [{it:{help if}}]

{p 8 16 2}
{cmd:xttrans} {varname} [{it:{help if}}]  [{cmd:,} {opt f:req}]

{phang}
A panel variable must be specified; use {helpb xtset}.{p_end}
{phang}
{cmd:by} is allowed with {cmd:xttab} and {cmd:xttrans}; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

    {title:xttab}

{phang2}
{bf:Statistics > Longitudinal/panel data > Setup and utilities >}
      {bf:Tabulate xt data}

     {title:xttrans}

{phang2}
{bf:Statistics > Longitudinal/panel data > Setup and utilities >}
       {bf:Report transition probabilities}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xttab}, a generalization of {helpb tabulate oneway}, performs one-way
tabulations and decomposes counts into between and within components in
panel data.

{pstd}
{cmd:xttrans}, another generalization of {helpb tabulate oneway}, reports
transition probabilities (the change in one categorical variable over time).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xttabQuickstart:Quick start}

        {mansection XT xttabRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{dlgtab:Main}

{phang}
{opt freq}, allowed with {cmd:xttrans} only, specifies that
frequencies as well as transition probabilities be displayed.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse nlswork}{p_end}
{phang2}{cmd:. xtset id year}{p_end}

{pstd}xttab{p_end}
{phang2}{cmd:. xttab msp}{p_end}
{phang2}{cmd:. xttab race}{p_end}

{pstd}xttrans{p_end}
{phang2}{cmd:. xttrans msp}{p_end}
{phang2}{cmd:. xttrans msp, freq}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xttab} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(n)}}number of panels{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(results)}}results matrix{p_end}
