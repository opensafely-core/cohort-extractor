{smcl}
{* *! version 1.0.8  15may2018}{...}
{viewerdialog estat "dialog estat"}{...}
{vieweralsosee "[TS] estat sbknown" "mansection TS estatsbknown"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] estat sbcusum" "help estat sbcusum"}{...}
{vieweralsosee "[TS] estat sbsingle" "help estat sbsingle"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ivregress" "help ivregress"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "estat sbknown##syntax"}{...}
{viewerjumpto "Menu for estat" "estat sbknown##menu_estat"}{...}
{viewerjumpto "Description" "estat sbknown##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_sbknown##linkspdf"}{...}
{viewerjumpto "Options" "estat sbknown##options"}{...}
{viewerjumpto "Examples" "estat sbknown##examples"}{...}
{viewerjumpto "Stored results" "estat sbknown##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[TS] estat sbknown} {hline 2}}Test for a structural break with
a known break date{p_end}
{p2col:}({mansection TS estatsbknown:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
        {cmd:estat sbknown}{cmd:,}
	{opth break:(estat_sbknown##tcl:time_constant_list)}
	[{it:options}]

{synoptset 34 tabbed}{...}
{synopthdr}
{synoptline}
{p2coldent:* {opth break:(estat_sbknown##tcl:time_constant_list)}}specify
one or more break dates{p_end}
{synopt :{cmd:breakvars(}[{varlist}][{cmd:,} {opt cons:tant}]{cmd:)}}specify
variables to be included in the test; by default,
all coefficients are tested{p_end}
{synopt :{opt wald}}request a Wald test; the default{p_end}
{synopt :{opt lr}}request an LR test{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt break()} is required.{p_end}
{p 4 6 2}
You must {cmd:tsset} your data before using {cmd:estat sbknown}; see
{helpb tsset:[TS] tsset}.


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{opt estat sbknown}  performs a Wald or a likelihood-ratio (LR) test of
whether the coefficients in a time-series regression vary over the periods
defined by known break dates.

{pstd}
{opt estat sbknown} requires that the current estimation results be from
{helpb regress} or {helpb ivregress:ivregress 2sls}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS estatsbknownQuickstart:Quick start}

        {mansection TS estatsbknownRemarksandexamples:Remarks and examples}

        {mansection TS estatsbknownMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt break(time_constant_list)} specifies a list of one or more
hypothesized break dates.  {opt break()} is required with at least one
break date.

{marker tcl}{...}
{phang2}
{it:time_constant_list} is a list of one or more {it:time_constant}
elements specified using dates in Stata internal form (SIF) or human-readable
form (HRF) format.  If you specify the {it:time_constant_list} using HRF, you
must use one of the datetime pseudofunctions; see
{helpb datetime:[D] Datetime}.

{phang}
{cmd:breakvars(}[{varlist}][{cmd:,} {cmd:constant}]{cmd:)}
specifies variables to be included in the test. By default, all the
coefficients are tested.

{phang2}
{opt constant} specifies that a constant be included in the list of
variables to be tested.  {opt constant} may be specified only if 
the original model was fit with a constant term. 

{phang}
{opt wald} requests that a Wald test be performed.  This is the default.

{phang}
{opt lr} requests that an LR test be performed instead of a Wald test.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse usmacro}{p_end}
{phang2}{cmd:. regress fedfunds L.fedfunds}{p_end}

{pstd}Test for a structural break date and divide the data into three
subsamples by specifying the break dates at {cmd:1970q1} and {cmd:1995q1}{p_end}
{phang2}{cmd:. estat sbknown, break(tq(1970q1) tq(1995q1))}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat sbknown} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(chi2)}}chi-squared test statistic{p_end}
{synopt:{cmd:r(p)}}p-value for chi-squared test{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(breakdate)}}list of break dates{p_end}
{synopt:{cmd:r(breakvars)}}list of variables whose coefficients are included in
the test{p_end}
{synopt:{cmd:r(test)}}type of test{p_end}
{p2colreset}{...}
