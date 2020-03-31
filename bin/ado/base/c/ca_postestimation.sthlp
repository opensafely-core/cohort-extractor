{smcl}
{* *! version 1.4.4  19oct2017}{...}
{viewerdialog predict "dialog ca_p"}{...}
{viewerdialog estat "dialog ca_estat"}{...}
{viewerdialog cabiplot "dialog cabiplot"}{...}
{viewerdialog caprojection "dialog caprojection"}{...}
{viewerdialog screeplot "dialog screeplot"}{...}
{vieweralsosee "[MV] ca postestimation" "mansection MV capostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] ca" "help ca"}{...}
{vieweralsosee "[MV] ca postestimation plots" "help ca postestimation plots"}{...}
{vieweralsosee "[MV] screeplot" "help screeplot"}{...}
{viewerjumpto "Postestimation commands" "ca postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "ca_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "ca postestimation##syntax_predict"}{...}
{viewerjumpto "estat" "ca postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "ca postestimation##examples"}{...}
{viewerjumpto "Stored results" "ca postestimation##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[MV] ca postestimation} {hline 2}}Postestimation tools for
{cmd:ca} and {cmd:camat}
{p_end}
{p2col:}({mansection MV capostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after {cmd:ca}
and {cmd:camat}:

{synoptset 21 tabbed}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb ca postestimation plots##cabiplot:cabiplot}}biplot of row and column
	points{p_end}
{synopt:{helpb ca postestimation plots##caprojection:caprojection}}CA dimension
	projection plot{p_end}
{synopt:{helpb ca postestimation##estat:estat coordinates}}display row and
	column coordinates{p_end}
{synopt:{helpb ca postestimation##estat:estat distances}}display chi-squared
	distances between row and column profiles{p_end}
{synopt:{helpb ca postestimation##estat:estat inertia}}display inertia
	contributions of the individual cells{p_end}
{synopt:{helpb ca postestimation##estat:estat loadings}}display correlations 
        of profiles and axes{p_end}
{synopt:{helpb ca postestimation##estat:estat profiles}}display row and column
	profiles{p_end}
{p2coldent:* {helpb ca postestimation##estat:estat summarize}}estimation sample
	summary{p_end}
{synopt:{helpb ca postestimation##estat:estat table}}display fitted
	correspondence table{p_end}
{synopt:{helpb screeplot}}plot singular values{p_end}
{synoptline}
{p 4 6 2}
* {cmd:estat summarize} is not available after {cmd:camat}.

{pstd}
The following standard postestimation commands are also available:

{p2coldent:Command}Description{p_end}
{synoptline}
{p2coldent:* {helpb estimates}}cataloging estimation results{p_end}
{p2coldent:+ {helpb ca postestimation##predict:predict}}fitted values, row
	coordinates, or column coordinates{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* All {cmd:estimates} subcommands except {opt table} and {opt stats} are
available.
{p_end}
{p 4 6 2}
+ {cmd:predict} is not available after {cmd:camat}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV capostestimationRemarksandexamples:Remarks and examples}

        {mansection MV capostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic}]

{synoptset 15 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt f:it}}fitted values; the default{p_end}
{synopt:{opt row:score(#)}}row score for dimension {it:#}{p_end}
{synopt:{opt col:score(#)}}column score for dimension {it:#}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:predict} is not available after {cmd:camat}.


INCLUDE help menu_predict


{marker desc_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
fitted values and row or column scores.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}{opt fit}
specifies that fitted values for the correspondence analysis model be 
computed.  {opt fit} displays the fitted values p_{ij} according to the
correspondence analysis model.  {opt fit} is the default.

{phang}{opt rowscore(#)}
generates the row score for dimension {it:#}, that is, the appropriate elements
from the normalized row coordinates.

{phang}{opt colscore(#)}
generates the column score for dimension {it:#}, that is, the appropriate
elements from the normalized column coordinates.


{marker syntax_estat}{...}
{marker estat}{...}
{title:Syntax for estat}

{pstd}
Display row and column coordinates

{p 8 14 2}
{cmd:estat} {opt co:ordinates} [{cmd:,} {opt norow} {opt nocol:umn}
	{opth for:mat(%fmt)}]


{pstd}
Display chi-squared distances between row and column profiles

{p 8 14 2}
{cmd:estat} {opt di:stances} [{cmd:,} {opt norow} {opt nocol:umn}
	{opt ap:prox} {opth for:mat(%fmt)}]


{pstd}
Display inertia contributions of cells

{p 8 14 2}
{cmd:estat} {opt in:ertia} [{cmd:,} {opt to:tal} {opt nosc:ale}
	{opth for:mat(%fmt)}]


{pstd}
Display correlations of profiles and axes

{p 8 14 2}
{cmd:estat} {opt lo:adings} [{cmd:,} {opt norow} {opt nocol:umn}
	{opth for:mat(%fmt)}]


{pstd}
Display row and column profiles

{p 8 14 2}
{cmd:estat} {opt pr:ofiles} [{cmd:,} {opt norow} {opt nocol:umn}
	{opth for:mat(%fmt)}]


{pstd}
Display summary information

{p 8 14 2}
{cmd:estat} {opt su:mmarize} [{cmd:,} {opt lab:els} {opt nohea:der}
	{opt nowei:ghts}]


{pstd}
Display fitted correspondence table

{p 8 14 2}
{cmd:estat} {opt ta:ble} [{cmd:,}
	{opt fit} {opt obs} {opt in:dependence} {opt nosc:ale}
	{opth for:mat(%fmt)}]


{synoptset 16}{...}
{synopthdr}
{synoptline}
{synopt:{opt norow}}suppress display of row results{p_end}
{synopt:{opt nocol:umn}}suppress display of column results{p_end}
{synopt:{opth for:mat(%fmt)}}display format; default is
	{cmd:format(%9.4f)}{p_end}
{synopt:{opt ap:prox}}display distances between fitted (approximated)
	profiles{p_end}
{synopt:{opt to:tal}}add row and column margins{p_end}
{synopt:{opt nosc:ale}}display chi-squared
	contributions; default is inertias = chi2/N 
	(with {cmd:estat inertia}) {p_end}
{synopt:{opt lab:els}}display variable labels{p_end}
{synopt:{opt nohea:der}}suppress the header{p_end}
{synopt:{opt nowei:ghts}}ignore weights{p_end}
{synopt:{opt fit}}display fitted values from correspondence analysis model{p_end}
{synopt:{opt obs}}display correspondence table ("observed table"){p_end}
{synopt:{opt in:dependence}}display expected values under independence{p_end}
{synopt:{opt nosc:ale}}suppress scaling of entries
	to 1 (with {cmd:estat table}) {p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_estat


{marker desc_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat coordinates}
displays the row and column coordinates.

{pstd}
{cmd:estat distances}
displays the chi-squared distances between the row profiles and between the
column profiles.  Also, the chi-squared distances between the row and
column profiles to the respective centers (marginal distributions) are
displayed.  Optionally, the fitted profiles rather than the observed profiles
are used.

{pstd}
{cmd:estat inertia}
displays the inertia (chi2/N) contributions of the individual cells.

{pstd}
{cmd:estat loadings}
displays the correlations of the row and column profiles and the axes, 
comparable to the loadings of principal component analysis. 

{pstd}
{cmd:estat profiles}
displays the row and column profiles; the row (column) profile is the
conditional distribution of the row (column) given the column (row).  This is
equivalent to specifying the {cmd:row} and {cmd:column} options with the
{cmd:tabulate} command; see {manhelp tabulate_twoway R:tabulate twoway}.

{pstd}
{cmd:estat summarize}
displays summary information about the row and column variables over the
estimation sample.

{pstd}
{cmd:estat table}
displays the fitted correspondence table.  Optionally, the observed
"correspondence table" and the expected table under independence are
displayed.


{marker options_estat}{...}
{title:Options for estat}

{phang}{opt norow},
an option used with {cmd:estat coordinates}, {cmd:estat distances}, and
{cmd:estat profiles}, suppresses the display of row results.

{phang}{opt nocolumn},
an option used with {cmd:estat coordinates}, {cmd:estat distances}, and
{cmd:estat profiles}, suppresses the display of column results.

{phang}{opth format(%fmt)},
an option used with many of the subcommands of {cmd:estat}, specifies the
display format for the matrix, for example, {cmd:format(%8.3f)}.  The default
is {cmd:format(%9.4f)}.

{phang}{opt approx},
an option used with {cmd:estat distances}, computes distances between the
fitted profiles.  The default is to compute distances between the observed
profiles.

{phang}{opt total},
an option used with {cmd:estat inertia}, adds row and column margins to the
table of inertia or chi-squared (chi-squared/N) contributions.

{phang}{opt noscale},
as an option used with {cmd:estat inertia}, displays chi-squared contributions
rather than inertia (= chi-squared/N) contributions.  (See below for the
description of {opt noscale} with {cmd:estat table}.)

{phang}{opt labels},
an option used with {cmd:estat summarize}, displays variable labels.

{phang}{opt noheader},
an option used with {cmd:estat summarize}, suppresses the header.

{phang}{opt noweights},
an option used with {cmd:estat summarize}, ignores the weights, if any.  The
default when weights are present is to perform a weighted {cmd:summarize} on
all variables except the weight variable itself.  An unweighted
{cmd:summarize} is performed on the weight variable.

{phang}{opt fit},
an option used with {cmd:estat table},
displays the fitted values for the correspondence analysis model.
{cmd:fit} is implied if {cmd:obs} and {cmd:independence} are not specified.

{phang}{opt obs},
an option used with {cmd:estat table}, displays the observed table with
nonnegative entries (the "correspondence table").

{phang}{opt independence},
an option used with {cmd:estat table}, displays the expected values p(ij)
assuming independence of the rows and columns, p(ij) = r(i) c(j), where r(i)
is the mass of row i and c(j) is the mass of column j.

{phang}{opt noscale},
as an option used with {cmd:estat table}, normalizes the displayed tables to
the sum of the original table entries.  The default is to scale the tables to
overall sum 1.  (See above for the description of {opt noscale} with
{cmd:estat inertia}.)


{marker examples}{...}
{title:Examples}

    Setup
        {cmd:. webuse ca_smoking}

    Estimate CA
        {cmd:. ca rank smoking}

    Postestimation statistics
        {cmd:. estat distances}
        {cmd:. estat distances, fit}
        {cmd:. estat inertia}
        {cmd:. estat inertia, total noscale}
        {cmd:. estat profiles, nocolumn}
        {cmd:. estat table, fit obs}

    Predict variables
        {cmd:. predict fitted, fit}
        {cmd:. predict pers_score, rowscore(1)}
        {cmd:. predict smok_score, colscore(1)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat distances} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(Dcolumns)}}chi-squared distances between the columns and
	between the columns and the column center{p_end}
{synopt:{cmd:r(Drows)}}chi-squared distances between the rows and between the
rows and the row center{p_end}

{pstd}
{cmd:estat inertia} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(Q)}}matrix of (squared) inertia (or chi-squared)
	contributions{p_end}

{pstd}
{cmd:estat loadings} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(LC)}}column loadings{p_end}
{synopt:{cmd:r(LR)}}row loadings{p_end}

{pstd}
{cmd:estat profiles} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(Pcolumns)}}column profiles (columns normalized to 1){p_end}
{synopt:{cmd:r(Prows)}}row profiles (rows normalized to 1){p_end}

{pstd}
{cmd:estat table} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(Fit)}}fitted (reconstructed) values{p_end}
{synopt:{cmd:r(Fit0)}}fitted (reconstructed) values, assuming independence of
	row and column variables{p_end}
{synopt:{cmd:r(Obs)}}correspondence table{p_end}
{p2colreset}{...}
