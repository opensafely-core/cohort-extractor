{smcl}
{* *! version 1.0.10  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi test" "mansection MI mitest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{vieweralsosee "[MI] mi estimate using" "help mi_estimate_using"}{...}
{vieweralsosee "[MI] mi estimate postestimation" "help mi estimate postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Glossary" "help mi glossary"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] Intro substantive" "help mi intro substantive"}{...}
{viewerjumpto "Syntax" "mi_test##syntax"}{...}
{viewerjumpto "Menu" "mi_test##menu"}{...}
{viewerjumpto "Description" "mi_test##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_test##linkspdf"}{...}
{viewerjumpto "Options" "mi_test##options"}{...}
{viewerjumpto "Examples" "mi_test##examples"}{...}
{viewerjumpto "Stored results" "mi_test##results"}{...}
{viewerjumpto "References" "mi_test##references"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[MI] mi test} {hline 2}}Test hypotheses after mi estimate{p_end}
{p2col:}({mansection MI mitest:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Test that coefficients are zero

{p 8 16 2}
{cmd:mi} {cmd:test} {it:{help mi test##coeflist:coeflist}}


{pstd}
Test that coefficients within a single equation are zero

{p 8 16 2}
{cmd:mi} {cmd:test} [{it:{help mi test##eqno:eqno}}] [{cmd::}
     {it:{help mi test##coeflist:coeflist}}]


{pstd}
Test that subsets of coefficients are zero (full syntax)

{p 8 16 2}
{cmd:mi} {cmd:test} {cmd:(}{it:{help mi test##spec:spec}}{cmd:)} [{cmd:(}{it:{help mi test##spec:spec}}{cmd:)} ...]
  [{cmd:,} {it:{help mi test##test_options:test_options}}]


{pstd}
Test that subsets of transformed coefficients are zero

{p 8 16 2}
{cmd:mi} {cmdab:testtr:ansform} {it:{help mi test##name:name}}
  [{cmd:(}{it:{help mi test##name:name}}{cmd:)} ...]
  [{cmd:,} {it:{help mi test##transform_options:transform_options}}]


{marker test_options}{...}
{synoptset 18 tabbed}{...}
{synopthdr:test_options}
{synoptline}
{syntab:Test}
{synopt: {opt ufmit:est}}perform unrestricted FMI model test{p_end}
{synopt: {opt nosmall}}do not apply small-sample correction to degrees of
    freedom{p_end}
{synopt: {opt cons:tant}}include the constant in coefficients to be tested{p_end}
{synoptline}


{marker transform_options}{...}
{synoptset 18 tabbed}{...}
{synopthdr:transform_options}
{synoptline}
{syntab:Test}
{synopt: {opt ufmit:est}}perform unrestricted FMI model test{p_end}
{synopt: {opt nosmall}}do not apply small-sample correction to degrees of
    freedom{p_end}
{synopt: {opt noleg:end}}suppress transformation legend{p_end}
{synoptline}


{marker coeflist}{...}
{p 4 6 2}
{it:coeflist} may contain factor variables and time-series operators; see
{help fvvarlist} and {help tsvarlist}.

    {it:coeflist} is
          {it:coef} [{it:coef} ...]
          {cmd:[}{it:eqno}{cmd:]}{it:coef} [{cmd:[}{it:eqno}{cmd:]}{it:coef}...]
          {cmd:[}{it:eqno}{cmd:]_b[}{it:coef}{cmd:]}[{cmd:[}{it:eqno}{cmd:]}_b{cmd:[}{it:coef}{cmd:]}...]

{marker eqno}{...}
     {it:eqno} is
          {cmd:#}{it:#}
          {it:eqname}

{marker spec}{...}
    {it:spec} is
          {it:coeflist}
          {cmd:[}{it:eqno}{cmd:]} [{cmd::} {it:coeflist}]

{pstd}
{it:coef} identifies a coefficient in the model; see
the {help test##coef:description} in {manhelp test R} for
details.  {it:eqname} is an equation name.

{marker name}{...}
{pstd}
{it:name} is an expression name as specified with
{cmd:mi estimate} or {cmd:mi estimate using} (see
{manhelp mi_estimate MI:mi estimate} or
{manhelp mi_estimate_using MI:mi estimate using}).


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:test} performs joint tests of coefficients. 

{p 4 4 2}
{cmd:mi} {cmd:testtransform} performs joint tests of transformed coefficients
as specified with {helpb mi estimate} or {helpb mi estimate using}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI mitestRemarksandexamples:Remarks and examples}

        {mansection MI mitestMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Test}

{phang}
{cmd:ufmitest} specifies that the unrestricted fraction missing
information (FMI) model test be used.  The default test performed
assumes equal fractions of information missing due to nonresponse for all
coefficients.  This is equivalent to the assumption that the
between-imputation and within-imputation variances are proportional.  The
unrestricted test may be preferable when this assumption is suspect provided
that the number of imputations is large relative to the number of estimated
coefficients.

{phang}
{cmd:nosmall} specifies that no small-sample adjustment be made to the degrees
of freedom.  By default, individual tests of coefficients (and transformed
coefficients) use the small-sample adjustment of
{help mi test##BR1999:Barnard and Rubin (1999)},
and the overall model test uses the small-sample adjustment of
{help mi test##R2007:Reiter (2007)}.

{phang}
{cmd:constant} specifies that {cmd:_cons} be included in the list of
coefficients to be tested when using the
{cmd:[}{it:{help mi test##eqno:eqno}}{cmd:]} form of
{it:{help mi test##spec:spec}} with {cmd:mi test}.  The default is to
not include {cmd:_cons}.

{phang}
{cmd:nolegend}, specified with {cmd:mi testtransform}, suppresses
transformation legend.


{marker examples}{...}
{title:Examples}

{pstd}Test that {cmd:tax}, {cmd:sqft}, {cmd:age}, {cmd:nfeatures}, {cmd:ne},
{cmd:custom}, and {cmd:corner} are in the regression analysis of house resale
prices{p_end}
{phang2}{cmd:. webuse mhouses1993s30}{p_end}
{phang2}{cmd:. mi estimate: regress price tax sqft age nfeatures ne custom corner}{p_end}
{phang2}{cmd:. mi test tax sqft age nfeatures ne custom corner}{p_end}

{pstd}Test that a subset of coefficients, say, {cmd:sqft} and {cmd:tax}, are
equal to zero{p_end}
{phang2}{cmd:. mi test tax sqft}{p_end}

{pstd}Test the equality of coefficients for {cmd:sqft} and {cmd:tax}{p_end}
{phang2}{cmd:. mi estimate (diff: _b[tax]-_b[sqft]), saving(miest):}{p_end}
{phang3}{cmd:regress price tax sqft age nfeatures ne custom corner}{p_end}
{phang2}{cmd:. mi testtransform diff}{p_end}

{pstd}Test whether three coefficients are jointly equal{p_end}
{phang2}{cmd:. mi estimate (diff1: _b[tax]-_b[sqft]) (diff2: _b[custom]-_b[tax]) using miest}{p_end}
{phang2}{cmd:. mi testtr diff1 diff2}{p_end}

{pstd}Test nonlinear hypotheses{p_end}
{phang2}{cmd:. mi estimate (rdiff: _b[tax]/_b[sqft] - 1) using miest}{p_end}
{phang2}{cmd:. mi testtr rdiff}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mi} {cmd:test} and {cmd:mi} {cmd:testtransform} store the following in
{cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(df)}}test constraints degrees of freedom{p_end}
{synopt:{cmd:r(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}
{synopt:{cmd:r(F)}}F statistic{p_end}
{synopt:{cmd: r(drop)}}{cmd:1} if constraints were dropped, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(dropped_i)}}index of ith constraint dropped{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker BR1999}{...}
{phang}
Barnard, J., and D. B. Rubin. 1999. Small-sample degrees of freedom with
multiple imputation. {it:Biometrika} 86: 948-955.

{marker R2007}{...}
{phang}
Reiter, J. P. 2007. Small-sample degrees of freedom for multi-component
significance tests with multiple imputation for missing data.
{it:Biometrika} 94: 502-508.
{p_end}
