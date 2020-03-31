{smcl}
{* *! version 1.0.4  29mar2017}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] makecns" "help makecns"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] constraint" "help constraint"}{...}
{viewerjumpto "Syntax" "_make_constraints##syntax"}{...}
{viewerjumpto "Description" "_make_constraints##description"}{...}
{viewerjumpto "Options" "_make_constraints##options"}{...}
{viewerjumpto "Remarks" "_make_constraints##remarks"}{...}
{viewerjumpto "Stored results" "_make_constraints##results"}{...}
{title:Title}

{p2colset 5 30 32 2}{...}
{p2col :{hi:[P] _make_constraints} {hline 2}}Make the constraint matrices
	associated with a {cmd:constraints()} specification{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_make_constraints}{cmd:,} {opt b(name)}
  [{cmd:constraints(}{it:{help numlist}}{c |}{it:matname}{cmd:)}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_make_constraints} returns the constraint matrices defined by a 
{cmd:constraint()} specification as well as those implied by the factor
specifications in the stripe of matrix {cmd:b}.


{marker options}{...}
{title:Options}

{phang}
{opt b(name)} specifies the striped coefficient matrix for generating the
constraint matrices. {opt b()} is required.

{phang}
{opth constraints(numlist)} specifies the number list of the constraints 
defined by the {helpb constraint} command.
{opt constraints(matname)} specifies the matrix used by {helpb makecns}.


{marker remarks}{...}
{title:Remarks}

{pstd}
For background about the linear constraint matrices used by Stata, see
{manhelp makecns P}.

{pstd}
Given the r x p constraint matrix {bf:C} and r x 1 vector
{bf:a}, we apply constraints as

{p 15 15 2}
{bf:C}*{bf:b} = {bf:a}

{pstd}
on coefficient vector {bf:b} using generated r x p matrix {bf:T} as

{p 15 15 2}
{bf:bc} = {bf:b}*{bf:T}

{pstd}
We compute the original parameterization from constrained vector {bf:bc} 
using 

{p 15 15 2}
{bf:b} = {bf:bc}*{bf:T}' + {bf:a}

{pstd}
{cmd:_make_constraints} uses only the stripe of coefficient matrix
{bf:b}; its numeric contents are immaterial.

{pstd}
{cmd:_make_constraints} returns in {cmd:e} matrix {bf:e(Cm)}

{p 15 15 2}
{cmd:Cm} = ({bf:C},{bf:a})

{pstd}
which can be used when initializing an {bf:moptimize()} problem with
{cmd:moptimize_init_constraints(}{it:M}{cmd:,} {it:Cm}{cmd:)}.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_make_constraints} stores the following in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(k_autoCns)}}number of base, empty, and omitted constraints{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(Cm)}}constraint matrix ({bf:C},{bf:a}){p_end}
{synopt:{cmd:e(T)}}constraint matrix such that {bf:bc} = {bf:b}*{bf:T}{p_end}
{synopt:{cmd:e(a)}}constraint right-hand-side vector{p_end}
{p2colreset}{...}
