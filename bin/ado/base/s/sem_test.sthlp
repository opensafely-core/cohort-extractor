{smcl}
{* *! version 1.0.7  19oct2017}{...}
{viewerdialog test "dialog test"}{...}
{vieweralsosee "[SEM] test" "mansection SEM test"}{...}
{findalias assembequal}{...}
{findalias assemcorr}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] estat eqtest" "help sem_estat_eqtest"}{...}
{vieweralsosee "[SEM] estat stdize" "help sem_estat_stdize"}{...}
{vieweralsosee "[SEM] lincom" "help sem_lincom"}{...}
{vieweralsosee "[SEM] lrtest" "help sem_lrtest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{viewerjumpto "Syntax" "sem_test##syntax"}{...}
{viewerjumpto "Menu" "sem_test##menu"}{...}
{viewerjumpto "Description" "sem_test##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_test##linkspdf"}{...}
{viewerjumpto "Options" "sem_test##options"}{...}
{viewerjumpto "Remarks" "sem_test##remarks"}{...}
{viewerjumpto "Examples" "sem_test##examples"}{...}
{viewerjumpto "Stored results" "sem_test##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[SEM] test} {hline 2}}Wald test of linear hypothesis{p_end}
{p2col:}({mansection SEM test:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmdab:te:st}
{it:{help test##coeflist:coeflist}}

{phang2}
{cmdab:te:st}
{it:{help test##exp:exp}} {cmd:=} {it:{help test##exp:exp}} [{cmd:=} ...]

{phang2}
{cmdab:te:st}
{cmd:[}{it:{help test##eqno:eqno}}{cmd:]}
[{cmd::} {it:{help test##coeflist:coeflist}}]

{phang2}
{cmdab:te:st}
{cmd:[}{it:{help test##eqno:eqno}} {cmd:=}
            {it:{help test##eqno:eqno}} [{cmd:=} ...]{cmd:]}
[{cmd::} {it:{help test##coeflist:coeflist}}]

{p 8 14 2}
{cmdab:te:st}
{cmd:(}{it:{help test##spec:spec}}{cmd:)}
[{cmd:(}{it:{help test##spec:spec}}{cmd:)} ...]
[{cmd:,} {it:{help test:test_options}}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Testing and CIs > Wald tests of linear hypotheses}


{marker description}{...}
{title:Description}

{pstd}
{cmd:test} is a postestimation command for use after {cmd:sem}, {cmd:gsem},
and other Stata estimation commands.

{pstd}
{cmd:test} performs the Wald test of the hypothesis or hypotheses that you
specify.  In the case of {cmd:sem} and {cmd:gsem}, you must use the
{cmd:_b[]} coefficient notation.

{pstd}
See {helpb test:[R] test}.  Also documented there is {cmd:testparm}.
{cmd:testparm} cannot be used after {cmd:sem} or {cmd:gsem} because its syntax
hinges on use of shortcuts for referring to coefficients.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM testRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
See {it:{help test##options_test:Options for test}} in {helpb test:[R] test}.


{marker remarks}{...}
{title:Remarks}

{pstd}    
See {findalias sembequal} and {findalias semcorr}.

{pstd}    
{cmd:test} works in the metric of SEM, which is to say path
coefficients, variances, and covariances.  If you want to frame your tests in
terms of standardized coefficients and correlations and you fit your model
with {cmd:sem}, not {cmd:gsem}, then prefix {cmd:test} with
{cmd:estat stdize:}; see {helpb sem_estat_stdize:[SEM] estat stdize}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_2fmm}{p_end}
{phang2}{cmd:. sem (Affective -> a1 a2 a3 a4 a5) (Cognitive -> c1 c2 c3 c4 c5)}{p_end}

{pstd}Show coefficient legend{p_end}
{phang2}{cmd:. sem, coeflegend}{p_end}

{pstd}Test that all coefficients for Affective are zero{p_end}
{phang2}{cmd:. test _b[a1:Affective] = _b[a2:Affective] = _b[a3:Affective]}{break}
	{cmd: = _b[a4:Affective] = _b[a5:Affective]}{p_end}

{pstd}Test that the error variances for {cmd:a1} and {cmd:a2} are equal{p_end}
{phang2}{cmd:. test _b[/var(e.a1)] =  _b[/var(e.a2)]}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {it:{help test##results:Stored results}} in
{helpb test:[R] test}.{p_end}
