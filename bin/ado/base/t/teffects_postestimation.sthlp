{smcl}
{* *! version 1.0.6  04jun2018}{...}
{viewerdialog predict "dialog teffects_p"}{...}
{vieweralsosee "[TE] teffects postestimation" "mansection TE teffectspostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects overlap" "help teffects overlap"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects aipw" "help teffects aipw"}{...}
{vieweralsosee "[TE] teffects ipw" "help teffects ipw"}{...}
{vieweralsosee "[TE] teffects ipwra" "help teffects ipwra"}{...}
{vieweralsosee "[TE] teffects nnmatch" "help teffects nnmatch"}{...}
{vieweralsosee "[TE] teffects psmatch" "help teffects psmatch"}{...}
{vieweralsosee "[TE] teffects ra" "help teffects ra"}{...}
{viewerjumpto "Postestimation commands" "teffects postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "teffects_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "teffects postestimation##predict"}{...}
{viewerjumpto "Examples" "teffects postestimation##examples"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[TE] teffects postestimation} {hline 2}}Postestimation tools for
teffects{p_end}
{p2col:}({mansection TE teffectspostestimation:View complete PDF manual entry}){p_end}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after
{cmd:teffects}:

{synoptset 16}{...}
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
{synopt :{helpb teffects postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE teffectspostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker predict}{...}
{title:Syntaxes for predict}

{pstd}
Syntaxes are presented under the following headings:

        {help teffects postestimation##syntax_predict_ipwraaipw:Syntax for predict after aipw and ipwra}
        {help teffects postestimation##syntax_predict_ipw:Syntax for predict after ipw}
        {help teffects postestimation##syntax_predict_match:Syntax for predict after nnmatch and psmatch}
        {help teffects postestimation##syntax_predict_ra:Syntax for predict after ra}


{marker syntax_predict_ipwraaipw}{...}
{title:Syntax for predict after aipw and ipwra}

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
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt psxb}}linear prediction for propensity score{p_end}
{synopt :{opt lns:igma}}log square root of conditional latent variance (for outcome model {cmd:hetprobit()}) at treatment level{p_end}
{synopt :{opt pslns:igma}}log square root of latent variance (for treatment model {cmd:hetprobit()}) for propensity score{p_end}
{synopt :{opt sc:ores}}parameter-level or equation-level scores{p_end}
{synoptline}
{p 4 6 2}
If you do not specify {cmd:tlevel()} and only specify one new variable,
{cmd:te} and {cmd:psxb} assume {opt tlevel()} specifies the first noncontrol
 treatment level. {p_end}
{p 4 6 2}
If you do not specify {cmd:tlevel()} and only specify one new variable, 
{cmd:cmean}, {cmd:ps}, {cmd:xb}, and {cmd:lnsigma} assume {cmd:tlevel()}
 specifies the first treatment level.{p_end}
{p 4 6 2}
You specify one or t new variables with {cmd:cmean}, {cmd:ps}, {cmd:xb},
and {cmd:lnsigma}, where t is the number of treatment levels.{p_end}
{p 4 6 2}
You specify one or t-1 new variables with {cmd:te}, {cmd:psxb}, and
{cmd:pslnsigma}.{p_end}


{marker syntax_predict_ipw}{...}
{marker predict}{...}
{title:Syntax for predict after ipw}

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
{synopt :{opt xb}}linear prediction for the propensity score{p_end}
{synopt :{opt lns:igma}}log square root of latent variance (for treatment model {cmd:hetprobit()}){p_end}
{synopt :{opt sc:ores}}parameter-level or equation-level scores{p_end}
{synoptline}
{p 4 6 2}
If you do not specify {cmd:tlevel()} and only specify one new variable, {cmd:ps} assumes {opt tlevel()} specifies the first treatment level.
{p_end}
{p 4 6 2}
If you do not specify {cmd:tlevel()} and only specify one new variable, {cmd:xb}
assumes {opt tlevel()} specifies the first noncontrol treatment level.{p_end}
{p 4 6 2}
You specify one or t new variables with {cmd:ps}, where t is the number of treatment levels.{p_end}
{p 4 6 2}
You specify one or t-1 new variables with {cmd:xb} and {cmd:lnsigma}.{p_end}


{marker syntax_predict_match}{...}
{marker predict}{...}
{title:Syntax for predict after nnmatch or psmatch}

{p 8 16 2}
{cmd:predict} {dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{c )-} 
[{cmd:,} {it:statistic} {opt tl:evel}{cmd:(}{it:treat_level}{cmd:)}]

{synoptset 14 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab :Main}
{synopt :{opt te}}treatment effect; the default{p_end}
{synopt :{opt po}}potential outcome{p_end}
{synopt :{opt dist:ance}}nearest-neighbor distance{p_end}
{synopt :{opt ps}}propensity score ({cmd:psmatch}
	only){p_end}
{synopt :{opt lns:igma}}log square root of latent variance (for treatment model {cmd:hetprobit()}){p_end}
{synoptline}
{p 4 6 2} These statistics are available for the estimation sample only
and require the estimation option {cmd:generate(}{it:stub}{cmd:)}.  This is
because of the nonparametric nature of the matching estimator.{p_end}
{p 4 6 2} If you do not specify {cmd:tlevel()} and only specify one new
variable, {cmd:po} and {cmd:ps} assume {opt tlevel()} specifies the first
 treatment level.{p_end}
{p 4 6 2} You specify one new variable with {cmd:te} and {cmd:lnsigma}.{p_end}
{p 4 6 2} You specify one or two new variables with {cmd:po} and {cmd:ps}.{p_end}
{p2colreset}{...}


{marker syntax_predict_ra}{...}
{marker predict}{...}
{title:Syntax for predict after ra}

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
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt lns:igma}}log square root of conditional latent variance (for outcome model {cmd:hetprobit()}) at treatment level{p_end}
{synopt :{opt sc:ores}}parameter-level or equation-level scores{p_end}
{synoptline}
{p 4 6 2}
If you do not specify {cmd:tlevel()} and only specify one new variable,
{cmd:te} assumes {opt tlevel()} specifies the first
noncontrol treatment level. {p_end}
{p 4 6 2}
If you do not specify {cmd:tlevel()} and only specify one new variable, 
{cmd:cmean}, {cmd:xb}, and {cmd:lnsigma} assume {opt tlevel()} specifies the 
first treatment level.{p_end}
{p 4 6 2}
You specify one or t new variables with {cmd:cmean}, {cmd:xb}, and
{cmd:lnsigma}, where t is the number of treatment levels.{p_end}
{p 4 6 2}
You specify one or t-1 new variables with {cmd:te}.{p_end}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
treatment effects, potential outcomes, conditional means, propensity scores,
linear predictions, nearest-neighbor distances, and log square root of latent
variances.


{title:Options for predict}

{pstd}
Options are presented under the following headings:

        {help teffects postestimation##options_predict_ipwraaipw:Options for predict after aipw and ipwra}
        {help teffects postestimation##options_predict_ipw:Options for predict after ipw}
        {help teffects postestimation##options_predict_match:Options for predict after nnmatch and psmatch}
        {help teffects postestimation##options_predict_ra:Options for predict after ra}


{marker options_predict_ipwraaipw}{...}
{title:Options for predict after aipw and ipwra}

{dlgtab:Main}

{phang}
{opt te}, the default, calculates the treatment effect for each noncontrol
treatment level or the treatment level specified in {opt tlevel()}.  If you
specify the {opt tlevel()} option, you need to specify only one new variable;
otherwise, you must specify a new variable for each treatment level (except the
control level).

{phang}
{opt cmean} calculates the conditional mean for each treatment level or the
treatment level specified in {opt tlevel()}.  If you specify the {opt tlevel()}
option, you need to specify only one new variable; otherwise, you must specify
a new variable for each treatment level. 

{phang}
{opt ps} calculates the propensity score of each treatment level or the
treatment level specified in {opt tlevel()}.  If you specify the
{opt tlevel()} option, you need to specify only one new variable; otherwise,
you must specify a new variable for each treatment level.

{phang}
{opt xb} calculates the linear prediction at each treatment level or the
treatment level specified in {opt tlevel()}.  If you specify the {opt tlevel()}
option, you need to specify only one new variable; otherwise, you must specify
a new variable for each treatment level. 

{phang}
{opt psxb} calculates the linear prediction for the propensity score at each
noncontrol level of the treatment or the treatment level specified in
{opt tlevel()}.  If you specify the {opt tlevel()} option, you need to specify
only one new variable; otherwise, you must specify a new variable for each
treatment level (except the control level).

{phang}
{opt lnsigma} calculates the log square root of the conditional latent variance
for each treatment level or the treatment level specified in {opt tlevel()}.
This option is valid when outcome model {cmd:hetprobit()} was used.  If you
specify the {opt tlevel()} option, you need to specify only one new variable;
otherwise, you must specify a new variable for each treatment level.

{phang}
{opt pslnsigma} calculates the log square root of the latent variance for the
propensity score.  This option is only valid when treatment model
{cmd:hetprobit()} was used.  Specify only one new variable.

{phang}
{opt tlevel(treat_level)} specifies the treatment level for prediction.

{phang}
{opt scores} calculates the score variables.  Parameter-level scores are
computed for the treatment mean and average treatment-effect equations.
Equation-level scores are computed for the propensity-score equations.

{pmore}
The jth new variable will contain the scores for the jth parameter in the
coefficient table if j<=t, where t is the number of treatment levels.
Otherwise, it will contain the scores for fitted equation j-t following the
first t parameters in the coefficient table.


{marker options_predict_ipw}{...}
{title:Options for predict after ipw}

{dlgtab:Main}

{phang}
{opt ps}, the default, calculates the propensity score of each treatment level
or the treatment level specified in {opt tlevel()}.
If you specify the {opt tlevel()} option, you need to specify only one new
variable; otherwise, you must specify a new variable for each treatment level.

{phang}
{opt xb} calculates the linear prediction for the propensity score at each
noncontrol level of the treatment or the treatment level specified in 
{opt tlevel()}.  If you specify the {opt tlevel()} option, you need to specify
only one new variable; otherwise, you must specify a new variable for each
treatment level (except the control level).

{phang}
{opt lnsigma} calculates the log square root of the latent variance.  This
option is only valid when treatment model {cmd:hetprobit()} was used.
Specify only one new variable.

{phang}
{opt tlevel(treat_level)} specifies the treatment level for prediction.

{phang}
{opt scores} calculates the score variables.  Parameter-level scores are
computed for the treatment mean and average treatment-effect equations.
Equation-level scores are computed for the propensity-score equations.   

{pmore}
The jth new variable will contain the scores for the jth parameter in the
coefficient table if j<=t, where t is the number of treatment levels.
Otherwise, it will contain the scores for fitted equation j-t following the
first t parameters in the coefficient table.


{marker options_predict_match}{...}
{title:Options for predict after nnmatch and psmatch}

{dlgtab:Main}

{phang}
{opt te}, the default, calculates the treatment effect.

{phang}
{opt po} calculates the potential outcomes for each observation and
treatment level or the treatment level specified in {opt tlevel()}.  If you
specify the {opt tlevel()} option, you need to specify only one new variable;
otherwise, you must specify new variables for the control and treated groups.

{phang}
{opt distance} calculates the distances of the nearest neighbors for each
observation.  The number of variables generated is equal to the maximum number
of nearest-neighbor matches.  This is equal to the number of index variables
generated by the estimation option {opt generate(stub)}.  You may
use the {it:stub}{cmd:*} syntax to set the distance variable prefix:
{it:stub}{cmd:1}, {it:stub}{cmd:2}, ....

{phang}
{opt ps} calculates the propensity score of each treatment level or the
propensity score of the treatment level specified in {opt tlevel()}.  If you
specify the {opt tlevel()} option, you need to specify only one new variable;
otherwise, you must specify new variables for the control and treated groups.

{phang}
{opt lnsigma} calculates the log square root of the latent variance.  This
option is only valid when treatment model {cmd:hetprobit()} was used.
Specify only one new variable.

{phang}
{opt tlevel(treat_level)} restricts potential-outcome estimation to either the
treated group or the control group.  This option may only be specified with
options {cmd:po} and {cmd:ps}.


{marker options_predict_ra}{...}
{title:Options for predict after ra}

{dlgtab:Main}

{phang}
{opt te}, the default, calculates the treatment effect for each noncontrol
treatment level or the treatment level specified in
{opt tlevel()}.  If you specify the {opt tlevel()} option, you need to specify
only one new variable; otherwise, you must specify a new variable for each
treatment level (except the control level).

{phang}
{opt cmean} calculates the conditional mean for each treatment level or the
treatment level specified in {opt tlevel()}.  If you specify the {opt tlevel()}
option, you need to specify only one new variable; otherwise, you must specify a
new variable for each treatment level. 

{phang}
{opt xb} calculates the linear prediction at each treatment level or the
treatment level specified in {opt tlevel()}.  If you specify the {opt tlevel()}
option, you need to specify only one new variable; otherwise, you must specify a
new variable for each treatment level. 

{phang}
{opt lnsigma} calculates the log square root of the conditional latent variance
for each treatment level or the treatment level specified in {opt tlevel()}.
This option is valid when outcome model {cmd:hetprobit()} was used.  If you
specify the {opt tlevel()} option, you need to specify only one new variable;
otherwise, you must specify a new variable for each treatment level.

{phang}
{opt tlevel(treat_level)} specifies the treatment level for prediction.

{phang}
{opt scores} calculates the score variables.  Parameter-level scores are
computed for the treatment mean and average treatment-effect equations.
Equation-level scores are computed for the regression equations.   

{pmore}
The jth new variable will contain the scores for the jth parameter in the
coefficient table if j<=t, where t is the number of treatment levels.
Otherwise, it will contain the scores for fitted equation j-t following the
first t parameters in the coefficient table.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse cattaneo2}{p_end}

{pstd}Estimate treatment effects by propensity score matching{p_end}
{phang2}{cmd:. teffects psmatch (bweight) (mbsmoke mmarried c.mage##c.mage}
          {cmd:fbaby medu, probit), generate(po)}{p_end}

{pstd}Calculate the treatment effect (the default){p_end}
{phang2}{cmd:. predict treatment}{p_end}

{pstd}Predict propensity scores for the control group{p_end}
{phang2}{cmd:. predict pscore, ps}{p_end}
