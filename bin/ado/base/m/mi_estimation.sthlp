{smcl}
{* *! version 1.0.21  06jun2019}{...}
{vieweralsosee "[MI] Estimation" "mansection MI Estimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{vieweralsosee "[MI] mi estimate postestimation" "help mi_estimate_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi import" "help mi_import"}{...}
{vieweralsosee "[MI] mi impute" "help mi_impute"}{...}
{vieweralsosee "[MI] mi set" "help mi_set"}{...}
{vieweralsosee "[MI] Workflow" "help mi_workflow"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] Intro substantive" "help mi intro substantive"}{...}
{vieweralsosee "[MI] Glossary" "help mi_glossary"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[MI] Estimation} {hline 2}}Estimation commands for use with mi estimate{p_end}
{p2col:}({mansection MI Estimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{title:Description}

{pstd}
Multiple-imputation data analysis in Stata is similar to standard data
analysis.  The standard syntax applies, but you need to remember the following
for MI data analysis:

{phang2}
1.  The data must be declared as {cmd:mi} data. 

{pmore2}
If you already have multiply imputed data (saved in Stata format), use 
{helpb mi import} to import it into {cmd:mi}.

{pmore2}
    If you do not have multiply imputed data, use {helpb mi set} to declare
    your original data to be {cmd:mi} data and use {helpb mi impute} to
    fill in missing values.

{phang2}
2.  After you have declared {cmd:mi} data, commands such as
{helpb svyset}, {helpb stset}, and {helpb xtset} cannot be used.
Instead
use {cmd:mi svyset} to declare survey data,
use {cmd:mi stset} to declare survival data, and
use {cmd:mi xtset} to declare panel data.  See
{helpb mi XXXset:[MI] mi XXXset}.

{phang2}
3.  Prefix the estimation commands with {helpb mi_estimate:mi estimate:}.

{marker estimation_command}{...}
{pstd}
The following estimation commands support the {cmd:mi} {cmd:estimate} prefix.

{synoptset 20 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{syntab:Linear regression models}
{synopt :{helpb regress}}Linear regression{p_end}
{synopt :{helpb cnsreg}}Constrained linear regression{p_end}
{synopt :{helpb mvreg}}Multivariate regression{p_end}

{syntab:Binary-response regression models}
{synopt :{helpb logistic}}Logistic regression, reporting odds ratios{p_end}
{synopt :{helpb logit}}Logistic regression, reporting coefficients{p_end}
{synopt :{helpb probit}}Probit regression{p_end}
{synopt :{helpb cloglog}}Complementary log-log regression{p_end}
{synopt :{helpb binreg}}GLM for the binomial family{p_end}

{syntab:Count-response regression models}
{synopt :{helpb poisson}}Poisson regression{p_end}
{synopt :{helpb nbreg}}Negative binomial regression{p_end}
{synopt :{helpb gnbreg}}Generalized negative binomial regression{p_end}

{syntab:Ordinal-response regression models}
{synopt :{helpb ologit}}Ordered logistic regression{p_end}
{synopt :{helpb oprobit}}Ordered probit regression{p_end}

{syntab:Categorical-response regression models}
{synopt :{helpb mlogit}}Multinomial (polytomous) logistic regression{p_end}
{synopt :{helpb mprobit}}Multinomial probit regression{p_end}
{synopt :{helpb clogit}}Conditional (fixed-effects) logistic regression{p_end}

{syntab:Fractional-response regression models}
{synopt :{helpb fracreg}}Fractional response regression{p_end}

{syntab:Quantile regression models}
{synopt :{helpb qreg}}Quantile regression{p_end}
{synopt :{helpb iqreg}}Interquantile range regression{p_end}
{synopt :{helpb sqreg}}Simultaneous-quantile regression{p_end}
{synopt :{helpb bsqreg}}Bootstrapped quantile regression{p_end}

{syntab:Survival regression models}
{synopt :{helpb stcox}}Cox proportional hazards model{p_end}
{synopt :{helpb streg}}Parametric survival models{p_end}
{synopt :{helpb stcrreg}}Competing-risks regression{p_end}

{syntab:Other regression models}
{synopt :{helpb glm}}Generalized linear models{p_end}
{synopt :{helpb areg}}Linear regression with a large dummy-variable set{p_end}
{synopt :{helpb rreg}}Robust regression{p_end}
{synopt :{helpb truncreg}}Truncated regression{p_end}

{syntab:Descriptive statistics}
{synopt :{helpb mean}}Estimate means{p_end}
{synopt :{helpb proportion}}Estimate proportions{p_end}
{synopt :{helpb ratio}}Estimate ratios{p_end}
{synopt :{helpb total}}Estimate totals{p_end}

{marker xt_cmds}{...}
{syntab:Panel-data models}
{synopt :{helpb xtreg}}Fixed-, between- and random-effects, and
population-averaged linear models{p_end}
{synopt :{helpb xtrc}}Random-coefficients model{p_end}
{synopt :{helpb xtlogit}}Fixed-effects, random-effects, and population-averaged
logit models{p_end}
{synopt :{helpb xtprobit}}Random-effects and population-averaged probit
models{p_end}
{synopt :{helpb xtcloglog}}Random-effects and population-averaged cloglog
models{p_end}
{synopt :{helpb xtpoisson}}Fixed-effects, random-effects, and
population-averaged Poisson models{p_end}
{synopt :{helpb xtnbreg}}Fixed-effects, random-effects, and population-averaged
negative binomial models{p_end}
{synopt :{helpb xtgee}}Fit population-averaged panel-data models by using GEE{p_end}

{syntab:Multilevel mixed-effects models}
{synopt :{helpb mixed}}Multilevel mixed-effects linear regression{p_end}

{syntab:Survey regression models}
{synopt :{helpb svy estimation:svy:}}Estimation commands for survey data 
(excluding commands that are not listed above){p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}
Only Taylor-linearized survey variance estimation is supported with {cmd:svy:}.
{p_end}
