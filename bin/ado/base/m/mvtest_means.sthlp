{smcl}
{* *! version 1.1.33  19oct2017}{...}
{viewerdialog mvtest "dialog mvtest"}{...}
{vieweralsosee "[MV] mvtest means" "mansection MV mvtestmeans"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] hotelling" "help hotelling"}{...}
{vieweralsosee "[MV] manova" "help manova"}{...}
{vieweralsosee "[R] mean" "help mean"}{...}
{vieweralsosee "[R] ttest" "help ttest"}{...}
{viewerjumpto "Syntax" "mvtest_means##syntax"}{...}
{viewerjumpto "Menu" "mvtest_means##menu"}{...}
{viewerjumpto "Description" "mvtest_means##description"}{...}
{viewerjumpto "Links to PDF documentation" "mvtest_means##linkspdf"}{...}
{viewerjumpto "Options for multiple-sample tests" "mvtest_means##options_multi"}{...}
{viewerjumpto "Options for one-sample tests" "mvtest_means##options_one"}{...}
{viewerjumpto "Examples" "mvtest_means##examples"}{...}
{viewerjumpto "Stored results" "mvtest_means##results"}{...}
{viewerjumpto "References" "mvtest_means##references"}{...}
{p2colset 1 22 18 2}{...}
{p2col:{bf:[MV] mvtest means} {hline 2}}Multivariate tests of means{p_end}
{p2col:}({mansection MV mvtestmeans:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Multiple-sample tests

{p 8 16 2}
{cmd:mvtest} {cmdab:m:eans} {varlist} {ifin}
[{it:{help mvtest means##weight:weight}}]{cmd:,}
{opth by:(varlist:groupvars)}
[{help mvtest_means##multisample_options:{it:multisample_options}}]


{pstd}
One-sample tests

{p 8 16 2}
{cmd:mvtest} {cmdab:m:eans} {varlist} {ifin}
[{it:{help mvtest means##weight:weight}}]
[{cmd:,}
{help mvtest_means##one-sample_options:{it:one-sample_options}}]


{synoptset 20 tabbed}{...}
{marker multisample_options}{...}
{synopthdr:multisample_options}
{synoptline}
{syntab:Model}
{p2coldent:* {opth by:(varlist:groupvars)}}compare subsamples with same
	values in {it:groupvars}{p_end}
{synopt:{opt miss:ing}}treat missing values in {it:groupvars} as ordinary
	values {p_end}

{syntab:Options}
{synopt:{opt hom:ogeneous}}test for equal means with homogeneous
	covariance matrices across by-groups; the default{p_end}
{synopt:{opt het:erogeneous}}James's test for equal means, allowing
	heterogeneous covariance matrices across by-groups{p_end}
{synopt:{opt lr}}likelihood-ratio test for equal means, allowing heterogeneous
	covariance matrices across by-groups{p_end}
{synopt:{cmdab:prot:ect(}{it:{help mvtest_means##spec:spec}}{cmd:)}}run
        protection as a safeguard against local minimum with the group means
        as initial values; use only with {cmd:lr} option{p_end}
{synoptline}
{p 4 6 2}* {opt by(groupvars)} is required.

{synoptset 20 tabbed}{...}
{marker one-sample_options}{...}
{synopthdr:one-sample_options}
{synoptline}
{syntab:Options}
{synopt:{opt e:qual}}test that variables in {varlist} have equal means; the
	default{p_end}
{synopt:{opt z:ero}}test that means of {varlist} are all equal to 0{p_end}
{synopt:{opt e:quals(M)}}test that mean vector equals vector {it:M}{p_end}
{synopt:{opt l:inear(V)}}test that mean vector of {varlist} satisfies linear
	hypothesis described by matrix {it:V}{p_end}
{synoptline}

{p 4 6 2}
{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:rolling}, and {cmd:statsby}
are allowed; see {help prefix}.{p_end}
{p 4 6 2}
Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:aweight}s and {cmd:fweight}s are allowed;
see {help weight}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis > MANOVA, multivariate regression,}
           {bf:and related > Multivariate test of means, covariances, and}
           {bf:normality}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mvtest means} performs one-sample and multiple-sample multivariate tests
on means.  These tests assume multivariate normality.

{pstd}
See {manhelp mvtest MV} for other multivariate tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV mvtestmeansQuickstart:Quick start}

        {mansection MV mvtestmeansRemarksandexamples:Remarks and examples}

        {mansection MV mvtestmeansMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_multi}{...}
{title:Options for multiple-sample tests}

{dlgtab:Model}

{phang}
{opth by:(varlist:groupvars)} is required with the multiple-sample version of
the test.  Observations with the same values in {it:groupvars} form a sample.
Observations with missing values in {it:groupvars} are ignored, unless the
{cmd:missing} option is specified.

{phang}
{opt missing} specifies that missing values in {it:groupvars} are treated like
ordinary values.

{dlgtab:Options}

{phang}
{cmd: homogeneous}, the default, specifies the hypothesis that the mean
vectors are the same across the by-groups, assuming homogeneous
covariance matrices across the by-groups.  {cmd:homogeneous} produces
the four standard tests of multivariate means (Wilks's lambda, Pillai's trace,
Lawley-Hotelling trace, and Roy's largest root).

{phang}
{cmd:heterogeneous} removes the assumption that the covariance matrices are
the same across the by-groups.  This is the multivariate Behrens-Fisher
problem.  With two groups, the MNV test, an affine-invariant modification by
{help mvtest means##KY2004:Krishnamoorthy and Yu (2004)} of the
{help mvtest means##NM1986:Nel-Van der Merwe (1986)} test, is displayed.
With more than two groups, the Wald test, with p-values adjusted as proposed
by {help mvtest means##J1954:James (1954)}, is displayed.

{phang}
{opt lr} removes the assumption that the covariance matrices are the same
across the by-groups and specifies that a likelihood-ratio test be
presented.  The associated estimation problem may have multiple local optima,
though this seems rare with two groups.

{phang}
{marker spec}{...}
{opt protect(spec)} is a technical option accompanying {cmd:lr}, specifying 
that the "common means" model is fit from different starting values
to ascertain with some confidence whether a global optimum to the underlying 
estimation problem was reached.  The Mardia-Kent-Bibby
({help mvtest means##MKB1979:1979}) proposal 
for initialization of the common means is always used as well.  If the
different trials do not converge to the same solution, the "best" one is used
to obtain the test, and a warning message is displayed.

{phang2}
{cmd:protect(groups)} specifies to fit the common means model 
using each of the group means as starting values for the common means.

{phang2}
{cmd:protect(randobs, reps(}{it:#}{cmd:))} specifies to fit the common means
model using {it:#} random observations as starting values for the common means.

{phang2}
{opt protect(#)} is a convenient shorthand for
{cmd:protect(randobs, reps(}{it:#}{cmd:))}.


{marker options_one}{...}
{title:Options with one-sample tests}

{dlgtab:Options}

{phang}
{cmd:equal} performs Hotelling's test of the hypothesis that the means of all
variables in {varlist} are equal.

{phang}
{cmd:zero} performs Hotelling's test of the hypothesis that the means of all
variables in {varlist} are 0.

{phang}
{cmd:equals(}{it:M}{cmd:)} performs Hotelling's test that the vector of means
of the k variables in {varlist} equals {it:M}.  The matrix {it:M} must be a
kx1 or 1xk vector.  The row and column names of {it:M} are ignored.

{phang}
{cmd:linear(}{it:V}{cmd:)} performs Hotelling's test that the means satisfy a
user-specified set of linear constraints, represented by {it:V}.  {it:V} must
be a matrix vector with k or k+1 columns, where k is the number of variables
in {varlist}.  Let {it:A} be a matrix of the first k columns of {it:V}.
Let {it:b} be the last column of {it:V} if {it:V} has k+1 columns and a column
of 0s otherwise.  The linear hypothesis test is that {it:A} times a column
vector of the means of {it:varlist} equals {it:b}.  {cmd:mvtest} ignores
matrix row and column names.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse milktruck}{p_end}

{pstd}Test that the means of the variables are equal{p_end}
{phang2}{cmd:. mvtest means fuel repair capital, equal}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse turnip}{p_end}

{pstd}Test that the means of the variables equal a given vector{p_end}
{phang2}{cmd:. matrix Mstd = (15.0, 6.0, 2.85)}{p_end}
{phang2}{cmd:. mvtest means y*, equals(Mstd)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse metabolic}{p_end}

{pstd}Test that the means are equal for the groups, assuming equality of
covariance matrices{p_end}
{phang2}{cmd:. mvtest means y1 y2, by(group)}{p_end}

{pstd}Test that the means are equal for the first 3 groups, allowing for
heterogeneity{p_end}
{phang2}{cmd:. mvtest means y1 y2 if group<4, by(group) heterogeneous}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mvtest means} without the {cmd:by()} option (that is, a one-sample means
test) stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(T2)}}Hotelling T-squared{p_end}
{synopt:{cmd:r(F)}}F statistic{p_end}
{synopt:{cmd:r(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:r(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:r(p_F)}}p-value for F test{p_end}

{p2col 5 20 24 2:Macros}{p_end}
{synopt:{cmd:r(Ftype)}}type of model F test{p_end}

{pstd}
{cmd:mvtest means} with {cmd:by()} but without {cmd:lr} or {cmd:heterogeneous}
options (that is, a multiple-sample means test, assuming homogeneity) stores the
following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(F)}}F statistic{p_end}
{synopt:{cmd:r(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:r(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:r(p_F)}}p-value for F test{p_end}

{p2col 5 20 24 2:Macros}{p_end}
{synopt:{cmd:r(Ftype)}}type of model F test{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:r(stat_m)}}MANOVA model tests{p_end}

{pstd}
{cmd:mvtest means} with {cmd:by()} defining two groups and with the
{cmd:heterogeneous} option (that is, a two-sample test of means, allowing for
heterogeneity) stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(F)}}F statistic{p_end}
{synopt:{cmd:r(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:r(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:r(p_F)}}p-value for F test{p_end}

{p2col 5 20 24 2:Macros}{p_end}
{synopt:{cmd:r(Ftype)}}type of model F test{p_end}

{pstd}
{cmd:mvtest means} with {cmd:by()} defining more than two groups and with the
{cmd:heterogeneous} option (that is, a multiple-sample test of means, allowing
for heterogeneity) stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(chi2)}}chi-squared statistic{p_end}
{synopt:{cmd:r(df)}}degrees of freedom for chi-squared test{p_end}
{synopt:{cmd:r(p_chi2)}}p-value for chi-squared test{p_end}
{synopt:{cmd:r(p_chi2_James)}}p-value for Wald test via James's approximation{p_end}

{p2col 5 20 24 2:Macros}{p_end}
{synopt:{cmd:r(chi2type)}}type of model chi-squared test{p_end}

{pstd}
{cmd:mvtest means} with the {cmd:by()} and {cmd:lr} options (that is, a
likelihood-ratio multiple-sample test of means, allowing for heterogeneity)
stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(chi2)}}chi-squared statistic{p_end}
{synopt:{cmd:r(df)}}degrees of freedom for chi-squared test{p_end}
{synopt:{cmd:r(p_chi2)}}p-value for chi-squared test{p_end}
{synopt:{cmd:r(rc)}}return code{p_end}
{synopt:{cmd:r(uniq)}}1/0 if protection runs yielded/did not yield same
	solution ({cmd:protect()} only){p_end}
{synopt:{cmd:r(nprotect)}}number of protection runs ({cmd:protect()}
	only){p_end}

{p2col 5 20 24 2:Macros}{p_end}
{synopt:{cmd:r(chi2type)}}type of model chi-squared test{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:r(M)}}maximum likelihood estimate of means{p_end}


{marker references}{...}
{title:References}

{marker J1954}{...}
{phang}
James, G. S.  1954.  Tests of linear hypotheses in univariate and multivariate
analysis when the ratios of the population variances are unknown.
{it:Biometrika} 41: 19-43.

{marker KY2004}{...}
{phang}
Krishnamoorthy, K., and J. Yu. 2004.  Modified Nel and Van der Merwe test for
the multivariate Behrens-Fisher problem.
{it:Statistics and Probability Letters} 66: 161-169.

{marker MKB1979}{...}
{phang}
Mardia, K. V., J. T. Kent, and J. M. Bibby. 1979. {it:Multivariate Analysis}.
London: Academic Press.

{marker NM1986}{...}
{phang}
Nel, D. G., and C. A. Van Der Merwe. 1986. A solution to the multivariate
Behrens-Fisher problem.
{it:Communications in Statistics, Theory and Methods} 15: 3719-3735.
{p_end}
