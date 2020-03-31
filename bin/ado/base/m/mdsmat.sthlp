{smcl}
{* *! version 2.2.7  12dec2018}{...}
{viewerdialog mdsmat "dialog mdsmat"}{...}
{vieweralsosee "[MV] mdsmat" "mansection MV mdsmat"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mds postestimation" "help mds_postestimation"}{...}
{vieweralsosee "[MV] mds postestimation plots" "help mds_postestimation plots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mds" "help mds"}{...}
{vieweralsosee "[MV] mdslong" "help mdslong"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] biplot" "help biplot"}{...}
{vieweralsosee "[MV] ca" "help ca"}{...}
{vieweralsosee "[MV] factor" "help factor"}{...}
{vieweralsosee "[MV] pca" "help pca"}{...}
{viewerjumpto "Syntax" "mdsmat##syntax"}{...}
{viewerjumpto "Menu" "mdsmat##menu"}{...}
{viewerjumpto "Description" "mdsmat##description"}{...}
{viewerjumpto "Links to PDF documentation" "mdsmat##linkspdf"}{...}
{viewerjumpto "Options" "mdsmat##options"}{...}
{viewerjumpto "Examples" "mdsmat##examples"}{...}
{viewerjumpto "Stored results" "mdsmat##results"}{...}
{viewerjumpto "References" "mdsmat##references"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[MV] mdsmat} {hline 2}}Multidimensional scaling of proximity data in a matrix
{p_end}
{p2col:}({mansection MV mdsmat:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 24 2}
{cmd:mdsmat} {it:matname}
[{cmd:,} {it:options}]


{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt:{opth met:hod(mdsmat##method:method)}}method for performing MDS{p_end}
{synopt:{opth loss:(mdsmat##loss:loss)}}loss function{p_end}
{synopt:{opth trans:form(mdsmat##tfunction:tfunction)}}permitted transformations of
	dissimilarities{p_end}
{synopt:{opth norm:alize(mdsmat##norm:norm)}}normalization method; default is
	{cmd:normalize(principal)}{p_end}
{synopt:{opt nam:es(namelist)}}variable names corresponding to row and
column names of the matrix; required with all but
{cmd:shape(full)}{p_end}
{synopt:{cmdab:sh:ape}{cmd:(}{cmdab:f:ull}{cmd:)}}{it:matname} is a square
	symmetric matrix; the default{p_end}
{synopt:{cmdab:sh:ape}{cmd:(}{cmdab:l:ower}{cmd:)}}{it:matname} is a vector
	with the rowwise lower triangle (with diagonal){p_end}
{synopt:{cmdab:sh:ape}{cmd:(}{cmdab:ll:ower}{cmd:)}}{it:matname} is a vector
	with the rowwise strictly lower triangle (no diagonal){p_end}
{synopt:{cmdab:sh:ape}{cmd:(}{cmdab:u:pper}{cmd:)}}{it:matname} is a vector
	with the rowwise upper triangle (with diagonal){p_end}
{synopt:{cmdab:sh:ape}{cmd:(}{cmdab:uu:pper}{cmd:)}}{it:matname} is a vector
	with the rowwise strictly upper triangle (no diagonal){p_end}
{synopt:{cmd:s2d(}{cmdab:st:andard}{cmd:)}}convert similarity to
	dissimilarity: dissim(ij) = sqrt{c -(}sim(ii)+sim(jj)-2sim(ij){c )-}{p_end}
{synopt:{cmd:s2d(}{cmdab:one:minus}{cmd:)}}convert similarity to
	dissimilarity: dissim(ij) = 1-sim(ij){p_end}

{syntab:Model 2}
{synopt:{opt dim:ension(#)}}configuration dimensions; default is
	{cmd:dimension(2)}{p_end}
{synopt:{opt force}}fix problems in proximity information{p_end}
{synopt:{opt add:constant}}make distance matrix positive semidefinite
	(classical MDS only){p_end}
{synopt:{opt weight(matname)}}specifies a weight matrix with the same
	shape as the proximity matrix{p_end}

{syntab:Reporting}
{p2col:{opt neig:en(#)}}maximum number of eigenvalues to display; default is
	{cmd:neigen(10)} (classical MDS only){p_end}
{p2col:{opt con:fig}}display table with configuration coordinates{p_end}
{p2col:{opt nopl:ot}}suppress configuration plot{p_end}

{syntab:Minimization}
{synopt:{opth init:ialize(mdsmat##initopt:initopt)}}start with configuration given in
{it:initopt}{p_end}
{synopt:{opt tol:erance(#)}}tolerance for configuration matrix;
default is {cmd:tolerance(1e-4)}{p_end}
{synopt:{opt ltol:erance(#)}}tolerance for loss criterion; default is
{cmd:ltolerance(1e-8)}{p_end}
{synopt:{opt iter:ate(#)}}perform maximum of {it:#} iterations;
default is {cmd:iterate(1000)}{p_end}
{synopt:{opt prot:ect(#)}}perform {it:#} optimizations and report best
	solution; default is {cmd:protect(1)}{p_end}
{synopt:[{cmd:no}]{cmd:log}}display or suppress the iteration log; default is
to display{p_end}
{synopt:{opt tr:ace}}display current configuration in iteration log{p_end}
{synopt:{opt grad:ient}}display current gradient matrix in iteration log{p_end}

{synopt:{opt sd:protect(#)}}advanced; see {help mdsmat##sdprotect():{it:Options}} below{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt sdprotect(#)} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp mds_postestimation MV:mds postestimation} for features available
after estimation.{p_end}


INCLUDE help mds_tables


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis > Multidimensional scaling (MDS) >}
      {bf:MDS of proximity matrix}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mdsmat} performs multidimensional scaling (MDS) for
two-way proximity data with an explicit measure of similarity or dissimilarity
between objects, where the proximities are found in a user-specified matrix.
{cmd:mdsmat} performs classical metric MDS as well as modern metric and
nonmetric MDS.

{pstd}
If your proximities are stored as variables in long format, see
{manhelp mdslong MV}.  If you are looking for MDS on a dataset on the basis of 
dissimilarities between observations over variables, see {manhelp mds MV}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV mdsmatQuickstart:Quick start}

        {mansection MV mdsmatRemarksandexamples:Remarks and examples}

        {mansection MV mdsmatMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

INCLUDE help mds_mltn_desc

{phang}{opt names(namelist)}
is required with all but {cmd:shape(full)}.  The number of
names should equal the number of rows (and columns) of the full similarity or
dissimilarity matrix and should not contain duplicates.

{phang}{opt shape(shape)}
specifies the storage mode of the existing similarity or dissimilarity matrix
{it:matname}.  The following storage modes are allowed:

{phang2}{opt full}
specifies that {it:matname} is a symmetric n x n matrix.

{phang2}{opt lower}
specifies that {it:matname} is a row or column vector of length n(n+1)/2, with
the rowwise lower triangle of the similarity or dissimilarity matrix
including the diagonal.

{p 16 20 2}
D(11) D(21) D(22) D(31) D(32) D(33) ... D(n1) D(n2) ... D(nn)

{phang2}{opt llower}
specifies that {it:matname} is a row or column vector of length n(n-1)/2, with
the rowwise lower triangle of the similarity or dissimilarity matrix excluding
the diagonal.

{p 16 20 2}
D(21) D(31) D(32) D(41) D(42) D(43) ... D(n1) D(n2) ... D(n,n-1)

{phang2}{opt upper}
specifies that {it:matname} is a row or column vector of length n(n+1)/2, with
the rowwise upper triangle of the similarity or dissimilarity matrix including
the diagonal.

{p 16 20 2}
D(11) D(12) ... D(1n) D(22) D(23) ... D(2n) D(33) D(34) ... D(3n) ... D(nn)

{phang2}{opt uupper}
specifies that {it:matname} is a row or column vector of length n(n-1)/2, with
the rowwise upper triangle of the similarity or dissimilarity matrix excluding
the diagonal.

{p 16 20 2}
D(12) D(13) ... D(1n) D(23) D(24) ... D(2n) D(34) D(35) ... D(3n) ... D(n-1,n)

{phang}{cmd:s2d(standard}|{cmd:oneminus)}
specifies how similarities are converted into dissimilarities.
By default, the command assumes dissimilarity data.
Specifying {opt s2d()} indicates that your proximity data are similarities.

{pmore}
Dissimilarity data should have zeros on the diagonal (that is, an object is
identical to itself) and nonnegative off-diagonal values.
Dissimilarities need not satisfy the triangular inequality,
D(i,j)^2 {ul:<} D(i,h)^2 + D(h,j)^2.  Similarity data should have ones on the
diagonal (that is, an object is identical to itself) and have off-diagonal
values between zero and one.  In either case, proximities should be symmetric.
See option {helpb mdsmat##force:force} if your data violate these assumptions.

{pmore}
The available {cmd:s2d()} options, {cmd:standard} and {cmd:oneminus}, are
defined as follows:

{p2colset 13 25 27 2}{...}
{p2col:{cmd:standard}}dissim(ij) = sqrt{c -(}sim(ii)+sim(jj)-2sim(ij){c )-} = sqrt(2(1-sim(ij))){p_end}
{p2col:{cmd:oneminus}}dissim(ij) = 1-sim(ij){p_end}
{p2colreset}{...}

{pmore}{cmd:s2d(standard)} is the default.

{pmore}{cmd:s2d()} should be specified only with measures in similarity form.

{dlgtab:Model 2}

{phang}{opt dimension(#)}
specifies the dimension of the approximating configuration.  The default is
{cmd:dimension(2)}, and {it:#} should not exceed the number of positive
eigenvalues of the centered distance matrix.

{marker force}{...}
{phang}
{opt force} corrects problems with the supplied proximity and weight
information.
{opt force} specifies that the dissimilarity matrix be symmetrized; the
mean of D(i,j) and D(j,i) is used.  Also, problems on the diagonal
(similarities:  D(i,i)!=1; dissimilarities: D(i,i)!=0) are fixed.
{cmd:force} does not fix missing values or out-of-range values (that is,
D(i,j)<0 or similarities with D(i,j)>1).  Analogously, {opt force}
symmetrizes the weight matrix.

{phang}{cmd:addconstant}
specifies that if the double-centered distance matrix is not positive
semidefinite (psd), a constant should be added to the squared distances to
make it psd and, hence, Euclidean.

{phang}
{cmd:weight(}{it:matname}{cmd:)}
specifies a symmetric weight matrix with the same shape as the proximity
matrix; that is, if {cmd:shape(lower)} is specified, the weight matrix must
have this shape.  Weights should be nonnegative.  Missing weights are
assumed to be 0.  Weights must also be irreducible; that is, it is not
possible to split the objects into disjointed groups with all intergroup
weights 0.   {cmd:weight()} is not allowed with {cmd:method(classical)}, but
see {helpb mdsmat##loss(strain):loss(strain)}. 

{dlgtab:Reporting}

{phang}{opt neigen(#)}
specifies the number of eigenvalues to be included in the table.  The default
is {cmd:neigen(10)}.  Specifying {cmd:neigen(0)} suppresses the table.  This
option is allowed with classical MDS only.

{phang}{opt config}
displays the table with the coordinates of the approximating configuration.
This table may also be displayed using the postestimation command
{cmd:estat config}; see {manhelp mds_postestimation MV:mds postestimation}.

{phang}{opt noplot}
suppresses the graph of the approximating configuration.  The graph
can still be produced later via {cmd:mdsconfig}, which also allows the standard
graphics options for fine-tuning the plot; see
{manhelp mds_postestimation_plots MV:mds postestimation plots}.

{dlgtab:Minimization}

{phang}These options are available only with {cmd:method(modern)} or
{cmd:method(nonmetric)}:

{marker initialize()}{...}
{phang}{opt initialize(initopt)}
specifies the initial values of the criterion minimization process.

{phang2}{cmd:initialize(classical)}, the default,
uses the solution from classical metric scaling as initial values.
With {cmd:protect()}, all but the first run start from random
perturbations from the classical solution.  These random perturbations
are independent and normally distributed with standard error equal to the
product of {opt sdprotect(#)} and the standard deviation of the
dissimilarities.  {cmd:initialize(classical)} is the default.

{phang2}{cmd:initialize(random)}
starts an optimization process from a random starting configuration.
These random configurations are generated from independent normal
distributions with standard error equal to the product of
{opt sdprotect(#)} and the standard deviation of the dissimilarities.
The means of the configuration are irrelevant in MDS.

{phang2}{cmd:initialize(from(}{it:matname}{cmd:)}[{cmd:, copy}]{cmd:)}
sets the initial value to {it:matname}.  {it:matname} should be an
{it:n} x {it:p} matrix, where {it:n} is the number of observations and {it:p}
is the number of dimensions, and the rows
of {it:matname} should be ordered with respect to {cmd:id()}.
The rownames of {it:matname} should be set correctly but will
be ignored if {cmd:copy} is specified.  With {cmd:protect()}, the
second-to-last runs start from random perturbations from {it:matname}.  These
random perturbations are independent normal distributed with standard error
equal to the product of {opt sdprotect(#)} and the standard deviation of the
dissimilarities.

{phang}{opt tolerance(#)}
specifies the tolerance for the configuration matrix.  When the relative change
in the configuration from one iteration to the next is less than or equal to
{cmd:tolerance()}, the {cmd:tolerance()} convergence criterion is satisfied.
The default is {cmd:tolerance(1e-4)}.

{phang}{opt ltolerance(#)}
specifies the tolerance for the fit criterion.  When the relative change
in the fit criterion from one iteration to the next is less than or
equal to {cmd:ltolerance()}, the {cmd:ltolerance()} convergence is
satisfied.  The default is {cmd:ltolerance(1e-8)}.

{pmore}
Both the {cmd:tolerance()} and {cmd:ltolerance()} criteria must be satisfied
for convergence.

{phang}{opt iterate(#)}
specifies the maximum number of iterations.  The default is {cmd:iterate(1000)}.

{phang}{opt protect(#)}
requests that {it:#} optimizations be performed and that the best of the
solutions be reported.  The default is {cmd:protect(1)}.  See option
{helpb mdsmat##initialize():initialize()} on starting values of the runs.  The
output contains a table of the return code, the criterion value reached, and
the seed of the random number used to generate the starting value.  Specifying
a large number, such as {cmd:protect(50)}, provides reasonable insight whether
the solution found is a global minimum and not just a local minimum.

{pmore}
If any of the options {cmd:log}, {cmd:trace}, or {cmd:gradient}
is also specified, iteration reports will be printed for each
optimization run.  Beware: this option will produce a lot of output.

{phang}
INCLUDE help lognolog

{phang}{opt trace}
displays the configuration matrices in the iteration report.
Beware: this option may produce a lot of output.

{phang}{opt gradient}
displays the gradient matrices of the fit criterion in the iteration report.
Beware: this option may produce a lot of output.
{p_end}

{pstd}The following option is available with {cmd:mdsmat} but is not shown in
the dialog box:

{marker sdprotect()}{...}
{phang}{opt sdprotect(#)}
sets a proportionality constant for the standard deviations of random
configurations ({cmd:init(random)}) or random perturbations of given
starting configurations ({cmd:init(classical)} or {cmd:init(from())}).
The default is {cmd:sdprotect(1)}.


{marker examples}{...}
{title:Examples}

{pstd}
A famous example in the MDS literature is the data on the percentage of times
that pairs of Morse code signals for two numbers (1,..,9,0) were declared the
same by 598 subjects.  We enter the lower triangle of the data matrix,
excluding the diagonal.  This is called the {cmd:llower} shape (notice the
extra "l" to tell it apart from {cmd:lower} that includes the diagonal).  For
clarity, we enter each row on a separate line; we could have typed the numbers
as one long row as well.

{cmd}{...}
{tab}. matrix input Morse = (     ///
{tab}    62                       ///
{tab}    16 59                    ///
{tab}     6 23 38                 ///
{tab}    12  8 27 56              ///
{tab}    12 14 33 34 30           ///
{tab}    20 25 17 24 18 65        ///
{tab}    37 25 16 13 10 22 65     ///
{tab}    57 28  9  7  5  8 31 58  ///
{tab}    52 18  9  7  5 18 15 39 79 )
{txt}{...}

{pstd}
These are proximity data in similarity format, but in the range [0,100] rather
than [0,1] as required by {cmd:mdsmat}.

{tab}{cmd:. matrix Morse = 0.01 * Morse}

{pstd}Classical MDS{p_end}

{phang2}
{cmd:. mdsmat Morse, shape(llower) s2d(st) names(1 2 3 4 5 6 7 8 9 0)}

{pstd}Modern MDS{p_end}

{phang2}
{cmd:. mdsmat Morse, shape(llower) s2d(st) names(1 2 3 4 5 6 7 8 9 0) method(modern)}{p_end}
{pmore}(note: {cmd:loss(stress)} and {cmd:transform(identity)} are
assumed){p_end}

{phang2}
{cmd:. mdsmat Morse, shape(llower) s2d(st) names(1 2 3 4 5 6 7 8 9 0) loss(sstress)}{p_end}

{pstd}Nonmetric MDS{p_end}

{phang2}
{cmd:. mdsmat Morse, shape(llower) s2d(st) names(1 2 3 4 5 6 7 8 9 0) loss(stress) transform(monotonic)}


{marker results}{...}
{title:Stored results}

{pstd}{cmd:mdsmat} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of rows or columns (i.e., number of observations){p_end}
{synopt:{cmd:e(p)}}number of dimensions in the approximating configuration{p_end}
{synopt:{cmd:e(np)}}number of strictly positive eigenvalues{p_end}
{synopt:{cmd:e(addcons)}}constant added to squared dissimilarities to force positive semidefiniteness{p_end}
{synopt:{cmd:e(mardia1)}}Mardia measure 1{p_end}
{synopt:{cmd:e(mardia2)}}Mardia measure 2{p_end}
{synopt:{cmd:e(critval)}}loss criterion value{p_end}
{synopt:{cmd:e(wsum)}}sum of weights{p_end}
{synopt:{cmd:e(alpha)}}parameter of {cmd:transform(power)}{p_end}
{synopt:{cmd:e(ic)}}iteration count{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:mdsmat}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(method)}}{cmd:classical} or {cmd:modern} MDS method{p_end}
{synopt:{cmd:e(method2)}}{cmd:nonmetric}, if {cmd:method(nonmetric)}{p_end}
{synopt:{cmd:e(loss)}}loss criterion{p_end}
{synopt:{cmd:e(losstitle)}}description loss criterion{p_end}
{synopt:{cmd:e(dmatrix)}}name of analyzed matrix{p_end}
{synopt:{cmd:e(tfunction)}}{cmd:identity}, {cmd:power}, or {cmd:monotonic},
transformation function{p_end}
{synopt:{cmd:e(transftitle)}}description of transformation{p_end}
{synopt:{cmd:e(dtype)}}{cmd:similarity} or {cmd:dissimilarity}; type of
               proximity data{p_end}
{synopt:{cmd:e(s2d)}}{cmd:standard} or {cmd:oneminus} (when {cmd:e(dtype)}
is {cmd:similarity}){p_end}
{synopt:{cmd:e(unique)}}{cmd:1} if eigenvalues are distinct, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(init)}}initialization method{p_end}
{synopt:{cmd:e(irngstate)}}initial random-number state used for {cmd:init(random)}{p_end}
{synopt:{cmd:e(rngstate)}}random-number state for solution{p_end}
{synopt:{cmd:e(norm)}}normalization method{p_end}
{synopt:{cmd:e(targetmatrix)}}name of target matrix for
{cmd:normalize(target)}{p_end}
{synopt:{cmd:e(properties)}}{cmd:nob noV} for modern or nonmetric MDS; {cmd:nob noV eigen} for classical MDS
{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(D)}}dissimilarity matrix{p_end}
{synopt:{cmd:e(Disparities)}}disparity matrix for nonmetric MDS{p_end}
{synopt:{cmd:e(Y)}}approximating configuration coordinates{p_end}
{synopt:{cmd:e(Ev)}}eigenvalues{p_end}
{synopt:{cmd:e(W)}}weight matrix{p_end}
{synopt:{cmd:e(norm_stats)}}normalization statistics{p_end}
{synopt:{cmd:e(linearf)}}two element vector defining the linear
transformation; distance equals first element plus second element
times dissimilarity{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker BG2005}{...}
{phang}
Borg, I., and P. J. F. Groenen. 2005.
{it:Modern Multidimensional Scaling: Theory and Applications}. 2nd ed.
New York: Springer.

{marker S1969}{...}
{phang}
Sammon, J. W., Jr. 1969.
A nonlinear mapping for data structure analysis.
{it:IEEE Transactions on Computers} 18: 401-409.
{p_end}
