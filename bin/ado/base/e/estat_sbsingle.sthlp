{smcl}
{* *! version 1.0.5  19oct2017}{...}
{viewerdialog estat "dialog estat"}{...}
{vieweralsosee "[TS] estat sbsingle" "mansection TS estatsbsingle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] estat sbcusum" "help estat sbcusum"}{...}
{vieweralsosee "[TS] estat sbknown" "help estat sbknown"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ivregress" "help ivregress"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "estat sbsingle##syntax"}{...}
{viewerjumpto "Menu for estat" "estat sbsingle##menu_estat"}{...}
{viewerjumpto "Description" "estat sbsingle##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_sbsingle##linkspdf"}{...}
{viewerjumpto "Options" "estat sbsingle##options"}{...}
{viewerjumpto "Examples" "estat sbsingle##examples"}{...}
{viewerjumpto "Stored results" "estat sbsingle##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[TS] estat sbsingle} {hline 2}}Test for a structural break with
an unknown break date{p_end}
{p2col:}({mansection TS estatsbsingle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

        {cmd:estat sbsingle} [{cmd:,} {it:options}]

{synoptset 31}{...}
{synopthdr}
{synoptline}
{synopt :{cmd:breakvars(}[{varlist}][{cmd:,} {opt cons:tant}]{cmd:)}}specify
variables to be included in the test; by default,
all coefficients are tested{p_end}
{synopt :{opt trim(#)}}specify a trimming percentage; default is {cmd:trim(15)}{p_end}
{synopt :{opt ltrim(#_l)}}specify a left trimming percentage{p_end}
{synopt :{opt rtrim(#_r)}}specify a right trimming percentage{p_end}
{synopt :{opt swald}}request a supremum Wald test; the default{p_end}
{synopt :{opt awald}}request an average Wald test{p_end}
{synopt :{opt ewald}}request an exponential Wald test{p_end}
{synopt :{opt all}}report all tests{p_end}
{synopt :{opt slr}}request a supremum likelihood-ratio (LR) test{p_end}
{synopt :{opt alr}}request an average LR test{p_end}
{synopt :{opt elr}}request an exponential LR test{p_end}
{synopt :{opth gen:erate(newvarlist)}}create {it:newvarlist} containing Wald
or LR test statistics{p_end}
{synopt :{opt nodots}}suppress iteration dots{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:tsset} your data before using {cmd:estat sbsingle}; see
{helpb tsset:[TS] tsset}.


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{opt estat sbsingle}  performs a test of whether the coefficients in a
time-series regression vary over the periods defined by an unknown break date.

{pstd}
{opt estat sbsingle} requires that the current estimation results be from
{helpb regress} or {helpb ivregress:ivregress 2sls}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS estatsbsingleQuickstart:Quick start}

        {mansection TS estatsbsingleRemarksandexamples:Remarks and examples}

        {mansection TS estatsbsingleMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:breakvars(}[{varlist}][{cmd:,} {cmd:constant}]{cmd:)}
specifies variables to be included in the test. By default, all the
coefficients are tested.

{phang2}
{opt constant} specifies that a constant be included in the list of
variables to be tested.  {opt constant} may be specified only if 
the original model was fit with a constant term. 

{phang}
{opt trim(#)} specifies an equal left and right trimming percentage as an
integer.  Specifying {opt trim(#)} causes the observation at the {it:#}th
percentile to be treated as the first possible break date and the observation
at the (100 - {it:#})th percentile to be treated as the last
possible break date.  By default, the trimming percentage is set to 15 but
may be set to any value between 1 and 49.

{phang}
{opt ltrim(#_l)} specifies a left trimming percentage as an integer.
Specifying {opt ltrim(#_l)} causes the observation at the
{it:#_l}th percentile to be treated as the first possible break date.
This option must be specified with {opt rtrim(#_r)} and may not be
combined with {opt trim(#)}. {it:#_l} must be between 1 and 99.

{phang}
{opt rtrim(#_r)} specifies a right trimming percentage as an
integer.  Specifying {opt rtrim(#_r)} causes the observation at the
(100 - {it:#_r})th percentile to be treated as the last possible
break date. This option must be specified with {opt ltrim(#_l)} and
may not be combined with {opt trim(#)}.  {it:#_r} must be less than
(100 - {it:#_l}). Specifying {it:#_l} = {it:#_r} is
equivalent to specifying {opt trim(#)} with {it:#} = {it:#_l} = {it:#_r}.

{phang}
{opt swald} requests that a supremum Wald test be performed. This is
the default.

{phang}
{opt awald} requests that an average Wald test be performed.

{phang}
{opt ewald} requests that an exponential Wald test be performed.

{phang}
{opt all} specifies that all tests be displayed in a table.

{phang}
{opt slr} requests that a supremum LR test be performed.

{phang}
{opt alr} requests that an average LR test be performed.

{phang}
{opt elr} requests that an exponential LR test be performed.

{phang}
{opth generate(newvarlist)} creates either one or two new variables
containing the Wald statistics, LR statistics, or both that are
transformed and used to calculate the requested Wald or LR tests. If
you request only Wald-type tests ({opt swald}, {opt awald}, or {opt ewald})
or only LR-type tests ({opt slr}, {opt alr}, or {opt elr}), then you
may specify only one {varname} in {opt generate()}.  By default, {newvar}
will contain Wald or LR statistics, depending on the type of test
specified.

{pmore}
A variable containing Wald statistics and a variable containing LR
statistics are created if you specify both Wald-type and LR-type tests
and specify two {it:varnames} in {opt generate()}. If you only specify one
{it:varname} in {opt generate()} with Wald-type and LR-type tests
specified, then Wald statistics are returned. 

{pmore}
If no test is specified and {opt generate()} is specified, Wald statistics are
returned. 

{phang}
{opt nodots} suppresses display of the iteration dots.  By default, one dot
character is displayed for each iteration in the range of possible break dates.  

{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse usmacro}{p_end}
{phang2}{cmd:. regress fedfunds L.fedfunds inflation}{p_end}

{pstd}Test whether coefficients changed at an unknown break date{p_end}
{phang2}{cmd:. estat sbsingle}{p_end}

{pstd}Same as above, but also display the results for the supremum Wald,
average Wald, and average LR tests{p_end}
{phang2}{cmd:. estat sbsingle, swald awald alr}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat sbsingle} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(chi2)}}chi-squared test statistic{p_end}
{synopt:{cmd:r(p)}}p-value for chi-squared test{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(ltrim)}}start of trim date{p_end}
{synopt:{cmd:r(rtrim)}}end of trim date{p_end}
{synopt:{cmd:r(breakvars)}}list of variables whose coefficients are included in
the test{p_end}
{synopt:{cmd:r(breakdate)}}estimated break date only after supremum tests{p_end}
{synopt:{cmd:r(test)}}type of test{p_end}
{p2colreset}{...}
