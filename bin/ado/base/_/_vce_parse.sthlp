{smcl}
{* *! version 1.0.6  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _vce_parserun" "help _vce_parserun"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{vieweralsosee "[R] vce_option" "help vce_option"}{...}
{viewerjumpto "Syntax" "_vce_parse##syntax"}{...}
{viewerjumpto "Description" "_vce_parse##description"}{...}
{viewerjumpto "Options" "_vce_parse##options"}{...}
{viewerjumpto "Stored results" "_vce_parse##results"}{...}
{title:Title}

{p 4 21 2}
{hi:[P] _vce_parse} {hline 2}
Parsing tool for the {opt vce()} option


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_vce_parse}
	[{it:{help mark:markvar}}]
	[{cmd:,}
		{it:options}
	] {cmd::} {weight} [,
		{opt vce(vcetype)}
		{opt cl:uster(varname)}
		{opt r:obust}
	]


{synoptset 27}{...}
{synopthdr}
{synoptline}
{synopt :{opt opt:list(vcetypes)}}{it:vcetypes}
	that do not allow arguments{p_end}
{synopt :{opt argopt:list(vcetypes)}}{it:vcetypes}
	that require arguments{p_end}
{synopt :{opt pw:allowed(vcetypes)}}{it:vcetypes}
	that are allowed with {cmd:pweight}s{p_end}
{synopt :{opt old}}allow {opt cluster()} and {opt robust}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:vcetypes} is one or more names allowed to be used in the {opt vce()}
option.
Use capital letters to specify minimum abbreviations as in {helpb syntax}.
Capital letters in the {opt pwallowed()} option are ignored.
{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_vce_parse} is a programmer's tool that helps estimation commands
parse the {opt vce()} option.  {cmd:_vce_parse} validates the specified
{opt vce()} option, and returns its results to {cmd:r()}.


{marker options}{...}
{title:Options}

{phang}
{opt optlist(vcetypes)} identifies the list of optional {it:vcetypes} that do
not allow arguments.

{phang}
{opt argoptlist(vcetypes)} identifies the list of optional {it:vcetypes} that
require arguments.

{phang}
{opt pwallowed(vcetypes)} identifies which of the {it:vcetypes} specified in
{opt optlist()} and {opt aroptlist()} are allowed with {cmd:pweight}s.

{phang}
{opt old} specifies that {opt cluster()} and {opt robust} are allowed as
synonyms for {cmd:vce(cluster ...)} and {cmd:vce(robust)}.  By default,
{cmd:_vce_parse} will report an error if {opt cluster()} or {opt robust} are
specified.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_vce_parse} stores the following in {cmd:r()}:

{p2colset 9 24 32 2}{...}
{pstd}Macros:{p_end}
{p2col :{cmd:r(vce)}}the specified {it:vcetype}{p_end}
{p2col :{cmd:r(vceargs)}}arguments{p_end}
{p2col :{cmd:r(vceopt)}}the reconstructed {opt vce()} option{p_end}

{p2col :{cmd:r(robust)}}{opt robust}
	if {cmd:vce(robust)} or {opt robust} were specified{p_end}
{p2col :{cmd:r(cluster)}}{it:varname}
	if {cmd:vce(cluster} {it:varname}{cmd:)} or
	{opt cluster(varname)} were specified{p_end}
{p2colreset}{...}
