{smcl}
{* *! version 1.2.6  14may2018}{...}
{vieweralsosee "[M-5] st_matrix()" "mansection M-5 st_matrix()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_global()" "help mf_st_global"}{...}
{vieweralsosee "[M-5] st_rclear()" "help mf_st_rclear"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_matrix##syntax"}{...}
{viewerjumpto "Description" "mf_st_matrix##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_matrix##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_matrix##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_matrix##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_matrix##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_matrix##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] st_matrix()} {hline 2}}Obtain and put Stata matrices
{p_end}
{p2col:}({mansection M-5 st_matrix():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix}{bind:  }
{cmd:st_matrix(}{it:string scalar name}{cmd:)}

{p 8 12 2}
{it:string matrix} 
{cmd:st_matrixrowstripe(}{it:string scalar name}{cmd:)}

{p 8 12 2}
{it:string matrix} 
{cmd:st_matrixcolstripe(}{it:string scalar name}{cmd:)}


{p 8 12 2}
{it:void}{bind:         }
{cmd:st_matrix(}{it:string scalar name}{cmd:,}
{it:real matrix X}{cmd:)}

{p 8 52 2}
{it:void}{bind:         }
{cmd:st_matrix(}{it:string scalar name}{cmd:,}
{it:real matrix X}{cmd:,}{break}
{it:string scalar hcat}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:st_matrixrowstripe(}{it:string scalar name}{cmd:,}
{it:string matrix s}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:st_matrixcolstripe(}{it:string scalar name}{cmd:,}
{it:string matrix s}{cmd:)}


{p 8 12 2}
{it:void}{bind:         }
{cmd:st_replacematrix(}{it:string scalar name}{cmd:,}
{it:real matrix X}{cmd:)}


{p 8 12 2}
{it:string} {it:scalar}
{cmd:st_matrix_hcat(}{it:name}{cmd:)}


{p 4 8 2}
where

{p 8 12 2}
1.  All functions allow {it:name} to be 
{p_end}
{p 16 20 2}
     a.  global matrix name such as {cmd:"mymatrix"},
{p_end}

{p 16 20 2}
     b.  {cmd:r()} matrix such as {cmd:"r(Z)"}, or
{p_end}

{p 16 20 2}
     c.  {cmd:e()} matrix such as {cmd:"e(V)"}.

{p 8 12 2}
2.  {cmd:st_matrix(}{it:name}{cmd:)} returns the contents of the specified
    Stata matrix.  It returns {cmd:J(0,0,.)} if the matrix does not exist.

{p 8 12 2}
3.  {cmd:st_matrix(}{it:name}{cmd:,} {it:X}{cmd:)} sets or resets the 
    contents of the specified Stata matrix.  Row and column stripes are set to
    the default {cmd:r1}, {cmd:r2}, ..., and {cmd:c1}, {cmd:c2}, ....
    
{p 8 12 2}
4.  {cmd:st_replacematrix(}{it:name}{cmd:,} {it:X}{cmd:)} is an alternative
    way to replace existing Stata matrices.  The number of rows and columns of
    {it:X} must match the Stata matrix being replaced, and in return, the row
    and column stripes are not replaced.

{p 8 12 2}
5.  {cmd:st_matrix(}{it:name}{cmd:,} {it:X}{cmd:)} deletes the 
    specified Stata matrix if {it:value}{cmd:==J(0,0,.)} (if 
    value is 0 {it:x} 0).

{p 8 12 2}
6.  Neither {cmd:st_matrix()} nor {cmd:st_replacematrix()} can be used to set,
    replace, or delete special Stata {cmd:e()} matrices {cmd:e(b)},
    {cmd:e(V)}, or {cmd:e(Cns)}.  Only Stata commands {cmd:ereturn} {cmd:post}
    and {cmd:ereturn} {cmd:repost} can be used to set these special matrices;
    see {bf:{help ereturn:[P] ereturn}}.  
    Also see {bf:{help mf_stata:[M-5] stata()}}
    for executing Stata commands from Mata.

{p 8 12 2}
7.  {cmd:st_matrix(}{it:name}{cmd:,} {it:X}{cmd:,} {it:hcat}{cmd:)} 
    sets or resets the specified Stata matrix and sets the hidden 
    or historical status when setting a Stata {cmd:e()} or {cmd:r()} matrix.
    Allowed {it:hcat} values are "{cmd:visible}", "{cmd:hidden}",
    "{cmd:historical}", and a string scalar release number such as "{cmd:10}",
    "{cmd:10.1}", or any string release number matching
    "{it:#}[{it:#}][{cmd:.}[{it:#}[{it:#}]]]".  See {manlink P return} for a
    description of hidden and historical stored results.

{p 8 12 2}
8.  {cmd:st_matrix_hcat(}{it:name}{cmd:)} returns the {it:hcat} 
    associated with a Stata {cmd:e()} or {cmd:r()} matrix.

{p 8 12 2}
9.  {cmd:st_matrixrowstripe()} and {cmd:st_matrixcolstripe()} 
    allow querying and resetting the row and column stripes of 
    existing or previously created Stata matrices.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_matrix(}{it:name}{cmd:)} returns the contents of Stata's matrix
{it:name}, or it returns {cmd:J(0,0,.)} if the matrix does not exist.

{p 4 4 2}
{cmd:st_matrixrowstripe(}{it:name}{cmd:)} returns the row stripe associated
with the matrix {it:name}, or it returns {cmd:J(0,2,"")} if the matrix does not 
exist.

{p 4 4 2}
{cmd:st_matrixcolstripe(}{it:name}{cmd:)} returns the column stripe
associated with the matrix {it:name}, or it returns {cmd:J(0,2,"")} if the 
matrix does not exist.

{p 4 4 2}
{cmd:st_matrix(}{it:name}, {it:X}{cmd:)} sets or resets the contents of the
Stata matrix {it:name} to be {it:X}.  If the matrix did not previously exist,
a new matrix is created.  If the matrix did exist, the new contents replace
the old.  Either way, the row and column stripes are also reset to contain
{cmd:"r1"}, {cmd:"r2"}, ..., and {cmd:"c1"}, {cmd:"c2"}, ...

{p 4 4 2}
{cmd:st_matrix(}{it:name}, {it:X}{cmd:)}
deletes the Stata matrix {it:name} when {it:X} is 0 {it:x} 0:
{cmd:st_matrix(}{it:name}{cmd:, J(0,0,.))} deletes Stata matrix {it:name}
or does nothing if {it:name} does not exist.

{p 4 4 2}
{cmd:st_matrixrowstripe(}{it:name}, {it:s}{cmd:)} and
{cmd:st_matrixcolstripe(}{it:name}, {it:s}{cmd:)} 
change the contents to be {it:s} of the row and column stripe 
associated with the already existing Stata matrix {it:name}.
In either case, {it:s} must be {it:n} {it:x} 2, where {it:n} = the number of
rows (columns) of the underlying matrix.

{p 4 4 2}
{cmd:st_matrixrowstripe(}{it:name}, {it:s}{cmd:)} and
{cmd:st_matrixcolstripe(}{it:name}, {it:s}{cmd:)}
reset the row and column stripe to be {cmd:"r1"}, {cmd:"r2"}, ..., and 
{cmd:"c1"}, {cmd:"c2"}, ..., when {it:s} is 0 {it:x} 2 (that is,
{cmd:J(0,2,"")}).

{p 4 4 2}
{cmd:st_replacematrix(}{it:name}, {it:X}{cmd:)} resets the contents of the
Stata matrix {it:name} to be {it:X}.  The existing Stata matrix must have
the same number of rows and columns as {it:X}.  The row stripes and column
stripes remain unchanged.

{p 4 4 2}
{cmd:st_matrix(}{it:name}{cmd:,} {it:X}{cmd:,} {it:hcat}{cmd:)} 
and 
{cmd:st_matrix_hcat(}{it:name}{cmd:)}
are used to set and query the {it:hcat} corresponding to a
Stata {cmd:e()} or {cmd:r()} matrix.  They are also rarely used.
See {manlink R Stored results} and {manlink P return} for more 
information.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_matrix()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{marker remarks1}{...}
{title:Processing Stata's row and column stripes}

{p 4 4 2} 
Both row stripes and column stripes are presented in the same way:
each row of {it:s} represents the {it:eq}{cmd::}{it:op}{cmd:.}{it:name}
associated with a row or column of the underlying matrix.  The first column
records {it:eq}, and the second column records {it:op}{cmd:.}{it:name}.  For
instance, given the following Stata matrix

                                eq2:  eq2:
                            L.          L.
                   turn  turn  turn  turn
              mpg     1     2     3     4
            L.mpg     5     6     7     8
          eq2:mpg     9    10    11    12
        eq2:L.mpg    13    14    15    16

{p 4 4 2} 
{cmd:st_matrixrowstripe(}{it:name}{cmd:)} returns the 4 {it:x} 2 string matrix

	""      "mpg"
	""      "L.mpg"
	"eq2"	"mpg"
	"eq2"	"L.mpg"

{p 4 4 2} 
and {cmd:st_matrixcolstripe(}{it:name}{cmd:)} returns 

	""      "turn"
	""      "L.turn"
	"eq2"	"turn"
	"eq2"	"L.turn"


{marker conformability}{...}
{title:Conformability}

    {cmd:st_matrix(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  {it:m x n}  (0 {it:x} 0 if not found)

    {cmd:st_matrixrowstripe(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  {it:m x} 2  (0 {it:x} 2 if not found)

    {cmd:st_matrixcolstripe(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  {it:n x} 2  (0 {it:x} 2 if not found)

    {cmd:st_matrix(}{it:name}{cmd:,} {it:X}{cmd:)}:
	     {it:name}:  1 {it:x} 1
		{it:X}:  {it:r x c}  (0 {it:x} 0 means delete)
	   {it:result}:  {it:void}

    {cmd:st_matrix(}{it:name}{cmd:,} {it:X}{cmd:,} {it:hcat}{cmd:)}:
	     {it:name}:  1 {it:x} 1
		{it:X}:  {it:r x c}
	     {it:hcat}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {cmd:st_matrixrowstripe(}{it:name}{cmd:,} {it:s}{cmd:)}:
	     {it:name}:  1 {it:x} 1
		{it:s}:  {it:r x} 2  (0 {it:x} 2 means default {cmd:"r1"}, {cmd:"r2"}, ...)
	   {it:result}:  {it:void}

    {cmd:st_matrixcolstripe(}{it:name}{cmd:,} {it:s}{cmd:)}:
	     {it:name}:  1 {it:x} 1
		{it:s}:  {it:c x} 2  (0 {it:x} 2 means default {cmd:"c1"}, {cmd:"c2"}, ...)
	   {it:result}:  {it:void}

    {cmd:st_replacematrix(}{it:name}{cmd:,} {it:X}{cmd:)}:
	     {it:name}:  1 {it:x} 1
		{it:X}:  {it:m x n}  (0 {it:x} 0 means delete)
	   {it:result}:  {it:void}

    {cmd:st_matrix_hcat(}{it:name}{cmd:)}
	     {it:name}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_matrix(}{it:name}{cmd:)},
{cmd:st_matrixrowstripe(}{it:name}{cmd:)}, and
{cmd:st_matrixcolstripe(}{it:name}{cmd:)}
abort with error if {it:name} is malformed. Also,

{p 8 12 2}
1.
{cmd:st_matrix(}{it:name}{cmd:)}
returns {cmd:J(0,0,.)} if Stata matrix {it:name} does not exist.

{p 8 12 2}
2.
{cmd:st_matrixrowstripe(}{it:name}{cmd:)} and
{cmd:st_matrixcolstripe(}{it:name}{cmd:)}
return {cmd:J(0,2,"")} if Stata matrix {it:name} does not exist.  There is no
possibility that matrix {it:name} might exist and not have row and column
stripes.

{p 4 4 2}
{cmd:st_matrix(}{it:name}{cmd:,} {it:X}{cmd:)}, 
{cmd:st_matrixrowstripe(}{it:name}{cmd:,} {it:s}{cmd:)}, and 
{cmd:st_matrixcolstripe(}{it:name}{cmd:,} {it:s}{cmd:)}
abort with error if {it:name} is malformed. Also,

{p 8 12 2}
1.
{cmd:st_matrixrowstripe(}{it:name}{cmd:,} {it:s}{cmd:)}
aborts with error if {cmd:rows(}{it:s}{cmd:)} is not equal to the 
number of rows of Stata matrix {it:name} and 
{cmd:rows(}{it:s}{cmd:)}!=0, or if {cmd:cols(}{it:s}{cmd:)}!=2.

{p 8 12 2}
2.
{cmd:st_matrixcolstripe(}{it:name}{cmd:,} {it:s}{cmd:)}
aborts with error if {cmd:cols(}{it:s}{cmd:)} is not equal to the 
number of columns of Stata matrix {it:name} and 
{cmd:cols(}{it:s}{cmd:)}!=0, or if {cmd:cols(}{it:s}{cmd:)}!=2.

{p 4 4 7}
{cmd:st_replacematrix(}{it:name}{cmd:,} {it:X}{cmd:)} 
aborts with error if 
Stata matrix {it:name} does not have the same number of rows and 
columns as {it:X}.  
{cmd:st_replacematrix()} also aborts with error if 
Stata matrix {it:name} does not exist and 
{it:X}{cmd:!=J(0,0,.)}; {cmd:st_replacematrix()} does nothing if 
the matrix does not exist and {it:X}{cmd:==J(0,0,.)}.
{cmd:st_replacematrix()} aborts with error if {it:name} is malformed.

{p 4 4 2}
{cmd:st_matrix(}{it:name}{cmd:,} {it:X}{cmd:,} {it:hcat}{cmd:)}
aborts with error if {it:hcat} is not an allowed value.

{p 4 4 2}
{cmd:st_matrix_hcat(}{it:name}{cmd:)} returns "{cmd:visible}" when 
{it:name} is not a Stata {cmd:e()} or {cmd:r()} matrix and returns
{cmd:""} when {cmd:name} is an {cmd:e()} or {cmd:r()} value that 
does not exist.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
