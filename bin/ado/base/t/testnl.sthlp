{smcl}
{* *! version 1.2.8  19oct2017}{...}
{viewerdialog testnl "dialog testnl"}{...}
{vieweralsosee "[R] testnl" "mansection R testnl"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] contrast" "help contrast"}{...}
{vieweralsosee "[R] lincom" "help lincom"}{...}
{vieweralsosee "[R] lrtest" "help lrtest"}{...}
{vieweralsosee "[R] nlcom" "help nlcom"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{viewerjumpto "Syntax" "testnl##syntax"}{...}
{viewerjumpto "Menu" "testnl##menu"}{...}
{viewerjumpto "Description" "testnl##description"}{...}
{viewerjumpto "Links to PDF documentation" "testnl##linkspdf"}{...}
{viewerjumpto "Options" "testnl##options"}{...}
{viewerjumpto "Remarks" "testnl##remarks"}{...}
{viewerjumpto "Examples" "testnl##examples"}{...}
{viewerjumpto "Stored results" "testnl##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] testnl} {hline 2}}Test nonlinear hypotheses after estimation{p_end}
{p2col:}({mansection R testnl:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 33 2}
{cmd:testnl} {it:{help testnl##exp:exp}} {cmd:=} {it:{help testnl##exp:exp}}
       [{cmd:=} {it:{help testnl##exp:exp}} ...] [{cmd:,} {it:options}]

{p 8 33 2}
{cmd:testnl} {cmd:(}{it:{help testnl##exp:exp}} {cmd:=} {it:{help testnl##exp:exp}}
     [{cmd:=} {it:{help testnl##exp:exp}}...]{cmd:)}
     [{cmd:(}{it:{help testnl##exp:exp}} {cmd:=} {it:{help testnl##exp:exp}}
     [{cmd:=} {it:{help testnl##exp:exp}} ...]{cmd:)} {it:...}]
[{cmd:,} {it:options}] 
  
{synoptset 15}{...}
{synopthdr}
{synoptline}
{synopt:{opt m:test}[{opt (opt)}]}test each condition separately {p_end}
{synopt:{opt iter:ate(#)}}use maximum {it:#} of iterations to find
	the optimal step size {p_end}

{synopt :{opt df(#)}}use F distribution with {it:#} denominator degrees of
        freedom for the reference distribution of the test statistic{p_end}
{synopt:{opt nosvy:adjust}}carry out the Wald test as W/k ~ F(k,d);
	for use with {opt svy} estimation commands when the {cmd:df()} option
	is also specified{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt df(#)} and {cmd:nosvyadjust} do not appear in the dialog box.
{p_end}

{pstd}
The second syntax means that if more than one expression is specified, each
must be surrounded by parentheses.

{marker exp}{...}
{pstd}
{it:exp} is a possibly nonlinear expression containing{p_end}
	    {cmd:_b[}{it:coef}{cmd:]}
	    {cmd:_b[}{it:eqno}{cmd::}{it:coef}{cmd:]}
	    {cmd:[}{it:eqno}{cmd:]}{it:coef}
            {cmd:[}{it:eqno}{cmd:]_b[}{it:coef}{cmd:]}

{marker eqno}{...}
{pstd}{it:eqno} is{p_end}
	    {cmd:#}{it:#}
	    {it:name}

{pstd}
{it:coef} identifies a coefficient in the model.
{it:coef} is typically a variable name, a level indicator, an interaction
indicator, or an interaction involving continuous variables.
Level indicators identify one level of a factor variable and interaction
indicators identify one combination of levels of an interaction; see
{help fvvarlist}.
{it:coef} may contain time-series operators; see {help tsvarlist}.

{pstd}
Distinguish between {cmd:[]}, which are to be typed, and [], which indicate
optional arguments.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{opt testnl} tests (linear or nonlinear) hypotheses about the estimated
parameters from the most recently fit model.

{pstd}
{opt testnl} produces Wald-type tests of smooth nonlinear (or linear)
hypotheses about the estimated parameters from the most recently fit
model.  The p-values are based on the delta method, an approximation
appropriate in large samples.

{pstd}
{cmd:testnl} can be used with {cmd:svy} estimation results, see
{manhelp svy_postestimation SVY:svy postestimation}.

{pstd}
The format
{cmd:(}{it:{help testnl##exp:exp1}}{cmd:=}{it:exp2}{cmd:=}{it:exp3}... {cmd:)}
for a simultaneous-equality hypothesis is just a convenient shorthand for
a list {cmd:(}{it:exp1}{cmd:=}{it:exp2}{cmd:)}
{cmd:(}{it:exp1}{cmd:=}{it:exp3}{cmd:)}, etc.

{pstd}
{opt testnl} may also be used to test linear hypotheses.  {cmd:test} is faster
if you want to test only linear hypotheses; see {manhelp test R}.
{opt testnl} is the only option for testing linear and nonlinear hypotheses
simultaneously.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R testnlQuickstart:Quick start}

        {mansection R testnlRemarksandexamples:Remarks and examples}

        {mansection R testnlMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt mtest}[{opt (opt)}]
   specifies that tests be performed for each condition separately.  {it:opt}
   specifies the method for adjusting p-values for multiple testing.  Valid
   values for {it:opt} are

{pin3}{opt b:onferroni}{space 4}Bonferroni's method{p_end}
{pin3}{opt h:olm}{space      10}Holm's method{p_end}
{pin3}{opt s:idak}{space      9}Sidak's method{p_end}
{pin3}{opt noadj:ust}{space   6}no adjustment is to be made{p_end}
   
{pmore}
   Specifying {opt mtest} without an argument is equivalent to
   {cmd:mtest(noadjust)}.

{phang}
{opt iterate(#)} specifies the maximum number of iterations used to find the
   optimal step size in the calculation of numerical derivatives of the test
   expressions.  By default, the maximum number of iterations is 100, but
   convergence is usually achieved after only a few iterations.  You should
   rarely have to use this option.

{pstd}
The following options are available with {opt testnl} but are not shown in the
dialog box:

{phang}
{opt df(#)} specifies that the F distribution with {it:#} denominator
degrees of freedom be used for the reference distribution of the test
statistic.  With survey data, {it:#} is the design degrees of freedom unless
{cmd:nosvyadjust} is specified.

{phang}
{cmd:nosvyadjust}
   is for use with {cmd:svy} estimation commands when the {cmd:df()} option is
   also specified; see {manhelp svy_estimation SVY:svy estimation}.  It
   specifies that the Wald test be carried out without the default adjustment
   for the design degrees of freedom.  That is, the test is carried out as
   {bind:W/k ~ F(k,d)} rather than as {bind:(d-k+1)W/(kd) ~ F(k,d-k+1)}, where
   {bind:k = the dimension} of the test and d = the design degrees of freedom
   specified in the {cmd:df()} option.


{marker remarks}{...}
{title:Remarks}

{pstd}
In contrast to likelihood-ratio tests, different -- mathematically
equivalent -- formulations of an hypothesis may lead to different results
for a nonlinear Wald test (lack of "invariance"). For instance, the two
hypotheses

	H0: b1 = b2

	H0: exp(b1) = exp(b2)

{pstd}
are mathematically equivalent expressions but do not yield the same test
statistic and p-value. In extreme cases, under one formulation, one would
reject H0, whereas under an equivalent formulation one would not reject H0.

{pstd}
Likelihood-ratio testing does satisfy representation invariance.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. generate weightsq = weight^2}{p_end}
{phang2}{cmd:. regress price mpg trunk length weight weightsq foreign}{p_end}

{pstd}Test one nonlinear constraint{p_end}
{phang2}{cmd:. testnl _b[mpg] = 1/_b[weight]}{p_end}

{pstd}Test multiple nonlinear constraints{p_end}
{phang2}{cmd:. testnl (_b[mpg] = 1/_b[weight]) (_b[trunk] = 1/_b[length])}

{pstd}Test multiple nonlinear constraints separately, and adjust p-values using Holm's method{p_end}
{phang2}{cmd:. testnl (_b[mpg] = 1/_b[weight]) (_b[trunk] = 1/_b[length]), mtest(holm)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:testnl} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
{synopt:{cmd:r(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:r(chi2)}}chi-squared{p_end}
{synopt:{cmd:r(p)}}p-value for Wald test{p_end}
{synopt:{cmd:r(F)}}F statistic{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(mtmethod)}}method specified in {cmd:mtest()}{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(G)}}derivatives of R(b) with respect to b; see
    {mansection R testnlMethodsandformulas:{it:Methods and formulas}} in
    {bf:[R] testnl}{p_end}
{synopt:{cmd:r(R)}}R(b)-q; see
    {mansection R testnlMethodsandformulas:{it:Methods and formulas}} in
    {bf:[R] testnl}{p_end}
{synopt:{cmd:r(mtest)}}multiple test results{p_end}
{p2colreset}{...}
