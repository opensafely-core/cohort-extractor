{smcl}
{* *! version 1.0.0  23jun2019}{...}
{viewerdialog lassoknots "dialog lassoknots"}{...}
{vieweralsosee "[LASSO] lassoknots" "mansection lasso lassoknots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] lasso" "help lasso"}{...}
{vieweralsosee "[LASSO] lasso fitting" "mansection lasso lassofitting"}{...}
{vieweralsosee "[LASSO] lassocoef" "help lassocoef"}{...}
{vieweralsosee "[LASSO] lassoselect" "help lassoselect"}{...}
{viewerjumpto "Syntax" "lassoknots##syntax"}{...}
{viewerjumpto "Menu" "lassoknots##menu"}{...}
{viewerjumpto "Description" "lassoknots##description"}{...}
{viewerjumpto "Links to PDF documentation" "lassoknots##linkspdf"}{...}
{viewerjumpto "Options" "lassoknots##options"}{...}
{viewerjumpto "Examples" "lassoknots##examples"}{...}
{viewerjumpto "Stored results" "lassoknots##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[LASSO] lassoknots} {hline 2}}Display knot table after lasso
estimation{p_end}
{p2col:}({mansection LASSO lassoknots:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
After {cmd:lasso}, {cmd:sqrtlasso}, and {cmd:elasticnet}

{p 8 16 2}
{cmd:lassoknots}
[{cmd:,} {help lassoknots##lassoknots_options:{it:options}}]


{pstd}
After {cmd:ds} and {cmd:po}

{p 8 16 2}
{cmd:lassoknots,} {opt for(varspec)}
[{help lassoknots##lassoknots_options:{it:options}}]


{pstd}
After {cmd:xpo} without {cmd:resample}

{p 8 16 2}
{cmd:lassoknots,} {opt for(varspec)}
{opt xfold(#)}
[{help lassoknots##lassoknots_options:{it:options}}]


{pstd}
After {cmd:xpo} with {cmd:resample}

{p 8 16 2}
{cmd:lassoknots,} {opt for(varspec)}
{opt xfold(#)}
{opt resample(#)}
[{help lassoknots##lassoknots_options:{it:options}}]


{phang}
{it:varspec} is a {varname}, except after {cmd:poivregress}
and {cmd:xpoivregress}, when it is either {it:varname} or
{mansection LASSO lassoinfoRemarksandexamplespred_varname:{bf:pred(}{it:varname}{bf:)}}.


{marker lassoknots_options}{...}
{synoptset 25}{...}
{synopthdr}
{synoptline}
{synopt :{cmdab:di:splay(}{help lassoknots##diopts:{it:di_opts}}{cmd:)}}specify what to display; maximum of three {it:di_opts} options{p_end}
{synopt :{cmdab:all:lambdas}}show all lambdas{p_end}
{synopt :{cmd:steps}}show all adaptive steps; {cmd:selection(adaptive)} only{p_end}
{synopt :{cmd:nolstretch}}do not stretch the width of the table to accommodate long variable names{p_end}

INCLUDE help for_short
{synoptline}
INCLUDE help for_footnote


{marker diopts}{...}
{synoptset 25}{...}
{synopthdr:di_opts}
{synoptline}
{synopt :{cmdab:nonz:ero}}number of nonzero coefficients{p_end}
{synopt :{cmdab:var:iables}}names of variables added or removed{p_end}
{synopt :{cmd:cvmd}}CV mean deviance (the CV function){p_end}
{synopt :{cmdab:cvdev:ratio}}CV mean-deviance ratio{p_end}
{synopt :{cmdab:dev:ratio}}in-sample deviance ratio{p_end}
{synopt :{cmd:bic}}BIC{p_end}
{synopt :{cmd:l1}}relative ell_1-norm of coefficients{p_end}
{synopt :{cmd:l2}}relative ell_2-norm squared of coefficients{p_end}

{syntab:Linear models only}
{synopt :{cmd:cvmpe}}CV mean-prediction error (the CV function){p_end}
{synopt :{cmd:osr2}}out-of-sample R^2{p_end}
{synopt :{cmd:r2}}in-sample R^2{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:lassoknots} shows a table of knots after a lasso.
Knots are the values of lambda at which variables in the model change.

{pstd}
{cmd:lassoknots} displays the names of the variables added or removed as
models are fit for successive lambdas.  It also displays measures of fit.

{pstd}
When using cross-validation (CV) to select lambda*, {cmd:lassoknots} will
display values of the CV function.  After viewing measures of fit, you can
select an alternative lambda* using {helpb lassoselect}.

{pstd}
When {cmd:ds}, {cmd:po}, and {cmd:xpo} commands fit models using
{cmd:selection(cv)} or {cmd:selection(adaptive)} (see
{manhelp lasso_options LASSO:lasso options}), {cmd:lassoknots} can be used to
show the CV function and measures of fit for each of the lassos computed.

{pstd}
{cmd:lassoknots} does work after {cmd:selection(plugin)} but only shows
measures for the single lambda* estimated by the plugin formula.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO lassoknotsQuickstart:Quick start}

        {mansection LASSO lassoknotsRemarksandexamples:Remarks and examples}

	{mansection LASSO lassoknotsMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt display(di_opts)} specifies what to display in the knot table.  A maximum
of three {it:di_opts} options can be specified.  The default is
{cmd:display(nonzero cvmpe variables)} for linear models and
{cmd:display(nonzero cvmd variables)} for logit, probit, and Poisson models.
The full set of {it:di_opts} is the following.

{phang2}
{cmd:nonzero} specifies that the number of nonzero coefficients be shown.

{phang2}
{cmd:variables} specifies that the names of variables added or removed at each
knot be shown.

{phang2}
{cmd:cvmd} specifies that the CV mean deviance be shown.  These are the values
of the CV function that are searched for a minimum.  For linear models, it is
the same as the CV mean-prediction error given by {cmd:cvmpe}.

{phang2}
{cmd:cvdevratio} specifies that the CV mean-deviance ratio be shown.  The CV
mean-deviance ratio is an estimate of out-of-sample goodness of fit.  As a
measure of prediction performance, it is superior to {cmd:devratio}, the
in-sample deviance ratio.  It is typically between 0 and 1, but in some cases,
it may be outside this range.  For linear models, it is the same as
out-of-sample R^2 given by {cmd:osr2}.

{phang2}
{cmd:devratio} specifies that the in-sample deviance ratio be shown.  The
in-sample deviance ratio is an indicator of in-sample goodness of fit.  The
in-sample deviance generalizes the in-sample R^2 to nonlinear models.  As a
measure of prediction performance, it is inferior to {cmd:cvdevratio}, the CV
mean-deviance ratio.  The in-sample deviance ratio is a poor measure of
prediction performance because it does not capture the cost of including
additional covariates for prediction.  It is always between 0 and 1.  For
linear models, it is the same as in-sample R^2 given by {cmd:r2}.

{phang2}
{cmd:bic} specifies that the BIC be shown.

{phang2}
{cmd:l1} specifies that the relative ell_1-norm of coefficients be shown.

{phang2}
{cmd:l2} specifies that relative ell_2-norm squared of coefficients be shown.

{phang2}
Linear models only

{phang3}
{cmd:cvmpe} specifies that the CV mean-prediction error be shown.  These are
the values of the CV function that are searched for a minimum.

{phang3}
{cmd:osr2} specifies that the out-of-sample R^2 be shown.  The out-of-sample
R^2 is an estimate of out-of-sample goodness of fit.  As a measure of
prediction performance, it is superior to {cmd:r2}, the in-sample R^2.  It is
typically between 0 and 1, but in some cases, it may be outside this range.

{phang3}
{cmd:r2} specifies that the in-sample deviance ratio be shown.  The in-sample
deviance ratio is an indicator of in-sample goodness of fit.  As a measure of
prediction performance, it is inferior to {cmd:osr2}, the out-of-sample R^2.
The in-sample R^2 is a poor measure of prediction performance because it does
not capture the cost of including additional covariates for prediction.  It is
always between 0 and 1.

{phang}
{cmd:alllambdas} specifies that all lambdas are to be shown, not just the
knots.  Measures at lambdas that are not knots change slightly because the
coefficient estimates change slightly.  lambdas that are not knots can be
selected as lambda* by {cmd:lassoselect}; however, this is typically not done.

{phang}
{cmd:steps} applies to {cmd:selection(adaptive)} only.  When specified,
lambdas for all adaptive steps are shown.  By default, lambdas for only
the last adaptive step are shown.

{phang}
{cmd:nolstretch} specifies that the width of the table not be automatically
widened to accommodate long variable names.  When {cmd:nolstretch} is
specified, names are abbreviated to make the table width no more than 79
characters.  The default, {cmd:lstretch}, is to automatically widen the table
up to the width of the Results window.  To change the default, use
{helpb set:set lstretch off}.

INCLUDE help for_long


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. set seed 1234}{p_end}
{phang2}{cmd:. lasso linear mpg i.foreign i.rep78 headroom weight turn}
    {cmd:gear_ratio price trunk length displacement}

{pstd}Show knot{p_end}
{phang2}{cmd:. lassoknots}

{pstd}Show number of nonzero coefficients, out-of-sample R^2, and
variables added or removed{p_end}
{phang2}{cmd:. lassoknots, display(nonzero osr2 variables)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse breathe, clear}{p_end}
{phang2}{cmd:. dsregress react no2_class no2_home,}
    {cmd:controls(i.(meducation overweight msmoke sex) noise sev* age)}
    {cmd:selection(cv)}

{pstd}Show the knot table for the lasso for the dependent variable {cmd:react}
{p_end}
{phang2}{cmd:. lassoknots, for(react)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse nlsy80, clear}{p_end}
{phang2}{cmd:. poivregress wage exper} 
    {cmd:(educ = i.pcollege##c.(meduc feduc) i.urban sibs iq),} 
    {cmd:controls(c.age##c.age tenure kww i.(married black south urban))}
    {cmd:selection(cv)}

{pstd}Show the knot table for the lasso for the prediction of the endogenous
variable {cmd:educ}{p_end}
{phang2}{cmd:. lassoknots, for(pred(educ))}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:lassoknots} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(table)}}matrix containing the values displayed{p_end}
