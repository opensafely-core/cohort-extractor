{smcl}
{* *! version 1.0.5  04jun2018}{...}
{viewerdialog predict "dialog stteffects_p"}{...}
{vieweralsosee "[TE] stteffects postestimation" "mansection TE stteffectspostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] tebalance" "help tebalance"}{...}
{vieweralsosee "[TE] teffects overlap" "help teffects overlap"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] stteffects ipw" "help stteffects ipw"}{...}
{vieweralsosee "[TE] stteffects ipwra" "help stteffects ipwra"}{...}
{vieweralsosee "[TE] stteffects ra" "help stteffects ra"}{...}
{vieweralsosee "[TE] stteffects wra" "help stteffects wra"}{...}
{viewerjumpto "Postestimation commands" "stteffects postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "stteffects_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "stteffects postestimation##predict"}{...}
{viewerjumpto "Examples" "stteffects postestimation##examples"}{...}
{p2colset 1 35 37 2}{...}
{p2col:{bf:[TE] stteffects postestimation} {hline 2}}Postestimation tools for
stteffects{p_end}
{p2col:}({mansection TE stteffectspostestimation:View complete PDF manual entry}){p_end}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after
{cmd:stteffects}:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb teffects overlap:teffects overlap}}overlap plots{p_end}
{synopt :{helpb tebalance}}check balance of covariates{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 16}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_hausman
INCLUDE help post_lincom
INCLUDE help post_nlcom
{synopt :{helpb stteffects postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE stteffectspostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker predict}{...}
{title:Syntaxes for predict}

{pstd}
Syntaxes are presented under the following headings:

        {help stteffects postestimation##syntax_predict_ipw:Syntax for predict after stteffects ipw}
        {help stteffects postestimation##syntax_predict_ipwra:Syntax for predict after stteffects ipwra}
        {help stteffects postestimation##syntax_predict_ra:Syntax for predict after stteffects ra}
        {help stteffects postestimation##syntax_predict_wra:Syntax for predict after stteffects wra}


{marker syntax_predict_ipw}{...}
{title:Syntax for predict after stteffects ipw}

{p 8 16 2}
{cmd:predict} {dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help newvar}} | {it:{help newvarlist}}{c )-}
{ifin}
[{cmd:,} {it:statistic} {opt tl:evel}{cmd:(}{it:treat_level}{cmd:)}]

{synoptset 14 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab :Main}
{synopt :{opt ps}}propensity score; the default{p_end}
{synopt :{opt cens:urv}}censored survival probability{p_end}
{synopt :{opt xb}}linear prediction for propensity score{p_end}
{synopt :{opt cxb}}linear prediction for censoring model{p_end}
{synopt :{opt lns:igma}}log square root of latent variance (for treatment
model {cmd:hetprobit()}){p_end}
{synopt :{opt clnsh:ape}}log of conditional latent shape (for censoring
distribution Weibull, log normal, or gamma){p_end}
{synopt :{opt sc:ores}}parameter-level or equation-level scores{p_end}
{synoptline}
{p 4 6 2}
If you do not specify {cmd:tlevel()} and only specify one new variable,
{cmd:ps} assumes {opt tlevel()} specifies the first treatment level.{p_end}
{p 4 6 2}
If you do not specify {cmd:tlevel()} and only specify one new variable, 
{cmd:xb} and {cmd:lnsigma} assume {cmd:tlevel()}
 specifies the first noncontrol treatment level.{p_end}
{p 4 6 2}
You specify one or t new variables with {cmd:ps}, where t is the number of treatment levels.{p_end}
{p 4 6 2}
You specify one or t-1 new variables with {cmd:xb} and
{cmd:lnsigma}.{p_end}
{p 4 6 2}
You specify one new variable with {cmd:censurv}, {cmd:cxb}, and {cmd:clnshape}.


{marker syntax_predict_ipwra}{...}
{marker predict}{...}
{title:Syntax for predict after stteffects ipwra}

{p 8 16 2}
{cmd:predict} {dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help newvar}} | {it:{help newvarlist}}{c )-}
{ifin}
[{cmd:,} {it:statistic} {opt tl:evel}{cmd:(}{it:treat_level}{cmd:)}]

{synoptset 14 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab :Main}
{synopt :{opt te}}treatment effect; the default{p_end}
{synopt :{opt cm:ean}}conditional mean at treatment level{p_end}
{synopt :{opt ps}}propensity score{p_end}
{synopt :{opt cens:urv}}censored survival probability{p_end}
{synopt :{opt xb}}linear prediction for outcome model{p_end}
{synopt :{opt cxb}}linear prediction for censoring model{p_end}
{synopt :{opt psxb}}linear prediction for propensity score{p_end}
{synopt :{opt lnsh:ape}}log of conditional latent shape (for outcome
distribution Weibull, log normal, or gamma) at treatment level{p_end}
{synopt :{opt clnsh:ape}}log of conditional latent shape (for censoring
distribution Weibull, log normal, or gamma){p_end}
{synopt :{opt pslns:igma}}log square root of latent variance (for treatment
model {cmd:hetprobit()}) for propensity score{p_end}
{synopt :{opt sc:ores}}parameter-level or equation-level scores{p_end}
{synoptline}
{p 4 6 2}
If you do not specify {cmd:tlevel()} and only specify one new variable,
{cmd:te} and {cmd:psxb} assume {cmd:tlevel()} specifies the first noncontrol
 treatment level.{p_end}
{p 4 6 2}
If you do not specify {cmd:tlevel()} and only specify one new variable,
{cmd:cmean}, {cmd:ps}, {cmd:xb}, and {cmd:pslnsigma} assume {cmd:tlevel()} specifies the first treatment level.{p_end}
{p 4 6 2}
You specify one or t new variables with {cmd:cmean},
{cmd:ps}, {cmd:xb}, and {cmd:lnshape}, where t is the
number of treatment levels.{p_end}
{p 4 6 2}
You specify one or t-1 new variables with {cmd:te}, {cmd:psxb}, and {cmd:pslnsigma}.{p_end}
{p 4 6 2}
You specify one new variable with {cmd:censurv}, {cmd:cxb}, and {cmd:clnshape}.


{marker syntax_predict_ra}{...}
{marker predict}{...}
{title:Syntax for predict after stteffects ra}

{p 8 16 2}
{cmd:predict} {dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help newvar}} | {it:{help newvarlist}}{c )-}
{ifin}
[{cmd:,} {it:statistic} {opt tl:evel}{cmd:(}{it:treat_level}{cmd:)}]

