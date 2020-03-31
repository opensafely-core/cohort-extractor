{smcl}
{* *! version 1.2.1  02aug2018}{...}
{vieweralsosee "[M-5] exp()" "mansection M-5 exp()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Scalar" "help m4_scalar"}{...}
{viewerjumpto "Syntax" "mf_exp##syntax"}{...}
{viewerjumpto "Description" "mf_exp##description"}{...}
{viewerjumpto "Conformability" "mf_exp##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_exp##diagnostics"}{...}
{viewerjumpto "Source code" "mf_exp##source"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-5] exp()} {hline 2}}Exponentiation and logarithms
{p_end}
{p2col:}({mansection M-5 exp():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric matrix}
{cmd:exp(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:ln(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:log(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:log10(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:expm1(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:ln1p(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:log1p(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:ln1m(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:log1m(}{it:numeric matrix Z}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:exp(}{it:Z}{cmd:)} returns the elementwise exponentiation of {it:Z}.
{cmd:exp()} returns real if {it:Z} is real and complex if {it:Z} is complex.

{p 4 4 2}
{cmd:ln(}{it:Z}{cmd:)} and {cmd:log(}{it:Z}{cmd:)} return the elementwise
natural logarithm of {it:Z}.  The functions are synonyms.
{cmd:ln()} and {cmd:log()} return real if {it:Z} is real and complex if {it:Z}
is complex.

{p 8 8 2}
    {cmd:ln(}{it:x}{cmd:)}, {it:x} real, returns the natural logarithm of 
    {it:x} or returns missing ({cmd:.}) if {it:x} <= 0.

{p 8 8 2}
    {cmd:ln(}{it:z}{cmd:)}, {it:z} complex, returns the complex natural 
    logarithm of {it:z}.  Im({cmd:ln()}) is chosen to be in the interval 
    (-{it:pi},{it:pi}].

{p 4 4 2}
{cmd:log10(}{it:Z}{cmd:)} returns the elementwise log base 10 of {it:Z}.
{cmd:log10()} returns real if {it:Z} is real and complex if {it:Z} is complex.
{cmd:log10(}{it:Z}{cmd:)} is defined mathematically and operationally 
as {cmd:ln(}{it:Z}{cmd:)}/{cmd:ln(10)}.

{p 4 4 2}
{cmd:expm1(}{it:Z}{cmd:)} returns {cmd:exp(}{it:z}{cmd:)}-1 for every element
{it:z} of real matrix {it:Z}. {cmd:expm1(}{it:z}{cmd:)} is more accurate
than {cmd:exp(}{it:z}{cmd:)}-1 for small values of |{it:z}|.

{p 4 4 2}
{cmd:ln1p(}{it:Z}{cmd:)} and {cmd:log1p(}{it:Z}{cmd:)} return
{cmd:log(}1+{it:z}{cmd:)} for every element {it:z} of real matrix {it:Z}. The
functions are synonyms. {cmd:ln1p(}{it:z}{cmd:)} is more accurate than
{cmd:ln(}1+{it:z}{cmd:)} for small values of |{it:z}|.

{p 4 4 2}
{cmd:ln1m(}{it:Z}{cmd:)} and {cmd:log1m(}{it:Z}{cmd:)} return 
{cmd:log(}1-{it:z}{cmd:)} for every element {it:z} of real matrix {it:Z}. The
functions are synonyms. {cmd:ln1m(}{it:z}{cmd:)} is more accurate than
{cmd:ln(}1-{it:z}{cmd:)} for small values of |{it:z}|.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:exp(}{it:Z}{cmd:)},
{cmd:ln(}{it:Z}{cmd:)},
{cmd:log(}{it:Z}{cmd:)},
{cmd:log10(}{it:Z}{cmd:)},
{cmd:expm1(}{it:Z}{cmd:)},
{cmd:ln1p(}{it:Z}{cmd:)},
{cmd:log1p(}{it:Z}{cmd:)},
{cmd:ln1m(}{it:Z}{cmd:)},
{cmd:log1m(}{it:Z}{cmd:)}:
{p_end}
	     {it:Z}:  {it:r x c}
	{it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:exp(}{it:Z}{cmd:)} returns missing when Re({it:Z})>709.

{p 4 4 2}
{cmd:ln(}{it:Z}{cmd:)}, 
{cmd:log(}{it:Z}{cmd:)}, and
{cmd:log10(}{it:Z}{cmd:)}
return missing when {it:Z} is real and {it:Z}<=0.
In addition, the functions return missing ({cmd:.}) for real
arguments when the result would be complex.  For instance, 
{cmd:ln(-1)} = {cmd:.}, whereas 
{cmd:ln(-1+0i)} = 3.14159265i.

{p 4 4 2}
{cmd:expm1(}{it:Z}{cmd:)} returns missing when {it:Z}>709.

{p 4 4 2}
{cmd:ln1p(}{it:z}{cmd:)} and {cmd:log1p(}{it:z}{cmd:)} 
return missing when 1+{it:z}<=0.

{p 4 4 2}
{cmd:ln1m(}{it:z}{cmd:)} and {cmd:log1m(}{it:z}{cmd:)} 
return missing when 1-{it:z}<=0.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view log10.mata, adopath asis:log10.mata};
other functions are built in.
{p_end}
