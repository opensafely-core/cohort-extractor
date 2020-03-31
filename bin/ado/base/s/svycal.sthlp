{smcl}
{* *! version 1.0.1  11oct2017}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{vieweralsosee "[SVY] svyset" "help svyset"}{...}
{viewerjumpto "Syntax" "svycal##syntax"}{...}
{viewerjumpto "Description" "svycal##description"}{...}
{viewerjumpto "Options" "svycal##options"}{...}
{viewerjumpto "Examples" "svycal##examples"}{...}
{viewerjumpto "References" "svycal##references"}{...}
{title:Title}

{p 4 22 2}
{hi:[SVY] svycal} {hline 2} Calibration-adjusted sampling weights


{marker syntax}{...}
{title:Syntax}

{pstd}
Linear-regression-adjusted sampling weights

{p 8 15 2}
{cmd:svycal} {cmd:regress}
	{varlist} {weight} {ifin}
	{cmd:,}
		{opth gen:erate(newvar)} 
		{opth tot:als(svycal##spec:spec)}
		[{opt nocons:tant}
			{opt ll(#)}
			{opt ul(#)}
			{opt iter:ate(#)}
			{opt tol:erance(#)}
			{opt force}]


{pstd}
Raking-ratio-adjusted sampling weights

{p 8 15 2}
{cmd:svycal} {cmd:rake}
	{varlist} {weight} {ifin}
	{cmd:,}
		{opth gen:erate(newvar)} 
		{opth tot:als(svycal##spec:spec)}
		[{opt nocons:tant}]


{pstd}
{varlist} may contain factor variables; see {help fvvarlist}.
{p_end}
{pstd}
{opt pweight}s and {opt iweight}s are allowed; see {help weights}.
{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:svycal} generates calibration-adjusted weights for survey data
analysis.

{pstd}
{cmd:svycal} {cmd:regress} generates sampling weights that are adjusted
according to an additive (linear) distance measure.

{pstd}
{cmd:svycal} {cmd:rake} generates sampling weights that are adjusted
according to a multiplicative distance measure.


{marker options}{...}
{title:Options}

{phang}
{opth generate(newvar)} specifies the name of a new variable
in which to put the adjusted sampling weights.  {opt generate()} is required.

{marker spec}{...}
{phang}
{opt totals(spec)} specifies the population totals corresponding to the
variables specified in {varlist}.  {it:spec} is one of

{p 12 20 2}{it:matname} [{cmd:,} {cmd:skip} {cmd:copy}]{p_end}

{p 12 20 2}{c -(} [{it:eqname}{cmd::}]{it:name} {cmd:=} {it:#} |
	{cmd:/}{it:eqname} {cmd:=} {it:#} {c )-} [{it:...}]{p_end}

{p 12 20 2}{it:#} [{it:#} {it:...}]{cmd:,} {cmd:copy}{p_end}

{pmore}
That is, {it:spec} may be a matrix name,
for example, {bf:totals(poptotals)};
a list of variable names in {it:varlist} with their
population totals,
for example, {bf:totals(_cons=1300 dogs=850 cats=450)};
or a list of values,
for example, {bf:totals(850 450 1300)}.

{phang2}
{opt skip} specifies that any parameters found in the specified initialization
vector that are not also found in the model be ignored.  The default action is
to issue an error message.

{phang2}
{opt copy} specifies that the list of values or the initialization
vector be copied into the initial-value vector by position rather than
by name.

{phang}
{opt noconstant} prevents {cmd:svycal} from including an intercept in the
calibration calculations.

{phang}
{opt ll(#)} specifies a lower limit for the weight ratios.

{phang}
{opt ul(#)} specifies an upper limit for the weight ratios.

{phang}
{opt iterate(#)} specifies the maximum number of iterations.
When the number of iterations equals {cmd:iterate()}, the calibration
adjustment stops and presents a note.
The default is {cmd:iterate(1000)}.

{phang}
{opt tolerance(#)} specifies the tolerance for the Lagrange multiplier in the
calibration equations.
Convergence is achieved when the relative change in the Lagrange
multiplier from one iteration to the next is less than or equal to
{cmd:tolerance()}.
The default is {cmd:tolerance(1e-7)}.

{phang}
{opt force} prevents {cmd:svycal} from exiting with an error if the
calibration adjustment fails to converge.


{marker examples}{...}
{title:Examples}

{phang}
Poststratification adjustment: population totals in a matrix
{p_end}

{phang2}
{cmd:. webuse poststrata}
{p_end}
{phang2}
{cmd:. matrix poptotals = 1300, 850, 450}
{p_end}
{phang2}
{cmd:. matrix colnames poptotals = _cons 1.type 2.type}
{p_end}
{phang2}
{cmd:. svycal regress i.type [pw=weight], generate(adj_weight) totals(poptotals)}
{p_end}

{phang}
Poststratification adjustment: population totals using key-value pairs
{p_end}

{phang2}
{cmd:. webuse poststrata}
{p_end}
{phang2}
{cmd:. svycal regress i.type [pw=weight], generate(adj_weight) totals(_cons=1300 1.type=850 2.type=450)}
{p_end}

{phang}
Poststratification adjustment: population totals using a list of values
{p_end}

{phang2}
{cmd:. webuse poststrata}
{p_end}
{phang2}
{cmd:. svycal regress i.type [pw=weight], generate(adj_weight) totals(850 450 1300, copy)}
{p_end}


{marker references}{...}
{title:References}

{marker D1992}{...}
{phang}
Deville, J.-C., and C.-E. Sarndal.  1992.  Calibration estimators
in survey sampling.
{it:Journal of the American Statistical Association} 87: 376-382.
{p_end}

{marker D1993}{...}
{phang}
Deville, J.-C., C.-E. Sarndal, and O. Sautory.  1993.  Generalized raking
procedures in survey sampling.
{it:Journal of the American Statistical Association} 88: 1013-1020.
{p_end}

{marker V2002}{...}
{phang}
Valliant, R.  2002.  Variance estimation for the general regression
estimator.  {it:Survey} {it:Methodology} 28: 103-114.
{p_end}
