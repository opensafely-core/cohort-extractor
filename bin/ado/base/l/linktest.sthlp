{smcl}
{* *! version 1.1.13  22mar2018}{...}
{viewerdialog linktest "dialog linktest"}{...}
{vieweralsosee "[R] linktest" "mansection R linktest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] regress postestimation" "help regress_postestimation"}{...}
{viewerjumpto "Syntax" "linktest##syntax"}{...}
{viewerjumpto "Menu" "linktest##menu"}{...}
{viewerjumpto "Description" "linktest##description"}{...}
{viewerjumpto "Links to PDF documentation" "linktest##linkspdf"}{...}
{viewerjumpto "Option" "linktest##option"}{...}
{viewerjumpto "Examples" "linktest##examples"}{...}
{viewerjumpto "Stored results" "linktest##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[R] linktest} {hline 2}}Specification link test for single-equation models{p_end}
{p2col:}({mansection R linktest:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:linktest} {ifin} [{cmd:,} {it:cmd_options}]

{phang}
When {cmd:if} and {cmd:in} are not specified, the link
test is performed on the same sample as the previous estimation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:linktest} performs a link test for model specification.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R linktestQuickstart:Quick start}

        {mansection R linktestRemarksandexamples:Remarks and examples}

        {mansection R linktestMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{dlgtab:Main}

{phang}
{it:cmd_options} must be the same options specified with the underlying
estimation command, except the {it:display_options} may differ.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Fit linear regression{p_end}
{phang2}{cmd:. regress mpg weight displacement foreign}{p_end}

{pstd}Perform link test{p_end}
{phang2}{cmd:. linktest}{p_end}

{pstd}Generate new variable, {cmd:wgt}{p_end}
{phang2}{cmd:. generate wgt = weight/100}{p_end}

{pstd}Fit tobit model with right-censoring limit at 2,400 pounds{p_end}
{phang2}{cmd:. tobit mpg wgt, ul(24)}{p_end}

{pstd}Perform link test, specifying right-censoring limit{p_end}
{phang2}{cmd:. linktest, ul(24)}{p_end}

{pstd}Fit quantile regression model{p_end}
{phang2}{cmd:. qreg mpg weight displ foreign}{p_end}

{pstd}Perform link test{p_end}
{phang2}{cmd:. linktest}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:linktest} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(t)}}t statistic on {cmd:_hatsq}{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
