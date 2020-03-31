{smcl}
{* *! version 1.1.12  15may2018}{...}
{viewerdialog symmetry "dialog symmetry"}{...}
{viewerdialog symmi "dialog symmi"}{...}
{vieweralsosee "[R] symmetry" "mansection R symmetry"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] Epitab" "help epitab"}{...}
{viewerjumpto "Syntax" "symmetry##syntax"}{...}
{viewerjumpto "Menu" "symmetry##menu"}{...}
{viewerjumpto "Description" "symmetry##description"}{...}
{viewerjumpto "Links to PDF documentation" "symmetry##linkspdf"}{...}
{viewerjumpto "Options" "symmetry##options"}{...}
{viewerjumpto "Examples" "symmetry##examples"}{...}
{viewerjumpto "Stored results" "symmetry##results"}{...}
{viewerjumpto "References" "symmetry##references"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[R] symmetry} {hline 2}}Symmetry and marginal homogeneity tests
{p_end}
{p2col:}({mansection R symmetry:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Symmetry and marginal homogeneity tests

{p 8 17 2}
{cmd:symmetry} {it:casesvar} {it:controlvar}
{ifin} 
[{it:{help symmetry##weight:weight}}]
[{cmd:,} {it:options}]


{pstd}
Immediate form of symmetry and marginal homogeneity tests

{p 8 17 2}
{cmd:symmi} {it:#}11 {it:#}12 [{it:...}]{cmd:\} {it:#}21 {it:#}22
	[{it:...}] [{cmd:\}{it:...}]
{ifin} [{cmd:,} {it:options}]


{synoptset 11 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt not:able}}suppress output of contingency table
{p_end}
{synopt:{opt con:trib}}report contribution of each off-diagonal cell pair
{p_end}
{synopt:{opt ex:act}}perform exact test of table symmetry
{p_end}
{synopt:{opt mh}}perform two marginal homogeneity tests
{p_end}
{synopt:{opt tr:end}}perform a test for linear trend in the (log)
relative risk (RR)
{p_end}
{synopt:{opt cc}}use continuity correction when calculating test for
linear trend
{p_end}
{synoptline}
{p2colreset}{...}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s are allowed; see {help weight}.
{p_end}


{marker menu}{...}
{title:Menu}

    {title:symmetry} 

{phang2}
{bf:Statistics > Epidemiology and related > Other >}
      {bf:Symmetry and marginal homogeneity test}

    {title:symmi}

{phang2}
{bf:Statistics > Epidemiology and related > Other >}
      {bf:Symmetry and marginal homogeneity test calculator}


{marker description}{...}
{title:Description}

{pstd}
{opt symmetry} performs asymptotic symmetry and marginal homogeneity tests,
as well as an exact symmetry test on K x K tables where there is a 1-to-1
matching of cases and controls (nonindependence). This testing is used to
analyze matched-pair case-control data with multiple discrete levels of the
exposure (outcome) variable. In genetics, the test is known as the
transmission/disequilibrium test (TDT) and is used to test the association
between transmitted and nontransmitted parental marker alleles to an affected
child ({help symmetry##SME1993:Spieldman, McGinnis, and Ewens 1993)}.
For 2 x 2 tables, the asymptotic
test statistics reduce to the McNemar test statistic, and the exact symmetry
test produces an exact McNemar test; see {manhelp Epitab R}.  For many
exposure variables, {opt symmetry} can optionally perform a test for linear
trend in the log relative risk.

{pstd}
{opt symmetry} expects the data to be in the wide format; that is, each
observation contains the matched case and control values in variables
{it:casesvar} and {it:controlvar}.  Variables can be numeric or string.

{pstd}
{opt symmi} is the immediate form of {opt symmetry}.  The {opt symmi} command
uses the values specified on the command line; rows are separated by '\', and
options are the same as for {opt symmetry}.
See {help immed} for a general introduction to immediate commands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R symmetryQuickstart:Quick start}

        {mansection R symmetryRemarksandexamples:Remarks and examples}

        {mansection R symmetryMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt notable} suppresses the output of the contingency table.
By default, {opt symmetry} displays the n x n contingency table at the top of
the output.

{phang}
{opt contrib} reports the contribution of each off-diagonal cell pair
to the overall symmetry chi-squared.

{phang}
{opt exact} performs an exact test of table symmetry.
This option is recommended for sparse tables.  CAUTION:  The
exact test requires substantial amounts of time and memory for large tables.

{phang}
{opt mh} performs two marginal homogeneity tests that do not require
the inversion of the variance-covariance matrix.

{pmore}
By default, {opt symmetry} produces the Stuart-Maxwell test statistic, which
requires the inversion of the nondiagonal variance-covariance matrix, V.
When the table is sparse, the matrix may not be full rank, and then
the command substitutes a generalized inverse V* for V^(-1).
{opt mh} calculates optional marginal homogeneity statistics that do not require
the inversion of the variance-covariance matrix.  These tests may be preferred
in certain situations. See
{mansection R symmetryMethodsandformulas:{it:Methods and formulas}} and
{help symmetry##BC1995:Bickeb{c o:}ller and Clerget-Darpoux (1995)} for details
on these test statistics.

{phang}
{opt trend} performs a test for linear trend in the (log) relative risk
(RR).  This option is allowed only for numeric exposure (outcome) variables,
and its use should be restricted to measurements on the ordinal or interval
scales.

{phang}
{opt cc} specifies that the continuity correction be used when
calculating the test for linear trend. This correction should be
specified only when the levels of the exposure variable are equally spaced.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse iran}{p_end}

{pstd}Test the symmetry{p_end}
{phang2}{cmd:. symmetry before after}{p_end}

{pstd}Exact test of symmetry{p_end}
{phang2}{cmd:. symmetry before after, exact}

{pstd}Show contribution of cells to symmetry{p_end}
{phang2}{cmd:. symmetry before after, contrib}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse bd163}{p_end}

{pstd}Specify {cmd:fweight} because observations correspond to more than one
matched pair{p_end}
{phang2}{cmd:. symmetry case control [fw=count]}{p_end}

{pstd}Create new variable {cmd:ca} based on existing variable {cmd:case}{p_end}
{phang2}{cmd:. encode case, gen(ca)}{p_end}

{pstd}Create new variable {cmd:co} based on existing variable
{cmd:control}{p_end}
{phang2}{cmd:. encode control, gen(co)}{p_end}

{pstd}Perform test for linear trend and do continuity correction{p_end}
{phang2}{cmd:. symmetry ca co [fw=count], trend cc }{p_end}

{pstd}Same as above, but suppress output of contingency table{p_end}
{phang2}{cmd:. symmetry ca co [fw=count], trend cc notable}{p_end}

{pstd}Immediate form of symmetry and marginal homogeneity tests{p_end}
{phang2}{cmd:. symmi 47 56 38 \ 28 61 31 \ 26 47 10}

{pstd}Same as above, but report contribution of each off-diagonal cell
pair{p_end}
{phang2}{cmd:. symmi 47 56 38 \ 28 61 31 \ 26 47 10, contrib}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:symmetry} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N_pair)}}number of matched pairs{p_end}
{synopt:{cmd:r(chi2)}}asymptotic symmetry chi-squared{p_end}
{synopt:{cmd:r(df)}}asymptotic symmetry degrees of freedom{p_end}
{synopt:{cmd:r(p)}}asymptotic symmetry p-value{p_end}
{synopt:{cmd:r(chi2_sm)}}MH (Stuart-Maxwell) chi-squared{p_end}
{synopt:{cmd:r(df_sm)}}MH (Stuart-Maxwell) degrees of freedom{p_end}
{synopt:{cmd:r(p_sm)}}MH (Stuart-Maxwell) p-value{p_end}
{synopt:{cmd:r(chi2_b)}}MH (Bickenboller) chi-squared{p_end}
{synopt:{cmd:r(df_b)}}MH (Bickenboller) degrees of freedom{p_end}
{synopt:{cmd:r(p_b)}}MH (Bickenboller) p-value{p_end}
{synopt:{cmd:r(chi2_nd)}}MH (no diagonals) chi-squared{p_end}
{synopt:{cmd:r(df_nd)}}MH (no diagonals) degrees of freedom{p_end}
{synopt:{cmd:r(p_nd)}}MH (no diagonals) p-value{p_end}
{synopt:{cmd:r(chi2_t)}}chi-squared for linear trend{p_end}
{synopt:{cmd:r(p_trend)}}p-value for linear trend{p_end}
{synopt:{cmd:r(p_exact)}}exact symmetry p-value{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker BC1995}{...}
{phang}
Bickeb{c o:}ller, H., and F. Clerget-Darpoux. 1995. Statistical properties
of the allelic and genotypic transmission/disequilibrium test for multiallelic
markers. {it:Genetic Epidemiology} 12: 865-870.

{marker SME1993}{...}
{phang}
Spieldman, R. S., R. E. McGinnis, and W. J. Ewens. 1993.
Transmission test for linkage disequilibrium: The insulin gene region and
insulin-dependence diabetes mellitus (IDDM).
{it:American Journal of Human Genetics} 52: 506-516.
{p_end}
