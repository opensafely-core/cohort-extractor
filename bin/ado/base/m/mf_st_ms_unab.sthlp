{smcl}
{* *! version 1.0.1  18mar2013}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] matrix rownames" "help matrix_rownames"}{...}
{vieweralsosee "[P] _ms_unab" "help _ms_unab"}{...}
{viewerjumpto "Syntax" "mf_st_ms_unab##syntax"}{...}
{viewerjumpto "Description" "mf_st_ms_unab##description"}{...}
{viewerjumpto "Conformability" "mf_st_ms_unab##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_ms_unab##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_ms_unab##source"}{...}
{title:Title}

{phang}
{hi:[M-5] st_ms_unab()} {hline 2} Unabbreviate matrix stripe elements
{p_end}


{marker syntax}{...}
{title:Syntax}

{phang2}
{it:void}{space 8}
{cmd:st_ms_unab(}{it:spec}{cmd:)}

{phang2}
{it:real scalar}
{cmd:_st_ms_unab(}{it:spec}{cmd:)}

{phang2}
{it:real scalar}
{cmd:_st_ms_unab(}{it:spec}{cmd:,} {it:noisily}{cmd:)}

{pstd}
where

		{it:spec}:  {it:string scalar}
	     {it:noisily}:  {it:real scalar}


{marker description}{...}
{title:Description}

{pstd}
{cmd:st_ms_unab(}{it:spec}{cmd:)} unabbreviates {it:spec} by using the
variable names in the current dataset, updating the contents of {it:spec}.

{pstd}
{cmd:_st_ms_unab(}{it:spec}{cmd:)} is equivalent to
{cmd:st_ms_unab(}{it:spec}{cmd:)} except that it quietly returns a Stata return
code if there was a parsing error or an ambiguous abbreviation.

{pstd}
{cmd:_st_ms_unab(}{it:spec}{cmd:,} {it:noisily}{cmd:)} is equivalent to
{cmd:_st_ms_unab(}{it:spec}{cmd:)} except that a parsing error or an ambiguous
abbreviation will cause Stata to report an error message if {it:noisily} is
neither zero nor missing.


{marker conformability}{...}
{title:Conformability}

     {cmd:st_ms_unab(}{it:spec}{cmd:)}:
	     {it:spec}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {cmd:_st_ms_unab(}{it:spec}{cmd:)}:
	     {it:spec}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

    {cmd:_st_ms_unab(}{it:spec}{cmd:,} {it:noisily}{cmd:)}:
	     {it:spec}:  1 {it:x} 1
	  {it:noisily}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{pstd}
All of these functions abort with an error if any of the arguments are 
malformed.  {it:noisily} indicates whether Stata is to report an error message
when {it:spec} cannot be parsed or for ambiguous abbreviations.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view st_ms_unab.mata, adopath asis:st_ms_unab.mata};
{cmd:_st_ms_unab()} is built in.
{p_end}
