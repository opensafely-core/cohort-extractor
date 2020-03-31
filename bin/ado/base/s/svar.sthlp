{smcl}
{* *! version 1.2.28  22mar2019}{...}
{viewerdialog svar "dialog svar"}{...}
{vieweralsosee "[TS] var svar" "mansection TS varsvar"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] var svar postestimation" "help svar postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] var" "help var"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] varbasic" "help varbasic"}{...}
{vieweralsosee "[TS] vec" "help vec"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[DSGE]" "mansection DSGE dsge"}{...}
{viewerjumpto "Syntax" "svar##syntax"}{...}
{viewerjumpto "Menu" "svar##menu"}{...}
{viewerjumpto "Description" "svar##description"}{...}
{viewerjumpto "Links to PDF documentation" "svar##linkspdf"}{...}
{viewerjumpto "Options" "svar##options"}{...}
{viewerjumpto "Examples" "svar##examples"}{...}
{viewerjumpto "Stored results" "svar##results"}{...}
{viewerjumpto "Reference" "svar##reference"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[TS] var svar} {hline 2}}Structural vector autoregressive
models{p_end}
{p2col:}({mansection TS varsvar:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Short-run constraints

{p 8 13 2}
{cmd:svar}
{depvarlist}
{ifin}
{cmd:,}
{c -(}
{opt acon:straints(constraints_a)}
{opt ae:q(matrix_aeq)}
{opt ac:ns(matrix_acns)}
{opt bcon:straints(constraints_b)}
{opt be:q(matrix_beq)}
{opt bc:ns(matrix_bcns)}
{c )-}
[{it:{help svar##short_run_options:short_run_options}}]{p_end}


{pstd}
Long-run constraints

{p 8 13 2 }
{cmd:svar}
{depvarlist}
{ifin}
{cmd:,}
{c -(}
{opt lrcon:straints(constraints_lr)}
{opt lre:q(matrix_lreq)}
{opt lrc:ns(matrix_lrcns)}
{c )-}
[{it:{help svar##long_run_options:long_run_options}}]{p_end}


{synoptset 33 tabbed}{...}
{marker short_run_options}{...}
{synopthdr:short_run_options}
{synoptline}
{syntab:Model}
{synopt:{opt nocons:tant}}suppress constant term{p_end}
{p2coldent:* {opt acon:straints(constraints_a)}}apply previously defined {it:constraints_a} to {bf:A}{p_end}
{p2coldent:* {opt ae:q(matrix_aeq)}}define and apply to {bf:A} equality constraint matrix {it:matrix_aeq}{p_end}
{p2coldent:* {opt ac:ns(matrix_acns)}}define and apply to {bf:A} cross-parameter constraint matrix {it:matrix_acns}{p_end}
{p2coldent:* {opt bcon:straints(constraints_b)}}apply previously defined {it:constraints_b} to {bf:B}{p_end}
{p2coldent:* {opt be:q(matrix_beq)}}define and apply to {bf:B} equality constraint matrix {it:matrix_beq}{p_end}
{p2coldent:* {opt bc:ns(matrix_bcns)}}define and apply to {bf:B} cross-parameter constraint {it:matrix_bcns}{p_end}
{synopt:{opth la:gs(numlist)}}use lags {it:numlist} in the underlying VAR{p_end}

{syntab:Model 2}
{synopt:{opth ex:og(varlist:varlist_exog)}}use exogenous variables {it:varlist}{p_end}
{synopt:{opt varc:onstraints(constraints_v)}}apply {it:constraints_v} to underlying VAR{p_end}
{synopt:{opt noislog}}suppress SURE iteration log{p_end}
{synopt:{opt isit:erate(#)}}set maximum number of iterations for SURE; default is {cmd:isiterate(1600)}{p_end}
{synopt:{opt istol:erance(#)}}set convergence tolerance of SURE{p_end}
{synopt:{opt nois:ure}}use one-step SURE{p_end}
{synopt:{opt dfk}}make small-sample degrees-of-freedom adjustment{p_end}
{synopt:{opt sm:all}}report small-sample t and F statistics{p_end}
{synopt:{opt noiden:check}}do not check for local identification{p_end}
{synopt:{opt nobig:f}}do not compute parameter vector for coefficients
implicitly set to zero {p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt f:ull}}show constrained parameters in table{p_end}
{synopt:{opt var}}display underlying {opt var} output{p_end}
{synopt:{opt lut:stats}}report L{c u:}tkepohl lag-order selection statistics{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help svar##display_options:display_options}}}control columns
         and column formats{p_end}

{syntab:Maximization}
{synopt:{it:{help svar##maximize_options:maximize_options}}}control the maximization process;
seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p 4 6 2}
* {opt aconstraints(constraints_a)}, {opt aeq(matrix_aeq)}, {opt acns(matrix_acns)},
  {opt bconstraints(constraints_b)}, {opt beq(matrix_beq)}, {opt bcns(matrix_bcns)}:
  at least one of these options must be specified.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}

{marker long_run_options}{...}
{synopthdr:long_run_options}
{synoptline}
{syntab:Model}
{synopt:{opt nocons:tant}}suppress constant term{p_end}
{p2coldent:* {opt lrcon:straints(constraints_lr)}}apply previously defined {it:constraints_lr} to {bf:C}{p_end}
{p2coldent:* {opt lre:q(matrix_lreq)}}define and apply to {bf:C} equality constraint matrix {it:matrix_lreq}{p_end}
{p2coldent:* {opt lrc:ns(matrix_lrcns)}}define and apply to {bf:C} cross-parameter constraint matrix {it:matrix_lrcns}{p_end}
{synopt:{opth la:gs(numlist:numlist)}}use lags {it:numlist} in the underlying VAR{p_end}

{syntab:Model 2}
{synopt:{opth ex:og(varlist:varlist_exog)}}use exogenous variables {it:varlist}{p_end}
{synopt:{opt varc:onstraints(constraints_v)}}apply {it:constraints_v}
to underlying VAR {p_end}
{synopt:{opt noislog}}suppress SURE iteration log{p_end}
{synopt:{opt isit:erate(#)}}set maximum number of iterations for SURE; default is {cmd:isiterate(1600)}{p_end}
{synopt:{opt istol:erance(#)}}set convergence tolerance of SURE{p_end}
{synopt:{opt nois:ure}}use one-step SURE{p_end}
{synopt:{opt dfk}}make small-sample degrees-of-freedom adjustment{p_end}
{synopt:{opt sm:all}}report small-sample t and F statistics{p_end}
{synopt:{opt noiden:check}}do not check for local identification{p_end}
{synopt:{opt nobig:f}}do not compute parameter vector for coefficients
implicitly set to zero{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt f:ull}}show constrained parameters in table{p_end}
{synopt:{opt var}}display underlying {opt var} output{p_end}
{synopt:{opt lut:stats}}report L{c u:}tkepohl lag-order selection statistics{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help svar##display_options:display_options}}}control columns
         and column formats{p_end}

{syntab:Maximization}
{synopt:{it:{help svar##maximize_options:maximize_options}}}control the maximization process;
seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p 4 6 2}
* {opt lrconstraints(constraints_lr)}, {opt lreq(matrix_lreq)},
  {opt lrcns(matrix_lrcns)}: at least one of these options must be specified.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}

{p 4 6 2}You must {cmd:tsset} your data before using {opt svar}; see
{helpb tsset:[TS] tsset}. {p_end}
{p 4 6 2}The {it:depvarlist} and {it:varlist_exog} may contain time-series
operators; see {help tsvarlist}. {p_end}
{p 4 6 2}{opt by}, {opt fp}, {opt rolling}, {opt statsby}, and {cmd:xi} are
allowed; see {help prefix}.{p_end}
{p 4 6 2}See {manhelp svar_postestimation TS:var svar postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > Structural vector autoregression (SVAR)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:svar} fits a vector autoregressive model subject to short- or
long-run constraints you place on the resulting impulse-response
functions (IRFs).  Economic theory typically motivates the constraints,
allowing a causal interpretation of the IRFs to be made.  See 
{manhelp var_intro TS:var intro} for a list of commands that are used in
conjunction with {cmd:svar}. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS varsvarQuickstart:Quick start}

        {mansection TS varsvarRemarksandexamples:Remarks and examples}

        {mansection TS varsvarMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{bf:{help estimation options##noconstant:[R] Estimation options}}.

{pstd}
{opt aconstraints(constraints_a)},
{opt aeq(matrix_aeq)},
{opt acns(matrix_acns)}
{break}
{opt bconstraints(constraints_b)},
{opt beq(matrix_beq)},
{opt bcns(matrix_bcns)}{p_end}
{pmore}
    These options specify the short-run constraints in an SVAR.  To specify a
    short-run SVAR model, you must specify at least one of these options.  The
    first list of options specifies constraints on the parameters of the
    {bf:A} matrix; the second list specifies constraints on the parameters of
    the {bf:B} matrix.
    If at least one option is selected from the first list and none are
    selected from the second list, {opt svar} sets {bf:B} to the identity
    matrix.  Similarly, if at least one option is selected from the second
    list and none are selected from the first list, {opt svar} sets {bf:A} to
    the identity matrix.

{pmore}
    None of these options may be specified with any of the options that define
    long-run constraints.

{phang2}
{opt aconstraints(constraints_a)} specifies a {it:{help numlist}} of
    previously defined Stata constraints to be applied to {bf:A}
    during estimation.

{phang2}
{opt aeq(matrix_aeq)} specifies a matrix that defines a set of
equality constraints.  This matrix must be square with dimension equal to the
number of equations in the underlying VAR.  The elements of this matrix must
be {it:missing} or real numbers.  A missing value in the ({it:i,j})
element of this matrix specifies that the ({it:i,j}) element of {bf:A}
is a free parameter.  A real number in the ({it:i,j}) element of this
matrix constrains the ({it:i,j}) element of {bf:A} to this real number.  For
example,

{center:{space 4}{c TLC}{space 11}{c TRC}}
{center:{bf:A} = {c |} 1     0   {c |}}
{center:{space 4}{c |} .    1.5  {c |}}
{center:{space 4}{c BLC}{space 11}{c BRC}}

{pmore2}
   specifies that {bf:A}[1,1]=1, {bf:A}[1,2]=0, {bf:A}[2,2]=1.5, and
   {bf:A}[2,1] is a free parameter.

{phang2}
{opt acns(matrix_acns)} specifies a matrix that defines a set
   of exclusion or cross-parameter equality constraints on {bf:A}.  This
   matrix must be square with dimension equal to the number of equations in
   the underlying VAR.  Each element of this matrix must be {it:missing}, 0,
   or a positive integer.  A missing value in the ({it:i,j}) element of this
   matrix specifies that no constraint be placed on this element of {bf:A}.  A
   zero in the ({it:i,j}) element of this matrix constrains the ({it:i,j})
   element of {bf:A} to be zero.  Any strictly positive integers must be in
   two or more elements of this matrix.  A strictly positive integer in the
   ({it:i,j}) element of this matrix constrains the ({it:i,j}) element of {bf:A}
   to be equal to all the other elements of {bf:A} that correspond to elements
   in this matrix that contain the same integer.  For example, consider the
   matrix

{center:{space 4}{c TLC}{space 10}{c TRC}}
{center:{bf:A} = {c |} .     1  {c |}}
{center:{space 4}{c |} 1     0  {c |}}
{center:{space 4}{c BLC}{space 10}{c BRC}}

{pmore2}
   Specifying {cmd:acns(A)} in a two-equation SVAR constrains
   {bf:A}[2,1]={bf:A}[1,2] and {bf:A}[2,2]=0 while leaving {bf:A}[1,1] free.

{phang2}
{opt bconstraints(constraints_a)} specifies a {it:{help numlist}} of
   previously defined Stata constraints to be applied to {bf:B} during
   estimation.

{phang2}
{opt beq(matrix_beq)} specifies a matrix that defines a set of
   equality constraints.  This matrix must be square with dimension equal to
   the number of equations in the underlying VAR.  The elements of this matrix
   must be either {it:missing} or real numbers.  The syntax of implied
   constraints is analogous to the one described in {opt aeq()}, except that it
   applies to {bf:B} rather than to {bf:A}.

{phang2}
{opt bcns(matrix_bcns)} specifies a matrix that defines a set of
   exclusion or cross-parameter equality constraints on {bf:B}.  This matrix
   must be square with dimension equal to the number of equations in the
   underlying VAR.  Each element of this matrix must be {it:missing}, 0, or a
   positive integer.  The format of the implied constraints is the same as the
   one described in the {opt acns()} option above.

{phang}
{opt lrconstraints(constraints_lr)},
{opt lreq(matrix_lreq)},
{opt lrcns(matrix_lrcns)}{p_end}
{pmore}
   These options specify the long-run constraints in an SVAR.  To specify a
   long-run SVAR model, you must specify at least one of these options.  The
   list of options specifies constraints on the parameters of the long-run
   {bf:C} matrix (see 
   {mansection TS varsvarRemarksandexamplesLong-runSVARmodels:{it:Long-run SVAR models}}
   in {bf:[TS] var svar}
   for the definition of {bf:C}).  None of these options may be specified with
   any of the options that define short-run constraints.

{phang2}
{opt lrconstraints(constraints_lr)} specifies a {it:{help numlist}} of
   previously defined Stata constraints to be applied to {bf:C} during
   estimation.

{phang2}
{opt lreq(matrix_lreq)} specifies a matrix that defines a set
   of equality constraints on the elements of {bf:C}.  This matrix must be
   square with dimension equal to the number of equations in the underlying
   VAR.  The elements of this matrix must be either {it:missing} or real
   numbers.  The syntax of implied constraints is analogous to the one
   described in option {opt aeq()}, except that it applies to {bf:C}.

{phang2}
{opt lrcns(matrix_lrcns)} specifies a matrix that defines a set
   of exclusion or cross-parameter equality constraints on {bf:C}.  This
   matrix must be square with dimension equal to the number of equations in
   the underlying VAR.  Each element of this matrix must be {it:missing}, 0,
   or a positive integer.  The syntax of the implied constraints is the same
   as the one described for the {opt acns()} option above.

{phang}
{opt lags(numlist)} specifies the lags to be included in the underlying VAR
   model.  The default is {cmd:lags(1 2)}. This option takes a
   {it:numlist} and not simply an integer for the maximum lag.  For instance,
   {cmd:lags(2)} would include only the second lag in the model, whereas
   {cmd:lags(1/2)} would include both the first and second lags in the model.
   See {it:{help numlist}} and {help tsvarlist} for
   further discussion of {it:numlist}s and lags.

{dlgtab:Model 2}

{phang}
{opth "exog(varlist:varlist_exog)"} specifies a list of exogenous variables to
be included in the underlying VAR.

{phang}
{opt varconstraints(constraints_v)} specifies a list of constraints to
    be applied to the coefficients in the underlying VAR.  Because {opt svar}
    estimates multiple equations, the constraints must specify the equation
    name for all but the first equation.

{phang}
{opt noislog} prevents {opt svar} from displaying the iteration log from the
   iterated seemingly unrelated regression algorithm.  When the
   {opt varconstraints()} option is not specified, the VAR coefficients are
   estimated via OLS, a noniterative procedure.  As a result, {opt noislog}
   may be specified only with {opt varconstraints()}.  Similarly,
   {opt noislog} may not be combined with {opt noisure}.

{phang}
{opt isiterate(#)} sets the maximum number of iterations for the iterated
   seemingly unrelated regression algorithm.  The default limit is 1,600.
   When the {opt varconstraints()} option is not specified, the VAR
   coefficients are estimated via OLS, a noniterative procedure.  As a result,
   {opt isiterate()} may be specified only with {opt varconstraints()}.
   Similarly, {opt isiterate()} may not be combined with {opt noisure}.

{phang}
{opt istolerance(#)} specifies the convergence tolerance of the iterated
   seemingly unrelated regression algorithm.  The default tolerance is
   {cmd:1e-6}.  When the {opt varconstraints()} option is not specified, the
   VAR coefficients are estimated via OLS, a noniterative procedure.  As a
   result, {opt istolerance()} may be specified only with
   {opt varconstraints()}.  Similarly, {opt istolerance()} may not be combined
   with {opt noisure}.

{phang}
{opt noisure} specifies that the VAR coefficients be estimated via one-step
   seemingly unrelated regression when {opt varconstraints()} is specified.
   By default, {opt svar} estimates the coefficients in the VAR via iterated
   seemingly unrelated regression when {opt varconstraints()} is specified.
   When the {opt varconstraints()} option is not specified, the VAR
   coefficient estimates are obtained via OLS, a noniterative procedure.  As a
   result, {opt noisure} may be specified only with {opt varconstraints()}.

{phang}
{opt dfk} specifies that a small-sample degrees-of-freedom adjustment
   be used when estimating the covariance matrix of the VAR disturbances.
   Specifically, 1/(T-mparms) is used instead of the large-sample divisor 1/T,
   where mparms is the average number of parameters in the functional form for
   y_t over the K equations.

{phang}
{opt small} causes {opt svar} to calculate and report small-sample t and
   F statistics instead of the large-sample normal and chi-squared
   statistics.

{phang}
{opt noidencheck} requests that the
   {help svar##AG1997:Amisano and Giannini (1997)} check for local
   identification not be performed.  This check is local to the starting
   values used.  Because of this dependence on the starting values, you may
   wish to suppress this check by specifying the {opt noidencheck} option.
   However, be careful in specifying this option.  Models that are not
   structurally identified can still converge, thereby producing meaningless
   results that only appear to have meaning.

{phang}
{opt nobigf} requests that {opt svar} not compute the estimated parameter
vector that incorporates coefficients that have been implicitly constrained to
be zero, such as when some lags have been omitted from a model.  {cmd:e(bf)}
is used for computing asymptotic standard errors in the postestimation
commands {helpb irf create} and {helpb fcast compute}.  Therefore, specifying
{opt nobigf} implies that the asymptotic standard errors will not be available
from {opt irf create} and {opt fcast compute}.  See
{it:{mansection TS varRemarksandexamplesFittingmodelswithsomelagsexcluded:Fitting models with some lags excluded}}
in {bf:[TS] var}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{bf:{help estimation options##level():[R] Estimation options}}.

{phang}
{opt full} shows constrained parameters in table.

{phang}
{opt var} specifies that the output from {opt var} also be displayed.
By default, the underlying VAR is fit {helpb quietly}.

{phang}
{opt lutstats} specifies that the L{c u:}tkepohl versions of the lag-order
   selection statistics be computed.  See
   {it:{mansection TS varsocMethodsandformulas:Methods and formulas}} in
   {bf:[TS] varsoc} for a discussion of these statistics.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noci},
{opt nopv:alues},
{opth cformat(%fmt)},
{opt pformat(%fmt)}, and
{opt sformat(%fmt)};
    see {helpb estimation options##display_options:[R] Estimation options}.

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)},
[{cmd:no}]{opt log},
{opt tr:ace},
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)};
see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pstd}
The following option is available with {opt svar} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}{p_end}
{phang2}{cmd:. matrix A = (1,0,0\.,1,0\.,.,1)}{p_end}
{phang2}{cmd:. matrix B = (.,0,0\0,.,0\0,0,.)}

{pstd}Short-run just-identified SVAR model{p_end}
{phang2}{cmd:. svar dln_inv dln_inc dln_consump, aeq(A) beq(B)}{p_end}

{pstd}Same as above, but restrict to specified date range{p_end}
{phang2}{cmd:. svar dln_inv dln_inc dln_consump if qtr<=tq(1978q4),}
            {cmd:aeq(A) beq(B)}{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. matrix A = (1,0,0\0,1,0\.,.,1)}{p_end}
{phang2}{cmd:. matrix B = (.,0,0\0,.,0\0,0,.)}

{pstd}Short-run overidentified SVAR model{p_end}
{phang2}{cmd:. svar dln_inv dln_inc dln_consump if qtr<=tq(1978q4),}
           {cmd:aeq(A) beq(B)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse m1gdp}{p_end}
{phang2}{cmd:. matrix lr = (.,0\0,.)}

{pstd}Long-run SVAR model{p_end}
{phang2}{cmd:. svar d.ln_m1 d.ln_gdp, lreq(lr)}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:svar} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_cns)}}number of constraints{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(ll)}}log likelihood from {cmd:svar}{p_end}
{synopt:{cmd:e(N_gaps_var)}}number of gaps in the sample{p_end}
{synopt:{cmd:e(k_var)}}number of coefficients in VAR{p_end}
{synopt:{cmd:e(k_eq_var)}}number of equations in underlying VAR{p_end}
{synopt:{cmd:e(k_dv_var)}}number of dependent variables in underlying VAR{p_end}
{synopt:{cmd:e(df_eq_var)}}average number of parameters in an equation{p_end}
{synopt:{cmd:e(df_r_var)}}if {cmd:small}, residual degrees of freedom{p_end}
{synopt:{cmd:e(obs_}{it:#}{cmd:_var)}}number of observations on equation
	{it:#}{p_end}
{synopt:{cmd:e(k_}{it:#}{cmd:_var)}}number of coefficients in equation
	{it:#}{p_end}
{synopt:{cmd:e(df_m}{it:#}{cmd:_var)}}model degrees of freedom for equation
	{it:#}{p_end}
{synopt:{cmd:e(df_r}{it:#}{cmd:_var)}}residual degrees of freedom for equation
	{it:#} ({cmd:small} only){p_end}
{synopt:{cmd:e(r2_}{it:#}{cmd:_var)}}R-squared for equation {it:#}{p_end}
{synopt:{cmd:e(ll_}{it:#}{cmd:_var)}}log likelihood for equation {it:#} VAR
{p_end}
{synopt:{cmd:e(chi2_}{it:#}{cmd:_var)}}chi-squared statistic for equation
	{it:#}{p_end}
{synopt:{cmd:e(F_}{it:#}{cmd:_var)}}F statistic for equation {it:#}
	({cmd:small} only){p_end}
{synopt:{cmd:e(rmse_}{it:#}{cmd:_var)}}root mean squared error for equation
	{it:#}{p_end}
{synopt:{cmd:e(mlag_var)}}highest lag in VAR{p_end}
{synopt:{cmd:e(tparms_var)}}number of parameters in all equations{p_end}
{synopt:{cmd:e(aic_var)}}Akaike information criterion{p_end}
{synopt:{cmd:e(hqic_var)}}Hannan-Quinn information criterion{p_end}
{synopt:{cmd:e(sbic_var)}}Schwarz-Bayesian information criterion{p_end}
{synopt:{cmd:e(fpe_var)}}final prediction error{p_end}
{synopt:{cmd:e(ll_var)}}log likelihood from {cmd:var}{p_end}
{synopt:{cmd:e(detsig_var)}}determinant of {cmd:e(Sigma)}{p_end}
{synopt:{cmd:e(detsig_ml_var)}}determinant of Sigma_ml hat{p_end}
{synopt:{cmd:e(tmin)}}first time period in the sample{p_end}
{synopt:{cmd:e(tmax)}}maximum time{p_end}
{synopt:{cmd:e(chi2_oid)}}overidentification test{p_end}
{synopt:{cmd:e(oid_df)}}number of overidentifying restrictions{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic_ml)}}number of iterations{p_end}
{synopt:{cmd:e(rc_ml)}}return code from {cmd:ml}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:svar}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(lrmodel)}}long-run model, if specified{p_end}
{synopt:{cmd:e(lags_var)}}lags in model{p_end}
{synopt:{cmd:e(depvar_var)}}names of dependent variables{p_end}
{synopt:{cmd:e(endog_var)}}names of endogenous variables{p_end}
{synopt:{cmd:e(exog_var)}}names of exogenous variables, if specified{p_end}
{synopt:{cmd:e(nocons_var)}}{cmd:nocons}, if {cmd:noconstant} specified{p_end}
{synopt:{cmd:e(cns_lr)}}long-run constraints{p_end}
{synopt:{cmd:e(cns_a)}}cross-parameter equality constraints on A{p_end}
{synopt:{cmd:e(cns_b)}}cross-parameter equality constraints on B{p_end}
{synopt:{cmd:e(dfk_var)}}alternate divisor ({cmd:dfk}), if specified{p_end}
{synopt:{cmd:e(eqnames_var)}}names of equations{p_end}
{synopt:{cmd:e(lutstats_var)}}{cmd:lutstats}, if specified{p_end}
{synopt:{cmd:e(constraints_var)}}{cmd:constraints_var}, if there are
	constraints on VAR{p_end}
{synopt:{cmd:e(small)}}{cmd:small}, if specified{p_end}
{synopt:{cmd:e(tsfmt)}}format of timevar{p_end}
{synopt:{cmd:e(timevar)}}name of timevar{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(Sigma)}}Sigma hat matrix{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(b_var)}}coefficient vector of underlying VAR model{p_end}
{synopt:{cmd:e(V_var)}}VCE of underlying VAR model{p_end}
{synopt:{cmd:e(bf_var)}}full coefficient vector with zeros in dropped lags{p_end}
{synopt:{cmd:e(G_var)}}Gamma matrix stored by {cmd:var}; see
	{mansection TS varMethodsandformulas:{it:Methods and formulas}} in
	{hi:[TS] var}{p_end}
{synopt:{cmd:e(aeq)}}{cmd:aeq(}{it:matrix}{cmd:)}, if specified{p_end}
{synopt:{cmd:e(acns)}}{cmd:acns(}{it:matrix}{cmd:)}, if specified{p_end}
{synopt:{cmd:e(beq)}}{cmd:beq(}{it:matrix}{cmd:)}, if specified{p_end}
{synopt:{cmd:e(bcns)}}{cmd:bcns(}{it:matrix}{cmd:)}, if specified{p_end}
{synopt:{cmd:e(lreq)}}{cmd:lreq(}{it:matrix}{cmd:)}, if specified{p_end}
{synopt:{cmd:e(lrcns)}}{cmd:lrcns(}{it:matrix}{cmd:)}, if specified{p_end}
{synopt:{cmd:e(Cns_var)}}constraint matrix from {cmd:var}, if
	{cmd:varconstraints()} is specified{p_end}
{synopt:{cmd:e(A)}}estimated A matrix, if a short-run model{p_end}
{synopt:{cmd:e(B)}}estimated B matrix{p_end}
{synopt:{cmd:e(C)}}estimated C matrix, if a long-run model{p_end}
{synopt:{cmd:e(A1)}}estimated A bar matrix, if a long-run model{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker AG1997}{...}
{phang}
Amisano, G., and C. Giannini. 1997. {it:Topics in Structural VAR Econometrics}.
2nd ed. Heidelberg: Springer.
{p_end}
