{smcl}
{* *! version 2.2.9  12dec2018}{...}
{viewerdialog mds "dialog mds"}{...}
{vieweralsosee "[MV] mds" "mansection MV mds"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mds postestimation" "help mds postestimation"}{...}
{vieweralsosee "[MV] mds postestimation plots" "help mds postestimation plots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mdslong" "help mdslong"}{...}
{vieweralsosee "[MV] mdsmat" "help mdsmat"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] biplot" "help biplot"}{...}
{vieweralsosee "[MV] ca" "help ca"}{...}
{vieweralsosee "[MV] factor" "help factor"}{...}
{vieweralsosee "[MV] pca" "help pca"}{...}
{viewerjumpto "Syntax" "mds##syntax"}{...}
{viewerjumpto "Menu" "mds##menu"}{...}
{viewerjumpto "Description" "mds##description"}{...}
{viewerjumpto "Links to PDF documentation" "mds##linkspdf"}{...}
{viewerjumpto "Options" "mds##options"}{...}
{viewerjumpto "Examples" "mds##examples"}{...}
{viewerjumpto "Stored results" "mds##results"}{...}
{viewerjumpto "Reference" "mds##reference"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[MV] mds} {hline 2}}Multidimensional scaling for two-way data
{p_end}
{p2col:}({mansection MV mds:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mds} {varlist} {ifin} {cmd:,} {opth id(varname)}
[{it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent:* {opth id(varname)}}identify observations{p_end}
{synopt:{opth met:hod(mds##method:method)}}method for performing MDS{p_end}
{synopt:{opth loss:(mds##loss:loss)}}loss function{p_end}
{synopt:{opth trans:form(mds##tfunction:tfunction)}}permitted transformations of
	dissimilarities{p_end}
{synopt:{opth norm:alize(mds##norm:norm)}}normalization method; default is
	{cmd:normalize(principal)}{p_end}
{synopt:{opt dim:ension(#)}}configuration dimensions; default is
	{cmd:dimension(2)}{p_end}
{synopt:{opt add:constant}}make distance matrix positive semidefinite{p_end}

{syntab:Model 2}{...}
{synopt:{cmd:unit}[{cmd:(}{it:{help varlist:varlist2}}{cmd:)}]}scale variables to min=0 and
	max=1{p_end}
{synopt:{cmd:std}[{cmd:(}{it:{help varlist:varlist3}}{cmd:)}]}scale variables to mean=0 and
	sd=1{p_end}
{synopt:{opth mea:sure(measure option:measure)}}similarity or dissimilarity
	measure; default is {cmd:measure(L2)} (Euclidean){p_end}
{synopt:{cmd:s2d(}{cmdab:st:andard}{cmd:)}}convert similarity to
	dissimilarity: dissim(ij)=sqrt{c -(}sim(ii)+sim(jj)-2sim(ij){c )-}; the default{p_end}
{synopt:{cmd:s2d(}{cmdab:one:minus}{cmd:)}}convert similarity to
	dissimilarity: dissim(ij)=1-sim(ij){p_end}

{syntab:Reporting}
{synopt:{opt neig:en(#)}}maximum number of eigenvalues to display; default is
	{cmd:neigen(10)}{p_end}
{synopt:{opt con:fig}}display table with configuration coordinates{p_end}
{synopt:{opt nopl:ot}}suppress configuration plot{p_end}

{syntab:Minimization}
{synopt:{opth init:ialize(mds##initopt:initopt)}}start with configuration given in
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

{synopt:{opt sd:protect(#)}}advanced; see {help mds##sdprotect():{it:Options}} below{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt id(varname)} is required.
{p_end}
{p 4 6 2}
{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:rolling}, {cmd:statsby}, and
{cmd:xi} are allowed; see {help prefix}.
{p_end}
{p 4 6 2}
The maximum number of observations allowed in {cmd:mds} is the maximum matrix
size; see {manhelp Limits R}.
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
     {bf:MDS of data}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mds} performs multidimensional scaling (MDS) for dissimilarities between
observations with respect to the specified variables.  A wide selection
of similarity and dissimilarity measures is available.  {cmd:mds} performs
classical metric MDS as well as modern metric and nonmetric MDS.

{pstd}
If your proximities are stored as variables in long format, see
{manhelp mdslong MV}.  For MDS with two-way proximity data in a
matrix, see {manhelp mdsmat MV}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV mdsQuickstart:Quick start}

        {mansection MV mdsRemarksandexamples:Remarks and examples}

        {mansection MV mdsMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}{opth id(varname)}
is required and specifies a variable that identifies observations.
A warning message is displayed if {it:varname} has duplicate values.

INCLUDE help mds_mltn_desc

{phang}{opt dimension(#)}
specifies the dimension of the approximating configuration.  The default
{it:#} is 2 and should not exceed the number of observations;
typically, {it:#} would be much smaller.  With {cmd:method(classical)}, it
should not exceed the number of positive eigenvalues of the centered distance
matrix.

{phang}
{cmd:addconstant} specifies that if the double-centered distance matrix is not
positive semidefinite (psd), a constant should be added to the squared
distances to make it psd and, hence, Euclidean.
{cmd:addconstant} is allowed with classical MDS only.

{dlgtab:Model 2}

{phang}{cmd:unit}[{cmd:(}{it:{help varlist:varlist2}}{cmd:)}]
specifies variables that are transformed to min=0 and max=1 before entering in
the computation of similarities or dissimilarities.  {cmd:unit} by
itself, without an argument, is a shorthand for {cmd:unit(_all)}.
Variables in {cmd:unit()} should not be included in {cmd:std()}.

{phang}{cmd:std}[{cmd:(}{it:{help varlist:varlist3}}{cmd:)}]
specifies variables that are transformed to mean=0 and sd=1 before entering in
the computation of similarities or dissimilarities.  {cmd:std} by
itself, without an argument, is a shorthand for {cmd:std(_all)}.
Variables in {cmd:std()} should not be included in {cmd:unit()}.

{marker measure}{...}
{phang}{opt measure(measure)}
specifies the similarity or dissimilarity measure.
The default is {cmd:measure(L2)}, Euclidean distance.  This option is not
case sensitive.  See {manhelpi measure_option MV} for detailed descriptions of
the supported measures.

{pmore}
If a similarity measure is selected, the computed similarities will first be
transformed into dissimilarities, before proceeding with scaling; see the
{opt s2d()} option below.

{pmore}
Classical metric MDS with Euclidean distance is equivalent to principal
component analysis (see {manhelp pca MV}); the MDS configuration coordinates are
the principal components.

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

{pmore}
The available {cmd:s2d()} options, {cmd:standard} and {cmd:oneminus}, are
defined as follows:

{p2colset 13 25 27 2}{...}
{p2col:{cmd:standard}}dissim(ij) = sqrt{c -(}sim(ii)+sim(jj)-2sim(ij){c )-} = sqrt(2(1-sim(ij))){p_end}
{p2col:{cmd:oneminus}}dissim(ij) = 1-sim(ij){p_end}
{p2colreset}{...}

{pmore}{cmd:s2d(standard)} is the default.

{pmore}{cmd:s2d()} should be specified only with measures in similarity form.

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

{phang2}{cmd:initialize(from(}{it:matname}{cmd:)} [{cmd:, copy}]{cmd:)}
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
{helpb mds##initialize():initialize()} on starting values of the runs.  The
output contains a table of the run, return code, iteration, and criterion
value reached.  Specifying a large number, such as {cmd:protect(50)}, provides
reasonable insight whether the solution found is a global minimum and not just
a local minimum.

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

{pstd}The following option is available with {cmd:mds} but is not shown in the
dialog box:

{marker sdprotect()}{...}
{phang}{opt sdprotect(#)}
sets a proportionality constant for the standard deviations of random
configurations ({cmd:init(random)}) or random perturbations of given
starting configurations ({cmd:init(classical)} or {cmd:init(from())}).
The default is {cmd:sdprotect(1)}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}

{phang2}{cmd:. sysuse auto}{p_end}
   
{pstd}Classical MDS{p_end}

{phang2}
{cmd:. mds price-gear, id(make)}{p_end}
{phang2}
{cmd:. mds price-gear, id(make) dim(3) std noplot}{p_end}
{phang2}
{cmd:. mds price-gear, id(make) std measure(corr) addconstant}{p_end}

{pstd}Metric MDS{p_end}

{phang2}
{cmd:. mds price-gear, id(make) loss(strain) transform(identity)}{p_end}
{pmore}(this is equivalent to classical MDS){p_end}

{phang2}
{cmd:. mds price-gear, id(make) method(modern)}{p_end}
{pmore}(note: {cmd:loss(stress)} and {cmd:transform(identity)} are assumed){p_end}

{phang2}
{cmd:. mds price-gear, id(make) std loss(stress) transform(power)}{p_end}
{phang2}
{cmd:. mds price-gear, id(make) std loss(sstress) transform(id)}{p_end}
{phang2}
{cmd:. mds price-gear, id(make) method(modern) meas(corr) std}{p_end}

{pstd}Nonmetric MDS{p_end}

{phang2}
{cmd:. mds price-gear, id(make) method(nonmetric) std}{p_end}
{pmore}(note: {cmd:loss(stress)} and {cmd:transform(monotonic)} are
assumed){p_end}

{phang2}
{cmd:. mds price-gear, id(make) unit loss(stress) transform(monotonic)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd} {cmd:mds} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(p)}}number of dimensions in the approximating configuration{p_end}
{synopt:{cmd:e(np)}}number of strictly positive eigenvalues{p_end}
{synopt:{cmd:e(addcons)}}constant added to squared dissimilarities to force positive semidefiniteness{p_end}
{synopt:{cmd:e(mardia1)}}Mardia measure 1{p_end}
{synopt:{cmd:e(mardia2)}}Mardia measure 2{p_end}
{synopt:{cmd:e(critval)}}loss criterion value{p_end}
{synopt:{cmd:e(alpha)}}parameter of {cmd:transform(power)}{p_end}
{synopt:{cmd:e(ic)}}iteration count{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:mds}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(method)}}{cmd:classical} or {cmd:modern} MDS method{p_end}
{synopt:{cmd:e(method2)}}{cmd:nonmetric}, if {cmd:method(nonmetric)}{p_end}
{synopt:{cmd:e(loss)}}loss criterion{p_end}
{synopt:{cmd:e(losstitle)}}description loss criterion{p_end}
{synopt:{cmd:e(tfunction)}}{cmd:identity}, {cmd:power}, or {cmd:monotonic},
transformation function{p_end}
{synopt:{cmd:e(transftitle)}}description of transformation{p_end}
{synopt:{cmd:e(id)}}ID variable name ({cmd:mds}){p_end}
{synopt:{cmd:e(idtype)}}{cmd:int} or {cmd:str}; type of {cmd:id()}
variable{p_end}
{synopt:{cmd:e(duplicates)}}{cmd:1} if duplicates in {cmd:id()},
{cmd:0} otherwise{p_end}
{synopt:{cmd:e(labels)}}labels for ID categories{p_end}
{synopt:{cmd:e(strfmt)}}format for category labels{p_end}
{synopt:{cmd:e(varlist)}}variables used in computing similarities or
dissimilarities{p_end}
{synopt:{cmd:e(dname)}}similarity or dissimilarity measure name{p_end}
{synopt:{cmd:e(dtype)}}{cmd:similarity} or {cmd:dissimilarity}{p_end}
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
{synopt:{cmd:e(idcoding)}}coding for integer identifier variable{p_end}
{synopt:{cmd:e(coding)}}variable standardization values; first column has
value to subtract and second column has divisor{p_end}
{synopt:{cmd:e(norm_stats)}}normalization statistics{p_end}
{synopt:{cmd:e(linearf)}}two element vector defining the linear transformation; distance equals first element plus second element times dissimilarity{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{phang}
Sammon, J. W., Jr. 1969.
A nonlinear mapping for data structure analysis.
{it:IEEE Transactions on Computers} 18: 401-409.
{p_end}
