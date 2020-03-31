{smcl}
{* *! version 1.1.8  19oct2017}{...}
{viewerdialog ksmirnov "dialog ksmirnov"}{...}
{vieweralsosee "[R] ksmirnov" "mansection R ksmirnov"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] runtest" "help runtest"}{...}
{vieweralsosee "[R] sktest" "help sktest"}{...}
{vieweralsosee "[R] swilk" "help swilk"}{...}
{viewerjumpto "Syntax" "ksmirnov##syntax"}{...}
{viewerjumpto "Menu" "ksmirnov##menu"}{...}
{viewerjumpto "Description" "ksmirnov##description"}{...}
{viewerjumpto "Links to PDF documentation" "ksmirnov##linkspdf"}{...}
{viewerjumpto "Options" "ksmirnov##options"}{...}
{viewerjumpto "Examples" "ksmirnov##examples"}{...}
{viewerjumpto "Stored results" "ksmirnov##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[R] ksmirnov} {hline 2}}Kolmogorov-Smirnov equality-of-distributions test{p_end}
{p2col:}({mansection R ksmirnov:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
One-sample Kolmogorov-Smirnov test

{p 8 17 2}
{cmd:ksmirnov} {varname} {cmd:=} {it:{help exp}} {ifin}


{phang}
Two-sample Kolmogorov-Smirnov test

{p 8 17 2}
{cmd:ksmirnov} {varname} {ifin} {cmd:,} {opth "by(varlist:groupvar)"}
 [{opt e:xact}]


{pstd}
In the first syntax, {varname} is the variable whose distribution is being
tested, and {it:{help exp}} must evaluate to the corresponding (theoretical)
cumulative.  In the second syntax, {it:{help varlist:groupvar}} must take on
two distinct values.  The distribution of {it:varname} for the first value of
{it:groupvar} is compared with that of the second value.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Nonparametric analysis > Tests of hypotheses >}
      {bf:Kolmogorov-Smirnov test}


{marker description}{...}
{title:Description}

{pstd}
{cmd:ksmirnov} performs one- and two-sample Kolmogorov-Smirnov tests of the
equality of distributions.  A one-sample test compares the distribution of
the tested variable with the specified distribution.  A two-sample test tests
the equality of the distributions of two samples.

{pstd}
When testing for normality, please see {manhelp sktest R} and
{manhelp swilk R}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R ksmirnovQuickstart:Quick start}

        {mansection R ksmirnovRemarksandexamples:Remarks and examples}

        {mansection R ksmirnovMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth "by(varlist:groupvar)"} is required.  It specifies a binary variable
that identifies the two groups.

{phang}
{opt exact} specifies that the exact p-value be computed.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse ksxmpl}{p_end}
{phang2}{cmd:. summarize x}{p_end}

{pstd}One-sample test{p_end}
{phang2}{cmd:. ksmirnov x = normal((x-r(mean))/r(sd))}{p_end}

{pstd}Two-sample test{p_end}
{phang2}{cmd:. ksmirnov x, by(group)}

{pstd}Two-sample test, exact value{p_end}
{phang2}{cmd:. ksmirnov x, by(group) exact}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ksmirnov} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(D_1)}}D from line 1{p_end}
{synopt:{cmd:r(p_1)}}p-value from line 1{p_end}
{synopt:{cmd:r(D_2)}}D from line 2{p_end}
{synopt:{cmd:r(p_2)}}p-value from line 2{p_end}
{synopt:{cmd:r(D)}}combined D{p_end}
{synopt:{cmd:r(p)}}combined p-value{p_end}
{synopt:{cmd:r(p_exact)}}exact combined p-value{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(group1)}}name of group from line 1{p_end}
{synopt:{cmd:r(group2)}}name of group from line 2{p_end}
{p2colreset}{...}