{synoptset 14 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab :Main}
{synopt :{opt te}}treatment effect; the default{p_end}
{synopt :{opt cm:ean}}conditional mean at treatment level{p_end}
{synopt :{opt xb}}linear prediction for outcome model{p_end}
{synopt :{opt lnsh:ape}}log of conditional latent shape (for
outcome distribution Weibull, log normal, or gamma) at treatment level{p_end}
{synopt :{opt sc:ores}}parameter-level or equation-level scores{p_end}
{synoptline}
{p 4 6 2} If you do not specify {cmd:tlevel()} and only specify one new
variable,
{cmd:te} assumes {cmd:tlevel()} specifies the first noncontrol
 treatment level.{p_end}
{p 4 6 2}
If you do not specify {cmd:tlevel()} and only specify one new variable,
{cmd:cmean}, {cmd:xb}, and {cmd:lnshape} assume {cmd:tlevel()}
specifies the first treatment level.{p_end}
{p 4 6 2}
You specify one or t new variables with {cmd:cmean},
{cmd:xb}, and {cmd:lnshape}, where t is the number of
treatment levels.{p_end}
{p 4 6 2}
You specify one or t-1 new variables with {cmd:te}.
{p2colreset}{...}


{marker syntax_predict_wra}{...}
{marker predict}{...}
{title:Syntax for predict after stteffects wra}

{p 8 16 2}
{cmd:predict} {dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help newvar}} | {it:{help newvarlist}}{c )-}
{ifin}
[{cmd:,} {it:statistic} {opt tl:evel}{cmd:(}{it:treat_level}{cmd:)}]

