{smcl}
{* *! version 1.0.0  06jul2011}{...}
{title:mi impute reports that the sets of predictors of the imputation model vary across imputations}

{pstd}
{cmd:mi impute} reports a warning when the sets of predictors used to obtain
estimates of the parameters of the imputation model vary across imputations
(or across iterations with {cmd:mi impute chained}).  This may arise when the
{cmd:bootstrap} option is used with any of the univariate imputation methods
or with {cmd:mi impute monotone}, or when the {cmd:mi impute chained} command
is used.  When the {cmd:bootstrap} option is used, estimation of the
parameters is performed on each imputation using a different bootstrap sample,
which may lead to varying sets of predictors.  When the 
{cmd:mi impute chained} command is used, estimation is performed on each
iteration using the previously imputed data from that iteration.

{pstd}
The sets of predictors may vary when some predictors are omitted, for example,
due to collinearity in some imputations (or iterations) but not in others.
Varying sets of predictors may also arise when factor variables are used as
regressors and the sets of levels vary across data used for estimation.
During imputation of categorical data, the sets of categories of the imputed
variable may vary across estimation datasets.

{pstd}
The impact of different predictors being used during imputation on final
multiple-imputation results has not yet been investigated.  When fractions of
missing data are high, the estimates of the "varying" omitted predictors may
be biased toward zero in the final multiple-imputation analysis.  If
predictors vary, you should try to redesign your imputation model such that
the same set of predictors is used in each imputation (iteration).  For
example, remove collinear variables from the imputation model prior to
imputation.  In the presence of factor variables, make sure that the base
level is consistent across imputations (or iterations); see 
{helpb mi_fvset:mi fvset base} on how to set the base level.  Use the
{cmd:noisily} option with {cmd:mi impute} to identify varying sets of
predictors.
{p_end}
