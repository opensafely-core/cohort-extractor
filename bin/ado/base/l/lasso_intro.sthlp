{smcl}
{* *! version 1.0.1  04feb2020}{...}
{vieweralsosee "[LASSO] Lasso intro" "mansection LASSO Lassointro"}{...}
{viewerjumpto "Description" "lasso_intro##description"}{...}
{viewerjumpto "Links to PDF documentation" "lasso_intro##linkspdf"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[LASSO] Lasso intro} {hline 2}}Introduction to lasso{p_end}
{p2col:}({mansection LASSO Lassointro:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Lasso was originally an acronym for "least absolute shrinkage and selection
operator".  Today, lasso is considered a word and not an acronym.

{pstd}
Lasso is used for prediction, for model selection, and as a component of
estimators to perform inference.

{pstd}
Lasso, elastic net, and square-root lasso are designed for model selection and
prediction.  Stata's {cmd:lasso}, {cmd:elasticnet}, and {cmd:sqrtlasso}
commands implement these methods.  {cmd:lasso} and {cmd:elasticnet} fit
continuous, binary, and count outcomes, while {cmd:sqrtlasso} fits continuous
outcomes.

{pstd}
Stata also provides lasso commands for inference.  They use lassos to select
control variables that appear in the model, and they estimate coefficients and
standard errors for a specified subset of covariates.

{pstd}
Stata's lasso inference commands implement methods known as double selection,
partialing out, and cross-fit partialing out.  With each of these methods,
linear, logistic, or Poisson regression can be used to model a continuous,
binary, or count outcome.  Partialing out and cross-fit partialing out also
allow for endogenous covariates in linear models.

{pstd}
This entry provides an overview of lasso for prediction, model selection,
and inference and an introduction to Stata's suite of lasso commands.

{synoptset 37}{...}
{synoptline}
{synopt :{manlink LASSO Lasso inference intro}}Introduction to inferential lasso models{p_end}
{synopt :{manhelp coefpath LASSO}}Plot path of coefficients after lasso{p_end}
{synopt :{manlink LASSO Collinear covariates}}Treatment of collinear covariates{p_end}
{synopt :{manhelp cvplot LASSO}}Plot cross-validation function after lasso{p_end}
{synopt :{manhelp dslogit LASSO}}Double-selection lasso logistic regression{p_end}
{synopt :{manhelp dspoisson LASSO}}Double-selection lasso Poisson regression{p_end}
{synopt :{manhelp dsregress LASSO}}Double-selection lasso linear regression{p_end}
{synopt :{manhelp elasticnet LASSO}}Elastic net for prediction and model selection{p_end}
{synopt :{helpb lasso estimates store:[LASSO] estimates store}}Saving and restoring estimates in memory and on disk{p_end}
{synopt :{manlink LASSO Inference examples}}Examples and workflow for inference{p_end}
{synopt :{manlink LASSO Inference requirements}}Requirements for inference{p_end}
{synopt :{manhelp lasso LASSO}}Lasso for prediction and model selection{p_end}
{synopt :{helpb lasso postestimation:[LASSO] lasso postestimation}}Postestimation tools for lasso for prediction{p_end}
{synopt :{manhelp lassocoef LASSO}}Display coefficients after lasso estimation results{p_end}
{synopt :{manlink LASSO lasso examples}}Examples of lasso for prediction{p_end}
{synopt :{manlink LASSO lasso fitting}}The process (in a nutshell) of fitting lasso models{p_end}
{synopt :{manhelp lassogof LASSO}}Goodness of fit after lasso for prediction{p_end}
{synopt :{helpb lasso inference postestimation:[LASSO] lasso inference postestimation}}Postestimation tools for lasso inferential models{p_end}
{synopt :{manhelp lassoinfo LASSO}}Display information about lasso estimation results{p_end}
{synopt :{manhelp lassoknots LASSO}}Display knot table after lasso estimation{p_end}
{synopt :{helpb lasso options:[LASSO] lasso options}}Lasso options for inferential models{p_end}
{synopt :{manhelp lassoselect LASSO}}Select lambda after lasso{p_end}
{synopt :{manhelp poivregress LASSO}}Partialing-out lasso instrumental-variables regression{p_end}
{synopt :{manhelp pologit LASSO}}Partialing-out lasso logistic regression{p_end}
{synopt :{manhelp popoisson LASSO}}Partialing-out lasso Poisson regression{p_end}
{synopt :{manhelp poregress LASSO}}Partialing-out lasso linear regression{p_end}
{synopt :{manhelp sqrtlasso LASSO}}Square-root lasso for prediction and model selection{p_end}
{synopt :{manhelp xpoivregress LASSO}}Cross-fit partialing-out lasso instrumental-variables regression{p_end}
{synopt :{manhelp xpologit LASSO}}Cross-fit partialing-out lasso logistic regression{p_end}
{synopt :{manhelp xpopoisson LASSO}}Cross-fit partialing-out lasso Poisson regression{p_end}
{synopt :{manhelp xporegress LASSO}}Cross-fit partialing-out lasso linear regression{p_end}
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO LassointroRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.
{p_end}
