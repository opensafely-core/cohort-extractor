{smcl}
{* *! version 1.0.0  13may2019}{...}
{viewerdialog predict "dialog cmroprobit_p"}{...}
{viewerdialog estat "dialog cmroprobit_estat"}{...}
{vieweralsosee "[CM] cmroprobit postestimation" "mansection CM cmroprobitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmroprobit" "help cmroprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmmprobit" "help cmmprobit"}{...}
{vieweralsosee "[CM] cmmprobit postestimation" "help cmmprobit postestimation"}{...}
{vieweralsosee "[CM] margins" "help cm margins"}{...}
{viewerjumpto "Postestimation commands" "cmroprobit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "cmroprobit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "cmroprobit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "cmroprobit postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "cmroprobit postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "cmroprobit postestimation##examples"}{...}
{p2colset 1 35 37 2}{...}
{p2col:{bf:[CM] cmroprobit postestimation} {hline 2}}Postestimation tools for
cmroprobit{p_end}
{p2col:}({mansection CM cmroprobitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:cmroprobit}:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb cmroprobit postestimation##estat:estat covariance}}covariance matrix of the utility errors for the alternatives{p_end}
{synopt :{helpb cmroprobit postestimation##estat:estat correlation}}correlation matrix of the utility errors for the alternatives{p_end}
{synopt :{helpb cmroprobit postestimation##estat:estat facweights}}covariance factor weights matrix{p_end}
{synoptline}

{pstd}
The following standard postestimation commands are also available:

{synoptset 20}{...}
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
{synopt :{helpb cmroprobit postestimation##margins:margins}}adjusted predictions, predictive margins, and marginal effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb cmroprobit postestimation##predict:predict}}predicted probabilities, estimated linear predictor and its standard error{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection CM cmroprobitpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{newvar}
{ifin}
[{cmd:,} {it:statistic}]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{c )-}
{ifin}{cmd:,}
{opt sc:ores

{synoptset 20 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt pr}}probability of each ranking, by case; the default{p_end}
{synopt :{opt pr1}}probability alternative is preferred{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synoptline}
INCLUDE help esample
{p 4 6 2}
{cmd:predict} omits missing values casewise if {cmd:cmroprobit} 
used casewise deletion (the default); if {cmd:cmroprobit} used
alternativewise deletion (option {cmd:altwise}),
{cmd:predict} uses alternativewise deletion.


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
probabilities, linear predictions, and standard errors.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:pr}, the default, calculates the probability of each ranking.
For each case, one probability is computed for the ranks in 
{cmd:e(depvar)}.

{phang}
{cmd:pr1} calculates the probability that each alternative is preferred.

{phang}
{cmd:xb} calculates the linear prediction
xb_{ij} + {bf:z}_i alpha_j for alternative j and case i.

{phang}
{cmd:stdp} calculates the standard error of the linear prediction.

{phang}
{cmd:scores} calculates the scores for each coefficient in {cmd:e(b)}.
This option requires a new variable list of length equal to 
the number of columns in {cmd:e(b)}.  Otherwise, use the {it:stub}{cmd:*}
syntax to have {cmd:predict} generate enumerated variables with
prefix {it:stub}.


INCLUDE help syntax_cmmargins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt pr}}not allowed with {cmd:margins}{p_end}
{synopt :{opt pr1}}probability alternative is preferred; the default{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt sc:ores}}not allowed with {cmd:margins}{p_end}
{synoptline}

INCLUDE help notes_cmmargins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
probabilities and linear predictions.


{marker syntax_estat}{...}
{marker estat}{...}
{title:Syntax for estat}

{pstd}
Covariance matrix of the utility errors for the alternatives

{p 8 16 2}
{cmd:estat} {cmdab:cov:ariance}
[{cmd:,}
{opth for:mat(%fmt)}
{opth bor:der(matlist##bspec:bspec)}
{opt left(#)}]


{pstd}
Correlation matrix of the utility errors for the alternatives

{p 8 16 2}
{cmd:estat} {cmdab:cor:relation}
[{cmd:,}
{opth for:mat(%fmt)}
{opth bor:der(matlist##bspec:bspec)}
{opt left(#)}]


{pstd}
Covariance factor weights matrix

{p 8 16 2}
{cmd:estat} {cmdab:facw:eights}
[{cmd:,}
{opth for:mat(%fmt)}
{opth bor:der(matlist##bspec:bspec)}
{opt left(#)}]


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat covariance} computes the estimated variance-covariance
matrix of the utility (latent-variable) errors for the alternatives.
The estimates are displayed, and the variance-covariance matrix is
stored in {cmd:r(cov)}.

{pstd}
{cmd:estat correlation} computes the estimated correlation matrix of the
utility (latent-variable) errors for the alternatives.  The estimates are
displayed, and the correlation matrix is stored in {cmd:r(cor)}.

{pstd}
{cmd:estat facweights} displays the covariance factor weights matrix and stores
it in {cmd:r(C)}.


{marker options_estat_co}{...}
{title:Options for estat covariance, estat correlation, and estat facweights}

{phang}
{opth format(%fmt)} sets the matrix display format.
The default for {cmd:estat covariance} and {cmd:estat facweights} is
{cmd:format(%9.0g)}; the default for {cmd:estat correlation}
is {cmd:format(%9.4f)}.

{phang}
{opt border(bspec)} sets the matrix display border style.
The default is {cmd:border(all)}.  See {manhelp matlist P}.

{phang}
{opt left(#)} sets the matrix display left indent.
The default is {cmd:left(2)}.  See {manhelp matlist P}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse travel}{p_end}
{phang2}{cmd:. cmset id mode}{p_end}
{phang2}{cmd:. cmroprobit choice travelcost termtime, casevars(income)}{p_end}

{pstd}Calculate the probability of each ranking{p_end}
{phang2}{cmd:. predict prob}{p_end}

{pstd}Obtain the correlations of the errors in the utility equations{p_end}
{phang2}{cmd:. estat correlation}{p_end}

{pstd}Obtain the covariances of the errors in the utility equations{p_end}
{phang2}{cmd:. estat covariance}{p_end}
