{smcl}
{* *! version 1.1.8  19oct2017}{...}
{vieweralsosee "[R] eform_option" "mansection R eform_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _coef_table" "help _coef_table"}{...}
{vieweralsosee "[R] ml" "help ml"}{...}
{viewerjumpto "Description" "eform_option##description"}{...}
{viewerjumpto "Links to PDF documentation" "eform_option##linkspdf"}{...}
{viewerjumpto "Examples" "eform_option##examples"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[R]} {it:eform_option} {hline 2}}Displaying exponentiated coefficients{p_end}
{p2col:}({mansection R eform_option:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
An {it:eform_option} causes the coefficient table to be displayed in
exponentiated form: for each coefficient, exp(b) rather than b is
displayed.  Standard errors and confidence intervals are also transformed.

{pstd}
An {it:eform_option} is one of the following:

{p2colset 9 32 36 2}{...}
{p2col :{it:eform_option}}Description{p_end}
{p2line}
{p2col :{opth eform:(strings:string)}}use {it:string} for column title{p_end}

{p2col :{opt eform}}exponentiated
	coefficient, {it:string} is {cmd:exp(b)}{p_end}
{p2col :{opt hr}}hazard ratio, {it:string} is {cmd:Haz. Ratio}{p_end}
{p2col :{opt shr}}subhazard ratio, {it:string} is {cmd:SHR}{p_end}
{p2col :{opt ir:r}}incidence-rate ratio, {it:string} is {cmd:IRR}{p_end}
{p2col :{opt or}}odds ratio, {it:string} is {cmd:Odds Ratio}{p_end}
{p2col :{opt rr:r}}relative-risk ratio, {it:string} is {cmd:RRR}{p_end}
{p2line}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R eform_optionRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse nhanes2d}

{pstd}Perform logit regression using {cmd:svy} prefix and display odds ratios
rather than coefficients{p_end}
{phang2}{cmd:. svy, or: logit highbp female black}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse lbw}

{pstd}Fit complementary log-log model, displaying exponentiated coefficients
{p_end}
{phang2}{cmd:. cloglog low age lwt i.race smoke ptl ht ui, eform}{p_end}

    {hline}