{synoptset 14 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab :Main}
{synopt :{opt te}}treatment effect; the default{p_end}
{synopt :{opt cm:ean}}conditional mean at treatment level{p_end}
{synopt :{opt cens:urv}}censored survival probability{p_end}
{synopt :{opt xb}}linear prediction for outcome model{p_end}
{synopt :{opt cxb}}linear prediction for censoring model{p_end}
{synopt :{opt lnsh:ape}}log of conditional latent shape (for
outcome distribution Weibull, log normal, or gamma) at treatment level{p_end}
{synopt :{opt clnsh:ape}}log of conditional latent shape (for
censoring distribution Weibull, log normal, or gamma){p_end}
{synopt :{opt sc:ores}}parameter-level or equation-level scores{p_end}
{synoptline}
{p 4 6 2}
If you do not specify {cmd:tlevel()} and only specify one new variable,
{cmd:te} assumes {cmd:tlevel()} specifies the first noncontrol
 treatment level.{p_end}
{p 4 6 2}
If you do not specify {cmd:tlevel()} and only specify one new variable,
{cmd:cmean}, {cmd:xb}, and {cmd:lnshape} assume {cmd:tlevel()}
 specifies the first treatment level.{p_end}
{p 4 6 2}
You specify one or t new variables with {cmd:cmean},
{cmd:xb}, and {cmd:lnshape}, where t is the number of treatment
levels.{p_end}
{p 4 6 2}
You specify one or t-1 new variables with {cmd:te}.{p_end}
{p 4 6 2}
You specify one new variable with {cmd:censurv}, {cmd:cxb}, and {cmd:clnshape}.


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
treatment effects, conditional means, propensity scores,
linear predictions, and log square roots of latent variances.


{title:Options for predict}

