{smcl}
{* *! version 1.2.6  30may2019}{...}
{viewerdialog eivreg "dialog eivreg"}{...}
{vieweralsosee "[R] eivreg" "mansection R eivreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] eivreg postestimation" "help eivreg_postestimation"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "" "--"}{...}
{findalias assemrel}{...}
{viewerjumpto "Syntax" "eivreg##syntax"}{...}
{viewerjumpto "Menu" "eivreg##menu"}{...}
{viewerjumpto "Description" "eivreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "eivreg##linkspdf"}{...}
{viewerjumpto "Options" "eivreg##options"}{...}
{viewerjumpto "Example" "eivreg##example"}{...}
{viewerjumpto "Stored results" "eivreg##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] eivreg} {hline 2}}Errors-in-variables regression{p_end}
{p2col:}({mansection R eivreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:eivreg}
{depvar}
[{indepvars}]
{ifin}
[{it:{help eivreg##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt:{cmdab:r:eliab(}{it:{help varlist:indepvar}} {it:#} [{it:indepvar # }[...]]{cmd:)}}{p_end}
{synopt: }specify measurement reliability for each {it:indepvar} measured with error{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{it:{help eivreg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
INCLUDE help fvvarlist
{p 4 6 2}
{opt bootstrap}, {opt by}, {opt jackknife}, {opt rolling}, and {opt statsby}
are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{p 4 6 2}
{cmd:aweight}s and {cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp eivreg_postestimation R:eivreg postestimation} for features
available after estimation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Errors-in-variables regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:eivreg} fits errors-in-variables regression models when one or more
of the independent variables are measured with error.  To use {cmd:eivreg},
you must have an estimate of each independent variable's reliability or
assume it is measured without error.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R eivregQuickstart:Quick start}

        {mansection R eivregRemarksandexamples:Remarks and examples}

        {mansection R eivregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:reliab(}{it:{help varlist:indepvar}} {it:#} [{it:indepvar # }[...]]{cmd:)}
specifies the measurement reliability for each independent variable
measured with error.  
Reliabilities are specified as pairs consisting of an independent
variable name (a name that appears in {it:indepvars})
and the corresponding reliability r, 0 < r {ul:<} 1.
Independent variables for
which no reliability is specified are assumed to have reliability 1.
If the option is not specified, all variables are assumed to have reliability
1, and the result is thus the same as that produced by {cmd:regress}
(the ordinary least-squares results).

{dlgtab:Reporting}

{phang}
{opt level(#)}; see 
{helpb estimation options##level():[R] Estimation options}.

INCLUDE help displayopts_list

{pstd}
The following option is available with {opt eivreg} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Fit regression in which {cmd:weight} and {cmd:mpg} are measured with
reliabilities 0.85 and 0.95, respectively{p_end}
{phang2}{cmd:. eivreg price weight foreign mpg, reliab(weight .85 mpg .95)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:eivreg} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(r2)}}R-squared{p_end}
{synopt:{cmd:e(F)}}F statistic{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:eivreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(rellist)}}{it:indepvars} and associated reliabilities{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
