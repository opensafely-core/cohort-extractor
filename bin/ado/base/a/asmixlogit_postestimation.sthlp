{smcl}
{* *! version 1.0.3  01apr2019}{...}
{viewerdialog predict "dialog asmixlogit_p"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] asmixlogit" "help asmixlogit"}{...}
{viewerjumpto "Postestimation commands" "asmixlogit postestimation##description"}{...}
{viewerjumpto "predict" "asmixlogit postestimation##syntax_predict"}{...}
{viewerjumpto "Examples" "asmixlogit postestimation##examples"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[R] asmixlogit postestimation} {hline 2}}Postestimation tools for
asmixlogit{p_end}
{p2col:}({browse "http://www.stata.com/manuals15/rasmixlogitpostestimation.pdf":View complete PDF manual entry}){p_end}
{p2colreset}{...}

{pstd}
{cmd:asmixlogit} continues to work but, as of Stata 16, is no longer an
official part of Stata.  This is the original help file, which we will no
longer update, so some links may no longer work.

{pstd}
See {helpb cmmixlogit} for a recommended alternative to {cmd:asmixlogit}.


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following standard postestimation commands are available after
{cmd:asmixlogit}:

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
INCLUDE help post_nlcom
{synopt :{helpb asmixlogit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic} {opt altwise}]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:stub}{cmd:*}{c |}{it:{help newvarlist}}{c )-}
{ifin}
{cmd:,} {opt sc:ores}

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab:Main}
{synopt :{opt p:r}}probability alternative is chosen; the default{p_end}
{synopt :{cmd:xb}}linear prediction{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
probabilities or linear predictions.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt pr}, the default, calculates the probability that alternative {it:a}
is chosen in case {it:i}.

{phang}
{opt xb} calculates the linear prediction for alternative {it:a} and case
{it:i}.

{phang}
{opt altwise} specifies that alternativewise deletion be used when marking out
observations due to missing values in your variables.  The default is to use
casewise deletion.

{phang}
{opt scores} calculates the scores for each coefficient in {cmd:e(b)}.
This option requires a new variable list of length equal to 
the number of columns in {cmd:e(b)}.  Otherwise, use the {it:stub}{cmd:*}
syntax to have {cmd:predict} generate enumerated variables with
prefix {it:stub}.


{marker examples}{...}
{title:Examples}

    Setup
{phang2}{cmd:. webuse inschoice}{p_end}

{pstd}Fit mixed logit model with fixed and random coefficients{p_end}
{phang2}{cmd:. asmixlogit choice premium, case(id) alternatives(insurance)}
     {cmd:random(deductible)}{p_end}

{pstd}Calculate probability alternative is chosen{p_end}
{phang2}{cmd:. predict p}{p_end}
