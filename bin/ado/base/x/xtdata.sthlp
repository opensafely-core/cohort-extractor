{smcl}
{* *! version 1.1.10  19oct2017}{...}
{viewerdialog xtdata "dialog xtdata"}{...}
{vieweralsosee "[XT] xtdata" "mansection XT xtdata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtsum" "help xtsum"}{...}
{viewerjumpto "Syntax" "xtdata##syntax"}{...}
{viewerjumpto "Menu" "xtdata##menu"}{...}
{viewerjumpto "Description" "xtdata##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtdata##linkspdf"}{...}
{viewerjumpto "Options" "xtdata##options"}{...}
{viewerjumpto "Examples" "xtdata##examples"}{...}
{viewerjumpto "Warnings" "xtdata##warnings"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[XT] xtdata} {hline 2}}Faster specification searches with xt data{p_end}
{p2col:}({mansection XT xtdata:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:xtdata} [{varlist}] {ifin} 
[{cmd:,} {it:options}]


{synoptset 15 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt re}}convert data to a form suitable for random-effects estimation{p_end}
{synopt :{opt r:atio(#)}}ratio of random effect to pure residual (standard deviations){p_end}
{synopt :{opt be}}convert data to a form suitable for between estimation{p_end}
{synopt :{opt fe}}convert data to a form suitable for fixed-effects (within) estimation{p_end}
{synopt :{opt nodouble}}keep original variable type; default is to recast type as {opt double}{p_end}
{synopt :{opt clear}}overwrite current data in memory{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
A panel variable must be specified; use {helpb xtset}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Setup and utilities >}
     {bf:Faster specification searches with xt data}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtdata} produces a transformed dataset of the variables specified in
{varlist} or of all the variables in the data.  Once the data are transformed,
Stata's {cmd:regress} command may be used to perform specification searches
more quickly than {cmd:xtreg}; see {manhelp regress R} and {manhelp xtreg XT}.
Using {cmd:xtdata, re} also creates a variable named {opt constant}.  When
using {cmd:regress} after {cmd:xtdata, re}, specify {opt noconstant} and
include {cmd:constant} in the regression.  After {cmd:xtdata, be} and
{cmd:xtdata, fe}, you need not include {cmd:constant} or specify
{cmd:regress}'s {opt noconstant} option.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtdataQuickstart:Quick start}

        {mansection XT xtdataRemarksandexamples:Remarks and examples}

        {mansection XT xtdataMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt re} specifies that the data be converted into a form suitable for
random-effects estimation.  {opt re} is the default if {opt be}, {opt fe}, or
{opt re} is not specified.  {opt ratio()} must also be specified.

{phang}
{opt ratio(#)} (use with {cmd:xtdata, re} only) specifies the ratio
sigma_u/sigma_e, which is the ratio of the random effect to the pure residual.
This is the ratio of the standard deviations, not the variances.

{phang}
{opt be} specifies that the data be converted into a form suitable for
between estimation.

{phang}
{opt fe} specifies that the data be converted into a form suitable for
fixed-effects (within) estimation.

{phang}
{opt nodouble} specifies that transformed variables keep their original types,
if possible.  The default is to recast variables to {cmd:double}.

{pmore}
Remember that {cmd:xtdata} transforms variables to be differences from
group means, pseudodifferences from group means, or group means.  Specifying
{opt nodouble} will decrease the size of the resulting dataset but may
introduce roundoff errors in these calculations.

{phang}
{opt clear} specifies that the data may be converted even though the
dataset has changed since it was last saved on disk.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse xtdatasmpl}{p_end}

{pstd}Perform between transformation{p_end}
{phang2}{cmd:. xtdata ln_w grade age* ttl_exp* tenure* black not_smsa south, be}
{p_end}

{pstd}Equivalent to {cmd:xtreg, be}{p_end}
{phang2}{cmd:. regress ln_w grade age* ttl_exp* tenure* black not_smsa south}
{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse xtdatasmpl, clear}{p_end}

{pstd}Perform within transformation{p_end}
{phang2}{cmd:. xtdata, fe}{p_end}

{pstd}Equivalent to {cmd:xtreg, fe}{p_end}
{phang2}{cmd:. regress ln_w grade age* ttl_exp* tenure* black not_smsa south}
{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse xtdatasmpl, clear}{p_end}

{pstd}Perform random-effects transformation{p_end}
{phang2}{cmd:. xtdata, re ratio(.88719358)}{p_end}

{pstd}Equivalent to {cmd:xtreg, re}{p_end}
{phang2}{cmd:. regress ln_w grade age* ttl_exp* tenure* black not_smsa south}
                 {cmd:constant, noconstant}{p_end}
    {hline}


{marker warnings}{...}
{title:Warnings}

{phang}1.  {cmd:xtdata} is intended for use during the specification
search phase of analysis.  Final results should be estimated with
{cmd:xtreg} on unconverted data.

{phang}2.  Using {cmd:regress} after {cmd:xtdata, fe}, produces
standard errors that are too small, but only slightly.

{phang}3.  Interpret significance tests and confidence intervals loosely.
After {cmd:xtdata, fe} and {cmd:re}, an incorrect (but close to correct)
distribution is being assumed.

{phang}4.  You should ignore the summary statistics reported at the top of
{cmd:regress}'s output.

{phang}5.  After converting the data, you may form linear, but not
nonlinear combinations of regressors.
{p_end}
