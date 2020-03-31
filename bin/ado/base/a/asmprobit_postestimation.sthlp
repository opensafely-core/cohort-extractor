{smcl}
{* *! version 2.4.3  01apr2019}{...}
{viewerdialog predict "dialog asmprobit_p"}{...}
{viewerdialog estat "dialog asmprobit_estat"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] asmprobit" "help asmprobit"}{...}
{viewerjumpto "Postestimation commands" "asmprobit postestimation##description"}{...}
{viewerjumpto "predict" "asmprobit postestimation##syntax_predict"}{...}
{viewerjumpto "estat" "asmprobit postestimation##syntax_estat"}{...}
{viewerjumpto "Remarks" "asmprobit postestimation##remarks"}{...}
{viewerjumpto "Examples" "asmprobit postestimation##examples"}{...}
{viewerjumpto "Stored results" "asmprobit postestimation##results"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[R] asmprobit postestimation} {hline 2}}Postestimation tools for
asmprobit{p_end}
{p2col:}({browse "http://www.stata.com/manuals15/rasmprobitpostestimation.pdf":View complete PDF manual entry}){p_end}
{p2colreset}{...}

{pstd}
{cmd:asmprobit} continues to work but, as of Stata 16, is no longer an
official part of Stata.  This is the original help file, which we will no
longer update, so some links may no longer work.

