{smcl}
{* *! version 1.0.6  13feb2019}{...}
{viewerdialog predict "dialog menl_p"}{...}
{viewerdialog estat "dialog menl_estat"}{...}
{vieweralsosee "[ME] menl postestimation" "mansection ME menlpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] menl" "help menl"}{...}
{viewerjumpto "Postestimation commands" "menl_postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "menl_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "menl_postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "menl_postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "menl_postestimation##examples"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[ME] menl postestimation} {hline 2}}Postestimation tools for
menl{p_end}
{p2col:}({mansection ME menlpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:menl}:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb estat group}}summarize
the composition of the nested groups{p_end}
{synopt :{helpb estat recovariance}}display
the estimated random-effects covariance matrices{p_end}
{synopt :{helpb me estat sd:estat sd}}display variance components as standard deviations and correlations{p_end}
{synopt :{helpb me estat wcorrelation:estat wcorrelation}}display
within-cluster correlations and standard deviations{p_end}
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
{synopt :{helpb estimates}}cataloging estimation results{p_end}
{synopt :{helpb mixed_postestimation##lincom:lincom}}point estimates, standard errors, testing, and inference for linear combinations of coefficients{p_end}
INCLUDE help post_lrtest
{synopt :{helpb menl_postestimation##margins:margins}}marginal
        means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb menl_postestimation##predict:predict}}predictions, residuals,
influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
{synopt:{helpb mixed postestimation##pwcompare:pwcompare}}pairwise comparisons of estimates{p_end}
{synopt :{helpb mixed_postestimation##test:test}}Wald tests of simple and composite linear hypotheses{p_end}
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ME menlpostestimationRemarksandexamples:Remarks and examples}

        {mansection ME menlpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 4 4 2}
Syntax for obtaining predictions of random effects and their standard errors

{p 8 16 2}
{cmd:predict}
{dtype}
{{it:{help newvarlist##stub*:stub}}{cmd:*} | {newvar:list}}
{ifin}{cmd:,}
{opt ref:fects}
[{cmd:reses(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {help varlist:{it:newvarlist}}{cmd:)}
{opt relev:el(levelvar)}
{help menl_postestimation##predict_optstable:{it:options}}]


{p 4 4 2}
Syntax for predicting named substitutable expressions (parameters)

        Predict specific parameters

{p 8 16 2}
{cmd:predict}
{dtype}
{cmd:(}{it:newvar} {cmd:=}
{cmd:{c -(}}{help menl_postestimation##paramnames:{it:param}}{cmd::{c )-})}
[{cmd:(}{it:newvar} {cmd:=}
{cmd:{c -(}}{it:param}{cmd::{c )-})}]
[...]
{ifin}
[{cmd:,} {opt fixed:only}
{opt relev:el(levelvar)}
{it:{help menl_postestimation##predict_optstable:options}}]

{p 8 16 2}
{cmd:predict}
{dtype}
{{it:{help newvarlist##stub*:stub}}{cmd:*} | {newvar:list}}
{ifin}{cmd:,}
{opth param:eters(menl_postestimation##paramnames:paramnames)}
[{opt fixed:only}
{opt relev:el(levelvar)}
{it:{help menl_postestimation##predict_optstable:options}}]


        Predict all parameters

{p 8 16 2}
{cmd:predict}
{dtype}
{{it:{help newvarlist##stub*:stub}}{cmd:*} | {newvar:list}}
{ifin}{cmd:,}
{opt param:eters}
[{opt fixed:only} {opt relev:el(levelvar)}
{it:{help menl_postestimation##predict_optstable:options}}]


{pstd}
Syntax for obtaining other predictions

{p 8 16 2}
{cmd:predict}
{dtype}
{newvar}
{ifin} 
[{cmd:,}
{it:{help menl_postestimation##statistic:statistic}} {opt fixed:only} {opt relev:el(levelvar)}
{it:{help menl_postestimation##predict_optstable:options}}]


{marker paramnames}{...}
{phang}
{it:paramnames} is {it:param} [{it:param} [...]] and {it:param} is a name of a
substitutable expression as specified in one of {opt menl}'s {opt define()}
options.

{marker statistic}{...}
{synoptset 25 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab: Main}
{synopt :{opt yhat}}prediction for the expected response conditional on the
random effects{p_end}
{synopt :{opt mu}}synonym for {opt yhat}{p_end}
{synopt :{opt res:iduals}}residuals, response minus predicted values{p_end}
{p2coldent :* {opt rsta:ndard}}standardized residuals{p_end}
{synoptline}
INCLUDE help unstarred

{marker predict_optstable}{...}
{synopthdr}
{synoptline}
{syntab: Main}
{synopt :{opt iter:ate(#)}}maximum number of iterations when computing random
effects; default is {cmd:iterate(10)}{p_end}
{synopt :{opt tol:erance(#)}}convergence tolerance when computing random
effects; default is {cmd:tolerance(1e-6)}{p_end}
{synopt:{opt nrtol:erance(#)}}scaled gradient tolerance when computing random
	effects; default is {cmd:nrtolerance(1e-5)}{p_end}
{synopt:{opt nonrtol:erance}}ignore the {opt nrtolerance()} option{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions of mean values,
residuals, or standardized residuals. It can also create multiple new
variables containing estimates of random effects and their standard errors or
containing predicted
{help me_glossary##named_subexpr:named substitutable expressions}.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt yhat} calculates the predicted values, which are the mean-response values
conditional on the random effects, mu(x', b, u). By
default, the predicted values account for random effects from all levels in
the model; however, if the {opt relevel(levelvar)} option is specified, then
the predicted values are fit beginning with the topmost level down to and
including level {it:levelvar}.  For example, if {opt class}es are nested
within {opt school}s, then typing

            {cmd:. predict yhat_school, yhat relevel(school)}

{pmore}
would produce school-level predictions.  That is, the predictions would
incorporate school-specific random effects but not those for each class nested
within each school. If the {opt fixedonly} option is specified, predicted
values conditional on zero random effects, mu(x', b, 0),
are calculated based on the estimated fixed effects (coefficients) in the
model when the random effects  are fixed at their theoretical mean value of
{bf:0}.

{phang}
{opt mu} is a synonym for {opt yhat}.

{phang}
{opt parameters} and
{opth parameters:(menl_postestimation##paramnames:paramnames)} calculate
predictions for all or a subset of the
{help me_glossary##named_subexpr:named substitutable expressions} in the
model.  By default, the predictions account for random effects from all levels
in the model; however, if the {opt relevel(levelvar)} option is
specified, then the predictions would incorporate random effects from the
topmost level down to and including level {it:levelvar}. Option
{opth parameters:(menl_postestimation##paramnames:param)} is useful with
{opt margins}.  {opt parameters()} does not appear in the dialog box.

{marker reffects}{...}
{phang}
{opt reffects} calculates predictions of the random effects. For the
Lindstrom-Bates estimation method of {helpb menl}, these are
essentially the best linear unbiased predictions of the random
effects in the LME approximated log likelihood; see
{mansection ME menlMethodsandformulasInferencebasedonlinearization:{it:Inference based on linearization}}
in {manhelp menl ME}. By default,
estimates of all random effects in the model are calculated.  However, if the
{opt relevel(levelvar)} option is specified, then estimates of random
effects for only level {it:levelvar} in the model are calculated.  For
example, if {opt class}es are nested within {opt school}s, then typing

            {cmd:. predict b*, reffects relevel(school)}

{pmore}
would produce estimates at the school level.  You must specify {it:q} new
variables, where {it:q} is the number of random-effects terms in the model (or
level).  However, it is much easier to just specify {it:stub}{cmd:*} and let
Stata name the variables {it:stub}{cmd:1}, {it:stub}{cmd:2}, ..., {it:stubq}
for you.

{phang}
{cmd:reses(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {help varlist:{it:newvarlist}}{cmd:)} calculates the
standard errors of the estimates of the random effects.  By default, standard
errors for all random effects in the model are calculated. However, if the
{opt relevel(levelvar)} option is specified, then standard errors of the
estimates of the random effects for only level {it:levelvar} in the model are
calculated; see the {helpb menl_postestimation##reffects:reffects} option.

{pmore}
You must specify {it:q} new variables, where {it:q} is the number of
random-effects terms in the model (or level).  However, it is much easier to
just specify {it:stub}{cmd:*} and let Stata name the variables
{it:stub}{cmd:1}, {it:stub}{cmd:2}, ..., {it:stubq} for you.  The new
variables will have the same storage type as the corresponding random-effects
variables.

{pmore}
The {cmd:reffects} and {cmd:reses()} options often generate multiple new
variables at once.  When this occurs, the random effects (or standard
errors) contained in the generated variables correspond to the order in which
the variance components are listed in the output of {cmd:menl}.  Still,
examining the variable labels of the generated variables 
(with the {cmd:describe} command, for instance) can be useful in deciphering
which variables correspond to which terms in the model. 

{phang}
{opt residuals} calculates residuals, equal to the responses minus the
predicted values {opt yhat}.  By default, the predicted values account for
random effects from all levels in the model; however, if the
{opt relevel(levelvar)} option is specified, then the predicted values are fit
beginning at the topmost level down to and including level {it:levelvar}.

{phang}
{opt rstandard} calculates standardized residuals, equal to the residuals
multiplied by the inverse square root of the estimated error covariance
matrix.

{phang}
{opt fixedonly} specifies that all random effects be set to zero, equivalent
to using only the fixed portion of the model.

{phang}
{opt relevel(levelvar)} specifies the level in the model at which
predictions involving random effects are to be obtained; see the options above
for the specifics.  {it:levelvar} is the name of the model level; it is the
name of the variable describing the grouping at that level.

{phang}
{opt iterate(#)} specifies the maximum number of iterations when
computing estimates of the random effects.  The default is {cmd:iterate(10)}.
This option is relevant only to predictions that depend on random effects.
This option is not allowed if the {cmd:fixedonly} option is specified.

{phang}
{opt tolerance(#)} specifies a convergence tolerance when computing
estimates of the random effects. The default is {cmd:tolerance(1e-6)}. This
option is relevant only to predictions that depend on random effects. This
option is not allowed if the {cmd:fixedonly} option is specified.

{phang}
{opt nrtolerance(#)} and {opt nonrtolerance} control the tolerance for
the scaled gradient when computing estimates of the random effects.

{phang2}
{opt nrtolerance(#)} specifies the tolerance for the scaled
gradient.  Convergence is declared when g(-H^{-1})g' is less than
{opt nrtolerance(#)}, where g is the gradient row vector and H is the
approximated Hessian matrix from the current iteration.  The default is
{cmd:nrtolerance(1e-5)}.

{phang2}
{opt nonrtolerance} specifies that the default
{opt nrtolerance()} criterion be turned off.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt yhat}}predicted values conditional on zero random effects;
implies {opt fixedonly}; the default{p_end}
{synopt :{opth param:eters(menl_postestimation##paramnames:param)}}predicted 
named substitutable expression {it:param} conditional on zero random 
effects; implies {cmd:fixedonly}{p_end}
{synopt :{opt ref:fects}}not allowed with {cmd:margins}{p_end}
{synopt :{opt res:iduals}}not allowed with {cmd:margins}{p_end}
{synopt :{opt rsta:ndard}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p 4 6 2}The {cmd:fixedonly} option is assumed for the predictions used with
{cmd:margins}.

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{opt margins} estimates margins of response for predicted mean values or 
{help me_glossary##named_subexpr:named substitutable expressions}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse soybean}{p_end}
{phang2}{cmd:. menl weight = {phi1:}/(1+exp(-(time-{phi2:})/{phi3:})),}
{cmd:define(phi1: i.year U1[plot]) define(phi2: i.year i.variety)}
{cmd:define(phi3: i.year) resvariance(power _yhat, noconstant)}

{pstd}Test the null hypothesis of homoskedastic within-plot errors {p_end}
{phang2}{cmd:. test _b[/Residual:delta] = 0}{p_end}

{pstd}Display estimated marginal standard deviations and correlations for plot 2 and list the corresponding observations in the data{p_end}
{phang2}{cmd:. estat wcorrelation, at(plot=2) list}{p_end}

{pstd}Calculate predicted values conditional on zero random effects{p_end}
{phang2}{cmd:. predict weight_f, yhat fixedonly}{p_end}

{pstd}Predict parameter {cmd:phi1} defined in the model specification{p_end}
{phang2}{cmd:. predict (phi1 = {phi1:})}{p_end}


    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse wafer, clear}{p_end}
{phang2}{cmd:. menl current = {phi1:}+{phi2}*cos({phi3}*voltage + _pi/4),}
                {cmd:define(phi1: voltage W0[wafer] S0[wafer>site]}
                {cmd:c.voltage#(W1[wafer] S1[wafer>site]))}

{pstd}Summarize composition of nested groups{p_end}
{phang2}{cmd:. estat group}{p_end}

{pstd}Predict random effects at the wafer level{p_end}
{phang2}{cmd:. predict u_wafer*, reffects relevel(wafer)}{p_end}

{pstd}Display estimated random-effects covariance matrix for the {cmd:site}-within-{cmd:wafer} level{p_end}
{phang2}{cmd:. estat recovariance, relevel(site)}{p_end}

{pstd}Calculate predicted values at the wafer level{p_end}
{phang2}{cmd:. predict curr_wafer, yhat relevel(wafer)}{p_end}

    {hline}
