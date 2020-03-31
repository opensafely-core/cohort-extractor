{smcl}
{* *! version 1.2.6  29aug2018}{...}
{viewerdialog predict "dialog gmm_p"}{...}
{viewerdialog estat "dialog gmm_estat"}{...}
{vieweralsosee "[R] gmm postestimation" "mansection R gmmpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] gmm" "help gmm"}{...}
{viewerjumpto "Postestimation commands" "gmm postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "gmm_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "gmm postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "gmm postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "gmm postestimation##syntax_estat_overid"}{...}
{viewerjumpto "Examples" "gmm postestimation##examples"}{...}
{viewerjumpto "Stored results" "gmm postestimation##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[R] gmm postestimation} {hline 2}}Postestimation tools for gmm{p_end}
{p2col:}({mansection R gmmpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after 
{cmd:gmm}:

{synoptset 14}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb gmm postestimation##estatoverid:estat overid}}perform test of overidentifying restrictions{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 14}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_hausman
INCLUDE help post_lincom
{synopt:{helpb gmm postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb gmm postestimation##predict:predict}}linear predictions,
residuals, and scores{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
	

{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R gmmpostestimationRemarksandexamples:Remarks and examples}

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
[{cmd:,} {cmd:xb} {cmdab:eq:uation(#}{it:eqno}{c |}{it:eqname}{cmd:)}]

{p 8 16 2}
{cmd:predict}
{dtype}
{newvar}
{ifin}
{cmd:,} {opt r:esiduals} [{cmdab:eq:uation(#}{it:eqno}{c |}{it:eqname}{cmd:)}]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvar:newvar_1}}
    {it:{help newvar:newvar_2}} ... {it:{help newvar:newvar_q}}{c )-}
{ifin}
[{cmd:,} {opt r:esiduals}]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvar:newvar_1}}
    {it:{help newvar:newvar_2}} ... {it:{help newvar:newvar_p}}{c )-}
{ifin}
[{cmd:,} {opt sc:ores}]

{p 4 6 4}Residuals are available both in and out of sample; 
type {cmd:predict} ... {cmd:if e(sample)} ... if wanted only for the 
estimation sample.

{p 4 6 4}Scores are available only for observations within the estimation
sample.

{p 4 6 4}You specify one new variable and (optionally) {cmd:equation()}, 
or you specify {it:stub}{cmd:*} or {it:q} or {it:p} new variables, where
{it:q} is the number of moment equations and {it:p} is the number of
parameters in the model.


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as 
linear predictions, residuals, and scores.


{marker option_predict}{...}
{title:Option for predict}

{dlgtab:Main}

{phang}
{cmd:xb}, the default, calculates the linear prediction.

{phang}
{cmd:residuals} calculates the residuals, the predicted values of the moment
equations.  This option requires that the length of the new variable list be
equal to the number of moment equations, {it:q}.  Otherwise, use
{it:stub}{cmd:*} to have {cmd:predict} generate enumerated variables with
prefix {it:stub}.  If {cmd:equation()} is not specified, the jth new variable
will contain the residuals for the jth moment equation.

{phang}
{cmd:equation(#}{it:eqno}{c |}{it:eqname}{cmd:)} specifies the equation for
which residuals or linear predictions are desired.  The specified equation may
be a model equation or a moment equation.

{pmore}
If {cmd:xb} is specified, {cmd:equation()} is used to specify equations in the
model.  Specifying {cmd:equation(#1)} indicates that the calculation is to be
made for the first model equation.  Specifying {cmd:equation(demand)} would
indicate that the calculation is to be made for the model equation named
{cmd:demand}, assuming there is an equation named {cmd:demand} in the model.

{pmore}
If {cmd:residuals} is specified, {cmd:equation()} is used to specify moment
equations.  Specifying {cmd:equation(#1)} indicates that the calculation is to
be made for the first moment equation.  Specifying {cmd:equation(demand)}
would indicate that the calculation is to be made for the moment equation
named {cmd:demand}, assuming there is a moment equation named {cmd:demand} in
the model.

{pmore}
If you specify one new variable name and omit {cmd:equation()}, 
results are the same as if you had specified {cmd:equation(#1)}.

{pmore}
For more information on using {cmd:predict} after multiple-equation
estimation commands, see {manhelp predict R}.

{phang}
{cmd:scores} calculates the parameter-level score equations, the first
derivatives of the GMM criterion function with respect to the parameters
scales by -0.5.  This option requires that the length of the new variable
list be equal to the number of parameters, {it:p}.  Otherwise, use
{it:stub}{cmd:*} to have {cmd:predict} generate enumerated variables with
prefix {it:stub}.  The jth new variable will contain the jth score of the
model.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt xb} defaults to the first equation.
{p_end}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for linear predictions.


{marker syntax_estat_overid}{...}
{marker estatoverid}{...}
{title:Syntax for estat overid}

{p 8 16 2}
{cmd:estat} {cmdab:over:id} 


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat overid} reports Hansen's J statistic, which is used to 
determine the validity of the overidentifying restrictions in a GMM 
model.  If the model is correctly specified in the sense that 
E{{bf:z}_i'u_i({bf:b})} = {bf:0}, then the sample analog to that condition 
should hold at the estimated value of {bf:b}.  Hansen's J statistic is 
valid only if the weight matrix is optimal, meaning that it equals the 
inverse of the covariance matrix of the moment conditions.  Therefore, 
{cmd:estat overid} only reports Hansen's J statistic after two-step or 
iterated estimation, or if you specified {opt winitial(matname)} when 
calling {cmd:gmm}.  In the latter case, it is your responsibility to 
determine the validity of the J statistic.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse probitgmm}{p_end}
{phang2}{cmd:. gmm ((y - normal({y: x _cons}))*(-x*normalden({y:})))}
              {cmd:((y - normal({y:}))*(-1*normalden({y:})))}
              {cmd:, winitial(identity) onestep}{p_end}

{pstd}Estimate marginal probability of success with unconditional standard
errors{p_end}
{phang2}{cmd:. margins, expression(normal(xb())) vce(unconditional)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse supDem}{p_end}
{phang2}{cmd:. global demand "demand: quantity - {xb1:price pcompete income} - {b0}"}{p_end}
{phang2}{cmd:. global supply "supply: quantity - {xb2:price praw} - {c0}"}{p_end}
{phang2}{cmd:. gmm ($demand) ($supply), wmatrix(robust)}
        {cmd:inst(demand:praw pcompete income)}
        {cmd:inst(supply:praw pcompete income) winit(unadj,indep)}
        {cmd:deriv(1/xb1 = -1) deriv(1/b0 = -1)}
        {cmd:deriv(2/xb2 = -1) deriv(2/c0 = -1) twostep}{p_end}

{pstd}Obtain residuals for supply equation{p_end}
{phang2}{cmd:. predict rhat, equation(xb2)}{p_end}

{pstd}Obtain residuals for all equations, storing them in double-precision
{p_end}
{phang2}{cmd:. predict double r*, residuals}{p_end}

{pstd}Same as above{p_end}
{phang2}{cmd:. predict double s1 double s2, residuals}{p_end}

{pstd}Test whether the overidentifying restrictions are valid{p_end}
{phang2}{cmd:. estat overid}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat overid} stores the following in {cmd:r()}:

{synoptset 10 tabbed}{...}
{p2col 5 10 14 2: Scalars}{p_end}
{synopt:{cmd:r(J)}}Hansen's J statistic{p_end}
{synopt:{cmd:r(J_df)}}J statistic degrees of freedom{p_end}
{synopt:{cmd:r(J_p)}}J statistic p-value{p_end}
