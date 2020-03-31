{smcl}
{* *! version 1.1.8  11may2019}{...}
{viewerdialog pkcollapse "dialog pkcollapse"}{...}
{vieweralsosee "[R] pkcollapse" "mansection R pkcollapse"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] pk" "help pk"}{...}
{viewerjumpto "Syntax" "pkcollapse##syntax"}{...}
{viewerjumpto "Menu" "pkcollapse##menu"}{...}
{viewerjumpto "Description" "pkcollapse##description"}{...}
{viewerjumpto "Links to PDF documentation" "pkcollapse##linkspdf"}{...}
{viewerjumpto "Options" "pkcollapse##options"}{...}
{viewerjumpto "Examples" "pkcollapse##examples"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[R] pkcollapse} {hline 2}}Generate pharmacokinetic measurement dataset{p_end}
{p2col:}({mansection R pkcollapse:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 19 2}
{cmd:pkcollapse} {it:time} {it:concentration} [{it:concentration} [...]] [{it:{help if}}] {cmd:,}
 {opt id(id_var)} [{it:options}]

{synoptset 18 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{p2coldent :* {opt id(id_var)}}subject ID variable{p_end}
{synopt :{opth "stat(pkcollapse##measures:measures)"}}create specified
{it:measures}; default is all{p_end}
{synopt :{opt t:rapezoid}}use trapezoidal rule; default is cubic splines{p_end}
{synopt :{opt fit(#)}}use {it:#} points to estimate AUC_0,inf; default is
{cmd:fit(3)}{p_end}
{synopt :{opth keep(varlist)}}keep variables in {it:varlist}{p_end}
{synopt :{opt force}}force collapse{p_end}
{synopt :{opt nod:ots}}suppress dots during calculation{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}*{opt id(id_var)} is required.

{synoptset 18}{...}
{marker measures}{...}
{synopthdr :measures}
{synoptline}
{synopt :{opt auc}}AUC_0,tmax{p_end}
{synopt :{opt aucline}}AUC_0,inf using a linear extension{p_end}
{synopt :{opt aucexp}}AUC_0,inf using an exponential extension{p_end}
{synopt :{opt auclog}}area under the concentration-time curve from 0 to
infinity extended with a linear fit to log concentration{p_end}
{synopt :{opt half}}half-life of the drug{p_end}
{synopt :{opt ke}}elimination rate{p_end}
{synopt :{opt cmax}}maximum concentration{p_end}
{synopt :{opt tmax}}time at last concentration{p_end}
{synopt :{opt tomc}}time of maximum concentration{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Epidemiology and related > Other >}
    {bf:Generate pharmacokinetic measurement dataset}


{marker description}{...}
{title:Description}

{pstd}
{cmd:pkcollapse} generates new variables with the pharmacokinetic summary
measures of interest.
 
{pstd}
{cmd:pkcollapse} is one of the pk commands.  Please read {helpb pk} before
reading this entry.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R pkcollapseQuickstart:Quick start}

        {mansection R pkcollapseRemarksandexamples:Remarks and examples}

        {mansection R pkcollapseMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt id(id_var)} is required and specifies the variable that contains
the subject ID over which {cmd:pkcollapse} is to operate.

{phang}
{opth stat:(pkcollapse##measures:measures)} specifies the measures to be
generated.  The default is to generate all the measures.

{phang}
{opt trapezoid} tells Stata to use the trapezoidal rule when calculating the
AUC_0,tmax.  The default is to use cubic splines, which give better results
for most functions.  When the curve is irregular, {opt trapezoid} may give
better results.

{phang}
{opt fit(#)} specifies the number of points to use in estimating the
AUC_0,inf.  The default is {cmd:fit(3)}, the last three points.  This number
should be viewed as a minimum; the appropriate number of points will depend on
your data.

{phang}
{opth keep(varlist)} specifies the variables to be kept during the collapse.
Variables not specified with the {opt keep()} option will be dropped.  When
{opt keep()} is specified, the kept variables are checked to ensure that all
values of the variables are the same within {it:id_var}.

{phang}
{opt force} forces the collapse, even when values of the {opt keep()}
variables are different within {it:id_var}.

{phang}
{opt nodots} suppresses the display of dots during calculation.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse pkdata}{p_end}

{pstd}Create dataset containing all summary pharmacokinetic measures{p_end}
{phang2}{cmd:. pkcollapse time conc1 conc2, id(id)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse pkdata, clear}{p_end}

{pstd}Create dataset containing the AUC measure, and keep the variable
{cmd:seq}{p_end}
{phang2}{cmd:. pkcollapse time conc1 conc2, id(id) keep(seq) stat(auc)}{p_end}
    {hline}
