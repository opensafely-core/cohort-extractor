{smcl}
{* *! version 1.0.0  28apr2019}{...}
{viewerdialog cmrologit "dialog cmrologit"}{...}
{vieweralsosee "[CM] cmrologit" "mansection CM cmrologit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmrologit postestimation" "help cmrologit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmclogit" "help cmclogit"}{...}
{vieweralsosee "[CM] cmroprobit" "help cmroprobit"}{...}
{vieweralsosee "[CM] cmset" "help cmset"}{...}
{vieweralsosee "[R] ologit" "help ologit"}{...}
{viewerjumpto "Syntax" "cmrologit##syntax"}{...}
{viewerjumpto "Menu" "cmrologit##menu"}{...}
{viewerjumpto "Description" "cmrologit##description"}{...}
{viewerjumpto "Links to PDF documentation" "cmrologit##linkspdf"}{...}
{viewerjumpto "Options" "cmrologit##options"}{...}
{viewerjumpto "Examples" "cmrologit##examples"}{...}
{viewerjumpto "Stored results" "cmrologit##results"}{...}
{viewerjumpto "References" "cmrologit##references"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[CM] cmrologit} {hline 2}}Rank-ordered logit choice model{p_end}
{p2col:}({mansection CM cmrologit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:cmrologit}
{depvar}
{indepvars}
{ifin}
[{help cmrologit##weight:{it:weight}}]
[{cmd:,} {it:options}]

{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt inc:omplete(#)}}use {it:#} to code unranked alternatives;
default is {cmd:incomplete(0)}{p_end}
{synopt :{opt rev:erse}}reverse the preference order{p_end}
{synopt :{opt ties(spec)}}method to handle ties: {cmd:exactm}, {cmd:breslow},
{cmd:efron}, or {cmd:none}{p_end}
{synopt :{opt altwise}}use alternativewise deletion instead of casewise
deletion{p_end}
{synopt :{opt note:strhs}}keep right-hand-side variables that do not vary
within case{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with
coefficient constrained to 1{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {cmd:oim},
{opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap},
or {opt jack:knife}{p_end}


{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{it:{help cmrologit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help cmrologit##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:cmset} your data before using {cmd:cmrologit};
see {manhelp cmset CM}.{p_end}
INCLUDE help fvvarlist2
{p 4 6 2}
{cmd:bootstrap},
{cmd:by},
{cmd:fp},
{cmd:jackknife}, and
{cmd:statsby}
are allowed; see {help prefix}.{p_end}
INCLUDE help weight_boot
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s
are allowed, except no weights are allowed with {cmd:ties(efron)},
and {cmd:pweight}s are not allowed with {cmd:ties(exactm)};
see {help weight}.{p_end}
{p 4 6 2}
{cmd:coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp cmrologit_postestimation CM:cmrologit postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Choice models > Rank-ordered logit model}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cmrologit} fits the rank-ordered logistic regression model by
maximum likelihood
({help cmrologit##beggscardellhausman1981:Beggs, Cardell, and Hausman 1981}).
This model is also known as the Plackett-Luce model
({help cmrologit##marden1995:Marden 1995}), as the exploded logit model
({help cmrologit##punjstaelin1978:Punj and Staelin 1978}), and as the
choice-based method of conjoint analysis
({help cmrologit##hairblackbabinanderson2010:Hair et al. 2010}).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection CM cmrologitQuickstart:Quick start}

        {mansection CM cmrologitRemarksandexamples:Remarks and examples}

        {mansection CM cmrologitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt incomplete(#)} specifies the numeric value used to code
alternatives that are not ranked.  It is assumed that unranked alternatives
are less preferred than the ranked alternatives (that is, the data record the
ranking of the most preferred alternatives).  It is not assumed that subjects
are indifferent between the unranked alternatives.  {it:#} defaults to 0.

{phang}
{opt reverse} specifies that in the preference order, a higher number means a
less attractive alternative.  The default is that higher values
indicate more attractive alternatives.  The rank-ordered logit model is not
symmetric in the sense that reversing the ordering simply leads to a change in
the signs of the coefficients.

{phang}
{opt ties(spec)} specifies the method for handling ties
(indifference between alternatives) (see {manhelp stcox ST} for details):

            {cmdab:ex:actm}    exact marginal likelihood (default)
            {cmdab:bre:slow}   Breslow's method (default if {cmd:pweight}s specified)
            {cmdab:efr:on}     Efron's method (default if robust VCE)
            {cmd:none}      no ties allowed

{phang}
{opt altwise} specifies that alternativewise deletion be used when omitting
observations because of missing values in your variables.  The default is to
use casewise deletion; that is, the entire group of observations making up a
case is omitted if any missing values are encountered.  This option does not
apply to observations that are excluded by the {cmd:if} or {cmd:in} qualifier
or the {cmd:by} prefix; these observations are always handled alternativewise
regardless of whether {cmd:altwise} is specified.

{phang}
{opt notestrhs} suppresses the test that the independent variables vary within
(at least some of) the cases.  Effects of variables that are always constant
are not identified.  For instance, a rater's gender cannot directly affect his
or her rankings; it could affect the rankings only via an interaction with a
variable that does vary over alternatives.

{phang}
{opth offset(varname)}; see {helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

{marker vcetype}{...}
{phang}
{opt vce(vcetype)} specifies the type of standard error reported,
which includes types that are derived from asymptotic theory ({cmd:oim}), that
are robust to some kinds of misspecification ({cmd:robust}), that allow for
intragroup correlation ({cmd:cluster} {it:clustvar}), and that use bootstrap
or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{manhelpi vce_option R}.

{pmore}
If {cmd:ties(exactm)} is specified, {it:vcetype} may be only {cmd:oim},
{cmd:bootstrap}, or {cmd:jackknife}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options:[R] Estimation options}.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt iter:ate(#)},
{opt tr:ace},
[{cmd:no}]{cmd:log},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)}, and
{opt nonrtol:erance};
see {helpb maximize:[R] Maximize}.  These options are seldom used.

{pstd}
The following option is available with {cmd:cmrologit} but is not shown in
the dialog box:

{phang}
{opt coeflegend}; see {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse evignet}{p_end}
{phang2}{cmd:. cmset caseid, noalternatives}{p_end}

{pstd}Fit rank-ordered logit choice model{p_end}
{phang2}{cmd:. cmrologit pref i.female age i.grades i.edufit i.workexp i.boardexp if job==1}

{pstd}Fit a model for all jobs and estimate cluster-robust standard errors{p_end}
{phang2}{cmd:. cmrologit pref job##(i.female i.grades i.edufit i.workexp), vce(cluster employer)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:cmrologit} stores the following in {cmd:e()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(N_case)}}number of cases{p_end}
{synopt :{cmd:e(N_ic)}}N for Bayesian information criterion
(BIC){p_end}
{synopt :{cmd:e(N_clust)}}number of clusters{p_end}
{synopt :{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt :{cmd:e(ll)}}log likelihood{p_end}
{synopt :{cmd:e(ll_0)}}log likelihood of the null model ("all rankings are equiprobable"){p_end}
{synopt :{cmd:e(chi2)}}chi-squared{p_end}
{synopt :{cmd:e(r2_p)}}pseudo-R-squared{p_end}
{synopt :{cmd:e(p)}}p-value for model test{p_end}
{synopt :{cmd:e(code_inc)}}value for incomplete preferences{p_end}
{synopt :{cmd:e(alt_min)}}minimum number of alternatives{p_end}
{synopt :{cmd:e(alt_avg)}}average number of alternatives{p_end}
{synopt :{cmd:e(alt_max)}}maximum number of alternatives{p_end}
{synopt :{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 25 29 2: Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:cmrologit}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt :{cmd:e(caseid)}}name of case ID variable{p_end}
{synopt :{cmd:e(wtype)}}weight type{p_end}
{synopt :{cmd:e(wexp)}}weight expression{p_end}
{synopt :{cmd:e(marktype)}}{cmd:casewise} or {cmd:altwise}, type of
markout{p_end}
{synopt :{cmd:e(key_N_ic)}}{cmd:cases}, key for N for
Bayesian information criterion (BIC){p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt :{cmd:e(offset)}}linear offset variable{p_end}
{synopt :{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared test{p_end}
{synopt :{cmd:e(reverse)}}{cmd:reverse}, if specified{p_end}
{synopt :{cmd:e(ties)}}{cmd:breslow}, {cmd:efron}, {cmd:exactm}{p_end}
{synopt :{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt :{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt :{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt :{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt :{cmd:e(marginsdefault)}}default {cmd:predict()} specification for
{cmd:margins}{p_end}
{synopt :{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt :{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 25 29 2: Matrices}{p_end}
{synopt :{cmd:e(b)}}coefficient vector{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt :{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 25 29 2: Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker beggscardellhausman1981}{...}
{phang}
Beggs, S., S. Cardell, and J. A. Hausman. 1981. Assessing the potential demand
for electric cars. {it:Journal of Econometrics} 17: 1-19.

{marker hairblackbabinanderson2010}{...}
{phang}
Hair, J. F., Jr., W. C. Black, B. J. Babin, and R. E. Anderson. 2010.
Multivariate Data Analysis. 7th ed. Upper Saddle River, NJ: Pearson.

{marker marden1995}{...}
{phang}
Marden, J. I. 1995. Analyzing and Modeling Rank Data. London: Chapman & Hall.

{marker punjstaelin1978}{...}
{phang}
Punj, G. N., and R. Staelin. 1978. The choice process for graduate business
schools. {it:Journal of Marketing Research} 15: 588-598.
{p_end}
