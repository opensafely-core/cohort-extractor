{smcl}
{* *! version 1.5.6  17feb2020}{...}
{viewerdialog gmm "dialog gmm"}{...}
{vieweralsosee "[R] gmm" "mansection R gmm"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] gmm postestimation" "help gmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ivregress" "help ivregress"}{...}
{vieweralsosee "[R] ml" "help ml"}{...}
{vieweralsosee "[R] mlexp" "help mlexp"}{...}
{vieweralsosee "[R] nl" "help nl"}{...}
{vieweralsosee "[R] nlsur" "help nlsur"}{...}
{vieweralsosee "[XT] xtabond" "help xtabond"}{...}
{vieweralsosee "[XT] xtdpd" "help xtdpd"}{...}
{vieweralsosee "[XT] xtdpdsys" "help xtdpdsys"}{...}
{viewerjumpto "Syntax" "gmm##syntax"}{...}
{viewerjumpto "Menu" "gmm##menu"}{...}
{viewerjumpto "Description" "gmm##description"}{...}
{viewerjumpto "Links to PDF documentation" "gmm##linkspdf"}{...}
{viewerjumpto "Options" "gmm##options"}{...}
{viewerjumpto "Remarks" "gmm##remarks"}{...}
{viewerjumpto "Examples" "gmm##examples"}{...}
{viewerjumpto "Stored results" "gmm##results"}{...}
{viewerjumpto "References" "gmm##references"}{...}
{p2colset 1 12 14 2}{...}
{p2col:{bf:[R] gmm} {hline 2}}Generalized method of moments estimation{p_end}
{p2col:}({mansection R gmm:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Interactive version
    
{p 8 11 2}
{cmd:gmm} {cmd:(}[{it:reqname1}{cmd::}]{it:rexp_1}{cmd:)} 
          {cmd:(}[{it:reqname2}{cmd::}]{it:rexp_2}{cmd:)} 
   ...
   {ifin}
   [{it:{help gmm##weight:weight}}]
   [{cmd:,} {it:{help gmm##options_table:options}}]


{phang}
Moment-evaluator program version
    
{p 8 23 2}
{cmd:gmm} {it:moment_prog} {ifin}
   [{it:{help gmm##weight:weight}}]{cmd:,}
   {c -(}{opt eq:uations(namelist)}{c |}{opt neq:uations(#)}{c )-}
   {c -(}{opt param:eters(namelist)}{c |}{opt nparam:eters(#)}{c )-}
   [{it:{help gmm##options_table:options}}]
   [{it:{help gmm##program_options:program_options}}]


{phang}
{it:reqname_j} is the {it:j}th residual equation name,{p_end}
{phang}
{it:rexp_j} is the substitutable expression for the {it:j}th residual equation,
and{p_end}
{phang}
{it:moment_prog} is a moment-evaluator program.


{synoptset 28 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opt deriv:ative}{cmd:(}[{it:reqname}{c |}{it:#}]{cmd:/}{it:name} {cmd:=} {it:dexp_jk}{cmd:)}}{p_end}
{synopt : }specify derivative of {it:reqname} (or {it:#}) with respect to
parameter {it:name}; can be specified more than once (interactive version only){p_end}
{p2coldent :* {opt two:step}}use two-step GMM estimator; the default{p_end}
{p2coldent :* {opt one:step}}use one-step GMM estimator{p_end}
{p2coldent :* {opt i:gmm}}use iterative GMM estimator{p_end}
{synopt :{opth va:riables(varlist)}}specify variables in model{p_end}
{synopt :{opt nocommonesample}}do not restrict estimation sample to be the same for all equations{p_end}

{syntab :Instruments}
{synopt :{opt inst:ruments}{cmd:(}[{it:reqlist}{cmd::}]{varlist}[{cmd:,} {cmdab:nocons:tant}]{cmd:)}}{p_end}
{synopt : }specify instruments; can be specified more than once{p_end}
{synopt :{opt xtinst:ruments}{cmd:(}[{it:reqlist}{cmd::}]{varlist}{cmd:, lags(}{it:#_1}{cmd:/}{it:#_2}{cmd:))}}{p_end}
{synopt :}specify panel-style instruments; can be specified more than once{p_end}

{syntab :Weight matrix}
{synopt :{opt wmat:rix}{cmd:(}{it:wmtype}[{cmd:, }{opt indep:endent}]{cmd:)}}{p_end}
{synopt :}specify weight matrix; {it:wmtype} may be {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt hac} {help gmm##kernel:{it:kernel}} [{it:lags}], or {opt un:adjusted}{p_end}
{synopt :{opt c:enter}}center moments in weight-matrix computation{p_end}
{synopt :{opt winit:ial}{cmd:(}{it:iwtype}[{cmd:, }{opt indep:endent}]{cmd:)}}{p_end}
{synopt :}specify initial weight matrix; {it:iwtype} may be {opt un:adjusted}, {opt i:dentity}, {cmd:xt} {help gmm##xtspec:{it:xtspec}}, or the name of a
Stata matrix{p_end}

{syntab :SE/Robust}
{synopt :{cmd:vce(}{it:{help gmm##vcetype:vcetype}}[{cmd:, }{opt indep:endent}]{cmd:)}}{it:vcetype}
     may be {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap},
     {opt jack:knife}, {opt hac} {it:{help gmm##kernel:kernel}} {it:lags}, or
     {opt un:adjusted}{p_end}
{synopt :{opt quickd:erivatives}}use alternative method of computing numerical
     derivatives for VCE{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opth title:(strings:string)}}display {it:string} as title above the table of parameter estimates{p_end}
{synopt :{opth title2:(strings:string)}}display {it:string} as subtitle{p_end}
{synopt :{it:{help gmm##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Optimization}
{synopt :{opt from(initial_values)}}specify initial values for parameters{p_end}
{p2coldent :# {opt igmmit:erate(#)}}specify maximum number of iterations for iterated GMM estimator{p_end}
{p2coldent :# {opt igmmeps(#)}}specify # for iterated GMM parameter convergence criterion; default is {cmd:igmmeps(1e-6)}{p_end}
{p2coldent :# {opt igmmweps(#)}}specify # for iterated GMM weight-matrix convergence criterion; default is {cmd:igmmweps(1e-6)}{p_end}
{synopt :{it:{help gmm##optimization_options:optimization_options}}}control the optimization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}* You can specify at most one of these options.{p_end}
{p 4 6 2}# These options may be specified only when {opt igmm} is specified.{p_end}

{marker program_options}{...}
{synoptset 27 tabbed}
{synopthdr:program_options}
{synoptline}
{syntab :Model}
{synopt :{it:evaluator_options}}additional options to be passed to the moment-evaluator program{p_end}
{p2coldent :+ {opt hasd:erivatives}}moment-evaluator program can calculate parameter-level derivatives{p_end}
{p2coldent :+ {opt haslfd:erivatives}}moment-evaluator program can calculate linear-form derivatives{p_end}
{p2coldent :* {opt eq:uations(namelist)}}specify residual equation names{p_end}
{p2coldent :* {opt neq:uations(#)}}specify number of residual equations{p_end}
{p2coldent :# {opt param:eters(namelist)}}specify parameter names{p_end}
{p2coldent :# {opt nparam:eters(#)}}specify number of parameters{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}+ You may not specify both {opt hasderivatives} and 
{opt haslfderivatives}.{p_end}
{p 4 6 2}* You must specify {opt equations(namelist)} or {opt nequations(#)};
  you may specify both.{p_end}
{p 4 6 2}# You must specify {opt parameters(namelist)} or
  {opt nparameters(#)}; you may specify both.{p_end}


{p 4 6 2}{it:rexp_j} and {it:dexp_jk} may contain factor variables and
time-series operators; see {help fvvarlist} and {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:rolling}, 
and {cmd:statsby} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:aweight}s, {cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s
are allowed; see {help weight}.{p_end}
{p 4 6 2}{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp gmm_postestimation R:gmm postestimation} for
features available after estimation.

{pstd}
{it:rexp_j} and {it:dexp_jk} are substitutable expressions, that is, Stata
expressions that also contain parameters to be estimated.  The parameters are
enclosed in curly braces and must satisfy the naming requirements for
variables; {cmd:{c -(}beta{c )-}} is an example of a parameter.  The notation
{cmd:{c -(}}{it:lcname}:{it:varlist}{cmd:{c )-}} is allowed for linear
combinations of multiple covariates and their parameters.  For example,
{cmd:{c -(}xb:} {cmd:mpg} {cmd:price} {cmd:turn} {cmd:_cons}{cmd:{c )-}} defines a
linear combination of the variables {cmd:mpg}, {cmd:price}, {cmd:turn}, and
{cmd:_cons} (the constant term).  See
{mansection R gmmRemarksandexamplesSubstitutableexpressions:{it:Substitutable expressions}} under {it:Remarks and examples} of {bf:[R] gmm}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Endogenous covariates > Generalized method of moments estimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:gmm} performs generalized method of moments (GMM) estimation.  With 
the interactive version of the command, you enter the residual equation
for each moment condition directly into the dialog box or on the command line
by using substitutable expressions.  The moment-evaluator program version gives
you greater flexibility in exchange for increased complexity; with this
version, you write a program in an ado-file that calculates the moments based
on a vector of parameters passed to it.

{pstd}
{cmd:gmm} can fit both single- and multiple-equation models.  It allows
moment conditions of the form E{{bf:z}_i u_i({bf:b})} = {bf:0}, where
{bf:z}_i is a vector of instruments, and u_i({bf:b}) is an error term, as well
as more general moment conditions of the form E{{bf:h}_i({bf:z}_i;{bf:b})} =
{bf:0}.  {cmd:gmm} works with cross-sectional, time-series, and longitudinal
(panel) data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R gmmRemarksandexamples:Remarks and examples}

        {mansection R gmmMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:derivative(}[{it:reqname}{c |}{it:#}]{cmd:/}{it:name} {cmd: =} {it:dexp_jk}{cmd:)}
specifies the derivative of residual equation {it:reqname} or {it:#} with 
respect to parameter {it:name}.  If {it:reqname} or {it:#} is not 
specified, {cmd:gmm} assumes that the derivative applies to the first residual
equation.

{pmore}
For a moment condition of the form E{{bf:z}_ji u_ji({bf:b})} = {bf:0}, 
{cmd:derivative(}{it:j}{cmd:/}{it:b_k} {cmd:=} {it:dexp_jk}{cmd:)}
is to contain a substitutable expression for {it:du_ji / db_k}.  If you
specified {cmd:m} as the {it:reqname}, then for a moment condition of
the form E{{bf:z}_mi u_mi({bf:b})} = 0, you can specify 
{cmd:derivative(m/}{it:b_k} {cmd:=} {it:dexp_mk}{cmd:)}, where
{it:m} is the index of {cmd:m}.

{pmore}
{it:dexp_jk} uses the same substitutable expression syntax as is used to 
specify residual equations.  If you declare a linear combination in a 
residual equation, you provide the derivative for the linear combination; 
{cmd:gmm} then applies the chain rule for you.  See 
{help gmm##lcderiv:example 4} below.

{pmore}
If you do not specify the {opt derivative()} option, {cmd:gmm} calculates 
derivatives numerically.  You must either specify no derivatives or 
specify a derivative for each of the {it:k} parameters that appears in each
of the {it:j} residual equations unless the derivative is identically zero.
You cannot specify some analytic derivatives and have {cmd:gmm} compute the
rest numerically.

{phang}
{opt twostep}, {opt onestep}, and {opt igmm} specify which estimator is 
to be used.  You can specify at most one of these options.  
{opt twostep} is the default.

{pmore}
{opt twostep} requests the two-step GMM estimator.  {cmd:gmm} obtains 
parameter estimates based on the initial weight matrix, computes a new 
weight matrix based on those estimates, and then reestimates the parameters 
based on that weight matrix.

{pmore}
{opt onestep} requests the one-step GMM estimator.  The parameters are 
estimated based on an initial weight matrix, and no updating of the 
weight matrix is performed except when calculating the appropriate 
variance-covariance (VCE) matrix.

{pmore}
{opt igmm} requests the iterative GMM estimator.  {cmd:gmm} obtains 
parameter estimates based on the initial weight matrix, computes a new 
weight matrix based on those estimates, reestimates the parameters based 
on that weight matrix, computes a new weight matrix, and so on, to convergence.
Convergence is declared when the relative change in the parameter vector is
less than {opt igmmeps()}, the relative change in the weight matrix is less
than {opt igmmweps()}, or {opt igmmiterate()} iterations have been completed.  
{help gmm##H2005:Hall (2005, sec. 2.4 and 3.6)} mentions that there may be
gains to finite-sample efficiency from using the iterative estimator.

{phang}
{opth variables(varlist)} specifies the variables in the model.
{opt gmm} ignores observations for which any of these variables has a
missing value. If you do not specify {cmd:variables()}, then {cmd:gmm}
assumes all the observations are valid and issues an error message
if any residual equations evaluate to missing for any observations at the
initial value of the parameter vector.

{phang}
{opt nocommonesample} requests that {cmd:gmm} not restrict the 
estimation sample to be the same for all equations.  By default, 
{cmd:gmm} will restrict the estimation sample to observations that are 
available for all equations in the model, mirroring the behavior of 
other multiple-equation estimators such as {cmd:nlsur}, {cmd:sureg}, or
{cmd:reg3}.  For certain models, however, different equations can have 
different numbers of observations.  For these models, you should specify 
{opt nocommonesample}.  See the {help gmm##dynpan:dynamic panel-data} 
examples for one type of model where this option is needed.  You cannot
specify weights if you specify {opt nocommonesample}.

{dlgtab:Instruments}

{phang}
{opt instruments}{cmd:(}[{it:reqlist}{cmd::}] 
{varlist}[{cmd:, }{opt noconstant}]{cmd:)} specifies a list of 
instrumental variables to be used.  If you specify a single residual
equation, then you do not need to specify the equations to which the
instruments apply; you can omit the {it:reqlist} and simply specify
{cmd:instruments(}{it:varlist}{cmd:)}.  By default, a constant term is included
in {it:varlist}; to omit the constant term, use the {cmd:noconstant}
suboption: {cmd:instruments(}{it:varlist}{cmd:, noconstant)}.

{pmore}
If your model has multiple moment conditions of the form 

{pmore2}{space 1}{ {bf:z}1_i u1({bf:b})_i }{p_end}
{pmore2}E{ ............ } = {bf:0}{p_end}
{pmore2}{space 1}{ {bf:z}q_i uq({bf:b})_i }{p_end}

{pmore}
then you can specify multiple corresponding residual equations.  Then, specify
the {it:reqname} or an {it:reqlist} to indicate the residual equations for
which the list of variables is to be used as instruments if you do not want
that list applied to all the residual equations.  For example, you might type

{phang3}{cmd:gmm (main:} {it:rexp_1}{cmd:) (}{it:rexp_2}{cmd:)}
         {cmd:(}{it:rexp_3}{cmd:), instruments(z1 z2)}
         {cmd:instruments(2: z3) instruments(main 3: z4)}

{pmore}
Variables {cmd:z1} and {cmd:z2} will be used as instruments for all 
three equations, {cmd:z3} will be used as an instrument for the second 
equation, and {cmd:z4} will be used as an instrument for the first and 
third equations.  Notice that we chose to supply a name for the first residual
equation but not the second two, identifying each by its equation number.

{pmore}
{it:varlist} may contain factor variables and time-series operators; see
{help fvvarlist} and {help tsvarlist}, respectively.

{phang}
{opt xtinstruments}{cmd:(}[{it:reqlist}{cmd::}] 
{varlist}{cmd:, lags(}{it:#_1}{cmd:/}{it:#_2}{cmd:))} is for use with 
panel-data models in which the set of available instruments depends on 
the time period.  As with {opt instruments()}, you can prefix the list
of variables with residual equation names or numbers to target instruments to
specific equations.  Unlike with {opt instruments()}, a constant term is not
included in {it:varlist}.  You must {cmd:xtset} your data before using this
option; see {helpb xtset}.

{pmore}
If you specify

{pmore2}
{cmd:gmm} ...{cmd:, xtinstruments(x, lags(1/.))} ...

{pmore}
then for panel {it:i} and period {it:t}, {cmd:gmm} uses
{it:x_(i,t-1)}, {it:x_(i,t-2)}, ..., {it:x_i1} as instruments.  More
generally, specifying
{cmd:xtinstruments(x, lags(}{it:#_1}{cmd:,}{it:#_2}{cmd:))} uses
{it:x_(i,t-#_1)}, ..., {it:x_(i,t-#_2)} as instruments; setting
{it:#_2} = {cmd:.} requests all available lags.
{it:#_1} and {it:#_2} must be zero or positive integers.

{pmore}
{cmd:gmm} automatically excludes observations for which no valid
instruments are available. It does, however, include observations for
which only a subset of the lags is available.  For example, if you
request that lags one through three be used, then {cmd:gmm} will include the
observations for the second and third time periods even though fewer
than three lags are available as instruments.

{dlgtab:Weight matrix}

{marker wmatrix}{...}
{phang}
{opt wmatrix}{cmd:(}{it:wmtype}[{cmd:,} {opt independent}]{cmd:)} 
specifies the type of weight matrix to be used in conjunction with the 
two-step and iterated GMM estimators.

{pmore}
Specifying {cmd:wmatrix(robust)} requests a weight matrix that is 
appropriate when the errors are independent but not necessarily 
identically distributed.  {cmd:wmatrix(robust)} is the default.

{pmore}
Specifying {cmd:wmatrix(cluster} {it:clustvar}{cmd:)} requests a 
weight matrix that accounts for arbitrary correlation among 
observations within clusters identified by {it:clustvar}.

{marker kernel}{...}
{pmore}
Specifying {cmd:wmatrix(hac} {it:kernel} {it:#}{cmd:)} requests a
heteroskedasticity- and autocorrelation-consistent (HAC) weight
matrix using the specified kernel (see below) with {it:#} lags.  The
bandwidth of a kernel is equal to the number of lags plus one.

{pmore}
Specifying {cmd:wmatrix(hac} {it:kernel} {cmd:opt} [{it:#}]{cmd:)} requests an
HAC weight matrix using the specified kernel, and the lag order is selected
using Newey and West's ({help gmm##NW1994:1994}) optimal lag-selection
algorithm.  {it:#} is an optional tuning parameter that affects the lag order
selected; see the
{mansection R gmmMethodsandformulaswmatrixopt:discussion}
in {bf:[R] gmm}.

{pmore}
Specifying {cmd:wmatrix(hac} {it:kernel}{cmd:)} requests an HAC 
weight matrix using the specified kernel and {it:N}-2 lags, 
where {it:N} is the sample size.

{pmore}
There are three kernels available for HAC weight matrices, and you 
can request each one by using the name used by statisticians or the 
name perhaps more familiar to economists:

{p 12 16 4}
{opt ba:rtlett} or {opt nw:est} requests the Bartlett (Newey-West) kernel;

{p 12 16 4}
{opt pa:rzen} or {opt ga:llant} requests the Parzen (Gallant) kernel; and

{p 12 16 4}
{opt qu:adraticspectral} or {opt an:drews} requests the quadratic 
spectral (Andrews) kernel.

{pmore}
Specifying {cmd:wmatrix(unadjusted)} requests a weight matrix that is 
suitable when the errors are homoskedastic.  In some applications, the 
GMM estimator so constructed is known as the (nonlinear) two-stage 
least-squares (2SLS) estimator.

{pmore}
Including the {cmd:independent} suboption creates a weight matrix that 
assumes moment conditions are independent.  This suboption is often used to 
replicate other models that can be motivated outside the GMM framework, 
such as the estimation of a system of equations by system-wide 2SLS.  
This suboption has no effect if only one residual equation is specified.

{pmore}
{opt wmatrix()} has no effect if {cmd:onestep} is also specified.

{phang}
{opt center} requests that the sample moments be centered (demeaned) 
when computing GMM weight matrices.  By default, centering is not done.

{phang}
{opt winitial}{cmd:(}{it:iwtype}[{cmd:,} {opt independent}]{cmd:)} 
specifies the weight matrix to use to obtain the first-step parameter
estimates.

{pmore}
Specifying {cmd:winitial(unadjusted)} requests a weight matrix that 
assumes the moment conditions are independent and identically 
distributed.  This matrix is of the form ({bf:Z}'{bf:Z})^-1, where {bf:Z}
represents all the instruments specified in the {cmd:instruments()} option.
To avoid a singular weight matrix, you should specify at least q-1 moment
conditions of the form E{{bf:z}_hi u_hi({bf:b})} = {bf:0}, where q is the
number of moment conditions, or you should specify the {cmd:independent}
suboption.

{pmore}
Including the {opt independent} suboption creates a weight matrix that 
assumes moment conditions are independent.  Elements of the weight matrix 
corresponding to covariances between two moment conditions are set equal 
to zero.  This suboption has no effect if only one residual equation is 
specified.

{pmore}
{cmd:winitial(unadjusted)} is the default.

{pmore}
{cmd:winitial(identity)} requests that the identity matrix be used.

{marker xtspec}{...}
{pmore}
{cmd:winitial(xt} {it:xtspec}{cmd:)} is for use with dynamic panel-data 
models in which one of the residual equations is specified in first-differences
form.  {it:xtspec} is a string consisting of the letters "L" and "D", 
the length of which is equal to the number of residual equations in the 
model.  You specify "L" for a residual equation if that residual equation 
is written in levels, and you specify "D" for a residual equation if it 
is written in first differences; {it:xtspec} is not case sensitive.  
When you specify this option, you can specify at most one residual 
equation in levels and one residual equation in first differences.
See the {help gmm##dynpan:dynamic panel-data} examples below.

{pmore}
{opt winitial(matname)} requests that Stata matrix {it:matname} be used.  
You cannot specify the {opt independent} suboption if you specify 
{opt winitial(matname)}.

{dlgtab:SE/Robust}

{marker vcetype}{...}
{phang}
{cmd:vce(}{it:vcetype} [{cmd:, independent}]{cmd:)} specifies the type 
of standard error reported, which includes types that are robust to some 
kinds of misspecification ({cmd:robust}), that allow for intragroup
correlation ({cmd:cluster} {it:clustvar}), and that use bootstrap or jackknife
methods ({cmd:bootstrap}, {cmd:jackknife}); see
{helpb vce_option:[R] {it:vce_option}}.

{pmore}
{cmd:vce(unadjusted)} specifies that an unadjusted (nonrobust) VCE 
matrix be used; this, along with the {opt twostep} option, results in the 
"optimal two-step GMM" estimates often discussed in textbooks.

{pmore}
The default {it:vcetype} is based on the {it:wmtype} specified in the 
{opt wmatrix()} option.  If {opt wmatrix()} is specified 
but {opt vce()} is not, then {it:vcetype} is set equal to {it:wmtype}.  
To override this behavior and obtain an unadjusted (nonrobust) VCE 
matrix, specify {cmd:vce(unadjusted)}.

{pmore}
Specifying {cmd:vce(bootstrap)} or {cmd:vce(jackknife)} results in
standard errors based on the bootstrap or jackknife, respectively.  See
{manhelpi vce_option R}, {manhelp bootstrap R}, and {manhelp jackknife R} for
more information on these VCEs.

{pmore}
The syntax for {it:vcetype}s other than {cmd:bootstrap} and {cmd:jackknife}
is identical to those for {helpb gmm##wmatrix:wmatrix()}.

{phang}
{opt quickderivatives} requests that an alternative method be used to compute
the numerical derivatives for the VCE.  This option has no effect if you
specify the {opt derivatives()}, {opt hasderivatives}, or 
{opt haslfderivatives} option.

{pmore}
The VCE depends on a matrix of partial derivatives that {cmd:gmm} must compute
numerically unless you supply analytic derivatives.  This Jacobian matrix will
be especially large if your model has many instruments, residual equations, or
parameters.

{pmore}
By default, {cmd:gmm} computes each element of the Jacobian matrix
individually, searching for an optimal step size each time.  Although this
procedure results in accurate derivatives, it is computationally taxing:
{cmd:gmm} may have to evaluate the moments of your model five or more times
for each element of the Jacobian matrix.

{pmore}
When you specify the {opt quickderivatives} option, {cmd:gmm} computes all 
derivatives corresponding to a parameter at once, using a fixed step size
proportional to the parameter's value.  This method requires just two 
evaluations of the model's moments to compute an entire column of the 
Jacobian matrix and therefore has the most impact when you specify many
instruments or residual equations.

{pmore}
Most of the time, the two methods produce virtually identical results, but 
the {opt quickderivatives} method may fail if a residual equation is highly
nonlinear or if instruments differ by orders of magnitude.  In the rare case
where you specify {opt quickderivatives} and obtain suspiciously large or 
small standard errors, try refitting your model without this option.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opth title:(strings:string)} specifies an optional title that will be
displayed just above the table of parameter estimates.

{phang}
{opth title2:(strings:string)} specifies an optional subtitle that will be
displayed between the title specified in {opt title()} and the table of
parameter estimates.  If {opt title2()} is specified but {opt title()} is not,
{opt title2()} has the same effect as {opt title()}.

INCLUDE help displayopts_list

{dlgtab:Optimization}

{phang}
{opt from(initial_values)} specifies the initial values to begin the
estimation.  You can specify a parameter name, its initial value, another
parameter name, its initial value, and so on, or you can specify a 1 x k
matrix, where k is the number of parameters in the model.  For example, to
initialize {opt alpha} to 1.23 and {opt delta} to 4.57, you would type

{pmore2}
{cmd:gmm} ...{cmd:,} {cmd:from(alpha 1.23 delta 4.57)} ...

{pmore}
or equivalently

{pmore2}
{cmd:matrix} {cmd:define} {cmd:initval} {cmd:=} {cmd:(1.23, 4.57)}{break}
{cmd:gmm} ...{cmd:,} {cmd:from(initval)} ...

{pmore}
Initial values declared in the {cmd:from()} option override any that are
declared within substitutable expressions.  If you specify a parameter that
does not appear in your model, {cmd:gmm} exits with an error message.  If you
specify a matrix, the values must be in the same order in which the parameters
are declared in your model.

{phang}
{opt igmmiterate(#)}, {opt igmmeps(#)}, and
{opt igmmweps(#)} control the iterative process for the
iterative GMM estimator.  These options can be specified only if
you also specify {cmd:igmm}.

{phang2}
{opt igmmiterate(#)} specifies the maximum number of iterations to 
perform with the iterative GMM estimator.  The default is the number set 
using {helpb set maxiter}, which is
INCLUDE help maxiter
by default.

{phang2}
{opt igmmeps(#)} specifies the convergence criterion used for successive
parameter estimates when the iterative GMM estimator is used.
The default is {cmd:igmmeps(1e-6)}.  Convergence is declared when the 
relative difference between successive parameter estimates is less than 
{cmd:igmmeps()} and the relative difference between successive estimates of 
the weight matrix is less than {cmd:igmmweps()}.

{phang2}
{opt igmmweps(#)} specifies the convergence criterion used for successive 
estimates of the weight matrix when the iterative GMM estimator
is used.  The default is {cmd:igmmweps(1e-6)}.  Convergence is declared when
the relative difference between successive parameter estimates is less than
{cmd:igmmeps()} and the relative difference between successive estimates of the
weight matrix is less than {cmd:igmmweps()}.

{marker optimization_options}{...}
{phang}
{it:optimization_options}: {opt tech:nique()}, 
{opt conv_maxiter()}, {opt conv_ptol()}, {opt conv_vtol()}, 
{opt conv_nrtol()}, {opt tracelevel()}.  {opt technique()} specifies 
the optimization technique to use; {cmd:gn} (the default), {cmd:nr}, {cmd:dfp}, 
and {cmd:bfgs} are allowed.  {opt conv_maxiter()} 
specifies the maximum number of iterations; {opt conv_ptol()}, 
{opt conv_vtol()}, and {opt conv_nrtol()} specify the convergence 
criteria for the parameters, gradient, and scaled Hessian, 
respectively.  {opt tracelevel()} allows you to obtain additional 
details during the iterative process.  
See {helpb mf_optimize:[M-5] optimize()}.


{pstd}
The following options pertain only to the moment-evaluator program 
version of {cmd:gmm}:

{dlgtab:Model}

{phang}
{it:evaluator_options} refer to any options allowed by your {it:moment_prog}. 

{phang}
{opt hasderivatives} and {opt haslfderivatives} indicate that you have written
your moment-evaluator program to compute derivatives.  You may specify one or
the other but not both.  If you do not specify either of these options,
{cmd:gmm} computes the derivatives numerically.

{pmore}
{opt hasderivatives} indicates that your moment-evaluator program computes
parameter-level derivatives.

{pmore}
{opt haslfderivatives} indicates that your moment-evaluator program computes
equation-level derivatives and is useful only when you specify the parameters
of your model using the {cmd:{c -(}}{it:lcname}{cmd::}{it:varlist}{cmd:{c )-}}
syntax of the {opt parameters()} option.

{pmore}
See {mansection R gmmRemarksandexamplesdetailsofmoment:{it:Details of moment-evaluator programs}} in
{bf:[R] gmm} for more information.

{phang}
{opt equations(namelist)} specifies the names of the residual equations 
in the model.  If you specify both {opt equations()} and 
{opt nequations()}, the number of names in the former must match the number 
specified in the latter.

{phang}
{opt nequations(#)} specifies the number of residual equations in the 
model.  If you do not specify names with the {opt equations()} option, 
{cmd:gmm} numbers the residual equations 1, 2, 3, ....  If you specify both 
{opt equations()} and {opt nequations()}, the number of names in the 
former must match the number specified in the latter.

{phang}
{opt parameters(namelist)} specifies the names of the parameters in the
model. The names of the parameters must comply with the naming
conventions of Stata's variables; see {findalias frnames}.

{pmore}
Alternatively, you can use parameter equation notation to specify linear
combinations of parameters.  Each linear combination is of the form
{cmd:{c -(}}{it:lcname}{cmd::}{it:varlist}{cmd:{c )-}}, where {it:varlist}
is one or more variable names. Specify the {help _variables:system variable}
{cmd:_cons} in {it:varlist} to include a constant term.  Distinguish between
{cmd:{c -(}}{it:lcname}{cmd::}{it:varlist}{cmd:{c )-}}, in which {it:lcname}
identifies the linear combination, and
{cmd:(}{it:reqname}{cmd::}{it:rex}{cmd:)}, in which {it:reqname} identifies the
residual equation.  When you use linear-combination syntax, {cmd:gmm} prepends
each element of the parameter vector passed to your evaluator program with
{it:lcname}{cmd::} to generate unique names.

{pmore}
If you specify both {opt parameters()} and {opt nparameters()}, the number of
names in the former must match the number specified in the latter. 

{phang}
{opt nparameters(#)} specifies the number of parameters in the model. 
If you do not specify names with the {opt parameters()} option,
{cmd:gmm} names them {cmd:b1}, {cmd:b2}, ..., {cmd:b}{it:#}.  If you
specify both {opt parameters()} and {opt nparameters()}, the number of
names in the former must match the number specified in the latter.

{pstd}
The following option is available with {opt gmm} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

            {help gmm##interactive:Interactive version}
            {help gmm##moment-eval:Moment-evaluator program version}
            {help gmm##substitute:Substitutable expressions}


{marker interactive}{...}
{title:Interactive version}

{pstd}
In many applications, the moment conditions can be written in the form

{pmore}
E{{bf:z}_i u_i({bf:b})} = {bf:0}

{pstd}
where {it:i} indexes observations, {bf:b} is a {it:p} x 1 vector of 
parameters, u({bf:b}) is a residual term, and {bf:z} represents a vector 
of one or more instrumental variables, {bf:z1}, {bf:z2}, ..., {bf:z}{it:q}.
Here you would type

{pmore}
{cmd:. gmm (}{it:<expression for u_i(}{bf:b}{it:)>}{cmd:), instruments(z1, z2, }...{cmd:, z}{it:q}{cmd:)}

{pstd} 
In other applications, we cannot write the moment conditions as the 
product of a residual and a list of instruments but instead have the 
more general moment conditions

{pmore}
E{{bf:h}_i({bf:b})} = {bf:0}

{pstd}
where {bf:h}({bf:b}) is a {it:q} x 1 vector-valued function.  Here you 
would type

{pmore}{cmd:. gmm (}{it:<expression for h_1i(}{bf:b}{it:)>}{cmd:)} {cmd:(}{it:<expression for h_2i(}{bf:b}{it:)>}{cmd:)} ...   {p_end}
{pmore}{space 6}{cmd:(}{it:<expression for h_qi(}{bf:b}{it:)>}{cmd:)} 

{pstd}
where h_1i({bf:b}) is the first element of {bf:h}({bf:b}), and so on.

{pstd}
In yet other applications, your moment conditions might be of the form

{pmore}{space 1}{ {bf:z}_1i u_1i({bf:b}) }{p_end}
{pmore}E{ ............ } = {bf:0}{p_end}
{pmore}{space 1}{ {bf:z}_qi u_qi({bf:b}) }{p_end}

{pstd}
where {bf:z}_1i is a vector of instrumental variables {bf:z11}, {bf:z12}, ..., 
{bf:z1}q1, associated with the first residual term, u_1i({bf:b}), and so on.  
Here you would type

{pmore}{cmd:. gmm (}{it:<expression for u_1i(}{bf:b}{it:)>}{cmd:)}{p_end}
{pmore}{space 6}{cmd:(}{it:<expression for u_2i(}{bf:b}{it:)>}{cmd:)} ...{p_end}
{pmore}{space 6}{cmd:(}{it:<expression for u_qi(}{bf:b}{it:)>}{cmd:)}{cmd:,}{p_end}
{pmore}{space 6}{cmd:instruments(1: z11 z12} ... {cmd:z1}{it:q1}{cmd:)}{p_end}
{pmore}{space 6}{cmd:instruments(2: z21 z22} ... {cmd:z2}{it:q2}{cmd:)} ...{p_end}
{pmore}{space 6}{cmd:instruments(3: z31 z32} ... {cmd:z3}{it:q3}{cmd:)}{p_end}

{pstd}
Of course, you can also combine moment conditions of the forms 
E{{bf:h}_i({bf:b})} = {bf:0} and E{{bf:z}_ki u_ki({bf:b})} = 
{bf:0}.


{marker moment-eval}{...}
{title:Moment-evaluator program version}

{pstd}
Instead of defining the moment equations in the dialog box or on the 
command line, you can write a program that evaluates them
similarly to how {cmd:ml} and the function-evaluator program 
version of {cmd:nl} work.  We illustrate the mechanics of a moment-evaluator
program through a simple example.  Suppose we wish to fit the model

{pmore}
y_i = {bf:x}_i'{bf:b} + u_i

{pstd}
where we suspect that some elements of {bf:x} are endogenous.  We have 
as instruments the vector {bf:z}, consisting of the elements of {bf:x} 
that are exogenous and additional variables not correlated with 
u_i.  In a GMM framework, we can write our moment conditions as

{pmore}
E{{bf:z}_i u_i({bf:b})} = E{{bf:z}_i(y_i - {bf:x}_i'{bf:b})} = 0

{pstd}
Our first attempt at a moment-evaluator program is

{pmore}{cmd:program gmm_ivreg}{p_end}

{pmore}{space 4}{cmd:version {ccl stata_version}}{p_end}

{pmore}{space 4}{cmd:syntax varlist [if] , at(name) rhs(varlist) depvar(varlist)}{p_end}

{pmore}{space 4}{cmd:tempvar m}{p_end}
{pmore}{space 4}{cmd:quietly gen double `m' = 0 `if'}{p_end}
{pmore}{space 4}{cmd:local i 1}{p_end}
{pmore}{space 4}{cmd:foreach var of varlist `rhs' {c -(}}{p_end}
{pmore}{space 8}{cmd:quietly replace `m' = `m' + `var'*`at'[1,`i'] `if'}{p_end}
{pmore}{space 8}{cmd:local `++i'}{p_end}
{pmore}{space 4}{cmd:{c )-}}{p_end}
{pmore}{space 4}{cmd:quietly replace `m' = `m' + `at'[1,`i'] `if'{space 4}// constant}{p_end}

{pmore}{space 4}{cmd:quietly replace `varlist' = `depvar' - `m' `if'}{p_end}

{pmore}{cmd:end}{p_end}

{pstd}
Say that our dependent variable, y_i, is {cmd:mpg}; {bf:x} consists of
{cmd:gear_ratio}, {cmd:turn}, and a constant; and {bf:z} consists of
{cmd:gear_ratio}, {cmd:length}, {cmd:headroom}, and a constant.  Then, to fit
our model, we would type

{pmore}{cmd:. gmm gmm_ivreg, nequations(1) nparameters(3) }{p_end}
{pmore}{space 6}{cmd:instruments(gear_ratio length headroom)} {cmd:depvar(mpg)}{p_end}
{pmore}{space 6}{cmd:rhs(gear_ratio turn)}{p_end}

{pstd}
First, notice that {opt depvar()} and {opt rhs()} are not options that 
the {cmd:gmm} command recognizes.  Therefore, {cmd:gmm} will pass those 
options to our moment-evaluator program.

{pstd}
Our moment-evaluator program accepts a {it:varlist}.  {cmd:gmm} will pass to 
our program {it:q} variables in this {it:varlist}, where {it:q} is the number 
of moment equations specified in the {opt nequations()} or 
{opt equations()} option.  Because, in our command, we specified 
{cmd:nequations(1)}, the {it:varlist} will contain one variable, which we are
to fill in with our single moment equation u_i({bf:b}) = y_i - {bf:x}_i'{bf:b}.

{pstd}
The parameter vector at which we are to evaluate our moments is passed 
in the required {opt at()} option; all moment-evaluator programs must 
accept this option.  In our calling command, we specified
{cmd:nparameters(3)}, so the {cmd:`at'} vector passed to our program 
will be 1 x 3.

{pstd}
We wrote our moment-evaluator program to also accept the 
{opt depvar()} and {opt rhs()} options.  That way, we can fit other regression 
models with endogenous regressors simply by changing the variables we 
specify in those options and the {opt instruments()} option.  Unlike commands
such as {cmd:ivregress} designed specifically for linear regression with
endogenous regressors, with {cmd:gmm} we must specify the complete instrument
list, including exogenous regressors, in the {opt instruments()} option.

{pstd}
Our program also accepts an {opt if} condition because  that is how {cmd:gmm} 
communicates the estimation sample.  For all the commands that operate 
on variables, we include the expression {cmd:`if'} to restrict their 
operations to the estimation sample.

{pstd}
The method we just explained can be used to fit an arbitrary GMM model.  When
some of the moments are linear in the parameters, we can instead specify full
equation names in the {opt parameters()} option and use 
{helpb matrix_score:matrix score} to compute linear combinations of variables
rather than having to loop through each variable as in our previous program.
Thus we can write the moment-evaluator program for our example as follows:

{pmore}{cmd:program gmm_ivreg_2}{p_end}

{pmore}{space 4}{cmd:version {ccl stata_version}}{p_end}
	
{pmore}{space 4}{cmd:syntax varlist [if] , at(name) depvar(varlist)}{p_end}
	
{pmore}{space 4}{cmd:tempvar xb}{p_end}
{pmore}{space 4}{cmd:matrix score double `xb' = `at' `if', eq(#1)}{p_end}
	
{pmore}{space 4}{cmd:quietly replace `varlist' = `depvar' - `xb' `if'}{p_end}
	
{pmore}{cmd:end}{p_end}

{pstd}
Now, to fit our model, we type

{pmore}{cmd:. gmm gmm_ivreg_2, nequations(1) depvar(mpg)}{p_end}
{pmore}{space 6}{cmd:parameters({mpg:gear_ratio turn _cons})}{p_end}
{pmore}{space 6}{cmd:instruments(gear_ratio length headroom)}{p_end}

{pstd}
Because we specify full equation and variable names for each parameter, the
columns of the {cmd:`at'} vector passed to our program will be labeled so that
{cmd:matrix score} can compute the linear combination, and we no longer need
to include an option to pass the variable names into our program.  For
simplicity, we included an option to specify the dependent variable, but we
could have used Stata's {help macro} functions to obtain it from the
{cmd:`at'} vector as well.


{marker substitute}{...}
{title:Substitutable expressions}

{pstd}
You use substitutable expressions with the interactive and programmed 
substitutable-expression versions of {cmd:gmm} to define your system 
of equations.  Substitutable expressions are just like any other 
mathematical expression in Stata, except that the parameters of your 
model are bound in braces.

{pstd}
You specify a substitutable expression for each equation in your 
system, and you must follow three rules:

{phang2}
1.  Parameters of the model are bound in curly braces:
{cmd:{c -(}b0{c )-}}, {cmd:{c -(}param{c )-}}, etc.
Parameter names must follow the same conventions as variable names; see
{findalias frnames}.

{phang2}
2.  Initial values for parameters are given by including an equal sign and
the initial value inside the curly braces:  {cmd:{c -(}b0=1{c )-}}, 
{cmd: {c -(}param=3.571{c )-}}, etc. 

{pmore2}
You can also specify initial values by using the {cmd:from()} option.
Initial values specified in {cmd:from()} override whatever initial values are
given within the substitutable expression.  If you do not specify an initial
value for a parameter, it is initialized to 0.

{phang2}
3.  Linear combinations of variables can be included using the notation 
{cmd:{c -(}}{it:lc}{cmd::}{it:varlist}{cmd:{c )-}}:
{cmd:{c -(}}{cmd:xb: mpg price weight _cons}{c )-},
{cmd:{c -(}}{cmd:score: w x z}{cmd:{c )-}}, etc.
Parameters of linear combinations are initialized to 0.

{pstd}
Substitutable expressions can include any mathematical expression involving
scalars and variables.  See {help operator} and {help exp} for more
information on expressions.


{marker examples}{...}
{title:Examples}

{pstd}
Simple linear regression{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress mpg gear_ratio turn}{p_end}
{phang2}{cmd:. gmm (mpg - {b1}*gear_ratio - {b2}*turn - {b0}), instruments(gear_ratio turn)}{p_end}

{pstd}
Same as above, with analytic derivatives{p_end}
{phang2}{cmd:. gmm (mpg - {b1}*gear_ratio - {b2}*turn - {b0}), instruments(gear_ratio turn)}
         {cmd:derivative(/b1 = -1*gear_ratio) derivative(/b2 = -1*turn)}
         {cmd:derivative(/b0 = -1)}{p_end}

{pstd}
Simple linear regression, using a linear combination{p_end}
{phang2}{cmd:. gmm (mpg - {xb:gear_ratio turn} - {b0}), instruments(gear_ratio turn)}{p_end}

{pstd}
{marker lcderiv}
Same as above, with analytic derivatives{p_end}
{phang2}{cmd:. gmm (mpg - {xb:gear_ratio turn} - {b0}), instruments(gear_ratio turn)}
       {cmd:derivative(/xb = -1) derivative(/b0 = -1)}{p_end}

{pstd}
Two-stage least squares (same as {cmd:ivregress 2sls}){p_end}
{phang2}{cmd:. ivregress 2sls mpg gear_ratio (turn = weight length headroom)}{p_end}
{phang2}{cmd:. gmm (mpg - {b1}*turn - {b2}*gear_ratio - {b0}),}
            {cmd:instruments(gear_ratio weight length headroom) onestep}{p_end}

{pstd}
Two-step GMM estimation (same as {cmd:ivregress gmm}){p_end}
{phang2}{cmd:. ivregress gmm mpg gear_ratio (turn = weight length headroom)}{p_end}
{phang2}{cmd:. gmm (mpg - {b1}*turn - {b2}*gear_ratio - {b0}),}
            {cmd:instruments(gear_ratio weight length headroom)}
            {cmd:wmatrix(robust)}{p_end}

{marker example7}{...}
{pstd}
Estimation of the parameters of the gamma distribution
       ({help gmm##G2018:Greene 2018, 493}){p_end}
{phang2}{cmd:. webuse greenegamma}{p_end}
{phang2}{cmd:. gmm (y - {c -(}P{c )-}/{c -(}lambda{c )-})}{p_end}
{phang2}{space 4}{cmd:(y^2 - {c -(}P{c )-}*({c -(}P{c )-}+1)/{c -(}lambda{c )-}^2)}{p_end}
{phang2}{space 4}{cmd:(ln(y) - digamma({c -(}P{c )-}) + ln({c -(}lambda{c )-}))}{p_end}
{phang2}{space 4}{cmd:(1/y - {c -(}lambda{c )-}/({c -(}P{c )-}-1)),}{p_end}
{phang2}{space 4}{cmd:from(P 2.41 lambda 0.08) winitial(identity)}{p_end}

{pstd}
Same as above, with analytic derivatives{p_end}
{phang2}{cmd:. gmm (y - {c -(}P{c )-}/{c -(}lambda{c )-})}{p_end}
{phang2}{space 4}{cmd:(y^2 - {c -(}P{c )-}*({c -(}P{c )-}+1)/{c -(}lambda{c )-}^2)}{p_end}
{phang2}{space 4}{cmd:(ln(y) - digamma({c -(}P{c )-}) + ln({c -(}lambda{c )-}))}{p_end}
{phang2}{space 4}{cmd:(1/y - {c -(}lambda{c )-}/({c -(}P{c )-}-1)),}{p_end}
{phang2}{space 4}{cmd:from(P 2.41 lambda 0.08)}{p_end}
{phang2}{space 4}{cmd:winitial(identity)}{p_end}
{phang2}{space 4}{cmd:deriv(1/P = -1/{c -(}lambda{c )-})}{p_end}
{phang2}{space 4}{cmd:deriv(2/P = -(2*{c -(}P{c )-}+1)/{c -(}lambda{c )-}^2)}{p_end}
{phang2}{space 4}{cmd:deriv(3/P = -1*trigamma({c -(}P{c )-}))}{p_end}
{phang2}{space 4}{cmd:deriv(4/P = {c -(}lambda{c )-}/({c -(}P{c )-}-1)^2)}{p_end}
{phang2}{space 4}{cmd:deriv(1/lambda = {c -(}P{c )-}/{c -(}lambda{c )-}^2)}{p_end}
{phang2}{space 4}{cmd:deriv(2/lambda = 2*{c -(}P{c )-}*({c -(}P{c )-}+1)/{c -(}lambda{c )-}^3)}{p_end}
{phang2}{space 4}{cmd:deriv(3/lambda = 1/{c -(}lambda{c )-})}{p_end}
{phang2}{space 4}{cmd:deriv(4/lambda = -1/({c -(}P{c )-}-1))}{p_end}

{pstd}
Estimation of a consumption CAPM model with one financial asset, 
using first and second lags of consumption growth and two lags of 
returns as instruments ({help gmm##H1994:Hamilton 1994, sec. 14.2}){p_end}
{phang2}{cmd:. webuse cr}{p_end}
{phang2}{cmd:. generate clc = c / L.c}{p_end}
{phang2}{cmd:. generate lcllc = L.c / L2.c}{p_end}
{phang2}{cmd:. gmm (1 - {c -(}b=1{c )-}*(1+F.r)*(F.c/c)^(-1*{c -(}g{c )-})),}
             {cmd:inst(clc lcllc r L.r L2.r)}{p_end}

{pstd}
Exponential (Poisson) regression with endogenous regressor {cmd:income}{p_end}
{phang2}{cmd:. webuse docvisits, clear}{p_end}
{phang2}{cmd:. gmm (docvis - exp({xb:private chronic female income} + {b0})),}
                {cmd:instruments(private chronic female age black hispanic) onestep}
{p_end}

{pstd}
Same as above, specifying analytic derivatives and using the two-step estimator
{p_end}
{phang2}{cmd:. gmm (docvis - exp({xb:private chronic female income} + {b0})),}
             {cmd:instruments(private chronic female age black hispanic)}
             {cmd:deriv(/xb = -1*exp({xb:} + {b0}))}
             {cmd:deriv(/b0 = -1*exp({xb:} + {b0})) twostep}{p_end}

{pstd}
Using {cmd:gmm} to fit a maximum likelihood model (probit){p_end}
{phang2}{cmd:. webuse probitgmm}{p_end}
{phang2}{cmd:. global Phi "normal({b0}+{b1}*x)"}{p_end}
{phang2}{cmd:. global phi "normalden({b0}+{b1}*x)"}{p_end}
{phang2}{cmd:. gmm (y*$phi/$Phi - (1-y)*$phi/(1-$Phi))}
           {cmd:( (y*$phi/$Phi - (1-y)*$phi/(1-$Phi))*x)}
           {cmd:winitial(identity) onestep}{p_end}

{pstd}
Using {cmd:gmm} to fit a nonlinear least-squares model (probit){p_end}
{phang2}{cmd:. global Phi "normal({b0}+{b1}*x)"}{p_end}
{phang2}{cmd:. global phi "normalden({b0}+{b1}*x)"}{p_end}
{phang2}{cmd:. gmm ( (y - $Phi)*(-x*$phi) )}
              {cmd:( (y - $Phi)*(-1*$phi) )}
              {cmd:winitial(identity) onestep}{p_end}
{phang2}{cmd:. nl (y = $Phi)}{p_end}

{marker dynpan}{...}
{pstd}
Using {cmd:gmm} to fit a dynamic panel-data model{p_end}
{phang2}{cmd:. webuse abdata}{p_end}
{phang2}{cmd:. xtdpdsys n L(0/1).w, lags(1) twostep}{p_end}
{phang2}{cmd:. gmm (n - {c -(}rho{c )-}*L.n - {c -(}w{c )-}*w - {c -(}lagw{c )-}*L.w - {c -(}c{c )-})}{p_end}
{phang2}{space 4}{cmd:(D.n - {c -(}rho{c )-}*LD.n - {c -(}w{c )-}*D.w - {c -(}lagw{c )-}*LD.w),}{p_end}
{phang2}{space 4}{cmd:xtinstruments(1:D.n, lags(1/1))}{p_end}
{phang2}{space 4}{cmd:xtinstruments(2:n, lags(2/.))}{p_end}
{phang2}{space 4}{cmd:instruments(2:D.w LD.w, noconstant)}{p_end}
{phang2}{space 4}{cmd:deriv(1/rho = -1*L.n)}{p_end}
{phang2}{space 4}{cmd:deriv(1/w = -1*w)}{p_end}
{phang2}{space 4}{cmd:deriv(1/lagw = -1*L.w)}{p_end}
{phang2}{space 4}{cmd:deriv(1/c = -1)}{p_end}
{phang2}{space 4}{cmd:deriv(2/rho = -1*LD.n)}{p_end}
{phang2}{space 4}{cmd:deriv(2/w = -1*D.w)}{p_end}
{phang2}{space 4}{cmd:deriv(2/lagw = -1*LD.w)}{p_end}
{phang2}{space 4}{cmd:winitial(xt LD) wmatrix(robust) vce(unadjusted)}{p_end}
{phang2}{space 4}{cmd:variables(L.n w L.w)}{p_end}
{phang2}{space 4}{cmd:twostep nocommonesample}{p_end}

{pstd}
Using {cmd:gmm} to fit a dynamic panel-data model with 
predetermined coterminous regressor {cmd:k}{p_end}
{phang2}{cmd:. xtdpdsys n L(0/1).w, pre(k) lags(1) twostep}{p_end}
{phang2}{cmd:. gmm (n - {c -(}rho{c )-}*L.n - {c -(}k{c )-}*k - {c -(}w{c )-}*w - {c -(}lagw{c )-}*L.w - {c -(}c{c )-})}{p_end}
{phang2}{space 4}{cmd:(D.n - {c -(}rho{c )-}*LD.n - {c -(}k{c )-}*D.k - {c -(}w{c )-}*D.w - {c -(}lagw{c )-}*LD.w),}{p_end}
{phang2}{space 4}{cmd:xtinstruments(1:D.n, lags(1/1))}{p_end}
{phang2}{space 4}{cmd:xtinstruments(1:D.k, lags(0/0))}{p_end}
{phang2}{space 4}{cmd:xtinstruments(2:n, lags(2/.))}{p_end}
{phang2}{space 4}{cmd:xtinstruments(2:k, lags(1/.))}{p_end}
{phang2}{space 4}{cmd:instruments(2:D.w LD.w, noconstant)}{p_end}
{phang2}{space 4}{cmd:deriv(1/rho = -1*L.n)}{p_end}
{phang2}{space 4}{cmd:deriv(1/k = -1*k)}{p_end}
{phang2}{space 4}{cmd:deriv(1/w = -1*w)}{p_end}
{phang2}{space 4}{cmd:deriv(1/lagw = -1*L.w)}{p_end}
{phang2}{space 4}{cmd:deriv(1/c = -1)}{p_end}
{phang2}{space 4}{cmd:deriv(2/rho = -1*LD.n)}{p_end}
{phang2}{space 4}{cmd:deriv(2/k = -1*D.k)}{p_end}
{phang2}{space 4}{cmd:deriv(2/w = -1*D.w)}{p_end}
{phang2}{space 4}{cmd:deriv(2/lagw = -1*LD.w)}{p_end}
{phang2}{space 4}{cmd:winitial(xt LD) wmatrix(robust) vce(unadjusted)}{p_end}
{phang2}{space 4}{cmd:variables(L.n w L.w)}{p_end}
{phang2}{space 4}{cmd:twostep nocommonesample}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:gmm} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(n_moments)}}number of moments{p_end}
{synopt:{cmd:e(n_eq)}}number of equations in moment-evaluator program{p_end}
{synopt:{cmd:e(Q)}}criterion function{p_end}
{synopt:{cmd:e(J)}}Hansen {it:J} chi-squared statistic{p_end}
{synopt:{cmd:e(J_df)}}{it:J} statistic degrees of freedom{p_end}
{synopt:{cmd:e(k_}{it:i}{cmd:)}}number of parameters in equation {it:i}{p_end}
{synopt:{cmd:e(has_xtinst)}}{cmd:1} if panel-style instruments specified, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(type)}}{cmd:1} if interactive version, {cmd:2} if moment-evaluator program version{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations used by iterative GMM estimator{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:gmm}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(title)}}title specified in {cmd:title()}{p_end}
{synopt:{cmd:e(title_2)}}title specified in {cmd:title2()}{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(inst_}{it:i}{cmd:)}}equation {it:i} instruments{p_end}
{synopt:{cmd:e(eqnames)}}equation names{p_end}
{synopt:{cmd:e(winit)}}initial weight matrix used{p_end}
{synopt:{cmd:e(winitname)}}name of user-supplied initial weight matrix{p_end}
{synopt:{cmd:e(estimator)}}{opt onestep}, {opt twostep}, or {opt igmm}{p_end}
{synopt:{cmd:e(rhs)}}variables specified in {opt variables()}{p_end}
{synopt:{cmd:e(params_}{it:i}{cmd:)}}equation {it:i} parameters{p_end}
{synopt:{cmd:e(wmatrix)}}{it:wmtype} specified in {opt wmatrix()}{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {opt vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(params)}}parameter names{p_end}
{synopt:{cmd:e(sexp_}{it:i}{cmd:)}}substitutable expression for equation {it:i}{p_end}
{synopt:{cmd:e(evalprog)}}moment-evaluator program{p_end}
{synopt:{cmd:e(evalopts)}}options passed to moment-evaluator program{p_end}
{synopt:{cmd:e(nocommonesample)}}{cmd:nocommonesample}, if specified{p_end}
{synopt:{cmd:e(technique)}}optimization technique{p_end}
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
{synopt:{cmd:e(init)}}initial values of the estimators{p_end}
{synopt:{cmd:e(Wuser)}}user-supplied initial weight matrix{p_end}
{synopt:{cmd:e(W)}}weight matrix used for final round of estimation{p_end}
{synopt:{cmd:e(S)}}moment covariance matrix used in robust VCE computations{p_end}
{synopt:{cmd:e(G)}}averages of derivatives of moment conditions{p_end}
{synopt:{cmd:e(N_byequation)}}number of observations per equation, if {opt nocommonesample} specified{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}


{marker references}{...}
{title:References}

{marker G2018}{...}
{phang}
Greene, W. H. 2018.
{browse "http://www.stata.com/bookstore/ea.html":{it:Econometric Analysis}. 8th ed.}
New York: Pearson.

{marker H2005}{...}
{phang}
Hall, A. R. 2005.
{it:Generalized Method of Moments}.
Oxford: Oxford University Press.

{marker H1994}{...}
{phang}
Hamilton, J. D. 1994.
{it:Time Series Analysis}.
Princeton: Princeton University Press.

{marker NW1994}{...}
{phang}
Newey, W. K., and K. D. West. 1994 Automatic lag selection in covariance
matrix estimation.  {it:Review of Economic Studies} 61: 631-653.
{p_end}
