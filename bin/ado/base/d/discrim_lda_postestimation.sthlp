{smcl}
{* *! version 1.2.7  21may2018}{...}
{viewerdialog predict "dialog discrim_lda_p"}{...}
{viewerdialog estat "dialog discrim_lda_estat"}{...}
{viewerdialog screeplot "dialog screeplot"}{...}
{viewerdialog loadingplot "dialog loadingplot"}{...}
{viewerdialog scoreplot "dialog scoreplot"}{...}
{vieweralsosee "[MV] discrim lda postestimation" "mansection MV discrimldapostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim lda" "help discrim lda"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim estat" "help discrim estat"}{...}
{vieweralsosee "[MV] scoreplot" "help scoreplot"}{...}
{vieweralsosee "[MV] screeplot" "help screeplot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] candisc" "help candisc"}{...}
{vieweralsosee "[MV] canon" "help canon"}{...}
{vieweralsosee "[MV] discrim" "help discrim"}{...}
{vieweralsosee "[MV] manova" "help manova"}{...}
{viewerjumpto "Postestimation commands" "discrim lda postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "discrim_lda_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "discrim lda postestimation##syntax_predict"}{...}
{viewerjumpto "estat" "discrim lda postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "discrim lda postestimation##examples"}{...}
{viewerjumpto "Stored results" "discrim lda postestimation##results"}{...}
{p2colset 1 36 38 2}{...}
{p2col:{bf:[MV] discrim lda postestimation} {hline 2}}Postestimation tools
        for discrim lda
{p_end}
{p2col:}({mansection MV discrimldapostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:discrim lda}:

{synoptset 23}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb discrim lda postestimation##syntax_estat:estat anova}}ANOVA
	summaries table{p_end}
{synopt:{helpb discrim lda postestimation##syntax_estat:estat canontest}}tests
	of the canonical discriminant functions{p_end}
{synopt:{helpb discrim lda postestimation##syntax_estat:estat classfunctions}}classification
	functions{p_end}
{synopt:{helpb discrim estat##syntax_estat:estat classtable}}classification
	table{p_end}
{synopt:{helpb discrim lda postestimation##syntax_estat:estat correlations}}correlation
	matrices and p-values{p_end}
{synopt:{helpb discrim lda postestimation##syntax_estat:estat covariance}}covariance
	matrices{p_end}
{synopt:{helpb discrim estat##syntax_estat:estat errorrate}}classification
	error-rate estimation{p_end}
{synopt:{helpb discrim lda postestimation##syntax_estat:estat grdistances}}Mahalanobis
	and generalized squared distances between the group means{p_end}
{synopt:{helpb discrim lda postestimation##syntax_estat:estat grmeans}}group
	means and variously standardized or transformed means{p_end}
{synopt:{helpb discrim estat##syntax_estat:estat grsummarize}}group
	summaries{p_end}
{synopt:{helpb discrim estat##syntax_estat:estat list}}classification
	listing{p_end}
{synopt:{helpb discrim lda postestimation##syntax_estat:estat loadings}}canonical
	discriminant-function coefficients (loadings){p_end}
{synopt:{helpb discrim lda postestimation##syntax_estat:estat manova}}MANOVA
	table{p_end}
{synopt:{helpb discrim lda postestimation##syntax_estat:estat structure}}canonical
	structure matrix{p_end}
{synopt:{helpb discrim estat##syntax_estat:estat summarize}}estimation
        sample summary{p_end}
{synopt:{helpb scoreplot:loadingplot}}plot standardized discriminant-function
	loadings{p_end}
{synopt:{helpb scoreplot}}plot discriminant-function scores{p_end}
{synopt:{helpb screeplot}}plot eigenvalues{p_end}
{synoptline}

{pstd}
The following standard postestimation commands are also available:

{synoptset 23 tabbed}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{p2coldent:* {helpb estimates}}cataloging estimation results{p_end}
{synopt:{helpb discrim lda postestimation##predict:predict}}group
	classification and posterior probabilities{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* All {cmd:estimates} subcommands except {opt table} and {opt stats} are
available.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV discrimldapostestimationRemarksandexamples:Remarks and examples}

        {mansection MV discrimldapostestimationMethodsandformulas:Methods and formulas}

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
{synopt:{opt mah:alanobis}}Mahalanobis squared distance between observations
	and groups{p_end}
{synopt:{opt dsc:ore}}discriminant function score{p_end}
{synopt:{opt clsc:ore}}group classification function score{p_end}
{p2coldent:* {opt looc:lass}}leave-one-out group membership classification;
may be used only when one new variable is specified{p_end}
{p2coldent:* {opt loop:r}}leave-one-out probability of group membership{p_end}
{p2coldent:* {opt loom:ahal}}leave-one-out Mahalanobis squared distance between
	observations and groups{p_end}
{synoptline}

{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt g:roup(group)}}the group for which the statistic is to be
	calculated{p_end}

{syntab:Options}
{synopt:{opth pri:ors(discrim_lda_postestimation##priors:priors)}}group prior
        probabilities; defaults to {cmd:e(grouppriors)}{p_end}
{synopt:{opth tie:s(discrim_lda_postestimation##ties:ties)}}how ties in
        classification are to be handled; defaults to {cmd:e(ties)}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help discrim_optsp

{p 4 6 2}
You specify one new variable with {opt classification} or {opt looclass};
either one or {cmd:e(N_groups)} new variables with {opt pr}, {opt loopr},
{opt mahalanobis}, {opt loomahal}, or {opt clscore}; and one to {cmd:e(f)}
new variables with {opt dscore}.
{p_end}
{p 4 6 2}
Unstarred statistics are available both in and out of sample;
type {cmd:predict ... if e(sample) ...} if wanted only for the estimation
sample.  Starred statistics are calculated only for the estimation sample,
even when {cmd:if e(sample)} is not specified.
{p_end}
{p 4 6 2}
{opt group()} is not allowed with {opt classification}, {opt dscore},
or {opt looclass}.
{p_end}


INCLUDE help menu_predict


{marker desc_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
group classifications, probabilities, Mahalanobis squared distances,
discriminant function scores, leave-one-out probabilities,
leave-one-out group classifications, and leave-one-out Mahalanobis
squared distances.


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
{opt mahalanobis}
calculates the squared Mahalanobis distance between the observations and group
means.  If you specify the {opt group()} option, specify one new variable.
Otherwise, you must specify {cmd:e(N_groups)} new variables.

{phang}
{opt dscore}
produces the discriminant function score.  Specify as many variables as
leading discriminant functions that you wish to score.  No more than
{cmd:e(f)} variables may be specified.

{phang}
{opt clscore}
produces the group classification function score. If you specify the
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
{opt loomahal}
calculates the leave-one-out squared Mahalanobis distance between the
observations and group means.  If you specify the {opt group()} option,
specify one new variable.  Otherwise, you must specify {cmd:e(N_groups)} new
variables.  Leave-one-out calculations are restricted to {cmd:e(sample)}
observations.

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
{cmd:group()} is not allowed with {cmd:classification}, {cmd:dscore}, or
{cmd:looclass}.

{marker priorsdesc}{...}
{dlgtab:Options}

INCLUDE help discrim_priorsp


{marker syntax_estat}{...}
{title:Syntax for estat}

{pstd}ANOVA summaries table

	{cmd:estat} {opt an:ova}


{pstd}Tests of the canonical discriminant functions

	{cmd:estat} {opt can:ontest}


{pstd}Classification functions

{p 8 25 2}
	{cmd:estat} {opt classf:unctions} [{cmd:,}
     {it:{help discrim_lda_postestimation##classfunctions_options:classfunctions_options}}]


{pstd}Correlation matrices and p-values

{p 8 25 2}
	{cmd:estat} {opt cor:relations} [{cmd:,}
     {it:{help discrim_lda_postestimation##correlations_options:correlations_options}}]


{pstd}Covariance matrices

{p 8 25 2}
	{cmd:estat} {opt cov:ariance} [{cmd:,}
      {it:{help discrim_lda_postestimation##covariance_options:covariance_options}}]


{pstd}Mahalanobis and generalized squared distances between the group means

{p 8 25 2}
	{cmd:estat} {opt grd:istances} [{cmd:,}
      {it:{help discrim_lda_postestimation##grdistances_options:grdistances_options}}]


{pstd}Group means and variously standardized or transformed means

{p 8 25 2}
	{cmd:estat} {opt grm:eans} [{cmd:,}
      {it:{help discrim_lda_postestimation##grmeans_options:grmeans_options}}]


{pstd}Canonical discriminant-function coefficients (loadings)

{p 8 25 2}
	{cmd:estat} {opt loa:dings} [{cmd:,}
     {it:{help discrim_lda_postestimation##loadings_options:loadings_options}}]


{pstd}MANOVA table

	{cmd:estat} {opt man:ova}


{pstd}Canonical structure matrix

{p 8 25 2}
	{cmd:estat} {opt str:ucture} [{cmd:,} {opth for:mat(%fmt)}]



{marker classfunctions_options}{...}
{synoptset 23 tabbed}{...}
{synopthdr:classfunctions_options}
{synoptline}
{syntab:Main}
{synopt:{opt adjusteq:ual}}adjust the constant even when priors are equal{p_end}
{synopt:{opth for:mat(%fmt)}}numeric display format; default is
	{cmd:%9.0g}{p_end}

{syntab:Options}
{synopt:{opth pri:ors(discrim_lda_postestimation##priors:priors)}}group prior
	probabilities; defaults to {cmd:e(grouppriors)}{p_end}
{synopt:{opt nopri:ors}}suppress display of prior probabilities{p_end}
{synoptline}


{marker correlations_options}{...}
{synoptset 23 tabbed}{...}
{synopthdr:correlations_options}
{synoptline}
{syntab:Main}
{synopt:{opt w:ithin}}display pooled within-group correlation matrix;
          the default{p_end}
{synopt:{opt b:etween}}display between-groups correlation matrix{p_end}
{synopt:{opt t:otal}}display total-sample correlation matrix{p_end}
{synopt:{opt g:roups}}display the correlation matrix for each group{p_end}
{synopt:{opt all}}display all the above{p_end}
{synopt:{opt p}}display two-sided p-values for requested correlations{p_end}
{synopt:{opth for:mat(%fmt)}}numeric display format; default is
	{cmd:%9.0g}{p_end}
{synopt:{opt noha:lf}}display full matrix even if symmetric{p_end}
{synoptline}


{marker covariance_options}{...}
{synoptset 23 tabbed}{...}
{synopthdr:covariance_options}
{synoptline}
{syntab:Main}
{synopt:{opt w:ithin}}display pooled within-group covariance matrix; the
default{p_end}
{synopt:{opt b:etween}}display between-groups covariance matrix{p_end}
{synopt:{opt t:otal}}display total-sample covariance matrix{p_end}
{synopt:{opt g:roups}}display the covariance matrix for each group{p_end}
{synopt:{opt all}}display all the above{p_end}
{synopt:{opth for:mat(%fmt)}}numeric display format; default is
	{cmd:%9.0g}{p_end}
{synopt:{opt noha:lf}}display full matrix even if symmetric{p_end}
{synoptline}


{marker grdistances_options}{...}
{synoptset 23 tabbed}{...}
{synopthdr:grdistances_options}
{synoptline}
{syntab:Main}
{synopt:{opt mah:alanobis}[{cmd:(f p)}]}display Mahalanobis squared distances
	between group means; the default{p_end}
{synopt:{opt gen:eralized}}display generalized Mahalanobis squared
	distances between group means{p_end}
{synopt:{opt all}}equivalent to {cmd:mahalanobis(f p) generalized}{p_end}
{synopt:{opth for:mat(%fmt)}}numeric display format; default is
	{cmd:%9.0g}{p_end}

{syntab:Options}
{synopt:{opth pri:ors(discrim_lda_postestimation##priors:priors)}}group prior
	probabilities; defaults to {cmd:e(grouppriors)}{p_end}
{synoptline}


{marker grmeans_options}{...}
{synoptset 23 tabbed}{...}
{synopthdr:grmeans_options}
{synoptline}
{syntab:Main}
{synopt:{opt r:aw}}display untransformed and unstandardized group means{p_end}
{synopt:{opt t:otalstd}}display total-sample standardized group means{p_end}
{synopt:{opt w:ithinstd}}display pooled within-group standardized group
	means{p_end}
{synopt:{opt c:anonical}}display canonical functions evaluated at group
	means{p_end}
{synopt:{opt all}}display all the mean tables{p_end}
{synoptline}


{marker loadings_options}{...}
{synoptset 23 tabbed}{...}
{synopthdr:loadings_options}
{synoptline}
{syntab:Main}
{synopt:{opt st:andardized}}display pooled within-group standardized canonical
	discriminant function coefficients; the default{p_end}
{synopt:{opt tot:alstandardized}}display the total-sample standardized
	canonical discriminant function coefficients{p_end}
{synopt:{opt unst:andardized}}display unstandardized canonical discriminant
	function coefficients{p_end}
{synopt:{opt all}}display all the above{p_end}
{synopt:{opth for:mat(%fmt)}}numeric display format; default is
	{cmd:%9.0g}{p_end}
{synoptline}


INCLUDE help menu_estat


{marker desc_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat anova} presents a table summarizing the one-way ANOVAs for each
variable in the discriminant analysis.

{pstd}
{cmd:estat canontest} presents tests of the canonical discriminant functions.
Presented are the canonical correlations, eigenvalues, proportion and
cumulative proportion of variance, and likelihood-ratio tests for the number
of nonzero eigenvalues.

{pstd}
{cmd:estat classfunctions} displays the classification functions.

{pstd}
{cmd:estat correlations} displays the pooled within-group correlation
matrix, between-groups correlation matrix, total-sample correlation matrix,
and/or the individual group correlation matrices.  Two-tailed p-values for
the correlations may also be requested.

{pstd}
{cmd:estat covariance} displays the pooled within-group covariance matrix,
between-groups covariance matrix, total-sample covariance matrix, and/or the
individual group covariance matrices.

{pstd}
{cmd:estat grdistances} provides Mahalanobis squared distances between the
group means along with the associated F statistics and significance levels.
Also available are generalized squared distances.

{pstd}
{cmd:estat grmeans} provides group means, total-sample standardized group
means, pooled within-group standardized means, and canonical functions
evaluated at the group means.

{pstd}
{cmd:estat loadings} present the canonical discriminant-function coefficients
(loadings).  Unstandardized, pooled within-class standardized, and
total-sample standardized coefficients are available.

{pstd}
{cmd:estat manova} presents the MANOVA table associated with the discriminant
analysis.

{pstd}
{cmd:estat structure} presents the canonical structure matrix.


{marker options_estat_classfunctions}{...}
{title:Options for estat classfunctions}

{dlgtab:Main}

{phang}
{opt adjustequal} specifies that the constant term in the classification
function be adjusted for prior probabilities even though the priors are
equal.  By default, equal prior probabilities are not used in adjusting the
constant term.  {opt adjustequal} has no effect with unequal prior
probabilities.

{phang}
{opth format(%fmt)} specifies the matrix display format.  The default is
{cmd:format(%9.0g)}.

{dlgtab:Options}

{phang}
{opt priors(priors)} specifies the group prior probabilities.  The prior
probabilities affect the constant term in the classification function.  By
default, {it:priors} is determined from {cmd:e(grouppriors)}.
See {it:{help discrim_lda_postestimation##priorsdesc:Options for predict}} for
the {it:priors} specification.  By common convention, when there are equal
prior probabilities the adjustment of the constant term is not performed.  See
{opt adjustequal} to override this convention. 

{phang}
{opt nopriors} specifies that the prior probabilities not be displayed.
By default, the prior probabilities used in determining the constant in the
classification functions are displayed as the last row in the classification
functions table.


{marker options_estat_correlations}{...}
{title:Options for estat correlations}

{dlgtab:Main}

{phang}
{opt within} specifies that the pooled within-group correlation matrix
be displayed.  This is the default. 

{phang}
{opt between} specifies that the between-groups correlation matrix be
displayed.

{phang}
{opt total} specifies that the total-sample correlation matrix be
displayed.

{phang}
{opt groups} specifies that the correlation matrix for each group be
displayed.

{phang}
{opt all} is the same as specifying {opt within}, {opt between}, {opt total},
and {opt groups}.

{phang}
{opt p} specifies that two-sided p-values be computed and displayed for the
requested correlations.

{phang}
{opth format(%fmt)} specifies the matrix display format.  The default is
{cmd:format(%8.5f)}.

{phang}
{opt nohalf} specifies that, even though the matrix is symmetric, the full
matrix be printed.  The default is to print only the lower triangle.


{marker options_estat_covariance}{...}
{title:Options for estat covariance}

{dlgtab:Main}

{phang}
{opt within} specifies that the pooled within-group covariance matrix
be displayed.  This is the default. 

{phang}
{opt between} specifies that the between-groups covariance matrix be
displayed.

{phang}
{opt total} specifies that the total-sample covariance matrix be
displayed.

{phang}
{opt groups} specifies that the covariance matrix for each group be
displayed.

{phang}
{opt all} is the same as specifying {opt within}, {opt between}, {opt total},
and {opt groups}.

{phang}
{opth format(%fmt)} specifies the matrix display format.  The default is
{cmd:format(%9.0g)}.

{phang}
{opt nohalf} specifies that, even though the matrix is symmetric, the full
matrix be printed.  The default is to print only the lower triangle.


{marker options_estat_grdistances}{...}
{title:Options for estat grdistances}

{dlgtab:Main}

{phang}
{opt mahalanobis}[{cmd:(f p)}] specifies that a table of Mahalanobis squared
distances between group means be presented.  {cmd:mahalanobis(f)} adds F tests
for each displayed distance and {cmd:mahalanobis(p)} adds the associated
p-values.  {cmd:mahalanobis(f p)} adds both.  The default is
{cmd:mahalanobis}.

{phang}
{opt generalized} specifies that a table of generalized Mahalanobis squared
distances between group means be presented.  {opt generalized} starts with
what is produced by the {opt mahalanobis} option and adds a term accounting
for prior probabilities.  Prior probabilities are provided with the
{opt priors()} option, or if {opt priors()} is not specified, by the values in
{cmd:e(grouppriors)}.  By common convention, if prior probabilities are equal
across the groups, the prior probability term is omitted and the results from
{opt generalized} will equal those from {opt mahalanobis}.

{phang}
{opt all} is equivalent to specifying {cmd:mahalanobis(f p)} and
{opt generalized}.

{phang}
{opth format(%fmt)} specifies the matrix display format.  The default is
{cmd:format(%9.0g)}.

{dlgtab:Options}

{phang}
{opt priors(priors)} specifies the group prior probabilities and affects only
the output of the {opt generalized} option.
By default, {it:priors} is determined from {cmd:e(grouppriors)}.
See {it:{help discrim_lda_postestimation##priorsdesc:Options for predict}} for
the {it:priors} specification.


{marker options_estat_grmeans}{...}
{title:Options for estat grmeans}

{dlgtab:Main}

{phang}
{opt raw}, the default, displays a table of group means.

{phang}
{opt totalstd} specifies that a table of total-sample standardized group means
be presented.

{phang}
{opt withinstd} specifies that a table of pooled within-group standardized
group means be presented.

{phang}
{opt canonical} specifies that a table of the unstandardized canonical
discriminant functions evaluated at the group means be presented.

{phang}
{opt all} is equivalent to specifying {opt raw}, {opt totalstd},
{opt withinstd}, and {opt canonical}.


{marker options_estat_loadings}{...}
{title:Options for estat loadings}

{dlgtab:Main}

{phang}
{opt standardized} specifies that the pooled within-group standardized
canonical discriminant function coefficients be presented.
This is the default.

{phang}
{opt totalstandardized} specifies that the total-sample standardized canonical
discriminant function coefficients be presented.

{phang}
{opt unstandardized} specifies that the unstandardized canonical discriminant
function coefficients be presented.

{phang}
{opt all} is equivalent to specifying {opt standardized},
{opt totalstandardized}, and {opt unstandardized}.

{phang}
{opth format(%fmt)} specifies the matrix display format.  The default is
{cmd:format(%9.0g)}.


{marker option_estat_structure}{...}
{title:Option for estat structure}

{dlgtab:Main}

{phang}
{opth format(%fmt)} specifies the matrix display format.  The default is
{cmd:format(%9.0g)}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rootstock}{p_end}

{pstd}Fit linear discriminant analysis (LDA) model with equal prior
	probabilities for the six rootstock groups and display classification
	matrix{p_end}
{phang2}{cmd:. discrim lda y1 y2 y3 y4, group(rootstock)}{p_end}

{pstd}List true group, predicted group, and posterior probabilities for
	misclassified observations{p_end}
{phang2}{cmd:. estat list, misclassified}{p_end}

{pstd}Predict leave-one-out posterior probabilities{p_end}
{phang2}{cmd:. predict pp1 pp2 pp3 pp4 pp5 pp6, loopr}{p_end}

{pstd}Display the leave-one-out classification table{p_end}
{phang2}{cmd:. estat classtable, loo}{p_end}

{pstd}Display canonical correlations, eigenvalues, and likelihood-ratio tests
	of the canonical discriminant functions{p_end}
{phang2}{cmd:. estat canontest}{p_end}

{pstd}Display the classification functions{p_end}
{phang2}{cmd:. estat classfunctions}{p_end}

{pstd}Display the canonical coefficients (loadings){p_end}
{phang2}{cmd:. estat loadings}{p_end}

{pstd}Display the canonical structure matrix{p_end}
{phang2}{cmd:. estat structure}{p_end}

{pstd}Display the canonical functions evaluated at the group means{p_end}
{phang2}{cmd:. estat grmeans, canonical}{p_end}

{pstd}Show the Mahalanobis squared distance between the group means along
	with the associated F tests and p-values{p_end}
{phang2}{cmd:. estat grdistances, mahalanobis(f p)}{p_end}

{pstd}Display the MANOVA table related to this discriminant analysis{p_end}
{phang2}{cmd:. estat manova}{p_end}

{pstd}Show a summary of the ANOVAs related to this discriminant analysis{p_end}
{phang2}{cmd:. estat anova}{p_end}

{pstd}Display the pooled within-group covariance matrix{p_end}
{phang2}{cmd:. estat covariance}{p_end}

{pstd}Display the pooled within-group correlation matrix and the correlation
	matrices for each group; present two-sided p-values for each
	correlation{p_end}
{phang2}{cmd:. estat correlations, within groups p}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat anova} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:r(df_r)}}residual degrees of freedom{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(anova_stats)}}ANOVA statistics for the model{p_end}


{pstd}
{cmd:estat canontest} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(N_groups)}}number of groups{p_end}
{synopt:{cmd:r(k)}}number of variables{p_end}
{synopt:{cmd:r(f)}}number of canonical discriminant functions{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(stat)}}canonical discriminant statistics{p_end}


{pstd}
{cmd:estat classfunction} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(C)}}classification function matrix{p_end}
{synopt:{cmd:r(priors)}}group prior probabilities{p_end}


{pstd}
{cmd:estat correlations} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(Rho)}}pooled within-group correlation matrix ({opt within}
	only){p_end}
{synopt:{cmd:r(P)}}two-sided p-values for pooled within-group correlations
	({opt within} and {opt p} only){p_end}
{synopt:{cmd:r(Rho_between)}}between-groups correlation matrix ({opt between}
	only){p_end}
{synopt:{cmd:r(P_between)}}two-sided p-values for between-groups correlations
	({opt between} and {opt p} only){p_end}
{synopt:{cmd:r(Rho_total)}}total-sample correlation matrix ({opt total}
	only){p_end}
{synopt:{cmd:r(P_total)}}two-sided p-values for total-sample correlations
	({opt total} and {opt p} only){p_end}
{synopt:{cmd:r(Rho_}{it:#}{cmd:)}}group {it:#} correlation matrix
	({opt groups} only){p_end}
{synopt:{cmd:r(P_}{it:#}{cmd:)}}two-sided p-values for group {it:#}
	correlations ({opt groups} and {opt p} only){p_end}


{pstd}
{cmd:estat covariance} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(S)}}pooled within-group covariance matrix ({opt within}
	only){p_end}
{synopt:{cmd:r(S_between)}}between-groups covariance matrix ({opt between}
	only){p_end}
{synopt:{cmd:r(S_total)}}total-sample covariance matrix ({opt total}
	only){p_end}
{synopt:{cmd:r(S_}{it:#}{cmd:)}}group {it:#} covariance matrix ({opt groups}
	only){p_end}


{pstd}
{cmd:estat grdistances} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(df1)}}numerator degrees of freedom ({opt mahalanobis}
	only){p_end}
{synopt:{cmd:r(df2)}}denominator degrees of freedom ({opt mahalanobis}
	only){p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(sqdist)}}Mahalanobis squared distances between group means
	({opt mahalanobis} only){p_end}
{synopt:{cmd:r(F_sqdist)}}F statistics for tests of the Mahalanobis squared
	distances between group means are zero ({opt mahalanobis} only){p_end}
{synopt:{cmd:r(P_sqdist)}}p-value for tests that the Mahalanobis squared
	distances between group means are zero ({opt mahalanobis} only){p_end}
{synopt:{cmd:r(gsqdist)}}generalized squared distances between group means
	({opt generalized} only){p_end}


{pstd}
{cmd:estat grmeans} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(means)}}group means
	({opt raw} only){p_end}
{synopt:{cmd:r(stdmeans)}}total-sample standardized group means
	({opt totalstd} only){p_end}
{synopt:{cmd:r(wstdmeans)}}pooled within-group standardized group means
	({opt withinstd} only){p_end}
{synopt:{cmd:r(cmeans)}}group means on canonical variables
	({opt canonical} only){p_end}


{pstd}
{cmd:estat loadings} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(L_std)}}within-group standardized canonical discriminant
	function coefficients ({opt standardized} only){p_end}
{synopt:{cmd:r(L_totalstd)}}total-sample standardized canonical discriminant
	function coefficients ({opt totalstandardized} only){p_end}
{synopt:{cmd:r(L_unstd)}}unstandardized canonical discriminant function
	coefficients ({opt unstandardized} only){p_end}


{pstd}
{cmd:estat manova} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:r(df_r)}}residual degrees of freedom{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(stat_m)}}multivariate statistics for the model{p_end}


{pstd}
{cmd:estat structure} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(canstruct)}}canonical structure matrix{p_end}
