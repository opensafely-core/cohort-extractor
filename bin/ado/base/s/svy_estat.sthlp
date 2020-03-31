{smcl}
{* *! version 1.4.22  24jan2019}{...}
{viewerdialog estat "dialog svy_estat"}{...}
{vieweralsosee "[SVY] estat" "mansection SVY estat"}{...}
{vieweralsosee "[SVY] Subpopulation estimation" "mansection SVY Subpopulationestimation"}{...}
{vieweralsosee "[SVY] Variance estimation" "mansection SVY Varianceestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{vieweralsosee "[SVY] svy postestimation" "help svy_postestimation"}{...}
{viewerjumpto "Syntax" "svy_estat##syntax"}{...}
{viewerjumpto "Menu" "svy_estat##menu"}{...}
{viewerjumpto "Description" "svy_estat##description"}{...}
{viewerjumpto "Links to PDF documentation" "svy_estat##linkspdf"}{...}
{viewerjumpto "Options for estat effects" "svy_estat##options_estat_effects"}{...}
{viewerjumpto "Options for estat lceffects" "svy_estat##options_estat_lceffects"}{...}
{viewerjumpto "Options for estat size" "svy_estat##options_estat_size"}{...}
{viewerjumpto "Options for estat sd" "svy_estat##options_estat_sd"}{...}
{viewerjumpto "Options for estat cv" "svy_estat##options_estat_cv"}{...}
{viewerjumpto "Options for estat gof" "svy_estat##options_estat_gof"}{...}
{viewerjumpto "Options for estat vce" "svy_estat##options_estat_vce"}{...}
{viewerjumpto "Examples" "svy_estat##examples"}{...}
{viewerjumpto "Stored results" "svy_estat##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[SVY] estat} {hline 2}}Postestimation statistics for survey data
{p_end}
{p2col:}({mansection SVY estat:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Survey design characteristics

{phang2}
{cmd:estat} {opt svyset}


{phang}
Design and misspecification effects for point estimates

{phang2}
{cmd:estat} {opt eff:ects}
	[{cmd:,} {it:{help svy_estat##effects_options:estat_effects_options}}]


{phang}
Design and misspecification effects for linear combinations of point estimates

{phang2}
{cmd:estat} {opt lceff:ects} {it:exp}
	[{cmd:,} {it:{help svy_estat##lceffects_options:estat_lceffects_options}}]


{phang}
Subpopulation sizes

{phang2}
{cmd:estat} {opt size}
	[{cmd:,} {it:{help svy_estat##size_options:estat_size_options}}]


{marker estatsd}{...}
{phang}
Subpopulation standard-deviation estimates

{phang2}
{cmd:estat} {opt sd}
	[{cmd:,} {it:{help svy_estat##sd_options:estat_sd_options}}]


{phang}
Singleton and certainty strata

{phang2}
{cmd:estat} {opt strata}


{phang}
Coefficient of variation for survey data

{phang2}
{cmd:estat} {opt cv}
	[{cmd:,} {it:{help svy_estat##cv_options:estat_cv_options}}]


{phang}
Goodness-of-fit test for binary response models using survey data

{phang2}
{cmd:estat} {opt gof}
	{ifin} [{cmd:,} {it:{help svy_estat##gof_options:estat_gof_options}}]


{phang}
Display covariance matrix estimates

{phang2}
{cmd:estat} {opt vce}
	[{cmd:,} {it:{help estat vce##estat_vce_options:estat_vce_options}}]


{synoptset 29}{...}
{marker effects_options}{...}
{synopthdr:estat_effects_options}
{p2line}
{p2col :{opt deff}}report DEFF design effects{p_end}
{p2col :{opt deft}}report DEFT design effects{p_end}
{p2col :{opt srs:subpop}}report
	design effects, assuming SRS within subpopulation{p_end}
{p2col :{opt meff}}report MEFF design effects{p_end}
{p2col :{opt meft}}report MEFT design effects{p_end}
{synopt :{it:{help svy_estat##display_options_effects:display_options}}}control spacing
           and display of omitted variables and base and empty cells{p_end}
{p2line}

{marker lceffects_options}{...}
{synopthdr:estat_lceffects_options}
{p2line}
{p2col :{opt deff}}report DEFF design effects{p_end}
{p2col :{opt deft}}report DEFT design effects{p_end}
{p2col :{opt srs:subpop}}report
	design effects, assuming SRS within subpopulation{p_end}
{p2col :{opt meff}}report MEFF design effects{p_end}
{p2col :{opt meft}}report MEFT design effects{p_end}
{p2line}

{marker size_options}{...}
{synopthdr:estat_size_options}
{p2line}
{p2col :{opt obs}}report number of observations (within subpopulation)
{p_end}
{p2col :{opt size}}report subpopulation sizes{p_end}
{p2line}

{marker sd_options}{...}
{synopthdr:estat_sd_options}
{p2line}
{p2col :{opt var:iance}}report
	subpopulation variances instead of standard deviations{p_end}
{p2col :{opt srs:subpop}}report
	standard deviations, assuming SRS within subpopulation{p_end}
{p2line}

{marker cv_options}{...}
{synopthdr:estat_cv_options}
{p2line}
{synopt :{opt nol:egend}}suppress the table legend{p_end}
{synopt :{it:{help svy_estat##display_options_cv:display_options}}}control spacing
           and display of omitted variables and base and empty cells{p_end}
{p2line}

{marker gof_options}{...}
{synopthdr:estat_gof_options}
{p2line}
{p2col :{opt g:roup(#)}}compute test statistic using {it:#} quantiles{p_end}
{p2col :{opt total}}compute
	test statistic using the total estimator instead of the mean
	estimator{p_end}
{p2col :{opt all}}execute test for all observations in the data{p_end}
{p2line}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survey data analysis > DEFF, MEFF, and other statistics}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat} {cmd:svyset} reports the survey design characteristics associated
with the current estimation results.

{pstd}
{cmd:estat} {cmd:effects} displays a table of design and misspecification
effects for each estimated parameter.

{pstd}
{cmd:estat} {cmd:lceffects} displays a table of design and misspecification
effects for a user-specified linear combination of the parameter estimates.

{pstd}
{cmd:estat} {cmd:size} displays a table of sample and subpopulation sizes for
each estimated subpopulation mean, proportion, ratio, or total.  This
command is available only after
{cmd:svy: mean},
{cmd:svy: proportion},
{cmd:svy: ratio},
and
{cmd:svy: total}; see {manhelp mean R}, {manhelp proportion R},
{manhelp ratio R}, and {manhelp total R}.

{pstd}
{cmd:estat} {cmd:sd} reports subpopulation standard deviations based on the
estimation results from {cmd:mean} and {cmd:svy: mean}; see
{manhelp mean R}.
{cmd:estat} {cmd:sd} is not appropriate with estimation results that used 
direct standardization or poststratification.

{pstd}
{cmd:estat} {cmd:strata} displays a table of the number of singleton and
certainty strata within each sampling stage.
The variance scaling factors are also displayed for estimation results where
{cmd:singleunit(scaled)} was {cmd:svyset}.

{pstd}
{cmd:estat} {cmd:cv} reports the coefficient of variation (CV) for each
coefficient in the current estimation results.  The CV for coefficient {it:b}
is

{pmore2}
CV({it:b}) = SE({it:b})/|{it:b}| x 100%

{pstd}
{cmd:estat} {cmd:gof} reports a goodness-of-fit test for binary response models
using survey data.
This command is available only after
{cmd:svy:} {cmd:logistic},
{cmd:svy:} {cmd:logit},
and {cmd:svy:} {cmd:probit}; see {manhelp logistic R}, 
{manhelp logit R}, and {manhelp probit R}.

{pstd}
{cmd:estat} {cmd:vce} displays the covariance or correlation matrix of the
parameter estimates of the previous model.  See
{manhelp estat_vce R:estat vce} for examples.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SVY estatQuickstart:Quick start}

        {mansection SVY estatRemarksandexamples:Remarks and examples}

        {mansection SVY estatMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_estat_effects}{...}
{title:Options for estat effects}

{phang}
{opt deff} and {opt deft}
request that the design-effect measures DEFF and DEFT be displayed.  This is
the default, unless direct standardization or poststratification was used.

{pmore}
The {opt deff} and {opt deft} options are not allowed with estimation
results that used direct standardization or poststratification. These
methods obscure the measure of design effect because they adjust the frequency
distribution of the target population.

{phang}
{opt srssubpop}
requests that DEFF and DEFT be computed using
an estimate of simple random sampling (SRS) variance for sampling
within a subpopulation.  By default, DEFF and DEFT are computed
using an estimate of the SRS variance for sampling from the entire
population.  Typically, {opt srssubpop} is used when computing
subpopulation estimates by strata or by groups of strata.

{phang}
{opt meff} and {opt meft}
request that the misspecification-effect measures MEFF and MEFT be displayed.

{marker display_options_effects}{...}
{phang}
{it:display_options}:
{opt noomit:ted},
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels};
    see {helpb estimation options##display_options:[R] Estimation options}.


{marker options_estat_lceffects}{...}
{title:Options for estat lceffects}

{phang}
{opt deff} and {opt deft}
request that the design-effect measures DEFF and DEFT be displayed.  This is
the default, unless direct standardization or poststratification was used.

{pmore}
The {opt deff} and {opt deft} options are not allowed with estimation
results that used direct standardization or poststratification. These
methods obscure the measure of design effect because they adjust the frequency
distribution of the target population.

{phang}
{opt srssubpop}
requests that DEFF and DEFT be computed using
an estimate of simple random sampling (SRS) variance for sampling
within a subpopulation.  By default, DEFF and DEFT are computed
using an estimate of the SRS variance for sampling from the entire
population.  Typically, {opt srssubpop} is used when computing
subpopulation estimates by strata or by groups of strata.

{phang}
{opt meff} and {opt meft}
request that the misspecification-effect measures MEFF and MEFT be displayed.


{marker options_estat_size}{...}
{title:Options for estat size}

{phang}
{opt obs} requests that the number of observations used to 
compute the estimate be displayed for each row of estimates.

{phang}
{opt size} requests that the estimate of the subpopulation size be
displayed for each row of estimates.  The subpopulation size estimate equals
the sum of the weights for those observations in the estimation
sample that are also in the specified subpopulation.  The estimated population
size is reported when a subpopulation is not specified.


{marker options_estat_sd}{...}
{title:Options for estat sd}

{phang}
{opt variance}
requests that the subpopulation variance be displayed instead of the standard
deviation.

{phang}
{opt srssubpop}
requests that the standard deviation be computed using
an estimate of SRS variance for sampling
within a subpopulation.  By default, the standard deviation is computed
using an estimate of the SRS variance for sampling from the entire
population.  Typically, {opt srssubpop} is used when computing
subpopulation estimates by strata or by groups of strata.


{marker options_estat_cv}{...}
{title:Options for estat cv}

{phang}
{opt nolegend} prevents the table legend identifying the subpopulations from
being displayed.

{marker display_options_cv}{...}
{phang}
{it:display_options}:
{opt noomit:ted},
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels};
    see {helpb estimation options##display_options:[R] Estimation options}.


{marker options_estat_gof}{...}
{title:Options for estat gof}

{phang}
{opt group(#)}
specifies the number of quantiles to be used to group the data for the
goodness-of-fit test.  The minimum allowed value is {cmd:group(2)}.  The
maximum allowed value is {opt group(df)}, where {it:df} is the
design degrees of freedom ({cmd:e(df_r)}).  The default is {cmd:group(10)}.

{phang}
{opt total}
requests that the goodness-of-fit test statistic be computed
using the total estimator instead of the mean estimator.

{phang}
{opt all}
requests that the goodness-of-fit test statistic be computed
for all observations in the data, ignoring any {cmd:if} or {cmd:in}
restrictions specified with the model fit.


{marker options_estat_vce}{...}
{title:Options for estat vce}

{phang}
See {it:{help estat vce##options_estat_vce:estat_vce_options}}.


{marker examples}{...}
{title:Examples}

    {hline}
{phang2}
{cmd:. webuse nhanes2}
{p_end}
{phang2}
{cmd:. svy: mean tcresult tgresult}
{p_end}
{phang2}
{cmd:. estat svyset}
{p_end}
{phang2}
{cmd:. estat effects, deff deft meff meft}
{p_end}
{phang2}
{cmd:. estat size}
{p_end}

{phang2}
{cmd:. svy: mean tcresult, over(sex)}
{p_end}
{phang2}
{cmd:. estat size}
{p_end}
{phang2}
{cmd:. estat sd}
{p_end}
{phang2}
{cmd:. estat cv}
{p_end}

    {hline}
{pstd}
Design effects for subpopulations

{phang2}
{cmd:. webuse nhanes2b}
{p_end}
{phang2}
{cmd:. svy: mean iron, over(sex)}
{p_end}
{phang2}
{cmd:. estat effects}
{p_end}
{phang2}
{cmd:. estat effects, srssubpop}
{p_end}

{phang2}
{cmd:. webuse nmihs}
{p_end}
{phang2}
{cmd:. svy: mean birthwgt, over(race)}
{p_end}
{phang2}
{cmd:. estat effects}
{p_end}
{phang2}
{cmd:. estat effects, srssubpop}
{p_end}

    {hline}
{pstd}
Misspecification effects for subpopulations

{phang2}
{cmd:. webuse nhanes2b}
{p_end}
{phang2}
{cmd:. svy: mean zinc, over(sex)}
{p_end}
{phang2}
{cmd:. estat effects, meff meft}
{p_end}

    {hline}
{pstd}
Design and misspecification effects for linear combinations

{phang2}
{cmd:. webuse nhanes2b}
{p_end}
{phang2}
{cmd:. svy: mean tcresult, over(sex)}
{p_end}
{phang2}
{cmd:. estat lceffects tcresult#1.sex - tcresult#2.sex, deff deft meff meft}
{p_end}

    {hline}
{pstd}
Using survey data to determine Neyman allocation

{phang2}
{cmd:. webuse nmihs}
{p_end}
{phang2}
{cmd:. svyset [pw=finwgt], strata(stratan)}
{p_end}
{phang2}
{cmd:. svy: mean birthwgt, over(stratan)}
{p_end}

{phang2}
{cmd:. estat size}
{p_end}
{phang2}
{cmd:. matrix p_obs = 100 * r(_N)/e(N)}
{p_end}
{phang2}
{cmd:. matrix nsubp = r(_N_subp)}
{p_end}

{phang2}
{cmd:. estat sd}
{p_end}
{phang2}
{cmd:. matrix p_neyman = 100 * hadamard(nsubp,r(sd))/el(nsubp*r(sd)',1,1)}
{p_end}
{phang2}
{cmd:. matrix list p_obs, format(%4.1f)}
{p_end}
{phang2}
{cmd:. matrix list p_neyman, format(%4.1f)}
{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat svyset} stores the following in {cmd:r()}:

{* If you update results here, also change svyset *}{...}
{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:r(stages)}}number of sampling stages{p_end}
{synopt:{cmd:r(stages_wt)}}last stage containing stage-level weights{p_end}
{synopt:{cmd:r(bsn)}}bootstrap mean-weight adjustment{p_end}
{synopt:{cmd:r(fay)}}Fay's adjustment{p_end}
{synopt:{cmd:r(dof)}}{opt dof()} value{p_end}

{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(wtype)}}weight type{p_end}
{synopt:{cmd:r(wexp)}}weight expression{p_end}
{synopt:{cmd:r(wvar)}}weight variable name{p_end}
{synopt:{cmd:r(weight}{it:#}{cmd:)}}variable identifying weight for stage
                          {it:#}{p_end}
{synopt:{cmd:r(su}{it:#}{cmd:)}}variable identifying sampling units for stage
                          {it:#}{p_end}
{synopt:{cmd:r(strata}{it:#}{cmd:)}}variable identifying strata for stage {it:#}{p_end}
{synopt:{cmd:r(fpc}{it:#}{cmd:)}}FPC for stage {it:#}{p_end}
{synopt:{cmd:r(bsrweight)}}{cmd:bsrweight()} variable list{p_end}
{synopt:{cmd:r(brrweight)}}{cmd:brrweight()} variable list{p_end}
{synopt:{cmd:r(jkrweight)}}{cmd:jkrweight()} variable list{p_end}
{synopt:{cmd:r(sdrweight)}}{cmd:sdrweight()} variable list{p_end}
{synopt:{cmd:r(sdrfpc)}}{cmd:fpc()} value from within {opt sdrweight()}{p_end}
{synopt:{cmd:r(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:r(mse)}}{cmd:mse}, if specified{p_end}
{synopt:{cmd:r(poststrata)}}{cmd:poststrata()} variable{p_end}
{synopt:{cmd:r(postweight)}}{cmd:postweight()} variable{p_end}
{synopt:{cmd:r(rake)}}{cmd:rake()} specification{p_end}
{synopt:{cmd:r(regress)}}{cmd:regress()} specification{p_end}
{synopt:{cmd:r(settings)}}{cmd:svyset} arguments to reproduce the current
settings{p_end}
{synopt:{cmd:r(singleunit)}}{cmd:singleunit()} setting{p_end}

{pstd}
{cmd:estat strata} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(_N_strata_single)}}number of strata with one sampling unit{p_end}
{synopt:{cmd:r(_N_strata_certain)}}number of certainty strata{p_end}
{synopt:{cmd:r(_N_strata)}}number of strata{p_end}
{synopt:{cmd:r(scale)}}variance
	scale factors used when {cmd:singleunit(scaled)} is {cmd:svyset}{p_end}

{pstd}
{cmd:estat effects} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(deff)}}vector of DEFF estimates{p_end}
{synopt:{cmd:r(deft)}}vector of DEFT estimates{p_end}
{synopt:{cmd:r(deffsub)}}vector of DEFF estimates for {cmd:srssubpop}{p_end}
{synopt:{cmd:r(deftsub)}}vector of DEFT estimates for {cmd:srssubpop}{p_end}
{synopt:{cmd:r(meff)}}vector of MEFF estimates{p_end}
{synopt:{cmd:r(meft)}}vector of MEFT estimates{p_end}

{pstd}
{cmd:estat lceffects} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:r(estimate)}}point estimate{p_end}
{synopt:{cmd:r(se)}}estimate of standard error{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
{synopt:{cmd:r(deff)}}DEFF estimate{p_end}
{synopt:{cmd:r(deft)}}DEFT estimate{p_end}
{synopt:{cmd:r(deffsub)}}DEFF estimate for {cmd:srssubpop}{p_end}
{synopt:{cmd:r(deftsub)}}DEFT estimate for {cmd:srssubpop}{p_end}
{synopt:{cmd:r(meff)}}MEFF estimate{p_end}
{synopt:{cmd:r(meft)}}MEFT estimate{p_end}

{pstd}
{cmd:estat size} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(_N)}}vector of numbers of nonmissing observations{p_end}
{synopt:{cmd:r(_N_subp)}}vector of subpopulation size estimates{p_end}

{pstd}
{cmd:estat sd} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(srssubpop)}}{cmd:srssubpop}, if specified{p_end}

{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(mean)}}vector of subpopulation mean estimates{p_end}
{synopt:{cmd:r(sd)}}vector of subpopulation standard-deviation estimates{p_end}
{synopt:{cmd:r(variance)}}vector of subpopulation variance estimates{p_end}

{pstd}
{cmd:estat cv} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(b)}}estimates{p_end}
{synopt:{cmd:r(se)}}standard errors of the estimates{p_end}
{synopt:{cmd:r(cv)}}coefficients of variation of the estimates{p_end}

{pstd}
{cmd:estat gof} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(p)}}p-value associated with the test statistic{p_end}
{synopt:{cmd:r(F)}}F statistic, if {cmd:e(df_r)} was stored by estimation
   command{p_end}
{synopt:{cmd:r(df1)}}numerator degrees of freedom for F statistic{p_end}
{synopt:{cmd:r(df2)}}denominator degrees of freedom for F statistic{p_end}
{synopt:{cmd:r(chi2)}}chi-squared statistic, if {cmd:e(df_r)} was not stored by estimation command{p_end}
{synopt:{cmd:r(df)}}degrees of freedom for chi-squared statistic{p_end}

{pstd}
{cmd:estat vce} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(V)}}VCE or correlation matrix{p_end}
