{smcl}
{* *! version 1.2.4  14may2018}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] gsem reporting options" "mansection SEM gsemreportingoptions"}{...}
{findalias asgsemtirt}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{viewerjumpto "Syntax" "gsem_reporting_options##syntax"}{...}
{viewerjumpto "Description" "gsem_reporting_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "gsem_reporting_options##linkspdf"}{...}
{viewerjumpto "Options" "gsem_reporting_options##options"}{...}
{viewerjumpto "Remarks" "gsem_reporting_options##remarks"}{...}
{viewerjumpto "Examples" "gsem_reporting_options##examples"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[SEM] gsem reporting options} {hline 2}}Options affecting
reporting of results{p_end}
{p2col:}({mansection SEM gsemreportingoptions:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:gsem} {help sem_and_gsem path notation:{it:paths}} ...{cmd:,} ...
     {it:reporting_options}

{p 8 12 2}
{cmd:gsem,} {it:reporting_options}


{synoptset 19}{...}
{synopthdr:reporting_options}
{synoptline}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt coefl:egend}}display coefficient legend{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{opt nohead:er}}do not display header above parameter table{p_end}
{synopt :{opt nodvhead:er}}do not display dependent variables information in the header{p_end}
{synopt :{opt notable}}do not display parameter tables{p_end}

{synopt :{opt byparm}}display results in a single table with rows arranged by
parameter{p_end}

{synopt :{it:{help gsem_reporting_options##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
These options control how {cmd:gsem} displays estimation results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM gsemreportingoptionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt coeflegend} displays the legend that reveals how to specify estimated
coefficients in {opt _b[]} notation, which you are sometimes required to
type in specifying postestimation commands.

{phang}
{opt nocnsreport} suppresses the display of the constraints.
Fixed-to-zero constraints that are automatically set by {cmd:gsem} are not
shown in the report to keep the output manageable.

{phang}
{opt noheader} suppresses the header above the parameter table, the display
that reports the final log-likelihood value, number of observations, etc.

{phang}
{opt nodvheader} suppresses the dependent variables information from the
header above the parameter table.

{phang}
{opt notable} suppresses the parameter table.

{phang}
{opt byparm} specifies that estimation results with multiple groups or latent
classes be reported in a single table with rows arranged by parameter.  The
default is to report results in separate tables for each group and latent
class combination.

INCLUDE help displayopts_list


{marker remarks}{...}
{title:Remarks}

{pstd}
Any of the above options may be specified when you fit the model or when you
redisplay results, which you do by specifying nothing but options after the
{cmd:gsem} command:

{phang2}{cmd:. gsem (...) (...), ...}{p_end}
{phang2}{it:(original output displayed)}

{phang2}{cmd:. gsem}{p_end}
{phang2}{it:(output redisplayed)}

{phang2}{cmd:. gsem, coeflegend}{p_end}
{phang2}{it:(coefficient-name table displayed)}

{phang2}{cmd:. gsem}{p_end}
{phang2}{it:(output redisplayed)}


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_cfa}{p_end}
{phang2}{cmd:. gsem (MathAb -> q1-q8, logit) (MathAtt -> att1-att5, ologit)}{p_end}

{pstd}Display coefficient legend{p_end}
{phang2}{cmd:. gsem, coeflegend}{p_end}

{pstd}Obtain 90 percent confidence intervals{p_end}
{phang2}{cmd:. gsem, level(90)}{p_end}
