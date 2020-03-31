{smcl}
{* *! version 1.0.22  31jul2019}{...}
{vieweralsosee "[MV] Glossary" "mansection MV Glossary"}{...}
{viewerjumpto "Description" "mv_glossary##description"}{...}
{viewerjumpto "Glossary" "mv_glossary##glossary"}{...}
{viewerjumpto "References" "mv_glossary##references"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[MV] Glossary} {hline 2}}Glossary of terms{p_end}
{p2col:}({mansection MV Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}Commonly used terms are defined here.


{marker glossary}{...}
{title:Glossary}

{phang}
{marker agglohier}{...}
{bf:agglomerative hierarchical clustering methods}.
Agglomerative hierarchical clustering methods are bottom-up methods for
hierarchical clustering.  Each observation begins in a separate group.  The
closest pair of groups is agglomerated or merged in each iteration until all
the data are in one cluster.  This process creates a hierarchy of clusters.
Contrast to 
{help mv_glossary##divisivehier:divisive hierarchical clustering methods}.

{phang}
{bf:anti-image correlation matrix} or {bf:anti-image covariance matrix}.
The image of a variable is defined as that part which is predictable by
regressing each variable on all the other variables; hence, the anti-image is
the part of the variable that cannot be predicted.  The anti-image correlation
matrix {bf:A} is a matrix of the negatives of the partial correlations among
variables.  Partial correlations represent the degree to which the factors
explain each other in the results.  The diagonal of the anti-image correlation
matrix is the Kaiser-Meyer-Olkin measure of sampling adequacy for the individual
variables.  Variables with small values should be eliminated from the analysis.
The anti-image covariance matrix {bf:C} contains the negatives of the
partial covariances and has one minus the squared multiple correlations in the
principal diagonal.  Most of the off-diagonal elements should be small in both
anti-image matrices in a good factor model.  Both anti-image matrices can be
calculated from the inverse of the correlation matrix {bf:R} via 

            {bf:A} = {c -(}diag({bf:R}){c )-}^{-1} {bf:R}{c -(}diag({bf:R}){c )-}^{-1}
            {bf:C} = {c -(}diag({bf:R}){c )-}^{-1/2} {bf:R}{c -(}diag({bf:R}){c )-}^{-1/2}

{pmore}
Also see 
{help mv_glossary##KMO:Kaiser-Meyer-Olkin measure of sampling adequacy}.

{phang}
{bf:average-linkage clustering}.
Average-linkage clustering is a hierarchical clustering method that uses the
average proximity of observations between groups as the proximity measure
between the two groups.

{phang}
{bf:Bayes's theorem}.
Bayes's theorem states that the probability of an event, A, conditional on
another event, B, is generally different from the probability of B
conditional on A, although the two are related.   Bayes's theorem is that

            P(A|B) = {P(B|A) P(A)}/{P(B)}

{pmore}
where P(A) is the marginal probability of A, and P(A|B) is the conditional
probability of A given B, and likewise for P(B) and P(B|A).

{phang}
{bf:Bentler's invariant pattern simplicity rotation}.
Bentler's ({help mv glossary##B1977:1977}) rotation maximizes the invariant
pattern simplicity.  It is an oblique rotation that minimizes the criterion
function

{phang3}
   c({bf:Lambda}) = -log[|({bf:Lambda}^2)'{bf:Lambda}^2|] +
         log[|diag{c -(}({bf:Lambda}^2)'{bf:Lambda}^2{c )-}|]

{pmore}
See 
{help mv_glossary##CFrotate:Crawford-Ferguson rotation}
for a definition of {bf:Lambda}.  Also see 
{help mv_glossary##obliquerotation:oblique rotation}.

{phang}
{marker betweenmatrix}{...}
{bf:between matrix} and {bf:within matrix}.
The between and within matrices are SSCP matrices that measure the
spread between groups and within groups, respectively.  These matrices are
used in multivariate analysis of variance and related hypothesis tests:
Wilks's lambda, Roy's largest root, Lawley-Hotelling trace, and Pillai's trace.

{pmore}
Here we have k independent random samples of size n.  The between matrix
{bf:H} is given by

{phang3}
   {bf:H} = n sum_{i=1}^k ({bf:y}_{i{bf:.}}[bar] -
                           {bf:y}_{{bf:..}}[bar])
                           ({bf:y}_{i{bf:.}}[bar]
                         - {bf:y}_{{bf:..}}[bar])' = sum_{i=1}^k
             1/n {bf:y}_{i{bf:.}}{bf:y}_{i{bf:.}}' -
             1/kn {bf:y}_{{bf:..}}{bf:y}_{{bf:..}}'

{pmore}
The within matrix {bf:E} is defined as

{phang3}
{bf:E} = sum_{i=1}^k sum_{j=1}^n({bf:y}_{ij} - {bf:y}_{i{bf:.}}[bar])
             ({bf:y}_{ij} - {bf:y}_{i{bf:.}})' = sum_{i=1}^k 
              sum_{j=1}^n{bf:y}_{ij}{bf:y}_{ij}' -
              sum_{i=1}^k 1/n {bf:y}_{i{bf:.}}{bf:y}_{i{bf:.}}'

{pmore}
Also see {help mv_glossary##SSCP:SSCP matrix}.

{phang}
{bf:biplot}.
A biplot is a scatterplot which represents both observations and
variables simultaneously.  There are many different biplots;
variables in biplots are usually represented by arrows and observations are
usually represented by points.

{phang}
{bf:biquartimax rotation} or {bf:biquartimin rotation}.
Biquartimax rotation and biquartimin rotation are synonyms.  They put equal
weight on the varimax and quartimax criteria, simplifying the columns and rows
of the matrix.  This is an oblique rotation equivalent to an oblimin rotation
with gamma = 0.5.  Also see
{help mv_glossary##varimaxrotation:varimax rotation},
{help mv_glossary##quartimaxrotation:quartimax rotation}, and
{help mv_glossary##obliminrotation:oblimin rotation}.

{phang}
{bf:boundary solution} or {bf:Heywood solution}.
See {help mv_glossary##Heywood:Heywood case}.

{phang}
{bf:CA}.
See {help mv_glossary##CA:correspondence analysis}.

{phang}
{bf:canonical correlation analysis}.
Canonical correlation analysis attempts to describe the relationships between
two sets of variables by finding linear combinations of each so that the
correlation between the linear combinations is maximized.

{phang}
{marker canonicaldiscrim}{...}
{bf:canonical discriminant analysis}.
Canonical linear discriminant analysis is LDA where describing how
groups are separated is of primary interest.  Also see
{help mv_glossary##LDA:linear discriminant analysis}.

{phang}
{bf:canonical loadings}.
The canonical loadings are coefficients of canonical linear discriminant
functions.  Also see
{help mv_glossary##canonicaldiscrim:canonical discriminant analysis} and
{help mv_glossary##loading:loading}.

{phang}
{bf:canonical variate set}.
The canonical variate set is a linear combination or weighted sum of variables
obtained from canonical correlation analysis.  Two sets of variables are
analyzed in canonical correlation analysis.  The first canonical variate of
the first variable set is the linear combination in standardized form that has
maximal correlation with the first canonical variate from the second variable
set.  The subsequent canonical variates are uncorrelated to the previous and
have maximal correlation under that constraint.

{phang}
{bf:centered data}.
A centered dataset has zero mean.  You can center data {bf:x} by taking
{bf:x} - {bf:x}[bar].

{phang}
{bf:centroid-linkage clustering}.
Centroid-linkage clustering is a hierarchical clustering method that computes
the proximity between two groups as the proximity between the group means.

{phang}
{marker classscaling}
{bf:classical scaling}.
Classical scaling is a method of performing MDS via an eigen
decomposition.  This is contrasted to modern MDS, which is achieved via
the minimization of a loss function.  Also see
{help mv_glossary##MDS:multidimensional scaling} and
{help mv_glossary##modernscaling:modern scaling}.

{phang}
{bf:classification}.
Classification is the act of allocating or classifying observations to groups
as part of discriminant analysis.  In some sources, classification is 
synonymous with cluster analysis.

{phang}
{marker classfunction}
{bf:classification function}.
Classification functions can be obtained after LDA or QDA.
They are functions based on Mahalanobis distance for classifying observations
to the groups.  See
{help mv_glossary##discrimfunction:discriminant function} for an alternative. 
Also see 
{help mv_glossary##LDA:linear discriminant analysis} and
{help mv_glossary##QDA:quadratic discriminant analysis}.

{phang}
{marker classtable}{...}
{bf:classification table}. 
A classification table, also known as a confusion matrix, gives the count of
observations from each group that are classified into each of the groups as
part of a discriminant analysis.  The element at (i,j) gives the number of
observations that belong to the {it:i}th group but were classified into the
{it:j}th group.  High counts are expected on the diagonal of the table where
observations are correctly classified, and small values are expected off the
diagonal.  The columns of the matrix are categories of the predicted
classification; the rows represent the actual group membership.

{phang}
{marker clanalysis}{...}
{bf:cluster analysis}.
Cluster analysis is a method for determining natural groupings or clusters of
observations.

{phang}
{bf:cluster tree}.
See {help mv_glossary##dendrogram:dendrogram}.

{phang}
{bf:clustering}.
See {help mv_glossary##clanalysis:cluster analysis}.

{phang}
{bf:common factors}.
Common factors are found by factor analysis.  They linearly reconstruct the
original variables.  In factor analysis, reconstruction is defined in terms of
prediction of the correlation matrix of the original variables.

{phang}
{marker communality}{...}
{bf:communality}.
Communality is the proportion of a variable's
variance explained by the common factors in factor analysis.  It is also
"1 - uniqueness".  Also see {help mv_glossary##uniqueness:uniqueness}.

{phang}
{bf:complete-linkage clustering}.
Complete-linkage clustering is a hierarchical clustering method that uses the
farthest pair of observations between two groups to determine the proximity
of the two groups.

{phang}
{bf:component scores}.
Component scores are calculated after PCA.  Component scores are the
coordinates of the original variables in the space of principal components.

{phang}
{bf:Comrey's tandem 1 and 2 rotations}.
{help mv glossary##C1967:Comrey (1967)} describes two
rotations, the first (tandem 1) to judge which "small" factors should be
dropped, the second (tandem 2) for "polishing".

{pmore}
Tandem principle 1 minimizes the criterion 

{phang3}
 c({bf:Lambda}) = < {bf:Lambda}^2, ({bf:LambdaLambda}')^2{bf:Lambda}^2>

{pmore}
Tandem principle 2 minimizes the criterion

{phang3}
 c({bf:Lambda}) = < {bf:Lambda}^2,
  {c -(}{bf:11}' - ({bf:LambdaLambda}')^2{c )-}{bf:Lambda}^2>

{pmore} See 
{help mv_glossary##CFrotate:Crawford-Ferguson rotation}
for a definition of {bf:Lambda}.

{phang}
{bf:configuration}.
The configuration in MDS is a representation in a low-dimensional
(usually 2-dimensional) space with distances in the low-dimensional space
approximating the dissimilarities or disparities in high-dimensional space.
Also see
{help mv_glossary##MDS:multidimensional scaling},
{help mv_glossary##dissimilarity:dissimilarity}, and
{help mv_glossary##disparity:disparity}.

{phang}
{marker configplot}{...}
{bf:configuration plot}.
A configuration plot after MDS is
a (usually 2-dimensional) plot of labeled points showing the low-dimensional
approximation to the dissimilarities or disparities in high-dimensional space.
Also see
{help mv_glossary##MDS:multidimensional scaling},
{help mv_glossary##dissimilarity:dissimilarity}, and
{help mv_glossary##disparity:disparity}.

{phang}
{bf:confusion matrix}.
A confusion matrix is a synonym for a
classification table after discriminant analysis.  See
{help mv_glossary##classtable:classification table}.

{phang}
{bf:contrast} or {bf:contrasts}.
In ANOVA, a contrast in
k population means is defined as a linear combination

{phang3}
delta = c_1 mu_1 + c_2 mu_2 + ... + c_k mu_k

{pmore}
where the coefficients satisfy

{phang3}
sum_{i=1}^k c_i = 0

{pmore}
In the multivariate setting (MANOVA), a contrast in k population mean
vectors is defined as

{phang3}
{bf:delta} = c_1 {bf:mu}_1 +c_2 {bf:mu}_2 + ... c_k {bf:mu}_k

{pmore}
where the coefficients again satisfy

{phang3}
sum_{i=1}^k c_i = 0

{pmore}
The univariate hypothesis delta = 0 may be tested with {cmd:contrast}
(or {cmd:test}) after ANOVA.
The multivariate hypothesis {bf:delta} = 0 may be tested with {cmd:manovatest}
after MANOVA.

{marker CA}{...}
{phang}
{bf:correspondence analysis}.
Correspondence analysis (CA) gives a geometric representation of the
rows and columns of a two-way frequency table.  The geometric representation is
helpful in understanding the similarities between the categories of variables
and associations between variables. CA is calculated by singular value
decomposition.  Also see 
{help mv_glossary##SVD:singular value decomposition}.

{phang}
{bf:correspondence analysis projection}.
A correspondence analysis projection is a line plot of the row and column
coordinates after CA.  The goal of this graph is to show the ordering
of row and column categories on each principal dimension of the analysis.  Each
principal dimension is represented by a vertical line; markers are plotted on
the lines where the row and column categories project onto the dimensions.
Also see {help mv_glossary##CA:correspondence analysis}.

{phang}
{bf:costs}.
Costs in discriminant analysis are the cost of misclassifying
observations.

{phang}
{bf:covarimin rotation}.
Covarimin rotation is an orthogonal
rotation equivalent to varimax.  Also see 
{help mv_glossary##varimaxrotation:varimax rotation}.

{phang}
{marker CFrotate}{...}
{bf:Crawford-Ferguson rotation}.
Crawford-Ferguson {help mv glossary##CF1970:(1970)} rotation
is a general oblique rotation with several interesting special cases.

{pmore}
Special cases of the Crawford-Ferguson rotation include

{p2colset 13 28 30 2}{...}
{p2col :kappa}Special case{p_end}
            {hline 36}
{p2col: 0}quartimax / quartimin{p_end}
{p2col: 1/p}varimax / covarimin{p_end}
{p2col: f/(2p)}equamax{p_end}
{p2col: (f-1)/(p+f-2)}parsimax{p_end}
{p2col: 1}factor parsimony{p_end}
            {hline 36}
{p 12 28 30 2}p = number of rows of {bf:A}.{p_end}
{p 12 28 30 2}f = number of columns of {bf:A}.{p_end}
{p2colreset}{...}

{pmore}
Where {bf:A} is the matrix to be rotated, {bf:T} is the rotation
and {bf:Lambda} = {bf:AT}.  The Crawford-Ferguson rotation
is achieved by minimizing the criterion

{phang3}
c({bf:Lambda}) = (1-kappa)/4 <{bf:Lambda}^2, {bf:Lambda}^2({bf:1 1}'
      - {bf:I})> + kappa/4 < {bf:Lambda}^2, ({bf:1 1}' -
        {bf:I}){bf:Lambda}^2>

{pmore}
Also see {help mv_glossary##obliquerotation:oblique rotation}.

{phang}
{marker crossedvars}{...}
{bf:crossed variables} or {bf:stacked variables}.
In CA
and MCA crossed categorical variables may be formed from the
interactions of two or more existing categorical variables.  Variables that
contain these interactions are called crossed or stacked variables.

{phang}
{marker crossingvars}{...}
{bf:crossing variables} or {bf:stacking variables}.
In CA and MCA, crossing or stacking variables are the existing
categorical variables whose interactions make up a crossed or stacked variable.

{phang}
{bf:curse of dimensionality}.
The curse of dimensionality is a term
coined by Richard {help mv glossary##B1961:Bellman (1961)}
to describe the problem caused by the
exponential increase in size associated with adding extra dimensions to a
mathematical space.  On the unit interval, 10 evenly spaced points suffice to
sample with no more distance than 0.1 between them; however a unit square
requires 100 points, and a unit cube requires 1000 points.  Many
multivariate statistical procedures suffer from the curse of dimensionality.
Adding variables to an analysis without adding sufficient observations can lead
to imprecision.

{phang}
{marker dendrogram}{...}
{bf:dendrogram} or {bf:cluster tree}.
A dendrogram or cluster tree
graphically presents information about how observations are grouped together at
various levels of (dis)similarity in hierarchical cluster analysis.  At the
bottom of the dendrogram, each observation is considered its own cluster.
Vertical lines extend up for each observation, and at various (dis)similarity
values, these lines are connected to the lines from other observations with a
horizontal line.  The observations continue to combine until, at the top of the
dendrogram, all observations are grouped together. Also see
{help mv_glossary##hiercl:hierarchical clustering}.

{phang}
{marker dilation}{...}
{bf:dilation}.
A dilation stretches or shrinks distances in Procrustes rotation.

{phang}
{bf:dimension}.
A dimension is a parameter or measurement required to define a characteristic
of an object or observation.  Dimensions are the variables in the dataset.
Weight, height, age, blood pressure, and drug dose are examples of dimensions in
health data.  Number of employees, gross income, net income, tax, and year are
examples of dimensions in data about companies.

{phang}
{marker discrim}{...}
{bf:discriminant analysis}.
Discriminant analysis is used to
describe the differences between groups and to exploit those differences when
allocating (classifying) observations of unknown group membership.
Discriminant analysis is also called classification in many references.

{phang}
{marker discrimfunction}{...}
{bf:discriminant function}.
Discriminant functions are formed from the eigenvectors from Fisher's approach
to LDA.  See {help mv_glossary##LDA:linear discriminant analysis}.
See {help mv_glossary##classfunction:classification function} for an
alternative.

{phang}
{bf:discriminating variables}.
Discriminating variables in a discriminant analysis are analyzed to determine
differences between groups where group membership is known.  These differences
between groups are then exploited when classifying observations to the groups.

{phang}
{marker disparity}{...}
{bf:disparity}.
Disparities are transformed dissimilarities, that is, dissimilarity values
transformed by some function.  The class of functions to transform
dissimilarities to disparities may either be (1) a class of metric, or known
functions such as linear functions or power functions that can be parameterized
by real scalars or (2) a class of more general (nonmetric) functions, such as
any monotonic function.  Disparities are used in MDS.  Also see
{help mv_glossary##dissimilarity:dissimilarity},
{help mv_glossary##MDS:multidimensional scaling},
{help mv_glossary##metricscaling:metric scaling}, and
{help mv_glossary##nonmetricscaling:nonmetric scaling}.

{phang}
{marker dissimilarity}{...}
{bf:dissimilarity}, {bf:dissimilarity matrix}, and {bf:dissimilarity measure}.
Dissimilarity or a dissimilarity measure is a quantification of the difference
between two things, such as observations or variables or groups of observations
or a method for quantifying that difference.  A dissimilarity matrix is a
matrix containing dissimilarity measurements.  Euclidean distance is one
example of a dissimilarity measure.  Contrast to
{help mv_glossary##similarity:similarity}.
Also see
{help mv_glossary##proximity:proximity} and
{help mv_glossary##Euclidean:Euclidean distance}.

{phang}
{marker divisivehier}{...}
{bf:divisive hierarchical clustering methods}.
Divisive
hierarchical clustering methods are top-down methods for hierarchical
clustering.  All the data begin as a part of one large cluster; with
each iteration, a cluster is broken into two to create two new clusters.
At the first iteration there are two clusters, then three, and so on.
Divisive methods are very computationally expensive.  Contrast to 
{help mv_glossary##agglohier:agglomerative hierarchical clustering methods}.

{phang}
{bf:eigenvalue}.
An eigenvalue is the scale factor by which an
eigenvector is multiplied.  For many multivariate techniques, the size of an
eigenvalue indicates the importance of the corresponding eigenvector.
Also see eigenvector.

{phang}
{marker eigenvector}{...}
{bf:eigenvector}.
An eigenvector of a linear transformation is a nonzero vector that is either
left unaffected or simply multiplied by a scale factor after the
transformation.

{pmore}
Here {bf:x} is an eigenvector of linear transformation {bf:A} with
eigenvalue lambda:

{phang3}
{bf:A}{bf:x} = lambda {bf:x}

{pmore}
For many multivariate techniques, eigenvectors form the basis for analysis and
interpretation.  Also see 
{help mv_glossary##loading:loading}.

{phang}
{bf:equamax rotation}.
Equamax rotation is an orthogonal rotation
whose criterion is a weighted sum of the varimax and quartimax criteria.
Equamax reflects a concern for simple structure within the rows and columns
of the matrix.  It is equivalent to oblimin with
gamma = p/2, or to the Crawford-Ferguson family with kappa = f/2p, where
p is the number of rows of the matrix to be rotated, and f is the number of
columns.  Also see 
{help mv_glossary##orthorotation:orthogonal rotation}, 
{help mv_glossary##varimaxrotation:varimax rotation},
{help mv_glossary##quartimaxrotation:quartimax rotation},
{help mv_glossary##obliminrotation:oblimin rotation}, and
{help mv_glossary##CFrotate:Crawford-Ferguson rotation}.

{phang}
{marker Euclidean}{...}
{bf:Euclidean distance}.
The Euclidean distance between two
observations is the distance one would measure with a ruler.  The distance
between vector {bf:P} = (P_1, P_2, ..., P_n) and
{bf:Q} = (Q_1, Q_2, ..., Q_n)
is given by

{phang3}
D({bf:P}, {bf:Q}) = sqrt{(P_1 - Q_1)^2 + (P_2 - Q_2)^2 + ... + (P_n - Q_n)^2}
 = sqrt{sum_{i=1}^n (P_i - Q_i)^2}

{phang}
{bf:factor}.
A factor is an unobserved random variable that is thought to explain
variability among observed random variables.

{phang}
{marker factoranalysis}{...}
{bf:factor analysis}.
Factor analysis is a statistical technique
used to explain variability among observed random variables in terms of fewer
unobserved random variables called factors.  The observed variables are then
linear combinations of the factors plus error terms.

{pmore} If the correlation matrix of the observed variables is {bf:R}, then
{bf:R} is decomposed by factor analysis as

{phang3}
{bf:R} = {bf:Lambda Phi Lambda}' + {bf:Psi}

{pmore}
{bf:Lambda} is the loading matrix, and {bf:Psi} contains the specific
variances, for example, the variance specific to the variable not explained by
the factors.  The default unrotated form assumes uncorrelated common factors,
{bf:Phi} = {bf:I}.

{phang}
{bf:factor loading plot}.
A factor loading plot produces a scatter
plot of the factor loadings after factor analysis.

{phang}
{bf:factor loadings}.
Factor loadings are the regression
coefficients which multiply the factors to produce the observed variables in
the factor analysis.

{phang}
{bf:factor parsimony}.
Factor parsimony is an oblique rotation,
which maximizes the column simplicity of the matrix.  It is equivalent to a
Crawford-Ferguson rotation with kappa = 1.  Also see
{help mv_glossary##obliquerotation:oblique rotation} and 
{help mv_glossary##CFrotate:Crawford-Ferguson rotation}.

{phang}
{bf:factor scores}.
Factor scores are computed after factor
analysis.  Factor scores are the coordinates of the original variables, {bf:x},
in the space of the factors.  The two types of scoring are regression scoring
({help mv glossary##T1951:Thomson 1951}) and Bartlett
({help mv glossary##B1937:1937},
 {help mv glossary##B1938:1938}) scoring.

{pmore} Using the symbols defined in 
{help mv_glossary##factoranalysis:factor analysis},
the formula for regression scoring is 

{phang3}
{bf:f}[hat] = {bf:Lambda}'{bf:R}^{-1}{bf:x}

{pmore}
In the case of oblique rotation the formula becomes

{phang3}
{bf:f}[hat] = {bf:Phi Lambda}'{bf:R}^{-1}{bf:x}

{pmore} The formula for Bartlett scoring is

{phang3}
{bf:f}[hat] = {bf:Gamma}^{-1}{bf:Lambda}'{bf:Psi}^{-1}{bf:x}

{pmore}
where 

{phang3}
{bf:Gamma} = {bf:Lambda}'{bf:Psi}^{-1}{bf:Lambda}

{pmore} Also see 
{help mv_glossary##factoranalysis:factor analysis}.

{phang}
{marker Heywood}{...}
{bf:Heywood case}  or {bf:Heywood solution}.
A Heywood case can appear in factor analysis output; this indicates that
a boundary solution, called a Heywood solution, was produced.  The geometric
assumptions underlying the likelihood-ratio test are violated, though the
test may be useful if interpreted cautiously.

{phang}
{marker hiercl}{...}
{bf:hierarchical clustering} and {bf:hierarchical clustering methods}.
In hierarchical clustering, the data are placed into clusters via
iterative steps. Contrast to 
{help mv_glossary##partitioncl:partition clustering}.  Also see
{help mv_glossary##agglohier:agglomerative hierarchical clustering methods}
and
{help mv_glossary##divisivehier:divisive hierarchical clustering methods}.

{phang}
{bf:Hotelling's T-squared generalized means test}.
Hotelling's T-squared generalized means test is a multivariate test that
reduces to a standard t test if only one variable is specified.  It tests
whether one set of means is zero or if two sets of means are equal.

{phang}
{bf:inertia}.
In CA, the inertia is related to the
definition in applied mathematics of "moment of inertia", which is the
integral of the mass times the squared distance to the centroid.  Inertia is
defined as the total Pearson chi-squared for the two-way table divided by the
total number of observations, or the sum of the squared singular values found
in the singular value decomposition.

{phang3}
total inertia = 1/n chi^2 = sum_k lambda^2_k

{pmore}
In MCA, the inertia is defined analogously.  In the case of the
indicator or Burt matrix approach, it is given by the formula

{phang3}
total inertia = (q/q-1) sum phi_t^2 - (J-q)/q^2

{pmore}
where q is the number of active variables, J is the number of
categories and phi_t is the {it:t}th (unadjusted) eigenvalue of the eigen
decomposition.  In JCA the total inertia of the modified Burt
matrix is defined as the sum of the inertias of the off-diagonal blocks.
Also see 
{help mv_glossary##CA:correspondence analysis} and
{help mv_glossary##MCA:multiple correspondence analysis}.

{phang}
{bf:iterated principal-factor method}.
The iterated principal-factor method is a method for performing factor analysis
in which  the communalities {h}_i^2[hat] are estimated iteratively from the
loadings in {bf:Lambda}[hat] using

{phang3}
h_i^2[hat] = sum_{j=1}^m lambda_{ij}^2[hat]

{pmore}
Also see 
{help mv_glossary##factoranalysis:factor analysis} and
{help mv_glossary##communality:communality}.

{phang}
{bf:JCA}.
An acronym for joint correspondence analysis; see
{help mv_glossary##MCA:multiple correspondence analysis}.

{phang}
{bf:joint correspondence analysis}.
See {help mv_glossary##MCA:multiple correspondence analysis}.

{phang}
{marker KMO}{...}
{bf:Kaiser-Meyer-Olkin measure of sampling adequacy}.
The Kaiser-Meyer-Olkin (KMO) measure of
sampling adequacy takes values between 0 and 1, with small values meaning that
the variables have too little in common to warrant a factor analysis or
PCA.  Historically, the following labels have been given to values of
KMO ({help mv glossary##K1974:Kaiser 1974}):

{p2colset 13 28 30 2}{...}
{p2col: 0.00 to 0.49}    unacceptable{p_end}
{p2col: 0.50 to 0.59}    miserable{p_end}
{p2col: 0.60 to 0.69}    mediocre{p_end}
{p2col: 0.70 to 0.79}    middling{p_end}
{p2col: 0.80 to 0.89}    meritorious{p_end}
{p2col: 0.90 to 1.00}    marvelous{p_end}
{p2colreset}{...}

{phang}
{marker kmeans}{...}
{bf:kmeans}.
Kmeans is a method for performing partition cluster
analysis.  The user specifies the number of clusters, k, to create using an
iterative process.  Each observation is assigned to the group whose mean is
closest, and then based on that categorization, new group means are determined.
These steps continue until no observations change groups.  The algorithm begins
with k seed values, which act as the k group means.  There are many ways to
specify the beginning seed values.  Also see
{help mv_glossary##partitioncl:partition clustering}.

{phang}
{marker kmedians}{...}
{bf:kmedians}.
Kmedians is a variation of kmeans.  The same process
is performed, except that medians instead of means are computed to represent
the group centers at each step.  Also see
{help mv_glossary##kmeans:kmeans} and
{help mv_glossary##partitioncl:partition clustering}.

{phang}
{bf:KMO}.
See {help mv_glossary##KMO:Kaiser-Meyer-Olkin measure of sampling adequacy}.

{phang}
{bf:KNN}.
See {help mv_glossary##KNN:kth nearest neighbor}.

{phang}
{marker Kruskalstress}{...}
{bf:Kruskal stress}.
The Kruskal stress measure
({help mv glossary##K1964:Kruskal 1964};
{help mv glossary##CC2001:Cox and Cox 2001, 63})
used in MDS is given by

{phang3}
Kruskal({bf:D}[hat],{bf:E}) = {c -(}(sum (E_{ij} - D_{ij})^2[hat])/sum E_{ij}^2{c )-}^{1/2}

{pmore}
where D_{ij} is the dissimilarity between objects i and j,
1 {ul:<} i,j {ul:<} n, and D_{ij}[hat} is the disparity, that is, the
transformed dissimilarity, and E_{ij} is the Euclidean distance between
rows i and j of the matching
configuration.  Kruskal stress is an example of a loss function in modern
MDS.  After classical MDS, {bf:estat stress} gives the Kruskal
stress.  Also see 
{help mv_glossary##classscaling:classical scaling},
{help mv_glossary##MDS:multidimensional scaling}, and
{help mv_glossary##stress:stress}.

{phang}
{marker KNN}{...}
{bf:kth nearest neighbor}.
{it:k}th-nearest-neighbor (KNN)
discriminant analysis is a nonparametric discrimination method based on the k
nearest neighbors of each observation.  Both continuous and binary data can be
handled through the different similarity and dissimilarity measures.  
KNN analysis can distinguish irregular-shaped groups, including groups with
multiple modes.  Also see {help mv_glossary##discrim:discriminant analysis}
and {help mv_glossary##nonparametricmethods:nonparametric methods}.

{phang}
{marker Lawley}{...}
{bf:Lawley-Hotelling trace}.
The Lawley-Hotelling
trace is a test statistic for the hypothesis test H_0: {bf:mu}_1 = {bf:mu}_2 =
... = {bf:mu}_k based on the eigenvalues lambda_1, lambda_2, ...,
lambda_s of {bf:E}^{-1}{bf:H}.  It is defined as

{phang3}
U^{(s)} = trace({bf:E}^{-1}{bf:H}) = sum_{i=1}^s lambda_i

{pmore} where {bf:H} is
the between matrix and {bf:E} is the within matrix, see
{help mv_glossary##betweenmatrix:between matrix}.

{phang}
{bf:LDA}.
See {help mv_glossary##LDA:linear discriminant analysis}.

{phang}
{marker LOO}{...}
{bf:leave one out}.
In discriminant analysis, classification of an observation while leaving it out
of the estimation sample is done to check the robustness of the analysis; thus
the phrase "leave one out" (LOO).  Also see
{help mv_glossary##discrim:discriminant analysis}.

{phang}
{marker LDA}{...}
{bf:linear discriminant analysis}.
Linear discriminant analysis (LDA) is a parametric form of discriminant
analysis.  In Fisher's ({help mv glossary##F1936:1936}) approach to LDA,
linear combinations of the discriminating variables provide maximal
separation between the groups.  The 
{help mv glossary##M1936:Mahalanobis (1936)} formulation of
LDA assumes that the observations come from multivariate normal
distributions with equal covariance matrices.    Also see
{help mv_glossary##discrim:discriminant analysis} and
{help mv_glossary##parametricmethods:parametric methods}.

{phang}
{bf:linkage}.
In cluster analysis, the linkage refers to the measure of proximity between
groups or clusters.

{phang}
{marker loading}{...}
{bf:loading}.
A loading is a coefficient or weight in a linear transformation.  Loadings play
an important role in many multivariate techniques, including factor analysis,
PCA, MANOVA, LDA, and canonical correlations.  In some
settings, the loadings are of primary interest and are examined for
interpretability.  For many multivariate techniques, loadings are based on an
eigenanalysis of a correlation or covariance matrix.  Also see
{help mv_glossary##eigenvector:eigenvector}.

{phang}
{bf:loading plot}.
A loading plot is a scatter plot of the loadings after LDA, factor
analysis or PCA.

{phang}
{bf:logistic discriminant analysis}.
Logistic discriminant analysis
is a form of discriminant analysis based on the assumption that the
likelihood ratios of the groups have an exponential form.  Multinomial logistic
regression provides the basis for logistic discriminant analysis.  Because
multinomial logistic regression can handle binary and continuous regressors,
logistic discriminant analysis is also appropriate for binary and continuous
discriminating variables.  Also see
{help mv_glossary##discrim:discriminant analysis}.

{phang}
{bf:LOO}.
See {help mv_glossary##LOO:leave one out}.

{phang}
{marker loss}{...}
{bf:loss}.
Modern MDS is performed by minimizing a loss
function, also called a loss criterion.  The loss quantifies the difference 
between the disparities and the Euclidean distances. 

{pmore}
Loss functions include Kruskal's stress and its square, both
normalized with either disparities or distances, the strain criterion which is
equivalent to classical metric scaling when the disparities equal the
dissimilarities, and the {help mv glossary##S1969:Sammon (1969)}
mapping criterion 
which is the sum of the scaled, squared differences between the
distances and the disparities, normalized by the sum of the disparities.

{pmore}
Also see
{help mv_glossary##MDS:multidimensional scaling},
{help mv_glossary##Kruskalstress:Kruskal stress}, 
{help mv_glossary##classscaling:classical scaling}, and
{help mv_glossary##disparity:disparity}.

{phang}
{bf:Mahalanobis distance}.
The Mahalanobis distance measure is a scale-invariant way of measuring
distance.  It takes into account the correlations of the dataset.

{phang}
{bf:Mahalanobis transformation}.
The Mahalanobis transformation
takes a Cholesky factorization of the inverse of the covariance matrix
{bf:S}^{-1} in the formula for Mahalanobis distance and uses it to transform
the data.  If we have the Cholesky factorization {bf:S}^{-1} = {bf:L}'{bf:L},
then the Mahalanobis transformation of {bf:x} is {bf:z} = {bf:Lx}, and
{bf:z}'{bf:z} = D_{M}^2({bf:x}).

{phang}
{bf:MANCOVA}.
MANCOVA is multivariate analysis of covariance.  See 
{help mv_glossary##MANOVA:multivariate analysis of variance}.

{phang}
{bf:MANOVA}.
{help mv_glossary##MANOVA:multivariate analysis of variance}.

{phang}
{bf:mass}.
In CA and MCA, the mass is the marginal probability.  The sum
of the mass over the active row or column categories equals 1.

{phang}
{marker matchcoef}{...}
{bf:matching coefficient}.
The matching similarity coefficient is
used to compare two binary variables.   If a is the number of observations
that both have value 1, and d is the number of observations that both have
value 0, and b, c are the number of (1,0) and (0,1) observations,
respectively, then the matching coefficient is given by

{phang3}
(a + d)/(a+b+c+d)  Also see
{help mv_glossary##similarity:similarity measure}.

{phang}
{bf:matching configuration}.
In MDS, the matching
configuration is the low dimensional configuration whose distances approximate
the high-dimensional dissimilarities or disparities.  Also see
{help mv_glossary##MDS:multidimensional scaling},
{help mv_glossary##dissimilarity:dissimilarity}, and 
{help mv_glossary##disparity:disparity}.

{phang}
{bf:matching configuration plot}.
After MDS, this is a scatter plot of the matching configuration.

{phang}
{bf:maximum likelihood factor method}.
The maximum likelihood factor method is a method for performing factor analysis
that assumes multivariate normal observations.  It maximizes the determinant of
the partial correlation matrix; thus, this solution is also meaningful as a
descriptive method for nonnormal data.  Also see 
{help mv_glossary##factoranalysis:factor analysis}.

{phang}
{bf:MCA}.
See {help mv_glossary##MCA:multiple correspondence analysis}.

{phang}
{bf:MDS}.
See {help mv_glossary##MDS:multidimensional scaling}.

{phang}
{bf:MDS configuration plot}.
See {help mv_glossary##configplot:configuration plot}.

{phang}
{bf:measure}.
A measure is a quantity representing the proximity
between objects or method for determining the proximity between objects.
Also see {help mv_glossary##proximity:proximity}.

{phang}
{bf:median-linkage clustering}.
Median-linkage clustering is a hierarchical clustering method that uses the
distance between the medians of two groups to determine the similarity or
dissimilarity of the two groups.  Also see 
{help mv_glossary##clanalysis:cluster analysis} and
{help mv_glossary##agglohier:agglomerative hierarchical clustering methods}.

{phang}
{marker metricscaling}{...}
{bf:metric scaling}.
Metric scaling is a type of MDS, in
which the dissimilarities are transformed to disparities via a class of known
functions.  This is contrasted to 
{help mv_glossary##nonmetricscaling:nonmetric scaling}.  Also see 
{help mv_glossary##MDS:multidimensional scaling}.

{phang}
{bf:minimum entropy rotation}.
The minimum entropy rotation is an
orthogonal rotation achieved by minimizing the deviation from uniformity
(entropy).  The minimum entropy criterion 
({help mv glossary##J2004:Jennrich 2004}) is

{phang3}
c({bf:Lambda}) = - 1/2 <{bf:Lambda}^2, log {bf:Lambda}^2>

{pmore} See 
{help mv_glossary##CFrotate:Crawford-Ferguson rotation}
for a definition of {bf:Lambda}.  Also see
{help mv_glossary##orthorotation:orthogonal rotation}.

{phang}
{bf:misclassification rate}.
The misclassification rate calculated after discriminant analysis is, in its
simplest form, the fraction of observations incorrectly classified. See
{help mv_glossary##discrim:discriminant analysis}.

{phang}
{marker modernscaling}{...}
{bf:modern scaling}.
Modern scaling is a form of MDS that
is achieved via the minimization of a loss function that compares the
disparities (transformed dissimilarities) in the higher-dimensional space and
the distances in the lower-dimensional space.  Contrast to
{help mv_glossary##classscaling:classical scaling}.  Also see  
{help mv_glossary##dissimilarity:dissimilarity},
{help mv_glossary##disparity:disparity},
{help mv_glossary##MDS:multidimensional scaling}, and
{help mv_glossary##loss:loss}. 

{phang}
{marker MDS}{...}
{bf:multidimensional scaling}.
Multidimensional scaling (MDS) is a dimension-reduction and visualization
technique.  Dissimilarities (for instance, Euclidean distances) between
observations in a high-dimensional space are represented in a lower-dimensional
space which is typically two dimensions so that the Euclidean distance in the
lower-dimensional space approximates in some sense the dissimilarities in the
higher-dimensional space.  Often the higher-dimensional dissimilarities are
first transformed to disparities, and the disparities are then approximated by
the distances in the lower-dimensional space.  Also see 
{help mv_glossary##dissimilarity:dissimilarity},
{help mv_glossary##disparity:disparity},
{help mv_glossary##classscaling:classical scaling},
{help mv_glossary##loss:loss}, 
{help mv_glossary##modernscaling:modern scaling},
{help mv_glossary##metricscaling:metric scaling}, and
{help mv_glossary##nonmetricscaling:nonmetric scaling}.

{phang}
{marker MCA}{...}
{bf:multiple correspondence analysis}.
Multiple correspondence analysis (MCA) and joint correspondence
analysis (JCA) are methods for analyzing observations on categorical
variables.  MCA and JCA analyze a multiway table and are
usually viewed as an extension of CA.  Also see 
{help mv_glossary##CA:correspondence analysis}.

{phang}
{bf:multivariate analysis of covariance}.
See {help mv_glossary##MANOVA:multivariate analysis of variance}.

{phang}
{marker MANOVA}{...}
{bf:multivariate analysis of variance}.
Multivariate analysis of variance (MANOVA)
is used to test hypotheses about means.  Four multivariate statistics are
commonly computed in MANOVA: Wilks's lambda, Pillai's trace,
Lawley-Hotelling trace, and Roy's largest root.  Also see
{help mv_glossary##Wilk:Wilks's lambda},
{help mv_glossary##Pillai:Pillai's trace},
{help mv_glossary##Lawley:Lawley-Hotelling trace}, and
{help mv_glossary##Roy:Roy's largest root}.

{phang}
{marker mvregression}{...}
{bf:multivariate regression}.
Multivariate regression is a method
of estimating a linear (matrix) model

{phang3}
{bf:Y} = {bf:X}{bf:B} + {bf:Xi}
Multivariate regression is estimated by least-squares regression, and it can be
used to test hypotheses, much like MANOVA.

{phang}
{bf:nearest neighbor}.
See {help mv_glossary##KNN:kth nearest neighbor}.

{phang}
{marker nonmetricscaling}{...}
{bf:nonmetric scaling}.
Nonmetric scaling is a type of modern
MDS in which the dissimilarities may be transformed to
disparities via any monotonic function as opposed to a class of known
functions.  Contrast to
{help mv_glossary##metricscaling:metric scaling}.  Also see
{help mv_glossary##MDS:multidimensional scaling},
{help mv_glossary##dissimilarity:dissimilarity},
{help mv_glossary##disparity:disparity},
and 
{help mv_glossary##modernscaling:modern scaling}.

{phang}
{marker nonparametricmethods}{...}
{bf:nonparametric methods}.
Nonparametric statistical methods,
such as KNN discriminant analysis, do not assume the
population fits any parameterized distribution.

{phang}
{bf:normalization}.
Normalization presents information in a standard form for interpretation.  In
CA the row and column coordinates can be normalized in different ways
depending on how one wishes to interpret the data.  Normalization is also used
in rotation, MDS, and MCA.

{phang}
{marker oblimaxrotation}{...}
{bf:oblimax rotation}.
Oblimax rotation is a method for oblique rotation which maximizes the number of
high and low loadings.  When restricted to orthogonal rotation, oblimax is
equivalent to quartimax rotation.  Oblimax minimizes the oblimax criterion

{phang3}
c({bf:Lambda}) = - log(<{bf:Lambda}^2, {bf:Lambda}^2>) + 2
      log(<{bf:Lambda}, {bf:Lambda}>)

{pmore}
See 
{help mv_glossary##CFrotate:Crawford-Ferguson rotation}
for a definition of {bf:Lambda}.  Also see
{help mv_glossary##obliquerotation:oblique rotation},
{help mv_glossary##orthorotation:orthogonal rotation}, and
{help mv_glossary##quartimaxrotation:quartimax rotation}.

{phang}
{marker obliminrotation}{...}
{bf:oblimin rotation}.
Oblimin rotation is a general method for oblique rotation, achieved by
minimizing the oblimin criterion

{phang3}
c({bf:Lambda}) = 1/4 <{bf:Lambda}^2, {c -(}{bf:I} - (gamma/p) {bf:1 1}'{c )-}
    {bf:Lambda}^2({bf:1 1}' - {bf:I})>

{pmore}
Oblimin has several interesting special cases:

{p2colset 13 28 30 2}{...}
{p2col: gamma}Special case{p_end}
           {hline 41}
{p2col: 0}quartimax / quartimin{p_end}
{p2col: 1/2}biquartimax / biquartimin{p_end}
{p2col: 1}varimax / covarimin{p_end}
{p2col: p/2}equamax{p_end}
           {hline 41}
{p 12 28 30 2}p = number of rows of {bf:A}.{p_end}
{p2colreset}{...}

{pmore}
See
{help mv_glossary##CFrotate:Crawford-Ferguson rotation}
for a definition of {bf:Lambda} and {bf:A}.  Also see
{help mv_glossary##obliquerotation:oblique rotation}.

{phang}
{marker obliquerotation}{...}
{bf:oblique rotation} or {bf:oblique transformation}.
An oblique rotation maintains the norms of the rows of the matrix but
not their inner products.  In geometric terms, this maintains the lengths
of vectors, but not the angles between them.  In contrast, in orthogonal
rotation, both are preserved.

{phang}
{bf:ordination}.
Ordination is the ordering of a set of data points
with respect to one or more axes.  MDS is a form of
ordination.

{phang}
{marker orthorotation}{...}
{bf:orthogonal rotation} or {bf:orthogonal transformation}.
Orthogonal rotation maintains both the norms of the rows of the matrix and also
inner products of the rows of the matrix.  In geometric terms, this maintains
both the lengths of vectors and the angles between them.  In contrast, oblique
rotation maintains only the norms, that is, the lengths of vectors.

{phang}
{marker parametricmethods}{...}
{bf:parametric methods}.
Parametric statistical methods, such as LDA and QDA, assume the
population fits a parameterized distribution.  For example, for LDA
we assume the groups are multivariate normal with equal covariance matrices.

{phang}
{bf:parsimax rotation}.
Parsimax rotation is an orthogonal rotation that balances complexity between
the rows and the columns.  It is equivalent to the Crawford-Ferguson
family with kappa = (f-1)/(p+f -2), where p is the number of rows of the
original matrix, and f is the number of columns.  See 
{help mv_glossary##orthorotation:orthogonal rotation} and 
{help mv_glossary##CFrotate:Crawford-Ferguson rotation}.

{phang}
{bf:partially specified target rotation}.  Partially specified target rotation
minimizes the criterion

{phang3}
c({bf:Lambda}) = |{bf:W} otimes ({bf:Lambda} - {bf:H})|^2

{pmore}
for a given target matrix {bf:H} and a
nonnegative weighting matrix {bf:W} (usually zero-one valued).
See 
{help mv_glossary##CFrotate:Crawford-Ferguson rotation}
for a definition of {bf:Lambda}.

{marker partitioncl}{...}
{phang}
{bf:partition clustering} and {bf:partition cluster-analysis methods}.
Partition clustering methods break the observations into a distinct
number of nonoverlapping groups.  This is accomplished in one step, unlike
hierarchical cluster-analysis methods, in which an iterative procedure is used.
Consequently, this method is quicker and will allow larger datasets than the
hierarchical clustering methods.  Contrast to
{help mv_glossary##hiercl:hierarchical clustering}.
Also see
{help mv_glossary##kmeans:kmeans} and
{help mv_glossary##kmedians:kmedians}.

{phang}
{bf:PCA}.
See {help mv_glossary##PCA:principal component analysis}.

{phang}
{marker Pillai}{...}
{bf:Pillai's trace}.
Pillai's trace is a test statistic for the
hypothesis test H_0: {bf:mu}_1 = {bf:mu}_2 = ... = {bf:mu}_k based on the
eigenvalues lambda_1, ..., lambda_s of {bf:E}^{-1}{bf:H}.  It is
defined as

{phang3}
V^{(s)} = trace[({bf:E} + {bf:H})^{-1}{bf:H}] =
      sum_{i=1}^s lambda_i/(1 + lambda_i)

{pmore} where {bf:H} is the between matrix and {bf:E} is the within
matrix.  See 
{help mv_glossary##betweenmatrix:between matrix}.

{phang}
{marker posteriorprob}{...}
{bf:posterior probabilities}.
After discriminant analysis, the posterior probabilities are the probabilities
of a given observation being assigned to each of the groups based on the prior
probabilities, the training data, and the particular discriminant model.
Contrast to {help mv_glossary##priorprob:prior probabilities}.

{phang}
{marker PCA}{...}
{bf:principal component analysis}.
Principal component analysis
(PCA) is a statistical technique used for data reduction.  The leading
eigenvectors from the eigen decomposition of the correlation or the covariance
matrix of the variables describe a series of uncorrelated linear combinations
of the variables that contain most of the variance.  In addition to data
reduction, the eigenvectors from a PCA are often inspected to learn
more about the underlying structure of the data.

{phang}
{bf:principal factor method}.
The principal factor method is a method for factor analysis in which the factor
loadings, sometimes called factor patterns, are computed using the squared
multiple correlations as estimates of the communality.  Also see
{help mv_glossary##factoranalysis:factor analysis} and
{help mv_glossary##communality:communality}.

{phang}
{marker priorprob}{...}
{bf:prior probabilities}
Prior probabilities in discriminant analysis are the probabilities of an
observation belonging to a group before the discriminant analysis is
performed.  Prior probabilities are often based on the prevalence of the groups
in the population as a whole.  Contrast to
{help mv_glossary##posteriorprob:posterior probabilities}.

{phang}
{bf:Procrustes rotation}.
A Procrustes rotation is an orthogonal or oblique transformation, that is, a
restricted Procrustes transformation without translation or dilation (uniform
scaling).

{phang}
{marker Procrustestransform}{...}
{bf:Procrustes transformation}.
The goal of Procrustes transformation is to transform the source matrix {bf:X}
to be as close as possible to the target {bf:Y}.  The permitted
transformations are any combination of dilation (uniform scaling), rotation and
reflection (that is, orthogonal or oblique transformations), and translation.
Closeness is measured by residual sum of squares.  In some cases, unrestricted
Procrustes transformation is desired; this allows the data to be transformed
not just by orthogonal or oblique rotations, but by all conformable regular
matrices {bf:A}.  Unrestricted Procrustes transformation is equivalent to a
multivariate regression.  

{pmore}
The name comes from
Procrustes of Greek mythology; Procrustes invited guests to try his 
iron bed.  If the guest was too tall for the bed, Procrustes would amputate the
guest's feet, and if the guest was too short, he would stretch the guest out
on a rack.

{pmore}
Also see
{help mv_glossary##orthorotation:orthogonal rotation},
{help mv_glossary##obliquerotation:oblique rotation},
{help mv_glossary##dilation:dilation}, and
{help mv_glossary##mvregression:multivariate regression}.

{phang}
{bf:promax power rotation}.
Promax power rotation is an oblique
rotation.  It does not fit in the minimizing-a-criterion
framework that is at the core of most other rotations.  The promax method
({help mv glossary##HW1964:Hendrickson and White 1964})
was proposed before computing power became widely
available.  The promax rotation consists of three steps:

{phang3}
1.  Perform an orthogonal rotation.

{phang3}
2. Raise the elements of the rotated matrix to some power,
preserving the sign of the elements.  Typically the power is in the range
2 {ul:<} power {ul:<} 4.  This operation is meant to distinguish clearly
between small and large values.

{phang3}
3. The matrix from step two is used as the target for an oblique
Procrustean rotation from the original matrix.

{phang}
{marker proximity}{...}
{bf:proximity}, {bf:proximity matrix}, and {bf:proximity measure}.
Proximity or a proximity measure means the nearness or farness of two things,
such as observations or variables or groups of observations or a method for
quantifying the nearness or farness between two things.  A proximity is
measured by a similarity or dissimilarity.  A proximity matrix is a matrix of
proximities.  Also see 
{help mv_glossary##similarity:similarity} and
{help mv_glossary##dissimilarity:dissimilarity}.

{phang}
{bf:QDA}.
See {help mv_glossary##QDA:quadratic discriminant analysis}.

{phang}
{marker QDA}{...}
{bf:quadratic discriminant analysis}.
Quadratic discriminant analysis (QDA) is a parametric form of discriminant
analysis and is a generalization of LDA.  Like LDA, QDA assumes that the
observations come from a multivariate normal distribution, but unlike LDA, the
groups are not assumed to have equal covariance matrices.  Also see 
{help mv_glossary##discrim:discriminant analysis}, 
{help mv_glossary##LDA:linear discriminant analysis},  and
{help mv_glossary##parametricmethods:parametric methods}.

{phang}
{marker quartimaxrotation}{...}
{bf:quartimax rotation}.
Quartimax rotation maximizes the variance
of the squared loadings within the rows of the matrix.  It is an orthogonal
rotation that is equivalent to minimizing the criterion

{phang3}
c({bf:Lambda}) = sum_i sum_r lambda^4_{ir} = -1/4
       <{bf:Lambda}^2, {bf:Lambda}^2>

{pmore} See 
{help mv_glossary##CFrotate:Crawford-Ferguson rotation}
for a definition of {bf:Lambda}.

{phang}
{bf:quartimin rotation}.
Quartimin rotation is an oblique rotation that is equivalent to quartimax
rotation when quartimin is restricted to orthogonal rotations.  Quartimin is
equivalent to oblimin rotation with gamma = 0.  Also see
{help mv_glossary##quartimaxrotation:quartimax rotation},
{help mv_glossary##obliquerotation:oblique rotation},
{help mv_glossary##orthorotation:orthogonal rotation}, and
{help mv_glossary##obliminrotation:oblimin rotation}.

{phang}
{bf:reflection}.
A reflection is an orientation reversing
orthogonal transformation, that is, a transformation that involves negating
coordinates in one or more dimensions.  A reflection is a Procrustes
transformation.

{phang}
{marker repeatmeasures}{...}
{bf:repeated measures}.
Repeated measures data have repeated measurements for the subjects over some
dimension, such as time -- for example test scores at the start, midway,
and end of the class.  The repeated observations are typically not independent.
Repeated-measures ANOVA is one approach for analyzing repeated measures
data, and MANOVA is another.  Also see 
{help mv_glossary##sphericity:sphericity}.

{phang}
{bf:rotation}.
A rotation is an orientation preserving orthogonal
transformation.  A rotation is a Procrustes transformation.

{phang}
{marker Roy}{...}
{bf:Roy's largest root}.
Roy's largest root test is a test
statistic for the hypothesis test H_0: {bf:mu}_1 = ... = {bf:mu}_k based on the
largest eigenvalue of {bf:E}^{-1}{bf:H}.  It is defined as

{phang3}
theta =  lambda_1/(1+lambda_1)


{pmore}
Here {bf:H} is the between matrix, and {bf:E} is the within matrix. See 
{help mv_glossary##betweenmatrix:between matrix}.

{phang}
{bf:Sammon mapping criterion}.
The {help mv glossary##S1969:Sammon (1969)} mapping criterion is a loss
criterion used with 
MDS; it is the sum of the scaled, squared differences between the distances
and the disparities, normalized by the sum of the disparities.  Also see 
{help mv_glossary##MDS:multidimensional scaling}, 
{help mv_glossary##modernscaling:modern scaling},
and
{help mv_glossary##loss:loss}. 

{phang}
{bf:score}.
A score for an observation after factor analysis, PCA, or LDA
is derived from a column of the loading matrix and is obtained as the linear
combination of that observation's data by using the coefficients found in the
loading.

{phang}
{bf:score plot}.
A score plot produces scatterplots of the score variables after factor
analysis, PCA, or LDA.

{phang}
{bf:scree plot}.
A scree plot is a plot of eigenvalues or singular values ordered from greatest
to least after an eigen decomposition or singular value decomposition.  Scree
plots help determine the number of factors or components in an eigen analysis.
Scree is the accumulation of loose stones or rocky debris lying on a slope or
at the base of a hill or cliff; this plot is called a scree plot because it
looks like a scree slope.  The goal is to determine the point where the
mountain gives way to the fallen rock.

{phang}
{bf:Shepard diagram}.
A Shepard diagram after MDS is a 2-dimensional plot
of high-dimensional dissimilarities or disparities versus the resulting
low-dimensional distances.  Also see 
{help mv_glossary##MDS:multidimensional scaling}.

{phang}
{marker similarity}{...}
{bf:similarity}, {bf:similarity matrix}, and {bf:similarity measure}.
A similarity or a similarity measure is a quantification of how alike two
things are, such as observations or variables or groups of observations, or a
method for quantifying that alikeness.  A similarity matrix is a matrix
containing similarity measurements.  The matching coefficient is one example
of a similarity measure.  Contrast to 
{help mv_glossary##dissimilarity:dissimilarity}.
Also see
{help mv_glossary##proximity:proximity} and
{help mv_glossary##matchcoef:matching coefficient}.

{phang}
{bf:single-linkage clustering}.
Single-linkage clustering is a hierarchical clustering method that computes the
proximity between two groups as the proximity between the closest pair of
observations between the two groups.

{phang}
{marker SVD}{...}
{bf:singular value decomposition}.
A singular value decomposition
(SVD) is a factorization of a rectangular matrix.  It says that if
{bf:M} is an m*n matrix, there exists a factorization of the form

{phang3}
{bf:M} = {bf:U Sigma V}^*

{pmore}
where {bf:U} is an m*m unitary matrix, {bf:Sigma} is an m*n matrix with
nonnegative numbers on the diagonal and zeros off the diagonal, and {bf:V}^*
is the conjugate transpose of {bf:V}, an n*n unitary matrix.  If
{bf:M} is a real matrix, then so is {bf:V}, and {bf:V}^* = {bf:V}'.

{phang}
{marker sphericity}{...}
{bf:sphericity}.
Sphericity is the state or condition of being a sphere.  In repeated measures
ANOVA, sphericity concerns the equality of variance in the difference
between successive levels of the repeated measure.  The multivariate
alternative to ANOVA, called MANOVA, does not require the
assumption of sphericity.  Also see
{help mv_glossary##repeatmeasures:repeated measures}.

{phang}
{marker SSCP}{...}
{bf:SSCP matrix}.
SSCP is an acronym for the sums of squares and cross products.  Also see 
{help mv_glossary##betweenmatrix:between matrix}.

{phang}
{bf:stacked variables}.
See {help mv_glossary##crossedvars:crossed variables}.

{phang}
{bf:stacking variables}.
See {help mv_glossary##crossingvars:crossing variables}.

{phang}
{bf:standardized data}.
A standardized dataset has a mean of zero and a standard deviation of one.
You can standardize data {bf:x} by taking ({bf:x} - {bf:x}[bar])/sigma, where
sigma is the standard deviation of the data.

{phang}
{bf:stopping rules}.
Stopping rules for hierarchical cluster
analysis are used to determine the number of clusters.  A stopping-rule value
(also called an index) is computed for each cluster solution, that is, at each
level of the hierarchy in hierarchical cluster analysis.   Also see 
{help mv_glossary##hiercl:hierarchical clustering}.

{phang}
{marker stress}{...}
{bf:stress}.  See 
{help mv_glossary##Kruskalstress:Kruskal stress} and
{help mv_glossary##loss:loss}. 

{phang}
{bf:structure}.
Structure, as in factor structure, is the
correlations between the variables and the common factors after factor
analysis.  Structure matrices are available after factor analysis and 
LDA.  Also see 
{help mv_glossary##factoranalysis:factor analysis}
and 
{help mv_glossary##LDA:linear discriminant analysis}.

{phang}
{bf:supplementary rows or columns} or {bf:supplementary variables}.
Supplementary rows or columns can be included in CA, and supplementary
variables can be included in MCA.  They do not affect the CA or
MCA solution, but they are included in plots and tables with statistics
of the corresponding row or column points.  Also see
{help mv_glossary##CA:correspondence analysis} and
{help mv_glossary##MCA:multiple correspondence analysis}.

{phang}
{bf:SVD}.
See {help mv_glossary##SVD:singular value decomposition}.

{phang}
{bf:target rotation}.
Target rotation minimizes the criterion

{phang3}
c({bf:Lambda}) = 1/2|{bf:Lambda} - {bf:H}|^2

{pmore}
for a given target matrix {bf:H}.

{pmore} See 
{help mv_glossary##CFrotate:Crawford-Ferguson rotation}
for a definition of {bf:Lambda}.

{phang}
{bf:taxonomy}.
Taxonomy is the study of the general principles of scientific classification.
It also denotes classification, especially the classification of plants and
animals according to their natural relationships.  Cluster analysis is a tool
used in creating a taxonomy and is synonymous with numerical taxonomy.
Also see 
{help mv_glossary##clanalysis:cluster analysis}.

{phang}
{bf:tetrachoric correlation}.
A tetrachoric correlation estimates
the correlation coefficients of binary variables by assuming a latent bivariate
normal distribution for each pair of variables, with a threshold model for
manifest variables.

{phang}
{bf:ties}.
After discriminant analysis, ties in classification occur when two or more
posterior probabilities are equal for an observation.  They are most common
with KNN discriminant analysis.

{phang}
{bf:total inertia} or {bf:total principal inertia}.
The total (principal) inertia in CA and MCA is the sum of the
principal inertias.  In CA, total inertia is the Pearson chi^2/n.
In CA, the principal inertias are the singular values; in MCA
the principal inertias are the eigenvalues.  Also see
{help mv_glossary##CA:correspondence analysis} and
{help mv_glossary##MCA:multiple correspondence analysis}.

{phang}
{marker uniqueness}{...}
{bf:uniqueness}.
In factor analysis, the uniqueness is the percentage of a variable's variance
that is not explained by the common factors.  It is also "1 - communality".
Also see 
{help mv_glossary##communality:communality}.

{phang}
{bf:unrestricted transformation}.
An unrestricted transformation is a Procrustes transformation that allows the
data to be transformed, not just by orthogonal and oblique rotations, but by all
conformable regular matrices.  This is equivalent to a multivariate regression.
Also see {help mv_glossary##Procrustestransform:Procrustes transformation} and 
{help mv_glossary##mvregression:multivariate regression}.

{phang}
{marker varimaxrotation}{...}
{bf:varimax rotation}.
Varimax rotation maximizes the variance of the squared loadings within the
columns of the matrix.  It is an orthogonal rotation equivalent to oblimin with
gamma = 1 or to the Crawford-Ferguson family with kappa = 1/p,
where p is the number of rows of the matrix to be rotated.  Also see
{help mv_glossary##orthorotation:orthogonal rotation},
{help mv_glossary##obliminrotation:oblimin rotation}, and 
{help mv_glossary##CFrotate:Crawford-Ferguson rotation}.

{phang}
{bf:Ward's linkage clustering}.
Ward's-linkage clustering is a hierarchical clustering method that joins the
two groups resulting in the minimum increase in the error sum of squares.

{phang}
{bf:weighted-average linkage clustering}.
Weighted-average linkage clustering is a hierarchical clustering method that
uses the weighted average similarity or dissimilarity of the two groups as the
measure between the two groups.

{phang}
{marker Wilk}{...}
{bf:Wilks's lambda}.
Wilks's lambda is a test statistic for the hypothesis test H_0: {bf:mu}_1 =
{bf:mu}_2 = ... = {bf:mu}_k based on the eigenvalues lambda_1, ..., lambda_s of
{bf:E}^{-1}{bf:H}.  It is defined as

{phang3}
Lambda = |{bf:E}|}/{|{bf:E} + {bf:H}|} = prod_{i=1}^s 1/(1 + lambda_i)

{pmore}
where {bf:H} is the between matrix and {bf:E} is the within matrix. See
{help mv_glossary##betweenmatrix:between matrix}.

{phang}
{bf:Wishart distribution}.
The Wishart distribution is a family of probability distributions
for nonnegative-definite matrix-valued random variables ("random matrices").
These distributions are of great importance in the estimation of covariance
matrices in multivariate statistics.

{phang}
{bf:within matrix}.
See {help mv_glossary##betweenmatrix:between matrix}.
{p_end}


{marker references}{...}
{title:References}

{marker B1937}{...}
{phang}
Bartlett, M. S. 1937. The statistical conception of mental factors.
{it:British Journal of Psychology} 28: 97-104.

{marker B1938}{...}
{phang}
------. 1938. Methods of estimating mental factors.
{it:Nature, London} 141: 609-610.

{marker B1961}{...}
{phang}
Bellman, R. E. 1961. {it:Adaptive Control Processes}. Princeton, NJ:
Princeton University Press.

{marker B1977}{...}
{phang}
Bentler, P. M. 1977. Factor simplicity index and transformations.
{it:Psychometrika} 42: 277-295.

{marker C1967}{...}
{phang}
Comrey, A. L. 1967. Tandem criteria for analytic rotation in factor analysis.
{it:Psychometrika} 32: 277-295.

{marker CC2001}{...}
{phang}
Cox, T. F., and M. A. A. Cox. 2001.  {it:Multidimensional Scaling}. 2nd ed.
Boca Raton, FL.  Chapman & Hall/CRC.

{marker CF1970}{...}
{phang}
Crawford, C. B., and G. A. Ferguson. 1970. A general rotation criterion and its
use in orthogonal rotation. {it:Psychometrika} 35: 321-332.

{marker F1936}{...}
{phang}
Fisher, R. A. 1936. The use of multiple measurements in taxonomic problems.
{it:Annals of Eugenics} 7: 179-188.

{marker HW1964}{...}
{phang}
Hendrickson, A. E., and P. O. White. 1964. Promax: A quick method for rotation
to oblique simple structure.  {it:British Journal of Statistical Psychology}
17: 65-70.

{marker J2004}{...}
{phang}
Jennrich, R. I. 2004. Rotation to simple loadings using component loss
functions: The orthogonal case.  {it:Psychometrika} 69: 257-273.

{marker K1974}{...}
{phang}
Kaiser, H. F. 1974. An index of factor simplicity. {it:Psychometrika} 39:
31-36.

{marker K1964}{...}
{phang}
Kruskal, J. B. 1964. Multidimensional scaling by optimizing goodness of fit to
a nonmetric hypothesis. {it:Psychometrika} 29: 1-27.

{marker M1936}{...}
{phang}
Mahalanobis, P. C. 1936. On the generalized distance in statistics.
{it:National Institute of Science in India} 12: 49-55.

{marker S1969}{...}
{phang}
Sammon, J. W., Jr. 1969. A nonlinear mapping for data structure analysis.
{it:IEEE Transactions on Computers} 18: 401-409.

{marker T1951}{...}
{phang}
Thomson, G. H. 1951. {it:The Factorial Analysis of Human Ability}.
London: University of London Press.
{p_end}
