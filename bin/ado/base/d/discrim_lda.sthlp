{smcl}
{* *! version 1.2.2  19oct2017}{...}
{viewerdialog discrim "dialog discrim, message(-lda-) name(discrim_lda)"}{...}
{vieweralsosee "[MV] discrim lda" "mansection MV discrimlda"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim lda postestimation" "help discrim lda postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim" "help discrim"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] candisc" "help candisc"}{...}
{viewerjumpto "Syntax" "discrim lda##syntax"}{...}
{viewerjumpto "Menu" "discrim lda##menu"}{...}
{viewerjumpto "Description" "discrim lda##description"}{...}
{viewerjumpto "Links to PDF documentation" "discrim_lda##linkspdf"}{...}
{viewerjumpto "Options" "discrim lda##options"}{...}
{viewerjumpto "Examples" "discrim lda##examples"}{...}
{viewerjumpto "Stored results" "discrim lda##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[MV] discrim lda} {hline 2}}Linear discriminant analysis{p_end}
{p2col:}({mansection MV discrimlda:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 20 2}
{cmd:discrim} {cmd:lda} {varlist} {ifin} 
        [{it:{help discrim lda##weight:weight}}]{cmd:,}
	{opth g:roup(varlist:groupvar)}
	[{it:options}]

{synoptset 19 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent:* {opth g:roup(varlist:groupvar)}}variable specifying the groups{p_end}
{synopt:{opth pri:ors(discrim_lda##priors:priors)}}group prior probabilities{p_end}
{synopt:{opth tie:s(discrim_lda##ties:ties)}}how ties in classification are
        to be handled{p_end}

{syntab:Reporting}
{synopt:{opt not:able}}suppress resubstitution classification table{p_end}
{synopt:{opt loo:table}}display leave-one-out classification table{p_end}
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
See {manhelp discrim_lda_postestimation MV:discrim lda postestimation} for
features available after estimation.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis > Discriminant analysis > Linear (LDA)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:discrim lda} performs linear discriminant analysis.
See {manhelp discrim MV} for other discrimination commands.

{pstd}
If you want canonical linear discriminant results displayed, see
{manhelp candisc MV}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV discrimldaQuickstart:Quick start}

        {mansection MV discrimldaRemarksandexamples:Remarks and examples}

        {mansection MV discrimldaMethodsandformulas:Methods and formulas}

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


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rootstock}{p_end}

{pstd}Fit a linear discriminant analysis (LDA) model with equal prior
probabilities for the six rootstock groups and display classification
matrix{p_end}
{phang2}{cmd:. discrim lda y1 y2 y3 y4, group(rootstock)}{p_end}

{pstd}Fit the same model, but use prior probabilities of 0.2 for the first
four rootstocks and 0.1 for the last two rootstocks{p_end}
{phang2}
{cmd:. discrim lda y*, group(rootstock) priors(.2,.2,.2,.2,.1,.1)}
{p_end}

{pstd}Replay results and display the leave-one-out classification table in
addition to the resubstitution classification table{p_end}
{phang2}{cmd:. discrim, lootable}{p_end}

{pstd}Replay results switching back to equal prior probabilities for the
groups and display only the leave-one-out classification table{p_end}
{phang2}{cmd:. discrim, priors(equal) notable lootable}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:discrim lda} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_groups)}}number of groups{p_end}
{synopt:{cmd:e(k)}}number of discriminating variables{p_end}
{synopt:{cmd:e(f)}}number of nonzero eigenvalues{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:discrim}{p_end}
{synopt:{cmd:e(subcmd)}}{cmd:lda}{p_end}
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
