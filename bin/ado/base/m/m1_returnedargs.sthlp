{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-1] Returned args" "mansection M-1 Returnedargs"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] Intro" "help m1_intro"}{...}
{viewerjumpto "Syntax" "m1_returnedargs##syntax"}{...}
{viewerjumpto "Description" "m1_returnedargs##description"}{...}
{viewerjumpto "Links to PDF documentation" "m1_returnedargs##linkspdf"}{...}
{viewerjumpto "Remarks" "m1_returnedargs##remarks"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-1] Returned args} {hline 2}}Function arguments used to return results
{p_end}
{p2col:}({mansection M-1 Returnedargs:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}


	{it:y} = {it:f}{cmd:(}{it:x}{cmd:,} ...{cmd:)}{...}
{col 40}(function returns result the usual way)

	{it:g}{cmd:(}{it:x}{cmd:,} ...{cmd:,} {it:y}{cmd:)}{...}
{col 40}(function returns result in argument {it:y})


{marker description}{...}
{title:Description}

{p 4 4 2}
Most Mata functions leave their arguments unchanged and return a result:

		: {it:y} = {it:f}{cmd:(}{it:x}{cmd:,} ...{cmd:)}

{p 4 4 2}
Some Mata functions, however, return nothing and instead return 
results in one or more arguments:  

		: {it:g}{cmd:(}{it:x}{cmd:,} ...{cmd:,} {it:y}{cmd:)}

{p 4 4 2}
If you use such functions interactively
and the arguments that are to receive results are not already defined
({it:y} in the above example), 
you will get a variable-not-found error.  The solution is to define the
arguments to contain something -- anything -- before calling the function:

		: {it:y} {cmd:= .}

		: {it:g}{cmd:(}{it:x}{cmd:,} ...{cmd:,} {it:y}{cmd:)}

{p 4 4 2}
You can combine this into one statement:

		: {it:g}{cmd:(}{it:x}{cmd:,} ...{cmd:,} {it:y}{cmd:=.)}

{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-1 ReturnedargsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:sqrt(}{it:a}{cmd:)} -- see {bf:{help mf_sqrt:[M-5] sqrt()}} -- calculates
the (element-by-element) square root of {it:a} and returns the result:

		: {cmd:x = 4}

		: {cmd:y = sqrt(x)}

		: {cmd:y}               // {cmd:y} now contains 2
		  2

		: {cmd:x}               // {cmd:x} is unchanged
		  4

{p 4 4 2}
Most functions work like {cmd:sqrt()}, although many take more than one 
argument.

{p 4 4 2}
On the other hand, 
{cmd:polydiv(}{it:ca}{cmd:,} 
{it:cb}{cmd:,}
{it:cq}{cmd:,}
{it:cr}{cmd:)} --
see {bf:{help mf_polyeval:[M-5] polyeval()}} --
takes the polynomial stored in {it:ca} and the polynomial stored in 
{it:cb} and divides them.  It returns the quotient in the third argument
({it:cq}) and the remainder in the fourth ({it:cr}).  
{it:ca} and {it:cb} are left unchanged.
The function itself returns nothing:

		: {cmd:A = (1,2,3)}

		: {cmd:B = (0,1)}

		: {cmd:polydiv(A, B, Q, R)}

		: {cmd:Q}             // {cmd:Q} has been redefined
		{res}       {txt}1   2
		    {c TLC}{hline 9}{c TRC}
		  1 {c |}  {res}2   3{txt}  {c |}
		    {c BLC}{hline 9}{c BRC}

		: {cmd:R}            // as has {cmd:R}
		  1

		: {cmd:A}             // while {cmd:A} and {cmd:B} are unchanged
		{res}       {txt}1   2   3
		    {c TLC}{hline 13}{c TRC}
		  1 {c |}  {res}1   2   3{txt}  {c |}
		    {c BLC}{hline 13}{c BRC}

		: {cmd:B}
		{res}       {txt}1   2
		    {c TLC}{hline 9}{c TRC}
		  1 {c |}  {res}0   1{txt}  {c |}
		    {c BLC}{hline 9}{c BRC}

{p 4 4 2}
As another example, 
{cmd:st_view(}{it:V}{cmd:,} {it:i}{cmd:,} {it:j}{cmd:)} --
see {bf:{help mf_st_view:[M-5] st_view()}} -- 
creates a view 
onto the Stata dataset.  
Views are like matrices but consume less memory.
Arguments {it:i} and {it:j} specify the 
observations and variables to be selected.  Rather than returning the 
matrix, however, the result is returned in the first argument ({it:V}).

		: {cmd:st_view(V, (1\5), ("mpg", "weight"))}

		: {cmd:V}
		{res}       {txt}   1      2
		    {c TLC}{hline 15}{c TRC}
		  1 {c |}  {res}  22   2930{txt}  {c |}
		  2 {c |}  {res}  15   4080{txt}  {c |}
		    {c BLC}{hline 15}{c BRC}

{p 4 4 2}
If you try to use these functions interactively, you will probably
get an error:

		: {cmd:polydiv(A, B, Q, R)}
		{res}{err}                 <istmt>:  3499  Q not defined
		{txt}r(3499);

		: {cmd:st_view(V, (1\5), ("mpg", "weight"))}
		{res}{err}                 <istmt>:  3499  V not defined
		{txt}r(3499);

{p 4 4 2}
Arguments must be defined before they are used, even if their only purpose 
is to receive a newly calculated result.  In such cases, it does not 
matter how the argument is defined because its contents will be replaced.
Easiest is to fill in a missing value:

		: {cmd:Q = .}
		: {cmd:R = .}
		: {cmd:polydiv(A, B, Q, R)}

		: {cmd:V = .}
		: {cmd:st_view(V, (1\5), ("mpg", "weight"))}

{p 4 4 2}
You can also define the argument inside the function:

		: {cmd:polydiv(A, B, Q=., R=.)}

		: {cmd:st_view(V=., (1\5), ("mpg", "weight"))}

{p 4 4 2}
When you use functions like these inside a program, however, you need 
not worry about defining the arguments, because they are defined 
by virtue of appearing in your program:

		{cmd:function foo()}
		{cmd:{c -(}}
		      ...
		      {cmd:polydiv(A, B, Q, R)}
		      {cmd:st_view(V, (1\5), ("mpg", "weight"))}
		      ...
		{cmd:{c )-}}

{p 4 4 2} 
When Mata compiles your program, however, you may see warning messages:

		: {cmd:function foo()}
		> {cmd:{c -(}}
		>       ...
		>       {cmd:polydiv(A, B, Q, R)}
		>       {cmd:st_view(V, (1\5), ("mpg", "weight"))}
		>       ...
		> {cmd:{c )-}}
		note: variable Q may be used before set
		note: variable R may be used before set
		note: variable V may be used before set

{p 4 4 2}
If the warning messages bother you, either define the variables before 
they are used just as you would interactively or use {cmd:pragma} 
to suppress the warning messages; see 
{bf:{help m2_pragma:[M-2] pragma}}.
{p_end}
