{smcl}
{* *! version 1.0.2  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{viewerjumpto "Syntax" "_ms_unab##syntax"}{...}
{viewerjumpto "Description" "_ms_unab##description"}{...}
{viewerjumpto "Options" "_ms_unab##options"}{...}
{title:Title}

{p2colset 4 17 20 2}{...}
{p2col:{hi:[P] _ms_unab}}{hline 2}
Unabbreviate matrix stripe elements
{p_end}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_ms_unab} {it:lmacname} {cmd::} [{it:speclist}]
	[{cmd:,}
		{opt min(#)}
		{opt max(#)}
		{opt name(string)}]

{pstd}
where {it:speclist} is a list of valid matrix stripe elements, excluding the
equation part.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_ms_unab} unabbreviates the elements in {it:speclist} by using the variable
names in the current dataset, placing the results in the local macro
{it:lmacname}.  {cmd:_ms_unab} is similar to {helpb fvunab}, except that
{cmd:_ms_unab} works with matrix stripe elements instead of {varlist}s.


{marker options}{...}
{title:Options}

{phang}
{cmd:min(}{it:#}{cmd:)} specifies the minimum number of variables allowed.
The default is {hi:min(1)}.

{phang}
{cmd:max(}{it:#}{cmd:)} specifies the maximum number of variables allowed.
The default is {hi:max(32000)}.

{phang}
{cmd:name(}{it:string}{cmd:)} provides a label that is used when printing
error messages.
{p_end}
