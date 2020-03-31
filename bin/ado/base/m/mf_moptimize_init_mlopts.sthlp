{smcl}
{* *! version 1.1.3  12dec2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] moptimize()" "help mf_moptimize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] mlopts" "help mlopts"}{...}
{viewerjumpto "Syntax" "mf_moptimize_init_mlopts##syntax"}{...}
{viewerjumpto "Description" "mf_moptimize_init_mlopts##description"}{...}
{viewerjumpto "Remarks" "mf_moptimize_init_mlopts##remarks"}{...}
{viewerjumpto "Conformability" "mf_moptimize_init_mlopts##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_moptimize_init_mlopts##diagnostics"}{...}
{viewerjumpto "Source code" "mf_moptimize_init_mlopts##source"}{...}
{title:Title}

{p2colset 5 38 40 2}{...}
{p2col:{hi:[M-5] moptimize_init_mlopts()} {hline 2}}ml options parser for
moptimize(){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{it:(void)}
{cmd:moptimize_init_mlopts(}{it:M}{cmd:,} {it:string scalar mopts}{cmd:)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:moptimize_init_mlopts()} applies the options in {it:mopts} to {it:M},
where {it:mopts} is assumed to contain {help maximize} options already
parsed by the {helpb mlopts} command.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
You have a Stata program with syntax

{p 8 8 2}
{cmd:syntax }{it:varlist} [{cmd:, }{it:program_options} {cmd:*}]

{p 4 4 2}
and are parsing the standard maximize options using

{p 8 8 2}
{cmd:mlopts }{it:mlopts options}{cmd:, }{it:`options'}

{p 4 4 2}
Within your Mata code, you create an {cmd:moptimize()} object

{p 8 8 2}
{it:M}{cmd: = moptimize_init()}

{p 4 4 2}
and somewhere afterward, you apply the specified options in macro
{it:mlopts} to the {cmd:moptimize()} object {it:M} by typing

{p 8 8 2}
{cmd:moptimize_init_mlopts(}{it:M}{cmd:, st_local("}{it:mlopts}{cmd:"))}


{marker conformability}{...}
{title:Conformability}

    {cmd:moptimize_init_mlopts(}{it:M}{cmd:, }{it:mopts}{cmd:)}
		{it:M}    :  1 {it:x} 1 
		{it:mopts}:  1 {it:x} 1 


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
The first argument {it:M} must be the returned value from
{cmd:moptimize_init()}.

{p 4 4 2}
The string scalar {it:mopts} should contain space-delimited options found in
{manhelp mlopts P}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view moptimize_init_mlopts.mata, adopath asis:moptimize_init_mlopts.mata}
{p_end}
