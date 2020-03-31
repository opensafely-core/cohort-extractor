{smcl}
{* *! version 1.1.5  30dec2010}{...}
{cmd:help mfx}{right:dialog:  {dialog mfx:mfx}}
{hline}
{pstd}
{cmd:mfx} has been superseded by {cmd:margins}.  {cmd:margins} can do
everything that {cmd:mfx} did and more.  {cmd:margins} syntax differs from
{cmd:mfx}; see {helpb margins}.  {cmd:mfx} continues to work but does not
support factor variables and will often fail if you do not run your estimation
command under {help version:version control}, with the version set to less than
11.  This help file remains to assist those who encounter an {cmd:mfx} command
in old do-files and programs.


{title:Title}

{p2colset 5 16 18 2}{...}
{p2col :{bf:[R] mfx} {hline 2}}Obtain marginal effects or elasticities after
estimation{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 12 2}
{cmd:mfx}
[{opt c:ompute}]
{ifin}
[{cmd:,} 
{it:options}]

{p 8 12 2}
{cmd:mfx}
{opt r:eplay}
[{cmd:,}
{opt l:evel(#)}]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opt pred:ict(predict_option)}}calculate marginal effects (elasticities)
for {it:predict_option}{p_end}
{synopt :{opth var:list(varlist)}}calculate marginal effects (elasticities) for
{it:varlist}{p_end}
{synopt :{opt dydx}}calculate marginal effects; the default{p_end}
{synopt :{opt eyex}}calculate elasticities in the form of d(lny)/d(lnx){p_end}
{synopt :{opt dyex}}calculate elasticities in the form of d(y)/d(lnx){p_end}
{synopt :{opt eydx}}calculate elasticities in the form of d(lny)/d(x){p_end}
{synopt :{opt nod:iscrete}}treat dummy (indicator) variables as
continuous{p_end}
{synopt :{opt nos:e}}do not calculate standard errors{p_end}

{syntab :Model 2}
{synopt :{cmd:at(}{it:{help mfx##atlist:atlist}}{cmd:)}}calculate marginal effects (elasticities) at these values{p_end}
{synopt :{opt noe:sample}}do not restrict calculation of means and medians
to the estimation sample{p_end}
{synopt :{opt now:ght}}ignore weights when calculating means and medians{p_end}

{syntab :Adv. model}
{synopt :{opt nonl:inear}}do not use the linear method{p_end}
{synopt :{opt force}}calculate marginal effects and standard errors when 
it would otherwise refuse to do so{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{cmdab:diag:nostics(beta)}}report suitability of marginal-effect
calculation{p_end}
{synopt :{cmdab:diag:nostics(vce)}}report suitability of standard-error
calculation{p_end}
{synopt :{cmdab:diag:nostics(all)}}report all diagnostic information{p_end}
{synopt :{opt tr:acelvl(#)}}report increasing levels of detail during
calculations{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{marker atlist}
where {it:atlist} is {it:{help numlist}} or {it:matname} or

{pin2}
[{cmd:mean}{c |}{cmd:median}{c |}{cmd:zero}] [{varname} {cmd:=} {it:#} [{cmd:,} {it:varname} {cmd:=} {it:#}] [...]]

{pin}
where {opt mean} is the default.


{title:Menu}

{phang}
{bf:Statistics > Postestimation > Marginal effects or elasticities}


{title:Description}

{pstd}
{opt mfx}
numerically calculates the marginal effects or the elasticities and their
standard errors after estimation.  Exactly what {opt mfx} can calculate is
determined by the previous estimation command and the
{opt predict(predict_option)} option.  The values at which the marginal
effects or elasticities are to be evaluated is determined by the
{opt at(atlist)} option.  By default, {opt mfx} calculates the marginal
effects or elasticities at the means of the independent variables by using the
default prediction option associated with the previous estimation command.

{pstd}
Some disciplines use the term partial effects, rather than marginal
effects, for what is computed by {cmd:mfx}.

{pstd}
{opt mfx replay} replays the results of the previous {opt mfx} computation.


{title:Options}

{dlgtab:Model}

{phang}
{opt predict(predict_option)} specifies the function
    (that is, the form of y) for which to calculate the marginal effects or
    elasticities.  The default is to use the default {opt predict} option of
    the preceding estimation command.  To see which {opt predict} options are
    available, see {opt help} for the particular estimation command.

{phang}
{opth varlist(varlist)} specifies the variables
    for which to calculate marginal effects (elasticities).
    The default is all variables.

{phang}{cmd:dydx} specifies that marginal effects be calculated. This is
the default.

{phang}
{opt eyex} specifies that elasticities be calculated in the form
    of d(lny)/d(lnx)

{phang}
{opt dyex} specifies that elasticities be calculated in the form
    of d(y)/d(lnx)

{phang}
{opt eydx} specifies that elasticities be calculated in the form
    of d(lny)/d(x)

{phang}
{opt nodiscrete} treats dummy variables as continuous.  A dummy variable is
    one that takes on the value 0 or 1 in the estimation sample.  If
    {opt nodiscrete} is not specified, the marginal effect of a dummy variable
    is calculated as the discrete change in y as the dummy variable changes
    from 0 to 1.  This option is irrelevant to the computation of the
    elasticities because all the dummy variables are treated as continuous
    when computing elasticities.

{phang}
{opt nose} specifies that standard errors of the marginal effects
    (elasticities) not be computed.

{dlgtab:Model 2}

{phang}
{opt at(atlist)} specifies the values at which the
    marginal effects (elasticities) are to be calculated.  The default is to
    calculate at the means of the independent variables.

{pmore}
    {opth at(numlist)} specifies that the marginal effects (elasticities)
    be calculated at {it:numlist}.  For instance,

{p 12 16 2}{cmd:. sysuse auto}{p_end}
{p 12 16 2}{cmd:. sureg (price disp weight) (mpg disp weight foreign)}{p_end}
{p 12 16 2}{cmd:. mfx, predict(xb eq(#2)) at(200 3000 0.5)}

{pmore}
   computes the marginal effects for the second equation, setting
   {cmd:disp}=200, {cmd:weight}=3000, and {cmd:foreign}=0.5.
   
{pmore}
    The order of the values in the {it:numlist} is the same as the variables
    in the preceding estimation command, from left to right, without
    repetition.  For instance,

{p 12 16 2}{cmd:. sureg (price disp weight) (mpg foreign disp) }{p_end}
{p 12 16 2}{cmd:. mfx, predict(xb) at(200 3000 0.5)}

{pmore}
    {opth at(matname)} specifies the points in a matrix
    format.  The ordering of the variables is the same as that of
    {it:numlist}.  For instance,

{p 12 16 2}{cmd:. probit foreign mpg weight price}{p_end}
{p 12 16 2}{cmd:. matrix A = (21, 3000, 6000)}{p_end}
{p 12 16 2}{cmd:. mfx, at(A)}

{pmore}
    {cmd:at(}[{opt mean} | {opt median} | {opt zero}] [{it:varname}
    {cmd:=} {it:#} [{cmd:,} {it:varname} {cmd:=} {it:#} [{it:...}]]]{cmd:)}
    specifies that the marginal effects (elasticities) be
    calculated at means, at medians of the independent variables, or at zeros.
    It also allows users to specify particular values for one or more
    independent variables, assuming that the rest are means, medians, or
    zeros.

{p 12 16 2}{cmd:. probit foreign mpg weight price}{p_end}
{p 12 16 2}{cmd:. mfx, at(mean mpg=30)}

{pmore}
    {cmd:at(}{varname} {cmd:=} {it:#} [{cmd:,} {it:varname} {cmd:=} {it:#} ]
    [...]{cmd:)} specifies that the marginal effects or the elasticities be
    calculated at particular values for one or more independent variables,
    assuming that the rest are means.

{p 12 16 2}{cmd:. probit foreign mpg weight price}{p_end}
{p 12 16 2}{cmd:. mfx, at(mpg=30)}

{phang}
{opt noesample} affects {opt at(atlist)}, any offsets used in the
    preceding estimation, and the determination of dummy variables.  It
    specifies that the whole dataset be considered instead of only those
    marked in the {cmd:e(sample)} defined by the previous estimation command.

{phang}
{opt nowght} affects only {opt at(atlist)} and offsets.
    It specifies that weights be ignored when calculating the means or
    medians for the {it:atlist} and when calculating the means for any
    offsets.

{dlgtab:Adv. model}

{phang}
{opt nonlinear} specifies that y, the function to be calculated for the
    marginal effects or the elasticities, does not meet the linear-form
    restriction.  By default, {opt mfx} assumes that y meets the
    linear-form restriction, unless one or more dependent variables are
    shared by multiple equations or the previous estimation command was
    {cmd:nl}.  For instance, predictions after

{phang3}
{cmd:. heckman mpg price, sel(foreign=rep78)}

{pmore}
    meet the linear-form restriction, but those after

{phang3}
{cmd:. heckman mpg price, sel(foreign=rep78 price)}

{pmore}
    do not.  If y meets the linear-form restriction, specifying
    {opt nonlinear} should produce the same results as not specifying it.
    However, the nonlinear method is generally more time consuming.  Most
    likely, you do not need to specify {opt nonlinear} after an official Stata
    command.  For user-written commands, if you are not sure whether y is of
    linear form, specifying {opt nonlinear} is a safe choice.

{phang}
{opt force} specifies that marginal effects and their 
    standard errors be calculated when it would otherwise refuse to
    do so.  Such cases arise, for instance, when the marginal effect is a
    function of a random quantity other than the coefficients of the model
    (for example, a residual).  If you specify this option, there is no
    guarantee that the resulting marginal effects and standard errors are
    correct.

{dlgtab:Reporting}

{phang}
{opt level(#)} specifies the confidence level, as a percentage,
    for confidence intervals.  The default is {cmd:level(95)} or as set by
    {helpb set level}.

{phang} {opt diagnostics(diaglist)} asks {opt mfx} to display various
    diagnostic information.

{pmore}
    {cmd:diagnostics(beta)} shows the information used to determine
    whether the prediction option is suitable for computing
    marginal effects.

{pmore}
    {cmd:diagnostics(vce)} shows the information used to determine
    whether the prediction option is suitable for computing
    the standard errors of the marginal effects.

{pmore}
    {cmd:diagnostics(all)} shows all the above diagnostic information.

{phang}
{opt tracelvl(#)}
    shows increasing levels of detail during calculations.
    {it:#} may be 1, 2, 3, or 4.
    Level 1 shows the marginal effects and standard errors as they are computed,
    and which method, either linear or nonlinear, was used.
    Level 2 shows, in addition, the components of the matrix of partial
    derivatives needed for each standard error as they are computed.
    Level 3 shows counts of iterations in obtaining a suitable finite
    difference for each numerical derivative.  
    Level 4 shows the values of these finite differences.


{title:Using mfx after nl}

{pstd} 
You must specify the independent variables by using the {opt variables()}
option when using the interactive version of {helpb nl} to obtain marginal
effects.  Otherwise, {cmd:mfx} has no way of distinguishing the independent
variables from the parameters of your model and will therefore exit with an
error message.

{pstd}
Instead of typing 

{phang2}{cmd:. nl (mpg = {b0} + {b1}*gear^{b2=1})}

{pstd}
type

{phang2}{cmd:. nl (mpg = {b0} + {b1}*gear^{b2=1}), variables(gear)}

{pstd}
If you use the programmed substitutable expression or function evaluator 
program versions of {cmd:nl}, you do not need to use the 
{opt variables()} option.


{title:Examples}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. logit foreign mpg price}{p_end}
{phang}{cmd:. mfx, predict(p)}{p_end}
{phang}{cmd:. mfx, predict(p) at(mpg = 20, price = 6000)}{p_end}
{phang}{cmd:. mfx, predict(p) at(20 6000)}{p_end}

{phang}{cmd:. mlogit rep78 mpg displ}{p_end}
{phang}{cmd:. mfx, predict(p outcome(2))}{p_end}
{phang}{cmd:. mfx, predict(p outcome(2)) at(20 400) }{p_end}
{phang}{cmd:. mfx, predict(p outcome(2)) varlist(mpg)}{p_end}

{phang}{cmd:. heckman mpg weight length, sel(foreign = length displ)}{p_end}
{phang}{cmd:. mfx, predict(xb)}{p_end}
{phang}{cmd:. mfx, predict(xbsel)}{p_end}
{phang}{cmd:. mfx, predict(yexpected) varlist(length) }{p_end}

{phang}{cmd:. regress mpg length weight}{p_end}
{phang}{cmd:. mfx, eyex}{p_end}
{phang}{cmd:. mfx replay, level(90)}{p_end}


{title:Saved results}

{pstd}
In addition to the {cmd:e()} results from the preceding estimation,
{cmd:mfx} saves the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(Xmfx_y)}}value of {it:y} given X{p_end}
{synopt:{cmd:e(Xmfx_off)}}value of mean of the offset variable or log of
the exposure variable{p_end}
{synopt:{cmd:e(Xmfx_off}{it:#}{cmd:)}}value of mean of the offset variable for equation {it:#}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(Xmfx_type)}}{cmd:dydx}, {cmd:eyex}, {cmd:eydx} or {cmd:dyex}{p_end}
{synopt:{cmd:e(Xmfx_discrete)}}{cmd:discrete} or {cmd:nodiscrete}{p_end}
{synopt:{cmd:e(Xmfx_cmd)}}{cmd:mfx}{p_end}
{synopt:{cmd:e(Xmfx_label_p)}}label for prediction in output{p_end}
{synopt:{cmd:e(Xmfx_predict)}}{it:predict_option} specified in {cmd:predict()}{p_end}
{synopt:{cmd:e(Xmfx_dummy)}}corresponding to independent variables; {cmd:1}
means dummy, {cmd:0} means continuous{p_end}
{synopt:{cmd:e(Xmfx_variables)}}corresponding to independent variables;
{cmd:1} means marginal effect calculated, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(Xmfx_method)}}{cmd:linear} or {cmd:nonlinear}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(Xmfx_dydx)}}marginal effects{p_end}
{synopt:{cmd:e(Xmfx_se_dydx)}}standard errors of the marginal effects{p_end}
{synopt:{cmd:e(Xmfx_eyex)}}elasticities of form {cmd:eyex}{p_end}
{synopt:{cmd:e(Xmfx_se_eyex)}}standard errors of elasticities of form {cmd:eyex}{p_end}
{synopt:{cmd:e(Xmfx_eydx)}}elasticities of form {cmd:eydx}{p_end}
{synopt:{cmd:e(Xmfx_se_eydx)}}standard errors of elasticities of form {cmd:eydx}{p_end}
{synopt:{cmd:e(Xmfx_dyex)}}elasticities of form {cmd:dyex}{p_end}
{synopt:{cmd:e(Xmfx_se_dyex)}}standard errors of elasticities of form {cmd:dyex}{p_end}
{synopt:{cmd:e(Xmfx_X)}}values around which marginal effects (elasticities)
were estimated{p_end}
{p2colreset}{...}


{title:Also see}

{psee}
Manual:  {bf:[R] mfx}

{psee}
{space 2}Help:  {manhelp predict R}
{p_end}
