{smcl}
{* *! version 1.2.2  21apr2014}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{vieweralsosee "[SVY] svyset" "help svyset"}{...}
{viewerjumpto "Syntax" "_svy_setup##syntax"}{...}
{viewerjumpto "Description" "_svy_setup##description"}{...}
{viewerjumpto "Options" "_svy_setup##options"}{...}
{viewerjumpto "Example" "_svy_setup##example"}{...}
{viewerjumpto "Stored results" "_svy_setup##results"}{...}
{title:Title}

{p 4 26 2}
{hi:[SVY] _svy_setup} {hline 2} Retrieve svy settings and adjust weights


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_svy_setup}
	{it:markvar}
	{it:submarkvar}
	[{it:wvar}]
	{weight}
	[{cmd:,}
		{opt cmdname(name)} 
		{opt sub:pop(subpop, ...)} 
		{opt over(varlist, ...)} 
		{opt srs:subpop} 
		{opt stset}
	]

{pstd}
{it:weights} are not allowed but are indicated above for the purpose of
generating an informative error message for the calling routine.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_svy_setup} is a programmers' tool for retrieving the required
information for survey data analysis.  {cmd:_svy_setup} will display an error
message if the data are not currently {cmd:svyset}.

{phang}
{it:markvar} is a mark variable as described in {manhelp mark P}.  This variable
identifies the subset of the data that will be used for estimation purposes.

{phang}
{it:submarkvar} is a new variable name and will identify the subpopulation
observations defined by {it:markvar} and the {opt subpop()} and {opt over()}
options.

{phang}
{it:wvar} is a new variable name and, if specified, will be filled in with the
observation-level weights.


{marker options}{...}
{title:Options}

{phang}
{opt cmdname(name)} identifies the name of the calling routine, and is used to
identify commands that allow the {opt over()} option.

{phang}
{opt subpop(subpop, ...)} identifies the subpopulation; see {manhelp svy SVY}.

{phang}
{opt srssubpop} is sometimes allowed outside the {opt subpop()} option; see
{manhelp svy SVY}.

{phang}
{opt over(varlist, ...)} identifies multiple subpopulations.
This option along with the {opt cmdname()} option help provide better error
messages for syntax errors in specifying subpopulations.

{phang}
{opt stset} verify that the {cmd:stset} settings are consistent with those of
{cmd:svyset}.


{marker example}{...}
{title:Example}

{pstd}
{cmd:. _svy_setup touse subuse wvar, cmdname(mean)}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
In addition to the results documented in {manhelp svyset SVY},
{cmd:_svy_setup} stores the following in {cmd:r()}:

{p2colset 9 25 32 2}{...}
{phang}
Scalars:

{p2col :{cmd:r(N)}}the number of selected observations{p_end}
{p2col :{cmd:r(N_pop)}}the population size{p_end}
{p2col :{cmd:r(N_strata)}}the number of strata{p_end}
{p2col :{cmd:r(N_psu)}}the number of PSUs{p_end}
{p2col :{cmd:r(N_sub)}}the number of selected subpopulation observations{p_end}
{p2col :{cmd:r(N_subpop)}}the subpopulation size{p_end}
{p2col :{cmd:r(N_subpsu)}}the subpopulation PSUs{p_end}

{phang}
Macros:

{p2col :{cmd:r(subpop)}}the parsed {opt subpop()} option{p_end}
{p2col :{cmd:r(srssubpop)}}the parsed {opt srssubpop} option{p_end}
