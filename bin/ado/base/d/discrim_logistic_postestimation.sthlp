{smcl}
{* *! version 1.2.5  21may2018}{...}
{viewerdialog predict "dialog discrim_logistic_p"}{...}
{viewerdialog estat "dialog discrim_logistic_estat"}{...}
{vieweralsosee "[MV] discrim logistic postestimation" "mansection MV discrimlogisticpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim logistic" "help discrim logistic"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim estat" "help discrim_estat"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim" "help discrim"}{...}
{viewerjumpto "Postestimation commands" "discrim logistic postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "discrim_logistic_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "discrim logistic postestimation##syntax_predict"}{...}
{viewerjumpto "Examples" "discrim logistic postestimation##examples"}{...}
{p2colset 1 41 43 2}{...}
{p2col:{bf:[MV] discrim logistic postestimation} {hline 2}}Postestimation
	tools for discrim logistic
{p_end}
{p2col:}({mansection MV discrimlogisticpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:discrim} {cmd:logistic}:

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
{synopt:{helpb discrim logistic postestimation##predict:predict}}group
	classification and posterior probabilities{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* All {cmd:estimates} subcommands except {opt table} and {opt stats} are
available.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV discrimlogisticpostestimationRemarksandexamples:Remarks and examples}

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
{synoptline}

{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt g:roup(group)}}the group for which the statistic is to be
	calculated{p_end}

{syntab:Options}
{synopt:{opth pri:ors(discrim_logistic_postestimation##priors:priors)}}group prior
        probabilities; defaults to {cmd:e(grouppriors)}{p_end}
{synopt:{opth tie:s(discrim_logistic_postestimation##ties:ties)}}how ties in
        classification are to be handled; defaults to {cmd:e(ties)}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help discrim_optsp

{p 4 6 2}
You specify one new variable with {opt classification} and
specify either one or {cmd:e(N_groups)} new variables with {opt pr}.
{p_end}
{p 4 6 2}
{opt group()} is not allowed with {opt classification}.
{p_end}


INCLUDE help menu_predict


{marker desc_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
group classifications and probabilities.


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
{cmd:group()} is not allowed with {cmd:classification}.

{dlgtab:Options}

INCLUDE help discrim_priorsp


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rootstock}{p_end}

{pstd}Fit a logistic discriminant analysis model{p_end}
{phang2}{cmd:. discrim logistic y1 y2 y3 y4, group(rootstock)}{p_end}

{pstd}Display the resubstitution classification table with prior probabilities
of 0.2 for the first four rootstocks and 0.1 for the last two root
stocks{p_end}
{phang2}{cmd:. estat classtable, priors(.2,.2,.2,.2,.1,.1)}{p_end}

{pstd}Predict the group posterior probabilities{p_end}
{phang2}{cmd:. predict postpr*, pr}{p_end}

{pstd}List the true and classified group membership along with the posterior
probabilities for the misclassified observations{p_end}
{phang2}{cmd:. estat list, misclassified}

{pstd}For each group, display the error rates estimated from the posterior
probabilities{p_end}
{phang2}{cmd:. estat errorrate, pp}{p_end}
