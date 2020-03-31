{smcl}
{* *! version 1.0.6  13dec2018}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "mansection BAYES Bayesianestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "[BAYES] bayesmh evaluators" "help bayesmh_evaluators"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Description" "bayesian_estimation##description"}{...}
{viewerjumpto "Video examples" "bayesian_estimation##video"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[BAYES] Bayesian estimation} {hline 2}}Bayesian estimation commands{p_end}
{p2col:}({mansection BAYES Bayesianestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Bayesian estimation in Stata is similar to standard estimation -- simply
prefix the estimation commands with {cmd:bayes:} (see {manhelp bayes BAYES}).
You can also refer to {manhelp bayesmh BAYES} and
{manhelp bayesmh_evaluators BAYES:bayesmh evaluators} for fitting more general
Bayesian models.

{marker estimation_command}{...}
{pstd}
The following estimation commands support the {opt bayes} prefix.

{synoptset 39 tabbed}{...}
{synopt:Command{space 4}Entry}Description{p_end}
{synoptline}
{syntab:Linear regression models}
{synopt :{cmd:regress}{space 5}{manhelp bayes_regress BAYES:bayes: regress}}Linear regression{p_end}
{synopt :{cmd:hetregress}{space 2}{manhelp bayes_hetregress BAYES:bayes: hetregress}}Heteroskedastic linear regressions{p_end}
{synopt :{cmd:tobit}{space 7}{manhelp bayes_tobit BAYES:bayes: tobit}}Tobit regression{p_end}
{synopt :{cmd:intreg}{space 6}{manhelp bayes_intreg BAYES:bayes: intreg}}Interval regression{p_end}
{synopt :{cmd:truncreg}{space 4}{manhelp bayes_truncreg BAYES:bayes: truncreg}}Truncated regression{p_end}
{synopt :{cmd:mvreg}{space 7}{manhelp bayes_mvreg BAYES:bayes: mvreg}}Multivariate regression{p_end}

{syntab:Binary-response regression models}
{synopt :{cmd:logistic}{space 4}{manhelp bayes_logistic BAYES:bayes: logistic}}Logistic regression, reporting odds ratios{p_end}
{synopt :{cmd:logit}{space 7}{manhelp bayes_logit BAYES:bayes: logit}}Logistic regression, reporting coefficients{p_end}
{synopt :{cmd:probit}{space 6}{manhelp bayes_probit BAYES:bayes: probit}}Probit regression{p_end}
{synopt :{cmd:cloglog}{space 5}{manhelp bayes_cloglog BAYES:bayes: cloglog}}Complementary log-log regression{p_end}
{synopt :{cmd:hetprobit}{space 3}{manhelp bayes_hetprobit BAYES:bayes: hetprobit}}Heteroskedastic probit regressions{p_end}
{synopt :{cmd:binreg}{space 6}{manhelp bayes_binreg BAYES:bayes: binreg}}GLM for the binomial family{p_end}
{synopt :{cmd:biprobit}{space 4}{manhelp bayes_biprobit BAYES:bayes: biprobit}}Bivariate probit regression{p_end}

{syntab:Ordinal-response regression models}
{synopt :{cmd:ologit}{space 6}{manhelp bayes_ologit BAYES:bayes: ologit}}Ordered logistic regression{p_end}
{synopt :{cmd:oprobit}{space 5}{manhelp bayes_oprobit BAYES:bayes: oprobit}}Ordered probit regression{p_end}
{synopt :{cmd:hetoprobit}{space 2}{manhelp bayes_hetoprobit BAYES:bayes: hetoprobit}}Heteroskedastic ordered probit regression{p_end}
{synopt :{cmd:zioprobit}{space 3}{manhelp bayes_zioprobit BAYES:bayes: zioprobit}}Zero-inflated ordered probit regression{p_end}

{syntab:Categorical-response regression models}
{synopt :{cmd:mlogit}{space 6}{manhelp bayes_mlogit BAYES:bayes: mlogit}}Multinomial (polytomous) logistic regression{p_end}
{synopt :{cmd:mprobit}{space 5}{manhelp bayes_mprobit BAYES:bayes: mprobit}}Multinomial probit regression{p_end}
{synopt :{cmd:clogit}{space 6}{manhelp bayes_clogit BAYES:bayes: clogit}}Conditional logistic regression{p_end}

{syntab:Count-response regression models}
{synopt :{cmd:poisson}{space 5}{manhelp bayes_poisson BAYES:bayes: poisson}}Poisson regression{p_end}
{synopt :{cmd:nbreg}{space 7}{manhelp bayes_nbreg BAYES:bayes: nbreg}}Negative binomial regression{p_end}
{synopt :{cmd:gnbreg}{space 6}{manhelp bayes_gnbreg BAYES:bayes: gnbreg}}Generalized negative binomial regression{p_end}
{synopt :{cmd:tpoisson}{space 4}{manhelp bayes_tpoisson BAYES:bayes: tpoisson}}Truncated Poisson regression{p_end}
{synopt :{cmd:tnbreg}{space 6}{manhelp bayes_tnbreg BAYES:bayes: tnbreg}}Truncated negative binomial regression{p_end}
{synopt :{cmd:zip}{space 9}{manhelp bayes_zip BAYES:bayes: zip}}Zero-inflated Poisson regression{p_end}
{synopt :{cmd:zinb}{space 8}{manhelp bayes_zinb BAYES:bayes: zinb}}Zero-inflated negative binomial regression{p_end}

{syntab:Generalized linear models}
{synopt :{cmd:glm}{space 9}{manhelp bayes_glm BAYES:bayes: glm}}Generalized linear models{p_end}

{syntab:Fractional-response regression models}
{synopt :{cmd:fracreg}{space 5}{manhelp bayes_fracreg BAYES:bayes: fracreg}}Fractional response regression{p_end}
{synopt :{cmd:betareg}{space 5}{manhelp bayes_betareg BAYES:bayes: betareg}}Beta regression{p_end}

{syntab:Survival regression models}
{synopt :{cmd:streg}{space 7}{manhelp bayes_streg BAYES:bayes: streg}}Parametric survival models{p_end}

{syntab:Sample-selection regression models}
{synopt :{cmd:heckman}{space 5}{manhelp bayes_heckman BAYES:bayes: heckman}}Heckman selection model{p_end}
{synopt :{cmd:heckprobit}{space 2}{manhelp bayes_heckprobit BAYES:bayes: heckprobit}}Probit model with sample selection{p_end}
{synopt :{cmd:heckoprobit}{space 1}{manhelp bayes_heckoprobit BAYES:bayes: heckoprobit}}Ordered probit model with sample selection{p_end}

{marker multilevel}{...}
{syntab:Multilevel regression models}
{synopt :{cmd:mixed}{space 7}{manhelp bayes_mixed BAYES:bayes: mixed}}Multilevel linear regression{p_end}
{synopt :{cmd:metobit}{space 5}{manhelp bayes_metobit BAYES:bayes: metobit}}Multilevel tobit regression{p_end}
{synopt :{cmd:meintreg}{space 4}{manhelp bayes_meintreg BAYES:bayes: meintreg}}Multilevel interval regression{p_end}
{synopt :{cmd:melogit}{space 5}{manhelp bayes_melogit BAYES:bayes: melogit}}Multilevel logistic regression{p_end}
{synopt :{cmd:meprobit}{space 4}{manhelp bayes_meprobit BAYES:bayes: meprobit}}Multilevel probit regression{p_end}
{synopt :{cmd:mecloglog}{space 3}{manhelp bayes_mecloglog BAYES:bayes: mecloglog}}Multilevel complementary log-log regression{p_end}
{synopt :{cmd:meologit}{space 4}{manhelp bayes_meologit BAYES:bayes: meologit}}Multilevel ordered logistic regression{p_end}
{synopt :{cmd:meoprobit}{space 3}{manhelp bayes_meoprobit BAYES:bayes: meoprobit}}Multilevel ordered probit regression{p_end}
{synopt :{cmd:mepoisson}{space 3}{manhelp bayes_mepoisson BAYES:bayes: mepoisson}}Multilevel Poisson regression{p_end}
{synopt :{cmd:menbreg}{space 5}{manhelp bayes_menbreg BAYES:bayes: menbreg}}Multilevel negative binomial regression{p_end}
{synopt :{cmd:meglm}{space 7}{manhelp bayes_meglm BAYES:bayes: meglm}}Multilevel generalized linear model{p_end}
{synopt :{cmd:mestreg}{space 5}{manhelp bayes_mestreg BAYES:bayes: mestreg}}Multilevel parametric survival regression{p_end}
{synoptline}
{p2colreset}{...}


{marker video}{...}
{title:Video examples}

{phang}
{browse "https://youtu.be/0F0QoMCSKJ4":Introduction to Bayesian statistics, part 1: The basic concepts}

{phang}
{browse "https://youtu.be/OTO1DygELpY":Introduction to Bayesian statistics, part 2: MCMC and the Metropolis-Hastings algorithm}
{p_end}
