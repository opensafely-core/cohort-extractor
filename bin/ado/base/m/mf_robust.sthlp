{smcl}
{* *! version 1.0.6  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _robust" "help _robust"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Mathematical" "help m4_mathematical"}{...}
{viewerjumpto "Syntax" "mf_robust##syntax"}{...}
{viewerjumpto "Description" "mf_robust##description"}{...}
{viewerjumpto "Remarks" "mf_robust##remarks"}{...}
{viewerjumpto "Conformability" "mf_robust##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_robust##diagnostics"}{...}
{viewerjumpto "Source code" "mf_robust##source"}{...}
{title:Title}

{phang}
{bf:[M-5] robust()} {hline 2} Robust variance estimates


{marker syntax}{...}
{title:Syntax}

{pstd}
{it:Initialization}

{p 19 8 2}
{it:R} 
{cmd:=}
{cmd:robust_init()}


{pstd}
{it:Estimation sample and subpopulation specifications}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_touse(}{it:R}{cmd:,} {it:touse}{cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_subpop(}{it:R}{cmd:,} {it:subpop}{cmd:)}


{pstd}
{it:Model specification}

{pmore}
Note:  In all the following {cmd:robust_init_}{it:*}{cmd:()} functions, the last
argument is optional.  Not specifying this argument causes the current,
unchanged setting to be returned.

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_scores(}{it:R}{cmd:,} {it:S}{cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_covmat(}{it:R}{cmd:,} {it:D}{cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_eq_n(}{it:R}{cmd:,} {it:neq}{cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_eq_indepvars(}{it:R}{cmd:,} {it:i}{cmd:,} {it:X}{cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_eq_cons(}{it:R}{cmd:,} {it:i}{cmd:,}
{c -(} {cmd:"on"} | {cmd:"off"} {c )-} {cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_minus(}{it:R}{cmd:,} {it:m}{cmd:)}


{pstd}
{it:Sampling design specification}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_svyset(}{it:R}{cmd:,}
{c -(} {cmd:"off"} | {cmd:"on"} {c )-} {cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_nstages(}{it:R}{cmd:,} {it:K}{cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_stage_units(}{it:R}{cmd:,}
{it:k}{cmd:,} {it:units}{cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_stage_strata(}{it:R}{cmd:,}
{it:k}{cmd:,} {it:strata}{cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_stage_fpc(}{it:R}{cmd:,}
{it:k}{cmd:,} {it:fpc}{cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_weight(}{it:R}{cmd:,} {it:w}{cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_weighttype(}{it:R}{cmd:,}
{c -(}
	{cmd:""} |
	{cmd:"pweight"} |{break}
	{cmd:"fweight"} |
	{cmd:"aweight"}
{c )-} {cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_poststrata(}{it:R}{cmd:,} {it:P}{cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_singleunit(}{it:R}{cmd:,} {it:singleunit}{cmd:)}


{pstd}
{it:Miscellaneous settings}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_V_srs(}{it:R}{cmd:,}
{c -(} {cmd:"off"} | {cmd:"on"} {c )-} {cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:robust_init_verbose(}{it:R}{cmd:,}
{c -(} {cmd:"on"} | {cmd:"off"} {c )-} {cmd:)}


{pstd}
{it:Variance computation}

{p 8 25 2}
{it:real matrix}{bind:   }
{cmd:robust(}{it:R}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:  }
{cmd:_robust(}{it:R}{cmd:)}


{pstd}
{it:Results}

{p 8 25 2}
{it:real matrix}{bind:   }
{cmd:robust_result_V(}{it:R}{cmd:)}

{p 8 25 2}
{it:real matrix}{bind:   }
{cmd:robust_result_V_srs(}{it:R}{cmd:)}

{p 8 25 2}
{it:real matrix}{bind:   }
{cmd:robust_result_V_srssub(}{it:R}{cmd:)}

{p 8 25 2}
{it:real matrix}{bind:   }
{cmd:robust_result_V_srswr(}{it:R}{cmd:)}

{p 8 25 2}
{it:real matrix}{bind:   }
{cmd:robust_result_V_srswrsub(}{it:R}{cmd:)}

{p 8 25 2}
{it:real matrix}{bind:   }
{cmd:robust_result_stage_strata(}{it:R}{cmd:)}

{p 8 25 2}
{it:real matrix}{bind:   }
{cmd:robust_result_stage_certain(}{it:R}{cmd:)}

{p 8 25 2}
{it:real matrix}{bind:   }
{cmd:robust_result_stage_single(}{it:R}{cmd:)}

{p 8 25 2}
{it:real matrix}{bind:   }
{cmd:robust_result_postsize(}{it:R}{cmd:)}

{p 8 25 2}
{it:real matrix}{bind:   }
{cmd:robust_result_postsum(}{it:R}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:   }
{cmd:robust_result_N(}{it:R}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:   }
{cmd:robust_result_sum_w(}{it:R}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:   }
{cmd:robust_result_N_sub(}{it:R}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:   }
{cmd:robust_result_sum_wsub(}{it:R}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:   }
{cmd:robust_result_N_clust(}{it:R}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:   }
{cmd:robust_result_N_strata(}{it:R}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:   }
{cmd:robust_result_N_strata_omit(}{it:R}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:   }
{cmd:robust_result_census(}{it:R}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:   }
{cmd:robust_result_singleton(}{it:R}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:   }
{cmd:robust_result_errorcode(}{it:R}{cmd:)}

{p 8 25 2}
{it:string scalar}{bind: }
{cmd:robust_result_errortext(}{it:R}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:   }
{cmd:robust_result_returncode(}{it:R}{cmd:)}


{pstd}
{it:Query status of robust specification}

{p 8 25 2}
{it:void}{bind:          }
{cmd:robust_query(}{it:R}{cmd:)}


{pstd}
where {it:R}, if it is declared, should be declared

		{cmd:transmorphic} {it:R}


{pstd}
and where {it:singleunit}, optionally specified in
{cmd:robust_init_singleunit()}, is

{p2colset 16 32 34 2}{...}
{p2col :{it:singleunit}}Description{p_end}
{p2line}
{p2col :{cmd:"missing"}}return
	a robust matrix of zeros if there are strata with only one sampling
	unit{p_end}
{p2col :{cmd:"certainty"}}treat
	strata with only one sampling unit as certainty units{p_end}
{p2col :{cmd:"scaled"}}use a scale version of {cmd:"certainty"}{p_end}
{p2col :{cmd:"centered"}}center
	strata with only one sampling unit at the grand mean{p_end}
{p2line}
{p 16 32 2}
The default is {cmd:"missing"}.
{p2colreset}{...}


{pstd}
Arguments
{it:S},
{it:X},
{it:touse},
{it:units},
{it:strata},
{it:fpc},
{it:w}, and
{it:P}
are assumed to be real matrices (or views) of the appropriate dimension or
{it:string scalar}s identifying Stata variables.  A view matrix is generated
when these arguments identify Stata variables.  The Stata variable identified
by the {it:touse} setting (if one was specified) is used to auto-generate
the views.

{pstd}
The {it:subpop} argument is assumed to be a column vector with the correct
number of rows or a {it:string scalar} identifying the subpopulation
observations according to the {opt subpop()} option of the {helpb svy} prefix
command.

{pstd}
No copy of the matrix arguments to the {cmd:robust_init_}{it:*}{cmd:()}
functions is made; a pointer is stored in {it:R}, so any changes to the
specified matrix will be reflected from within {cmd:robust()} and the
{cmd:robust_result_}*{cmd:()} functions.


{marker description}{...}
{title:Description}

{pstd}
These functions compute a robust variance estimate based on equation-level
scores, a covariance matrix, and a sampling design.  Equation-level scores are
expanded according to the chain rule when equation-level predictor variables
are specified.  The sampling designs covered include simple random sampling
with and without replacement, clustered sampling, stratified sampling, and
complex survey designs consisting of multiple stages of clustered sampling
with stratification at any stage.

{pstd}
{cmd:robust_init()} begins the definition of a robust problem and returns
{it:R}, a problem-description handle that contains default values.

{pstd}
The 
{cmd:robust_init_}{it:*}{cmd:(}{it:R}{cmd:,} ...{cmd:)} functions then allow
you to modify those defaults.  You use these functions to describe your 
particular problem:  
to set the equations,
to set the equation-level scores,
to specify the covariance matrix,
to specify the sampling design, 
and the like.

{pstd}
{cmd:robust}{cmd:(}{it:R}{cmd:)}
then performs the robust variance calculations.

{pstd}
The {cmd:robust_result_}{it:*}{cmd:(}{it:R}{cmd:)} functions can then be
used to access the computed results.

{pstd}
Usually you would stop there.  In other cases, you could compute variance
estimates using a different sampling design.

{pstd}
Aside:

{pstd}
The {cmd:robust_init_}{it:*}{cmd:(}{it:R}{cmd:,} ...{cmd:)} functions have
two modes of operation.  Each has an optional argument that you specify to set
the value and that you omit to query the value.
For instance, the full syntax of
{cmd:robust_init_scores()} is

		{it:void}        {cmd:robust_init_scores(}{it:R}{cmd:,} {it:S}{cmd:)}

		{it:real matrix} {cmd:robust_init_scores(}{it:R}{cmd:)}

{pstd}
The first syntax sets the equation-level scores and returns nothing.
The second syntax returns a real matrix containing the specified
equation-level scores.

{pstd} All the {cmd:robust_init_}{it:*}{cmd:(}{it:R}{cmd:,}
...{cmd:)} functions work the same way.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help mf_robust##example1:Example}

	{help mf_robust##functions:Functions}
	    {help mf_robust##i_:robust_init()}
	    {help mf_robust##i_touse:robust_init_touse()}
	    {help mf_robust##i_subpop:robust_init_subpop()}
	    {help mf_robust##i_scores:robust_init_scores()}
	    {help mf_robust##i_covmat:robust_init_covmat()}
	    {help mf_robust##i_eq:robust_init_eq_n()}
	    {help mf_robust##i_eq:robust_init_eq_indepvars()}
	    {help mf_robust##i_eq:robust_init_eq_cons()}
	    {help mf_robust##i_minus:robust_init_minus()}
	    {help mf_robust##i_svyset:robust_init_svyset()}
		{help mf_robust##i_stages:robust_init_nstages()}
		{help mf_robust##i_stage:robust_init_stage_units()}
		{help mf_robust##i_stage:robust_init_stage_strata()}
		{help mf_robust##i_stage:robust_init_stage_fpc()}
		{help mf_robust##i_weights:robust_init_weight()}
		{help mf_robust##i_weights:robust_init_weighttype()}
		{help mf_robust##i_post:robust_init_poststrata()}
		{help mf_robust##i_single:robust_init_singleunit()}
	    {help mf_robust##i_V_srs:robust_init_V_srs()}
	    {help mf_robust##i_verbose:robust_init_verbose()}

	    {help mf_robust##robust:robust()}
	   {help mf_robust##_robust:_robust()}

	    {help mf_robust##r_V:robust_result_V()}
	    {help mf_robust##r_V_srs:robust_result_V_srs()}
	    {help mf_robust##r_V_srs:robust_result_V_srssub()}
	    {help mf_robust##r_V_srs:robust_result_V_srswr()}
	    {help mf_robust##r_V_srs:robust_result_V_srswrsub()}
	    {help mf_robust##r__N_strata:robust_result_stage_strata()}
	    {help mf_robust##r__N_strata:robust_result_stage_certain()}
	    {help mf_robust##r__N_strata:robust_result_stage_single()}
	    {help mf_robust##r__N_post:robust_result_postsize()}
	    {help mf_robust##r__N_post:robust_result_postsum()}
	    {help mf_robust##r_N:robust_result_N()}
	    {help mf_robust##r_N:robust_result_sum_w()}
	    {help mf_robust##r_N:robust_result_N_sub()}
	    {help mf_robust##r_N:robust_result_sum_wsub()}
	    {help mf_robust##r_N:robust_result_N_clust()}
	    {help mf_robust##r_N:robust_result_N_strata()}
	    {help mf_robust##r_N:robust_result_N_strata_omit()}
	    {help mf_robust##r_census:robust_result_census()}
	    {help mf_robust##r_singleton:robust_result_singleton()}
	    {help mf_robust##r_error:robust_result_errorcode()}
	    {help mf_robust##r_error:robust_result_errortext()}
	    {help mf_robust##r_error:robust_result_returncode()}

	    {help mf_robust##query:robust_query()}


{marker example1}{...}
{title:Example}

{pstd}
The robust variance functions may be used interactively.

{pstd}
Let's start by pulling some variables from the auto dataset into Mata:

	{cmd:: stata("sysuse auto")}
	
	{cmd:: st_view(y=., ., "price")}

	{cmd:: st_view(X=., ., "mpg")}

	{cmd:: st_view(strata=., ., "foreign")}

{pstd}
From within Mata, we fit a linear regression model of {cmd:y} ({cmd:price})
on {cmd:X} ({cmd:mpg}) and use {cmd:robust()} to compute a variance, assuming
the cars were sampled using stratified simple random sampling, where
{cmd:strata} ({cmd:foreign}) identifies our strata.

	{cmd:: D = invsym(cross(X, 1, X, 1))}

	{cmd:: b = D*cross(X, 1, y, 0)}

	{cmd:: e = y - X*b[1] :- b[2]}

	{cmd:: R = robust_init()}

	{cmd:: robust_init_scores(R, e)}

	{cmd:: robust_init_covmat(R, D)}

	{cmd:: robust_init_eq_indepvars(R, 1, X)}

	{cmd:: robust_init_stage_strata(R, 1, strata)}

	{cmd:: V = robust(R)}

	{cmd:: b, sqrt(diagonal(V))}
	{res}       {txt}           1              2
	    {c TLC}{hline 31}{c TRC}
	  1 {c |}  {res}-238.8943456    57.13929874{txt}  {c |}
	  2 {c |}  {res} 11253.06066     1375.65857{txt}  {c |}
	    {c BLC}{hline 31}{c BRC}

{pstd}
Here is the equivalent example using Stata variables:

	{it:Stata}

	{cmd:. regress price mpg, mse1}
	  ({it:output omitted})

	{cmd:. gen byte touse = e(sample)}

	{cmd:. predict double score, score}

	{it:Mata}

	{cmd:: b = st_matrix("e(b)")'}

	{cmd:: R = robust_init()}

	{cmd:: robust_init_touse(R, "touse")}

	{cmd:: robust_init_scores(R, "score")}

	{cmd:: robust_init_eq_indepvars(R, 1, "mpg")}

	{cmd:: robust_init_stage_strata(R, 1, "foreign")}

	{cmd:: robust_init_covmat(R, st_matrix("e(V)"))}

	{cmd:: V = robust(R)}

	{cmd:: b, sqrt(diagonal(V))}
	       {txt}           1              2
	    {c TLC}{hline 31}{c TRC}
	  1 {c |}  {res}-238.8943456    57.13929874{txt}  {c |}
	  2 {c |}  {res} 11253.06066     1375.65857{txt}  {c |}
	    {c BLC}{hline 31}{c BRC}


{marker functions}{...}
{title:Functions}

{marker i_}{...}
{title:robust_init()}

{p 8 30 2}
{it:transmorphic} 
{cmd:robust_init()}

{pstd}
{cmd:robust_init()} is used to begin a robust variance problem.  Store the
returned result in a variable name of your choosing; we have used 
{it:R} in this documentation.  You pass {it:R} 
as the first argument to the other {cmd:robust_}{it:*}{cmd:()} functions.

{pstd}
{cmd:robust_init()} sets all {cmd:robust_init_}{it:*}{cmd:()} values to
their defaults.  You may use the query form of
{cmd:robust_init_}{it:*}{cmd:()} to determine an individual default, or you
can use {cmd:robust_query()} to see them all.

{pstd}
The query form of {cmd:robust_init_}{it:*}{cmd:()} can be used before or after
calling {cmd:robust()}.


{marker i_touse}{...}
{title:robust_init_touse()}

{p 8 30 2}
{it:void}{bind:          }
{cmd:robust_init_touse(}{it:R}{cmd:,}
{it:touse}{cmd:)}

{p 8 30 2}
{it:real colvector}
{cmd:robust_init_touse(}{it:R}{cmd:)}

{pstd}
{cmd:robust_init_touse(}{it:R}{cmd:,} {it:touse}{cmd:)}
specifies the column vector or Stata variable that identifies the estimation
sample. If {it:touse} is a column vector, it is assumed to be a vector of 1s.
{cmd:robust()} will reset the values of {it:touse} to 0 for observations
within any omitted strata.

{pmore}
Technical note: If {it:touse} identifies a Stata variable, it will be used to
produce views from all Stata variables that were specified.

{pstd}
{cmd:robust_init_touse(}{it:R}{cmd:)} returns the vector that
identifies the estimation sample.
A 0 {it:x} 1 matrix is returned if nothing was specified.


{marker i_subpop}{...}
{title:robust_init_subpop()}

{p 8 30 2}
{it:void}{bind:          }
{cmd:robust_init_subpop(}{it:R}{cmd:,}
{it:subpop}{cmd:)}

{p 8 30 2}
{it:real colvector}
{cmd:robust_init_subpop(}{it:R}{cmd:)}

{pstd}
{cmd:robust_init_subpop(}{it:R}{cmd:,} {it:subpop}{cmd:)} specifies that
{it:subpop} identifies the subpopulation sample.

{pmore}
Technical note:
If {it:subpop} is a string, then it is interpreted like the {cmd:subpop()}
option of the {helpb svy} prefix command.  Here either
{cmd:robust_init_svyset()} should be set to {cmd:"on"} or the first-stage
design settings should be set using Stata variables.

{pstd}
{cmd:robust_init_subpop(}{it:R}{cmd:)}
returns the vector that identifies the subpopulation sample.
A 0 {it:x} 1 matrix is returned if nothing was specified.


{marker i_scores}{...}
{title:robust_init_scores()}

{p 8 30 2}
{it:void}{bind:          }
{cmd:robust_init_scores(}{it:R}{cmd:,} {it:S}{cmd:)}

{p 8 30 2}
{it:real matrix}{bind:   }
{cmd:robust_init_scores(}{it:R}{cmd:)}

{pstd}
{cmd:robust_init_scores(}{it:R}{cmd:,} {it:S}{cmd:)} specifies that the
equation-level scores are contained in {it:S}.
Each column of {it:S} corresponds to an equation.

{pmore}
	{cmd:robust()} uses the chain rule to expand equation-level scores
	out to parameter-level scores.  Use
	{cmd:robust_init_eq_n(}{it:R}{cmd:,} {it:dim}{cmd:)}
	without setting independent variables if you are specifying
	parameter-level scores instead; here {it:dim} is the number of columns
	in the scores matrix.

{pstd}
{cmd:robust_init_scores(}{it:R}{cmd:)} returns the specified scores matrix.
A 0 {it:x} 0 matrix is returned if nothing was specified.


{marker i_covmat}{...}
{title:robust_init_covmat()}

{p 8 30 2}
{it:void}{bind:       }
{cmd:robust_init_covmat(}{it:R}{cmd:,} {it:real matrix D}{cmd:)}

{p 8 30 2}
{it:real matrix}
{cmd:robust_init_covmat(}{it:R}{cmd:)}

{pstd}
{cmd:robust_init_covmat(}{it:R}{cmd:,} {it:D}{cmd:)} sets the covariance
matrix to be used in the robust variance calculation.

{pstd}
{cmd:robust_init_covmat(}{it:R}{cmd:)} returns the specified covariance
matrix.
A 0 {it:x} 0 matrix is returned if nothing was specified.


{marker i_eq}{...}
{title:robust_init_eq_n()}
{title:robust_init_eq_indepvars()}
{title:robust_init_eq_cons()}

{p 8 30 2}
{it:void}{bind:         }
{cmd:robust_init_eq_n(}{it:R}{cmd:,}
{it:neq}{cmd:)}

{p 8 30 2}
{it:void}{bind:         }
{cmd:robust_init_eq_indepvars(}{it:R}{cmd:,}
{it:i}{cmd:,}
{it:X}{cmd:)}

{p 8 30 2}
{it:void}{bind:         }
{cmd:robust_init_eq_cons(}{it:R}{cmd:,}
{it:i}{cmd:,}
{c -(} {cmd:"on"} | {cmd:"off"} {c )-} {cmd:)}

{p 8 30 2}
{it:real scalar}{bind:  }
{cmd:robust_init_eq_n(}{it:R}{cmd:)}

{p 8 30 2}
{it:real matrix}{bind:  }
{cmd:robust_init_eq_indepvars(}{it:R}{cmd:,}
{it:i}{cmd:)}

{p 8 30 2}
{it:string scalar}
{cmd:robust_init_eq_cons(}{it:R}{cmd:,}
{it:i}{cmd:)}

{pstd}
{cmd:robust_init_eq_n(}{it:R}{cmd:,} {it:neq}{cmd:)} sets the number of
linear equations.  This function is not actually necessary because the number
of linear equations is automatically updated as you set them by using the above
functions; however, the {cmd:robust_init_eq_}{it:*}{cmd:()} functions perform
more efficiently when you set the number of equations ahead of time.

{pstd}
{cmd:robust_init_eq_indepvars(}{it:R}{cmd:,} {it:i}{cmd:,} {it:X}{cmd:)}
specifies that the independent variables for the {it:i}th equation are
contained in {it:X}.

{pstd}
{cmd:robust_init_eq_cons(}{it:R}{cmd:,} {it:i}{cmd:,} {it:cons}{cmd:)}
specifies whether there is a constant term for the {it:i}th equation.
{it:cons}={cmd:"on"} means that the constant term is present; {cmd:"off"}
means there is no constant term.  {it:cons}={cmd:"on"} is the default.

{pstd}
{cmd:robust_init_eq_n(}{it:R}{cmd:)} returns the number of equations
that were specified.  Technically, this is the maximum between {it:neq} and the
largest {it:i} used to specify an equation.

{pstd}
{cmd:robust_init_eq_indepvars(}{it:R}{cmd:,} {it:i}{cmd:)} specifies the matrix
of independent variables for the {it:i}th equation.  A 0 {it:x} 0 matrix is
returned if nothing was specified.

{pstd}
{cmd:robust_init_eq_cons(}{it:R}{cmd:,} {it:i}{cmd:)} returns whether the
constant term is {cmd:"on"} or {cmd:"off"} for the {it:i}th equation.


{marker i_minus}{...}
{title:robust_init_minus()}

{p 8 30 2}
{it:void}{bind:       }
{cmd:robust_init_minus(}{it:R}{cmd:,} {it:m}{cmd:)}

{p 8 30 2}
{it:real scalar}
{cmd:robust_init_minus(}{it:R}{cmd:)}

{pstd}
{cmd:robust_init_minus(}{it:R}{cmd:,} {it:m}{cmd:)} specifies the value for
use in the multiplier {it:n}/({it:n}-{it:m}) of the robust variance estimator
(here {it:n} is the sample size).  The default is {it:m}=1.

{pstd}
{cmd:robust_init_minus(}{it:R}{cmd:)} returns the current value of {it:m}.


{marker i_svyset}{...}
{title:robust_init_svyset()}

{p 8 30 2}
{it:void}{bind:         }
{cmd:robust_init_svyset(}{it:R}{cmd:,}
{c -(} {cmd:"off"} | {cmd:"on"} {c )-} {cmd:)}

{p 8 30 2}
{it:string scalar}
{cmd:robust_init_svyset(}{it:R}{cmd:)}

{pstd}
{cmd:robust_init_svyset(}{it:R}{cmd:,} {it:svyset}{cmd:)}
specifies whether to grab the survey design settings from {helpb svyset}.
{it:svyset}={cmd:"on"} means to get the survey design settings from
{cmd:svyset}; {cmd:"off"} means not to get them.  {it:svyset}={cmd:"off"} is
the default.  Specifying {cmd:"on"} will cause {cmd:robust()} to replace the
survey design settings with those from the {cmd:svyset} command.

{pstd}
{cmd:robust_init_svyset(}{it:R}{cmd:)} returns the current settings for
grabbing the survey design settings from {cmd:svyset}.


{marker i_stages}{...}
{title:robust_init_nstages()}

{p 8 30 2}
{it:void}{bind:       }
{cmd:robust_init_nstages(}{it:R}{cmd:,} {it:K}{cmd:)}

{p 8 30 2}
{it:real scalar}
{cmd:robust_init_nstages(}{it:R}{cmd:)}

{pstd}
{cmd:robust_init_nstages(}{it:R}{cmd:,} {it:K}{cmd:)} sets the number of
stages in the sampling design.  This function is not actually necessary because
the number of stages is automatically updated as you use the
{cmd:robust_init_stage_}{it:*}{cmd:()} functions; however, the
{cmd:robust_init_stage_}{it:*}{cmd:()} functions perform more efficiently when
you set the number of sampling stages ahead of time.

{pstd}
{cmd:robust_init_nstages(}{it:R}{cmd:)} returns the number of sampling stages.
Technically, this is the maximum between {it:K} and the largest {it:k} used to
specify a stage.


{marker i_stage}{...}
{title:robust_init_stage_units()}
{title:robust_init_stage_strata()}
{title:robust_init_stage_fpc()}

{p 8 30 2}
{it:void}{bind:          }
{cmd:robust_init_stage_units(}{it:R}{cmd:,} {it:k}{cmd:,}
{it:units}{cmd:)}

{p 8 30 2}
{it:void}{bind:          }
{cmd:robust_init_stage_strata(}{it:R}{cmd:,} {it:k}{cmd:,}
{it:strata}{cmd:)}

{p 8 30 2}
{it:void}{bind:          }
{cmd:robust_init_stage_fpc(}{it:R}{cmd:,} {it:k}{cmd:,}
{it:fpc}{cmd:)}

{p 8 30 2}
{it:real colvector}
{cmd:robust_init_stage_units(}{it:R}{cmd:,} {it:k}{cmd:)}

{p 8 30 2}
{it:real colvector}
{cmd:robust_init_stage_strata(}{it:R}{cmd:,} {it:k}{cmd:)}

{p 8 30 2}
{it:real colvector}
{cmd:robust_init_stage_fpc(}{it:R}{cmd:,} {it:k}{cmd:)}

{pstd}
{cmd:robust_init_stage_units(}{it:R}{cmd:,} {it:k}{cmd:,} {it:units}{cmd:)}
specifies that {it:units} identifies the sampling units in the {it:k}th stage.

{pstd}
{cmd:robust_init_stage_strata(}{it:R}{cmd:,} {it:k}{cmd:,} {it:strata}{cmd:)}
specifies that {it:strata} identifies the strata in the {it:k}th stage.

{pstd}
{cmd:robust_init_stage_fpc(}{it:R}{cmd:,} {it:k}{cmd:,} {it:fpc}{cmd:)}
specifies that {it:fpc} contains the finite population correction (FPC)
information for the {it:k}th stage.

{pstd}
{cmd:robust_init_stage_units(}{it:R}{cmd:,} {it:k}{cmd:)}
returns the vector that identifies the sampling units in the {it:k}th stage.
A 0 {it:x} 1 matrix is returned if nothing was specified.

{pstd}
{cmd:robust_init_stage_strata(}{it:R}{cmd:,} {it:k}{cmd:)}
returns the vector that identifies the strata in the {it:k}th stage.
A 0 {it:x} 1 matrix is returned if nothing was specified.

{pstd}
{cmd:robust_init_stage_fpc(}{it:R}{cmd:,} {it:k}{cmd:)}
returns the vector containing the FPC information for the {it:k}th stage.
A 0 {it:x} 1 matrix is returned if nothing was specified.


{marker i_weights}{...}
{title:robust_init_weight()}
{title:robust_init_weighttype()}

{p 8 30 2}
{it:void}{bind:          }
{cmd:robust_init_weight(}{it:R}{cmd:,}
{it:w}{cmd:)}

{p 8 30 2}
{it:void}{bind:          }
{cmd:robust_init_weighttype(}{it:R}{cmd:,}
{c -(}
	{cmd:""} |
	{cmd:"pweight"} |{break}
	{cmd:"fweight"} |
	{cmd:"aweight"}
{c )-} {cmd:)}

{p 8 30 2}
{it:real colvector}
{cmd:robust_init_weight(}{it:R}{cmd:)}

{p 8 30 2}
{it:string scalar}{bind: }
{cmd:robust_init_weighttype(}{it:R}{cmd:)}

{pstd}
{cmd:robust_init_weight(}{it:R}{cmd:,} {it:w}{cmd:)} specifies that {it:w}
contains the weights used in the model fit that produced the scores.

{pstd}
{cmd:robust_init_weighttype(}{it:R}{cmd:,} {it:wtype}{cmd:)}
sets the weight type.
{it:wtype}={cmd:"pweight"} is the default.

{pstd}
{cmd:robust_init_weight(}{it:R}{cmd:)} returns the weight
vector.
A 0 {it:x} 1 matrix is returned if nothing was specified.

{pstd}
{cmd:robust_init_weighttype(}{it:R}{cmd:)} returns the weight type.


{marker i_post}{...}
{title:robust_init_poststrata()}

{p 8 30 2}
{it:void}{bind:       }
{cmd:robust_init_poststrata(}{it:R}{cmd:,}
{it:P}{cmd:)}

{p 8 30 2}
{it:real matrix}
{cmd:robust_init_poststrata(}{it:R}{cmd:)}

{pstd}
{cmd:robust_init_poststrata(}{it:R}{cmd:,} {it:P}{cmd:)}
sets the poststratification information.  {it:P} is assumed to have 2 columns or
specify 2 Stata variables: the first identifies the poststrata and the second
contains the poststratum weights.

{pmore}
Note: The poststratum weights must be constant within the poststrata.

{pstd}
{cmd:robust_init_poststrata(}{it:R}{cmd:)} returns a matrix containing the
poststratification information.
A 0 {it:x} 2 matrix is returned if nothing was specified.


{marker i_single}{...}
{title:robust_init_singleunit()}

{p 8 30 2}
{it:void}{bind:         }
{cmd:robust_init_singleunit(}{it:R}{cmd:,}
{it:singleunit}{cmd:)}

{p 8 30 2}
{it:string scalar}
{cmd:robust_init_singleunit(}{it:R}{cmd:)}

{pstd}
{cmd:robust_init_singleunit(}{it:R}{cmd:,} {it:singleunit}{cmd:)} specifies
how to handle strata with a single sampling unit.

{phang2}
{it:singleunit}={cmd:"missing"}
means to return a zero variance matrix, resulting in missing standard errors
when the variance matrix is {cmd:ereturn} {cmd:post}ed in Stata.  This is the
default behavior.

{phang2}
{it:singleunit}={cmd:"certainty"}
means to treat these strata as certainty units.

{phang2}
{it:singleunit}={cmd:"scaled"}
means to use a scaled version of the variance matrix where these strata were
treated as certainty units.

{phang2}
{it:singleunit}={cmd:"centered"}
means to center these strata at the grand mean instead of at the respective
stratum mean.

{pstd}
{cmd:robust_init_singleunit(}{it:R}{cmd:)} returns the current setting for
{it:singleunit}.


{marker i_V_srs}{...}
{title:robust_init_V_srs()}

{p 8 30 2}
{it:void}{bind:       }
{cmd:robust_init_V_srs(}{it:R}{cmd:,}
{c -(} {cmd:"off"} | {cmd:"on"} {c )-} {cmd:)}

{p 8 30 2}
{it:real scalar}
{cmd:robust_init_V_srs(}{it:R}{cmd:)}

{pstd}
{cmd:robust_init_V_srs(}{it:R}{cmd:,} {it:vsrs}{cmd:)}
sets whether to perform the extra variance calculations, assuming simple random
sampling.  {it:vsrs}={cmd:"on"} means to perform the extra variance
calculations; {cmd:"off"} means not to perform them.
{it:vsrs}={cmd:"off"} is the default.

{pstd}
{cmd:robust_init_V_srs(}{it:R}{cmd:)} returns the current setting for
{it:vsrs}.


{marker i_verbose}{...}
{title:robust_init_verbose()}

{p 8 25 2}
{it:void}{bind:        }
{cmd:robust_init_verbose(}{it:S}{cmd:,}
{c -(} {cmd:"on"} | {cmd:"off"} {c )-} {cmd:)}

{p 8 25 2}
{it:real scalar}{bind: }
{cmd:robust_init_verbose(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:robust_init_verbose(}{it:S}{cmd:,} {it:verbose}{cmd:)}
sets whether error messages that arise during the execution of {cmd:robust()}
or {cmd:_robust()} are to be displayed.  {it:verbose}={cmd:"on"} means that
they are displayed; {cmd:"off"} means that they are not displayed.  The default
is {cmd:"on"}.  Setting {it:verbose} to {cmd:"off"} is of interest only to
users of {cmd:_robust()}.

{p 4 4 2}
{cmd:robust_init_verbose(}{it:S}{cmd:)} returns 1 if {it:verbose} is
{cmd:"on"} and 0 if it is {cmd:"off"}.


{marker robust}{...}
{title:robust()}

{p 8 30 2}
{it:real matrix}
{cmd:robust(}{it:R}{cmd:)}

{pstd}
{cmd:robust(}{it:R}{cmd:)} invokes the robust variance calculations and
returns the resulting variance matrix.  If something goes wrong,
{cmd:robust()} aborts with error.

{pstd}
Before you can invoke {cmd:robust()}, you must have set the equation-level
scores and corresponding equations.

		{it:R} {cmd:= robust_init()}
		{cmd:robust_init_scores(}{it:R}{cmd:,} {it:scores}{cmd:)}
		{cmd:robust_init_eq_n(}{it:R}{cmd:, 1)}
		{cmd:robust_init_eq_indepvars(}{it:R}{cmd:,} {it:X1}{cmd:)}

{pstd}
You may have coded other {cmd:robust_init_}{it:*}{cmd:(}{it:R}{cmd:)}
functions as well, such as specifying a more complicated sampling design than
the default design (with-replacement simple random sampling).

{pstd}
Once {cmd:robust()} completes, you may use the
{cmd:robust_result_}{it:*}{cmd:(}{it:R}{cmd:)} functions.  You may also
continue to use the {cmd:robust_init_}{it:*}{cmd:(}{it:R}{cmd:)} functions to
access the initial settings, or you may change the settings and reinvoke
{cmd:robust()} if you wish.


{marker _robust}{...}
{title:_robust()}

{p 8 30 2}
{it:real scalar}
{cmd:_robust(}{it:R}{cmd:)}

{pstd}
{cmd:_robust(}{it:R}{cmd:)} performs the same actions as
{cmd:robust(}{it:R}{cmd:)} except that, rather than returning the resulting
variance matrix, {cmd:_robust()} returns a real scalar and, rather than
aborting if numerical issues arise, {cmd:_robust()} returns a nonzero value.
{cmd:_robust()} returns 0 if all went well.  The returned value is called an
error code.

{pstd}
{cmd:robust()} returns the robust variance matrix.  It can work that way
because the robust calculations must have gone well.  Had they not gone well,
{cmd:robust()} would have aborted execution.

{pstd}
{cmd:_robust()} returns an error code.  If it is 0, the robust calculations 
went well and you can obtain the resulting variance matrix by using
{bf:{help mf_robust##r_V:robust_result_V()}}.
If the calculations did not go well, you can use the error code to diagnose
what went wrong and take the appropriate action.

{p 4 4 2}
Programmers implementing advanced systems will want to use {cmd:_robust()}
instead of {cmd:robust()}.  Everybody else should use {cmd:robust()}.

{p 4 4 2}
Programmers using {cmd:_robust()} will also be interested in the 
functions 
{helpb mf_robust##i_verbose:robust_init_verbose()}, 
{helpb mf_robust##r_error:robust_result_errorcode()}, 
{helpb mf_robust##r_error:robust_result_errortext()},
and
{helpb mf_robust##r_error:robust_result_returncode()}.


{marker r_V}{...}
{title:robust_result_V()}

{p 8 30 2}
{it:real matrix}
{cmd:robust_result_V(}{it:R}{cmd:)}

{pstd}
{cmd:robust_result_V(}{it:R}{cmd:)} returns the robust variance matrix.


{marker r_V_srs}{...}
{title:robust_result_V_srs()}
{title:robust_result_V_srssub()}
{title:robust_result_V_srswr()}
{title:robust_result_V_srswrsub()}

{p 8 30 2}
{it:real matrix}
{cmd:robust_result_V_srs(}{it:R}{cmd:)}

{p 8 30 2}
{it:real matrix}
{cmd:robust_result_V_srssub(}{it:R}{cmd:)}

{p 8 30 2}
{it:real matrix}
{cmd:robust_result_V_srswr(}{it:R}{cmd:)}

{p 8 30 2}
{it:real matrix}
{cmd:robust_result_V_srswrsub(}{it:R}{cmd:)}

{pstd}
The {cmd:robust_result_V_srs}{it:*}{cmd:()} functions return extra variance
estimates requested a priori via {cmd:robust_init_V_srs(}{it:R}{cmd:, "on")}.
If {cmd:robust_init_V_srs(}{it:R}{cmd:, "on")} was not specified, these
functions return matrices filled with missing values.

{pstd}
{cmd:robust_result_V_srs(}{it:R}{cmd:)} returns the variance matrix, assuming
the data were collected using a without-replacement simple random sample
design.  The sampling weights should sum to the population size for the result
of this function to be meaningful.

{pstd}
{cmd:robust_result_V_srssub(}{it:R}{cmd:)} returns the subpopulation variance
matrix, assuming the subpopulation observations were collected using a
without-replacement simple random sample design.  The sampling weights within
the subpopulation sample should sum to the subpopulation size for the result
of this function to be meaningful.

{pstd}
{cmd:robust_result_V_srswr(}{it:R}{cmd:)} returns the variance matrix, assuming
the data were collected using a with-replacement simple random sample design.

{pstd}
{cmd:robust_result_V_srswrsub(}{it:R}{cmd:)} returns the subpopulation
variance matrix, assuming the data were collected using a with-replacement
simple random sample design.


{marker r__N_strata}{...}
{title:robust_result_stage_strata()}
{title:robust_result_stage_certain()}
{title:robust_result_stage_single()}

{p 8 30 2}
{it:real matrix}
{cmd:robust_result_stage_strata(}{it:R}{cmd:)}

{p 8 30 2}
{it:real matrix}
{cmd:robust_result_stage_certain(}{it:R}{cmd:)}

{p 8 30 2}
{it:real matrix}
{cmd:robust_result_stage_single(}{it:R}{cmd:)}

{pstd}
{cmd:robust_result_stage_strata(}{it:R}{cmd:)} returns a rowvector containing
the number of strata within each stage.

{pstd}
{cmd:robust_result_stage_certain(}{it:R}{cmd:)} returns a rowvector
containing the number of certainty strata within each stage.

{pstd}
{cmd:robust_result_stage_single(}{it:R}{cmd:)} returns a rowvector
containing the number of single unit strata within each stage.


{marker r__N_post}{...}
{title:robust_result_postsize()}
{title:robust_result_postsum()}

{p 8 30 2}
{it:real matrix}
{cmd:robust_result_postsize(}{it:R}{cmd:)}

{p 8 30 2}
{it:real matrix}
{cmd:robust_result_postsum(}{it:R}{cmd:)}

{pstd}
{cmd:robust_result_postsize(}{it:R}{cmd:)} returns a rowvector of the
poststratum sizes (the number of individuals in the populations that belong to
each poststratum).

{pstd}
{cmd:robust_result_postsum(}{it:R}{cmd:)} returns a rowvector of the sum of
the unadjusted sampling weights within each poststratum.


{marker r_N}{...}
{title:robust_result_N()}
{title:robust_result_sum_w()}
{title:robust_result_N_sub()}
{title:robust_result_sum_wsub()}
{title:robust_result_N_clust()}
{title:robust_result_N_strata()}
{title:robust_result_N_strata_omit()}

{p 8 30 2}
{it:real scalar}
{cmd:robust_result_N(}{it:R}{cmd:)}

{p 8 30 2}
{it:real scalar}
{cmd:robust_result_sum_w(}{it:R}{cmd:)}

{p 8 30 2}
{it:real scalar}
{cmd:robust_result_N_sub(}{it:R}{cmd:)}

{p 8 30 2}
{it:real scalar}
{cmd:robust_result_sum_wsub(}{it:R}{cmd:)}

{p 8 30 2}
{it:real scalar}
{cmd:robust_result_N_clust(}{it:R}{cmd:)}

{p 8 30 2}
{it:real scalar}
{cmd:robust_result_N_strata(}{it:R}{cmd:)}

{p 8 30 2}
{it:real scalar}
{cmd:robust_result_N_strata_omit(}{it:R}{cmd:)}

{pstd}
{cmd:robust_result_N(}{it:R}{cmd:)} returns the sample size.

{pstd}
{cmd:robust_result_sum_w(}{it:R}{cmd:)} returns the sum of the sampling
weights.  This value is typically used to estimate the size of the population.

{pstd}
{cmd:robust_result_N_sub(}{it:R}{cmd:)} returns the subpopulation sample size.

{pstd}
{cmd:robust_result_sum_wsub(}{it:R}{cmd:)} returns the sum of the sampling
weights within the subpopulation observations.  This value is typically used
to estimate the size of the subpopulation.

{pstd}
{cmd:robust_result_N_clust(}{it:R}{cmd:)} returns the number of first-stage
sampling units, also known as clusters or primary sampling units.

{pstd}
{cmd:robust_result_N_strata(}{it:R}{cmd:)} returns the number of first-stage
strata.

{pstd}
{cmd:robust_result_N_strata_omit(}{it:R}{cmd:)} returns the number of
first-stage strata that were omitted because they did not intersect with the
subpopulation.


{marker r_census}{...}
{title:robust_result_census()}

{p 8 30 2}
{it:real scalar}
{cmd:robust_result_census(}{it:R}{cmd:)}

{pstd}
{cmd:robust_result_census(}{it:R}{cmd:)} returns an indicator (0 or 1 value)
for whether the first-stage sampling units represent a census.  This is the
special case where the robust variance matrix consisting of all zeros is
interpreted to truly mean no variation.


{marker r_singleton}{...}
{title:robust_result_singleton()}

{p 8 30 2}
{it:real scalar}
{cmd:robust_result_singleton(}{it:R}{cmd:)}

{pstd}
{cmd:robust_result_singleton(}{it:R}{cmd:)} returns an indicator (0 or 1 value)
for whether there were strata with only one sampling unit in any of the
sampling stages.


{marker r_error}{...}
{title:robust_result_errorcode()}
{title:robust_result_errortext()}
{title:robust_result_returncode()}

{p 8 25 2}
{it:real scalar}{bind:  }
{cmd:robust_result_errorcode(}{it:R}{cmd:)}

{p 8 25 2}
{it:string scalar}
{cmd:robust_result_errortext(}{it:R}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:  }
{cmd:robust_result_returncode(}{it:R}{cmd:)}

{p 4 4 2}
These functions are for use after {cmd:_robust()}.

{p 4 4 2}
{cmd:robust_result_errorcode(}{it:R}{cmd:)}
returns the error code as {cmd:_robust()}.
The value will be zero if there were no errors.
The possible error codes are listed directly below.

{p 4 4 2}
{cmd:robust_result_errortext(}{it:R}{cmd:)}
returns a string containing the error message corresponding to the error code.
If the error code is zero, the string will be {cmd:""}.

{p 4 4 2}
{cmd:robust_result_returncode(}{it:R}{cmd:)}
returns the Stata return code corresponding to the error code.
The mapping is listed directly below.  

{p 4 4 2}
In advanced code, these functions might be used as follows:

		{cmd:robust_init_verbose(R, 0)}
		{cmd:(void) _robust(R)}
		...
		{cmd:if (ec = robust_result_errorcode(R)) {c -(}}
			{cmd:errprintf("{c -(}p{c )-}\n")}
			{cmd:errprintf("%s\n", robust_result_errortext(R))}
			{cmd:errprintf("{c -(}p_end{c )-}\n")}
			{cmd:exit(robust_result_returncode(R))}
			{cmd:/*NOTREACHED*/}
		{cmd:{c )-}}

{p 4 4 2}
The error codes and their corresponding Stata return codes are listed
in the following table.

	   Error   Return
	   code     code   Error text
	{hline 70}
	     1      2000   no observations

	     2      3498   conformability error

	     3       100   no equations specified

	     4       198   invalid weight type

	     5       465   poststratum weights must be >= 0

	     6       464   poststratum weights must be constant within
	                   poststrata

	     7       460   FPC must be >= 0

	     8       461   FPC for all observations within a stratum must be
	                   the same

	     9       462   FPC must be <= 1 if a rate, or >= no. sampled units
	                   per stratum if unit totals

	{hline 70}


{marker query}{...}
{title:robust_query()}

{p 8 25 2}
{it:void}
{cmd:robust_query(}{it:R}{cmd:)}

{pstd}
{cmd:robust_query(}{it:R}{cmd:)} displays a report on the current
{cmd:robust_init_}{it:*}{cmd:()} values.
{cmd:robust_query(}{it:R}{cmd:)} may be used before or after {cmd:robust()}
and is useful when using {cmd:robust()} interactively or when debugging a
program that calls {cmd:robust()} or {cmd:_robust()}.


{marker conformability}{...}
{title:Conformability}

{pstd}
All functions have 1 {it:x} 1 inputs and have 1 {it:x} 1 or {it:void} outputs
except the following:

    {cmd:robust_init_touse(}{it:R}{cmd:,} {it:touse}{cmd:)}:
		{it:R}:  {it:transmorphic}
	    {it:touse}:  1 {it:x} 1 ({it:string})
		    {it:N x} 1 ({it:real})
	   {it:result}:  {it:void}

    {cmd:robust_init_touse(}{it:R}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:result}:  {it:N x} 1

    {cmd:robust_init_subpop(}{it:R}{cmd:,} {it:subpop}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:subpop}:  1 {it:x} 1 ({it:string})
		    {it:N x} 1 ({it:real})
	   {it:result}:  {it:void}

    {cmd:robust_init_subpop(}{it:R}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:result}:  {it:N x} 1

    {cmd:robust_init_scores(}{it:R}{cmd:,} {it:S}{cmd:)}:
		{it:R}:  {it:transmorphic}
		{it:S}:  1 {it:x} 1   ({it:string})
		    {it:N x neq} ({it:real})
	   {it:result}:  {it:void}

    {cmd:robust_init_scores(}{it:R}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:result}:  {it:N x neq}

    {cmd:robust_init_covmat(}{it:R}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:result}:  {it:np x np}

    {cmd:robust_init_eq_indepvars(}{it:R}{cmd:,} {it:i}{cmd:,} {it:X}{cmd:)}:
		{it:R}:  {it:transmorphic}
		{it:i}:  1 {it:x} 1
		{it:X}:  1 {it:x} 1   ({it:string})
		    {it:N x k_i} ({it:real})
	   {it:result}:  {it:void}

    {cmd:robust_init_eq_indepvars(}{it:R}{cmd:,} {it:i}{cmd:)}:
		{it:R}:  {it:transmorphic}
		{it:i}:  1 {it:x} 1
	   {it:result}:  {it:N x k_i}

    {cmd:robust_init_stage_units(}{it:R}{cmd:,} {it:k}{cmd:,} {it:units}{cmd:)}:
		{it:R}:  {it:transmorphic}
		{it:k}:  1 {it:x} 1
	    {it:units}:  1 {it:x} 1 ({it:string})
		    {it:N x} 1 ({it:real})
	   {it:result}:  {it:void}

    {cmd:robust_init_stage_units(}{it:R}{cmd:,} {it:k}{cmd:)}:
		{it:R}:  {it:transmorphic}
		{it:k}:  1 {it:x} 1
	   {it:result}:  {it:N x} 1

    {cmd:robust_init_stage_strata(}{it:R}{cmd:,} {it:k}{cmd:,} {it:strata}{cmd:)}:
		{it:R}:  {it:transmorphic}
		{it:k}:  1 {it:x} 1
	   {it:strata}:  1 {it:x} 1 ({it:string})
		    {it:N x} 1 ({it:real})
	   {it:result}:  {it:void}

    {cmd:robust_init_stage_strata(}{it:R}{cmd:,} {it:k}{cmd:)}:
		{it:R}:  {it:transmorphic}
		{it:k}:  1 {it:x} 1
	   {it:result}:  {it:N x} 1

    {cmd:robust_init_stage_fpc(}{it:R}{cmd:,} {it:k}{cmd:,} {it:fpc}{cmd:)}:
		{it:R}:  {it:transmorphic}
		{it:k}:  1 {it:x} 1
	      {it:fpc}:  1 {it:x} 1 ({it:string})
		    {it:N x} 1 ({it:real})
	   {it:result}:  {it:void}

    {cmd:robust_init_stage_fpc(}{it:R}{cmd:,} {it:k}{cmd:)}:
		{it:R}:  {it:transmorphic}
		{it:k}:  1 {it:x} 1
	   {it:result}:  {it:N x} 1

    {cmd:robust_init_weight(}{it:R}{cmd:,} {it:w}{cmd:)}:
		{it:R}:  {it:transmorphic}
		{it:k}:  1 {it:x} 1
	        {it:w}:  1 {it:x} 1 ({it:string})
		    {it:N x} 1 ({it:real})
	   {it:result}:  {it:void}

    {cmd:robust_init_weight(}{it:R}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:result}:  {it:N x} 1

    {cmd:robust_init_poststrata(}{it:R}{cmd:,} {it:P}{cmd:)}:
		{it:R}:  {it:transmorphic}
	        {it:P}:  1 {it:x} 1 ({it:string})
		    {it:N x} 2 ({it:real})
	   {it:result}:  {it:void}

    {cmd:robust_init_poststrata(}{it:R}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:result}:  {it:N x} 2

    {cmd:robust(}{it:R}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:result}:  {it:np x np}

    {cmd:robust_result_V(}{it:R}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:result}:  {it:np x np}

    {cmd:robust_result_V_srs(}{it:R}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:result}:  {it:np x np}

    {cmd:robust_result_V_srssub(}{it:R}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:result}:  {it:np x np}

    {cmd:robust_result_V_srswr(}{it:R}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:result}:  {it:np x np}

    {cmd:robust_result_V_srswrsub(}{it:R}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:result}:  {it:np x np}

    {cmd:robust_result_stage_strata(}{it:R}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:result}:  1 {it:x K}

    {cmd:robust_result_stage_certain(}{it:R}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:result}:  1 {it:x K}

    {cmd:robust_result_stage_single(}{it:R}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:result}:  1 {it:x K}

    {cmd:robust_result_postsize(}{it:R}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:result}:  1 {it:x npost}

    {cmd:robust_result_postsum(}{it:R}{cmd:)}:
		{it:R}:  {it:transmorphic}
	   {it:result}:  1 {it:x npost}


{marker diagnostics}{...}
{title:Diagnostics}

{pstd}
All functions abort with error when used incorrectly.

{pstd}
{cmd:robust()} aborts with error if it runs into numerical difficulties.


{marker source}{...}
{title:Source code}

{pstd}
{view robust.mata, adopath asis:robust.mata}
{p_end}
