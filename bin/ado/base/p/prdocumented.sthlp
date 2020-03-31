{smcl}
{* *! version 1.2.6  01nov2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{title:Title}

{pstd}
{hi:Previously documented commands}


{title:Description}

{pstd}
Previously documented commands are commands of Stata from a previous release
that are no longer documented because they have been superseded by more recent,
better commands.  The commands continue to work, although sometimes only under
version control.  The help files for the commands listed below are still
available to assist in understanding old do-files and ado-files.

{col 74}Last
{col 5}Command{col 25}Description{col 71}release
    {hline}
{col 5}{manhelp adjust R}{col 25}tables of adjusted means and proportions{col 76}10
{col 5}{manhelp anova_10 R}{col 25}old (prior to Stata 11) anova command{col 76}10
{col 5}{manhelp asclogit R}{col 25}alternative-specific conditional logit{col 76}15
          {col 27}(McFadden's choice) model
{col 5}{manhelp asmixlogit R}{col 25}alternative-specific mixed logit{col 76}15
          {col 27}regression
{col 5}{manhelp asmprobit R}{col 25}alternative-specific multinomial probit{col 76}15
          {col 27}regression
{col 5}{manhelp asroprobit R}{col 25}alternative-specific rank-ordered probit{col 76}15
          {col 27}regression

{col 5}{manhelp blogit R}{col 25}logistic regression for grouped data{col 76}13
{col 5}{manhelp bprobit R}{col 25}probit regression for grouped data{col 76}13

{col 5}{manhelp chelp R}{col 25}display system help in the Results window{col 76}12
{col 5}{manhelp ci_14_0 R}{col 25}old (prior to Stata 14.1) ci command{col 74}14.0
{col 5}{manhelp cii_14_0 R}{col 25}old (prior to Stata 14.1) cii command{col 74}14.0
{col 5}{manhelp clist D}{col 25}list values of variables{col 76}11
{col 5}{manhelp cnreg R}{col 25}censored-normal regression{col 76}10

{col 5}{manhelp dprobit R}{col 25}probit regression, reporting marginal effects{col 76}10
{col 5}{manhelp dvech TS}{col 25}diagonal vech multivariate GARCH models{col 76}11

{col 5}{manhelp fdasave D}{col 25}save and use datasets in FDA (SAS XPORT) format{col 76}11
{col 5}{manhelp findit R}{col 25}search for information across all sources{col 76}12
{col 5}{manhelp fracpoly R}{col 25}fractional polynomial regression{col 76}12

{col 5}{manhelp glogit R}{col 25}weighted least-squares logistic regression{col 76}13
{col 29}for grouped data
{col 5}{manhelp gprobit R}{col 25}weighted least-squares probit regression{col 76}13
{col 29}for grouped data
{col 5}{manhelp graph7 G-2}{col 25}old (prior to Stata 8) graph command{col 77}7

{col 5}{manhelp hadimvo R}{col 25}identify multivariate outliers{col 77}7
{col 5}{manhelp haver TS}{col 25}load data from Haver Analytics database{col 76}12
{col 5}{manhelp hsearch R}{col 25}search help files{col 76}12

{col 5}{manhelp icd9_13 D}{col 25}old (prior to Stata 14) icd9 and icd9p commands{col 76}13
{col 5}{manhelp impute D}{col 25}fill in missing values; see {helpb mi impute} instead{col 76}10
{col 5}{manhelp insheet D}{col 25}read text data created by a spreadsheet{col 76}12

{col 5}{manhelp manova_10 R}{col 25}old (prior to Stata 11) manova command{col 76}10
{col 5}{manhelp matrix_makeCns P:matrix dispCns}{col 25}constrained estimation; see {helpb makecns} instead{col 77}8
{col 5}{manhelp matrix_makeCns P:matrix makeCns}{col 25}constrained estimation; see {helpb makecns} instead{col 77}8
{col 5}{manhelp matsize R}{col 25}set the maximum number of variables in a model{col 76}15
{col 5}{manhelp meqrlogit ME}{col 25}multilevel mixed-effects logistic regression{col 76}15
                       {col 27}(QR decomposition) 
{col 5}{manhelp meqrpoisson ME}{col 25}multilevel mixed-effects Poisson regression{col 76}15
                       {col 27}(QR decomposition) 
{col 5}{manhelp merge_10 R}{col 25}old (prior to Stata 11) merge command{col 76}10
{col 5}{manhelp mfx R}{col 25}obtain marginal effects or elasticities after{col 76}10
                       {col 27}estimation
{col 5}{help ml_10}{col 25}old (Stata 10) {cmd:ml} commands{col 76}10
{col 5}{help mleval_10}
{col 5}{help mlmethod_10}
{col 5}{help ml_11}{col 25}original (Stata 11) {cmd:ml} commands{col 76}11
{col 5}{help mleval_11}
{col 5}{help mlmethod_11}
{col 5}{manhelp moptimize_11 M-5}{col 25}original (Stata 11) {cmd:moptimize()}{col 76}11

{col 5}{manhelp news R}{col 25}report Stata news{col 76}15

{col 5}{manhelp optimize_11 M-5}{col 25}original (Stata 11) {cmd:optimize()}{col 76}11
{col 5}{manhelp outsheet D}{col 25}write spreadsheet-style dataset{col 76}12

{col 5}{manhelp parse R}{col 25}parse program arguments{col 77}4
{col 5}{manhelp plot R}{col 25}draw scatterplot using typewriter characters{col 77}7

{col 5}{manhelp _qreg R}{col 25}internal estimation command for quantile{col 76}12
                        {col 27}regression

{col 5}{manhelp rologit R}{col 25}rank-ordered logistic regression{col 76}15


{col 5}{manhelp sampsi R}{col 25}sample size and power for means and proportions{col 76}12
{col 5}{manhelp set_charset R:set charset}{col 25}set the character set used by Stata for{col 76}13
                        {col 27}ASCII test (Mac only)
{col 5}{manhelp stpower ST}{col 25}sample size, power, and effect size for survival{col 76}13
{col 27}analysis
{col 5}{manhelp stpower_cox ST:stpower cox}{col 25}Sample size, power, and effect size for the Cox{col 76}13
{col 27}proportional hazards model
{col 5}{manhelp stpower_exponential ST:stpower}{col 25}Sample size and power for the exponential test{col 76}13
{col 10}{helpb stpower_exponential:exponential}
{col 5}{manhelp stpower_logrank ST:stpower}{col 25}Sample size, power, and effect size for the{col 76}13
{col 10}{helpb stpower_logrank:logrank}{col 27}log-rank test

{col 5}{manhelp tobit_14 R}{col 25}Tobit regression{col 76}14

{col 5}{manhelp vce R}{col 25}display variance-covariance matrix of estimators{col 77}8

{col 5}{manhelp xtmixed XT}{col 25}multilevel mixed-effects linear regression{col 76}12
{col 5}{manhelp xtmelogit XT}{col 25}multilevel mixed-effects logistic regression{col 76}12
{col 5}{manhelp xtmepoisson XT}{col 25}multilevel mixed-effects Poisson regression{col 76}12
{col 5}{manhelp xmlsave D}{col 25}export or import dataset in XML format{col 76}14

{col 5}{manhelp ztnb R}{col 25}zero-truncated negative binomial regression{col 76}11
{col 5}{manhelp ztp R}{col 25}zero-truncated Poisson regression{col 76}11
    {hline}
