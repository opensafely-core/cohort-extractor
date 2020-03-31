{smcl}
{* *! version 1.0.7  04jun2018}{...}
{viewerdialog predict "dialog eteffects_p"}{...}
{viewerdialog estat "dialog estat"}{...}
{vieweralsosee "[TE] eteffects postestimation" "mansection TE eteffectspostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] eteffects" "help eteffects"}{...}
{viewerjumpto "Postestimation commands" "eteffects postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "eteffects_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "eteffects postestimation##syntax_predict"}{...}
{viewerjumpto "estat" "eteffects postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "eteffects postestimation##examples"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[TE] eteffects postestimation} {hline 2}}Postestimation tools for
eteffects{p_end}
{p2col:}({mansection TE eteffectspostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after
{cmd:eteffects}: 

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb eteffects postestimation##syntax_estat:estat endogenous}}perform tests of endogeneity{p_end}
{synoptline}
{p2colreset}{...}


{pstd}
The following standard postestimation commands are available after
{cmd:eteffects}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_hausman
INCLUDE help post_lincom
INCLUDE help post_nlcom
{synopt :{helpb eteffects postestimation##predict:predict}}predictions,
residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE eteffectspostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvar}} {c |} {it:{help newvarlist}}{c )-}
{ifin}
[{cmd:,} {it:statistic} {opt tle:vel}]

{synoptset 15 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt te}}treatment effect; the default{p_end}
{synopt :{opt cm:ean}}conditional mean at treatment level{p_end}
{synopt :{opt ps}}propensity score{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt psxb}}linear prediction for propensity score{p_end}
{synopt :{opt xbt:otal}}linear prediction, using residuals from treatment
model{p_end}
{synopt :{opt sc:ores}}parameter-level or equation-level scores{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
Specify one new variable with {cmd:te}; specify one or two new variables with
{cmd:cmean}, {cmd:ps}, and {cmd:xb}.


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as treatment
effects, conditional means, propensity scores, and linear predictions.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt te}, the default, calculates the treatment effect.

{phang}
{opt cmean}  calculates the conditional mean for the control group.
To also obtain the conditional mean for the treatment group, specify two
variables. If you want the conditional mean for only the treatment group,
specify the {opt tlevel} option.

{phang}
{opt ps} calculates the probability of being in the control group.  To also
obtain the probability of being in the treatment group, specify two variables.
If you want the probability of being in the treatment group only, specify
the {opt tlevel} option.

{phang}
{opt xb} calculates the linear prediction for the  control group.  To also
obtain the linear prediction for the treatment group, specify two
variables.  If you want the linear prediction for only the treatment group,
specify the {opt tlevel} option.

{phang}
{opt psxb} calculates the linear prediction for the propensity score.

{phang}
{opt xbtotal} calculates the linear prediction for the  control group,
including the residuals from the treatment model as regressors.  To also
obtain the linear prediction for the treatment group, specify two variables.
If you want the linear prediction, including the residuals from the treatment
model as regressors, only for the treatment group, specify the {opt tlevel}
option.

{phang}
{opt tlevel} specifies that the statistic be calculated for the treatment
group; the default is to calculate the statistic for the control group.

{phang}
{opt scores} calculates the score variables. For {opt eteffects}, this is the
same as the residuals in the moment conditions used by the generalized method
of moments (see {manhelp gmm G}). For the average treatment effect, the
average treatment effect on the treated, and the potential-outcome means,
parameter-level scores are computed.  For the auxiliary equations,
equation-level scores are computed.


{marker syntax_estat}{...}
{marker estatendog}{...}
{title:Syntax for estat}

{p 8 16 2}
{cmd:estat} {cmdab:endog:enous}


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd} 
{cmd:estat endogenous} performs a Wald test to determine whether the
estimated correlations between the treatment-assignment and potential-outcome
models are different from zero.  The null hypothesis is that the correlations
are jointly zero.  Rejection of the null hypothesis suggests endogeneity. 


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse cattaneo2}{p_end}
{phang2}{cmd:. eteffects (bweight i.prenatal1 i.mmarried mage i.fbaby)}
          {cmd:(mbsmoke i.mmarried mage i.fbaby medu fedu)}{p_end}

{phang}Test for endogeneity {p_end}
{phang2}{cmd:. estat endogenous}{p_end}

{phang}Compute the estimated treatment probabilities{p_end}
{phang2}{cmd:. predict prob1 prob2, ps}{p_end}

{phang}Summarize the estimated treatment probabilities{p_end}
{phang2}{cmd:. summarize prob1 if mbsmoke==1, detail}{p_end}

{phang}Summarize the estimated control probabilities{p_end}
{phang2}{cmd:. summarize prob2 if mbsmoke==0, detail}{p_end}
