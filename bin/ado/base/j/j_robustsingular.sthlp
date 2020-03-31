{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[SVY] Survey" "mansection SVY Survey"}{...}
{vieweralsosee "[R] test" "mansection R test"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _robust" "mansection P _robust"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bootstrap" "help bootstrap"}{...}
{vieweralsosee "[R] jackknife" "help jackknife"}{...}
{viewerjumpto "The F or chi2 model statistic has been reported as missing" "j_robustsingular##fstat"}{...}
{viewerjumpto "Are any standard errors missing?" "j_robustsingular##se"}{...}
{viewerjumpto "Are you using bootstrap or jackknife?" "j_robustsingular##boot"}{...}
{viewerjumpto "Are you using a svy estimator or did you specify the vce(cluster clustvar) option?" "j_robustsingular##cluster"}{...}
{viewerjumpto "Is there a regressor that is nonzero for only 1 observation or for one cluster?" "j_robustsingular##nonzero"}{...}
{marker fstat}{...}
{title:The F or chi2 model statistic has been reported as missing}

{pstd}
Your estimation results show an F or chi2 model statistic reported to be
missing.  Stata has done that so as to not be misleading, not because
there is something necessarily wrong with your model.


{marker se}{...}
{title:Are any standard errors missing?}

{pstd}
If any standard errors are reported as dots, something is wrong with your
model:  one or more coefficients could not be estimated in the normal
statistical sense.  You need to address that problem and ignore the rest of
this discussion.


{marker boot}{...}
{title:Are you using {cmd:bootstrap} or {cmd:jackknife}?}

{pstd}
The VCE you have just estimated is not of sufficient rank to perform the model
test.  This is most likely due to not having enough replications.

{pstd}
The {cmd:bootstrap} command has a {opt reps(#)} option, and if {it:#} is less
than the number of coefficients in the model, the VCE will have insufficient
rank.  The solution is to rerun {cmd:bootstrap} with a much larger number of
replications.

{pstd}
The {cmd:jackknife} command estimates the VCE by refitting the model for each
observation in the dataset, leaving the associated observation out of the
estimation sample each time.  As with the conventional variance estimator,
the VCE will be singular if the number of observations is less than the number
of parameters.  See the following discussion if you supplied the
{opt cluster()} option to {cmd:jackknife}.


{marker cluster}{...}
{title:Are you using a {cmd:svy} estimator or did you specify the {cmd:vce(cluster clustvar)} option?}

{pstd}
The VCE you have just estimated is not of sufficient rank to perform the model
test.  As discussed in {manlink R test}, the model test with clustered or
survey data is distributed as F(k,d-k+1) or chi2(k), where k is the number of
constraints and d=number of clusters or d=number of PSUs minus the number of
strata.  Because the rank of the VCE is at most d and the model test reserves
1 degree of freedom for the constant, at most d-1 constraints can be tested,
so k must be less than d.  The model that you just fit does not meet this
requirement.

{pstd}
To simplify the remaining discussion, let's consider the case of clustered
data.  This discussion applies to survey estimation in general by
substituting, "PSUs - strata" for "clusters".

{pstd}
There is no mechanical problem with your model, but you need to consider
carefully whether any of the reported standard errors mean anything.  The
theory that justifies the standard error calculation is asymptotic in the
number of clusters, and we have just established that you are estimating at
least as many parameters as you have clusters.

{pstd}
That concern aside, the model test statistic issue is that you
cannot simultaneously test that all coefficients are zero because there is
not enough information.  You could test a subset, but not all, and so
Stata refuses to report the overall model test statistic.

{pstd}
Here note the degrees of freedom reported for the chi2 or F.
You might see chi2(6) or F(6, 5).  If you were to count the number
of coefficients that would be constrained to 0 in a model test in this case,
you would find that number to be greater than 6.  You could find out what
that number is by reestimating the model parameters without the
{cmd:vce(robust)} and {cmd:vce(cluster} {it:clustvar}{cmd:)} options (or, for
the {help survey} commands, using the corresponding non-{cmd:svy} estimator).
In any case, the 6 reported is the maximum number of coefficients that could
be simultaneously tested.


{marker nonzero}{...}
{title:Is there a regressor that is nonzero for only 1 observation or for one cluster?}

{pstd} 
The VCE you have just estimated is not of sufficient rank to perform the model
test.  This can happen if there is a variable in your model that is nonzero
for only 1 observation in the estimation sample.  Likewise, it can
happen if a variable is nonzero for only one cluster when using the
cluster-robust VCE.  In such cases the derivative of the sum-of-squares or
likelihood function with respect to that variable's parameter is zero for all
observations.  That implies that the outer-product-of-gradients (OPG) variance
matrix is singular.  Because the OPG variance matrix is used in computing the
robust variance matrix, the latter is therefore singular as well.
{p_end}
