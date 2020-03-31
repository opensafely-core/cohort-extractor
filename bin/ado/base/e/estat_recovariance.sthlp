{smcl}
{* *! version 1.0.4  23may2018}{...}
{viewerdialog estat "dialog estat"}{...}
{vieweralsosee "[ME] estat recovariance" "mansection ME estatrecovariance"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] menl" "help menl"}{...}
{vieweralsosee "[ME] mixed" "help mixed"}{...}
{viewerjumpto "Syntax" "estat recovariance##syntax"}{...}
{viewerjumpto "Menu for estat" "estat recovariance##menu_estat"}{...}
{viewerjumpto "Description" "estat recovariance##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_recovariance##linkspdf"}{...}
{viewerjumpto "Options" "estat recovariance##option_estat_recovariance"}{...}
{viewerjumpto "Example" "estat recovariance##example"}{...}
{viewerjumpto "Stored results" "estat recovariance##results"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[ME] estat recovariance} {hline 2}}Display estimated
random-effects covariance matrices{p_end}
{p2col:}({mansection ME estatrecovariance:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {opt recov:ariance} [{cmd:,} {opt relev:el(levelvar)}
          {opt corr:elation} {help matlist:{it:matlist_options}}]


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat recovariance} is for use after estimation with {cmd:menl}
and {cmd:mixed}.

{pstd}
{cmd:estat recovariance} displays the estimated variance-covariance matrix 
of the random effects for each level in the model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ME estatrecovarianceRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option_estat_recovariance}{...}
{title:Options}

{phang}
{opt relevel(levelvar)} specifies the level in the model for which the
random-effects covariance matrix is to be displayed.
By default, the covariance matrices for all levels in the model
are displayed.  {it:levelvar} is the name of the model level and is either the
name of the variable describing the grouping at that level or is {cmd:_all}, a
special designation for a group comprising all the estimation data.
The {cmd:_all} designation is not supported with {cmd:menl}.

{phang}
{opt correlation} displays the covariance matrix as a correlation matrix.

{phang}
{it:matlist_options} are style and formatting options that control how the
matrix (or matrices) is displayed; see {helpb matlist:[P] matlist} for
a list of options that are available.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse pig}{p_end}
{phang2}{cmd:. mixed weight week || id: week, covariance(unstructured)}{p_end}

{pstd}Random-effects correlation matrix for level ID{p_end}
{phang2}{cmd:. estat recovariance, correlation}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat recovariance} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(relevels)}}number of levels{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(Cov}{it:#}{cmd:)}}level-{it:#} random-effects covariance matrix{p_end}
{synopt:{cmd:r(Corr}{it:#}{cmd:)}}level-{it:#} random-effects correlation matrix
	(if option {cmd:correlation} was specified){p_end}
{p2colreset}{...}

{pstd}
For a G-level nested model, {it:#} can be any integer between 2 and G.
{p_end}
