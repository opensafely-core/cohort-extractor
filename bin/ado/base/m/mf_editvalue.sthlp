{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] editvalue()" "mansection M-5 editvalue()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] editmissing()" "help mf_editmissing"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{viewerjumpto "Syntax" "mf_editvalue##syntax"}{...}
{viewerjumpto "Description" "mf_editvalue##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_editvalue##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_editvalue##remarks"}{...}
{viewerjumpto "Conformability" "mf_editvalue##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_editvalue##diagnostics"}{...}
{viewerjumpto "Source code" "mf_editvalue##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] editvalue()} {hline 2}}Edit (change) values in matrix
{p_end}
{p2col:}({mansection M-5 editvalue():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:matrix}
{cmd:editvalue(}{it:matrix A}{cmd:,}
{it:scalar from}{cmd:,}
{it:scalar to}{cmd:)}

{p 8 8 2}
{it:void}{bind: }
{cmd:_editvalue(}{it:matrix A}{cmd:,}
{it:scalar from}{cmd:,}
{it:scalar to}{cmd:)}


{p 4 4 2}
where {it:A}, {it:from}, and {it:to} may be real, complex, or string.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:editvalue(}{it:A}{cmd:,} {it:from}{cmd:,} {it:to}{cmd:)}
returns {it:A} with all elements equal to {it:from} changed to {it:to}.

{p 4 4 2}
_{cmd:editvalue(}{it:A}{cmd:,} {it:from}{cmd:,} {it:to}{cmd:)}
does the same thing but modifies {it:A} itself.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 editvalue()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}


{p 4 4 2}
{cmd:editvalue()} and {cmd:_editvalue()} are fast.

{p 4 4 2}
If you wish to change missing values to nonmissing values, it is 
better to use {bf:{help mf_editmissing:[M-5] editmissing()}}.
{cmd:editvalue(}{it:A}{cmd:, ., 1)} would change all {cmd:.} missing 
values to 1 but leave {cmd:.a}, {cmd:.b}, ..., unchanged.
{cmd:editmissing(}{it:A}{cmd:, 1)} would change all missing values to 1.


{marker conformability}{...}
{title:Conformability}

    {cmd:editvalue(}{it:A}{cmd:,} {it:from}{cmd:,} {it:to}{cmd:)}:
		{it:A}:  {it:r x c}
	     {it:from}:  1 {it:x} 1
	       {it:to}:  1 {it:x} 1
	   {it:result}:  {it:r x c}

    {cmd:_editvalue(}{it:A}{cmd:,} {it:from}{cmd:,} {it:to}{cmd:)}:
	{it:input:}
		{it:A}:  {it:r x c}
	     {it:from}:  1 {it:x} 1
	       {it:to}:  1 {it:x} 1
	{it:output:}
		{it:A}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:editvalue(}{it:A}{cmd:,} {it:from}{cmd:,} {it:to}{cmd:)} returns 
a matrix of the same type as {it:A}.  

{p 4 4 2}
{cmd:editvalue(}{it:A}{cmd:,} {it:from}{cmd:,} {it:to}{cmd:)} 
and
{cmd:_editvalue(}{it:A}{cmd:,} {it:from}{cmd:,} {it:to}{cmd:)}
abort with error if {it:from} and {it:to} are incompatible with {it:A}.  That
is, if {it:A} is real, {it:to} and {it:from} must be real.  If {it:A} is
complex, {it:to} and {it:from} must each be either real or complex.  If {it:A}
is string, {it:to} and {it:from} must be string.

{p 4 4 2}
{cmd:_editvalue(}{it:A}{cmd:,} {it:from}{cmd:,} {it:to}{cmd:)}
aborts with error if {it:A} is a view.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view editvalue.mata, adopath asis:editvalue.mata};
{cmd:_editvalue()} is built in.
{p_end}
