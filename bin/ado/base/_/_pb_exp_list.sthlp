{smcl}
{* *! version 1.0.3  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] class" "help class"}{...}
{vieweralsosee "[R] nlcom" "help nlcom"}{...}
{viewerjumpto "Syntax" "_pb_exp_list##syntax"}{...}
{viewerjumpto "Description" "_pb_exp_list##description"}{...}
{viewerjumpto "Options for .new and .reset" "_pb_exp_list##options"}{...}
{viewerjumpto "Examples" "_pb_exp_list##examples"}{...}
{viewerjumpto "Stored results" "_pb_exp_list##results"}{...}
{title:Title}

{p2colset 5 25 27 2}{...}
{p2col:{hi:[P] _pb_exp_list} {hline 2}}General-purpose class for managing
parenthesis-bound expression lists{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Declaring a _pb_exp_list object

{phang2}
{cmd:.}{it:obj} = {cmd:._pb_exp_list.new}{cmd:,}
	{opt stub(name)}
	[{it:{help _pb_exp_list##reset:reset_options}}]


{pstd}
Resetting your _pb_exp_list object

{phang2}
{cmd:.}{it:obj}{cmd:.reset,}
	{opt stub(name)}
	[{it:{help _pb_exp_list##reset:reset_options}}]


{pstd}
Parsing the expression list

{phang2}
{cmd:.}{it:obj}{cmd:.parse}
	[{it:name}{cmd::}] {it:{help exp}}
	[{cmd:,} {it:{help eform_option}} {it:passthru_options}]

{phang2}
{cmd:.}{it:obj}{cmd:.parse}
	[{cmd:(}[{it:name}{cmd::}] {it:{help exp}}{cmd:)} ...]
	[{cmd:,} {it:{help eform_option}} {it:passthru_options}]


{pstd}
Computing point and variance estimates

{phang2}
{cmd:.}{it:obj}{cmd:.compute} {it:b} {it:V}


{pstd}
Posting the expressions to e()

{phang2}
{cmd:.}{it:obj}{cmd:.post_legend}


{marker reset}{...}
{synoptset 20 tabbed}{...}
{synopthdr:reset_options}
{synoptline}
{p2coldent :* {opt stub(name)}}stub for default name generation{p_end}
{synopt :{opt eqstub(name)}}stub for default equation name generation{p_end}
{synopt :{opt cmd:name(name)}}name of assumed estimation command{p_end}
{synoptline}
{p2colreset}{...}
{pstd}
* {opt stub()} is required.
{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_pb_exp_list} is a programmer's tool for managing expressions bound in
parentheses.  Each expression is assumed to be a function of the parameter
estimates in {cmd:e(b)} from an estimation command.

{pstd}
{cmd:.}{it:obj}{cmd:.reset} restores the elements in {cmd:.}{it:obj} as if it
were newly created.

{pstd}
{cmd:.}{it:obj}{cmd:.parse} parses the list of expressions.

{pstd}
{cmd:.}{it:obj}{cmd:.compute} uses the current estimation results in {cmd:e()}
to compute the requested point and variance estimates.  {cmd:.compute} uses
{helpb nlcom} to perform this task.  Each element of {cmd:e(b)} from the
current estimation results is included among the list of expressions.

{pstd}
{cmd:.}{it:obj}{cmd:.post_legend} stores the expressions in {cmd:e()}.


{marker options}{...}
{title:Options for .new and .reset}

{phang}
{opt stub(name)} specifies the stub used for automatic name generation.  The
stub is used when a name is not specified or for resolving conflicted names.
{opt stub()} is required.

{phang}
{opt eqstub(name)} specifies the stub for automatic equation name generation.
This equation stub is used only when one or more expressions are specified. 
The default is {cmd:eqstub(_eq_)}.

{phang}
{opt cmdname(name)} specifies which estimation command's results will be used.
This option gives the ability to produce error messages when an invalid
{it:{help eform_option}} is specified.


{marker examples}{...}
{title:Examples}

{pstd}
Make a new object

	{cmd:. .o = ._pb_exp_list.new, stub(exp_) eqstub(eq_) cmdname(logit)}

{pstd}
Parse an expression

	{cmd:. .o.parse (odiff: exp(_b[turn])-exp(_b[trunk])), or}

{pstd}
Fit a model

	{cmd:. logit foreign mpg turn trunk displ head}

{pstd}
Compute the value for our expression

	{cmd:. .o.compute b V}

{pstd}
Post the expressions to {cmd:e()}

	{cmd:. .o.post_legend}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:.}{it:obj}{cmd:.parse} returns the following in {cmd:r()}:

{synoptset 12 tabbed}{...}
{p2col 5 12 16 2: Scalars}{p_end}
{synopt:{cmd:r(k_exp)}}number of specified expressions{p_end}

{p2col 5 12 16 2: Macros}{p_end}
{synopt: {cmd:r(eform)}}parsed {it:{help eform_option}} for replaying
	underlying point estimates{p_end}
{synopt: {cmd:r(options)}}other options for caller to parse{p_end}
{p2colreset}{...}


{pstd}
{cmd:.}{it:obj}{cmd:.post_legend} returns the following in {cmd:e()}:

{synoptset 12 tabbed}{...}
{p2col 5 12 16 2:Scalars}{p_end}
{synopt: {cmd:e(k_exp)}}total number of expressions, including implied
	expressions from underlying {cmd:e(b)}{p_end}

{p2col 5 12 16 2:Macros}{p_end}
{synopt: {cmd:e(exp}{it:#}{cmd:)}}{it:#}th expression{p_end}
{p2colreset}{...}
