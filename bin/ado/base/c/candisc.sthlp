{smcl}
{* *! version 1.1.10  19oct2017}{...}
{viewerdialog candisc "dialog candisc"}{...}
{vieweralsosee "[MV] candisc" "mansection MV candisc"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim lda" "help discrim lda"}{...}
{viewerjumpto "Syntax" "candisc##syntax"}{...}
{viewerjumpto "Menu" "candisc##menu"}{...}
{viewerjumpto "Description" "candisc##description"}{...}
{viewerjumpto "Links to PDF documentation" "candisc##linkspdf"}{...}
{viewerjumpto "Options" "candisc##options"}{...}
{viewerjumpto "Examples" "candisc##examples"}{...}
{viewerjumpto "Stored results" "candisc##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[MV] candisc} {hline 2}}Canonical linear discriminant analysis
{p_end}
{p2col:}({mansection MV candisc:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:candisc} {varlist} {ifin} 
        [{it:{help candisc##weight:weight}}]{cmd:,}
	{opth g:roup(varlist:groupvar)}
	[{it:options}]

{synoptset 19 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent:* {opth g:roup(varlist:groupvar)}}variable specifying the groups{p_end}
{synopt:{opth pri:ors(candisc##priors:priors)}}group prior probabilities{p_end}
{synopt:{opth tie:s(candisc##ties:ties)}}how ties in classification are to be
	handled{p_end}

{syntab:Reporting}
{synopt:{opt not:able}}suppress resubstitution classification table{p_end}
{synopt:{opt loo:table}}display leave-one-out classification table{p_end}
{synopt:{opt nost:ats}}suppress display of canonical statistics{p_end}
{synopt:{opt noco:ef}}suppress display of standardized canonical
	discriminant function coefficients{p_end}
{synopt:{opt nostr:uct}}suppress display of canonical structure matrix{p_end}
{synopt:{opt nom:eans}}suppress display of group means on canonical
	variables{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help discrim_opts

{p 4 6 2}
*{opt group()} is required.{p_end}
{p 4 6 2}
{opt statsby} and {cmd:xi} are allowed; see {help prefix}.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s are allowed; see {help weight}.
{p_end}
{p 4 6 2}
{* -candisc- and -discrim lda- share the same postestimation commands / help}
See {manhelp discrim_lda_postestimation MV:discrim lda postestimation} for
features available after estimation.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis > Discriminant analysis >}
        {bf:Canonical linear discriminant analysis}


{marker description}{...}
{title:Description}

{pstd}
{cmd:candisc} performs canonical linear discriminant analysis (LDA).  What is
computed is the same as with {manhelp discrim_lda MV:discrim lda}.  The
difference is in what is presented.  See {manhelp discrim MV} for other
discrimination commands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV candiscQuickstart:Quick start}

        {mansection MV candiscRemarksandexamples:Remarks and examples}

        {mansection MV candiscMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth group:(varlist:groupvar)}
is required and specifies the name of the grouping variable.  {it:groupvar}
must be a numeric variable.

INCLUDE help discrim_priors

{dlgtab:Reporting}

{phang}
{opt notable}
suppresses the computation and display of the resubstitution classification
table.

{phang}
{opt lootable}
displays the leave-one-out classification table.

{phang}
{opt nostats}
suppresses the display of the table of canonical statistics.

{phang}
{opt nocoef}
suppresses the display of the standardized canonical discriminant function
coefficients.

{phang}
{opt nostruct}
suppresses the display of the canonical structure matrix.

{phang}
{opt nomeans}
suppresses the display of group means on canonical variables.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rootstock}{p_end}

{pstd}Fit linear discriminant analysis (LDA) model with equal prior
probabilities for the six rootstock groups and display the canonical
results{p_end}
{phang2}{cmd:. candisc y1 y2 y3 y4, group(rootstock)}{p_end}

{pstd}Fit the same model, but use prior probabilities of 0.2 for the first
four rootstocks and 0.1 for the last two rootstocks and display only the
canonical discriminant test statistics and the leave-one-out classification
table{p_end}
{phang2}
{cmd:. candisc y*, group(rootstock) priors(.2,.2,.2,.2,.1,.1) lootable}
	{cmd:notable nocoef nostruct nomeans}
{p_end}

{pstd}Replay results allowing the default display{p_end}
{phang2}{cmd:. candisc}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:candisc} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_groups)}}number of groups{p_end}
{synopt:{cmd:e(k)}}number of discriminating variables{p_end}
{synopt:{cmd:e(f)}}number of nonzero eigenvalues{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:candisc}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(groupvar)}}name of group variable{p_end}
{synopt:{cmd:e(grouplabels)}}labels for the groups{p_end}
{synopt:{cmd:e(varlist)}}discriminating variables{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(ties)}}how ties are to be handled{p_end}
{synopt:{cmd:e(properties)}}{cmd:nob noV eigen}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(groupcounts)}}number of observations for each group{p_end}
{synopt:{cmd:e(grouppriors)}}prior probabilities for each group{p_end}
{synopt:{cmd:e(groupvalues)}}numeric value for each group{p_end}
{synopt:{cmd:e(means)}}group means on discriminating variables{p_end}
{synopt:{cmd:e(SSCP_W)}}pooled within-group SSCP matrix{p_end}
{synopt:{cmd:e(SSCP_B)}}between-groups SSCP matrix{p_end}
{synopt:{cmd:e(SSCP_T)}}total SSCP matrix{p_end}
{synopt:{cmd:e(SSCP_W}{it:#}{cmd:)}}within-group SSCP matrix for group
        {it:#}{p_end}
{synopt:{cmd:e(W_eigvals)}}eigenvalues of {cmd:e(SSCP_W)}{p_end}
{synopt:{cmd:e(W_eigvecs)}}eigenvectors of {cmd:e(SSCP_W)}{p_end}
{synopt:{cmd:e(S)}}pooled within-group covariance matrix{p_end}
{synopt:{cmd:e(Sinv)}}inverse of {cmd:e(S)}{p_end}
{synopt:{cmd:e(sqrtSinv)}}Cholesky (square root) of {cmd:e(Sinv)}{p_end}
{synopt:{cmd:e(Ev)}}eigenvalues of inv(W)*B{p_end}
{synopt:{cmd:e(L_raw)}}eigenvectors of inv(W)*B{p_end}
{synopt:{cmd:e(L_unstd)}}unstandardized canonical discriminant function
	coefficients{p_end}
{synopt:{cmd:e(L_std)}}within-group standardized canonical discriminant
	function coefficients{p_end}
{synopt:{cmd:e(L_totalstd)}}total-sample standardized canonical discriminant
	function coefficients{p_end}
{synopt:{cmd:e(C)}}classification coefficients{p_end}
{synopt:{cmd:e(cmeans)}}unstandardized canonical discriminant functions
	evaluated at group means{p_end}
{synopt:{cmd:e(canstruct)}}canonical structure matrix{p_end}
{synopt:{cmd:e(candisc_stat)}}canonical discriminant analysis statistics{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