{pstd}
See {helpb cmmprobit} for a recommended alternative to {cmd:asmprobit}.


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:asmprobit}:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb asmprobit postestimation##estatalt:estat alternatives}}alternative summary statistics{p_end}
{synopt :{helpb asmprobit postestimation##estatcov:estat covariance}}covariance matrix of the latent-variable errors for the alternatives{p_end}
{synopt :{helpb asmprobit postestimation##estatcor:estat correlation}}correlation matrix of the latent-variable errors for the alternatives{p_end}
{synopt :{helpb asmprobit postestimation##estatfac:estat facweights}}covariance factor weights matrix{p_end}
{synopt :{helpb asmprobit postestimation##estatmfx:estat mfx}}marginal
effects{p_end}
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
{synopt :{helpb asmprobit postestimation##predict:predict}}predicted probabilities, estimated linear predictor and its standard error{p_end}
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
{synopt :{cmd:stdp}}standard error of the linear prediction{p_end}
{synoptline}
{p2colreset}{...}
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
{opt pr}, the default, calculates the probability that alternative {it:j}
is chosen in case {it:i}.

{phang}
{opt xb} calculates the linear prediction for alternative {it:j} and case
{it:i}.

{phang}
{opt stdp} calculates the standard error of the linear predictor.

{phang}
{opt altwise} specifies that alternativewise deletion be used when
marking out observations due to missing values in your variables.  The default
is to use casewise deletion.  The {cmd:xb} and {cmd:stdp} options always use
alternativewise deletion.

{phang}
{opt scores} calculates the scores for each coefficient in {cmd:e(b)}.
This option requires a new variable list of length equal to 
the number of columns in {cmd:e(b)}.  Otherwise, use the {it:stub}{cmd:*}
syntax to have {cmd:predict} generate enumerated variables with
prefix {it:stub}.


{marker syntax_estat}{...}
{marker estatalt}{marker estatcov}{marker estatcor}{...}
{marker estatfac}{marker estatmfx}{...}
{title:Syntax for estat}

{pstd}
Alternative summary statistics

{p 8 16 2}
{cmd:estat}
{opt alt:ernatives}


{pstd}
Covariance matrix of the latent-variable errors for the alternatives

{p 8 16 2}
{cmd:estat}
{opt cov:ariance} [{cmd:,} {opth for:mat(%fmt)}
{opth bor:der(matlist##bspec:bspec)} 
{opt left(#)}]


{pstd}
Correlation matrix of the latent-variable errors for the alternatives

{p 8 16 2}
{cmd:estat}
{opt cor:relation} [{cmd:,} {opth for:mat(%fmt)}
{opth bor:der(matlist##bspec:bspec)} 
{opt left(#)}]


{pstd}
Covariance factor weights matrix

{p 8 16 2}
{cmd:estat}
{opt facw:eights} [{cmd:,} {opth for:mat(%fmt)}
{opth bor:der(matlist##bspec:bspec)} 
{opt left(#)}]


{pstd}
Marginal effects

{p 8 16 2}
{cmd:estat}
{opt mfx}
{ifin}
[{cmd:,} {it:estat_mfx_options}]


{synoptset 35 tabbed}{...}
{synopthdr:estat_mfx_options}
{synoptline}
{syntab:Main}

{synopt : {opth var:list(varlist)}}display marginal effects for
{it:varlist}{p_end}
{synopt : {cmd:at(mean} [{it:{help asmprobit postestimation##atlist:atlist}}]|{cmd:median} [{it:{help asmprobit postestimation##atlist:atlist}}]{cmd:)}}calculate marginal effects at these values{p_end}

{syntab:Options}
{synopt : {opt l:evel(#)}}set confidence interval level; default is {cmd:level(95)}{p_end}
{synopt :{opt noe:sample}}do not restrict calculation of means and medians
to the estimation sample{p_end}
{synopt :{opt now:ght}}ignore weights when calculating means and medians{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd: estat alternatives} displays summary statistics about the alternatives
in the estimation sample and provides a mapping between the index numbers that
label the covariance parameters of the model and their associated values and
labels for the alternative variable.

{pstd}
{cmd: estat covariance} computes the estimated variance-covariance matrix of
the latent-variable errors for the alternatives.  The estimates are displayed,
and the variance-covariance matrix is stored in {hi:r(cov)}.

{pstd}
{cmd: estat correlation} computes the estimated correlation matrix of the
latent-variable errors for the alternatives.  The estimates are displayed, and
the correlation matrix is stored in {hi:r(cor)}.

{pstd}
{cmd: estat facweights} displays the covariance factor weights matrix and
stores it in {hi:r(C)}.

{pstd}
{cmd: estat mfx} computes the simulated probability marginal effects.


{marker options_estat}{...}
{title:Options for estat}

{pstd}
Options for {cmd:estat} are presented under the following headings:

{phang2}{help asmprobit postestimation##options_estat_co:Options for estat covariance, estat correlation, and estat facweights}{p_end}
{phang2}{help asmprobit postestimation##options_estat_mfx:Options for estat mfx}


{marker options_estat_co}{...}
{title:Options for estat covariance, estat correlation, and estat facweights}

{phang}
{opth format(%fmt)} sets the matrix display format.  The default
for {cmd:estat covariance} and {cmd:estat facweights} is 
{cmd:format(%9.0f)}; the default for {cmd:estat correlation} is
{cmd:format(%9.4f)}.

{phang}
{opt border(bspec)} sets the matrix display border style.  The default is
{cmd:border(all)}.  See {manhelp matlist P}.

{phang}
{opt left(#)} sets the matrix display left indent.  The default is
{cmd:left(2)}.  See {manhelp matlist P}.


{marker options_estat_mfx}{...}
{title:Options for estat mfx}

{dlgtab:Main}

{phang}
{opth varlist(varlist)} specifies the variables for which to display marginal
effects.  The default is all variables.

{marker atlist}{...}
{* although the code is such that you can type at(mean), at(mean atlist),}{...}
{* at(median), at(median atlist), or just at(atlist); we are documenting}{...}
{* as such that you have to type either mean or median with atlist}{...}
{phang}
{cmd:at(}{cmd:mean} [{it:atlist}]|{cmd:median} [{it:atlist}]{cmd:)}
specifies the values at which the marginal effects are to be calculated.
{it:atlist} is

{pmore2}
[[{it:alternative}{cmd::}{it:variable} {cmd:=} {it:#}] [{it:variable} {cmd:=} {it:#}] [...]]

{pmore}
The default is to calculate the marginal effects at the means of the independent
variables at the estimation sample, {cmd:at(mean)}.

{pmore}
After specifying the summary statistic, you can specify a series of specific
values for variables.  You can specify values for alternative-specific
variables by alternative, or you can specify one value for all alternatives.
You can specify only one value for case-specific variables.  For example, in
the {cmd:travel} dataset, {cmd:income} is a case-specific variable, whereas 
{cmd:termtime} and {cmd:travelcost} are alternative-specific variables.  The
following would be a legal syntax for {cmd:estat mfx}:

{p 12 16 2}{cmd:. estat mfx, at(mean air:termtime=50 travelcost=100 income=60)}
{p_end}

{pmore}
{cmd:at(mean} [{it:atlist}{cmd:])} or
{cmd:at(median} [{it:atlist}]{cmd:)}
has no effect on computing marginal effects for factor variables, which are
calculated as the discrete change in the probability as the factor variable
changes from the base level to the level specified in option {cmd:at()}.  If a
factor level is not specified in the {cmd:at()} option, the first level that
is not the base is used.

{pmore}
The mean and median computations respect any {cmd:if} or {cmd:in}
qualifiers, so you can restrict the data over which the means or medians are
computed. You can even restrict the values to a specific case; for example, 

{p 12 16 2}{cmd:. estat mfx if case==21}{p_end}

{dlgtab:Options}

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals.  The default is {cmd:level(95)} or as set by {helpb set level}.

{phang}
{opt noesample} specifies that the whole dataset be considered instead of only
those marked in the {cmd:e(sample)} defined by the {cmd:asmprobit} command.

{phang}
{opt nowght} specifies that weights be ignored when calculating the means or
medians.


{marker remarks}{...}
{title:Remarks}

{pstd}
Simulated probability marginal effects cannot be computed for a variable that
is specified in both the alternative-specific and case-specific variable
lists.  Computations assume that these two variable lists are mutually
exclusive.  For example, {cmd:estat mfx} exits with an error message if your
model has independent variables that are the interaction between
alternative-specific variables ({it:indepvars} specified in
{helpb asmprobit##syntax:asmprobit}) and
case-specific variables ({it:varlist} specified in the
{helpb asmprobit##syntax:casevars()} option).  Marginal effect computations
can proceed if you specify a variable list in the {cmd:varlist()} option
of {cmd:estat mfx} that excludes the variables that are used in both the
alternative-specific and case-specific variable lists.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse travel}{p_end}
{phang2}{cmd:. asmprobit choice travelcost termtime, case(id)}
        {cmd:alternatives(mode) casevars(income)}{p_end}

{pstd}Obtain correlation matrix of the alternatives{p_end}
{phang2}{cmd:. estat correlation}{p_end}

{pstd}Obtain variance-covariance matrix of the alternatives{p_end}
{phang2}{cmd:. estat covariance}{p_end}

{pstd}Calculate probability alternative is chosen{p_end}
{phang2}{cmd:. predict p}{p_end}

{pstd}Calculate marginal effects for the case-specific variable {cmd:income}
and the alternative-specific variables {cmd:termtime} and {cmd:travelcost}{p_end}
{phang2}{cmd:. estat mfx, at(air: termtime=50 travelcost=100 income=60)}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse travel, clear}{p_end}
{phang2}{cmd:. asmprobit choice travelcost termtime, case(id)}
          {cmd:alternatives(mode) casevars(income)}{p_end}
{phang2}{cmd:. estimates store full}{p_end}
{phang2}{cmd:. asmprobit choice travelcost termtime, case(id)}
          {cmd:alternatives(mode) casevars(income)}
          {cmd:correlation(exchangeable)}{p_end}

{pstd}Perform likelihood-ratio test to compare models{p_end}
{phang2}{cmd:. lrtest full .}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat mfx} stores the following in {opt r()}:

{pstd}Scalars

{phang2}
{cmd: r(pr_}{it:alt}{opt )} scalars containing the computed probability
of each alternative evaluated at the value that is labeled X in the table
output.  Here {it:alt} are the labels in the macro {cmd:e(alteqs)}.

{pstd}Matrices

{phang2}
{cmd: r(}{it:alt}{opt )} matrices containing the computed marginal effects and
associated statistics.  There is one matrix for each alternative, where
{it:alt} are the labels in the macro {cmd:e(alteqs)}.  Column 1 of each matrix
contains the marginal effects; column 2, their standard errors; columns 3 and
4, their z statistics and the p-values for the z statistics; and columns 5 and
6, the confidence intervals.  Column 7 contains the values of the independent
variables used to compute the probabilities {cmd:r(pr_}{it:alt}{opt )}.
{p_end}
