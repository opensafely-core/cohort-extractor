{smcl}
{* *! version 1.3.7  12dec2018}{...}
{viewerdialog vec "dialog vec"}{...}
{vieweralsosee "[TS] vec" "mansection TS vec"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] vec postestimation" "help vec postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] var" "help var"}{...}
{vieweralsosee "[TS] var svar" "help svar"}{...}
{vieweralsosee "[TS] vec intro" "help vec_intro"}{...}
{viewerjumpto "Syntax" "vec##syntax"}{...}
{viewerjumpto "Menu" "vec##menu"}{...}
{viewerjumpto "Description" "vec##description"}{...}
{viewerjumpto "Links to PDF documentation" "vec##linkspdf"}{...}
{viewerjumpto "Options" "vec##options"}{...}
{viewerjumpto "Examples" "vec##examples"}{...}
{viewerjumpto "Stored results" "vec##results"}{...}
{viewerjumpto "Reference" "vec##reference"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[TS] vec} {hline 2}}Vector error-correction models{p_end}
{p2col:}({mansection TS vec:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:vec} {depvarlist} {ifin} [{cmd:,} {it:options}]

{synoptset 31 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt r:ank(#)}}use {it:#} cointegrating equations; default is
{cmd:rank(1)}{p_end}
{synopt :{opt la:gs(#)}}use {it:#} for the maximum lag in underlying VAR model{p_end}
{synopt :{opt t:rend}{cmd:(}{opt c:onstant}{cmd:)}}include an unrestricted constant in model; the default{p_end}
{synopt :{opt t:rend}{cmd:(}{opt rc:onstant}{cmd:)}}include a restricted constant in model{p_end}
{synopt :{opt t:rend}{cmd:(}{opt t:rend}{cmd:)}}include a linear trend in the
cointegrating equations and a quadratic trend in the undifferenced data{p_end}
{synopt :{opt t:rend}{cmd:(}{opt rt:rend}{cmd:)}}include a restricted trend in
model{p_end}
{synopt :{opt t:rend}{cmd:(}{opt n:one}{cmd:)}}do not include a trend or a
constant{p_end}
{synopt :{opt bc:onstraints(constraints_bc)}}place {it:constraints_bc} on
cointegrating vectors{p_end}
{synopt :{opt ac:onstraints(constraints_ac)}}place {it:constraints_ac} on
adjustment parameters{p_end}

{syntab:Adv. model}
{synopt :{opth si:ndicators(varlist:varlist_si)}}include normalized seasonal indicator
variables {it:varlist_si}{p_end}
{synopt :{opt noreduce}}do not perform checks and corrections for collinearity
among lags of dependent variables{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nobt:able}}do not report parameters in the cointegrating equations{p_end}
{synopt :{opt noid:test}}do not report the likelihood-ratio test of
overidentifying restrictions{p_end}

{synopt :{opt al:pha}}report adjustment parameters in separate table{p_end}
{synopt :{opt pi}}report parameters in Pi=(alpha)(beta)'{p_end}
{synopt :{opt nopt:able}}do not report elements of Pi matrix{p_end}
{synopt :{opt m:ai}}report parameters in the moving-average impact
matrix{p_end}
{synopt :{opt noet:able}}do not report adjustment and short-run
parameters{p_end}
{synopt :{opt dforce}}force reporting of short-run, beta, and alpha parameters
when the parameters in beta are not identified; advanced option{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help vec##display_options:display_options}}}control columns
       and column formats, row spacing, and line width{p_end}

{syntab:Maximization}
{synopt :{it:{help vec##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}{cmd:vec} does not allow gaps in the data.{p_end}
{p 4 6 2}You must {cmd:tsset} your data before using {cmd:vec}; see
{helpb tsset:[TS] tsset}.{p_end}
{p 4 6 2}{it:varlist} must contain at least two variables and may contain
time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:by}, {cmd:fp}, {cmd:rolling}, {cmd:statsby}, and {cmd:xi} are
allowed; see {help prefix}.{p_end}
{p 4 6 2}{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp vec_postestimation TS:vec postestimation} for features 
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > Vector error-correction model (VECM)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:vec} fits a type of vector autoregression in which some of the 
variables are cointegrated by using Johansen's
({help vec##J1995:1995}) maximum likelihood 
method.  Constraints may be placed on the parameters in the 
cointegrating equations or on the adjustment terms.  See 
{manhelp vec_intro TS:vec intro} for a list of commands that are used 
in conjunction with {cmd:vec}. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS vecQuickstart:Quick start}

        {mansection TS vecRemarksandexamples:Remarks and examples}

        {mansection TS vecMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt rank(#)} specifies the number of cointegrating equations;
{cmd:rank(1)} is the default.

{phang}
{opt lags(#)} specifies the maximum lag to be included in the underlying VAR
model.  The maximum lag in a VECM is one smaller than the maximum lag in the
corresponding VAR in levels; the number of lags must be greater than zero but
small enough so that the degrees of freedom used up by the model are fewer
than the number of observations.  The default is {cmd:lags(2)}.

{phang}
{opt trend(trend_spec)} specifies which of Johansen's five trend
specifications to include in the model.  These specifications are discussed in
{it:{mansection TS vecRemarksandexamplesSpecificationofconstantsandtrends:Specification of constants and trends}}
of {hi:[TS] vec}.  The default is {cmd:trend(constant)}.

{phang}
{opt bconstraints(constraints_bc)} specifies the constraints to be placed on
the parameters of the cointegrating equations.  When no constraints are placed
on the adjustment parameters -- that is, when the {opt aconstraints()}
option is not specified -- the default is to place the constraints
defined by Johansen's normalization on the parameters of the cointegrating
equations.  When constraints are placed on the adjustment parameters, the
default is not to place constraints on the parameters in the cointegrating
equations.

{phang}
{opt aconstraints(constraints_ac)} specifies the constraints to be placed on
the adjustment parameters.  By default, no constraints are placed on the
adjustment parameters.

{dlgtab:Adv. model}

{phang}
{opth sindicators:(varlist:varlist_si)} specifies the normalized seasonal
indicator variables to include in the model.  The indicator variables specified
in this option must be normalized as discussed in 
{help vec##J1995:Johansen (1995)}.  If the
indicators are not properly normalized, the estimator of the cointegrating
vector does not converge to the asymptotic distribution derived by
{help vec##J1995:Johansen (1995)}.  More details about how these variables are
handled are provided in
{it:{mansection TS vecMethodsandformulas:Methods and formulas}} of
{hi:[TS] vec}.  {opt sindicators()} cannot be specified with {cmd:trend(none)}
or with {cmd:trend(rconstant)}.

{phang} 
{opt noreduce} causes {opt vec} to skip the checks and corrections for
collinearity among the lags of the dependent variables.  By default, 
{opt vec} checks to see whether the current lag specification causes some of the
regressions performed by {opt vec} to contain perfectly collinear variables;
if so, it reduces the maximum lag until the perfect collinearity is removed.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{bf:{help estimation options##level():[R] Estimation options}}.

{phang}
{opt nobtable} suppresses the estimation table for the parameters in the
cointegrating equations.  By default, {opt vec} displays
the estimation table for the parameters in the cointegrating equations.

{phang}
{opt noidtest} suppresses the likelihood-ratio test of the overidentifying
restrictions, which is reported by default when the model is overidentified.

{phang}
{opt alpha} displays a separate estimation table for the adjustment
parameters, which is not displayed by default.

{phang}
{opt pi} displays a separate estimation table for the parameters in
Pi=(alpha)(beta)', which is not displayed by default.

{phang}
{opt noptable} suppresses the estimation table for the elements of the Pi
matrix, which is displayed by default when the parameters in the cointegrating
equations are not identified.

{phang}
{opt mai} displays a separate estimation table for the parameters in the
moving-average impact matrix, which is not displayed by default.

{phang}
{opt noetable} suppresses the main estimation table that contains information
about the estimated adjustment parameters and the short-run parameters,
which is displayed by default.

{phang}
{opt dforce} displays the estimation tables for the short-run parameters and
alpha and beta -- if the last two are requested -- when the
parameters in beta are not identified.  By default, when the specified
constraints do not identify the parameters in the cointegrating equations,
estimation tables are displayed only for Pi and the MAI.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noci},
{opt nopv:alues},
{opt vsquish},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}: {opt iter:ate(#)},
[{cmd:no}]{opt log}, {opt tr:ace}, 
{opt toltr:ace}, {opt tol:erance(#)}, {opt ltol:erance(#)},
{opt af:rom(matrix_a)}, and {opt bf:rom(matrix_b)};
see {helpb maximize:[R] Maximize}.

{phang2}
{cmd:toltrace} displays the relative differences for the log likelihood and
the coefficient vector at every iteration.  This option cannot be specified if
no constraints are defined or if {cmd:nolog} is specified.

{phang2}
{opt afrom(matrix_a)} specifies a 1 x (K*r) row vector with starting values
for the adjustment parameters, where K is the number of endogenous variables
and r is the number of cointegrating equations specified in the {cmd:rank()}
option.  The starting values should be ordered as they are reported in
{cmd:e(alpha)}.  This option cannot be specified if no constraints are
defined.

{phang2}
{opt bfrom(matrix_b)} specifies a 1 x (m1*r) row vector with starting values
for the parameters of the cointegrating equations, where m1 is the number of
variables in the trend-augmented system and r is the number of cointegrating
equations specified in the {cmd:rank()} option.  (See
{it:{mansection TS vecMethodsandformulas:Methods and formulas}}
in {bf:[TS] vec} for more details about m1.)  The starting values should be
ordered as they are reported in {cmd:e(betavec)}.  For some trend
specifications, {cmd:e(beta)} contains parameter estimates that are not
obtained directly from the optimization algorithm.  {cmd:bfrom()} should
specify only starting values for the parameters reported in {cmd:e(betavec)}.
This option cannot be specified if no constraints are defined.

{pstd}
The following option is available with {opt vec} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse rdinc}

{pstd}Fit a vector error-correction model (VECM), assuming quadratic trends in
variables and one trend-stationary cointegrating equation{p_end}
{phang2}{cmd:. vec ln_ne ln_se}{p_end}

{pstd}Fit a VECM by using 3 lags{p_end}
{phang2}{cmd:. vec ln_ne ln_se, lags(3)}{p_end}

{pstd}Fit a VECM, assuming all means and trends are zero{p_end}
{phang2}{cmd:. vec ln_ne ln_se, trend(none)}{p_end}

{pstd}Fit a VECM and report adjustment parameters in separate table{p_end}
{phang2}{cmd:. vec ln_ne ln_se, alpha}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse urates}

{pstd}Fit a VECM, including a restricted constant (no linear trends in the
variables) in the model, including 2 cointegrating equations, and using 4 lags
{p_end}
{phang2}{cmd:. vec missouri indiana kentucky illinois, trend(rconstant)}
             {cmd:rank(2) lags(4)}

{pstd}Replay results and do not report parameters in the cointegrating 
equations{p_end}
{phang2}{cmd:. vec, nobtable}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:vec} stores the following in {cmd:e()}:

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k_rank)}}number of unconstrained parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(k_ce)}}number of cointegrating equations{p_end}
{synopt:{cmd:e(n_lags)}}number of lags{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(chi2_res)}}value of test of overidentifying restrictions{p_end}
{synopt:{cmd:e(df_lr)}}degrees of freedom of the test of overidentifying
	restrictions{p_end}
{synopt:{cmd:e(beta_iden)}}{cmd:1} if the parameters in beta are identified
       and {cmd:0} otherwise{p_end}
{synopt:{cmd:e(beta_icnt)}}number of independent restrictions placed on
	beta{p_end}
{synopt:{cmd:e(k_}{it:#}{cmd:)}}number of variables in equation {it:#}{p_end}
{synopt:{cmd:e(df_m}{it:#}{cmd:)}}model degrees of freedom in equation
	{it:#}{p_end}
{synopt:{cmd:e(r2_}{it:#}{cmd:)}}R-squared of equation {it:#}{p_end}
{synopt:{cmd:e(chi2_}{it:#}{cmd:)}}chi-squared statistic for equation
	{it:#}{p_end}
{synopt:{cmd:e(rmse_}{it:#}{cmd:)}}RMSE of equation {it:#}{p_end}
{synopt:{cmd:e(aic)}}value of AIC{p_end}
{synopt:{cmd:e(hqic)}}value of HQIC{p_end}
{synopt:{cmd:e(sbic)}}value of SBIC{p_end}
{synopt:{cmd:e(tmin)}}minimum time{p_end}
{synopt:{cmd:e(tmax)}}maximum time{p_end}
{synopt:{cmd:e(detsig_ml)}}determinant of the estimated covariance matrix{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(converge)}}{cmd:1} if switching algorithm converged, {cmd:0}
         if it did not converge{p_end}

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:vec}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(trend)}}trend specified{p_end}
{synopt:{cmd:e(tsfmt)}}format of the time variable{p_end}
{synopt:{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt:{cmd:e(endog)}}endogenous variables{p_end}
{synopt:{cmd:e(covariates)}}list of covariates{p_end}
{synopt:{cmd:e(eqnames)}}equation names{p_end}
{synopt:{cmd:e(cenames)}}names of cointegrating equations{p_end}
{synopt:{cmd:e(reduce_opt)}}{cmd:noreduce}, if {cmd:noreduce} is
	specified{p_end}
{synopt:{cmd:e(reduce_lags)}}list of maximum lags to which the model has been
	reduced{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(aconstraints)}}constraints placed on alpha{p_end}
{synopt:{cmd:e(bconstraints)}}constraints placed on beta{p_end}
{synopt:{cmd:e(sindicators)}}seasonal indicator variables{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {opt margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {opt margins}{p_end}
{synopt:{cmd:e(marginsdefault)}}default {opt predict()} specification for {cmd:margins}{p_end}

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}estimates of short-run parameters{p_end}
{synopt:{cmd:e(V)}}VCE of short-run parameter estimates{p_end}
{synopt:{cmd:e(beta)}}estimates of beta{p_end}
{synopt:{cmd:e(V_beta)}}VCE of beta hat{p_end}
{synopt:{cmd:e(betavec)}}directly obtained estimates of beta{p_end}
{synopt:{cmd:e(pi)}}estimates of pi hat{p_end}
{synopt:{cmd:e(V_pi)}}VCE of pi hat{p_end}
{synopt:{cmd:e(alpha)}}estimates of alpha{p_end}
{synopt:{cmd:e(V_alpha)}}VCE of alpha hat{p_end}
{synopt:{cmd:e(omega)}}estimates of omega hat{p_end}
{synopt:{cmd:e(mai)}}estimates of mai{p_end}
{synopt:{cmd:e(V_mai)}}VCE of mai hat{p_end}

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker J1995}{...}
{phang}
Johansen, S. 1995.
{it:Likelihood-Based Inference in Cointegrated Vector Autoregressive Models}.
Oxford: Oxford University Press.
{p_end}
