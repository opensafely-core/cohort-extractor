{smcl}
{* *! version 1.1.8  15may2018}{...}
{vieweralsosee "[M-5] invsym()" "mansection M-5 invsym()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] cholinv()" "help mf_cholinv"}{...}
{vieweralsosee "[M-5] diag0cnt()" "help mf_diag0cnt"}{...}
{vieweralsosee "[M-5] luinv()" "help mf_luinv"}{...}
{vieweralsosee "[M-5] pinv()" "help mf_pinv"}{...}
{vieweralsosee "[M-5] qrinv()" "help mf_qrinv"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{vieweralsosee "[M-4] Solvers" "help m4_solvers"}{...}
{viewerjumpto "Syntax" "mf_invsym##syntax"}{...}
{viewerjumpto "Description" "mf_invsym##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_invsym##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_invsym##remarks"}{...}
{viewerjumpto "Conformability" "mf_invsym##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_invsym##diagnostics"}{...}
{viewerjumpto "Source code" "mf_invsym##source"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] invsym()} {hline 2}}Symmetric real matrix inversion
{p_end}
{p2col:}({mansection M-5 invsym():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{col 9}{it:real matrix} {cmd:invsym(}{it:real matrix A}{cmd:)}

{col 9}{...}
{it:real matrix} {cmd:invsym(}{...}
{it:real matrix A}{...}
{cmd:,} {...}
{it:real vector order}{...}
{cmd:)}


{col 9}{it:void}       {cmd:_invsym(}{it:real matrix A}{cmd:)}

{col 9}{it:void}       {cmd:_invsym(}{...}
{it:real matrix A}{...}
{cmd:,} {...}
{it:real vector order}{...}
{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:invsym(}{it:A}{cmd:)} returns a generalized inverse of real, symmetric,
positive-semidefinite matrix {it:A}.

{p 4 4 2}
{cmd:invsym(}{it:A}{cmd:,} {it:order}{cmd:)} does the same but allows 
you to specify which columns are to be swept first.

{p 4 4 2}
{cmd:_invsym(}{it:A}{cmd:)} 
and
{cmd:_invsym(}{it:A}{cmd:,} {it:order}{cmd:)} 
do the same thing as 
{cmd:invsym(}{it:A}{cmd:)} 
and
{cmd:invsym(}{it:A}{cmd:,} {it:order}{cmd:)} 
except that {it:A} is replaced with the generalized inverse result rather 
than the result being returned.
{cmd:_invsym()} uses less memory than {cmd:invsym()}.

{p 4 4 2}
{cmd:invsym()} and {cmd:_invsym()} are the routines Stata uses for calculating
inverses of symmetric matrices.

{p 4 4 2}
Also see 
{bf:{help mf_luinv:[M-5] luinv()}}, 
{bf:{help mf_qrinv:[M-5] qrinv()}}, 
and
{bf:{help mf_pinv:[M-5] pinv()}}
for general matrix inversion.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 invsym()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_invsym##remarks1:Definition of generalized inverse}
	{help mf_invsym##remarks2:Specifying the order in which columns are dropped}
	{help mf_invsym##remarks3:Determining the rank, or counting the number of dropped columns}
	{help mf_invsym##remarks4:Extracting linear dependencies}


{marker remarks1}{...}
{title:Definition of generalized inverse}

{p 4 4 2}
When the matrix is full rank and positive semidefinite, the matrix {it:A}
becomes positive definite and the generalized inverse equals the inverse, that
is, assuming {it:A} is {it:n x n},

		{cmd:invsym(}{it:A}{cmd:)*}{it:A} {cmd:=} {it:A}*{cmd:invsym(}{it:A}{cmd:) = I(}{it:n}{cmd:)}

{p 4 4 2}
or, at least the above restriction is true up to roundoff error.  When
{it:A} is not full rank, the generalized inverse {cmd:invsym()} satisfies
(ignoring roundoff error)

	                {it:A}{cmd:*invsym(}{it:A}{cmd:)*}{it:A} {cmd:=} {it:A}

	        {cmd:invsym(}{it:A}{cmd:)*}{it:A}{cmd:*invsym(}{it:A}{cmd:) = invsym(}{it:A}{cmd:)}

{p 4 4 2}
In the generalized case, there are an infinite number of inverse matrices
that can satisfy the above restrictions.  The one {cmd:invsym()} chooses 
is one that sets entire columns (and therefore rows) to 0, thus treating
{it:A} as if it were of reduced dimension.  Which columns (rows) are selected
is determined on the basis of minimizing roundoff error.

{p 4 4 2}
In the above we talk as if determining whether a matrix is full rank is 
an easy calculation.  That is not true.  Because of the roundoff error in the
manufacturing and recording of {it:A} itself, columns that ought to be
perfectly collinear will not be and yet you will still want {cmd:invsym()} to
behave as if they were.  {cmd:invsym()} tolerates a little deviation from
collinearity in making the perfectly collinear determination.


{marker remarks2}{...}
{title:Specifying the order in which columns are dropped}

{p 4 4 2}
Left to make the decision itself, {cmd:invsym()} will choose which columns to
drop (to set to 0) to minimize the overall roundoff error of the
generalized inverse calculation.  If column 1 and column 3 are collinear, 
then {cmd:invsym()} will choose to drop column 1 or column 3.

{p 4 4 2}
There are occasions, however, when you would like to ensure that a 
particular column or set of columns are not dropped.  Perhaps column 1 
corresponds to the intercept of a regression model and you would much 
rather, if one of columns 1 and 3 has to be dropped, that it be column 3.

{p 4 4 2}
Order allows you to specify the columns of the matrix that you would prefer 
not be dropped in the generalized inverse calculation.  In the above 
example, to prevent column 1 from being dropped, you could code 

	{cmd:invsym(}{it:A}{cmd:, 1)}

{p 4 4 2}
If you would like to keep columns 1, 5, and 10 from being dropped, you can 
code 

	{cmd:invsym(}{it:A}{cmd:, (1,5,10))}

{p 4 4 2}
Specifying columns not to be dropped does not guarantee that they will not 
be dropped because they still might be collinear with each other or they 
might equal constants.  However, if any other column can be dropped 
to satisfy your desire, it will be.


{marker remarks3}{...}
{title:Determining the rank, or counting the number of dropped columns}

{p 4 4 2}
If a column is dropped, 0 will appear on the corresponding diagonal entry.
Hence, the rank of the original matrix can be extracted after 
inversion by {cmd:invsym()}:

	: {cmd:Ainv = invsym(A)}
	: {cmd:rank = rows(Ainv)-diag0cnt(Ainv)}

{p 4 4 2}
See {bf:{help mf_diag0cnt:[M-5] diag0cnt()}}.


{marker remarks4}{...}
{title:Extracting linear dependencies}

{p 4 4 2}
The linear dependencies can be read from the rows of
{it:A}{cmd:*}{cmd:invsym(}{it:A}{cmd:)}:

	: {cmd:A*invsym(A)}
	{res}       {txt}           1              2              3
	    {c TLC}{hline 46}{c TRC}
	  1 {c |}  {res}           0             -1              1{txt}  {c |}
	  2 {c |}  {res}           0              1   -2.22045e-16{txt}  {c |}
	  3 {c |}  {res}           0              0              1{txt}  {c |}
	    {c BLC}{hline 46}{c BRC}

{p 4 4 2}
The above is interpreted to mean

		{it:x1} = -{it:x2} + {it:x3}
		{it:x2} = {it:x2} 
		{it:x3} = {it:x3}

{p 4 4 2}
ignoring roundoff error.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:invsym(}{it:A}{cmd:)}, 
{cmd:invsym(}{it:A}{cmd:,} {it:order}{cmd:)}:
{p_end}
		{it:A}:  {it:n x n}
	    {it:order}:  1 x {it:k}  or  {it:k} x 1, {it:k} <= {it:n}    (optional)
	   {it:result}:  {it:n} x {it:n}

{p 4 4 2}
{cmd:_invsym(}{it:A}{cmd:)}, 
{cmd:_invsym(}{it:A}{cmd:,} {it:order}{cmd:)}:
{p_end}
		{it:A}:  {it:n x n}
	    {it:order}:  1 x {it:k}  or  {it:k} x 1, {it:k} <= {it:n}    (optional)
	 {it:output}:
		{it:A}:  {it:n x n}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:invsym(}{it:A}{cmd:)}, 
{cmd:invsym(}{it:A}{cmd:,} {it:order}{cmd:)}, 
{cmd:_invsym(}{it:A}{cmd:)}, and 
{cmd:_invsym(}{it:A}{cmd:,} {it:order}{cmd:)}
ASSUME that
{it:A} is symmetric; they do not check.
If {it:A} is nonsymmetric, they treat it as if it were symmetric and equal 
to its UPPER triangle.

{p 4 4 2}
{cmd:invsym()} and {cmd:_invsym()}
return a result containing missing values if 
{it:A} contains missing values.  

{p 4 4 2}
{cmd:_invsym()} aborts with error if {it:A} is a view.  Both
functions abort with argument-out-of-range error if {it:order} is specified
and contains values less than 1, greater than {cmd:rows(}{it:A}{cmd:)}, or
the same value more than once.

{p 4 4 2}
{cmd:invsym()} and {cmd:_invsym()} return a matrix of zeros if {it:A} is not
positive semidefinite.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
