{smcl}
{* *! version 1.0.4  19oct2017}{...}
{vieweralsosee "[FMM] fmm estimation" "mansection FMM fmmestimation"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "[FMM] Glossary" "help fmm glossary"}{...}
{viewerjumpto "Description" "fmm_estimation##description"}{...}
{viewerjumpto "Linear regression models" "fmm_estimation##linear"}{...}
{viewerjumpto "Binary-response regression models" "fmm_estimation##binary"}{...}
{viewerjumpto "Ordinal-response regression models" "fmm_estimation##ordinal"}{...}
{viewerjumpto "Categorical-response regression models" "fmm_estimation##categorical"}{...}
{viewerjumpto "Count-response regression models" "fmm_estimation##count"}{...}
{viewerjumpto "Generalized linear models" "fmm_estimation##glm"}{...}
{viewerjumpto "Fractional-response regression models" "fmm_estimation##fractional"}{...}
{viewerjumpto "Survival regression models" "fmm_estimation##survival"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[FMM] fmm estimation} {hline 2}}Fitting finite mixture models
{p_end}
{p2col:}({mansection FMM fmmestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Finite mixture models (FMMs) are used to classify observations, to adjust for
clustering, and to model unobserved heterogeneity.  In finite mixture
modeling, the observed data are assumed to belong to several unobserved
subpopulations called classes, and mixtures of probability densities or
regression models are used to model the outcome of interest.  After fitting
the model, class membership probabilities can also be predicted for each
observation.


{p2colset 5 37 39 2}{...}
{pstd}
{marker linear}{...}
{bf:Linear regression models}

{p2col :{helpb fmm regress:[FMM] fmm: regress}}Linear regression{p_end}
{p2col :{helpb fmm truncreg:[FMM] fmm: truncreg}}Truncated regression{p_end}
{p2col :{helpb fmm intreg:[FMM] fmm: intreg}}Interval regression{p_end}
{p2col :{helpb fmm tobit:[FMM] fmm: tobit}}Tobit regression{p_end}
{p2col :{helpb fmm ivregress:[FMM] fmm: ivregress}}Instrumental-variables regression{p_end}


{pstd}
{marker binary}{...}
{bf:Binary-response regression models}

{p2col :{helpb fmm logit:[FMM] fmm: logit}}Logistic regression, reporting
coefficients{p_end}
{p2col :{helpb fmm probit:[FMM] fmm: probit}}Probit regression{p_end}
{p2col :{helpb fmm cloglog:[FMM] fmm: cloglog}}Complementary log-log regression{p_end}


{pstd}
{marker ordinal}{...}
{bf:Ordinal-response regression models}

{p2col :{helpb fmm ologit:[FMM] fmm: ologit}}Ordered logistic regression{p_end}
{p2col :{helpb fmm oprobit:[FMM] fmm: oprobit}}Ordered probit regression{p_end}


{pstd}
{marker categorical}{...}
{bf:Categorical-response regression models}

{p2col :{helpb fmm mlogit:[FMM] fmm: mlogit}}Multinomial (polytomous) logistic
regression{p_end}


{pstd}
{marker count}{...}
{bf:Count-response regression models}

{p2col :{helpb fmm poisson:[FMM] fmm: poisson}}Poisson regression{p_end}
{p2col :{helpb fmm nbreg:[FMM] fmm: nbreg}}Negative binomial regression{p_end}
{p2col :{helpb fmm tpoisson:[FMM] fmm: tpoisson}}Truncated Poisson regression{p_end}


{pstd}
{marker glm}{...}
{bf:Generalized linear models}

{p2col :{helpb fmm glm:[FMM] fmm: glm}}Generalized linear models{p_end}


{pstd}
{marker fractional}{...}
{bf:Fractional-response regression models}

{p2col :{helpb fmm betareg:[FMM] fmm: betareg}}Beta regression{p_end}


{pstd}
{marker survival}{...}
{bf:Survival regression models}

{p2col :{helpb fmm streg:[FMM] fmm: streg}}Parametric survival models{p_end}


{pstd}
{cmd:fmm:} allows different regression models for different components of the
mixture; see {manhelp fmm FMM}. {cmd:fmm:} also allows one or more components
to be a degenerate distribution taking on a single integer value with
probability one; see {manhelp fmm_pointmass FMM:fmm: pointmass}.
{p_end}
