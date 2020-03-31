{smcl}
{* *! version 1.1.16  19oct2017}{...}
{viewerdialog lrtest "dialog lrtest"}{...}
{vieweralsosee "[R] lrtest" "mansection R lrtest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{vieweralsosee "[R] testnl" "help testnl"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] nestreg" "help nestreg"}{...}
{viewerjumpto "Syntax" "lrtest##syntax"}{...}
{viewerjumpto "Menu" "lrtest##menu"}{...}
{viewerjumpto "Description" "lrtest##description"}{...}
{viewerjumpto "Links to PDF documentation" "lrtest##linkspdf"}{...}
{viewerjumpto "Options" "lrtest##options"}{...}
{viewerjumpto "Remarks" "lrtest##remarks"}{...}
{viewerjumpto "Examples" "lrtest##examples"}{...}
{viewerjumpto "Stored results" "lrtest##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] lrtest} {hline 2}}Likelihood-ratio test after estimation{p_end}
{p2col:}({mansection R lrtest:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}{cmd:lrtest} {it:modelspec1} [{it:modelspec2}] [{cmd:,} {it:options}]

{phang}
{it:modelspec1} and {it:modelspec2} specify the restricted and unrestricted
model in any order.  {it:modelspec#} is

                {it:name}{c |}{cmd:.}{c |} {cmd:(}{it:namelist}{cmd:)}

{pmore}
{it:name} is the name under which estimation results were stored using
{helpb estimates store:estimates store}, and "{cmd:.}" refers to the last
estimation results, whether or not these were already stored.
If {it:modelspec2}
is not specified, the last estimation result is used; this is equivalent to
specifying {it:modelspec2} as "{cmd:.}".

{pmore}
If {it:namelist} is specified for a composite model, {it:modelspec1} and
{it:modelspec2} cannot have names in common; for example,
{cmd:lrtest {bind:(A B C)} {bind:(C D E)}} is not allowed because both model
specifications include {cmd:C}.


{synoptset 11}{...}
{synopthdr}
{synoptline}
{synopt :{opt st:ats}}display statistical information about the two
models{p_end}
{synopt :{opt di:r}}display descriptive information about the two models{p_end}
{synopt :{opt d:f(#)}}override the automatic degrees-of-freedom
calculation; seldom used{p_end}
{synopt :{opt force}}force testing even when apparently invalid{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:lrtest} performs a likelihood-ratio test of the null hypothesis that
the parameter vector of a statistical model satisfies some smooth constraint.
To conduct the test, both the unrestricted and the restricted models must 
be fit using the maximum likelihood method (or some equivalent method),
and the results of at least one must be stored using 
{helpb estimates store:estimates store}.

{pstd}
{cmd:lrtest} also supports composite models.
In a composite model, we assume that the log likelihood and
dimension (number of free parameters) of the full model are obtained as the
sum of the log-likelihood values and dimensions of the constituting models.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R lrtestQuickstart:Quick start}

        {mansection R lrtestRemarksandexamples:Remarks and examples}

        {mansection R lrtestMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt stats} displays statistical information about the unrestricted and
restricted models, including the information indices of Akaike and Schwarz.

{phang}
{opt dir} displays descriptive information about the unrestricted and
restricted models; see {cmd:estimates dir} in
{helpb estimates store:[R] estimates store}.

{phang}
{opt df(#)} is seldom specified; it overrides the automatic degrees-of-freedom
calculation.  

{phang}
{opt force} forces the likelihood-ratio test calculations to take place in
situations where {cmd:lrtest} would normally refuse to do so and issue an
error.  Such situations arise when one or more assumptions of the test are
violated, for example, if the models were fit with {cmd:vce(robust)},
{cmd:vce(cluster} {it:clustvar}{cmd:)}, or {helpb weight:pweight}s; when the
dependent variables in the two models differ; when the null log likelihoods
differ; when the samples differ; or when the estimation commands differ.  If
you use the {opt force} option, there is no guarantee as to the validity or
interpretability of the resulting test.


{marker remarks}{...}
{title:Remarks}

{pstd}
Under weak regularity conditions, the LR test statistic is approximately
chi-square distributed with degrees of freedom equal to the difference of
the dimensions of the unrestricted and restricted model (that is, the
difference of the numbers of unrestricted and restricted parameters) if
the true parameter vector indeed satisfies the restricted model and if
we are not "on a boundary of the parameter space".  The latter condition
is not satisfied, for instance, if we are  testing whether the variance
of a mixing distribution equals zero ({help j_chibar:click here} for more
information).  {cmd:lrtest} cannot discern whether it is being
invoked under such conditions, and it always produces p-values assuming
that the standard regularity conditions are satisfied.

{pstd}
{cmd:lrtest} provides an important alternative to {help test:Wald testing} for
models fit by maximum likelihood.  Wald testing requires fitting only one
model (the unrestricted model).  Hence, it is computationally more attractive
than likelihood-ratio testing.  Most statisticians, however, favor using
likelihood-ratio testing whenever feasible because the null-distribution of the
LR test statistic is often more closely chi-squared distributed than the Wald
test statistic.


{marker examples}{...}
{title:Examples with nested models}

{phang}{cmd:. webuse lbw}{p_end}
{phang}{cmd:. logit low age lwt i.race smoke ptl ht ui}{p_end}
{phang}{cmd:. estimates store A}{p_end}
{phang}{cmd:. logit low lwt i.race smoke ht ui}{p_end}
{phang}{cmd:. estimates store B}{p_end}
{phang}{cmd:. lrtest A .}{p_end}
{phang}{cmd:. lrtest A}{space 6}(equivalent to above command){p_end}
{phang}{cmd:. lrtest A B}{space 4}(equivalent to above command){p_end}
{phang}{cmd:. logit low lwt smoke ht ui}{p_end}
{phang}{cmd:. estimates store C}{p_end}
{phang}{cmd:. lrtest B}{p_end}
{phang}{cmd:. lrtest C A, stats}{p_end}


{title:Examples with composite models}

{pstd}
We want to test in {helpb heckman} that participation decision is stochastically
independent of the outcome (wage rate).  If this correlation is 0, Heckman's
model is equivalent to the combination of a {cmd:regress} for the outcome and
a {cmd:probit} model for participation.

{phang}{cmd:. webuse womenwk}{p_end}
{phang}{cmd:. heckman wage educ age, select(married children educ age)}{p_end}
{phang}{cmd:. estimates store H}{p_end}
{phang}{cmd:. regress wage educ age}{p_end}
{phang}{cmd:. estimates store R}{p_end}
{phang}{cmd:. generate dinc = !missing(wage)}{p_end}
{phang}{cmd:. probit dinc married children educ age}{p_end}
{phang}{cmd:. estimates store P}{p_end}
{phang}{cmd:. lrtest H (R P), df(1)}{p_end}

{pstd}
Chow-type tests are appropriate for hypotheses that specify that all
coefficients of a model do not vary between disjointed subsets of the data.

{phang}{cmd:. webuse vote, clear}{p_end}
{phang}{cmd:. logit vote age moinc dependents}{p_end}
{phang}{cmd:. estimates store All}{p_end}
{phang}{cmd:. logit vote age moinc dependents if county==1}{p_end}
{phang}{cmd:. estimates store A1}{p_end}
{phang}{cmd:. logit vote age moinc dependents if county==2}{p_end}
{phang}{cmd:. estimates store A2}{p_end}
{phang}{cmd:. logit vote age moinc dependents if county==3}{p_end}
{phang}{cmd:. estimates store A3}{p_end}
{phang}{cmd:. lrtest (All) (A1 A2 A3), df(7)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:lrtest} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(p)}}p-value for likelihood-ratio test{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
{synopt:{cmd:r(chi2)}}LR test statistic{p_end}

{pstd}
Programmers wishing their estimation  commands to be compatible with
{cmd:lrtest} should note that {cmd:lrtest} requires that the following results
be returned:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: }{p_end}
{synopt:{cmd:e(cmd)}}name of estimation command{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}

{pstd}
{cmd:lrtest} also verifies that {cmd:e(N)}, {cmd:e(ll_0)}, and {cmd:e(depvar)}
are consistent between two noncomposite models.{p_end}
{p2colreset}{...}
