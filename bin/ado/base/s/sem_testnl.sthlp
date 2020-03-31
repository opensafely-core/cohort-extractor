{smcl}
{* *! version 1.0.6  19oct2017}{...}
{viewerdialog testnl "dialog testnl"}{...}
{vieweralsosee "[SEM] testnl" "mansection SEM testnl"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] estat eqtest" "help sem_estat_eqtest"}{...}
{vieweralsosee "[SEM] estat stdize" "help sem_estat_stdize"}{...}
{vieweralsosee "[SEM] lrtest" "help sem_lrtest"}{...}
{vieweralsosee "[SEM] nlcom" "help sem_nlcom"}{...}
{vieweralsosee "[SEM] test" "help sem_test"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] testnl" "help testnl"}{...}
{viewerjumpto "Syntax" "sem_testnl##syntax"}{...}
{viewerjumpto "Menu" "sem_testnl##menu"}{...}
{viewerjumpto "Description" "sem_testnl##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_testnl##linkspdf"}{...}
{viewerjumpto "Options" "sem_testnl##options"}{...}
{viewerjumpto "Remarks" "sem_testnl##remarks"}{...}
{viewerjumpto "Examples" "sem_testnl##examples"}{...}
{viewerjumpto "Stored results" "sem_testnl##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[SEM] testnl} {hline 2}}Wald test of nonlinear hypothesis{p_end}
{p2col:}({mansection SEM testnl:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 33 2}
{cmd:testnl} {it:{help testnl##exp:exp}} {cmd:=} {it:{help testnl##exp:exp}}
       [{cmd:=} ...] [{cmd:,} {it:{help testnl:options}}]

{p 8 33 2}
{cmd:testnl} {cmd:(}{it:{help testnl##exp:exp}} {cmd:=}
       {it:{help testnl##exp:exp}}
     [{cmd:=} ...]{cmd:)}
     [{cmd:(}{it:{help testnl##exp:exp}} {cmd:=} {it:{help testnl##exp:exp}}
     [{cmd:=} ...]{cmd:)} {it:...}]
     [{cmd:,} {it:{help testnl:options}}] 


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Testing and CIs > Wald tests of nonlinear hypotheses}


{marker description}{...}
{title:Description}

{pstd}
{cmd:testnl} is a postestimation command for use after {cmd:sem}, {cmd:gsem},
and other Stata estimation commands.

{pstd}
{cmd:testnl} performs the Wald test of the nonlinear hypothesis or hypotheses.
In the case of {cmd:sem} and {cmd:gsem}, you must use the {cmd:_b[]}
coefficient notation.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM testnlRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
See {it:{help testnl##options:Options}} in {helpb testnl:[R] testnl}.


{marker remarks}{...}
{title:Remarks}

{pstd} 
{cmd:testnl} works in the metric of SEM, which is to say path coefficients,
variances, and covariances.  If you want to frame your tests in terms of
standardized coefficients and correlations and you fit the model with
{cmd:sem}, not {cmd:gsem}, then prefix {cmd:testnl} with
{cmd:estat stdize:}; see {helpb sem_estat_stdize:[SEM] estat stdize}.

{pstd} 
{cmd:estat stdize:} is unnecessary because, with {cmd:testnl}, everywhere you
wanted a standardized coefficient or correlation, you could just type the
formula.  If you did that, you would get the same answer except for numerical
precision.  In this case, the answer produced with the 
{cmd:estat stdize:} prefix will be a little more accurate because 
{cmd:estat stdize:} is able to substitute an analytic derivative in one part of
the calculation where {cmd:testnl}, doing the whole thing itself, would be
forced to use a numeric derivative. 


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_2fmm}{p_end}
{phang2}{cmd:. sem (Affective -> a1 a2 a3 a4 a5) (Cognitive -> c1 c2 c3 c4 c5)}{p_end}

{pstd}Test one nonlinear constraint{p_end}
{phang2}{cmd:. testnl _b[c3:Cognitive] = 1/_b[c2:Cognitive]}{p_end}

{pstd}Test multiple nonlinear constraints{p_end}
{phang2}{cmd:. testnl (_b[c3:Cognitive] = 1/_b[c2:Cognitive])}{break}
	{cmd: (_b[a3:Affective] = 1/_b[a2:Affective])}{p_end}

{pstd}Test multiple nonlinear constraints separately, and adjust p-values
using Holm's method{p_end}
{phang2}{cmd:. testnl (_b[c3:Cognitive] = 1/_b[c2:Cognitive])}{break}
	{cmd: (_b[a3:Affective] = 1/_b[a2:Affective]), mtest(holm)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {it:{help testnl##results:Stored results}} in
{helpb testnl:[R] testnl}.{p_end}
