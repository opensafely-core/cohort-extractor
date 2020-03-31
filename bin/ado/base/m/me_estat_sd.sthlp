{smcl}
{* *! version 1.0.9  20mar2019}{...}
{viewerdialog estat "dialog estat"}{...}
{vieweralsosee "[ME] estat sd" "mansection ME estatsd"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] mecloglog" "help mecloglog"}{...}
{vieweralsosee "[ME] meglm" "help meglm"}{...}
{vieweralsosee "[ME] meintreg" "help meintreg"}{...}
{vieweralsosee "[ME] melogit" "help melogit"}{...}
{vieweralsosee "[ME] menbreg" "help menbreg"}{...}
{vieweralsosee "[ME] menl" "help menl"}{...}
{vieweralsosee "[ME] meologit" "help meologit"}{...}
{vieweralsosee "[ME] meoprobit" "help meoprobit"}{...}
{vieweralsosee "[ME] mepoisson" "help mepoisson"}{...}
{vieweralsosee "[ME] meprobit" "help meprobit"}{...}
{vieweralsosee "[ME] mestreg" "help mestreg"}{...}
{vieweralsosee "[ME] metobit" "help metobit"}{...}
{vieweralsosee "[ME] mixed" "help mixed"}{...}
{viewerjumpto "Syntax" "me estat sd##syntax"}{...}
{viewerjumpto "Menu for estat" "me estat sd##menu_estat"}{...}
{viewerjumpto "Description" "me estat sd##description"}{...}
{viewerjumpto "Links to PDF documentation" "me_estat_sd##linkspdf"}{...}
{viewerjumpto "Options" "me estat sd##option_estat_sd"}{...}
{viewerjumpto "Examples" "me estat sd##examples"}{...}
{viewerjumpto "Stored results" "me estat sd##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[ME] estat sd} {hline 2}}Display variance components as
standard deviations and correlations{p_end}
{p2col:}({mansection ME estatsd:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {opt sd} [{cmd:,} 
	{opt var:iance} {opt verbose} {opt post} {opt coefl:egend}]


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat sd} displays the random-effects and within-group error parameter
estimates as standard deviations and correlations.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ME estatsdRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option_estat_sd}{...}
{title:Options}

{phang}
{cmd:variance} specifies that {cmd:estat sd} display the random-effects and
within-group error parameter estimates as variances and covariances.  If the
{cmd:post} option is specified, the estimated variances and covariances and
their respective standard errors are posted to {cmd:e()}.
{cmd:variance} is allowed only after {helpb menl}.

{phang}
{cmd:verbose} specifies that the full estimation table be displayed.  By
default, only the random-effects and within-group error parameters are
displayed.  This option is implied when {cmd:post} is specified.

{phang}
{opt post} causes {opt estat sd} to behave like a Stata estimation (e-class)
command.  {opt estat sd} posts the vector of calculated standard deviation and
correlation parameters along with the corresponding variance-covariance matrix
to {cmd:e()}, so that you can treat the estimated parameters just as you
would results from any other estimation command.  For example, you could use
{cmd:test} to perform simultaneous tests of hypotheses on the parameters,
or you could use {cmd:lincom} to create linear combinations.

{pstd}
The following option is not shown in the dialog box:

{marker coeflegend}{...}
{phang}
{opt coeflegend} specifies that the legend of the coefficients and how to
specify them in an expression be displayed rather than displaying the
statistics for the coefficients.  This option is allowed only if one of
{cmd:verbose} or {cmd:post} is also specified.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse pig}{p_end}
{phang2}{cmd:. mixed weight week || id: week, covariance(unstructured)}{p_end}

{pstd}Display the estimated variance components as
correlations and standard deviations{p_end}
{phang2}{cmd:. estat sd}

{pstd}Same as above, but display the full estimation table{p_end}
{phang2}{cmd:. estat sd, verbose}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat sd} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(level)}}confidence level{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(b)}}coefficient vector{p_end}
{synopt:{cmd:r(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:r(table)}}table of results{p_end}

{pstd}
If {cmd:post} is specified, {cmd:estat sd} stores the following in {cmd:e()}:

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:estat sd}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{p2colreset}{...}
