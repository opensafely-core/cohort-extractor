{smcl}
{* *! version 1.0.11  31may2018}{...}
{viewerdialog predict "dialog sem_p"}{...}
{vieweralsosee "[SEM] predict after sem" "mansection SEM predictaftersem"}{...}
{findalias assempredict}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] sem postestimation" "help sem_postestimation"}{...}
{viewerjumpto "Syntax" "sem_predict##syntax"}{...}
{viewerjumpto "Menu" "sem_predict##menu"}{...}
{viewerjumpto "Description" "sem_predict##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_predict##linkspdf"}{...}
{viewerjumpto "Options" "sem_predict##options"}{...}
{viewerjumpto "Remarks" "sem_predict##remarks"}{...}
{viewerjumpto "Examples" "sem_predict##examples"}{...}
{viewerjumpto "Reference" "sem_predict##reference"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[SEM] predict after sem} {hline 2}}Factor scores, linear
       predictions, etc.{p_end}
{p2col:}({mansection SEM predictaftersem:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{c )-}
{ifin} [{cmd:,} {it:options}]

{synoptset 18}{...}
{synopthdr:options}
{synoptline}
{synopt :{opt xb}}linear prediction for all OEn variables; the default{p_end}
{synopt :{opth xb(varlist)}}linear prediction for specified OEn variables{p_end}

{synopt :{opt xblat:ent}}linear prediction for all LEn variables{p_end}
{synopt :{opth xblat:ent(varlist)}}linear prediction for specified
LEn variables{p_end}

{synopt :{opt lat:ent}}factor scores for all latent variables{p_end}
{synopt :{opth lat:ent(varlist)}}factor scores for specified latent variables{p_end}

{synopt :{opt sc:ores}}calculate first derivative of the log likelihood{p_end}
{synoptline}
{p 4 6 2}
Key: OEn = observed endogenous; LEn = latent endogenous {p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Predictions}


{marker description}{...}
{title:Description}

{pstd}
{cmd:predict} is a standard postestimation command of Stata.
This entry concerns use of {cmd:predict} after {cmd:sem}.
See {helpb gsem_predict:[SEM] predict after gsem} if you fit your model with
{cmd:gsem}.

{pstd}
{cmd:predict} after {cmd:sem} creates new variables containing
observation-by-observation values of estimated factor scores (meaning
predicted values of latent variables) and predicted values for latent and
observed endogenous variables.  Out-of-sample prediction is allowed.

{pstd}
When {cmd:predict} is used on a model fit by {cmd:sem} with the 
{opt group()} option, results are produced with the appropriate group-specific
estimates.  Out-of-sample prediction is allowed; missing values are filled in
for groups not included at the time the model was fit.

{pstd}
{cmd:predict} allows two syntaxes.  You can type

{phang2}{cmd:. predict} {it:stub}{cmd:*}{cmd:, ...}{p_end}

{pstd}
to create variables named {it:stub}{cmd:1}, {it:stub}{cmd:2}, ..., or you
can type

{phang2}{cmd:. predict var1 var2 ..., ...}{p_end}

{pstd}
to create variables named {cmd:var1}, {cmd:var2}, ....

{pstd}
{cmd:predict} may not be used with summary statistics data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM predictaftersemRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:xb}
calculates the linear prediction for all observed endogenous variables in the
model.  {cmd:xb} is the default if no option is specified.

{phang}
{opth xb(varlist)}
calculates the linear prediction for the variables specified, all of which
must be observed endogenous variables.

{phang}
{cmd:xblatent} and {opth xblatent(varlist)}
calculate the linear prediction for all or the specified latent endogenous
variables, respectively.

{phang}
{cmd:latent} and {opth latent(varlist)} 
calculate the factor scores for all or the specified latent variables,
respectively.  The calculation method is an analog of regression scoring;
namely, it produces the means of the latent variables conditional on the
observed variables used in the model.  If missing values are found among the
observed variables, conditioning is on the variables with observed values
only.

{phang}{cmd:scores}
is for use by programmers.  It provides the first derivative of the
observation-level log likelihood with respect to the parameters. 

{p 8 8 2}
Programmers: In single-group {cmd:sem}, each parameter that is not
constrained to be 0 has an associated equation.  As a consequence,
the number of equations, and hence the number of score variables
created by {cmd:predict}, may be large.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {findalias sempredict}.

{pstd}
Factor scoring for latent variables can be interpreted as a form of
missing-value imputation -- think of each latent variable as an observed
variable that has only missing values.

{pstd}
When latent variables are present in the model, linear predictions from
{cmd:predict, xb} are computed by substituting the factor scores in place of
each latent variable before computing the linear combination of coefficients.
This method will lead to inconsistent coefficient estimates when the factor
score contains measurement error; see
{help sem_predict##Bollen1989:Bollen (1989}, 305-306). 


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_1fmm}{p_end}
{phang2}{cmd:. sem (x1 x2 x3 x4 <- X)}{p_end}

{pstd}Linear prediction for all observed endogenous variables{p_end}
{phang2}{cmd:. predict xb*, xb}{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. drop xb*}{p_end}

{pstd}Linear prediction for {cmd:x1} and {cmd:x2}{p_end}
{phang2}{cmd:. predict xb1 xb2, xb(x1 x2)}{p_end}

{pstd}Factor score for latent variable {cmd:X}{p_end}
{phang2}{cmd:. predict Fscore, latent(X)}{p_end}

{pstd}Parameter-level scores{p_end}
{phang2}{cmd:. predict s*, scores}{p_end}


{marker reference}{...}
{title:Reference}

{marker Bollen1989}{...}
{phang}
Bollen, K. A. 1989.  {it:Structural Equations with Latent Variables}.  New
York: Wiley.
{p_end}
