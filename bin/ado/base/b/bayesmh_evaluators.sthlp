{smcl}
{* *! version 1.0.9  25apr2019}{...}
{viewerdialog bayesmh "dialog bayesmh"}{...}
{vieweralsosee "[BAYES] bayesmh evaluators" "mansection BAYES bayesmhevaluators"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian postestimation"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes glossary"}{...}
{vieweralsosee "" "--"}{...}
{viewerjumpto "Syntax" "bayesmh evaluators##syntax"}{...}
{viewerjumpto "Description" "bayesmh evaluators##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayesmh_evaluators##linkspdf"}{...}
{viewerjumpto "Options" "bayesmh evaluators##options"}{...}
{viewerjumpto "Remarks" "bayesmh evaluators##remarks"}{...}
{viewerjumpto "Stored results" "bayesmh evaluators##results"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[BAYES] bayesmh evaluators} {hline 2}}User-defined evaluators with bayesmh{p_end}
{p2col:}({mansection BAYES bayesmhevaluators:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
{cmd:Single-equation models}

{p 6 11 2}
User-defined log-posterior evaluator 

{p 8 11 2}
{opt bayesmh} {depvar} [{indepvars}]
   {ifin} [{it:{help bayesmh evaluators##weight:weight}}]{cmd:,} 
   {opth eval:uator(bayesmh_evaluators##evalspec:evalspec)}
   [{it:{help bayesmh_evaluators##options_table:options}}]

{p 6 11 2}
User-defined log-likelihood evaluator

{p 8 11 2}
{opt bayesmh} {depvar} [{indepvars}]
   {ifin} [{it:{help bayesmh_evaluators##weight:weight}}]{cmd:,} 
   {opth lleval:uator(bayesmh_evaluators##evalspec:evalspec)}
   {opth prior:(bayesmh##priorspec:priorspec)}
   [{it:{help bayesmh_evaluators##options_table:options}}]


{phang}
{cmd:Multiple-equations models}

{p 6 11 2}
User-defined log-posterior evaluator

{p 8 11 2}
{opt bayesmh} {cmd:(}{it:{help bayesmh evaluators##eqspecp:eqspecp}}{cmd:)}
    [{cmd:(}{it:eqspecp}{cmd:)} [...]]
    {ifin} [{it:{help bayesmh evaluators##weight:weight}}]{cmd:,} 
   {opth eval:uator(bayesmh_evaluators##evalspec:evalspec)}
   [{it:{help bayesmh_evaluators##options_table:options}}]

{p 6 11 2}
User-defined log-likelihood evaluator

{p 8 11 2}
{opt bayesmh} {cmd:(}{it:{help bayesmh evaluators##eqspecll:eqspecll}}{cmd:)}
    [{cmd:(}{it:eqspecll}{cmd:)} [...]]
    {ifin} [{it:{help bayesmh evaluators##weight:weight}}]{cmd:,} 
   {opth prior:(bayesmh##priorspec:priorspec)}
   [{it:{help bayesmh_evaluators##options_table:options}}]


{marker eqspecp}{...}
{pstd}
The syntax of {it:eqspecp} is 

{p 8 11 2}
   {it:{help bayesmh##varspec:varspec}} [{cmd:,} {opt nocons:tant}] 
{p_end}

{marker eqspecll}{...}
{pstd}
The syntax of {it:eqspecll} for built-in likelihood models is 

{p 8 11 2}
   {it:{help bayesmh##varspec:varspec}}{cmd:,}
   {opt likel:ihood}{cmd:(}{it:{help bayesmh##modelspec:modelspec}}{cmd:)}
   [{opt nocons:tant}] 
{p_end}

{pstd}
The syntax of {it:eqspecll} for user-defined log-likelihood evaluators is 

{p 8 11 2}
   {it:{help bayesmh##varspec:varspec}}{cmd:,}
   {opt lleval:uator}{cmd:(}{it:{help bayesmh_evaluators##evalspec:evalspec}}{cmd:)}
   [{opt nocons:tant}] 
{p_end}

{marker varspec}{...}
{phang}
The syntax of {it:varspec} is one of the following:

        for single outcome

{phang3}
[{it:eqname}{cmd::}]{depvar} [{indepvars}]
{p_end}

        for multiple outcomes with common regressors

{phang3}
{it:{help depvar:depvars}} {cmd:=} [{indepvars}]
{p_end}

        for multiple outcomes with outcome-specific regressors

{phang3}
{cmd:(}[{it:eqname1}{cmd::}]{it:{help depvar:depvar1}} [{it:{help indepvars:indepvars1}}]{cmd:)}
{cmd:(}[{it:eqname2}{cmd::}]{it:{help depvar:depvar2}} [{it:{help indepvars:indepvars2}}]{cmd:)}
[...]
{p_end}

{marker evalspec}{...}
{phang}
The syntax of {it:evalspec} is 

{p 8 11 2}
	{it:progname}{cmd:,} {opth param:eters(bayesmh_evaluators##paramlist:paramlist)}
	[{opth extravars(varlist)} {opt passthru:opts(string)}]
{p_end}

{marker paramlist}{...}
{pmore}
where {it:progname} is the name of a Stata program that you write to evaluate
the log-posterior density or the log-likelihood function (see 
{help bayesmh_evaluators##program:{it:Program evaluators}}),
and {it:paramlist} is a list of model parameters:

{phang3}
{it:{help bayesmh_evaluators##paramdef:paramdef}} [{it:paramdef} [...]]
{p_end}

{marker paramdef}{...}
{phang}
The syntax of {it:paramdef} is

{phang3}
{cmd:{c -(}}[{it:eqname}{cmd::}]{it:param} [{it:param} [...]] [{cmd:,} {opt m:atrix}]{cmd:{c )-}}

{pmore}
where the parameter label {it:eqname} and parameter names {it:param} are
valid Stata names.  Model parameters are either scalars such as
{cmd:{c -(}var{c )-}}, {cmd:{c -(}mean{c )-}}, and
{cmd:{c -(}shape:alpha{c )-}} or matrices such as
{cmd:{c -(}Sigma, matrix{c )-}} and {cmd:{c -(}Scale:V, matrix{c )-}}.  For
scalar parameters, you can use {cmd:{c -(}param=}{it:#}{cmd:{c )-}} in the
above to specify an initial value. For example, you can specify
{cmd:{c -(}var=1{c )-}}, {cmd:{c -(}mean=1.267{c )-}}, or
{cmd:{c -(}shape:alpha=3{c )-}}.  You can specify multiple
parameters with same equation as {cmd:{c -(}eq:p1 p2 p3{c )-}} or
{cmd:{c -(}eq: S1 S2, matrix{c )-}}. Also see
{mansection BAYES bayesmhRemarksandexamplesDeclaringmodelparameters:{it:Declaring model parameters}}
in {bf:[BAYES] bayesmh}.


{marker options_table}{...}
{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{p2coldent: * {opth eval:uator(bayesmh_evaluators##evalspec:{it:evalspec})}}specify log-posterior evaluator; may not be
combined with {cmd:llevaluator()} and {cmd:prior()}{p_end}
{p2coldent: * {opth lleval:uator(bayesmh_evaluators##evalspec:{it:evalspec})}}specify log-likelihood evaluator;
requires {cmd:prior()} and may not be combined with {cmd:evaluator()}{p_end}
{p2coldent: * {opth prior:(bayesmh##priorspec:priorspec)}}prior for model
parameters; required with log-likelihood evaluator and may be repeated{p_end}
{synopt :{opth likel:ihood(bayesmh##modelspec:modelspec)}}distribution for the likelihood
model; allowed within an equation of a multiple-equations model only{p_end}
{synopt :{opt nocons:tant}}suppress constant term; not allowed with ordered
models specified in {cmd:likelihood()} with multiple-equations models{p_end}
{synopt : {it:{help bayesmh##options_table:bayesmhopts}}}any options of {manhelp bayesmh BAYES}
except {cmd:likelihood()} and {cmd:prior()}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* Option {cmd:evaluator()} is required for log-posterior evaluators,
and options {cmd:llevaluator()} and {cmd:prior()} are required for
log-likelihood evaluators.  With log-likelihood evaluators, {cmd:prior()} must
be specified for all model parameters and may be repeated.{p_end}
{p 4 6 2}{it:indepvars} may contain factor variables; see
{help fvvarlists}.{p_end}
{marker weight}{...}
{p 4 6 2}Only {cmd:fweight}s are allowed; see {help weight}.{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayesmh} provides two options, {cmd:evaluator()} and {cmd:llevaluator()},
that facilitate user-defined evaluators for fitting general Bayesian
regression models. {cmd:bayesmh, evaluator()} accommodates log-posterior
evaluators. {cmd:bayesmh, llevaluator()} accommodates log-likelihood
evaluators, which are combined with built-in prior distributions to form the
desired posterior density. For a catalog of built-in likelihood models and
prior distributions, see {manhelp bayesmh BAYES}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesmhevaluatorsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth evaluator:(bayesmh_evaluators##evalspec:evalspec)} specifies the name and
the attributes of the log-posterior evaluator; see
{help bayesmh_evaluators##program:{it:Program evaluators}}
for details. This option may not be combined with {cmd:llevaluator()} or
{cmd:likelihood()}.

{phang}
{opth llevaluator:(bayesmh_evaluators##evalspec:evalspec)} specifies the name
and the attributes of the log-likelihood evaluator; see
{help bayesmh_evaluators##program:{it:Program evaluators}} for details. This
option may not be combined with {cmd:evaluator()} or {cmd:likelihood()} and
requires the {cmd:prior()} option.

{phang}
{opth prior:(bayesmh##priorspec:priorspec)}; see {manhelp bayesmh BAYES}.  

{phang}
{opth likelihood:(bayesmh##modelspec:modelspec)}; see {manhelp bayesmh BAYES}.
This option is allowed within an equation of a multiple-equations model only.

{phang}
{cmd:noconstant}; see {manhelp bayesmh BAYES}.

{phang}
{it:bayesmhopts} specify any
{it:{help bayesmh##options_table:options}} of {manhelp bayesmh BAYES}, except
{cmd:likelihood()} and {cmd:prior()}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help bayesmh evaluators##program:Program evaluators}
        {help bayesmh evaluators##global_macros:Global macros}


{marker program}{...}
{title:Program evaluator}

{pstd}
If your likelihood model or prior distributions are particularly complex and
cannot be represented by one of the predefined sets of distributions or by
substitutable expressions provided with {helpb bayesmh}, you can program
these functions by writing your own evaluator program.

{pstd}
Evaluator programs can be used for programming the full posterior density by
specifying the {cmd:evaluator()} option or only the likelihood portion of your
Bayesian model by specifying the {cmd:llevaluator()} option.  For likelihood
evaluators, {cmd:prior()} option(s) must be specified for all model
parameters.  Your program is expected to calculate and return an overall
log-posterior or a log-likelihood density value.

{pstd}
It is allowed for the return values to match the log density up to an additive
constant, in which case, however, some of the reported statistics such as
DIC and log marginal-likelihood may not be applicable.

{pstd}
Your program evaluator {it:progname} must be a Stata program; see
{findalias frprograms}. The program must follow the style below.

            {cmd:program} {it:progname}
                {cmd}args lnden xb1 [xb2{txt} ...{cmd:] [}{it:modelparams}{cmd:]}

                 ... {it:computations} ...

                 {cmd}scalar `lnden' ={txt} ...
            {cmd:end}

{pstd}
Here {cmd:lnden} contains the name of a temporary scalar to be filled in with
an overall log-posterior or log-likelihood value;

{phang2}
{cmd:xb}{it:#} contains the name of a temporary variable containing the linear
predictor from the {it:#}th equation; and

{phang2}
{it:modelparams} is a list of names of scalars or matrices to contain the
values of model parameters specified in suboption {cmd:parameters()} of
{cmd:evaluator() or {cmd:llevaluator()}}.  For matrix parameters, the
specified names will contain the names of temporary matrices containing
current values.  For scalar parameters, these are the names of temporary
scalars containing current values.  The order in which names are listed should
correspond to the order in which model parameters are specified in
{cmd:parameters()}.

{pstd}
Also see {help bayesmh_evaluators##global_macros:{it:Global macros}} for a
list of global macros available to the program evaluator.

{pstd}
After you write a program evaluator, you specify its name in the option
{cmd:evaluator()} for log-posterior evaluators,

{phang2}
{cmd:. bayesmh} ...{cmd:,} {opt evaluator(progname, evalopts)}

{pstd}
or option {cmd:llevaluator()} for log-likelihood evaluators,

{phang2}
{cmd:. bayesmh} ...{cmd:,} {opt llevaluator(progname, evalopts)}

{pstd}
Evaluator options {it:evalopts} include {cmd:parameters()}, {cmd:extravars()},
and {cmd:passthruopts()}.

{phang2}
{opth parameters:(bayesmh_evaluators##paramlist:paramlist)} specifies model
parameters. Model parameters can be scalars or matrices. Each parameter must
be specified in curly braces {cmd:{c -(} {c )-}}. Multiple parameters with the
same equation names may be specified within one set of {cmd:{c -(} {c )-}}.

{pmore2}
For example,

{phang3}
{cmd:parameters({mu} {c -(}var:sig2{c )-} {S,matrix} {cov:Sigma, matrix}}
           {cmd:{prob:p1 p2})}

{pmore2}
specifies a scalar parameter with name {cmd:mu} without an equation label, a
scalar parameter with name {cmd:sig2} and label {cmd:var}, a
matrix parameter with name {cmd:S}, a matrix parameter with name {cmd:Sigma}
and label {cmd:cov}, and two scalar parameters {cmd:{prob:p1}} and
{cmd:{prob:p2}}.

{phang2}
{opth extravars(varlist)} specifies any variables in addition to dependent and
independent variables that you may need in your program evaluator. Examples
of such variables are offset variables, exposure variables for count-data
models, and failure or censoring indicators for survival-time models. See
{mansection BAYES bayesmhevaluatorsRemarksandexamplesCoxproportionalhazardsregression:{it:Cox proportional hazards regression}}
in {bf:[BAYES] bayesmh evaluators} for an example.

{phang2}
{opt passthruopts(string)} specifies a list of options you may want to
pass to your program evaluator. For example, these options may contain fixed
values of model parameters and hyperparameters. See
{mansection BAYES bayesmhevaluatorsRemarksandexamplesMultivariatenormalregressionmodel:{it:Multivariate normal regression model}}
in {bf:[BAYES] bayesmh evaluators} for an example.

{pstd}
{opt bayesmh} automatically creates parameters for regression coefficients:
{cmd:{c -(}}{it:depname}{cmd::}{it:varname}{cmd:{c )-}} for every {it:varname}
in {it:indepvars}, and a constant parameter
{cmd:{c -(}}{it:depname}{cmd:{c )-}} unless {cmd:noconstant} is specified.
These parameters are used to form linear predictors used by the program
evaluator.  If you need to access values of the parameters in the evaluator,
you can use {cmd:$MH_b}; see the log-posterior evaluator in
{mansection BAYES bayesmhevaluatorsRemarksandexamplesCoxproportionalhazardsregression:{it:Cox proportional hazards regression}}
in {bf:[BAYES] bayesmh evaluators} for an example.
With multiple dependent variables, regression coefficients are defined for
each dependent variable.


{marker global_macros}{...}
{title:Global macros}

{synoptset 20 tabbed}{...}
{marker prog_global}{...}
{synopt:Global macro}Description{p_end}
{synoptline}
{synopt :{opt $MH_N}}number of observations{p_end}
{synopt :{opt $MH_yn}}number of dependent variables{p_end}
{synopt: {opt $MH_touse}}variable containing 1 for the observations to be used, 0 otherwise{p_end}
{synopt: {opt $MH_w}}variable containing weight associated with observations{p_end}
{synopt :{opt $MH_extravars}}{varlist} specified in {cmd:extravars()}{p_end}
{synopt :{opt $MH_passthruopts}}options specified in {cmd:passthruopts()}{p_end}

{marker one_outcome}{...}
{syntab:One outcome}
{synopt :{opt $MH_y}}name of dependent variable{p_end}
{synopt :{opt $MH_x1}}name of first independent variable{p_end}
{synopt :{opt $MH_x2}}name of second independent variable{p_end}
{synopt :{opt ...}}{p_end}
{synopt :{opt $MH_xn}}number of independent variables{p_end}
{synopt :{opt $MH_xb}}name of temporary variable containing the linear combination{p_end}

{marker multiple_outcomes}{...}
{syntab:Multiple outcomes}
{synopt :{opt $MH_y1}}name of first dependent variable{p_end}
{synopt :{opt $MH_y2}}name of second dependent variable{p_end}
{synopt :{opt ...}}{p_end}

{synopt :{opt $MH_y1x1}}name of first independent variable modeling y1{p_end}
{synopt :{opt $MH_y1x2}}name of second independent variable modeling y1{p_end}
{synopt :{opt ...}}{p_end}
{synopt :{opt $MH_y1xn}}number of independent variables modeling y1{p_end}
{synopt :{opt $MH_y1xb}}name of temporary variable containing the linear combination modeling y1{p_end}

{synopt :{opt $MH_y2x1}}name of first independent variable modeling y2{p_end}
{synopt :{opt $MH_y2x2}}name of second independent variable modeling y2{p_end}
{synopt :{opt ...}}{p_end}
{synopt :{opt $MH_y2xn}}number of independent variables modeling y2{p_end}
{synopt :{opt $MH_y2xb}}name of temporary variable containing the linear combination modeling y2{p_end}

{synopt :{opt ...}}{p_end}

{marker prog_params}{...}
{syntab:Scalar and matrix parameters}
{synopt :{opt $MH_b}}name of a temporary vector of coefficients; stripes are
properly named after the name of the coefficients{p_end}
{synopt :{opt $MH_bn}}number of coefficients{p_end}
{synopt :{opt $MH_p}}name of a temporary vector of additional scalar model parameters, if any; stripes are properly named{p_end}
{synopt :{opt $MH_pn}}number of additional scalar model parameters{p_end}
{synopt :{opt $MH_m1}}name of a temporary matrix of the first matrix parameter, if any{p_end}
{synopt :{opt $MH_m2}}name of a temporary matrix of the second matrix parameter, if any{p_end}
{synopt :{opt ...}}{p_end}
{synopt :{opt $MH_mn}}number of matrix model parameters{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
In addition to the results stored by {cmd:bayesmh}, {cmd:bayesmh, evaluator()}
and {cmd:bayesmh, llevaluator()} store the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 15 17 2: Macros}{p_end}
{synopt:{cmd:e(evaluator)}}program evaluator (one equation){p_end}
{synopt:{cmd:e(evaluator}{it:#}{cmd:)}}program evaluator for the {it:#}th equation{p_end}
{synopt:{cmd:e(evalparams)}}evaluator parameters (one equation){p_end}
{synopt:{cmd:e(evalparams}{it:#}{cmd:)}}evaluator parameters for the {it:#}th equation{p_end}
{synopt:{cmd:e(extravars)}}extra variables (one equation){p_end}
{synopt:{cmd:e(extravars}{it:#}{cmd:)}}extra variables for the {it:#}th equation{p_end}
{synopt:{cmd:e(passthruopts)}}pass-through options (one equation){p_end}
{synopt:{cmd:e(passthruopts}{it:#}{cmd:)}}pass-through options for the {it:#}th equation{p_end}
{p2colreset}{...}
