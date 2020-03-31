{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] solvelower()" "mansection M-5 solvelower()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] cholsolve()" "help mf_cholsolve"}{...}
{vieweralsosee "[M-5] lusolve()" "help mf_lusolve"}{...}
{vieweralsosee "[M-5] qrsolve()" "help mf_qrsolve"}{...}
{vieweralsosee "[M-5] solve_tol()" "help mf_solve_tol"}{...}
{vieweralsosee "[M-5] svsolve()" "help mf_svsolve"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_solvelower##syntax"}{...}
{viewerjumpto "Description" "mf_solvelower##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_solvelower##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_solvelower##remarks"}{...}
{viewerjumpto "Conformability" "mf_solvelower##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_solvelower##diagnostics"}{...}
{viewerjumpto "Source code" "mf_solvelower##source"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-5] solvelower()} {hline 2}}Solve AX=B for X, A triangular
{p_end}
{p2col:}({mansection M-5 solvelower():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}
 
{p 8 12 2}
{it:numeric matrix}
{cmd:solvelower(}{it:A}{cmd:,}
{it:B} 
[{cmd:,} {it:rank}
[{cmd:,} {it:tol}
[{cmd:,} {it:d}
]]]{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:solveupper(}{it:A}{cmd:,}
{it:B} 
[{cmd:,} {it:rank}
[{cmd:,} {it:tol}
[{cmd:,} {it:d}
]]]{cmd:)}


{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:_solvelower(}{it:A}{cmd:,}
{it:B}
[{cmd:,} {it:tol}
[{cmd:,} {it:d}]]{cmd:)}

{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:_solveupper(}{it:A}{cmd:,}
{it:B}
[{cmd:,} {it:tol}
[{cmd:,} {it:d}]]{cmd:)}


{p 4 4 2}
where

{p 24 24 2}
		{it:A}:  {it:numeric matrix}

{p 24 24 2}
		{it:B}:  {it:numeric matrix}

{p 21 24 2}
	     {it:rank}:  irrelevant; {it:real scalar} returned

{p 22 24 2}
	      {it:tol}:  {it:real scalar}

{p 24 24 2}
		{it:d}:  {it:numeric scalar}

	
{marker description}{...}
{title:Description}

{p 4 4 2}
These functions are used in the implementation of the other solve functions; 
see 
{bf:{help mf_lusolve:[M-5] lusolve()}},
{bf:{help mf_qrsolve:[M-5] qrsolve()}}, and
{bf:{help mf_svsolve:[M-5] svsolve()}}.

{p 4 4 2}
{cmd:solvelower(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)} and 
{cmd:_solvelower(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)} 
solve lower-triangular systems.

{p 4 4 2}
{cmd:solveupper(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)} and 
{cmd:_solveupper(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)} 
solve upper-triangular systems.

{p 4 4 2}
Functions without a leading underscore -- {cmd:solvelower()} and
{cmd:solveupper()} -- return the solution; {it:A} and {it:B} are unchanged.

{p 4 4 2}
Functions with a leading underscore -- {cmd:_solvelower()} and
{cmd:_solveupper()} -- return the solution in {it:B}.

{p 4 4 2}
All four functions produce a generalized solution if {it:A} is singular.
The functions without an underscore place the rank of {it:A} in 
{it:rank}, if the argument is specified.
The underscore functions return the rank.

{p 4 4 2}
Determination of singularity is made via {it:tol}.  {it:tol} is interpreted
in the standard way -- as a multiplier for the default if {it:tol}>0 is
specified and as an absolute quantity to use in place of the default if
{it:tol}<=0 is specified.

{p 4 4 2}
All four functions allow {it:d} to be optionally specified.
Specifying {it:d}=. is equivalent to not specifying {it:d}.

{p 4 4 2}
If {it:d}!=. is specified, that value is used as if it appeared
on the diagonal of {it:A}.  The four functions do not in fact require that 
{it:A} be triangular; they merely look at the lower or upper triangle and
pretend that the opposite triangle contains zeros.  This feature is useful
when a decomposition utility has stored both the lower and upper triangles in
one matrix, because one need not take apart the combined matrix.
In such cases, 
it sometimes happens that the diagonal of the matrix corresponds to one 
matrix but not the other, and that for the other matrix, one merely knows 
that the diagonal elements are, say, 1.  Then you can specify 
{it:d}=1.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 solvelower()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The triangular-solve functions documented here exploit the triangular
structure in {it:A} and solve for {it:X} by recursive substitution.

{p 4 4 2}
When {it:A} is of full rank, these functions provide the same
solution as 
the other solve functions, such as 
{bf:{help mf_lusolve:[M-5] lusolve()}},
{bf:{help mf_qrsolve:[M-5] qrsolve()}}, and
{bf:{help mf_svsolve:[M-5] svsolve()}}.
The {cmd:solvelower()} and {cmd:solveupper()} functions, however, will 
produce the answer more quickly because of the large computational 
savings.

{p 4 4 2}
When {it:A} is singular, however, you may wish to consider whether you want to
use these triangular-solve functions.  The triangular-solve functions
documented here reach a generalized solution by setting
{it:B}[{it:i},{it:j}]=0, for all {it:j}, when {it:A}[{it:i},{it:i}] is zero or
too small (as determined by {it:tol}).  The method produces a generalized
inverse, but there are many generalized inverses, and this one may not have
the other properties you want.

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_solvelower##remarks1:Derivation}
	{help mf_solvelower##remarks2:Tolerance}


{marker remarks1}{...}
{title:Derivation}

{p 4 4 2}
We wish to solve 

		{it:A}{it:X} = {it:B}{right:(1)    }

{p 4 4 2}
when {it:A} is triangular.  Let us consider the lower-triangular case first.
{cmd:solvelower()} is up to handling full matrices for {it:B} and {it:X}, but let
us assume
{it:X}: {it:n} {it:x} 1 and  
{it:B}: {it:m} {it:x} 1:

	      {c TLC}                             {c TRC}  {c TLC}     {c TRC}       {c TLC}     {c TRC}
	      {c |} {it:a_11}     0     0   ...    0 {c |}  {c |} {it:x_1} {c |}       {c |} {it:b_1} {c |}
	      {c |} {it:a_21  a_22}     0   ...    0 {c |}  {c |} {it:x_2} {c |}       {c |} {it:b_2} {c |}
	      {c |}  .      .      .   .      . {c |}  {c |}  .  {c |}   =   {c |}  .  {c |}
	      {c |}  .      .      .      .   . {c |}  {c |}  .  {c |}       {c |}  .  {c |}
	      {c |} {it:a_m1  a_r2  a_r3}   ... {it:a_mn} {c |}  {c |} {it:x_n} {c |}       {c |} {it:b_m} {c |}
	      {c BLC}                             {c BRC}  {c BLC}     {c BRC}       {c BLC}     {c BRC}

{p 4 4 2}
The first equation to be solved is 

		{it:a_11}*{it:x_1} = {it:b_1}

{p 4 4 2}
and the solution is simply 

{marker eq2}{...}
		{it:x_1} = {it:b_1}/{it:a_11}{right:(2)    }

{p 4 4 2}
The second equation to be solved is

		{it:a_21}*{it:x_1}  + {it:a_22}*{it:x_2} = {it:b_2}

{p 4 4 2}
and because we have already solved for {it:x_1}, the solution is simply

{marker eq3}{...}
		{it:x_2} = ({it:b_2} - {it:a_21}*{it:x_1})/{it:a_22}{right:(3)    }

{p 4 4 2}
We proceed similarly for the remaining rows of {it:A}.  
If there are additional columns in {it:B} and {it:X}, we can then proceed
to handling each remaining column just as we handled the first column
above.

{p 4 4 2}
In the upper-triangular case, the formulas are similar except that you start
with the last row of {it:A}.


{marker remarks2}{...}
{title:Tolerance}

{p 4 4 2}
In {help mf_solvelower##eq2:(2)} and {help mf_solvelower##eq3:(3)}, we divide
by the diagonal elements of {it:A}.  If element {it:a}_{it:ii} is less than
{it:eta} in absolute value, the corresponding {it:x}_{it:i} is set to zero.
{it:eta} is given by 

		{it:eta} = 1e-13 * trace(abs({it:A}))/rows({it:A})

{p 4 4 2}
If you specify {it:tol}>0, the value you specify is used to multiply {it:eta}.
You may instead specify {it:tol}<=0, and then the negative of the value you
specify is used in place of {it:eta}; 
see {bf:{help m1_tolerance:[M-1] Tolerance}}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:solvelower(}{it:A}{cmd:,} {it:B}{cmd:,} {it:rank}{cmd:,} {it:tol}{cmd:,} 
{it:d}{cmd:)},
{cmd:solveupper(}{it:A}{cmd:,} {it:B}{cmd:,} {it:rank}{cmd:,} {it:tol}{cmd:,} 
{it:d}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x k}
	      {it:tol}:  1 {it:x} 1    (optional)
	        {it:d}:  1 {it:x} 1    (optional)
	{it:output:}
             {it:rank}:  1 {it:x} 1    (optional)
	   {it:result}:  {it:n x k}

{p 4 4 2}
{cmd:_solvelower(}{it:A}{cmd:,} {it:B}{cmd:,} {it:tol}{cmd:,} {it:d}{cmd:)},
{cmd:_solveupper(}{it:A}{cmd:,} {it:B}{cmd:,} {it:tol}{cmd:,} {it:d}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x k}
	      {it:tol}:  1 {it:x} 1    (optional)
	        {it:d}:  1 {it:x} 1    (optional)
	{it:output:}
		{it:B}:  {it:n x k}
	   {it:result}:  1 {it:x} 1    (contains rank)


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:solvelower(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)}, 
{cmd:_solvelower(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)}, 
{cmd:solveupper(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)}, and
{cmd:_solveupper(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)}
do not verify that the upper (lower) triangle of
{it:A} contains zeros; they just use the lower (upper) triangle of {it:A}.

{p 4 4 2}
{cmd:_solvelower(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)} and 
{cmd:_solveupper(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)}
do not abort with error if {it:B} is a view but can produce 
results subject to considerable roundoff error.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view solvelower.mata, adopath asis:solvelower.mata},
{view solveupper.mata, adopath asis:solveupper.mata},
{view _solvelower.mata, adopath asis:_solvelower.mata},
{view _solveupper.mata, adopath asis:_solveupper.mata}
{p_end}
