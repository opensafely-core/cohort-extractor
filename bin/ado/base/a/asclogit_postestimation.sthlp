{smcl}
{* *! version 1.3.3  01apr2019}{...}
{viewerdialog predict "dialog asclogit_p"}{...}
{viewerdialog estat "dialog asclogit_estat"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] asclogit" "help asclogit"}{...}
{viewerjumpto "Postestimation commands" "asclogit postestimation##description"}{...}
{viewerjumpto "predict" "asclogit postestimation##syntax_predict"}{...}
{viewerjumpto "estat" "asclogit postestimation##syntax_estat"}{...}
{viewerjumpto "Remarks" "asclogit postestimation##remarks"}{...}
{viewerjumpto "Examples" "asclogit postestimation##examples"}{...}
{viewerjumpto "Stored results" "asclogit postestimation##results"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[R] asclogit postestimation} {hline 2}}Postestimation tools for 
asclogit{p_end}
{p2col:}({browse "http://www.stata.com/manuals15/rasclogitpostestimation.pdf":View complete PDF manual entry}){p_end}
{p2colreset}{...}

{pstd}
{cmd:asclogit} continues to work but, as of Stata 16, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.

{pstd}
See {helpb cmclogit} for a recommended alternative to {cmd:asclogit}.


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:asclogit}:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb asclogit postestimation##estatalt:estat alternatives}}alternative
	summary statistics{p_end}
{synopt :{helpb asclogit postestimation##estatmfx:estat mfx}}marginal
	effects{p_end}{synoptline}
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
{synopt :{helpb asclogit postestimation##predict:predict}}predicted
probabilities, estimated linear predictor and its standard error{p_end}
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
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic} {it:options}]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:stub}{cmd:*}{c |}{it:{help newvarlist}}{c )-}
{ifin}
{cmd:,} {opt sc:ores}

{synoptset 15 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{opt p:r}}probability that each alternative is chosen; the default
{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synoptline}

