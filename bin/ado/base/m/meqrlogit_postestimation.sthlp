{smcl}
{* *! version 1.3.0  23may2018}{...}
{viewerdialog predict "dialog meqrlogit_p"}{...}
{viewerdialog estat "dialog meqrlogit_estat"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] meqrlogit" "help meqrlogit"}{...}
{viewerjumpto "Postestimation commands" "meqrlogit postestimation##description"}{...}
{viewerjumpto "predict" "meqrlogit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "meqrlogit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "meqrlogit postestimation##examples"}{...}
{viewerjumpto "Reference" "meqrlogit postestimation##reference"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[ME] meqrlogit postestimation} {hline 2}}Postestimation tools for
meqrlogit{p_end}
{p2col:}({browse "http://www.stata.com/manuals15/memeqrlogitpostestimation.pdf":View complete PDF manual entry}){p_end}
{p2colreset}{...}

{pstd}
{cmd:meqrlogit} continues to work but, as of Stata 16, is no longer an
official part of Stata.  This is the original help file, which we will no
longer update, so some links may no longer work.

{pstd}
See {helpb melogit} for a recommended alternative to {cmd:meqrlogit}.


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:meqrlogit}:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb estat group}}summarize
the composition of the nested groups{p_end}
{synopt :{helpb estat icc}}estimate
intraclass correlations{p_end}
{synopt :{helpb estat recovariance}}display
  the estimated random-effects covariance matrices{p_end}
{synopt :{helpb me estat sd:estat sd}}display variance components as standard deviations and correlations{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_hausman
INCLUDE help post_lincom
INCLUDE help post_lrtest
{synopt:{helpb meqrlogit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb meqrlogit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 4 4 2}
Syntax for obtaining estimated random effects and their standard errors

{p 8 16 2}
{cmd:predict} {dtype}
{it:{help meqrlogit_postestimation##newvarsspec:newvarsspec}}
{ifin}
{cmd:,} {opt ref:fects}
[{opth reses:(meqrlogit_postestimation##newvarsspec:newvarsspec)}
{opt relev:el(levelvar)}]


{p 4 4 2}
Syntax for obtaining other predictions

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} 
[{cmd:,} {it:statistic}
{opt nooff:set}
{opt fixed:only}]


{marker newvarsspec}{...}
{phang}
{it:newvarsspec} is {it:stub}{cmd:*} or {it:{help newvarlist}}.

{synoptset 13 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt mu}}mean response; the default{p_end}
{synopt :{cmd:xb}}linear predictor for the fixed portion of the model only{p_end}
{synopt :{cmd:stdp}}standard error of the fixed-portion linear prediction{p_end}
{synopt :{opt pea:rson}}Pearson residuals{p_end}
{synopt :{opt dev:iance}}deviance residuals{p_end}
{synopt :{opt ans:combe}}Anscombe residuals{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
mean responses; linear predictions; standard errors;
and Pearson, deviance, and Anscombe residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{marker reffects}{...}
{phang}
{opt reffects} calculates posterior modal estimates of the 
random effects.  By default, estimates for all random effects in the model 
are calculated.  However, if the {opt relevel(levelvar)} option is specified,
then estimates for only level {it:levelvar} in the model are calculated.  For
example, if {cmd:class}es are nested within {cmd:school}s, then typing

{p 12 16 2}{cmd:. predict b*, reffects relevel(school)}{p_end}

{pmore}
would yield random-effects estimates at the school level.  You must
specify {it:q} new variables, where {it:q} is the number of random-effects
terms in the model (or level).  However, it is much easier to just specify
{it:stub}{cmd:*} and let Stata name the variables
{it:stub}{cmd:1}, {it:stub}{cmd:2}, ..., {it:stubq} for you.

{phang}
{opth reses:(meqrlogit_postestimation##newvarsspec:newvarsspec)}
calculates standard errors for the random-effects estimates.
By default, standard errors for all random effects in the model are
calculated.  However, if the {opt relevel(levelvar)} option is specified, then
standard errors for only level {it:levelvar} in the model are calculated; see
the {helpb meqrlogit postestimation##reffects:reffects} option.

{pmore}
You must specify {it:q} new variables, where {it:q} is the number of
random-effects terms in the model (or level).  However, it is much easier to
just specify {it:stub}{cmd:*} and let Stata name the variables
{it:stub}{cmd:1}, {it:stub}{cmd:2}, ..., {it:stubq} for you.  The new
variables will have the same storage type as the corresponding random-effects
variables.

{pmore}
The {cmd:reffects} and {cmd:reses()} options often generate multiple new
variables at once.  When this occurs, the random effects (or standard errors)
contained in the generated variables correspond to the order in which the
variance components are listed in the output of {cmd:meqrlogit}.  Still,
examining the variable labels of the generated variables (with the
{cmd:describe} command, for instance) can be useful in deciphering which
variables correspond to which terms in the model.

{phang}
{opt relevel(levelvar)} specifies the level in the model at which
predictions for random effects and their standard errors are
to be obtained.  {it:levelvar} is the name of the model level and is either
the name of the variable describing the grouping at that level or is {cmd:_all},
a special designation for a group comprising all the estimation data.

{marker mu}{...}
{phang} 
{opt mu}, the default, calculates the predicted mean.
By default, this is based on a linear predictor that
includes both the fixed effects and the random effects, and the predicted
mean is conditional on the values of the random effects.  Use the
{cmd:fixedonly} option (see {help meqrlogit postestimation##fixedonly:below})
if you want predictions that include only the fixed portion of the model, that
is, if you want random effects set to 0.

{phang}
{opt xb} calculates the linear prediction based on the estimated fixed effects
(coefficients) in the model.  This is equivalent to fixing all random effects
in the model to their theoretical (prior) mean value of 0.

{phang}
{opt stdp} calculates the standard error of the fixed-effects linear
predictor.

{phang}
{opt pearson} calculates Pearson residuals.  Pearson residuals large in
absolute value may indicate a lack of fit.  By default, residuals include both
the fixed portion and the random portion of the model.  The {opt fixedonly}
option modifies the calculation to include the fixed portion only.

{phang}
{opt deviance} calculates deviance residuals.  Deviance residuals are
recommended by
{help meqrlogit postestimation##MN1989:McCullagh and Nelder (1989)}
as having the best properties for
examining the goodness of fit of a GLM.  They are approximately normally
distributed if the model is correctly specified.  They may be plotted against
the fitted values or against a covariate to inspect the model's fit.  By
default, residuals include both the fixed portion and the random portion of the
model.  The {opt fixedonly} option modifies the calculation to include the
fixed portion only.

{phang}
{opt anscombe} calculates Anscombe residuals, which are designed to closely
follow a normal distribution.  By default, residuals include both the fixed
portion and the random portion of the model.  The {opt fixedonly} option
modifies the calculation to include the fixed portion only.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} 
with {cmd:meqrlogit}.  It modifies the calculations made by {cmd:predict} so 
that they ignore the offset variable; the linear prediction is treated
as xb rather than xb + offset.

{marker fixedonly}{...}
{phang}
{opt fixedonly} modifies predictions to include only the fixed portion 
of the model, equivalent to setting all random effects equal to 
0;  see the {helpb meqrlogit postestimation##mu:mu} option.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{cmd:xb}}linear predictor for the fixed portion of the model only; the default{p_end}
{synopt :{opt ref:fects}}not allowed with {cmd:margins}{p_end}
{synopt :{opt reses}}not allowed with {cmd:margins}{p_end}
{synopt :{cmd:mu}}not allowed with {cmd:margins}{p_end}
{synopt :{cmd:stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt pea:rson}}not allowed with {cmd:margins}{p_end}
{synopt :{opt dev:iance}}not allowed with {cmd:margins}{p_end}
{synopt :{opt ans:combe}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
linear predictions.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse bangladesh}{p_end}
{phang2}{cmd:. meqrlogit c_use urban age child* || district: urban, covariance(unstructured)}{p_end}

{pstd}Random-effects covariance matrix for level {cmd:district}{p_end}
{phang2}{cmd:. estat recovariance}{p_end}

{pstd}Random-effects correlation matrix for level {cmd:district}{p_end}
{phang2}{cmd:. estat recovariance, correlation}{p_end}

{pstd}Predictions of random effects{p_end}
{phang2}{cmd:. predict re_urban re_cons, reffects}{p_end}

{pstd}Compute conditional intraclass correlation{p_end}
{phang2}{cmd:. estat icc}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse towerlondon, clear}{p_end}
{phang2}{cmd:. meqrlogit dtlm difficulty i.group || family: || subject:}
{p_end}

{pstd}Summarize composition of nested groups{p_end}
{phang2}{cmd:. estat group}{p_end}

{pstd}Predicted probabilities, incorporating random effects{p_end}
{phang2}{cmd:. predict p}{p_end}

{pstd}Predicted probabilities, ignoring subject and family effects{p_end}
{phang2}{cmd:. predict p_fixed, fixedonly}{p_end}

{pstd}Compute residual intraclass correlations{p_end}
{phang2}{cmd:. estat icc}{p_end}

    {hline}


{marker reference}{...}
{title:Reference}

{marker MN1989}{...}
{phang}
McCullagh, P., and J. A. Nelder. 1989.
{browse "http://www.stata.com/bookstore/glm.html":{it:Generalized Linear Models}. 2nd ed.}
London: Chapman & Hall/CRC.
{p_end}
