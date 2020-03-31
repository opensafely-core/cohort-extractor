{smcl}
{* *! version 1.0.2  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{viewerjumpto "Syntax" "mf_subdiagget##syntax"}{...}
{viewerjumpto "Description" "mf_subdiagget##description"}{...}
{viewerjumpto "Examples" "mf_subdiagget##examples"}{...}
{viewerjumpto "Conformability" "mf_subdiagget##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_subdiagget##diagnostics"}{...}
{viewerjumpto "Source code" "mf_subdiagget##source"}{...}
{title:Title}

{p2colset 5 27 29 2}{...}
{p2col :{hi:[M-5] subdiagget()} {hline 2}}Extract matrix subdiagonals{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 39 2}
{it:transmorphic colvector}{bind:}
{cmd:subdiagget(}{it:transmorphic matrix X}{cmd:,}
{it:real vector lower}{cmd:,}
{it:real vector upper}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:subdiagget(}{it:X}{cmd:)} returns subdiagonals of {it:X} transformed
into a column vector with one subdiagonal stacked onto the next.


{marker examples}{...}
{title:Examples}

{p 4 8 2}
1.
Extract the subdiagonal of matrix {cmd:X}, 

		{cmd:d = subdiagget(X, 1, 0)}

{p 4 8 2}
2.
Extract the superdiagonal of matrix {cmd:X}, 

		{cmd:d = subdiagget(X, 0, 1)}

{p 4 8 2}
3.
Extract the 1st through 5th subdiagonals of matrix {cmd:X}, 

		{cmd:d = subdiagget(X, 1..5, 0)}


{p 4 8 2}
4.
Extract the 2nd and 4th subdiagonals of matrix {cmd:X}, 

		{cmd:d = subdiagget(X, (2,4), 0)}


{p 4 8 2}
5.
Extract the 4th and 2nd subdiagonals of matrix {cmd:X}, 

		{cmd:d = subdiagget(X, (4,2), 0)}


{marker conformability}{...}
{title:Conformability}

    {cmd:subdiagget(}{it:X}{cmd:)}:
                  {it:X}:   {it:n x n}
             {it:result}:   {it:p x 1}        where {it:p < n}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:subdiagget(}{it:X}{cmd:)} aborts with error if {it:X} is not square.

{p 4 4 2}
Negative subscripts in {it:lower} and {it:upper} are treated as positive.

{p 4 4 2}
Subscripts greater than or equal to {cmd:cols(}{it:X}{cmd:)} in {it:lower} and
{it:upper} are ignored.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view subdiagget.mata, adopath asis:subdiagget.mata}
{p_end}
