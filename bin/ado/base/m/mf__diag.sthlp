{smcl}
{* *! version 1.2.4  19oct2017}{...}
{vieweralsosee "[M-5] _diag()" "mansection M-5 _diag()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] diag()" "help mf_diag"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] manipulation" "help m4_manipulation"}{...}
{viewerjumpto "Syntax" "mf__diag##syntax"}{...}
{viewerjumpto "Description" "mf__diag##description"}{...}
{viewerjumpto "Conformability" "mf__diag##conformability"}{...}
{viewerjumpto "Diagnostics" "mf__diag##diagnostics"}{...}
{viewerjumpto "Source code" "mf__diag##source"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] _diag()} {hline 2}}Replace diagonal of a matrix
{p_end}
{p2col:}({mansection M-5 _diag():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}
{cmd:_diag(}{it:numeric matrix Z}, {it:numeric vector v}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:_diag(}{it:Z}{cmd:,} {it:v}{cmd:)} replaces the diagonal of the matrix
{it:Z} with {it:v}.  {it:Z} need not be square.

{p 8 12 2}
1.
If {it:v} is a vector, the vector replaces the principal
diagonal.

{p 8 12 2}
2.
If {it:v} is 1 {it:x} 1, each element of the principal diagonal
is replaced with {it:v}.

{p 8 12 2}
3.
If {it:v} is a void vector (1 {it:x} 0 or 0 {it:x} 1), 
{it:Z} is left unchanged.


{marker conformability}{...}
{title:Conformability}

    {cmd:_diag(}{it:Z}, {it:v}{cmd:)}:
	{it:input:}
		{it:Z}:  {it:n x m}, {it:n}<={it:m}
		{it:v}:  1 {it:x} 1,  1 {it:x n}, or  {it:n x} 1
	{it:or}
		{it:Z}:  {it:n x m}, {it:n}>{it:m}
		{it:v}:  1 {it:x} 1,  1 {it:x m}, or  {it:m x} 1
	{it:output:}
		{it:Z}:  {it:n x m}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:_diag(}{it:Z}{cmd:,} {it:v}{cmd:)} aborts with error if 
{it:Z} or {it:v} is a view.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