{pstd}
Options are presented under the following headings:

        {help stteffects postestimation##options_predict_ipw:Options for predict after stteffects ipw}
        {help stteffects postestimation##options_predict_ipwra:Options for predict after stteffects ipwra}
        {help stteffects postestimation##options_predict_ra:Options for predict after stteffects ra}
        {help stteffects postestimation##options_predict_wra:Options for predict after stteffects wra}


{marker options_predict_ipw}{...}
{title:Options for predict after stteffects ipw}

{dlgtab:Main}

{phang}
{cmd:ps}, the default, calculates the propensity score of each treatment level
or the treatment level specified in {cmd:tlevel()}.  If you specify the
{cmd:tlevel()} option, you need to specify only one new variable; otherwise,
you must specify a new variable for each treatment level.

{phang}
{cmd:censurv} calculates the survivor probability from the time-to-censoring
model.  (In other words, it calculates the probability that an outcome is
not censored.)  This option is allowed only if a censoring model is
specified at estimation time.  You need to specify only one new variable.

{phang}
{cmd:xb} calculates the propensity score linear prediction at each noncontrol
level of the treatment or the treatment level specified in {cmd:tlevel()}.  If
you specify the {cmd:tlevel()} option, you need to specify only one new
variable; otherwise, you must specify a new variable for each treatment level
(except the control level).

{phang}
{cmd:cxb} calculates the linear prediction of the censoring model.  This
option is allowed only if a censoring model is specified at estimation time.
You need to specify only one new variable.

{phang}
{cmd:lnsigma} calculates the log square root of the latent variance.  This
option is valid only when treatment model {cmd:hetprobit()} is used.
You need to specify only one new variable.

{phang}
{cmd:clnshape} calculates the log of the conditional latent shape parameter
of the censoring distribution.  This option is valid when censoring
distribution Weibull, log normal, or gamma is used.  You need to specify only
one new variable.

{phang}
{opt tlevel(treat_level)} specifies the treatment level for
prediction.

{phang}
{cmd:scores} calculates the score variables.  Parameter-level scores are
computed for the treatment mean and average treatment-effect equations.
Equation-level scores are computed for the censoring and propensity-score
equations.

{pmore}
The jth new variable will contain the scores for the jth parameter in the
coefficient table if j{ul:<}t, where t is the number of treatment levels.
Otherwise, it will contain the scores for fitted equation j-t following the
first t parameters in the coefficient table.


{marker options_predict_ipwra}{...}
{title:Options for predict after stteffects ipwra}

{dlgtab:Main}

{phang}
{cmd:te}, the default, calculates the treatment effect for each noncontrol
treatment level or the treatment level specified in {cmd:tlevel()}.  If you
specify the {cmd:tlevel()} option, you need to specify only one new variable;
otherwise, you must specify a new variable for each treatment level (except
the control level).

{phang}
{cmd:cmean} calculates the conditional mean for each treatment level or the
treatment level specified in {cmd:tlevel()}.  If you specify the {cmd:tlevel()} option, you need to specify only one new variable; otherwise, you
must specify a new variable for each treatment level.

{phang}
{cmd:ps} calculates the propensity score of each treatment level or the
treatment level specified in {cmd:tlevel()}.  If you specify the
{cmd:tlevel()} option, you need to specify only one new variable; otherwise,
you must specify a new variable for each treatment level.

{phang}
{cmd:censurv} calculates the survivor probability from the time-to-censoring
model.  (In other words, it calculates the probability that an outcome is
not censored.)  This option is allowed only if a censoring model is
specified at estimation time.  You need to specify only one new variable.

{phang}
{cmd:xb} calculates the outcome model linear prediction at each treatment level
or the treatment level specified in {cmd:tlevel()}.  If you specify the
{cmd:tlevel()} option, you need to specify only one new variable; otherwise,
you must specify a new variable for each treatment level.

{phang}
{cmd:cxb} calculates the linear prediction of the censoring model.  This
option is allowed only if a censoring model is specified at estimation time.
You need to specify only one new variable.

{phang}
{cmd:psxb} calculates the propensity score linear prediction at each
noncontrol level of the treatment or the treatment level specified in
{cmd:tlevel()}.  If you specify the {cmd:tlevel()} option, you need to specify
only one new variable; otherwise, you must specify a new variable for each
treatment level (except the control level).

{phang}
{cmd:lnshape} calculates the log of the conditional latent shape parameter
for each treatment level or the treatment level specified in {cmd:tlevel()}.
This option is valid when outcome distribution Weibull, log normal, or
gamma is used.  If you specify the {cmd:tlevel()} option, you need to specify
only one new variable; otherwise, you must specify a new variable for each
treatment level.

{phang}
{cmd:clnshape} calculates the log of the conditional latent shape parameter
for the censoring distribution.  This option is valid when censoring
distribution Weibull, log normal, or gamma is used.  You need to specify only
one new variable.

{phang}
{cmd:pslnsigma} calculates the log square root of the latent variance for the
propensity score.  This option is valid only when treatment model
{cmd:hetprobit()} is used.  You need to specify only one new variable.

{phang}
{opt tlevel(treat_level)} specifies the treatment level for
prediction.

{phang}
{cmd:scores} calculates the score variables.  Parameter-level scores
are computed for the treatment mean and average treatment-effect equations.
Equation-level scores are computed for the outcome, censoring, and
propensity-score equations.

{pmore}
The jth new variable will contain the scores for the jth parameter in the
coefficient table if j{ul:<}t, where t is the number of treatment levels.
Otherwise, it will contain the scores for fitted equation j-t following the
first t parameters in the coefficient table.


{marker options_predict_ra}{...}
{title:Options for predict after stteffects ra}

{dlgtab:Main}

{phang}
{cmd:te}, the default, calculates the treatment effect for each noncontrol
treatment level or the treatment level specified in {cmd:tlevel()}.  If you
specify the {cmd:tlevel()} option, you need to specify only one new variable;
otherwise, you must specify a new variable for each treatment level (except the
control level).

{phang}
{cmd:cmean} calculates the conditional mean for each treatment level or
the treatment level specified in {cmd:tlevel()}.  If you specify the
{cmd:tlevel()} option, you need to specify only one new variable;
otherwise, you must specify a new variable for each treatment level.

{phang}
{cmd:xb} calculates the outcome model linear prediction at each treatment
level or the treatment level specified in {cmd:tlevel()}.  If you specify the
{cmd:tlevel()} option, you need to specify only one new variable; otherwise,
you must specify a new variable for each treatment level.

{phang}
{cmd:lnshape} calculates the log of the conditional latent shape parameter
for each treatment level or the treatment level specified in {cmd:tlevel()}.
This option is valid when the outcome distribution Weibull, log normal, or
gamma is used.  If you specify the {cmd:tlevel()} option, you need to specify
only one new variable; otherwise, you must specify a new variable for each
treatment level.

{phang}
{opt tlevel(treat_level)} specifies the treatment level for
prediction.

{phang}
{cmd:scores} calculates the score variables.  Parameter-level scores
are computed for the treatment mean and average treatment-effect equations.
Equation-level scores are computed for the outcome equations.

{pmore}
The jth new variable will contain the scores for the jth parameter in the
coefficient table if j{ul:<}t, where t is the number of treatment levels.
Otherwise, it will contain the scores for fitted equation j-t following the
first t parameters in the coefficient table.


{marker options_predict_wra}{...}
{title:Options for predict after stteffects wra}

{dlgtab:Main}

{phang}
{cmd:te}, the default, calculates the treatment effect for each noncontrol
treatment level or the treatment level specified in {cmd:tlevel()}.  If you
specify the {cmd:tlevel()} option, you need to specify only one new variable;
otherwise, you must specify a new variable for each treatment level (except
the control level).

{phang}
{cmd:cmean} calculates the conditional mean for each treatment level or the
treatment level specified in {cmd:tlevel()}.  If you specify the
{cmd:tlevel()} option, you need to specify only one new variable; otherwise,
you must specify a new variable for each treatment level.

{phang}
{cmd:censurv} calculates the survivor probability from the time-to-censoring
model.  (In other words, it calculates the probability that an outcome is
not censored.)  This option is allowed only if a censoring model is
specified at estimation time.  You need to specify only one new variable.

{phang}
{cmd:xb} calculates the outcome model linear prediction at each treatment level
or the treatment level specified in {cmd:tlevel()}.  If you specify the
{cmd:tlevel()} option, you need to specify only one new variable; otherwise,
you must specify a new variable for each treatment level.

{phang}
{cmd:lnshape} calculates the log of the conditional latent shape parameter
for each treatment level or the treatment level specified in {cmd:tlevel()}.
This option is valid when the outcome distribution Weibull, log normal, or
gamma is used.  If you specify the {cmd:tlevel()} option, you need to specify
only one new variable; otherwise, you must specify a new variable for each
treatment level.

{phang}
{cmd:clnshape} calculates the log of the conditional latent shape parameter of
the censoring distribution.  This option is valid when the censoring
distribution Weibull, log normal, or gamma is used.  You need to specify only
one new variable.

{phang}
{opt tlevel(treat_level)} specifies the treatment level for
prediction.

{phang}
{cmd:scores} calculates the score variables.  Parameter-level scores
are computed for the treatment mean and average treatment-effect equations.
Equation-level scores are computed for the outcome and censoring
equations.

{pmore}
The jth new variable will contain the scores for the jth parameter in the
coefficient table if j{ul:<}t, where t is the number of treatment levels.
Otherwise, it will contain the scores for fitted equation j-t following the
first t parameters in the coefficient table.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sheart}{p_end}
{phang2}{cmd:. stteffects ipw (smoke age exercise education)}
        {cmd:(age exercise diet education)}{p_end}

{pstd}Estimate the probabilities of being a {cmd:Nonsmoker} and store them in
{cmd:ps0} and of being a {cmd:Smoker} and store them in {cmd:ps1}{p_end}
{phang2}{cmd:. predict ps0 ps1, ps}

{pstd}Summarize the probabilities{p_end}
{phang2}{cmd:. summarize ps0 if fail==1 & smoke==0}{p_end}
{phang2}{cmd:. summarize ps1 if fail==1 & smoke==1}{p_end}

{pstd}Compute the estimated probabilities of failure and then summarize 
them among those that fail{p_end}
{phang2}{cmd:. predict fprob2, censurv}{p_end}
{phang2}{cmd:. summarize fprob if fail==1}{p_end}
