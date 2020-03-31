{smcl}
{* *! version 1.1.18  05sep2018}{...}
{viewerdialog discrim "dialog discrim, message(-knn-) name(discrim_knn)"}{...}
{vieweralsosee "[MV] discrim knn" "mansection MV discrimknn"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim knn postestimation" "help discrim knn postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim" "help discrim"}{...}
{viewerjumpto "Syntax" "discrim knn##syntax"}{...}
{viewerjumpto "Menu" "discrim knn##menu"}{...}
{viewerjumpto "Description" "discrim knn##description"}{...}
{viewerjumpto "Links to PDF documentation" "discrim_knn##linkspdf"}{...}
{viewerjumpto "Options" "discrim knn##options"}{...}
{viewerjumpto "Examples" "discrim knn##examples"}{...}
{viewerjumpto "Stored results" "discrim knn##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[MV] discrim knn} {hline 2}}kth-nearest-neighbor discriminant
	analysis
{p_end}
{p2col:}({mansection MV discrimknn:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 20 2}
{cmd:discrim} {cmd:knn} {varlist} {ifin}
        [{it:{help discrim knn##weight:weight}}]{cmd:,}
	{opth g:roup(varlist:groupvar)}
        {opt k(#)}
	[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent :* {opth g:roup(varlist:groupvar)}}variable specifying the groups
         {p_end}
{p2coldent :* {opt k(#)}}number of nearest neighbors{p_end}
{synopt:{opth pri:ors(discrim_knn##priors:priors)}}group prior probabilities{p_end}
{synopt:{opth tie:s(discrim_knn##ties:ties)}}how ties in classification are to
         be handled{p_end}

{syntab:Measure}
{synopt:{cmdab:mea:sure(}{help measure_option:{it:measure}}{cmd:)}}similarity
	or dissimilarity measure; default is {cmd:measure(L2)}{p_end}
{synopt:{cmd:s2d(}{cmdab:st:andard)}}convert similarity to dissimilarity:
		d(ij)=sqrt{c -(}s(ii)+s(jj)-2s(ij){c )-}, the default{p_end}
{synopt:{cmd:s2d(}{cmdab:one:minus)}}convert similarity to dissimilarity:
	d(ij)=1-s(ij){p_end}
{synopt:{opt mah:alanobis}}Mahalanobis transform continuous
data before computing dissimilarities{p_end}

{syntab:Reporting}
{synopt:{opt not:able}}suppress resubstitution classification table{p_end}
{synopt:{opt loo:table}}display leave-one-out classification table{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 20}{...}
{marker priors}{...}
{synopthdr:priors}
{synoptline}
{synopt:{opt eq:ual}}equal prior probabilities; the default{p_end}
{synopt:{opt prop:ortional}}group-size-proportional prior probabilities{p_end}
{synopt:{it:matname}}row or column vector containing the group prior
	probabilities{p_end}
{synopt:{it:matrix_exp}}matrix expression providing a row or column vector of
	the group prior probabilities{p_end}
{synoptline}

{marker ties}{...}
{synopthdr:ties}
{synoptline}
{synopt:{opt m:issing}}ties in group classification produce missing values;
        the default{p_end}
{synopt:{opt r:andom}}ties in group classification are broken randomly{p_end}
{synopt:{opt f:irst}}ties in group classification are set to the first tied
        group{p_end}
{synopt:{opt n:earest}}ties in group classification are assigned based on
	the closest observation, or missing if this still results in a
	tie{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
*{opt group()} and {opt k()} are required.{p_end}
{p 4 6 2}
{opt statsby} and {cmd:xi} are allowed; see {help prefix}.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s are allowed; see {help weight}.
{p_end}
{p 4 6 2}
See {manhelp discrim_knn_postestimation MV:discrim knn postestimation} for
features available after estimation.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis > Discriminant analysis >}
        {bf:Kth-nearest neighbor (KNN)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:discrim knn} performs {it:k}th-nearest-neighbor discriminant analysis.  A
wide selection of similarity and dissimilarity measures is available.

{pstd}
{it:k}th-nearest neighbor must retain the training data and search through the
data for the {it:k} nearest observations each time a classification or
prediction is performed.  Consequently for large datasets, {it:k}th-nearest
neighbor is slow and uses a lot of memory.

{pstd}
See {manhelp discrim MV} for other discrimination commands.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV discrimknnQuickstart:Quick start}

        {mansection MV discrimknnRemarksandexamples:Remarks and examples}

        {mansection MV discrimknnMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth group:(varlist:groupvar)}
is required and specifies the name of the grouping variable.  {it:groupvar}
must be a numeric variable.

{phang}{opt k(#)}
is required and specifies the number of nearest neighbors on which to base
computations.  In the event of ties, the next largest value of {cmd:k()} is
selected.  Suppose that {cmd:k(3)} is selected.  For a given
observation, one must go out a distance {it:d} to find three nearest neighbors,
but if, say, there are five data points all within distance {it:d}, then the
computation will be based on all five nearest points.

INCLUDE help discrim_priors

{phang2}
{cmd:ties(}{opt n:earest}{cmd:)} specifies that ties in group classification
   are assigned based on the closest observation, or missing if this still
   results in a tie.

{dlgtab:Measure}

{marker measure()}{...}
{phang}
{opt measure(measure)}
specifies the similarity or dissimilarity measure.  The default is
{cmd:measure(L2)}; all measures in
{help measure_option:{bf:[MV]} {it:measure_option}} are supported
except for {cmd:measure(Gower)}.

{phang}{cmd:s2d(standard}|{cmd:oneminus)}
specifies how similarities are converted into dissimilarities.

{pmore}
The available {cmd:s2d()} options, {cmd:standard} and {cmd:oneminus}, are
defined as

{p2colset 13 25 27 2}{...}
{p2col:{cmd:standard}}d(ij) = sqrt{c -(}s(ii)+s(jj)-2s(ij){c )-} = sqrt[2{1-s(ij)}]{p_end}{p2col:{cmd:oneminus}}d(ij) = 1-s(ij){p_end}
{p2colreset}{...}

{pmore}{cmd:s2d(standard)} is the default.

{phang}
{opt mahalanobis}
specifies performing a Mahalanobis transformation on continuous data before
computing dissimilarities.  The data are transformed via the Cholesky
decomposition of the within-group covariance matrix, and then the selected
dissimilarity measure is performed on the transformed data.  If the {cmd:L2}
(Euclidean) dissimilarity is chosen, this is the Mahalanobis distance.  If the
within-group covariance matrix does not have sufficient rank, an error is
returned.

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

{pstd}Fit {it:k}th-nearest-neighbor (KNN) discriminant analysis model using
three nearest neighbors and equal prior probabilities for the six rootstock
groups and display classification matrix breaking ties randomly{p_end}
{phang2}{cmd:. discrim knn y1 y2 y3 y4, group(rootstock) k(3) ties(random)}
{p_end}

{pstd}Fit the same model, but use prior probabilities of 0.2 for the first
four rootstocks and 0.1 for the last two rootstocks{p_end}
{phang2}
{cmd:. discrim knn y*, group(rootstock) k(3) ties(random) priors(.2,.2,.2,.2,.1,.1)}
{p_end}

{pstd}Fit a KNN model similar to the first, but use the Mahalanobis distance
to compute the nearest neighbors{p_end}
{phang2}{cmd:. discrim knn y1 y2 y3 y4, group(rootstock) k(3) ties(random)}
{cmd: mahalanobis measure(Euclidean)}{p_end}

{pstd}Replay results and display the leave-one-out classification table in
addition to the resubstitution classification table{p_end}
{phang2}{cmd:. discrim, lootable}{p_end}

{pstd}Replay results switching to proportional prior probabilities for the
groups and display only the leave-one-out classification table{p_end}
{phang2}{cmd:. discrim, priors(proportional) notable lootable}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:discrim knn} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_groups)}}number of groups{p_end}
{synopt:{cmd:e(k_nn)}}number of nearest neighbors{p_end}
{synopt:{cmd:e(k)}}number of discriminating variables{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:discrim}{p_end}
{synopt:{cmd:e(subcmd)}}{cmd:knn}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(groupvar)}}name of group variable{p_end}
{synopt:{cmd:e(grouplabels)}}labels for the groups{p_end}
{synopt:{cmd:e(measure)}}similarity or dissimilarity measure{p_end}
{synopt:{cmd:e(measure_type)}}{cmd:dissimilarity} or {cmd:similarity}{p_end}
{synopt:{cmd:e(measure_binary)}}{cmd:binary}, if binary measure specified{p_end}
{synopt:{cmd:e(s2d)}}{cmd:standard} or {cmd:oneminus}, if {cmd:s2d()} specified{p_end}
{synopt:{cmd:e(varlist)}}discriminating variables{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(ties)}}how ties are to be handled{p_end}
{synopt:{cmd:e(mahalanobis)}}{cmd:mahalanobis}, if Mahalanobis transform is
performed{p_end}
{synopt:{cmd:e(properties)}}{cmd:nob noV}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(groupcounts)}}number of observations for each group{p_end}
{synopt:{cmd:e(grouppriors)}}prior probabilities for each group{p_end}
{synopt:{cmd:e(groupvalues)}}numeric value for each group{p_end}
{synopt:{cmd:e(SSCP_W)}}pooled within-group SSCP matrix{p_end}
{synopt:{cmd:e(W_eigvals)}}eigenvalues of {cmd:e(SSCP_W}{cmd:)}{p_end}
{synopt:{cmd:e(W_eigvecs)}}eigenvectors of {cmd:e(SSCP_W}{cmd:)}{p_end}
{synopt:{cmd:e(S)}}pooled within-group covariance matrix{p_end}
{synopt:{cmd:e(Sinv)}}inverse of {cmd:e(S)}{p_end}
{synopt:{cmd:e(sqrtSinv)}}Cholesky (square root) of {cmd:e(Sinv)}{p_end}
{synopt:{cmd:e(community)}}community of neighbors for prediction{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
