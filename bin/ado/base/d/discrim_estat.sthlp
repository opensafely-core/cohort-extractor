{smcl}
{* *! version 1.2.4  19oct2017}{...}
{viewerdialog "estat after discrim knn" "dialog discrim_knn_estat"}{...}
{viewerdialog "estat after discrim lda" "dialog discrim_lda_estat"}{...}
{viewerdialog "estat after discrim logistic" "dialog discrim_logistic_estat"}{...}
{viewerdialog "estat after discrim qda" "dialog discrim_qda_estat"}{...}
{vieweralsosee "[MV] discrim estat" "mansection MV discrimestat"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim" "help discrim"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim knn postestimation" "help discrim_knn_postestimation"}{...}
{vieweralsosee "[MV] discrim lda postestimation" "help discrim_lda_postestimation"}{...}
{vieweralsosee "[MV] discrim logistic postestimation" "help discrim_logistic_postestimation"}{...}
{vieweralsosee "[MV] discrim qda postestimation" "help discrim_qda_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] candisc" "help candisc"}{...}
{viewerjumpto "Postestimation commands" "discrim estat##description"}{...}
{viewerjumpto "Links to PDF documentation" "discrim_estat##linkspdf"}{...}
{viewerjumpto "Syntax for estat" "discrim estat##syntax_estat"}{...}
{viewerjumpto "Menu for estat" "discrim estat##menu_estat"}{...}
{viewerjumpto "Description for estat" "discrim estat##desc_estat"}{...}
{viewerjumpto "Options for estat classtable" "discrim estat##options_estat_classtable"}{...}
{viewerjumpto "Options for estat errorrate" "discrim estat##options_estat_errorrate"}{...}
{viewerjumpto "Options for estat grsummarize" "discrim estat##options_estat_grsummarize"}{...}
{viewerjumpto "Options for estat list" "discrim estat##options_estat_list"}{...}
{viewerjumpto "Options for estat summarize" "discrim estat##options_estat_summarize"}{...}
{viewerjumpto "Examples" "discrim estat##examples"}{...}
{viewerjumpto "Stored results" "discrim estat##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[MV] discrim estat} {hline 2}}Postestimation tools for
	discrim
{p_end}
{p2col:}({mansection MV discrimestat:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:candisc}, {cmd:discrim} {cmd:knn}, {cmd:discrim} {cmd:lda}, {cmd:discrim}
{cmd:logistic}, and {cmd:discrim} {cmd:qda}:

{synoptset 19}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb discrim estat##syntax_estat:estat classtable}}classification
	table{p_end}
{synopt:{helpb discrim estat##syntax_estat:estat errorrate}}classification
	error-rate estimation{p_end}
{synopt:{helpb discrim estat##syntax_estat:estat grsummarize}}group
	summaries{p_end}
{synopt:{helpb discrim estat##syntax_estat:estat list}}classification
	listing{p_end}
{synopt:{helpb discrim estat##syntax_estat:estat summarize}}estimation
        sample summary{p_end}
{synoptline}

{pstd}
There are more postestimation commands of special interest after
{cmd:discrim lda} and {cmd:discrim qda}; see
{manhelp discrim_lda_postestimation MV:discrim lda postestimation} and
{manhelp discrim_qda_postestimation MV:discrim qda postestimation}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV discrimestatRemarksandexamples:Remarks and examples}

        {mansection MV discrimestatMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker estatclasstable}{marker estaterrorrate}{marker estatgrsummarize}{...}
{marker estatlist}{marker estatsummarize}{...}
{marker syntax_estat}{...}
{title:Syntax}

{pstd}Classification table

{p 8 25 2}
	{cmd:estat} {opt class:table} {ifin}
  [{it:{help discrim estat##weight:weight}}]
  [{cmd:,} {it:{help discrim_estat##classtable_options:classtable_options}}]


{pstd}Classification error-rate estimation

{p 8 25 2}
	{cmd:estat} {opt err:orrate} {ifin}
  [{it:{help discrim estat##weight:weight}}]
  [{cmd:,} {it:{help discrim_estat##errorrate_options:errorrate_options}}]


{pstd}Group summaries

{p 8 25 2}
	{cmd:estat} {opt grs:ummarize}
  [{cmd:,} {it:{help discrim_estat##grsummarize_options:grsummarize_options}}]


{pstd}Classification listing

{p 8 25 2}
	{cmd:estat} {opt li:st} {ifin}
  [{cmd:,} {it:{help discrim_estat##list_options:list_options}}]


{pstd}Estimation sample summary

{p 8 25 2}
	{cmd:estat} {opt su:mmarize} [{cmd:,}
		{opt lab:els} {opt nohea:der} {opt nowei:ghts}]


{marker classtable_options}{...}
{synoptset 18 tabbed}{...}
{synopthdr:classtable_options}
{synoptline}
{syntab:Main}
{synopt:{opt cl:ass}}display the classification table; the default{p_end}
{synopt:{opt loo:class}}display the leave-one-out classification table{p_end}

{syntab:Options}
{synopt:{opth pri:ors(discrim_estat##priors:priors)}}group prior
	probabilities; defaults to {cmd:e(grouppriors)}{p_end}
{synopt:{opt nopri:ors}}suppress display of prior probabilities{p_end}
{synopt:{opth tie:s(discrim_estat##ties:ties)}}how ties in classification are
	to be handled; defaults to {cmd:e(ties)}{p_end}
{synopt:{opt tit:le(text)}}title for classification table{p_end}
{synopt:{opt prob:abilities}}display the average posterior probability
	of being classified into each group{p_end}
{synopt:{opt noper:cents}}suppress display of percentages{p_end}
{synopt:{opt not:otals}}suppress display of row and column totals{p_end}
{synopt:{opt norowt:otals}}suppress display of row totals{p_end}
{synopt:{opt nocolt:otals}}suppress display of column totals{p_end}
{synoptline}
{p2colreset}{...}


{synoptset 18}{...}
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
        tie; after {cmd:discrim knn} only{p_end}
{synoptline}


{marker errorrate_options}{...}
{synoptset 18 tabbed}{...}
{synopthdr:errorrate_options}
{synoptline}
{syntab:Main}
{synopt:{opt cl:ass}}display the classification-based error-rate estimates
	table; the default{p_end}
{synopt:{opt loo:class}}display the leave-one-out classification-based
	error-rate estimates table{p_end}
{synopt:{opt cou:nt}}use a count-based error-rate estimate{p_end}
{synopt:{opt pp}[{cmd:(}{it:{help discrim_estat##ppopts:ppopts}}{cmd:)}]}use
	a posterior-probability-based error-rate estimate{p_end}

{syntab:Options}
{synopt:{opth pri:ors(discrim_estat##priors:priors)}}group prior probabilities;
	defaults to {cmd:e(grouppriors)}{p_end}
{synopt:{opt nopri:ors}}suppress display of prior probabilities{p_end}
{synopt:{opth tie:s(discrim_estat##ties:ties)}}how ties in classification are
       to be handled; defaults to {cmd:e(ties)}{p_end}
{synopt:{opt tit:le(text)}}title for error-rate estimate table{p_end}
{synopt:{opt not:otal}}suppress display of total column{p_end}
{synoptline}
{p2colreset}{...}


{synoptset 18}{...}
{marker ppopts}{...}
{synopthdr:ppopts}
{synoptline}
{synopt:{opt s:tratified}}present stratified results{p_end}
{synopt:{opt uns:tratified}}present unstratified results{p_end}
{synoptline}


{marker grsummarize_options}{...}
{synoptset 21 tabbed}{...}
{synopthdr:grsummarize_options}
{synoptline}
{syntab:Main}
{synopt:{cmd:n}[{cmd:(}{it:{help %fmt}}{cmd:)}]}group sizes{p_end}
{synopt:{cmdab:m:ean}[{cmd:(}{it:{help %fmt}}{cmd:)}]}means{p_end}
{synopt:{cmdab:med:ian}[{cmd:(}{it:{help %fmt}}{cmd:)}]}medians{p_end}
{synopt:{cmd:sd}[{cmd:(}{it:{help %fmt}}{cmd:)}]}standard deviations{p_end}
{synopt:{cmd:cv}[{cmd:(}{it:{help %fmt}}{cmd:)}]}coefficients of
	variation{p_end}
{synopt:{cmdab:sem:ean}[{cmd:(}{it:{help %fmt}}{cmd:)}]}standard errors of the
means{p_end}
{synopt:{cmd:min}[{cmd:(}{it:{help %fmt}}{cmd:)}]}minimums{p_end}
{synopt:{cmd:max}[{cmd:(}{it:{help %fmt}}{cmd:)}]}maximums{p_end}

{syntab:Options}
{synopt:{opt notot:al}}suppress overall statistics{p_end}
{synopt:{opt tran:spose}}display groups by row instead of column{p_end}
{synoptline}


{marker list_options}{...}
{synoptset 27 tabbed}{...}
{synopthdr:list_options}
{synoptline}
{syntab:Main}
{synopt:{opt mis:classified}}list only misclassified and unclassified
	observations{p_end}
{synopt:{cmdab:cl:assification(}{help discrim_estat##clopts:{it:clopts}}{cmd:)}}control
	display of classification{p_end}
{synopt:{cmdab:pr:obabilities(}{help discrim_estat##propts:{it:propts}}{cmd:)}}control
	display of probabilities{p_end}
{synopt:{cmdab:var:list}[{cmd:(}{help discrim_estat##varopts:{it:varopts}}{cmd:)}]}display
	discriminating variables{p_end}
{synopt:[{cmdab:no:}]{opt o:bs}}display or suppress the observation
	number{p_end}
{synopt:{cmdab:i:d(}{varname} [{opth for:mat(%fmt)}]{cmd:)}}display
	identification variable{p_end}

{syntab:Options}
{synopt:{cmdab:w:eight}[{cmd:(}{help discrim_estat##weightopts:{it:weightopts}}{cmd:)}]}display
	frequency weights{p_end}
{synopt:{opth pri:ors(discrim_estat##priors:priors)}}group prior probabilities;
	defaults to {cmd:e(grouppriors)}{p_end}
{synopt:{opth tie:s(discrim_estat##ties:ties)}}how ties in classification are
	to be handled; defaults to {cmd:e(ties)}{p_end}
{synopt:{opt sep:arator(#)}}display a horizontal separator every {it:#}
	lines{p_end}
{synoptline}
{p2colreset}{...}


{synoptset 27}{...}
{marker clopts}{...}
{synopthdr:clopts}
{synoptline}
{synopt:{opt noc:lass}}do not display the standard classification{p_end}
{synopt:{opt loo:class}}display the leave-one-out classification{p_end}
{synopt:{opt not:rue}}do not show the group variable{p_end}
{synopt:{opt nos:tar}}do not display stars indicating misclassified
	observations{p_end}
{synopt:{opt nol:abel}}suppress display of value labels for the group and
	classification variables{p_end}
{synopt:{opth for:mat(%fmt)}}format for group and classification variables;
	default is {cmd:%5.0f} for unlabeled numeric variables{p_end}
{synoptline}


{marker propts}{...}
{synopthdr:propts}
{synoptline}
{synopt:{opt nop:r}}suppress display of standard posterior probabilities{p_end}
{synopt:{opt loo:pr}}display leave-one-out posterior probabilities{p_end}
{synopt:{opth for:mat(%fmt)}}format for probabilities; default is {cmd:format(%7.4f)}{p_end}
{synoptline}


{marker varopts}{...}
{synopthdr:varopts}
{synoptline}
{synopt:{opt non:e}}do not display discriminating variables; the default{p_end}
{synopt:{opt f:irst}}display input variables before classifications and
	probabilities{p_end}
{synopt:{opt l:ast}}display input variables after classifications and
	probabilities{p_end}
{synopt:{opth for:mat(%fmt)}}format for input variables; default is the input
	variable format{p_end}
{synoptline}


{marker weightopts}{...}
{synopthdr:weightopts}
{synoptline}
{synopt:{opt non:e}}do not display the weights{p_end}
{synopt:{opth for:mat(%fmt)}}format for the weight; default is {cmd:%3.0f} for
	weights < 1,000, {cmd:%5.0f} for 1,000 < weights < 100,000, and 
	{cmd:%8.0g} otherwise{p_end}
{synoptline}


{marker weight}{...}
{p 4 6 2}{opt fweight}s are allowed; see {help weight}.


INCLUDE help menu_estat


{marker desc_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat classtable}
displays a cross-tabulation of the original groups with the classification
table.  Classification percentages, average posterior
probabilities, group prior probabilities, totals, and leave-one-out results
are available.

{pstd}
{cmd:estat errorrate}
displays error-rate estimates for the classification.  Count-based estimates
and both stratified and unstratified posterior-probability-based estimates of
the error rate are available.  These estimates can be resubstitution or
leave-one-out estimates.

{pstd}
{cmd:estat grsummarize}
presents estimation sample summary statistics for the discriminating variables
for each group defined by the grouping variable.  Means,
medians, minimums, maximums, standard deviations, coefficients of variation,
standard errors of the means, and group sizes may be displayed.  Overall
sample statistics are also available.

{pstd}
{cmd:estat list}
lists group membership, classification, and probabilities for observations.

{pstd}
{cmd:estat summarize}
summarizes the variables in the discriminant analysis over the estimation
sample.


{marker options_estat_classtable}{...}
{title:Options for estat classtable}

{dlgtab:Main}

{phang}
{opt class}, the default, displays the classification table.  With
in-sample observations, this is called the resubstitution classification
table.

{phang}
{opt looclass}
displays a leave-one-out classification table, instead of the default
classification table.  Leave-one-out classification applies only to the
estimation sample, and so, in addition to restricting the observations to
those chosen with {cmd:if} and {cmd:in} qualifiers, the observations are
further restricted to those included in {cmd:e(sample)}.

{dlgtab:Options}

{phang}
{opt priors(priors)}
specifies the prior probabilities for group membership.  If {opt priors()} is
not specified, {cmd:e(grouppriors)} is used.  If {opt nopriors} is specified
with {cmd:priors()}, prior probabilities are used for calculation of the
classification variable but not displayed.
The following {it:priors} are allowed:

{phang2}
{cmd:priors(}{opt eq:ual}{cmd:)} specifies equal prior probabilities.

{phang2}
{cmd:priors(}{opt prop:ortional}{cmd:)} specifies group-size-proportional
    prior probabilities.

{phang2}
{cmd:priors(}{it:matname}{cmd:)} specifies a row or column vector containing
the group prior probabilities.

{phang2}
{cmd:priors(}{it:matrix_exp}{cmd:)} specifies a matrix expression providing a
row or column vector of the group prior probabilities.

{phang}
{opt nopriors}
suppresses display of the prior probabilities.  This option does not change
the computations that rely on the prior probabilities specified in
{opt priors()} or as found by default in {cmd:e(grouppriors)}.

{phang}
{opt ties(ties)}
specifies how ties in group classification will be handled.  If
{opt ties()} is not specified, {cmd:e(ties)} determines how ties are handled.
The following {it:ties} are allowed:

{phang2}
{cmd:ties(}{opt m:issing}{cmd:)} specifies that ties in group classification
produce missing values.

{phang2}
{cmd:ties(}{opt r:andom}{cmd:)} specifies that ties in group classification
are broken randomly.

{phang2}
{cmd:ties(}{opt f:irst}{cmd:)} specifies that ties in group classification are
set to the first tied group.

{phang2}
{cmd:ties(}{opt n:earest}{cmd:)} specifies that ties in group classification
   are assigned based on the closest observation, or missing if this still
   results in a tie. {cmd:ties(nearest)} is available after {cmd:discrim knn}
   only.

{phang}
{opt title(text)}
customizes the title for the classification table.

{phang}
{opt probabilities}
specifies that the classification table show the average posterior probability
of being classified into each group.  {opt probabilities} implies
{opt norowtotals} and {opt nopercents}.

{phang}
{opt nopercents}
specifies that percentages are to be omitted from the classification table.

{phang}
{opt nototals}
specifies that row and column totals are to be omitted from the classification
table.

{phang}
{opt norowtotals}
specifies that row totals are to be omitted from the classification table.

{phang}
{opt nocoltotals}
specifies that column totals are to be omitted from the classification table.


{marker options_estat_errorrate}{...}
{title:Options for estat errorrate}

{dlgtab:Main}

{phang}
{opt class},
the default, specifies that the classification-based error-rate estimates
table be presented.  The alternative to {opt class} is {opt looclass}.

{phang}
{opt looclass}
specifies that the leave-one-out classification error-rate estimates table be
presented.

{phang}
{opt count},
the default, specifies the error-rate estimates be based on
misclassification counts.  The alternative to {opt count} is {opt pp()}.

{phang}
{opt pp}[{cmd:(}{it:ppopts}{cmd:)}]
specifies that the error-rate estimates be based on posterior probabilities.
{cmd:pp} is equivalent to {cmd:pp(stratified unstratified)}.  {cmd:stratified}
indicates that stratified estimates be presented.  {cmd:unstratified}
indicates that unstratified estimates be presented. One or both may be
specified.

{dlgtab:Options}

{phang}
{opt priors(priors)}
specifies the prior probabilities for group membership.  If {opt priors()} is
not specified, {cmd:e(grouppriors)} is used.  If {opt nopriors} is specified
with {cmd:priors()}, prior probabilities are used for calculation of the
error-rate estimates but not displayed.  The following {it:priors} are
allowed:

{phang2}
{cmd:priors(}{opt eq:ual}{cmd:)} specifies equal prior probabilities.

{phang2}
{cmd:priors(}{opt prop:ortional}{cmd:)} specifies group-size-proportional
    prior probabilities.

{phang2}
{cmd:priors(}{it:matname}{cmd:)} specifies a row or column vector containing
the group prior probabilities.

{phang2}
{cmd:priors(}{it:matrix_exp}{cmd:)} specifies a matrix expression providing a
row or column vector of the group prior probabilities.

{phang}
{opt nopriors}
suppresses display of the prior probabilities.  This option does not change
the computations that rely on the prior probabilities specified in
{opt priors()} or as found by default in {cmd:e(grouppriors)}.

{phang}
{opt ties(ties)}
specifies how ties in group classification will be handled.  If
{opt ties()} is not specified, {cmd:e(ties)} determines how ties are handled.
The following {it:ties} are allowed:

{phang2}
{cmd:ties(}{opt m:issing}{cmd:)} specifies that ties in group classification
produce missing values.

{phang2}
{cmd:ties(}{opt r:andom}{cmd:)} specifies that ties in group classification
are broken randomly.

{phang2}
{cmd:ties(}{opt f:irst}{cmd:)} specifies that ties in group classification are
set to the first tied group.

{phang2}
{cmd:ties(}{opt n:earest}{cmd:)} specifies that ties in group classification
   are assigned based on the closest observation, or missing if this still
   results in a tie.  {cmd:ties(nearest)} is available after {cmd:discrim knn}
   only.

{phang}
{opt title(text)}
customizes the title for the error-rate estimates table.

{phang}
{opt nototal}
suppresses the total column containing overall sample error-rate estimates.


{marker options_estat_grsummarize}{...}
{title:Options for estat grsummarize}

{dlgtab:Main}

{phang}
{cmd:n}[{cmd:(}{it:{help %fmt}}{cmd:)}]
specifies that group sizes be presented.
The optional argument provides a display format.
The default options are {cmd:n} and {cmd:mean}.

{phang}
{cmd:mean}[{cmd:(}{it:{help %fmt}}{cmd:)}]
specifies that means be presented.
The optional argument provides a display format.
The default options are {cmd:n} and {cmd:mean}.

{phang}
{cmd:median}[{cmd:(}{it:{help %fmt}}{cmd:)}]
specifies that medians be presented.
The optional argument provides a display format.

{phang}
{cmd:sd}[{cmd:(}{it:{help %fmt}}{cmd:)}]
specifies that standard deviations be presented.
The optional argument provides a display format.

{phang}
{cmd:cv}[{cmd:(}{it:{help %fmt}}{cmd:)}]
specifies that coefficients of variation be presented.
The optional argument provides a display format.

{phang}
{cmd:semean}[{cmd:(}{it:{help %fmt}}{cmd:)}]
specifies that standard errors of the means be presented.
The optional argument provides a display format.

{phang}
{cmd:min}[{cmd:(}{it:{help %fmt}}{cmd:)}]
specifies that minimums be presented.
The optional argument provides a display format.

{phang}
{cmd:max}[{cmd:(}{it:{help %fmt}}{cmd:)}]
specifies that maximums be presented.
The optional argument provides a display format.

{dlgtab:Options}

{phang}
{opt nototal}
suppresses display of the total column containing overall sample statistics.

{phang}
{opt transpose}
specifies that the groups are to be displayed by row.  By default, groups are
displayed by column.  If you have more variables than groups, you might prefer
the output produced by {opt transpose}.


{marker options_estat_list}{...}
{title:Options for estat list}

{dlgtab:Main}

{phang}
{opt misclassified}
lists only misclassified and unclassified observations.

{phang}
{opt classification(clopts)}
controls display of the group variable and classification.  By default, the
standard classification is calculated and displayed along with the group
variable in {cmd:e(groupvar)}, using labels from the group variable if they
exist.  {it:clopts} may be one or more of the following:

{phang2}
    {opt noclass}
    suppresses display of the standard classification.  If the observations
    are those used in the estimation, classification is called resubstitution
    classification.

{phang2}
    {opt looclass}
    specifies that the leave-one-out classification be calculated and
    displayed.  The default is that the leave-one-out classification is not
    calculated.  {opt looclass} is not allowed after {cmd:discrim logistic}.

{phang2}
    {opt notrue}
    suppresses the display of the group variable.  By default,
    {cmd:e(groupvar)} is displayed.  {cmd:notrue} implies {cmd:nostar}.

{phang2}
    {opt nostar}
    suppresses the display of stars indicating misclassified observations.  A
    star is displayed by default when the classification is not in agreement
    with the group variable.  {cmd:nostar} is the default when {cmd:notrue} is
    specified.

{phang2}
    {opt nolabel} specifies that value labels for the group variable, if they
    exist, not be displayed for the group or classification or used as
    labels for the probability column names.

{phang2}
    {opth format(%fmt)}
    specifies the format for the group and classification variables.  If value
    labels are used, string formats are permitted.

{phang}
{opt probabilities(propts)}
controls the display of group posterior probabilities.  {it:propts} may be one
or more of the following:

{phang2}
    {opt nopr}
    suppresses display of the standard posterior probabilities.  By default,
    the posterior probabilities are shown.

{phang2}
    {opt loopr}
    specifies that leave-one-out posterior probabilities be displayed.
    {opt loopr} is not allowed after {cmd:discrim logistic}.

{phang2}
    {opth format(%fmt)}
    specifies the format for displaying probabilities.  The default is
    {cmd:format(%7.4f)}.

{phang}
{cmd:varlist}[{cmd:(}{it:varopts}{cmd:)}]
specifies that the discriminating variables found in {cmd:e(varlist)} 
be displayed and specifies the display options for the variables.

{phang2}
    {opt none}
    specifies that discriminating variables are not to be displayed.  This is
    the default.

{phang2}
    {opt first}
    specifies variables be displayed before classifications and
    probabilities.

{phang2}
    {opt last}
    specifies variables be displayed after classifications and
    probabilities.

{phang2}
    {opth format(%fmt)}
    specifies the format for the input variables.  By default, the
    variable's format is used.

{phang}
[{opt no}]{opt obs}
indicates that observation numbers be or not be displayed.  Observation
numbers are displayed by default unless {cmd:id()} is specified.

{phang}
{cmd:id(}{varname} [{opth format(%fmt)}]{cmd:)}
    specifies the identification variable to display and, optionally, the
    format for that variable.  By default, the format of {it:varname} is
    used.

{dlgtab:Options}

{phang}
{cmd:weight}[{cmd:(}{it:weightopts}{cmd:)}]
specifies options for displaying weights.  By default, if {cmd:e(wexp)}
exists, weights are displayed.

{phang2}
    {opt none}
    specifies weights not be displayed.  This is the default if weights
    were not used with {cmd:discrim}.

{phang2}
    {opth format(%fmt)}
    specifies a display format for the weights.  If the weights are < 1,000,
    {cmd:%3.0f} is the default, {cmd:%5.0f} is the default if 1,000 < weights
    < 100,000, else {cmd:%8.0g} is used.

{phang}
{opt priors(priors)}
specifies the prior probabilities for group membership.  If {opt priors()} is
not specified, {cmd:e(grouppriors)} is used. 
The following {it:priors} are allowed:

{phang2}
{cmd:priors(}{opt eq:ual}{cmd:)} specifies equal prior probabilities.

{phang2}
{cmd:priors(}{opt prop:ortional}{cmd:)} specifies group-size-proportional
    prior probabilities.

{phang2}
{cmd:priors(}{it:matname}{cmd:)} specifies a row or column vector containing
the group prior probabilities.

{phang2}
{cmd:priors(}{it:matrix_exp}{cmd:)} specifies a matrix expression providing a
row or column vector of the group prior probabilities.

{phang}
{opt ties(ties)}
specifies how ties in group classification will be handled.  If
{opt ties()} is not specified, {cmd:e(ties)} determines how ties are handled.
The following {it:ties} are allowed:

{phang2}
{cmd:ties(}{opt m:issing}{cmd:)} specifies that ties in group classification
produce missing values.

{phang2}
{cmd:ties(}{opt r:andom}{cmd:)} specifies that ties in group classification
are broken randomly.

{phang2}
{cmd:ties(}{opt f:irst}{cmd:)} specifies that ties in group classification are
set to the first tied group.

{phang2}
{cmd:ties(}{opt n:earest}{cmd:)} specifies that ties in group classification
   are assigned based on the closest observation, or missing if this still
   results in a tie.  {cmd:ties(nearest)} is available after {cmd:discrim knn}
   only.

{phang}
{opt separator(#)}
specifies a horizontal separator line be drawn every {it:#}
observation.  The default is {cmd:separator(5)}.


{marker options_estat_summarize}{...}
{title:Options for estat summarize}

{phang}
{opt labels}, {opt noheader}, and {opt noweights} are the same as for the
generic {cmd:estat summarize}; see {helpb estat summarize:[R] estat summarize}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rootstock}{p_end}

{pstd}Fit a quadratic discriminant analysis (QDA) model (the postestimation
commands that follow apply equally well to the other discrimination
commands){p_end}
{phang2}{cmd:. discrim qda y1 y2 y3 y4, group(rootstock)}{p_end}

{pstd}Generate a predicted classification variable{p_end}
{phang2}{cmd:. predict classrstock, classification}{p_end}

{pstd}List the classification and probabilities for the misclassified
observations{p_end}
{phang2}{cmd:. estat list, misclassified}{p_end}

{pstd}Display a classification table with counts and average posterior
probabilities{p_end}
{phang2}{cmd:. estat classtable, probabilities}{p_end}

{pstd}Show the count-based error-rate estimates table{p_end}
{phang2}{cmd:. estat errorrate}{p_end}

{pstd}Present the group means and sample sizes (transposing rows and
columns because there are more groups than variables){p_end}
{phang2}{cmd:. estat grsummarize, transpose}{p_end}

{pstd}View the means, minimums, maximums and sample sizes by group; omit the
overall sample column{p_end}
{phang2}{cmd:. estat grsummarize, mean n min max nototal}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat classtable} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(counts)}}group counts{p_end}
{synopt:{cmd:r(percents)}}percentages for each group (unless {opt nopercents}
	specified){p_end}
{synopt:{cmd:r(avgpostprob)}}average posterior probabilities classified into
	each group ({opt probabilities} only){p_end}

{pstd}
{cmd:estat errorrate} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(grouppriors)}}row vector of group prior probabilities used in
	the calculations{p_end}
{synopt:{cmd:r(erate_count)}}matrix of error rates estimated from error
	counts ({cmd:count} only){p_end}
{synopt:{cmd:r(erate_strat)}}matrix of stratified error rates estimated from
	posterior probabilities ({cmd:pp} only){p_end}
{synopt:{cmd:r(erate_unstrat)}}matrix of unstratified error rates estimated
	from posterior probabilities ({cmd:pp} only){p_end}

{pstd}
{cmd:estat grsummarize} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(count)}}group counts{p_end}
{synopt:{cmd:r(mean)}}means ({cmd:mean} only){p_end}
{synopt:{cmd:r(median)}}medians ({cmd:median} only){p_end}
{synopt:{cmd:r(sd)}}standard deviations ({cmd:sd} only){p_end}
{synopt:{cmd:r(cv)}}coefficients of variation ({cmd:cv} only){p_end}
{synopt:{cmd:r(semean)}}standard errors of the means ({cmd:semean} only){p_end}
{synopt:{cmd:r(min)}}minimums ({cmd:min} only){p_end}
{synopt:{cmd:r(max)}}maximums ({cmd:max} only){p_end}
