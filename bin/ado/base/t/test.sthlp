{smcl}
{* *! version 1.2.3  19oct2017}{...}
{viewerdialog test "dialog test"}{...}
{viewerdialog testparm "dialog testparm"}{...}
{vieweralsosee "[R] test" "mansection R test"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] anova" "help anova"}{...}
{vieweralsosee "[R] anova postestimation" "help anova_postestimation"}{...}
{vieweralsosee "[R] contrast" "help contrast"}{...}
{vieweralsosee "[R] lincom" "help lincom"}{...}
{vieweralsosee "[R] lrtest" "help lrtest"}{...}
{vieweralsosee "[R] nestreg" "help nestreg"}{...}
{vieweralsosee "[R] nlcom" "help nlcom"}{...}
{vieweralsosee "[R] testnl" "help testnl"}{...}
{viewerjumpto "Syntax" "test##syntax"}{...}
{viewerjumpto "Menu" "test##menu"}{...}
{viewerjumpto "Description" "test##description"}{...}
{viewerjumpto "Links to PDF documentation" "test##linkspdf"}{...}
{viewerjumpto "Options for testparm" "test##options_testparm"}{...}
{viewerjumpto "Options for test" "test##options_test"}{...}
{viewerjumpto "Examples" "test##examples"}{...}
{viewerjumpto "Stored results" "test##results"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[R] test} {hline 2}}Test linear hypotheses after estimation{p_end}
{p2col:}({mansection R test:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{marker syntax1}{...}
{p 8 48 2}
{cmdab:te:st}
{it:{help test##coeflist:coeflist}}
{space 31}({help test##Syntax1:Syntax 1})

{marker syntax2}{...}
{p 8 48 2}
{cmdab:te:st}
{it:{help test##exp:exp}} {cmd:=} {it:{help test##exp:exp}} [{cmd:=} ...]
{space 22}({help test##Syntax2:Syntax 2})

{marker syntax3}{...}
{p 8 48 2}
{cmdab:te:st}
{cmd:[}{it:{help test##eqno:eqno}}{cmd:]}
[{cmd::} {it:{help test##coeflist:coeflist}}]
{space 20}({help test##Syntax3:Syntax 3})

{marker syntax4}{...}
{p 8 48 2}
{cmdab:te:st}
{cmd:[}{it:{help test##eqno:eqno}} {cmd:=}
            {it:{help test##eqno:eqno}} [{cmd:=} ...]{cmd:]}
[{cmd::} {it:{help test##coeflist:coeflist}}]
{space 5}({help test##Syntax4:Syntax 4})

{p 8 17 2}
{cmd:testparm}
{varlist}
[{cmd:,} {help test##testparm_options:{it:testparm_options}}]


{pstd}
Full syntax

{p 8 14 2}
{cmdab:te:st}
{cmd:(}{it:{help test##spec:spec}}{cmd:)}
[{cmd:(}{it:{help test##spec:spec}}{cmd:)} ...]
[{cmd:,} {help test##test_options:{it:test_options}}]


{marker testparm_options}{...}
{synoptset 19}{...}
{synopthdr:testparm_options}
{synoptline}
{synopt:{opt e:qual}}hypothesize that the coefficients are equal to each
other{p_end}
{synopt:{opth eq:uation(test##eqno:eqno)}}specify equation name or number for
which the hypothesis is tested{p_end}
{synopt:{opt nosvy:adjust}}compute unadjusted Wald tests for survey results
{p_end}

{synopt:{opt df(#)}}use F distribution with {it:#} denominator degrees of
freedom for the reference distribution of the test statistic; for survey data,
{it:#} specifies the design degrees of freedom unless {cmd:nosvyadjust} is
specified
{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt df(#)} does not appear in the dialog box.{p_end}


{marker test_options}{...}
{synoptset 19 tabbed}{...}
{synopthdr:test_options}
{synoptline}
{syntab:Options}
{synopt:{opt m:test}[{cmd:(}{it:{help test##opt:opt}}{cmd:)}]}test each
condition separately{p_end}
{synopt:{opt coef}}report estimated constrained coefficients
{p_end}
{synopt:{opt a:ccumulate}}test hypothesis jointly with previously tested
hypotheses{p_end}
{synopt:{opt not:est}}suppress the output
{p_end}
{synopt:{opt common}}test only variables common to all the equations
{p_end}
{synopt:{opt cons:tant}}include the constant in coefficients to be tested
{p_end}
{synopt:{opt nosvy:adjust}}compute unadjusted Wald tests for survey results
{p_end}
{synopt:{opt min:imum}}perform test with the constant, drop terms until the
test becomes nonsingular, and test without the constant on the remaining
terms; highly technical{p_end}

{synopt :{opt matvlc(matname)}}save the variance-covariance matrix;
programmer's option{p_end}
{synopt:{opt df(#)}}use F distribution with {it:#} denominator degrees of
freedom for the reference distribution of the test statistic; for survey data,
{it:#} specifies the design degrees of freedom unless {cmd:nosvyadjust} is
specified {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:coeflist} and {it:varlist} may contain factor variables and time-series
operators; see {help fvvarlist} and {help tsvarlist}.
{p_end}
{p 4 6 2}
{opt matvlc(matname)} and {opt df(#)} do not appear in the dialog box.{p_end}


{pin2}{marker Syntax1}
{help test##syntax1:Syntax 1} tests that coefficients are 0.

{pin2}{marker Syntax2}
{help test##syntax2:Syntax 2} tests that linear expressions are equal.

{pin2}{marker Syntax3}
{help test##syntax3:Syntax 3} tests that coefficients in {it:eqno} are 0.

{pin2}{marker Syntax4}
{help test##syntax4:Syntax 4} tests equality of coefficients between equations.


{marker spec}{...}
{p 8 8 2}{it:spec} is one of{p_end}
{p 12 16 2}{it:coeflist}{p_end}
{p 12 16 2}{it:exp}{cmd:=}{it:exp}[={it:exp}]{p_end}
{p 12 16 2}{cmd:[}{it:eqno}{cmd:]}[{cmd::} {it:coeflist}]{p_end}
{p 12 16 2}{cmd:[}{it:eqno1}{cmd:=}{it:eqno2}[{cmd:=}...]{cmd:]}[{cmd:: } {it:coeflist}]{p_end}

{marker coeflist}{...}
	{it:coeflist} is
	    {it:coef} [{it:coef} ...]
	    {cmd:[}{it:eqno}{cmd:]}{it:coef} [{cmd:[}{it:eqno}{cmd:]}{it:coef}...]
            {cmd:[}{it:eqno}{cmd:]_b[}{it:coef}{cmd:]} [{cmd:[}{it:eqno}{cmd:]_b[}{it:coef}{cmd:]}...]

{marker exp}{...}
	{it:exp} is a linear expression containing
	    {it:coef}
	    {cmd:_b[}{it:coef}{cmd:]}
	    {cmd:_b[}{it:eqno}{cmd::}{it:coef}{cmd:]}
	    {cmd:[}{it:eqno}{cmd:]}{it:coef}
            {cmd:[}{it:eqno}{cmd:]_b[}{it:coef}{cmd:]}

{marker eqno}{...}
	{it:eqno} is
	    {cmd:#}{it:#}
	    {it:name}

{marker coef}{...}
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

{pstd}
Although not shown in the syntax diagram, parentheses around {it:spec} are
required only with multiple specifications.  Also, the diagram does not show
that {opt test} may be called without arguments to redisplay the results from
the last {opt test}.

{pstd}
{helpb anova} and {helpb manova} allow the {cmd:test} syntax above plus more
(see {helpb anova_postestimation##test:[R] anova postestimation} for
{cmd:test} after {cmd:anova}; see
{helpb manova_postestimation##test:[MV] manova postestimation} for
{cmd:test} after {cmd:manova}).


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{opt test} performs Wald tests of simple and composite linear hypotheses
about the parameters of the most recently fit model.

{pstd}
{opt test} supports {cmd:svy} estimators (see 
{manhelp svy_estimation SVY:svy estimation}), carrying out an adjusted Wald test
by default in such cases.  {cmd:test} can be used with {cmd:svy} estimation
results, see {manhelp svy_postestimation SVY:svy postestimation}.

{pstd}
{opt testparm} provides a useful alternative to {opt test} that permits
{varlist} rather than a list of coefficients (which is often nothing
more than a list of variables), allowing the use of standard Stata notation,
including '{opt -}' and '{opt *}', which are given the expression
interpretation by {opt test}.

{pstd}
{opt test} and {opt testparm} perform Wald tests.  For likelihood-ratio tests,
see {manhelp lrtest R}.
For Wald-type tests of nonlinear hypotheses, see {manhelp testnl R}.
To display estimates for one-dimensional linear or nonlinear expressions of
coefficients, see {manhelp lincom R} and {manhelp nlcom R}.

{pstd}
See {helpb anova_postestimation##test:[R] anova postestimation} for
additional {opt test} syntax allowed after {opt anova}.

{pstd}
See {helpb manova_postestimation##test:[MV] manova postestimation} for
additional {opt test} syntax allowed after {opt manova}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R testQuickstart:Quick start}

        {mansection R testRemarksandexamples:Remarks and examples}

        {mansection R testMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_testparm}{...}
{title:Options for testparm}

{phang}
{opt equal} tests that the variables
   appearing in {varlist}, which also appear in the previously fit model,
   are equal to each other rather than jointly equal to zero.

{phang}
{opth "equation(test##eqno:eqno)"}
   is relevant only for multiple-equation models, such as {cmd:mvreg},
   {cmd:mlogit}, and {cmd:heckman}.  It specifies the equation for which the
   all-zero or all-equal hypothesis is tested.  {cmd:equation(#1)} specifies
   that the test be conducted regarding the first equation {cmd:#1}.
   {cmd:equation(price)} specifies that the test concern the equation named
   {cmd:price}.

{phang}
{opt nosvyadjust}
   is for use with {opt svy} estimation commands; see
   {manhelp svy_estimation SVY:svy estimation}.  It specifies that the
   Wald test be carried out without the default adjustment for the design
   degrees of freedom.  That is, the test is carried out as
   {bind:W/k ~ F(k,d)} rather than as
   {bind:(d-k+1)W/(kd) ~ F(k,d-k+1)}, where {bind:k = the dimension} of the
   test and {bind:d = the total} number of sampled PSUs minus the total number
   of strata.  When the {cmd:df()} option is used, it will override the
   default design degrees of freedom.

{pstd}
The following option is available with {opt testparm} but is not shown in
the dialog box:

{phang}
{opt df(#)} specifies that the F distribution with {it:#} denominator
   degrees of freedom be used for the reference distribution of the test
   statistic.  The default is to use {cmd:e(df_r)} degrees of freedom or the
   chi-squared distribution if {cmd:e(df_r)} is missing.  With survey data, 
   {it:#} is the design degrees of freedom unless {cmd:nosvyadjust} is 
   specified.


{marker options_test}{...}
{title:Options for test}

{dlgtab:Options}

{phang}
{opt mtest}[{opt (opt)}]
specifies that tests be performed for each condition separately.  {it:opt}
specifies the method for adjusting p-values for multiple testing.  Valid
values for {it:opt} are

{marker opt}
{pin3}{opt b:onferroni}{space 4}Bonferroni's method{p_end}
{pin3}{opt h:olm}{space      10}Holm's method{p_end}
{pin3}{opt s:idak}{space      9}Sidak's method{p_end}
{pin3}{opt noadj:ust}{space   6}no adjustment is to be made{p_end}

{pmore}
   Specifying {opt mtest} without an argument is equivalent to
   {cmd:mtest(noadjust)}.

{phang}
{opt coef} specifies that the constrained coefficients be displayed.

{phang}
{opt accumulate} allows a hypothesis to be tested jointly with the previously
   tested hypotheses.

{phang}
{opt notest} suppresses the output.  This option is useful when you are
   interested only in the joint test of several hypotheses, specified in a
   subsequent call of {cmd:test, accumulate}.

{phang}
{opt common} specifies that when you use the
   {cmd:[}{it:{help test##eqno:eqno1}}{cmd:=}{it:eqno2}[{cmd:=}...]{cmd:]} form
   of {it:{help test##spec:spec}}, the variables common to the equations
   {it:eqno1}, {it:eqno2}, etc., be tested.  The default action is to complain
   if the equations have variables not in common.

{phang}
{opt constant} specifies that {opt _cons} be included in the list of
   coefficients to be tested when using the
   {cmd:[}{it:{help test##eqno:eqno1}}{cmd:=}{it:eqno2}[{cmd:=}...]{cmd:]}
   or {cmd:[}{it:eqno}{cmd:]} forms of {it:{help test##spec:spec}}.  The default
   is not to include {opt _cons}.

{phang}
{opt nosvyadjust}
   is for use with {opt svy} estimation commands; see
   {manhelp svy_estimation SVY:svy estimation}.  It specifies that the
   Wald test be carried out without the default adjustment for the design
   degrees of freedom.  That is, the test is carried out as
   {bind:W/k ~ F(k,d)} rather than as
   {bind:(d-k+1)W/(kd) ~ F(k,d-k+1)}, where {bind:k = the dimension} of the
   test and {bind:d = the total} number of sampled PSUs minus the total number
   of strata.  When the {cmd:df()} option is used, it will override the
   default design degrees of freedom.

{phang}
{opt minimum} is a highly technical option.  It first performs the test
   with the constant added.  If this test is singular, coefficients are
   dropped until the test becomes nonsingular.  Then the test without the
   constant is performed with the remaining terms.

{pstd}
The following options are available with {opt test} but are not shown in the
dialog box:

{phang}
{opt matvlc(matname)}, a programmer's option, saves the
   variance-covariance matrix of the linear combinations involved in the suite
   of tests.  For the test of the linear constraints L*b = c, {it:matname}
   contains L*V*L', where V is the estimated variance-covariance matrix of b.

{phang}
{opt df(#)} specifies that the F distribution with {it:#} denominator
   degrees of freedom be used for the reference distribution of the test
   statistic.  The default is to use {cmd:e(df_r)} degrees of freedom or the
   chi-squared distribution if {cmd:e(df_r)} is missing.  With survey data, 
   {it:#} is the design degrees of freedom unless {cmd:nosvyadjust} is 
   specified.


{marker examples}{...}
{title:Examples after single-equation estimation}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse census3}{p_end}
{phang2}{cmd:. regress brate medage medagesq i.region}

{pstd}Test coefficient on {cmd:3.region} is 0{p_end}
{phang2}{cmd:. test 3.region=0}{p_end}

{pstd}Shorthand for the previous {cmd:test} command{p_end}
{phang2}{cmd:. test 3.region}{p_end}

{pstd}Test coefficient on {cmd:2.region}=coefficient on {cmd:4.region}{p_end}
{phang2}{cmd:. test 2.region=4.region}{p_end}

{pstd}Stata will perform the algebra, and then do the test{p_end}
{phang2}{cmd:. test 2*(2.region-3*(3.region-4.region))=3.region+2.region+6*(4.region-3.region)}

{pstd}Test that coefficients on {cmd:2.region} and {cmd:3.region} are jointly
equal to 0{p_end}
{phang2}{cmd:. test (2.region=0) (3.region=0)}

{pstd}The following two commands are equivalent to the previous {cmd:test}
command{p_end}
{phang2}{cmd:. test 2.region = 0}{p_end}
{phang2}{cmd:. test 3.region = 0, accumulate}{p_end}

{pstd}Test that the coefficients on {cmd:2.region}, {cmd:3.region}, and
{cmd:4.region} are all 0; {cmd:testparm} understands a varlist{p_end}

{phang2}{cmd:. testparm i(2/4).region}

{pstd}
In the above example, you may substitute any single-equation estimation
command (such as {helpb clogit}, {helpb logistic}, {helpb logit}, and
{helpb ologit}) for {helpb regress}.

 
{title:Examples after multiple-equation estimation commands}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. sureg (price foreign mpg displ) (weight foreign length)}

{pstd}Test significance of {cmd:foreign} in the {cmd:price} equation{p_end}
{phang2}{cmd:. test [price]foreign}

{pstd}Test that {cmd:foreign} is jointly 0 in both equations{p_end}
{phang2}{cmd:. test [price]foreign [weight]foreign}

{pstd}Shorthand for the previous {cmd:test} command{p_end}
{phang2}{cmd:. test foreign}

{pstd}Test a cross-equation constraint{p_end}
{phang2}{cmd:. test [price]foreign = [weight]foreign}

{pstd}Alternative syntax for the previous test{p_end}
{phang2}{cmd:. test [price=weight]: foreign}

{pstd}Test all coefficients except the intercept in an equation{p_end}
{phang2}{cmd:. test [price]}

{pstd}Test that {cmd:foreign} and {cmd:displ} are jointly 0 in the {cmd:price}
equation{p_end}
{phang2}{cmd:. test [price]: foreign displ}

{pstd}Test that the coefficients on variables that are common to both
equations are jointly 0{p_end}
{phang2}{cmd:. test [price=weight], common}

{pstd}Simultaneous test of multiple constraints{p_end}
{phang2}{cmd:. test ([price]: foreign) ([weight]: foreign)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:test} and {cmd:testparm} store the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}
{synopt:{cmd:r(F)}}F statistic{p_end}
{synopt:{cmd:r(df)}}test constraints degrees of freedom{p_end}
{synopt:{cmd:r(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:r(dropped_i)}}index of {it:i}th constraint dropped{p_end}
{synopt:{cmd:r(chi2)}}chi-squared{p_end}
{synopt:{cmd:r(ss)}}sum of squares (test){p_end}
{synopt:{cmd:r(rss)}}residual sum of squares{p_end}
{synopt:{cmd:r(drop)}}{cmd:1} if constraints were dropped, {cmd:0} otherwise{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(mtmethod)}}method of adjustment for multiple testing{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(mtest)}}multiple test results{p_end}

{pstd}
{cmd:r(ss)} and {cmd:r(rss)} are defined only when {cmd:test} is used for
testing effects after {cmd:anova}.{p_end}
{p2colreset}{...}
