{smcl}
{* *! version 1.2.9  19feb2019}{...}
{viewerdialog mlexp "dialog mlexp"}{...}
{vieweralsosee "[R] mlexp" "mansection R mlexp"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] mlexp postestimation" "help mlexp postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] gmm" "help gmm"}{...}
{vieweralsosee "[R] Maximize" "help maximize"}{...}
{vieweralsosee "[R] ml" "help ml"}{...}
{vieweralsosee "[R] nl" "help nl"}{...}
{vieweralsosee "[R] nlsur" "help nlsur"}{...}
{viewerjumpto "Syntax" "mlexp##syntax"}{...}
{viewerjumpto "Menu" "mlexp##menu"}{...}
{viewerjumpto "Description" "mlexp##description"}{...}
{viewerjumpto "Links to PDF documentation" "mlexp##linkspdf"}{...}
{viewerjumpto "Options" "mlexp##options"}{...}
{viewerjumpto "Remarks" "mlexp##remarks"}{...}
{viewerjumpto "Examples" "mlexp##examples"}{...}
{viewerjumpto "Stored results" "mlexp##results"}{...}
{viewerjumpto "Reference" "mlexp##reference"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] mlexp} {hline 2}}Maximum likelihood estimation of 
user-specified expressions{p_end}
{p2col:}({mansection R mlexp:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 11 2}
{cmd:mlexp} {cmd:(}{it:lexp}{cmd:)} 
   {ifin} 
   [{it:{help mlexp##weight:weight}}]
   [{cmd:,} {it:{help mlexp##option_table:options}}]

{phang}
where {it:lexp} is a substitutable expression representing the log-likelihood
function.

{synoptset 28 tabbed}{...}
{marker option_table}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opth va:riables(varlist)}}specify variables in model{p_end}
{synopt :{opt from(initial_values)}}specify initial values for parameters{p_end}
{synopt:{cmdab:const:raints(}{it:{help estimation options##constraints():numlist}}{cmd:)}}apply specified linear constraints{p_end}

{syntab :Derivatives}
{synopt :{opt deriv:ative}{cmd:(/}{it:name} {cmd:=} {it:dexp}{cmd:)}}specify 
derivative of {it:lexp} with respect to parameter {it:name}; can be 
specified more than once{p_end}

{syntab :SE/Robust}
{synopt :{cmd:vce(}{it:{help nl##vcetype:vcetype}}{cmd:)}}{it:vcetype}
           may be {opt oim}, {opt opg}, {opt r:obust}, {opt cl:uster} 
           {it:clustvar}, {opt boot:strap}, or {opt jack:knife}{p_end}
            
{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt title(string)}}display {it:string} as title above the table of parameter estimates{p_end}
{synopt :{opt title2(string)}}display {it:string} as subtitle{p_end}
{synopt :{it:{help mlexp##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help mlexp##mlexp_maximize:maximize_options}}}control the 
maximization process; seldom used{p_end}

{synopt :{opt debug}}display debug output{p_end}
{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p 4 6 2}{it:lexp} and {it:dexp} may contain factor variables and time-series
operators; see {help fvvarlist} and {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:rolling}, 
{cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{p 4 6 2}{cmd:vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:aweight}s, {cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s
are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt debug}, {opt collinear}, and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp mlexp R:mlexp postestimation} for features available after
estimation.{p_end}

{pstd}
{it:lexp} and {it:dexp} are substitutable expressions, Stata expressions that
also contain parameters to be estimated.  The parameters are enclosed in curly
braces and must satisfy the naming requirements for variables;
{cmd:{c -(}beta{c )-}} is an example of a parameter.  The notation
{cmd:{c -(}}{it:lc}:{it:varlist}{cmd:{c )-}} is allowed for linear
combinations of multiple covariates and their parameters.  For example,
{cmd:{c -(}xb:} {cmd:mpg} {cmd:price} {cmd:turn} {cmd:_cons}{cmd:{c )-}} defines a
linear combination of the variables {cmd:mpg}, {cmd:price}, {cmd:turn}, and
{cmd:_cons} (the constant term).  See
{mansection R mlexpRemarksandexamplesSubstitutableexpressions:{it:Substitutable expressions}} under {it:Remarks and examples} of {bf:[R] mlexp}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Other > Maximum likelihood estimation of expression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mlexp} performs maximum likelihood estimation of models that 
satisfy the linear-form restrictions, that is, models for which 
you can write the log likelihood for an individual observation and 
for which the overall log likelihood is the sum of the individual 
observations' log likelihoods.  

{pstd}
You express the observation-level log-likelihood function by using 
a substitutable expression.  Unlike models fit using {helpb ml}, you do not 
need to do any programming.  However, {cmd:ml} can fit classes of models that 
cannot be fit by {cmd:mlexp}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R mlexpQuickstart:Quick start}

        {mansection R mlexpRemarksandexamples:Remarks and examples}

        {mansection R mlexpMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}
{phang}
{opth variables(varlist)} specifies the variables in the model.
{opt mlexp} excludes observations for which any of these variables has
missing values. If you do not specify {cmd:variables()}, then {cmd:mlexp}
assumes all observations are valid.  {cmd:mlexp} will exit with an error
message if the log likelihood cannot be calculated at the initial values for
any observation.

{phang}
{opt from(initial_values)} specifies the initial values to begin the
estimation.  You can specify parameter names and values, or you can specify a
1 x k matrix, where k is the number of parameters in the model.  For example,
to initialize {opt alpha} to 1.23 and {opt delta} to 4.57, you would type

{pmore2}
{cmd:mlexp} ...{cmd:,} {cmd:from(alpha=1.23 delta=4.57)} ...

{pmore}
or equivalently

{pmore2}
{cmd:matrix define initval = (1.23, 4.57)}{break}
{cmd:mlexp} ...{cmd:,} {cmd:from(initval)} ...

{pmore}
Initial values declared in the {opt from()} option override any that are
declared within substitutable expressions.  If you specify a parameter that
does not appear in your model, {cmd:mlexp} exits with an error.  If you
specify a matrix, the values must be in the same order in which the parameters
are declared in your model.

{phang}
{opth constraints(numlist)}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:Derivatives}

{phang}
{cmd:derivative(}{cmd:/}{it:name} {cmd: =} {it:dexp}{cmd:)}
specifies the derivative of the observation-level log-likelihood
function with respect to parameter {it:name}.  If you wish to specify
analytic derivatives, you must specify {opt derivative()} for each
parameter in your model.

{pmore}
{it:dexp} uses the same substitutable expression syntax as is used to 
specify the log-likelihood function.  If you declare a linear 
combination in the log-likelihood function, you provide the derivative 
for the linear combination; {cmd:mlexp} then applies the chain rule for 
you.  See the final example {help mlexp##lcderiv:below}.

{pmore}
If you do not specify the {opt derivative()} option, {cmd:mlexp} calculates 
derivatives numerically.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opth title(string)} specifies an optional title that will be displayed just
above the table of parameter estimates.

{phang}
{opth title2(string)} specifies an optional subtitle that will be displayed
between the title specified in {opt title()} and the table of parameter
estimates.  If {opt title2()} is specified but {opt title()} is not, then
{opt title2()} has the same effect as {opt title()}.

INCLUDE help displayopts_list

{marker mlexp_maximize}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace},
{opt grad:ient}, {opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)}, and
{opt nonrtol:erance};
see {helpb maximize:[R] Maximize}.  These options are seldom used.

{pstd}
The following options are available with {opt mlexp} but are not shown in the
dialog box:

{phang}
{opt debug}  specifies that differences between the numerically computed 
gradient and the gradient computed from your derivative expression are
reported at each iteration.  This option is only allowed with the 
{opt derivative()} option.

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:mlexp} allows you to fit models via maximum likelihood estimation 
without doing any programming.  Instead, you express your log-likelihood 
function by using a substitutable expression, a mathematical expression
that uses curly braces to differentiate parameters from variables.  There are 
three rules to follow when defining substitutable expressions:

{phang2}
1.  Parameters of the model are bound in curly braces:
{cmd:{c -(}b0{c )-}}, {cmd:{c -(}param{c )-}}, etc.
Parameter names must follow the same conventions as variable names; see
{findalias frnames}

{phang2}
2.  Initial values for parameters are given by including an equal sign and
the initial value inside the curly braces:  {cmd:{c -(}b0=1{c )-}}, 
{cmd: {c -(}param=3.571{c )-}}, etc. 

{phang2}
3.  Linear combinations of variables can be included using the notation 
{cmd:{c -(}}{it:lc}{cmd::}{it:varlist}{cmd:{c )-}}:
{cmd:{c -(}xb: mpg price weight _cons{c )-}},
{cmd:{c -(}score: w x z{c )-}}, etc.
Parameters of linear combinations are initialized to zero.

{pstd}
Substitutable expressions can include any mathematical expression involving
scalars and variables.  See {help operator} and {help exp} for more
information on expressions.


{marker examples}{...}
{title:Examples}

{pstd}
Classical linear regression{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. mlexp (ln(normalden(mpg, {b0} + {b1}*gear_ratio, {sigma})))}{p_end}

{pstd}Same as above, constraining {it:sigma} to be positive{p_end}
{phang2}{cmd:. mlexp (ln(normalden(mpg, {xb:gear_ratio _cons}, exp({lnsigma}))))}{p_end}
{phang2}{cmd:. nlcom exp(_b[/lnsigma])}{p_end}

{pstd}
Probit regression with a linear combination of regressors{p_end}
{phang2}{cmd:. mlexp (ln(cond(foreign==1, normal({xb:gear_ratio turn _cons}),}
{cmd:normal(-1*({xb:})))))}{p_end}

{pstd}
Same as above, using {help mlexp##Greene2018:Greene's} (2018, 742, fn. 16)
auxiliary variable coded -1 for failures and +1 for successes{p_end}
{phang2}{cmd:. generate int q = 2*(foreign==1) - 1}{p_end}
{phang2}{cmd:. mlexp (ln(normal(q*({xb:gear_ratio turn _cons}))))}{p_end}

{pstd}
{marker lcderiv}
Same as above, specifying derivatives{p_end}
{phang2}{cmd:. mlexp (ln(normal(q*({xb:gear_ratio turn _cons})))),}
{cmd:deriv(/xb = q*normalden({xb:})/normal(q*({xb:})))}{p_end}
 

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mlexp} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_aux)}}number of ancillary parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:mlexp}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(lexp)}}likelihood expression{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(usrtitle)}}user-specified title{p_end}
{synopt:{cmd:e(usrtitle2)}}user-specified secondary title{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(params)}}names of parameters{p_end}
{synopt:{cmd:e(hasderiv)}}{cmd:yes}, if {cmd:derivative()} is specified{p_end}
{synopt:{cmd:e(d_}{it:j}{cmd:)}}derivative expression for parameter {it:j}{p_end}
{synopt:{cmd:e(rhs)}}contents of {cmd:variables()}{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(singularHmethod)}}{cmd:m-marquardt} or {cmd:hybrid}; method used when Hessian is singular (1){p_end}
{synopt:{cmd:e(crittype)}}optimization criterion (1){p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsprop)}}signals to the {cmd:margins} command{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(init)}}initial values{p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{space 4}{hline 20}
{p 4 6 2}
1. Type {cmd:ereturn} {cmd:list,} {cmd:all} to view these results; see {helpb return:[P] return}.


{marker reference}{...}
{title:Reference}

{marker Greene2018}{...}
{phang}
Greene, W. H. 2018.
{browse "http://www.stata.com/bookstore/ea.html":{it:Econometric Analysis}. 8th ed.}
New York: Pearson.
