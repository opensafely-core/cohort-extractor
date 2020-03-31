{smcl}
{* *! version 1.1.11  15jun2019}{...}
{viewerdialog bsample "dialog bsample"}{...}
{vieweralsosee "[R] bsample" "mansection R bsample"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bootstrap" "help bootstrap"}{...}
{vieweralsosee "[R] bstat" "help bstat"}{...}
{vieweralsosee "[D] sample" "help sample"}{...}
{vieweralsosee "[R] simulate" "help simulate"}{...}
{vieweralsosee "[D] splitsample" "help splitsample"}{...}
{viewerjumpto "Syntax" "bsample##syntax"}{...}
{viewerjumpto "Menu" "bsample##menu"}{...}
{viewerjumpto "Description" "bsample##description"}{...}
{viewerjumpto "Links to PDF documentation" "bsample##linkspdf"}{...}
{viewerjumpto "Options" "bsample##options"}{...}
{viewerjumpto "Examples" "bsample##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] bsample} {hline 2}}Sampling with replacement{p_end}
{p2col:}({mansection R bsample:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:bsample}
	[{it:exp}]
	{ifin}
	[{cmd:,} {it:options}]

{phang}
where {it:exp} is a standard Stata expression specifying the size of the
sample; see {help exp}.

{pmore}
{it:exp} must be less than or equal to {helpb _N} (the number of observations)
when neither the {cmd:cluster()} nor the {cmd:strata()} option is specified.
{cmd:_N} is the default when {it:exp} is not specified.

{pmore}
Observations that do not meet the optional {helpb if} and {helpb in}
criteria are dropped from the resulting dataset.

{synoptset 21}{...}
{synopthdr}
{synoptline}
{synopt :{opth str:ata(varlist)}}variables identifying strata{p_end}
{synopt :{opth cl:uster(varlist)}}variables identifying resampling clusters{p_end}
{synopt :{opth id:cluster(newvar)}}create new cluster ID variable{p_end}
{synopt :{opth w:eight(varname)}}replace {it:varname} with frequency weights{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Resampling > Draw bootstrap sample}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bsample} replaces the data in memory with a bootstrap sample (random
sample with replacement) drawn from the current dataset.  Clusters can be
optionally sampled during each replication in place of observations.
Bootstrap samples can also be selected within strata.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R bsampleQuickstart:Quick start}

        {mansection R bsampleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth strata(varlist)} specifies the variables identifying strata.  If
{opt strata()} is specified, bootstrap samples are selected within each
stratum, and {it:exp} must be less than or equal to {cmd:_N} within the
defined strata.

{phang}
{opth cluster(varlist)} specifies the variables identifying resampling
clusters.  If {opt cluster()} is specified, the sample drawn during each
replication is a bootstrap sample of clusters, and {it:exp} must be less than
or equal to N_c (the number of clusters identified by the {cmd:cluster()}
option).  If {cmd:strata()} is also specified, {it:exp} must be less than or
equal to the number of within-strata clusters.

{phang}
{opth idcluster(newvar)} creates a new variable containing a unique
identifier for each resampled cluster.

{phang}
{opth weight(varname)} specifies a variable in which the sampling frequencies
will be placed.  {it:varname} must be an existing variable, which will be
replaced.  After {cmd:bsample}, {it:varname} can be used as an {opt fweight}
in any Stata command that accepts {opt fweight}s, which can speed up
resampling for commands like {cmd:regress} and {cmd:summarize}.  This option
cannot be combined with {opt idcluster()}.

{pmore}
By default, {cmd:bsample} replaces the data in memory with the sampled
observations; however, specifying the {opt weight()} option causes only the
specified {it:varname} to be changed.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse bsample1}{p_end}

{pstd}Take bootstrap sample of size 200{p_end}
{phang2}{cmd:. bsample 200}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse bsample1, clear}{p_end}

{pstd}Take bootstrap samples of size 200 for females and males{p_end}
{phang2}{cmd:. bsample 200, strata(female)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse bsample1, clear}{p_end}

{pstd}Take 10% bootstrap samples for females and males{p_end}
{phang2}{cmd:. bsample round(0.1*_N), strata(female)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse bsample1, clear}{p_end}

{pstd}Take bootstrap sample of size 200 from females{p_end}
{phang2}{cmd:. bsample 200 if female}{p_end}

    {hline}
