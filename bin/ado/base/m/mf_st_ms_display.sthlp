{smcl}
{* *! version 1.0.0  07mar2019}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] matrix rownames" "help matrix_rownames"}{...}
{vieweralsosee "[P] _ms_display" "help _ms_display"}{...}
{viewerjumpto "Syntax" "mf_st_ms_display##syntax"}{...}
{viewerjumpto "Description" "mf_st_ms_display##description"}{...}
{viewerjumpto "Conformability" "mf_st_ms_display##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_ms_display##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_ms_display##source"}{...}
{title:Title}

{phang}
{hi:[M-5] st_ms_display()} {hline 2} Coefficient table output to strings
{p_end}


{marker syntax}{...}
{title:Syntax}

{phang2}
{it:string colvector}
{cmd:st_ms_display(}{it:mname}{cmd:)}

{phang2}
{it:string colvector}
{cmd:st_ms_display(}{it:mname}{cmd:,} {it:options}{cmd:)}

{phang2}
{it:string colvector}
{cmd:st_ms_display(}{it:mname}{cmd:,} {it:options}{cmd:,} {it:nooutput}{cmd:)}

{pstd}
where

		{it:mname}:  {it:string scalar}
	      {it:options}:  {it:string scalar}
	     {it:nooutput}:  {it:real scalar}


{marker description}{...}
{title:Description}

{pstd}
{cmd:st_ms_display(}{it:mname}{cmd:)} returns the strings produced by
{helpb _ms_display}, looping over all the column names in the Stata
matrix specified in {it:mname}.

{pstd}
{cmd:st_ms_display(}{it:mname}{cmd:,} {it:options}{cmd:)} does the same
thing but passes {it:options} to {cmd:_ms_display}.
Add option {opt row} to get {cmd:st_ms_display()} to loop over the row
names.
Add option {opt vsquish} to prevent blank spaces.

{pstd}
{cmd:st_ms_display(}{it:mname}{cmd:,} {it:options}{cmd:,} {it:nooutput}{cmd:)}
does the same thing but will allow output from {cmd:_ms_display} if
{it:nooutput}=0.


{marker conformability}{...}
{title:Conformability}

     {cmd:st_ms_display(}{it:mname}{cmd:)}:
	    {it:mname}:  1 {it:x} 1
	   {it:result}:  {it:n} {it:x} 1

     {cmd:st_ms_display(}{it:mname}{cmd:,} {it:options}{cmd:)}:
	    {it:mname}:  1 {it:x} 1
	  {it:options}:  1 {it:x} 1
	   {it:result}:  {it:n} {it:x} 1

     {cmd:st_ms_display(}{it:mname}{cmd:,} {it:options}{cmd:,} {it:nooutput}{cmd:)}:
	    {it:mname}:  1 {it:x} 1
	  {it:options}:  1 {it:x} 1
	 {it:nooutput}:  1 {it:x} 1
	   {it:result}:  {it:n} {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{pstd}
All of these functions abort with an error message if any of the arguments are
malformed.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view st_ms_display.mata, adopath asis:st_ms_display.mata}
{p_end}
