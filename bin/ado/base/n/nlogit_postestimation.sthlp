{smcl}
{* *! version 2.3.1  28apr2019}{...}
{viewerdialog predict "dialog nlogit_p"}{...}
{viewerdialog estat "dialog nlogit_estat"}{...}
{vieweralsosee "[CM] nlogit postestimation" "mansection CM nlogitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] nlogit" "help nlogit"}{...}
{viewerjumpto "Postestimation commands" "nlogit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "nlogit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "nlogit postestimation##syntax_predict"}{...}
{viewerjumpto "estat" "nlogit postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "nlogit postestimation##examples"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[CM] nlogit postestimation} {hline 2}}Postestimation tools for nlogit{p_end}
{p2col:}({mansection CM nlogitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after
{cmd:nlogit}:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb nlogit postestimation##estatalt:estat alternatives}}alternative
summary statistics{p_end}
{synoptline}
{p2colreset}{...}

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
INCLUDE help post_nlcom
{synopt :{helpb nlogit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection CM nlogitpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic}
{opt hlevel(#)}]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{c )-}
{ifin}
{cmd:,} {opt sc:ores}

{synoptset 20 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt pr}}predicted probabilities of choosing the alternatives
         at all levels of the hierarchy or at level {it:#}, where {it:#} is
	 specified by {opt hlevel(#)}; the default{p_end}
{synopt :{opt xb}}linear predictors for all levels of the
	hierarchy or at level {it:#}, where {it:#} is specified by 
	{opt hlevel(#)}{p_end}
{synopt :{opt condp}}predicted conditional probabilities at all 
	levels of the hierarchy or at level {it:#}, where {it:#} is specified
	by {opt hlevel(#)}{p_end}
{synopt :{opt iv}}inclusive values for levels 2, ..., {cmd:e(levels)}
	or for {opt hlevel(#)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
The inclusive value for the first-level alternatives is not used in
estimation; therefore, it is not calculated.{p_end}
INCLUDE help esample
{p 4 6 2}
{cmd:predict} omits missing values casewise if {cmd:nlogit} used casewise
deletion (the default); if {cmd:nlogit} used alternativewise deletion (option
{cmd:altwise}), {cmd:predict} uses alternativewise deletion.


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
probabilities, linear predictions, conditional probabilities, and inclusive
values.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt pr} calculates the probability of choosing each alternative at each 
level of the hierarchy.  Use the {opt hlevel(#)} option to
compute the alternative probabilities at level {it:#}.  When
{opt hlevel(#)} is not specified, {it:j} new variables must be
given, where {it:j} is the number of levels, or use {it:stub}{cmd:*}
to have {cmd:predict} generate {it:j} variables with the prefix
{it:stub} and numbered from 1 to {it:j}.  The {cmd:pr} option is the default,
and if one new variable is given, the probability of the bottom-level
alternatives are computed.  Otherwise, probabilities for all levels are
computed, and {it:stub}{cmd:*} is still valid.

{phang}
{opt xb} calculates the linear prediction for each alternative at each level.
Use the {opt hlevel(#)} option to compute the linear predictor at level
{it:#}.  When {opt hlevel(#)} is not specified, {it:j} new variables must be
given, where {it:j} is the number of levels, or use {it:stub}{cmd:*}
to have {cmd:predict} generate {it:j} variables with the prefix {it:stub}
and numbered from 1 to {it:j}.

{phang}
{opt condp} calculates the conditional probabilities for each alternative at
each level.  Use the {opt hlevel(#)} option to compute the conditional
probabilities of the alternatives at level {it:#}.  When {opt hlevel(#)} is
not specified, {it:j} new variables must be given, where {it:j} is the number
of levels, or use {it:stub}{cmd:*} to have {cmd:predict} generate
{it:j} variables with the prefix {it:stub} and numbered from 1 to {it:j}.

{phang}
{opt iv} calculates the inclusive value for each alternative at each level.
Use the {opt hlevel(#)} option to compute the inclusive value at level {it:#}.
There is no inclusive value at level 1.  If {opt hlevel(#)} is not used,
{it:j}-1 new variables are required, where {it:j} is the number of levels, or
use {it:stub}{cmd:*} to have {cmd:predict} generate {it:j}-1 variables with
the prefix {it:stub} and numbered from 2 to {it:j}.  See 
{mansection CM nlogitMethodsandformulas:{it:Methods and formulas}} in
{hi:[CM] nlogit} for a definition of the inclusive values.

{phang}
{opt hlevel(#)} calculates the prediction only for hierarchy level {it:#}.

{phang}
{opt scores} calculates the scores for each coefficient in {cmd:e(b)}.
This option requires a new-variable list of length equal to 
the number of columns in {cmd:e(b)}.  Otherwise, use {it:stub}{cmd:*}
to have {cmd:predict} generate enumerated variables with prefix {it:stub}.


{marker syntax_estat}{...}
{marker estatalt}{...}
{title:Syntax for estat}

{p 8 16 2}
{cmd:estat}
{opt alt:ernatives}


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat} {cmd:alternatives} displays summary statistics about the
alternatives in the estimation sample for each level of the tree structure.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse restaurant}{p_end}
{phang2}{cmd:. nlogitgen type = restaurant(fast: Freebirds | MamasPizza,} 
    {cmd:family:  CafeEccell | LosNortenos | WingsNmore, fancy: Christophers |}
    {cmd:MadCows)}{p_end}
{phang2}{cmd:. nlogit chosen cost rating distance || type: income kids, }
    {cmd:base(family) || restaurant:, noconst case(family_id)}{p_end}

{pstd}Compute probability of bottom-level alternative{p_end}
{phang2}{cmd:. predict pr}{p_end}

{pstd}Compute probabilities at each level{p_end}
{phang2}{cmd:. predict double p*, pr}{p_end}

{pstd}Compute probability of bottom-level alternative conditional on
second-level decision{p_end}
{phang2}{cmd:. predict condp, condp hlevel(2)}{p_end}

{pstd}Compute inclusive values{p_end}
{phang2}{cmd:. predict iv, iv}{p_end}

{pstd}Summarize alternatives on second-level decision{p_end}
{phang2}{cmd:. estat alternatives}{p_end}