{synopthdr:options}
{synoptline}
{syntab:Main}
{p2coldent :* {cmd:k(}{it:#}|{cmd:observed)}}condition on {it:#} 
	alternatives per case or on observed number of alternatives{p_end}
{synopt :{opt altwise}}use alternativewise deletion instead of casewise
	deletion when computing probabilities{p_end}
{synopt :{opt nooff:set}}ignore the {cmd:offset()} variable specified in
	{cmd:asclogit}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
*{cmd:k(}{it:#}|{cmd:observed)} may be used only with {opt pr}.{p_end}
INCLUDE help esample


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
{opt pr} computes the probability of choosing each alternative conditioned
on each case choosing {opt k()} alternatives.
This is the default statistic with default {cmd:k(1)}; one alternative per 
case is chosen.

{phang} 
{opt xb} computes the linear prediction.

{phang}
{opt stdp} computes the standard error of the linear prediction.

{phang}
{cmd:k(}{it:#}|{cmd:observed)} condition the probability on 
{it:#} alternatives per case or on the observed number of alternatives.
The default is {cmd:k(1)}.  This option may be used only with the {cmd:pr}
option.

{phang}
{opt altwise} specifies that alternativewise deletion be used when
marking out observations due to missing values in your variables.  The default
is to use casewise deletion.  The {cmd:xb} and {cmd:stdp} options always use
alternativewise deletion.

{phang}
{opt nooffset} is relevant only if you specified {cmd:offset({varname})} for
{cmd:asclogit}. It modifies the calculations made by {cmd:predict} so that they
ignore the offset variable; the linear prediction is treated as {cmd:xb} rather
than as {cmd:xb} + {cmd:offset}.  

{phang}
{opt scores} calculates the scores for each coefficient in {cmd:e(b)}.
This option requires a new variable list of length equal to 
the number of columns in {cmd:e(b)}.  Otherwise, use the {it:stub}{cmd:*}
syntax to have {cmd:predict} generate enumerated variables with
prefix {it:stub}.


{marker syntax_estat}{...}
{marker estatalt}{marker estatmfx}{...}
{title:Syntax for estat}

{pstd}Alternative summary statistics

{p 8 16 2}
{cmd:estat}
{opt alt:ernatives}


{pstd}Marginal effects

{p 8 16 2}
{cmd:estat}
{opt mfx}
{ifin}
[{cmd:,} {it:options}]


{synoptset 35 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}

{synopt : {opth var:list(varlist)}}display marginal effects for
	{it:varlist}{p_end}
{synopt : {cmd:at(mean} [{it:{help asclogit postestimation##atlist:atlist}}]|{cmd:median} [{it:{help asclogit postestimation##atlist:atlist}}]{cmd:)}}calculate
	marginal effects at these values{p_end}
{synopt : {opt k(#)}}condition on the number of alternatives chosen to be {it:#}

{syntab:Options}
{synopt : {opt l:evel(#)}}set confidence interval level; default is 
	{cmd:level(95)}{p_end}
{synopt :{opt noe:sample}}do not restrict calculation of means and medians
	to the estimation sample{p_end}
{synopt :{opt now:ght}}ignore weights when calculating means and medians{p_end}
{synoptline}
{p2colreset}{...}


{marker menu_estat}{...}
INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd: estat alternatives} displays summary statistics about the alternatives
in the estimation sample.

{pstd}
{cmd: estat mfx} computes probability marginal effects.


{marker options_estat_mfx}{...}
{title:Options for estat mfx}

{dlgtab:Main}

{phang}
{opth varlist(varlist)} specifies the variables for which to display marginal
	effects.  The default is all variables.

{* although the code is such that you can type at(mean), at(mean atlist),}{...}
{* at(median), at(median atlist), or just at(atlist); we are documenting}{...}
{* as such that you have to type either mean or median with atlist}{...}
{marker atlist}{...}
{phang}
{cmd:at(}{cmd:mean} [{it:atlist}]|{cmd:median} [{it:atlist}]{cmd:)}
specifies the values at which the marginal effects are to be calculated.
{it:atlist} is 

{pmore2}
[[{it:alternative}{cmd::}{it:variable} {cmd:=} {it:#}] [{it:variable} {cmd:=} {it:#}] [{it:alternative}{cmd::}{it:offset} {cmd:=} {it:#}] [...]]

{pmore}
The default is to calculate the marginal effects at the means of the independent
variables by using the estimation sample, {cmd:at(mean)}.  If {cmd:offset()}
is used during estimation, the means of the offsets (by alternative) are
computed by default.

{pmore}
After specifying the summary statistic, you can specify a series of specific
values for variables.  You can specify values for alternative-specific
variables by alternative, or you can specify one value for all alternatives.
You can specify only one value for case-specific variables.  You specify
values for the {cmd:offset()} variable (if present) the same way as for
alternative-specific variables.  For example, in the {cmd:choice} dataset (car
choice), {cmd:income} is a case-specific variable, whereas {cmd:dealer} is an
alternative-specific variable.  The following would be a legal syntax for
{cmd:estat mfx}:

{p 12 16 2}{cmd:. estat mfx, at(mean American:dealer=18 income=40)}{p_end}

{pmore}
{cmd:at(mean} [{it:atlist}]{cmd:)} or
{cmd:at(median} [{it:atlist}]{cmd:)} has no effect on computing marginal
effects for factor variables, which are calculated as the discrete change
in the probability as the factor variable changes from the
base level to the level specified in option {bf:at()}.  If a factor level is
not specified in the {bf:at()} option, the first level that is not the base
is used.

{pmore}
The mean and median computations respect any {cmd:if} or {cmd:in}
qualifiers, so you can restrict the data over which the statistic is 
computed. You can even restrict the values to a specific case, for example, 

{p 12 16 2}{cmd:. estat mfx if case==21}{p_end}

{phang}
{opt k(#)} computes the probabilities conditioned on {it:#} alternatives
chosen.  The default is one alternative chosen.

{dlgtab:Options}

{phang}
{opt level(#)} sets the confidence level; default is {cmd:level(95)}.

{phang}
{opt noesample} specifies that the whole dataset be considered instead of only
those marked in the {cmd:e(sample)} defined by the {cmd:asclogit} command.

{phang}
{opt nowght} specifies that weights be ignored when calculating the medians.


{marker remarks}{...}
{title:Remarks}

{pstd}
Probability marginal effects cannot be computed for a variable that is
specified in both the alternative-specific and case-specific variable lists.
Computations assume that these two variable lists are mutually exclusive.  For
example, {cmd:estat mfx} exits with an error message if your model has
independent variables that are the interaction between alternative-specific
variables ({it:indepvars} specified in {helpb asclogit##syntax:asclogit}) and
case-specific variables ({it:varlist} specified in the
{helpb asclogit##syntax:casevars()} option).  Marginal effect computations can
proceed if you specify a variable list in the {cmd:varlist()} option of
{cmd:estat mfx} that excludes the variables that are used in both the
alternative-specific and case-specific variable lists.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse choice}{p_end}

{pstd}Fit alternative-specific logit model{p_end}
{phang2}{cmd:. asclogit choice dealer, case(id) alternatives(car)}
           {cmd:casevars(sex income)}{p_end}

{pstd}Predict probability each alternative is chosen{p_end}
{phang2}{cmd:. predict p if e(sample)}{p_end}

{pstd}Predict probability each alternative is chosen, conditional on each
case choosing two alternatives{p_end}
{phang2}{cmd:. predict p2, k(2)}{p_end}

{pstd}Obtain summary statistics about the alternatives{p_end}
{phang2}{cmd:. estat alt}{p_end}

{pstd}Obtain marginal effects assuming each person is female and there is one
dealership of each nationality in each city{p_end}
{phang2}{cmd:. estat mfx, varlist(sex income) at(sex=0 dealer=1)}{p_end}


{marker results}{...}
{title:Stored results}

{phang}
{cmd:estat mfx} stores the following in {opt r()}:


{phang}
{cmd: r(pr_}{it:alt}{opt )} scalars containing the computed probability
of each alternative evaluated at the value that is labeled X in the table
output.  Here {it:alt} are the labels in the macro {cmd:e(alteqs)}.

{phang}
{cmd: r(}{it:alt}{opt )} matrices containing the computed marginal effects and
associated statistics.  There is one matrix for each alternative, where
{it:alt} are the labels in the macro {cmd:e(alteqs)}.  Column 1 of each matrix
contains the marginal effects; column 2, their standard errors; column 3, their
z statistics; and columns 4 and 5, the confidence intervals.  Column 6 contains
the values of the independent variables used to compute the probabilities 
{cmd:r(pr_}{it:alt}{opt )}.
{p_end}
