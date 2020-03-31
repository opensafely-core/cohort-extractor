{smcl}
{* *! version 1.1.7  15may2018}{...}
{vieweralsosee "[M-5] polyeval()" "mansection M-5 polyeval()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Mathematical" "help m4_mathematical"}{...}
{viewerjumpto "Syntax" "mf_polyeval##syntax"}{...}
{viewerjumpto "Description" "mf_polyeval##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_polyeval##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_polyeval##remarks"}{...}
{viewerjumpto "Conformability" "mf_polyeval##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_polyeval##diagnostics"}{...}
{viewerjumpto "Source code" "mf_polyeval##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] polyeval()} {hline 2}}Manipulate and evaluate polynomials
{p_end}
{p2col:}({mansection M-5 polyeval():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric vector}{bind:   }
{cmd:polyeval(}{it:numeric rowvector c}{cmd:,}
{it:numeric vector x}{cmd:)}

{p 8 12 2}
{it:numeric rowvector}
{cmd:polysolve(}{it:numeric vector y}{cmd:,}
{it:numeric vector x}{cmd:)}

{p 8 12 2}
{it:numeric rowvector}
{cmd:polytrim(}{it:numeric vector c}{cmd:)}


{p 8 12 2}
{it:numeric rowvector}
{cmd:polyderiv(}{it:numeric rowvector c}{cmd:,}
{it:real scalar i}{cmd:)}

{p 8 12 2}
{it:numeric rowvector}
{cmd:polyinteg(}{it:numeric rowvector c}{cmd:,}
{it:real scalar i}{cmd:)}


{p 8 12 2}
{it:numeric rowvector}
{cmd:polyadd(}{it:numeric rowvector c1}{cmd:,}
{it:numeric rowvector c2}{cmd:)}

{p 8 12 2}
{it:numeric rowvector}
{cmd:polymult(}{it:numeric rowvector c1}{cmd:,}
{it:numeric rowvector c2}{cmd:)}

{p 8 34 2}
{it:void}{bind:             }
{cmd:polydiv(}{it:numeric rowvector c1}{cmd:,}
{it:numeric rowvector c2}{cmd:,}{break}
{it:cq}{cmd:,}
{it:cr}{cmd:)}


{p 8 34 2}
{it:complex rowvector}
{cmd:polyroots(}{it:numeric rowvector c}{cmd:)}


{p 4 4 2}
In the above, row vector {it:c} contains the coefficients 
for a {cmd:cols(}{it:c}{cmd:)}-1 degree polynomial.  For instance, 

			{it:c} = (4, 2, 1)

{p 4 4 2}
records the polynomial

			4 + 2{it:x} + {it:x}^2


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:polyeval(}{it:c}{cmd:,} {it:x}{cmd:)}
evaluates polynomial {it:c} at each value recorded in {it:x}, 
returning the results in a p-conformable-with-{it:x} vector.
For instance, 
{cmd:polyeval((4,2,1), (3\5))} returns
(4+2*3+3^2 \ 4+2*5+5^2) = (19 \ 39).

{p 4 4 2}
{cmd:polysolve(}{it:y}{cmd:,} {it:x}{cmd:)}
returns the minimal-degree polynomial {it:c} fitting {it:y} =
{cmd:polyeval(}{it:c}{cmd:,} {it:x}{cmd:)}.  Solution is via Lagrange's
interpolation formula.

{p 4 4 2}
{cmd:polytrim(}{it:c}{cmd:)}
returns polynomial {it:c} with trailing zeros removed.  For instance, 
{cmd:polytrim((1,2,3,0))} returns (1,2,3).  
{cmd:polytrim((0,0,0,0))} returns (0).
Thus if {it:n} = {cmd:cols(polytrim(}{it:c}{cmd:))}, then {it:c} records
an ({it:n}-1)th degree polynomial.

{p 4 4 2}
{cmd:polyderiv(}{it:c}{cmd:,} {it:i}{cmd:)}
returns the polynomial that is the {it:i}th derivative of polynomial {it:c}.
For instance,
{cmd:polyderiv((4,2,1), 1)} returns (2,2) (the derivative of 
4+2{it:x}+{it:x}^2 is 2+2{it:x}).
The value of the first derivative of polynomial {it:c} at {it:x} is
{cmd:polyeval(polyderiv(}{it:c}{cmd:,1),} {it:x}{cmd:)}.

{p 4 4 2}
{cmd:polyinteg(}{it:c}{cmd:,} {it:i}{cmd:)}
returns the polynomial that is the {it:i}th integral of polynomial {it:c}.
For instance,
{cmd:polyinteg((4,2,1), 1)} returns (0,4,1,.3333)
(the integral of 
4+2{it:x}+{it:x}^2 
is 
0+4{it:x}+{it:x}^2+.3333{it:x}^3).
The value of the integral of polynomial {it:c} at {it:x} is
{cmd:polyeval(polyinteg(}{it:c}{cmd:,1),} {it:x}{cmd:)}.

{p 4 4 2}
{cmd:polyadd(}{it:c1}{cmd:,} {it:c2}{cmd:)}
returns the polynomial that is the sum of the polynomials {it:c1} and 
{it:c2}.  
For instance, 
{cmd:polyadd((2,1), (3,5,1))} is (5,6,1)
(the sum of 2+{it:x} and 3+5{it:x}+{it:x}^2 is 
5+6{it:x}+{it:x}^2).

{p 4 4 2}
{cmd:polymult(}{it:c1}{cmd:,} {it:c2}{cmd:)}
returns the polynomial that is the product of the polynomials {it:c1} and 
{it:c2}.
For instance, 
{cmd:polymult((2,1), (3,5,1))} is (6,13,7,1) 
(the product of 2+{it:x} and 3+5{it:x}+{it:x}^2 is 
6+13{it:x}+7{it:x}^2+{it:x}^3).

{p 4 4 2}
{cmd:polydiv(}{it:c1}{cmd:,} {it:c2}{cmd:,} {it:cq}{cmd:,} {it:cr}{cmd:)} 
calculates polynomial {it:c1}/{it:c2}, storing the quotient polynomial in
{it:cq} and the remainder polynomial in {it:cr}.  
For instance, 
{cmd:polydiv((3,5,1), (2,1),} {it:cq}{cmd:,} {it:cr}{cmd:)}
returns
{it:cq}=(3,1) and {it:cr}=(-3); that is,

		3+5{it:x}+{it:x}^2
		--------   =  3+{it:x} with a remainder of -3
		   2+{it:x}

{p 4 4 2}
or

		3+5{it:x}+{it:x}^2   =  (3+{it:x})(2+{it:x}) - 3

{p 4 4 2}
{cmd:polyroots(}{it:c}{cmd:)} find the roots of polynomial {it:c} and 
returns them in complex row vector (complex even if {it:c} is real).
For instance, {cmd:polyroots((3,5,1))} returns (-4.303+0i, -.697+0i) (the
roots of 3+5{it:x}+{it:x}^2 are -4.303 and -.697).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 polyeval()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Given the real or complex coefficients {it:c} that define an {it:n}-1 degree
polynomial in {it:x}, {cmd:polyroots(}{it:c}{cmd:)} returns the {it:n}-1
roots for which

		0 = {it:c}_1 + {it:c}_2 * {it:x}^1 + {it:c}_3 * {it:x}^2 + ... + {it:c}_{it:n} * {it:x}^({it:n}-1)

{p 4 4 2}
{cmd:polyroots(}{it:c}{cmd:)} obtains the roots by calculating the
eigenvalues of the companion matrix.  The ({it:n}-1) x ({it:n}-1) companion
matrix for the polynomial defined by {it:c} is

                 {c TLC}                                                   {c TRC}
                 {c |} -{it:c}_[{it:n}-1]*{it:s}   -{it:c}_[{it:n}-2]*{it:s}  .  .  .  -{it:c}_[2]*{it:s}   -{it:c}_[1]*{it:s} {c |}
                 {c |}     1           0      .  .  .     0         0    {c |}
                 {c |}     0           1      .  .  .     0         0    {c |}
                 {c |}     .           .      .           .         .    {c |}
           {it:C}  =  {c |}     .           .         .        .         .    {c |}
                 {c |}     .           .            .     .         .    {c |}
                 {c |}     0           0      .  .  .     1         0    {c |}
                 {c |}     0           0      .  .  .     0         1    {c |}
                 {c BLC}                                                   {c BRC}


{p 4 4 2}
where

	{it:s}  =  1/{it:c}_[{it:n}]

{p 4 4 2}
if {it:c} is real and 

	{it:s}  =  C(Re({it:c}_[{it:n}])/(Re({it:c}_[{it:n}])^2+Im({it:c}_[{it:n}])^2),
					-Im({it:c}_[{it:n}])/(Re({it:c}_[{it:n}])^2+Im({it:c}_[{it:n}])^2))

{p 4 4 2}
otherwise.

{p 4 4 2}
As in all nonsymmetric eigenvalue problems, the returned roots are complex
and sorted from largest to smallest, see 
{bf:{help mf_eigensystem:[M-5] eigensystem()}}.


{marker conformability}{...}
{title:Conformability}

    {cmd:polyeval(}{it:c}{cmd:,} {it:x}{cmd:)}:
		{it:c}:  1 {it:x n}, {it:n}>0
		{it:x}:  {it:r x 1}  or  1 {it:x c}
	   {it:result}:  {it:r x 1}  or  1 {it:x c}

    {cmd:polysolve(}{it:y}{cmd:,} {it:x}{cmd:)}:
		{it:y}:  {it:n x} 1  or  1 {it:x n}, {it:n}>=1
		{it:x}:  {it:n x} 1  or  1 {it:x n}
	   {it:result}:  1 {it:x k}, 1 <= {it:k} <= {it:n}

    {cmd:polytrim(}{it:c}{cmd:)}:
		{it:c}:  1 {it:x n}
	   {it:result}:  1 {it:x k}, 1<={it:k}<={it:n}

    {cmd:polyderiv(}{it:c}{cmd:,} {it:i}{cmd:)}:
		{it:c}:  1 {it:x n}, {it:n}>0
		{it:i}:  1 {it:x} 1, {it:i} may be negative
	   {it:result}:  1 {it:x} max(1, {it:n}-{it:i})

    {cmd:polyinteg(}{it:c}{cmd:,} {it:i}{cmd:)}:
		{it:c}:  1 {it:x n}, {it:n}>0
		{it:i}:  1 {it:x} 1, {it:i} may be negative
	   {it:result}:  1 {it:x} max(1, {it:n}+{it:i})

    {cmd:polyadd(}{it:c1}{cmd:,} {it:c2}{cmd:)}:
	       {it:c1}:  1 {it:x n1}, {it:n1}>0
	       {it:c2}:  1 {it:x n2}, {it:n2}>0
	   {it:result}:  1 {it:x} max({it:n1}, {it:n2})

    {cmd:polymult(}{it:c1}{cmd:,} {it:c2}{cmd:)}:
	       {it:c1}:  1 {it:x n1}, {it:n1}>0
	       {it:c2}:  1 {it:x n2}, {it:n2}>0
	   {it:result}:  1 {it:x} {it:n1}+{it:n2}-1
		
    {cmd:polydiv(}{it:c1}{cmd:,} {it:c2}{cmd:,} {it:cq}{cmd:,} {it:cr}{cmd:)}:
	{it:input}:
	       {it:c1}:  1 {it:x n1}, {it:n1}>0
	       {it:c2}:  1 {it:x n2}, {it:n2}>0
	{it:output}:
	       {it:cq}:  1 {it:x k1}, 1 <= {it:k1} <= max({it:n1}-{it:n2}+1, 1)
	       {it:cr}:  1 {it:x k2}, 1 <= {it:k2} <= max({it:n1}-{it:n2}, 1)

    {cmd:polyroots(}{it:c}{cmd:)}:
		{it:c}:  1 {it:x n}, {it:n}>0
	   {it:result}:  1 {it:x k}-1, {it:k} = {cmd:cols(polytrim(}{it:c}{cmd:))}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
All functions abort with an error if a polynomial coefficient row vector is
void, but they do not necessarily give indicative error messages as to the
problem.  Polynomial coefficient row vectors may contain missing values.

{p 4 4 2}
{cmd:polyderiv(}{it:c}{cmd:,} {it:i}{cmd:)}
returns {it:c} when {it:i}=0.  It returns 
{cmd:polyinteg(}{it:c}{cmd:,} -{it:i}{cmd:)}
when {it:i}<0.  It returns (0) when {it:i} is missing (think of 
missing as positive infinity).

{p 4 4 2}
{cmd:polyinteg(}{it:c}{cmd:,} {it:i}{cmd:)}
returns {it:c} when {it:i}=0.  It returns 
{cmd:polyderiv(}{it:c}{cmd:,} -{it:i}{cmd:)}
when {it:i}<0.  It aborts with error if {it:i} is missing
(think of missing as positive infinity).

{p 4 4 2}
{cmd:polyroots(}{it:c}{cmd:)} returns a vector of missing values if 
any element of {it:c} equals missing.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view polyeval.mata, adopath asis:polyeval.mata},
{view polysolve.mata, adopath asis:polysolve.mata},
{view polytrim.mata, adopath asis:polytrim.mata},
{view polyderiv.mata, adopath asis:polyderiv.mata},
{view polyinteg.mata, adopath asis:polyinteg.mata},
{view polyadd.mata, adopath asis:polyadd.mata},
{view polymult.mata, adopath asis:polymult.mata},
{view polydiv.mata, adopath asis:polydiv.mata},
{view polyroots.mata, adopath asis:polyroots.mata}
{p_end}
