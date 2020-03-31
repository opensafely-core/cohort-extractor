{smcl}
{* *! version 1.0.2  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_matrix()" "help mf_st_matrix"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix list" "help matrix_list"}{...}
{viewerjumpto "Syntax" "mf_st_matrix_list##syntax"}{...}
{viewerjumpto "Description" "mf_st_matrix_list##description"}{...}
{viewerjumpto "Conformability" "mf_st_matrix_list##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_matrix_list##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_matrix_list##source"}{...}
{title:Title}

{phang}
{cmd:[M-5] st_matrix_list()} {hline 2} Listing a Stata matrix


{marker syntax}{...}
{title:Syntax}

{phang2}
{it:void}
{cmd:st_matrix_list(}{it:name}{cmd:)}

{phang2}
{it:void}
{cmd:st_matrix_list(}{it:name}{cmd:,}
	{it:{help format}}{cmd:,}
	{it:title}{cmd:,}
	{it:blank}{cmd:,}
	{it:half}{cmd:,}
	{it:header}{cmd:,}
	{it:names}{cmd:,}
	{it:dotz}{cmd:)}

{pstd}
where

	  {it:name}:  {it:string scalar}
	{it:format}:  {it:string scalar}
	 {it:title}:  {it:string scalar}
	 {it:blank}:  {it:real   scalar}
	  {it:half}:  {it:real   scalar}
	{it:header}:  {it:real   scalar}
	 {it:names}:  {it:real   scalar}
	  {it:dotz}:  {it:real   scalar}


{marker description}{...}
{title:Description}

{pstd}
{cmd:st_matrix_list(}{it:name}{cmd:)}
lists the contents of Stata matrix {it:name}.
The other optional arguments control how {cmd:st_matrix_list()} produces
output.

{phang}
{it:format} specifies the numeric format for displaying the elements of
Stata matrix {it:name}.  The default is {cmd:"%10.0g"}.

{phang}
{it:title} is added to the header displayed before the matrix contents.
The default is {cmd:""}.

{phang}
{it:blank} indicates whether to add a blank line before displaying the matrix
contents.  The default is {cmd:1}.

{phang}
{it:half} indicates whether to display symmetric matrices in lower
triangular form.  The default is {cmd:1}.

{phang}
{it:header} indicates whether to display the header.  The header consists of
the matrix name, its dimensions, the optional title, and whether the matrix is
symmetric.  The default is {cmd:1}.

{phang}
{it:names} indicates whether to display the row and column names around the
matrix.  The default is {cmd:1}.

{phang}
{it:dotz} indicates whether to display {cmd:.z} missing values.  If
{it:dotz}{cmd:==0}, {cmd:st_matrix_list()} displays {cmd:.z} missing values as
blanks.  The default is {cmd:1}.


{marker conformability}{...}
{title:Conformability}

    {cmd:st_matrix_list(}{it:name}{cmd:,} {it:{help format}}{cmd:,} {it:title}{cmd:,} {it:blank}{cmd:,}
		   {it:half}{cmd:,} {it:header}{cmd:,} {it:names}{cmd:,} {it:dotz}{cmd:)}
	     {it:name}:  1 {it:x} 1
	   {it:format}:  1 {it:x} 1  (optional)
	    {it:title}:  1 {it:x} 1  (optional)
	    {it:blank}:  1 {it:x} 1  (optional)
	     {it:half}:  1 {it:x} 1  (optional)
	   {it:header}:  1 {it:x} 1  (optional)
	    {it:names}:  1 {it:x} 1  (optional)
	     {it:dotz}:  1 {it:x} 1  (optional)
	   {it:result}:  {it:void}


{marker diagnostics}{...}
{title:Diagnostics}

{pstd}
{cmd:st_matrix_list(}{it:name}{cmd:)} aborts with error if any of its
arguments are malformed.


{marker source}{...}
{title:Source code}

{pstd}
{view st_matrix_list.mata, adopath asis:st_matrix_list.mata}
{p_end}
