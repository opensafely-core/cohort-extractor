{smcl}
{* *! version 1.2.5  31may2018}{...}
{viewerdialog predict "dialog mca_p"}{...}
{viewerdialog estat "dialog mca_estat"}{...}
{viewerdialog mcaplot "dialog mcaplot"}{...}
{viewerdialog mcaprojection "dialog mcaprojection"}{...}
{viewerdialog screeplot "dialog screeplot"}{...}
{vieweralsosee "[MV] mca postestimation" "mansection MV mcapostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mca" "help mca"}{...}
{vieweralsosee "[MV] mca postestimation plots" "help mca postestimation plots"}{...}
{vieweralsosee "[MV] screeplot" "help screeplot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] ca" "help ca"}{...}
{vieweralsosee "[MV] ca postestimation" "help ca_postestimation"}{...}
{viewerjumpto "Postestimation commands" "mca postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "mca_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "mca postestimation##syntax_predict"}{...}
{viewerjumpto "estat" "mca postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "mca postestimation##examples"}{...}
{viewerjumpto "Stored results" "mca postestimation##results"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[MV] mca postestimation} {hline 2}}Postestimation tools for mca
{p_end}
{p2col:}({mansection MV mcapostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after {cmd:mca}:

{synoptset 21}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb mca postestimation plots##mcaplot:mcaplot}}plot of category coordinates{p_end}
{synopt:{helpb mca postestimation plots##mcaprojection:mcaprojection}}MCA dimension projection plot{p_end}
{synopt:{helpb mca postestimation##syntax_estat:estat coordinates}}display of category coordinates{p_end}
{synopt:{helpb mca postestimation##syntax_estat:estat subinertia}}matrix of inertias of the active variables (after JCA only){p_end}
{synopt:{helpb mca postestimation##syntax_estat:estat summarize}}estimation sample summary{p_end}
{synopt:{helpb screeplot}}plot principal inertias (eigenvalues){p_end}
{synoptline}
{p 4 6 2}


{pstd}
The following standard postestimation commands are also available:

{synoptset 21 tabbed}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{p2coldent:* {helpb estimates}}cataloging estimation results{p_end}
{synopt:{helpb mca postestimation##predict:predict}}row and category coordinates{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* All {cmd:estimates} subcommands except {opt table} and {opt stats} are
available.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV mcapostestimationRemarksandexamples:Remarks and examples}

        {mansection MV mcapostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {it:{help newvar}} {ifin} [{cmd:,} {it:statistic} {opt norm:alize(norm)} {opt dim:ensions(#)}]

{p 8 16 2}
{cmd:predict} {dtype} {{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help varlist:newvarlist}}} {ifin} [{cmd:,}
{it:statistic} {opt norm:alize(norm)} {opth dim:ensions(numlist)}]

{synoptset 22 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt row:scores}}row scores (coordinates), the default{p_end}
{synopt:{opth sc:ore(varname)}}scores (coordinates) for MCA variable
{it:varname}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 22}{...}
{synopthdr:norm}
{synoptline}
{synopt:{opt st:andard}}use standard normalization{p_end}
{synopt:{opt p:rincipal}}use principal normalization{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_predict


{marker desc_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
row scores and scores (coordinates) for the MCA variable.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}{opt rowscores}
specifies that row scores (row coordinates) be computed.  The row scores
returned are based on the indicator matrix approach to multiple
correspondence analysis, even if another method was specified in the
original {cmd:mca} estimation.  The sample for which row scores are computed
may exceed the estimation sample; for example, it may include supplementary
rows (variables).  {cmd:score()} and {cmd:rowscores} are mutually exclusive.
{cmd:rowscores} is the default.

{phang}{opth score(varname)}
specifies the name of a variable from the preceding MCA for which scores
should be computed.  The variable may be a regular categorical variable,
a crossed variable, or a supplementary variable.
{cmd:score()} and {cmd:rowscores} are mutually exclusive.

{dlgtab:Options}

{phang}{opt normalize(norm)}
specifies the normalization of the scores (coordinates).
{cmd:normalize(}{cmdab:s:tandard}{cmd:)}
returns coordinates in standard normalization.
{cmd:normalize(}{cmdab:p:rincipal}{cmd:)}
returns principal scores.  The default is
the normalization method specified with {cmd:mca} during estimation,
or {cmd:normalize(standard)} if no method was specified.

{phang}{opt dimensions(#)} or {opth dimensions(numlist)}
specifies the dimensions for which scores (coordinates) are computed.
The number of dimensions specified should equal the number of variables
in {it:{help newvarlist}}.  If {cmd:dimensions()} is not specified, scores for
dimensions 1,...,{it:k} are returned, where {it:k} is the number of variables
in {it:newvarlist}.  The number of variables in {it:newvarlist} should not
exceed the number of dimensions extracted during estimation.


{marker syntax_estat}{...}
{title:Syntax for estat}

{pstd}Display of category coordinates

{p 8 14 2}
{cmd:estat} {opt co:ordinates} [{varlist}] [{cmd:,}
{it:{help mca_postestimation##coordinates_options:coordinates_options}}]


{pstd}Matrix of inertias of the active variables (after JCA only)

{p 8 14 2}
{cmd:estat} {opt sub:inertia}


{pstd}Estimation sample summary

{p 8 14 2}
{cmd:estat} {opt su:mmarize} [{cmd:,}
{it:{help mca_postestimation##summarize_options:summarize_options}}]


{pstd}
Note: Variables in {it:varlist} must be from the preceding
{cmd:mca} and may refer to either a regular categorical variable or
a crossed variable.  The variables in {it:varlist} may also be chosen
from the supplementary variables.


{marker coordinates_options}{...}
{synoptset 22}{...}
{synopthdr:coordinates_options}
{synoptline}
{synopt:{cmdab:norm:alize(}{cmdab:s:tandard)}}standard coordinates{p_end}
{synopt:{cmdab:norm:alize(}{cmdab:p:rincipal)}}principal coordinates{p_end}
{synopt:{opt st:ats}}include mass, distance, and inertia{p_end}
{synopt:{opth for:mat(%fmt)}}display format; default is {cmd:format(%9.4f)}{p_end}
{synoptline}
{p2colreset}{...}


{marker summarize_options}{...}
{synoptset 22 tabbed}{...}
{synopthdr:summarize_options}
{synoptline}
{syntab:Main}
{synopt:{opt c:rossed}}summarize crossed and uncrossed variables as used{p_end}
{synopt:{opt lab:els}}display variable labels{p_end}
{synopt:{opt nohea:der}}suppress the header{p_end}
{synopt:{opt nowei:ghts}}ignore weights{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_estat


{marker desc_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat coordinates}
displays the category coordinates, optionally with column statistics.

{pstd}
{cmd:estat subinertia}
displays the matrix of inertias of the active variables (after JCA only).

{pstd}
{cmd:estat summarize}
displays summary information of MCA variables over the estimation sample.


{marker options_estat_coordinates}{...}
{title:Options for estat coordinates}

{phang}{opt normalize(norm)}
specifies the normalization of the scores (coordinates).
{cmd:normalize(standard)} returns coordinates in standard
normalization.  {cmd:normalize(principal)} returns principal scores.
The default is the normalization method specified with {cmd:mca} during
estimation, or {cmd:normalize(standard)} if no method was specified.

{phang}{opt stats}
includes the column mass, the distance of the columns to the centroid, and the
column inertias in the table.

{phang}{opth format(%fmt)}
specifies the display format for the matrix, for example, {cmd:format(%8.3f)}.
The default is {cmd:format(%9.4f)}.


{marker options_estat_summarize}{...}
{title:Options for estat summarize}

{dlgtab:Main}

{phang}{opt crossed}
specifies summarizing the crossed variables if crossed variables are used in
the MCA, rather than the crossing variables from which they are formed.  The
default is to summarize the crossing variables and single categorical variables
used in the MCA.

{phang}{opt labels}
displays variable labels.

{phang}{opt noheader}
suppresses the header.

{phang}{opt noweights}
ignores the weights, if any.  The default when weights are present is to
perform a weighted summarize on all variables except the weight variable
itself.  An unweighted summarize is performed on the weight variable.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse issp93}{p_end}
{phang2}{cmd:. mca A B C D, dimensions(2) suppl(age edu) method(joint)}{p_end}

{pstd}Predict column coordinates and row coordinates{p_end}
{phang2}{cmd:. predict a1 a2, score(A)}{p_end}
{phang2}{cmd:. predict r1 r2, rowscores norm(principal)}{p_end}

{pstd}View the coordinates and the subinertia{p_end}
{phang2}{cmd:. estat coord, stats}{p_end}
{phang2}{cmd:. estat subinertia}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat summarize} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(stats)}}k x 4 matrix of means, standard deviations, minimums, and maximums{p_end}

{pstd}
{cmd:estat coordinates} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(norm)}}normalization method of the coordinates{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(Coord)}}column coordinates{p_end}
{synopt:{cmd:r(Stats)}}column statistics: mass, distance, and inertia
           (option {cmd:stats} only){p_end}

{pstd}
{cmd:estat subinertia} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(inertia_sub)}}variable-by-variable inertias{p_end}
