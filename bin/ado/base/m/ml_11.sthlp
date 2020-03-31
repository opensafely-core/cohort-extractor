{smcl}
{* *! version 1.3.12  31may2018}{...}
{cmd:help ml_11}{right:{help prdocumented:previously documented}}
{hline}

{p2colset 4 14 16 2}{...}
{p2col:{hi:[R] ml} {hline 2}}Maximum likelihood estimation{p_end}
{p2colreset}{...}

{p 12 12 8}
{it}[The names associated with {bf:ml}'s evaluator types were changed
in version 11.
This help file documents {cmd:ml}'s old syntax and as such is 
probably of no interest to you.  You do not have to translate calls to
{cmd:ml} in old do-files to modern syntax because Stata continues
to understand both old and new syntaxes.   This help file is 
provided for those wishing to debug or understand old code.
Click {help ml:here} for the help file of the modern 
{cmd:ml} command.]{rm}


{title:Syntax}

{pstd}
ml model in interactive mode

{p 8 20 2}
{cmd:ml} {opt mod:el}{space 3}
{it:method progname eq}
[{it:eq ...}]
{ifin}
{weight}
[{cmd:,}
{it:{help ml_11##model_options:model_options}}
{opt svy}
{it:{help ml_11##diparm_options:diparm_options}}]

{p 8 20 2}
{cmd:ml} {opt mod:el}{space 3}
{it:method} {it:funcname}{cmd:()} {it:eq}
[{it:eq ...}]
{ifin}
{weight}
[{cmd:,}
{it:{help ml_11##model_options:model_options}}
{opt svy}
{it:{help ml_11##diparm_options:diparm_options}}]


{pstd}
ml model in noninteractive mode

{p 8 20 2}
{cmd:ml} {opt mod:el}{space 3}
{it:method progname eq}
[{it:eq ...}]
{ifin}
{weight}{cmd:,}
{opt max:imize}
[{it:{help ml_11##model_options:model_options}}
{opt svy}
{it:{help ml_11##diparm_options:diparm_options}}
{it:{help ml_11##noninteractive_options:noninteractive_options}}]

{p 8 20 2}
{cmd:ml} {opt mod:el}{space 3}
{it:method} {it:funcname}{cmd:()} {it:eq}
[{it:eq ...}]
{ifin}
{weight}{cmd:,}
{opt max:imize}
[{it:{help ml_11##model_options:model_options}}
{opt svy}
{it:{help ml_11##diparm_options:diparm_options}}
{it:{help ml_11##noninteractive_options:noninteractive_options}}]


{pstd}
Noninteractive mode is invoked by specifying the {opt maximize} option.  Use
{opt maximize} when {opt ml} will be used as a subroutine of another
ado-file or program and you want to carry forth the problem, from definition
to posting of results, in one command.

{p 8 20 2}
{cmd:ml clear}

{p 8 20 2}
{cmd:ml} {opt q:uery}

{p 8 20 2}
{cmd:ml check}

{p 8 20 2}
{cmd:ml} {opt sea:rch}{space 2}
	[[{cmd:/}]{it:eqname}[{cmd::}]
		{it:#lb} {it:#ub} ]
	[{it:...}]
	[{cmd:,}
	{it:{help ml_11##search_options:search_options}}]

{p 8 20 2}
{cmd:ml} {opt pl:ot}{space 4}
	[{it:eqname}{cmd::}]{it:name}
	[{it:#} [{it:#} [{it:#}]]]
	[{cmd:,}
	{cmdab:sav:ing:(}{it:filename}[{cmd:,} {opt replace}]{cmd:)}]

{p 8 20 2}
{cmd:ml init}{space 4}
	{c -(}
	[{it:eqname}{cmd::}]{it:name}{cmd:=}{it:#} |
	{cmd:/}{it:eqname}{cmd:=}{it:#}
	{c )-}
	[{it:...}]

{p 8 20 2}
{cmd:ml init}{space 5}{it:#} [{it:#} {it:...}]{cmd:,} {opt copy}

{p 8 20 2}
{cmd:ml init}{space 5}{it:matname} [{cmd:,} {opt copy} {opt skip} ]

{p 8 20 2}
{cmd:ml} {opt rep:ort}

{p 8 20 2}
{cmd:ml trace}{space 4}{c -(} {opt on} | {opt off} {c )-}

{p 8 20 2}
{cmd:ml count}{space 4}[ {opt clear} | {opt on} | {opt off} ]

{p 8 20 2}
{cmd:ml} {opt max:imize} [{cmd:,}
	{it:{help ml_11##ml_maximize_options:ml_maximize_options}}
	{it:{help ml_11##display_options:display_options}}
	{it:{help ml_11##eform_option:eform_option}}]

{p 8 20 2}
{cmd:ml} {opt gr:aph}{space 4}[{it:#}]
	[{cmd:,}
	{cmdab:sav:ing:(}{it:filename}[{cmd:,} {opt replace}]{cmd:)}
	]

{p 8 20 2}
{cmd:ml} {opt di:splay}{space 2}[{cmd:,}
	{it:{help ml_11##display_options:display_options}}
	{it:{help ml_11##eform_option:eform_option}}]

{p 8 20 2}
{cmd:ml} {opt foot:note}

{p 8 20 2}
{cmd:ml} {opt score} {newvar} {ifin}
      [{cmd:,} {it:{help ml_score:ml_score_options}}]

{p 8 20 2}
{cmd:ml} {opt score} {it:newvarlist} {ifin}
      [{cmd:,} {bf:{help ml_score:{ul:miss}ing}}]
 
{p 8 20 2}
{cmd:ml} {opt score} [{it:type}] {it:stub}{cmd:*} {ifin}
      [{cmd:,} {bf:{help ml_score:{ul:miss}ing}}]
 
{phang}
where {it:method} is one of

{col 13}{opt lf}{col 25}{opt d0}{col 37}        {col 49}{opt v0}
                {col 25}{opt d1}{col 37}{opt e1}{col 49}{opt v1}
                {col 25}{opt d1debug}{col 37}{opt e1debug}{col 49}{opt v1debug}
                {col 25}{opt d2}{col 37}{opt e2}{col 49}{opt v2}
                {col 25}{opt d2debug}{col 37}{opt e2debug}{col 49}{opt v2debug}

{phang}
{it:eq} is the equation to be estimated, enclosed in parentheses, and
optionally with a name to be given to the equation, preceded by a colon,

{p 12 16 2}
{cmd:(}
	[{it:eqname}{cmd::}]
	[{it:varlist_y} {cmd:=}]
	[{it:varlist_x}]
	[{cmd:,} {it:eq_options}]
{cmd:)}

{pmore}
or {it:eq} is the name of a parameter, such as sigma, with a slash in front

{p 12 12 2}
{cmd:/}{it:eqname}{space 6}which
is equivalent to{space 4}{cmd:(}{it:eqname}{cmd::)}

{pmore}
{marker diparm_options}{...}
and {it:diparm_options} is one or more {opt diparm(diparm_args)} options where
{it:diparm_args} is either {opt __sep__} or anything accepted by the
"undocumented" {opt _diparm} command; see {manhelp _diparm P}.

{marker eq_options}{...}
{synoptset 28}{...}
{synopthdr:eq_options}
{synoptline}
{synopt:{opt nocons:tant}}do not include an intercept in the equation
{p_end}
{synopt:{opth off:set(varname:varname_o)}}include {it:varname_o} in model with
	coefficient constrained to 1
	{p_end}
{synopt:{opth exp:osure(varname:varname_e)}}include ln({it:varname_e}) in model
	with coefficient constrained to 1
	{p_end}
{synoptline}
{p2colreset}{...}

{marker model_options}{...}
{synoptset 28}{...}
{synopthdr:model_options}
{synoptline}
{synopt:{opth vce(vcetype)}}{it:vcetype} may be {opt r:obust},
{opt cl:uster} {it:clustvar}, {opt oim}, or {opt opg}{p_end}
{synopt:{opth const:raints(numlist)}}constraints by number to be applied{p_end}
{synopt:{opt const:raints(matname)}}matrix that contains the constraints to be
applied{p_end}
{synopt:{opt nocnsnote:s}}do not display notes when constraints are dropped{p_end}
{synopt:{opth ti:tle(data types:string)}}place a title on the estimation output{p_end}
{synopt:{opt nopre:serve}}do not preserve the estimation subsample in
memory{p_end}
{synopt:{opt col:linear}}keep collinear variables within equations{p_end}
{synopt:{opt miss:ing}}keep observations containing variables with missing
values{p_end}
{synopt:{opt lf0(#k #ll)}}number of parameters and
log-likelihood value of the constant-only model{p_end}
{synopt:{opt cont:inue}}specifies that a model has been fit and sets the
initial values b_0 for the model to be fit based on those
results{p_end}
{synopt:{opt wald:test(#)}}perform a Wald test; see
{help ml_11##mlmode:Options for use with ml model in interactive or noninteractive mode} below
{p_end}
{synopt:{opt obs(#)}}number of observations{p_end}
{synopt:{opth "crittype(data types:string)"}}describe the criterion optimized
by {opt ml}{p_end}
{synopt:{opth sub:pop(varname)}}compute estimates for the single
subpopulation{p_end}
{synopt:{opt no}{opt svy:adjust}}carry out Wald test as W/k distributed F(k,d){p_end}
{synopt:{cmdab:tech:nique(nr)}}Stata's modified Newton-Raphson (NR) algorithm{p_end}
{synopt:{cmdab:tech:nique(bhhh)}}Berndt-Hall-Hall-Hausman (BHHH) algorithm{p_end}
{synopt:{cmdab:tech:nique(dfp)}}Davidon-Fletcher-Powell (DFP) algorithm{p_end}
{synopt:{cmdab:tech:nique(bfgs)}}Broyden-Fletcher-Goldfarb-Shanno (BFGS) algorithm{p_end}
{synoptline}
{p2colreset}{...}

{marker noninteractive_options}{...}
{synoptset 28}{...}
{synopthdr:noninteractive_options}
{synoptline}
{synopt:{opt init:(ml_init_args)}}set the initial values b_0{p_end}
{synopt:{cmdab:sea:rch(on)}}equivalent to {cmd:ml search, repeat(0)}; the
default{p_end}
{synopt:{cmdab:sea:rch(norescale)}}equivalent to {cmd:ml search, repeat(0) norescale}{p_end}
{synopt:{cmdab:sea:rch(quietly)}}same as {cmd:search(on)}, except that output
is suppressed{p_end}
{synopt:{cmdab:sea:rch(off)}}prevents calling {opt ml search}{p_end}
{synopt:{opt r:epeat(#)}}{opt ml search}'s {opt repeat()} option; see below{p_end}
{synopt:{opt b:ounds(ml_search_bounds)}}specify bounds for {opt ml search}
{p_end}
{synopt:{opt nowarn:ing}}suppress "convergence not achieved" message of
{cmd:iterate(0)}{p_end}
{synopt:{opt novce}}substitute the zero matrix for the variance matrix{p_end}
{synopt:{opt negh}}indicates that the evaluator returns the negative Hessian matrix{p_end}
{synopt:{opth sc:ore(newvar:newvars)}}new variables containing the
contribution to the score{p_end}
{synopt:{it:{help ml_11##noninteractive_maxopts:maximize_options}}}control the
maximization process; seldom used{p_end}
{synoptline}
{p2colreset}{...}

{marker search_options}{...}
{synoptset 28}{...}
{synopthdr:search_options}
{synoptline}
{synopt:{opt r:epeat(#)}}number of random attempts to find better
initial-value vector; default is {cmd:repeat(10)} in interactive mode and
{cmd:repeat(0)} in noninteractive mode{p_end}
{synopt:{opt rest:art}}use random actions to find starting values; not
recommended{p_end}
{synopt:{opt noresc:ale}}do not rescale to improve vector parameter; not
recommended{p_end}
{synopt:{it:{help ml_11##search_maxopts:maximize_options}}}control the
maximization process; seldom used{p_end}
{synoptline}
{p2colreset}{...}

{marker ml_maximize_options}{...}
{synoptset 28}{...}
{synopthdr:ml_maximize_options}
{synoptline}
{synopt:{opt nowarn:ing}}suppress "convergence not achieved" message of
{cmd:iterate(0)}{p_end}
{synopt:{opt novce}}substitute the zero matrix for the variance matrix{p_end}
{synopt:{opt negh}}indicates that the evaluator returns the negative Hessian matrix{p_end}
{synopt:{cmdab:sc:ore(}{it:{help newvar:newvars}} | {it:stub}{cmd:*}{cmd:)}}new variables containing the contribution
to the score{p_end}
{synopt:{opt noout:put}}suppress display of final results{p_end}
{synopt:{opt noclear}}do not clear ml problem definition after model has
converged{p_end}
{synopt:{it:{help ml_11##ml_maxopts:maximize_options}}}control the
maximization process; seldom used{p_end}
{synoptline}
{p2colreset}{...}

{marker display_options}{...}
{synoptset 28}{...}
{synopthdr:display_options}
{synoptline}
{synopt:{opt noh:eader}}suppress header display above the coefficient
table{p_end}
{synopt:{opt nofoot:note}}suppress footnote display below the coefficient
table{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt:{opt f:irst}}display coefficient table reporting results for first
equation only{p_end}
{synopt:{opt neq(#)}}display coefficient table reporting first {it:#}
equations{p_end}
{synopt:{opt showeq:ns}}display equation names in the coefficient table{p_end}
{synopt:{opt pl:us}}display coefficient table ending in
dashes{c -}plus-sign{c -}dashes{p_end}
{synopt:{opt nocnsr:eport}}suppress constraints display above the coefficient
table{p_end}
{synopt:{opt noomit:ted}}suppress display of omitted variables{p_end}
{synopt:{opt vsquish}}suppress blank space separating factor-variable terms or
          time-series-operated variables from other variables{p_end}
{synopt:{opt noempty:cells}}suppress empty cells for interactions of factor variables{p_end}
{synopt:{opt base:levels}}report base levels of factor variables and
     interactions{p_end}
{synopt:{opt allbase:levels}}display all base levels of factor variables and
     interactions{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{marker eform_option}{...}
{synoptset 28}{...}
{synopthdr:eform_option}
{synoptline}
{synopt:{opth ef:orm(data types:string)}}display exponentiated coefficients;
column title is "string"{p_end}
{synopt:{opt ef:orm}}display exponentiated coefficients;
column title is "{cmd:exp(b)}"{p_end}
{synopt:{opt hr}}report hazard ratios{p_end}
{synopt:{opt shr}}report subhazard ratios{p_end}
{synopt:{opt ir:r}}report incidence-rate ratios{p_end}
{synopt:{opt or}}report odds ratios{p_end}
{synopt:{opt rr:r}}report relative-risk ratios{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt fweight}s, {opt aweight}s, {opt iweight}s, and {opt pweight}s are
allowed; see {help weight}.
With all but method lf, you must write your likelihood-evaluation program
carefully if {opt pweight}s are to be specified, and {opt pweight}s may not be
specified with method d0, d1, d1debug, d2, or d2debug. See Gould, Pitblado,
and Sribney (2006, chap. 4) for details.{p_end}
{p 4 6 2}
See {help estcom} for more capabilities of estimation commands.  To
redisplay results, type {cmd:ml display}.{p_end}


{title:Description}

{pstd}
{opt ml model} defines the current problem.

{pstd}
{opt ml clear} clears the current problem definition.  This command is
rarely used because when you type {opt ml model}, any previous
problem is automatically cleared.

{pstd}
{opt ml query} displays a description of the current problem.

{pstd}
{opt ml check} verifies that the log-likelihood evaluator you have written
works.  We strongly recommend using this command.

{pstd}
{opt ml search} searches for (better) initial values.  We recommend using
this command.

{pstd}
{opt ml plot} provides a graphical way of searching for (better) initial
values.

{pstd}
{opt ml init} provides a way to specify initial values.

{pstd}
{opt ml report} reports ln L's values, gradient, and
Hessian at the initial values or current parameter estimates.

{pstd}
{opt ml trace} traces the execution of the user-defined log-likelihood
evaluation program.

{pstd}
{opt ml count} counts the number of times the user-defined log-likelihood
evaluation program is called;  this command is seldom used.
{opt ml count clear} clears the counter.  {opt ml count on} turns on the
counter.  {opt ml count} without arguments reports the current values of the
counter.  {opt ml count off} stops counting calls.

{pstd}
{opt ml maximize} maximizes the likelihood function and reports
results.  Once {opt ml maximize} has successfully completed, the previously
mentioned {opt ml} commands may no longer be used unless {opt noclear} is
specified. {opt ml graph} and {opt ml display} may be used whether or not
{opt noclear} is specified.

{pstd}
{opt ml graph} graphs the log-likelihood values against the iteration number.

{pstd}
{opt ml display} redisplays results.

{pstd}
{opt ml footnote} displays a warning message when the model did not converge
within the specified number of iterations.

{pstd}
{opt ml score} creates new variables containing the equation-level
scores.  The variables generated by {cmd:ml score}
are equivalent to those generated by specifying the {cmd:score()} option of
{cmd:ml maximize} (and {cmd:ml model} ...{cmd:,} ... {cmd:maximize}).

{pstd}
{it:progname} is the name of a Stata program you write to evaluate the
log-likelihood function.

{pstd}
{it:funcname}{cmd:()} is the name of a Mata function you write to evaluate the
log-likelihood function.

{pstd}
In this documentation, {it:progname} and {it:funcname}{cmd:()} are referred to
as the user-written evaluator, the likelihood evaluator, or sometimes simply
as the evaluator.  The program you write is written in the style required by
the method you choose.  The methods are lf, d0, d1, d2, e1, e2, v1, and v2.
Thus, if you choose to use method lf, your program is called a method of lf
evaluator. {help mlmethod_11} shows outlines of evaluator programs for each of
these methods.

{pstd}
Several commands are helpful in writing a user-written evaluator for use
with {opt ml}.  See {help mleval_11} for details of the {opt mleval},
{opt mlsum}, {opt mlvecsum}, {opt mlmatsum}, and {opt mlmatbysum} commands if
your evaluator is a Stata program.
See {helpb moptimize_11##syn_stepall:moptimize_11}
for details on
{cmd:moptimize_util_sum()},
{cmd:moptimize_util_vecsum()},
{cmd:moptimize_util_matsum()}, and
{cmd:moptimize_util_matbysum()} functions if your evaluator is a Mata function.

{marker mlmode}{...}
{title:Options for use with ml model in interactive or noninteractive mode}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are robust to some kinds of misspecification, that allow
for intragroup correlation, and that are derived from asymptotic theory;
see {helpb vce_option:[R] {it:vce_option}}.

{pmore}
{cmd:vce(robust)}, {cmd:vce(cluster} {it:clustvar}{cmd:)}, {cmd:pweight},
and {cmd:svy} will work with method lf, e1, e2, v0, v1, and v2 evaluators;
all you need to do is specify them.

{pmore}
These options will not work with method d0, d1, or d2 evaluators,
and specifying these options will produce an error message.

{phang}
{cmd:constraints(}{it:{help numlist}} | {it:matname}{cmd:)}
specifies the linear constraints to be
applied during estimation.  {opt constraints(numlist)} specifies the
constraints by number. Constraints are defined using the {cmd:constraint}
command; see {manhelp constraint R}.  {opt constraint(matname)} specifies a
matrix that contains the constraints.

{phang}
{opt nocnsnotes} prevents notes from being displayed when constraints are
dropped.  A constraint will be dropped if it is inconsistent, contradicts
other constraints, or causes some other error when the constraint matrix is
being built.  Constraints are checked in the order in which they are specified.

{phang}
{opth "title(data types:string)"} specifies the title for the
estimation output when results are complete.

{phang}
{opt nopreserve} specifies that {cmd:ml} need not
ensure that only the estimation subsample is in memory when the user-written
likelihood evaluator is called.  {opt nopreserve} is irrelevant when you use
method lf.  See {bf:[R] ml} for more details.

{phang}
{opt collinear} specifies that {opt ml} not remove the collinear variables
within equations.  There is no reason to leave collinear
variables in place, but this option is of interest to programmers who, in
their code, have already removed collinear variables and do not want {cmd:ml}
to waste computer time checking again.

{phang}
{opt missing} specifies that observations containing variables with missing
values not be eliminated from the estimation sample.  There are two reasons
you might want to specify {cmd:missing}:

{pmore}
Programmers may wish to specify {cmd:missing} because, in other parts of their
code, they have already eliminated observations with missing values and do not
want {cmd:ml} to waste computer time looking again.

{pmore}
You may wish to specify {cmd:missing} if your model explicitly deals with
missing values.  Stata's {cmd:heckman} command is a good example of this.  In
such cases, there will be observations where missing values are allowed and
other observations where they are not -- where their presence should
cause the observation to be eliminated.  If you specify {cmd:missing}, it is
your responsibility to specify an {cmd:if} {it:exp} that eliminates the
irrelevant observations.

{phang}
{opt lf0(#k #ll)} is typically used by programmers.  It
specifies the number of parameters and log-likelihood value of the
constant-only model so that {cmd:ml} can report a likelihood-ratio test
rather than a Wald test.

{pmore}
Also see the {cmd:continue} option directly below.

{pmore}
If you specify {cmd:lf0()}, it must be safe for you to specify the
{cmd:missing} option, too, else how did you calculate the log likelihood for
the constant-only model on the same sample?  You must have identified the
estimation sample, and done so correctly, so there is no reason for {cmd:ml}
to waste time rechecking your results.  All of which is to say, do not specify
{cmd:lf0()} unless you are certain your code identifies the estimation sample
correctly.

{pmore}
{cmd:lf0()}, even if specified, is ignored if {cmd:vce(robust)},
{cmd:vce(cluster} {it:clustvar}{cmd:)}, {cmd:pweight}, or {cmd:svy} is
specified because, in that case, a likelihood-ratio test would be
inappropriate.

{phang}
{opt continue} is typically specified by programmers and does two things:

{pmore}
First, it specifies that a model has just been fit by either {opt ml} or some
other estimation command, such as {helpb logit}, and that the likelihood value
stored in {cmd:e(ll)} and the number of parameters stored in {cmd:e(b)} as of
that instant are the relevant values of the constant-only model.  The current
value of the log likelihood is used to present a likelihood-ratio test unless
{cmd:vce(robust)}, {cmd:vce(cluster} {it:clustvar}{cmd:)}, {opt pweight},
{opt svy}, or {opt constraints()} is specified.  A likelihood-ratio test is
inappropriate when {cmd:vce(robust)}, {cmd:vce(cluster} {it:clustvar}{cmd:)},
{opt pweight}, or {opt svy} is specified.  We suggest using {helpb lrtest}
when {opt constraints()} is specified.

{pmore}
Second, {opt continue} sets the initial values b_0 for the model about to
be fit according to the {cmd:e(b)} currently stored.

{pmore}
The comments made about specifying {cmd:missing} with {cmd:lf0()} apply
equally well here.

{phang}
{opt waldtest(#)} is typically specified by programmers.  By
default, {opt ml} presents a Wald test, but that is overridden if the 
{opt lf0()} or {opt continue} option is specified.  A Wald test is performed if
{cmd:vce(robust)}, {cmd:vce(cluster} {it:clustvar}{cmd:)}, or {opt pweight}
is specified.

{pmore}
{cmd:waldtest(0)} prevents even the Wald test from being reported.

{pmore}
{cmd:waldtest(-1)} is the default.  It specifies that a Wald test be performed
by constraining all coefficients except the intercept to 0 in the first
equation.  Remaining equations are to be unconstrained. 
A Wald test is performed if neither {cmd:lf0()} nor {opt continue} was
specified, and a Wald test is forced if {cmd:vce(robust)},
{cmd:vce(cluster} {it:clustvar}{cmd:)}, or {opt pweight} was specified.

{pmore}
{opt waldtest(k)} for {it:k} {ul:<} -1 specifies that a Wald test be 
performed by constraining all coefficients except intercepts to 0 in the first
|{it:k}| equations; remaining equations are to be unconstrained.  A Wald test
is performed if neither {cmd:lf0()} nor {opt continue} was specified, and a
Wald test is forced if {cmd:vce(robust)},
{cmd:vce(cluster} {it:clustvar}{cmd:)}, or {opt pweight} was specified.

{pmore}
{opt waldtest(k)} for {it:k} {ul:>} 1 works like the options above, except
that it forces a Wald test to be reported even if the information to perform
the likelihood-ratio test is available and even if none of {cmd:vce(robust)},
{cmd:vce(cluster} {it:clustvar}{cmd:)}, or {opt pweight} was specified.
{opt waldtest(k)}, {it:k} {ul:>} 1, may not be specified with {opt lf0()}.

{phang}
{opt obs(#)} is used mostly by programmers.  It specifies that the number of
observations reported and ultimately stored in {cmd:e(N)} be {it:#}.
Ordinarily, {opt ml} works that out for itself.  Programmers may want to
specify this option when, for the likelihood evaluator to work for N
observations, they first had to modify the dataset so that it contained a
different number of observations.

{phang}
{opth "crittype(data types:string)"} is used mostly by programmers.  It allows
programmers to supply a string (up to 32 characters long) that describes the
criterion that is being optimized by {cmd:ml}.  The default is
{cmd:"log likelihood"} for nonrobust and {cmd:"log pseudolikelihood"} for
robust estimation.

{phang}
{opt svy} indicates that {cmd:ml} is to pick up the {opt svy} settings set
by {cmd:svyset} and use the robust variance estimator.  This option
requires the data to be {helpb svyset}.  {opt svy} may
not be specified with {cmd:vce()} or {help weight}s.

{phang}
{opth subpop(varname)} specifies that estimates be computed
for the single subpopulation 
defined by the observations for which {it:varname} != 0.  Typically,
{it:varname} = 1 defines the subpopulation and {it:varname} = 0 indicates
observations not belonging to the subpopulation.  For observations whose
subpopulation status is uncertain, {it:varname} should be set to missing
('.').  This option requires the {opt svy} option.

{phang}
{opt nosvyadjust} specifies that the model Wald test be carried out as W/k
distributed F(k,d), where W is the Wald test statistic, k is the number of
terms in the model excluding the constant term, d is the total number of
sampled PSUs minus the total number of strata, and F(k,d) is an F distribution
with k numerator degrees of freedom and d denominator degrees of freedom.  By
default, an adjusted Wald test is conducted:  (d-k+1)W/(kd) distributed
F(k,d-k+1).  See Korn and Graubard (1990) for a discussion of the Wald test
and the adjustments thereof. This option requires the {opt svy} option.

{phang}
{opt technique(algorithm_spec)} specifies how the likelihood function is to be
maximized.  The following algorithms are currently implemented in {cmd:ml}.
For details, see Gould, Pitblado, and Sribney (2006).

{pmore}
{cmd:technique(nr)} specifies Stata's modified Newton-Raphson (NR) algorithm.

{pmore}
{cmd:technique(bhhh)} specifies the Berndt-Hall-Hall-Hausman (BHHH) algorithm.

{pmore}
{cmd:technique(dfp)} specifies Davidon-Fletcher-Powell (DFP) algorithm.

{pmore}
{cmd:technique(bfgs)} specifies the Broyden-Fletcher-Goldfarb-Shanno (BFGS)
algorithm.

{pmore}
The default is {cmd:technique(nr)}.

{pmore}
You can switch between algorithms by specifying more than one in the
{opt technique()} option.  By default, {cmd:ml} will use an algorithm for five
iterations before switching to the next algorithm.  To specify a different
number of iterations, include the number after the technique in the option.
For example, specifying {cmd:technique(bhhh 10 nr 1000)} requests that
{cmd:ml} perform 10 iterations using the BHHH algorithm, followed by 1,000
iterations using the NR algorithm, and then switch back to BHHH for 10
iterations, and so on.  The process continues until convergence or until
reaching the maximum number of iterations.


{title:Options for use with ml model in noninteractive mode}

{pstd}
The following extra options are for use with {opt ml model} in
noninteractive mode.  Noninteractive mode is for programmers who use {opt ml}
as a subroutine and want to issue one command that will carry forth the
estimation from start to finish.

{phang}
{opt maximize} is required.  It specifies noninteractive mode.

{phang}
{opt init(ml_init_args)} sets the initial values, b_0.
{it:ml_init_args} are whatever you would type after the {opt ml init} command.

{phang}
{cmd:search(}{opt on}|{opt norescale}|{opt quietly}|{opt off}{cmd:)} specifies whether
{cmd:ml search} is to be used to improve the initial values.  {cmd:search(on)}
is the default and is equivalent to separately running
{cmd:ml search, repeat(0)}.  {cmd:search(norescale)} is equivalent to
separately running {cmd:ml search, repeat(0) norescale}.
{cmd:search(quietly)} is equivalent to {cmd:search(on)}, except that it
suppresses {cmd:ml search}'s output.  {cmd:search(off)} prevents calling
{cmd:ml search}.

{phang}
{opt repeat(#)} is {opt ml search}'s {opt repeat()} option.  {cmd:repeat(0)}
is the default.

{phang}
{opt bounds(ml_search_bounds)} specifies the search bounds.  The 
{opt ml model} command issues
{opt ml search} {it:ml_search_bounds}{opt , repeat(#)}.  Specifying search
bounds is optional.

{phang}
{opt nowarning}, {opt novce}, {opt negh}, and {opt score()} are {opt ml maximize}'s
equivalent options.

{phang}{marker noninteractive_maxopts}
{it:maximize_options}:
{opt dif:ficult},
{opt tech:nique(algorithm_spec)},
{opt iter:ate(#)},
[{cmdab:no:}]{opt lo:g},
{opt tr:ace},
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance},
{opt from(init_specs)}; see {manhelp maximize R}.  These options are seldom
used.


{title:Options for use when specifying equations}

{phang}
{opt noconstant} specifies that the equation not include an intercept.

{phang}
{opth "offset(varname:varname_o)"} specifies that the equation be
xb + {it:varname_o} -- that it include {it:varname_o} with
coefficient constrained to be 1.

{phang}
{opth "exposure(varname:varname_e)"} is an alternative to
{opt offset(varname_o)}; it specifies that the equation be xb +
ln({it:varname_e}).  The equation is to include ln({it:varname_e}) with
coefficient constrained to be 1.


{title:Options for use with ml search}

{phang}
{opt repeat(#)} specifies the number of random attempts that
are to be made to find a better initial-value vector.  The default is
{cmd:repeat(10)}.

{pmore}
{cmd:repeat(0)} specifies that no random attempts be made.
More precisely, {cmd:repeat(0)} specifies that no random attempts be made if
the first initial-value vector is a feasible starting point.  If not,
{opt ml search} will make random attempts, even if you specify
{cmd:repeat(0)}, because it has no alternative.  The {opt repeat()} option
refers to the number of random attempts to be made to improve the initial
values.  When the initial starting value vector is not feasible,
{opt ml search} will make up to 1,000 random attempts to find starting values.
It stops when it finds one set of values that works and then moves into
its improve-initial-values logic.

{pmore}
{opt repeat(k)}, {it:k} > 0, specifies the number of random attempts to be made to
improve the initial values.

{phang}
{opt restart} specifies that random actions be taken to obtain
starting values and that the resulting starting values not be a
deterministic function of the current values.  Generally,
you should not specify this option because, with {cmd:restart}, {cmd:ml search}
intentionally does not produce as good a set of starting values as it could.
{opt restart} is included for use by the optimizer when it gets into serious
trouble.  The random actions ensure that the optimizer and
{cmd:ml search}, working together, do not cause an endless loop.

{pmore}
{cmd:restart} implies {cmd:norescale}, which is why we recommend that you do
not specify {cmd:restart}.  In testing, sometimes {cmd:rescale} worked so well
that, even after randomization, the rescaler would bring the starting values
right back to where they had been the first time and thus defeat the intended
randomization.

{phang}
{opt norescale} specifies that {opt ml search} not engage in its
rescaling actions to improve the parameter vector.  We do not recommend
specifying this option because rescaling tends to work so well.

{phang}{marker search_maxopts}
{it:maximize_options}:
[{cmdab:no:}]{cmdab:lo:g},
{opt tr:ace};
see {manhelp maximize R}.  These options are seldom used.


{title:Option for use with ml plot}

{phang}
{helpb saving_option:saving({it:filename}[, replace])} specifies that the
graph be saved in {it:filename}{cmd:.gph}.


{title:Options for use with ml init}

{phang}
{opt copy} specifies that the list of numbers or the initialization
vector be copied into the initial-value vector by position rather than
by name.

{phang}
{opt skip} specifies that any parameters found in the specified
initialization vector that are not also found in the model be ignored.
The default action is to issue an error message.


{title:Options for use with ml maximize}

{phang}
{opt nowarning} is allowed only with {cmd:iterate(0)}.  {opt nowarning}
suppresses the "convergence not achieved" message.
Programmers might specify {cmd:iterate(0) nowarning} when they have a vector b
already containing the final estimates and want {opt ml} to calculate the
variance matrix and post estimation results.  Then specify
{bind:{cmd:init(b) search(off) iterate(0) nowarning nolog}}.

{phang}
{opt novce} is allowed only with {cmd:iterate(0)}.  {opt novce}
substitutes the zero matrix for the variance matrix, which in effect posts
estimation results as fixed constants.

{phang}
{opt negh} indicates that the evaluator returns the negative Hessian
matrix.  By default, {cmd:ml} assumes d2, e2, and v2 evaluators return the
Hessian matrix.

{phang}
{cmd:score(}{it:{help newvar:newvars}} | {it:stub}{cmd:*}{cmd:)}
creates new variables containing the contributions to the score for each
equation and ancillary parameter in the model; see
{findalias frscore}.

{pmore}
If {opt score(newvars)} is specified, the {it:newvars} must contain k
new variables, one for each equation in the model.  If
{cmd:score(}{it:stub}{cmd:*)} is
specified, variables named {it:stub}{cmd:1}, {it:stub}{cmd:2}, {it:...},
{it:stub}{cmd:k} are created.

{pmore}
The first variable contains {bind:d(ln L_j)/d(x_1j b_1)}, the second variable
contains {bind:d(ln L_j)/d(x_2j b_2)}, and so on.

{phang}
{opt nooutput} suppresses display of results.  This option is
different from prefixing {opt ml maximize} with {opt quietly} in that the
iteration log is still displayed (assuming that {opt nolog} is not specified).

{phang}
{opt noclear} specifies that the ml problem definition not be cleared after
the model has converged.  Perhaps you are having convergence
problems and intend to run the model to convergence.  If so, use {opt ml search}
to see if those values can be improved, and then restart the estimation.

{phang}{marker ml_maxopts}
{it:maximize_options}:
{opt dif:ficult},
{opt iter:ate(#)},
[{cmdab:no:}]{opt lo:g},
{opt tr:ace},
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance}; see {manhelp maximize R}.  These options are seldom used.

{phang}
{it:display_options}; see
{help ml_11##mldisplay:Options for use with ml display}.

{phang}
{it:eform_option}; see
{help ml_11##mldisplay:Options for use with ml display}.


{title:Option for use with ml graph}

{phang}
{helpb saving_option:saving({it:filename}[, replace])} specifies that
the graph be saved in {it:filename}{cmd:.gph}.


{marker mldisplay}{...}
{title:Options for use with ml display}

{phang}
{opt noheader} suppresses the header display above the coefficient
table that displays the final log-likelihood value, the number of
observations, and the model significance test.

{phang}
{opt nofootnote} suppresses the footnote display below the coefficient
table, which displays a warning if the model fit did not converge within
the specified number of iterations.  Use {cmd:ml} {cmd:footnote} to display
the warning if 1) you add to the coefficient table by using the {cmd:plus}
option or 2) you have your own footnotes and want the warning to be last.

{phang}
{opt level(#)} is the standard confidence-level option.  It
specifies the confidence level, as a percentage, for confidence intervals of the
coefficients.  The default is {cmd:level(95)} or as set by {opt set level};
see {manhelp level R}.

{phang}
{opt first} displays a coefficient table reporting results for the
first equation only, and the report makes it appear that the first equation is
the only equation.  This option is used by programmers who estimate ancillary
parameters in the second and subsequent equations and who wish to report the values
of such parameters themselves.

{phang}
{opt neq(#)} is an alternative to {opt first}.
{opt neq(#)} displays a coefficient table reporting results for
the first {it:#} equations.  This
option is used by programmers who estimate ancillary
parameters in the {it:#}+1 and subsequent equations and who wish to report the
values of such parameters themselves.

{phang}
{opt showeqns} is a seldom-used option that displays the equation names
in the coefficient table.  {cmd:ml} {cmd:display} uses the numbers
stored in {cmd:e(k_eq)} and {cmd:e(k_aux)} to determine how to display the
coefficient table.  {cmd:e(k_eq)} identifies the number of equations and
{cmd:e(k_aux)} identifies how many of these are for ancillary parameters.
The {opt first} option is implied when {opt showeqns} is not specified and all
but the first equation are for ancillary parameters.

{phang}
{opt plus} displays the coefficient table and
ends it in dashes{c -}plus-sign{c -}dashes rather than just dashes.  This
is so that programmers can write additional display code to add more results
to the table and make it appear as if the combined result is one table.
Programmers typically specify {cmd:plus} with the {opt first} or
{opt neq()} options.  This option implies {cmd:nofootnote}.

{phang}
{opt nocnsreport} suppresses the display of constraints above the coefficient
table.  This option is ignored if constraints were not used to fit the model.

{phang}
{opt noomitted} specifies that variables that were omitted because of
collinearity not be displayed.  The default is to include in the table
any variables omitted because of collinearity and to label them as "(omitted)".

{phang}
{opt vsquish} specifies that the blank space separating factor-variable
          terms or time-series-operated variables from other variables
          in the model be suppressed.

{phang}
{opt noemptycells} specifies that empty cells for interactions of factor
variables not be displayed.  The default is to include in the table interaction
cells that do not occur in the estimation sample and to label them as
"(empty)".

{phang}
{opt baselevels} and {opt allbaselevels} control whether the base levels of
factor variables and interactions are displayed.  The default is to exclude
from the table all base categories. 

{phang2}
        {opt baselevels} specifies that base levels be reported for factor
                variables and for interactions whose bases cannot be inferred
                from their component factor variables.

{phang2}
        {opt allbaselevels} specifies that all base levels of factor variables
                and interactions be reported.

{phang}
{opt coeflegend} specifies that the legend of the coefficients and how to
              specify them in an expression be displayed rather than
              displaying the statistics for the coefficients.

{phang}
{it:eform_option}: {opth "eform(data types:string)"}, {opt eform}, {opt hr},
{opt shr}, {opt irr}, {opt or}, and
{opt rrr} display the coefficient table in exponentiated form:
for each coefficient, exp({it:b}) rather than {it:b} is displayed, and standard
errors and confidence intervals are transformed.  Display of the intercept, if
any, is suppressed.  {it:string} is the table header that will be displayed
above the transformed coefficients and must be 11 characters or
shorter in length -- for example, {cmd:eform("Odds ratio")}.
The options {opt eform}, {opt hr}, {opt shr}, {opt irr}, {opt or}, and {opt rrr}
provide a default {it:string} equivalent to {cmd:"exp(b)"}, {cmd:"Haz.  Ratio"},
{cmd:"SHR"}, {cmd:"IRR"}, {cmd:"Odds Ratio"}, and {cmd:"RRR"}, respectively.
These options may not be combined.

{pmore}
{cmd:ml} {cmd:display} looks at {cmd:e(k_eform)} to determine how many
equations are affected by an {it:eform_option}; by default, only the first
equation is affected.


{title:Examples}

{pstd}
See {bf:[R] ml} for examples.  More examples are available in
Gould, Pitblado, and Sribney (2006) -- available from StataCorp.


{title:Saved results}

{pstd}
For results saved by {cmd:ml} without the {cmd:svy} options, see
{manhelp maximize R}.

{pstd}
For results saved by {cmd:ml} with the {cmd:svy} options, see
{manhelp svy SVY}.


{title:References}

{phang}
Gould, W. W., J. Pitblado, and W. M. Sribney. 2006. 
{browse "http://www.stata.com/bookstore/mle.html":{it:Maximum Likelihood Estimation with Stata}. 3rd ed.} College Station, TX: Stata Press.

{phang}
Korn, E. L., and B. I. Graubard. 1990.
Simultaneous testing of regression coefficients with complex survey
data: Use of Bonferroni t statistics.
{it:American Statistician} 44: 270-276.


{title:Also see}

{psee}
Manual:
{manlink R ml}

{psee}
{space 2}Help:  
{manhelp maximize R},
{helpb ml score},
{help mleval_11},
{manhelp nl R},
{help moptimize_11},
{help optimize_11}
{p_end}
