{smcl}
{* *! version 2.2.6  12dec2018}{...}
{viewerdialog mdslong "dialog mdslong"}{...}
{vieweralsosee "[MV] mdslong" "mansection MV mdslong"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mds postestimation" "help mds_postestimation"}{...}
{vieweralsosee "[MV] mds postestimation plots" "help mds postestimation plots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mds" "help mds"}{...}
{vieweralsosee "[MV] mdsmat" "help mdsmat"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] biplot" "help biplot"}{...}
{vieweralsosee "[MV] ca" "help ca"}{...}
{vieweralsosee "[MV] factor" "help factor"}{...}
{vieweralsosee "[MV] pca" "help pca"}{...}
{viewerjumpto "Syntax" "mdslong##syntax"}{...}
{viewerjumpto "Menu" "mdslong##menu"}{...}
{viewerjumpto "Description" "mdslong##description"}{...}
{viewerjumpto "Links to PDF documentation" "mdslong##linkspdf"}{...}
{viewerjumpto "Options" "mdslong##options"}{...}
{viewerjumpto "Example" "mdslong##example"}{...}
{viewerjumpto "Stored results" "mdslong##results"}{...}
{viewerjumpto "Reference" "mdslong##reference"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[MV] mdslong} {hline 2}}Multidimensional scaling of proximity data in long format
{p_end}
{p2col:}({mansection MV mdslong:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 24 2}
{cmd:mdslong} {depvar} {ifin}
[{it:{help mdslong##weight:weight}}]{cmd:,}
{opt id(var1 var2)} [{it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent:* {opt id(var1 var2)}}identify comparison pairs
	(object1,object2){p_end}
{synopt:{opth met:hod(mdslong##method:method)}}method for performing MDS{p_end}
{synopt:{opth loss:(mdslong##loss:loss)}}loss function{p_end}
{synopt:{opth trans:form(mdslong##tfunction:tfunction)}}permitted transformations of
	dissimilarities{p_end}
{synopt:{opth norm:alize(mdslong##norm:norm)}}normalization method; default is
	{cmd:normalize(principal)}{p_end}
{synopt:{cmd:s2d(}{cmdab:st:andard}{cmd:)}}convert similarity to
	dissimilarity: dissim(ij) = sqrt{c -(}sim(ii)+sim(jj)-2sim(ij){c )-}; the
	default{p_end}
{synopt:{cmd:s2d(}{cmdab:one:minus}{cmd:)}}convert similarity to
	dissimilarity: dissim(ij) = 1-sim(ij){p_end}
{synopt:{opt force}}correct problems in proximity information{p_end}
{synopt:{opt dim:ension(#)}}configuration dimensions; default is
	{cmd:dimension(2)}{p_end}
{synopt:{opt add:constant}}make distance matrix positive semidefinite
	(classical MDS only){p_end}

{syntab:Reporting}
{p2col:{opt neig:en(#)}}maximum number of eigenvalues to display; default is
	{cmd:neigen(10)} (classical MDS only){p_end}
{p2col:{opt con:fig}}display table with configuration coordinates{p_end}
{p2col:{opt nopl:ot}}suppress configuration plot{p_end}

{syntab:Minimization}
{synopt:{opth init:ialize(mdslong##initopt:initopt)}}start with configuration given in
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

{synopt:{opt sd:protect(#)}}advanced; see {help mdslong##sdprotect():{it:Options}} below{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt id(var1 var2)} is required.
{p_end}
{p 4 6 2}
{cmd:by} and {cmd:statsby} are allowed; see {help prefix}.
{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:aweight}s and {cmd:fweight}s are allowed for methods {cmd:modern}
and {cmd:nonmetric}; see {help weights}.
{p_end}
{p 4 6 2}
The maximum number of compared objects allowed is the maximum matrix size;
see {manhelp Limits R}.
{p_end}
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
     {bf:MDS of proximity-pair data}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mdslong} performs multidimensional scaling (MDS) for two-way proximity
data in long format with an explicit measure of similarity or
dissimilarity between objects.  {cmd:mdslong} performs classical MDS
as well as modern metric and nonmetric MDS.

{pstd}
For MDS with two-way proximity data in a matrix, see
{manhelp mdsmat MV}.  If you are looking for MDS on a dataset, based on
dissimilarities between observations over variables, see
{manhelp mds MV}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV mdslongQuickstart:Quick start}

        {mansection MV mdslongRemarksandexamples:Remarks and examples}

        {mansection MV mdslongMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}{opt id(var1 var2)}
is required.  The pair of variables {it:var1} and {it:var2} should uniquely
identify comparisons.  {it:var1} and {it:var2} are string or numeric variables
that identify the objects to be compared.  {it:var1} and {it:var2} should be
of the same data type; if they are value labeled, they should be labeled with
the same value label.  Using value-labeled variables or string variables is
generally helpful in identifying the points in plots and tables.

{tab}Example data layout for {cmd:mdslong proxim, id(i1 i2)}.

{space 19}{cmd:proxim    i1    i2}
{space 19}{hline 18}
{space 16}        7     1     2
{space 16}       10     1     3
{space 16}       12     1     4
{space 16}        4     2     3
{space 16}        6     2     4
{space 16}        3     3     4
{space 19}{hline 18}

{pmore}
If you have multiple measurements per pair, we suggest that you specify the mean
of the measures as the proximity and the inverse of the variance as the weight.

INCLUDE help mds_mltn_desc

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

{marker force}{...}
{phang}
{opt force} corrects problems with the supplied proximity information.
In the long format used by {cmd:mdslong}, multiple measurements on (i,j) may
be available.  Including both (i,j) and (j,i) would be treated as multiple
measurements.  This is an error, even if the measures are identical.  Option
{cmd:force} uses the mean of the measurements.  {cmd:force} also resolves
problems on the diagonal, that is, comparisons of objects with themselves;
these should have zero dissimilarity or unit similarity.  {cmd:force} does not
resolve incomplete data, that is, pairs (i,j) for which no measurement is
available.  Out-of-range values are also not fixed.

{phang}{opt dimension(#)}
specifies the dimension of the approximating configuration.  The default
is {cmd:dimension(2)}, and {it:#} should not exceed the number of positive
eigenvalues of the centered distance matrix.

{phang}{cmd:addconstant}
specifies that if the double-centered distance matrix is not positive
semidefinite (psd), a constant should be added to the squared distances to
make it psd and, hence, Euclidean.  This option is allowed with classical
MDS only.

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
{helpb mdslong##initialize():initialize()} on starting values of the runs.  The
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

{pstd}The following option is available with {cmd:mdslong} but is not shown in
the dialog box:

{marker sdprotect()}{...}
{phang}{opt sdprotect(#)}
sets a proportionality constant for the standard deviations of random
configurations ({cmd:init(random)}) or random perturbations of given
starting configurations ({cmd:init(classical)} or {cmd:init(from())}).
The default is {cmd:sdprotect(1)}.


{marker example}{...}
{title:Example}

{pstd}
A famous example in the MDS literature is the data on the percentage of times
that pairs of Morse code signals for two numbers (1,..,9,0) were declared the
same by 598 subjects.  We use the Morse data in long format.  The entries
are in the order 1,2,...,9,0.

{phang2}{cmd:. webuse morse_long}{p_end}

{pstd:}The proximity of (2,1) is entered, but not (1,2).  Either
one may be entered; it does not matter which.  Proximities between the
same objects, for example, (2,2) are not entered.  First we generate a
similarity measure between the objects.

{phang2}
{cmd}. gen sim = freqsame/100{txt}{p_end}

{pstd}{txt}Classical MDS{p_end}

{phang2}
{cmd}. mdslong sim, id(digit1 digit2) s2d(standard){txt}{p_end}

{pstd}{txt}Modern MDS{p_end}

{phang2}
{cmd}. mdslong sim, id(digit1 digit2) method(modern){p_end}
{pmore}{txt}(note: {cmd:loss(stress)} and {cmd:transform(identity)} are
assumed){p_end}

{pstd}Nonmetric MDS{p_end}

{phang2}
{cmd}. mdslong sim, id(digit1 digit2) method(nonmetric){p_end}
{pmore}{txt}(note: {cmd:loss(stress)} and {cmd:transform(monotonic)} are
assumed){p_end}


{marker results}{...}
{title:Stored results}

{pstd} {cmd:mdslong} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of underlying observations{p_end}
{synopt:{cmd:e(p)}}number of dimensions in the approximating configuration{p_end}
{synopt:{cmd:e(np)}}number of strictly positive eigenvalues{p_end}
{synopt:{cmd:e(addcons)}}constant added to squared dissimilarities to force positive semidefiniteness{p_end}
{synopt:{cmd:e(mardia1)}}Mardia measure 1{p_end}
{synopt:{cmd:e(mardia2)}}Mardia measure 2{p_end}
{synopt:{cmd:e(critval)}}loss criterion value{p_end}
{synopt:{cmd:e(npos)}}number of pairs with positive weights{p_end}
{synopt:{cmd:e(wsum)}}sum of weights{p_end}
{synopt:{cmd:e(alpha)}}parameter of {cmd:transform(power)}{p_end}
{synopt:{cmd:e(ic)}}iteration count{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:mdslong}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(method)}}{cmd:classical} or {cmd:modern} MDS method{p_end}
{synopt:{cmd:e(method2)}}{cmd:nonmetric}, if {cmd:method(nonmetric)}{p_end}
{synopt:{cmd:e(loss)}}loss criterion{p_end}
{synopt:{cmd:e(losstitle)}}description loss criterion{p_end}
{synopt:{cmd:e(tfunction)}}{cmd:identity}, {cmd:power}, or {cmd:monotonic},
transformation function{p_end}
{synopt:{cmd:e(transftitle)}}description of transformation{p_end}
{synopt:{cmd:e(id)}}two ID variable names identifying compared object pairs{p_end}
{synopt:{cmd:e(idtype)}}{cmd:int} or {cmd:str}; type of {cmd:id()}
variable{p_end}
{synopt:{cmd:e(duplicates)}}{cmd:1} if duplicates in {cmd:id()},
{cmd:0} otherwise{p_end}
{synopt:{cmd:e(labels)}}labels for ID categories{p_end}
{synopt:{cmd:e(mxlen)}}maximum length of category labels{p_end}
{synopt:{cmd:e(depvar)}}dependent variable containing dissimilarities{p_end}
{synopt:{cmd:e(dtype)}}{cmd:similarity} or {cmd:dissimilarity}; type of
               proximity data{p_end}
{synopt:{cmd:e(s2d)}}{cmd:standard} or {cmd:oneminus} (when {cmd:e(dtype)}
is {cmd:similarity}){p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
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
{synopt:{cmd:e(idcoding)}}coding for integer identifier variable{p_end}
{synopt:{cmd:e(norm_stats)}}normalization statistics{p_end}
{synopt:{cmd:e(linearf)}}two element vector defining the linear
transformation; distance equals first element plus second element
times dissimilarity{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker S1969}{...}
{phang}
Sammon, J. W., Jr. 1969.
A nonlinear mapping for data structure analysis.
{it:IEEE Transactions on Computers} 18: 401-409.
{p_end}
