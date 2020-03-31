{smcl}
{* *! version 1.2.5  21may2018}{...}
{viewerdialog predict "dialog discrim_knn_p"}{...}
{viewerdialog estat "dialog discrim_knn_estat"}{...}
{vieweralsosee "[MV] discrim knn postestimation" "mansection MV discrimknnpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim knn" "help discrim_knn"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim estat" "help discrim_estat"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim" "help discrim"}{...}
{viewerjumpto "Postestimation commands" "discrim knn postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "discrim_knn_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "discrim knn postestimation##syntax_predict"}{...}
{viewerjumpto "Examples" "discrim knn postestimation##examples"}{...}
{p2colset 1 36 38 2}{...}
{p2col:{bf:[MV] discrim knn postestimation} {hline 2}}Postestimation tools 
        for discrim knn
{p_end}
{p2col:}({mansection MV discrimknnpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:discrim} {cmd:knn}:

{synoptset 19}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb discrim estat##estatclasstable:estat classtable}}classification
	table{p_end}
{synopt:{helpb discrim estat##estaterrorrate:estat errorrate}}classification
	error-rate estimation{p_end}
{synopt:{helpb discrim estat##estatgrsummarize:estat grsummarize}}group
	summaries{p_end}
{synopt:{helpb discrim estat##estatlist:estat list}}classification
	listing{p_end}
{synopt:{helpb discrim estat##estatsummarize:estat summarize}}estimation
	sample summary{p_end}
{synoptline}

{pstd}
The following standard postestimation commands are also available:

{synoptset 19 tabbed}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{p2coldent:* {helpb estimates}}cataloging estimation results{p_end}
{synopt:{helpb discrim knn postestimation##predict:predict}}group
	classification and posterior probabilities{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* All {cmd:estimates} subcommands except {opt table} and {opt stats} are
available.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV discrimknnpostestimationRemarksandexamples:Remarks and examples}

        {mansection MV discrimknnpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar}
	{ifin} [{cmd:,} {it:statistic} {it:options}]

{p 8 16 2}
{cmd:predict} {dtype} {c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{c )-}
	{ifin} [{cmd:,} {it:statistic} {it:options}]

{synoptset 18 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt c:lassification}}group membership classification; the default
	 when one variable is specified and {cmd:group()} is not specified
	 {p_end}
{synopt:{opt pr}}probability of group membership; the default when
	{cmd:group()} is specified or when multiple variables are
	specified{p_end}
{p2coldent:* {opt looc:lass}}leave-one-out group membership
	classification; may be used only when one new variable is specified{p_end}
{p2coldent:* {opt loop:r}}leave-one-out probability of group membership{p_end}
{synoptline}

{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt g:roup(group)}}the group for which the statistic is to be
	calculated{p_end}

{syntab:Options}
{synopt:{opth pri:ors(discrim_knn_postestimation##priors:priors)}}group prior
        probabilities; defaults to {cmd:e(grouppriors)}{p_end}
{synopt:{opth tie:s(discrim_knn_postestimation##ties:ties)}}how ties in
        classification are to be handled; defaults to {cmd:e(ties)}{p_end}

{synopt:{opt noup:date}}do not update the within-group covariance matrix
	with leave-one-out predictions{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 20}{...}
{marker priors}{...}
{synopthdr:priors}
{synoptline}
{synopt:{opt eq:ual}}equal prior probabilities{p_end}
{synopt:{opt prop:ortional}}group-size-proportional prior probabilities{p_end}
{synopt:{it:matname}}row or column vector containing the group prior
	probabilities{p_end}
{synopt:{it:matrix_exp}}matrix expression providing a row or column vector of
	the group prior probabilities{p_end}
{synoptline}

{marker ties}{...}
{synopthdr:ties}
{synoptline}
{synopt:{opt m:issing}}ties in group classification produce missing values{p_end}
{synopt:{opt r:andom}}ties in group classification are broken randomly{p_end}
{synopt:{opt f:irst}}ties in group classification are set to the first tied
        group{p_end}
{synopt:{opt n:earest}}ties in group classification are assigned based on
	the closest observation, or missing if this still results in a
	tie{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
You specify one new variable with {opt classification} or {opt looclass} and
specify either one or {cmd:e(N_groups)} new variables with {opt pr} or
{opt loopr}.
{p_end}
{p 4 6 2}
Unstarred statistics are available both in and out of sample;
type {cmd:predict ... if e(sample) ...} if wanted only for the estimation
sample.  Starred statistics are calculated only for the estimation sample,
even when {cmd:if e(sample)} is not specified.
{p_end}
{p 4 6 2}
{opt group()} is not allowed with {opt classification} or {opt looclass}.
{p_end}
{p 4 6 2}
{opt noupdate} is an advanced option and does not appear in the dialog box.
{p_end}


INCLUDE help menu_predict


{marker desc_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
group classifications, probabilities, leave-one-out group classifications,
and leave-one-out probabilities.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt classification},
the default, calculates the group classification.  Only one new variable may
be specified.

{phang}
{opt pr}
calculates group membership posterior probabilities.  If you specify the
{opt group()} option, specify one new variable.  Otherwise, you must specify
{cmd:e(N_groups)} new variables.

{phang}
{opt looclass}
calculates the leave-one-out group classifications.  Only one new variable may
be specified.  Leave-one-out calculations are restricted to {cmd:e(sample)}
observations.

{phang}
{opt loopr}
calculates the leave-one-out group membership posterior probabilities.  If you
specify the {opt group()} option, specify one new variable.  Otherwise, you
must specify {cmd:e(N_groups)} new variables.  Leave-one-out calculations are
restricted to {cmd:e(sample)} observations.

{phang}
{opt group(group)}
specifies the group for which the statistic is to be calculated
and can be specified using 
 
{pin2}
{cmd:#1}, {cmd:#2}, ..., where {cmd:#1} means the first category of
the {cmd:e(groupvar)} variable, {cmd:#2} the second category, etc.; 

{pin2}
the values of the {cmd:e(groupvar)} variable; or 

{pin2}
the value labels of the {cmd:e(groupvar)} variable if they exist.

{pmore}
{cmd:group()} is not allowed with {cmd:classification} or {cmd:looclass}.

{dlgtab:Options}

INCLUDE help discrim_priorsp

{phang2}
{cmd:ties(}{opt n:earest}{cmd:)} specifies that ties in group classification
   are assigned based on the closest observation, or missing if this still
   results in a tie.

{pstd}
The following option is available with {cmd:predict} after {cmd:discrim knn}
but is not shown in the dialog box:

{phang}
{opt noupdate}
causes the within-group covariance matrix not to be updated with leave-one-out
predictions.  {opt noupdate} is an advanced, rarely used option that is 
valid only if a Mahalanobis transformation is specified.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rootstock}{p_end}

{pstd}Fit {it:k}th-nearest-neighbor (KNN) discriminant analysis model using
three nearest neighbors and equal prior probabilities for the six root
stock groups and display classification matrix breaking ties randomly{p_end}
{phang2}{cmd:. discrim knn y1 y2 y3 y4, group(rootstock) k(3)}
	{cmd:ties(random)}{p_end}

{pstd}List true group, predicted group, and posterior probabilities for
	misclassified observations{p_end}
{phang2}{cmd:. estat list, misclassified}{p_end}

{pstd}Predict leave-one-out posterior probabilities{p_end}
{phang2}{cmd:. predict pp1 pp2 pp3 pp4 pp5 pp6, loopr}{p_end}

{pstd}Display the leave-one-out classification table{p_end}
{phang2}{cmd:. estat classtable, loo}{p_end}
