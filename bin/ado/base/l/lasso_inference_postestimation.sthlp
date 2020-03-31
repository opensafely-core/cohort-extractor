{smcl}
{* *! version 1.0.0  21jun2019}{...}
{vieweralsosee "[LASSO] lasso inference postestimation" "mansection lasso lassoinferencepostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] Lasso inference intro" "mansection lasso Lassoinferenceintro"}{...}
{vieweralsosee "[LASSO] Inference examples" "mansection lasso Inferenceexamples"}{...}
{vieweralsosee "[LASSO] dslogit" "help dslogit"}{...}
{vieweralsosee "[LASSO] dspoisson" "help dspoisson"}{...}
{vieweralsosee "[LASSO] dsregress" "help dsregress"}{...}
{vieweralsosee "[LASSO] poivregress" "help poivregress"}{...}
{vieweralsosee "[LASSO] pologit" "help pologit"}{...}
{vieweralsosee "[LASSO] popoisson" "help popoisson"}{...}
{vieweralsosee "[LASSO] poregress" "help poregress"}{...}
{vieweralsosee "[LASSO] xpoivregress" "help xpoivregress"}{...}
{vieweralsosee "[LASSO] xpologit" "help xpologit"}{...}
{vieweralsosee "[LASSO] xpopoisson" "help xpopoisson"}{...}
{vieweralsosee "[LASSO] xporegress" "help xporegress"}{...}
{viewerjumpto "Postestimation commands" "lasso_inference_postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "lasso_inference_postestimation##linkspdf"}{...}
{viewerjumpto "Predictions" "lasso inference postestimation##syntax_predict"}{...}
{p2colset 1 43 45 2}{...}
{p2col:{bf:[LASSO] lasso inference postestimation} {hline 2}}Postestimation tools for lasso inferential models{p_end}
{p2col:}({mansection LASSO lassoinferencepostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after the
{cmd:ds}, {cmd:po}, and {cmd:xpo} commands:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{p2coldent:* {helpb coefpath}}plot path of coefficients{p_end}
{p2coldent:* {helpb cvplot}}plot cross-validation function{p_end}
{synopt :{helpb lassocoef}}display selected coefficients{p_end}
{synopt :{helpb lassoinfo}}information about lasso estimation results{p_end}
{synopt :{helpb lassoknots}}knot table of coefficient selection and measures of fit{p_end}
{p2coldent:* {helpb lassoselect}}select alternative lambda* (and alpha* for {cmd:elasticnet}){p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:coefpath}, {cmd:cvplot}, and {cmd:lassoselect} require the selection
method of the lasso to be {cmd:selection(cv)} or {cmd:selection(adaptive)}.
See {manhelp lasso_options LASSO:lasso options}.

{pstd}
The following standard postestimation commands are also available:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatsum
INCLUDE help post_estatvce
{synopt :{helpb estimates}}cataloging estimation results{p_end}
{synopt :{helpb lincom}}point estimates, standard errors, testing, and inference for linear combinations of coefficients{p_end}
{synopt :{helpb nlcom}}point estimates, standard errors, testing, and inference for nonlinear combinations of coefficients{p_end}
{synopt :{helpb lasso inference postestimation##predict:predict}}predictions{p_end}
{synopt :{helpb predictnl}}point estimates for generalized predictions{p_end}
INCLUDE help post_pwcompare
{synopt :{helpb test}}Wald tests of simple and composite linear hypotheses{p_end}
{synopt :{helpb testnl}}Wald tests of nonlinear hypotheses{p_end}
{synoptline}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO lassoinferencepostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker predict}{...}
{marker syntax_predict}{...}
{title:Syntax for predict}

{p 8 19 2}
{cmd:predict}
{dtype}
{newvar}
{ifin}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing the linear form X hat beta',
where hat beta is the vector of estimated coefficients of the variables of
interest and does not include a constant term.  This is the only type of
prediction available after the {cmd:ds}, {cmd:po}, and {cmd:xpo}
commands.{p_end}
