{smcl}
{* *! version 1.1.7  15may2018}{...}
{vieweralsosee "[M-2] Subscripts" "mansection M-2 Subscripts"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_subscripts##syntax"}{...}
{viewerjumpto "Description" "m2_subscripts##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_subscripts##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_subscripts##remarks"}{...}
{viewerjumpto "Conformability" "m2_subscripts##conformability"}{...}
{viewerjumpto "Diagnostics" "m2_subscripts##diagnostics"}{...}
{viewerjumpto "Reference" "m2_subscripts##reference"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-2] Subscripts} {hline 2}}Use of subscripts
{p_end}
{p2col:}({mansection M-2 Subscripts:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{it:x}{cmd:[}{it:real vector r}{cmd:,} {it:real vector c}{cmd:]}

	{it:x}{cmd:[|}{it:real matrix sub}{cmd:|]}


{p 4 4 2}
Subscripts may be used on the left or right of the
{help m2_op_assignment:equal-assignment operator}.


{marker description}{...}
{title:Description}

{p 4 4 2}
Subscripts come in two styles.  

{p 4 4 2}
In {cmd:[}{it:subscript}{cmd:]} syntax -- called list subscripts -- an
element or a matrix is specified:

	{cmd:x[1,2]}                  the 1,2 element of {it:x}; a scalar

        {cmd:x[(1\3\2), (4,5)]}       the 3 {it:x} 2 matrix composed of rows 1, 3, and 2
{col 33}and columns 4 and 5 of {it:x}:
{col 42}{c TLC}            {c TRC}
{col 42}{c |} {it:x_14  x_15} {c |}
{col 42}{c |} {it:x_34  x_35} {c |}
{col 42}{c |} {it:x_24  x_25} {c |}
{col 42}{c BLC}            {c BRC}

{p 4 4 2}
In {cmd:[|}{it:subscript}{cmd:|]} syntax -- called range subscripts -- an
element or a contiguous submatrix is specified:

	{cmd:x[|1,2|]}                same as {cmd:x[1,2]}; a scalar

	{cmd:x[|2,3 \ 4,7|]}          3 {it:x} 4 submatrix of {it:x}:
{col 42}{c TLC}                              {c TRC}
{col 42}{c |} {it:x_23  x_24  x_25  x_26  x_27} {c |}
{col 42}{c |} {it:x_33  x_34  x_35  x_36  x_37} {c |}
{col 42}{c |} {it:x_43  x_44  x_45  x_46  x_47} {c |}
{col 42}{c BLC}                              {c BRC}

{p 4 4 2}
Both style subscripts may be used in expressions and may be used on the
left-hand side of the equal-assignment operator.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 SubscriptsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_subscripts##remarks1:List subscripts}
	{help m2_subscripts##remarks2:Range subscripts}
	{help m2_subscripts##remarks3:When to use list subscripts and when to use range subscripts}
	{help m2_subscripts##remarks4:A fine distinction}


{marker remarks1}{...}
{title:List subscripts}

{p 4 4 2}
List subscripts -- also known simply as subscripts -- are obtained 
when you enclose the subscripts in square brackets, {cmd:[} and {cmd:]}.
List subscripts come in two basic forms:

{col 9}{it:x}{cmd:[}{it:ivec}{cmd:,}{it:jvec}{cmd:]}{...}
{col 33}matrix composed of rows {it:ivec} and columns {it:jvec}
{col 33}of matrix {it:x}

{col 9}{it:v}{cmd:[}{it:kvec}{cmd:]}{...}
{col 33}vector composed of elements {it:kvec} of vector {it:v}

{p 4 4 2}
where {it:ivec}, {it:jvec}, {it:kvec} may be a vector or a scalar, 
so the two basic forms include

{col 9}{it:x}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:]}{...}
{col 33}scalar {it:i},{it:j} element

{col 9}{it:x}{cmd:[}{it:i}{cmd:,}{it:jvec}{cmd:]}{...}
{col 33}row vector of row {it:i}, elements {it:jvec}

{col 9}{it:x}{cmd:[}{it:ivec}{cmd:,}{it:j}{cmd:]}{...}
{col 33}column vector of column {it:j}, elements {it:ivec}

{col 9}{it:v}{cmd:[}{it:k}{cmd:]}{...}
{col 33}scalar {it:k}th element of vector {it:v}

{p 4 4 2}
Also missing value may be specified to mean all the rows or 
all the columns:

{col 9}{it:x}{cmd:[}{it:i}{cmd:,.]}{...}
{col 33}row vector of row {it:i} of {it:x}
{col 9}{it:x}{cmd:[.,}{it:j}]{...}
{col 33}column vector of column {it:j} of {it:x}

{col 9}{it:x}{cmd:[}{it:ivec}{cmd:,.]}{...}
{col 33}matrix of rows {it:ivec}, all columns
{col 9}{it:x}{cmd:[.,}{it:jvec}]{...}
{col 33}matrix of columns {it:jvec}, all rows

{col 9}{it:x}{cmd:[.,.]}{...}
{col 33}the entire matrix

{p 4 4 2} 
Finally, Mata assumes missing value when you omit the argument entirely:

{col 9}{it:x}{cmd:[}{it:i}{cmd:,]}{...}
{col 33}same as {it:x}{cmd:[}{it:i}{cmd:,.]}
{col 9}{it:x}{cmd:[}{it:ivec}{cmd:,]}{...}
{col 33}same as {it:x}{cmd:[}{it:ivec}{cmd:,.]}
{col 9}{it:x}{cmd:[,}{it:j}{cmd:]}{...}
{col 33}same as {it:x}{cmd:[.,}{it:j}]
{col 9}{it:x}{cmd:[,}{it:jvec}{cmd:]}{...}
{col 33}same as {it:x}{cmd:[.,}{it:jvec}]
{col 9}{it:x}{cmd:[,]}{...}
{col 33}same as {it:x}{cmd:[.,.]}

{p 4 4 2}
Good style is to specify {it:ivec} as a column vector and {it:jvec} as a
row vector, but that is not required:

{col 9}{it:x}{cmd:[(1\2\3), (1,2,3)]}{...}
{col 33}good style
{col 9}{it:x}{cmd:[(1,2,3), (1,2,3)]}{...}
{col 33}same as {it:x}{cmd:[(1\2\3), (1,2,3)]}
{col 9}{it:x}{cmd:[(1\2\3), (1\2\3)]}{...}
{col 33}same as {it:x}{cmd:[(1\2\3), (1,2,3)]}
{col 9}{it:x}{cmd:[(1,2,3), (1\2\3)]}{...}
{col 33}same as {it:x}{cmd:[(1\2\3), (1,2,3)]}

{p 4 4 2}
Similarly, good style is to specify {it:kvec} as a column when {it:v} is 
a column vector and to specify {it:kvec} as a row when {it:v} is a row vector,
but that is not required and what is returned is a column vector if {it:v} is
a column and a row vector if {it:v} is a row:

{col 9}{it:rowv}{cmd:[(1,2,3)]}{...}
{col 33}good style for specifying row vector
{col 9}{it:rowv}{cmd:[(1\2\3)]}{...}
{col 33}same as {it:rowv}{cmd:[(1,2,3)]}

{col 9}{it:colv}{cmd:[(1\2\3)]}{...}
{col 33}good style for specifying column vector
{col 9}{it:colv}{cmd:[(1,2,3)]}{...}
{col 33}same as {it:colv}{cmd:[(1\2\3)]}

{p 4 4 2}
Subscripts may be used in expressions following a variable name:

        {cmd:first = list[1]}

	{cmd:multiplier = x[3,4]}
        
	{cmd:result = colsum(x[,j])}

{p 4 4 2}
Subscripts may be used following an expression to extract a submatrix 
from a result:

	{cmd:allneeded = invsym(x)[(1::4), .] * multiplier}

{p 4 4 2}
Subscripts may be used on the left-hand side of the equal-assignment 
operator:

        {cmd:x[1,1] = 1}

	{cmd:x[1,.] = y[3,.]}

        {cmd:x[(1::4), (1..4)] = I(4)}


{marker remarks2}{...}
{title:Range subscripts}

{p 4 4 2}
Range subscripts appear inside the difficult to type {cmd:[|} and {cmd:|]}
brackets.  Range subscripts come in four basic forms:

{col 9}{it:x}{cmd:[|}{it:i}{cmd:,}{it:j}{cmd:|]}{...}
{col 33}{it:i},{it:j} element; same result as {it:x}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:]}

{col 9}{it:v}{cmd:[|}{it:k}{cmd:|]}{...}
{col 33}{it:k}th element of vector; same result as {it:v}{cmd:[}{it:k}{cmd:]}

{col 9}{it:x}{cmd:[|}{it:i}{cmd:,}{it:j} {cmd:\} {it:k}{cmd:,}{it:l}{cmd:|]}{...}
{col 33}submatrix, vector, or scalar formed using 
{col 33}({it:i},{it:j}) as top-left corner and ({it:k},{it:l}) as 
{col 33}bottom-right corner

{col 9}{it:v}{cmd:[|}{it:i} {cmd:\} {it:k}{cmd:|]}{...}
{col 33}subvector or scalar of elements {it:i} through {it:k};
{col 33}result is row vector if {it:v} is row vector, 
{col 33}column vector if {it:v} is column vector

{p 4 4 2}
Missing value may be specified for a row or column to mean all rows or 
all columns when a 1 {it:x} 2 or 1 {it:x} 1 subscript is specified: 

{col 9}{it:x}{cmd:[|}{it:i}{cmd:,.|]}{...}
{col 33}row {it:i} of {it:x}; same as {it:x}{cmd:[}{it:i}{cmd:,.]}

{col 9}{it:x}{cmd:[|.,}{it:j}{cmd:|]}{...}
{col 33}column {it:j} of {it:x}; same as {it:x}{cmd:[.,}{it:j}{cmd:]}

{col 9}{it:x}{cmd:[|.,.|]}{...}
{col 33}entire matrix; same as {it:x}{cmd:[.,.]}

{col 9}{it:v}{cmd:[|.|]}{...}
{col 33}entire vector; same as {it:v}{cmd:[.]}

{p 4 4 2}
Also missing may be specified to mean the number of rows 
or the number of columns of the matrix being subscripted when a 
2 {it:x} 2 subscript is specified:

{col 9}{it:x}{cmd:[|1,2 \ 4,.|]}{...}
{col 33}equivalent to {it:x}{cmd:[|1,2 \ 4,cols(}{it:x}{cmd:)|]}

{col 9}{it:x}{cmd:[|1,2 \ .,3|]}{...}
{col 33}equivalent to {it:x}{cmd:[|1,2 \ rows(}{it:x}{cmd:),3|]}

{col 9}{it:x}{cmd:[|1,2 \ .,.|]}{...}
{col 33}equivalent to {it:x}{cmd:[|1,2 \ rows(}{it:x}{cmd:),cols(}{it:x}{cmd:|]}


{p 4 4 2}
With range subscripts, what appears inside the square brackets is in all 
cases interpreted as a matrix expression, so in

	{cmd:sub = (1,2)}
	... {cmd:x[|sub|]} ...

{p 4 4 2}
{cmd:x[sub]} refers to {cmd:x[1,2]}.

{p 4 4 2}
Range subscripts may be used in all the same contexts as list subscripts; 
they may be used in expressions following a variable name

	{cmd:submat = result[|1,1\3,3|]}

{p 4 4 2}
they may be used to extract a submatrix from a calculated result

	{cmd:allneeded = invsym(x)[|1,1 \ 4,4|]}

{p 4 4 2}
and they may be used on the left-hand side of the equal-assignment operator:

        {cmd:x[|1,1 \ 4,4|] = I(4)}


{marker remarks3}{...}
{title:When to use list subscripts and when to use range subscripts}

{p 4 4 2}
Everything a range subscript can do, a list subscript can also do.  The 
one seemingly unique feature of a range subscript

	{it:x}{cmd:[|}{it:i1}{cmd:,}{it:j1} {cmd:\} {it:i2}{cmd:,}{it:j2}{cmd:|]}

{p 4 4 2}
is perfectly mimicked by 

	{it:x}{cmd:[(}{it:i1}{cmd:::}{it:i2}{cmd:), (}{it:j1}{cmd:..}{it:j2}{cmd:)]}

{p 4 4 2}
The range-subscript construction, however, executes more quickly, and so that
is the purpose of range subscripts:  to provide a fast way to extract
contiguous submatrices.  In all other cases, use list subscripts because they
are faster.

{p 4 4 2}
Use list subscripts to refer to scalar values: 

	{cmd:result = x[1,3]}
	{cmd:x[1,3] = 2}

{p 4 4 2}
Use list subscripts to extract entire rows or columns:

	{cmd:obs = x[., 3]}
	{cmd:var = x[4, .]}

{p 4 4 2}
Use list subscripts to permute the rows and columns of matrices:

	{cmd:x = (1,2,3,4 \ 5,6,7,8 \ 9,10,11,12)}

	{cmd:y = x[(1\3\2), .]}
	{cmd:y}
        {res}       {txt} 1    2    3    4
            {c TLC}{hline 21}{c TRC}
          1 {c |}  {res} 1    2    3    4{txt}  {c |}
          2 {c |}  {res} 9   10   11   12{txt}  {c |}
          3 {c |}  {res} 5    6    7    8{txt}  {c |}
            {c BLC}{hline 21}{c BRC}

	{cmd:y = x[., (1,3,2,4)]}
	{cmd:y}
        {res}       {txt} 1    2    3    4
            {c TLC}{hline 21}{c TRC}
          1 {c |}  {res} 1    3    2    4{txt}  {c |}
          2 {c |}  {res} 5    7    6    8{txt}  {c |}
          3 {c |}  {res} 9   11   10   12{txt}  {c |}
            {c BLC}{hline 21}{c BRC}

	{cmd:y = x[(1\3\2), (1,3,2,4)]}
	{cmd:y}
        {res}       {txt} 1    2    3    4
            {c TLC}{hline 21}{c TRC}
          1 {c |}  {res} 1    3    2    4{txt}  {c |}
          2 {c |}  {res} 9   11   10   12{txt}  {c |}
          3 {c |}  {res} 5    7    6    8{txt}  {c |}
            {c BLC}{hline 21}{c BRC}

{p 4 4 2}
Use list subscripts to duplicate rows or columns:

	{cmd:x = (1,2,3,4 \ 5,6,7,8 \ 9,10,11,12)}

	{cmd:y = x[(1\2\3\1), .]}
	{cmd:y}
        {res}       {txt} 1    2    3    4
            {c TLC}{hline 21}{c TRC}
          1 {c |}  {res} 1    2    3    4{txt}  {c |}
          2 {c |}  {res} 5    6    7    8{txt}  {c |}
          3 {c |}  {res} 9   10   11   12{txt}  {c |}
          4 {c |}  {res} 1    2    3    4{txt}  {c |}
            {c BLC}{hline 21}{c BRC}

	{cmd:y = x[., (1,2,3,4,2)]}
	{cmd:y}
        {res}       {txt} 1    2    3    4    5
            {c TLC}{hline 26}{c TRC}
          1 {c |}  {res} 1    2    3    4    2{txt}  {c |}
          2 {c |}  {res} 5    6    7    8    6{txt}  {c |}
          3 {c |}  {res} 9   10   11   12   10{txt}  {c |}
            {c BLC}{hline 26}{c BRC}

	{cmd:y = x[(1\2\3\1), (1,2,3,4,2)]}
	{cmd:y}
        {res}       {txt} 1    2    3    4    5
            {c TLC}{hline 26}{c TRC}
          1 {c |}  {res} 1    2    3    4    2{txt}  {c |}
          2 {c |}  {res} 5    6    7    8    6{txt}  {c |}
          3 {c |}  {res} 9   10   11   12   10{txt}  {c |}
          4 {c |}  {res} 1    2    3    4    2{txt}  {c |}
            {c BLC}{hline 26}{c BRC}


{marker remarks4}{...}
{title:A fine distinction}

{p 4 4 2}
There is a fine distinction between 
{it:x}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:]}
and 
{it:x}{cmd:[|}{it:i}{cmd:,}{it:j}{cmd:|]}.
In {it:x}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:]}, there are two arguments, 
{it:i} and {it:j}.  The comma separates the arguments.
In {it:x}{cmd:[|}{it:i}{cmd:,}{it:j}{cmd:|]}, 
there is one argument:  {it:i}{cmd:,}{it:j}.  The comma is the 
{help m2_op_join:column-join operator}.

{p 4 4 2}
In Mata, comma means mostly the column-join operator:

	{cmd:newvec = oldvec, addedvalues}

	{cmd:qsum = (x,1)'(x,1)}

{p 4 4 2}
There are, in fact, only two exceptions.  When you type the arguments 
for a function, the comma separates one argument from the next:

	{cmd:result = f(}{it:a}{cmd:,}{it:b}{cmd:,}{it:c}{cmd:)}

{p 4 4 2}
In the above example, {cmd:f()} receives three arguments: {it:a}, {it:b}, and
{it:c}.  If we wanted {cmd:f()} to receive one argument,
({it:a},{it:b},{it:c}), we would have to enclose the calculation in
parentheses:

	{cmd:result = f((}{it:a}{cmd:,}{it:b}{cmd:,}{it:c}{cmd:))}

{p 4 4 2}
That is the first exception.  When you type the arguments inside a 
function, comma means argument separation.  You get back to the usual 
meaning of comma -- the column-join operator -- by opening another set of 
parentheses.

{p 4 4 2}
The second exception is in {help m2_subscripts##remarks1:list subscripting}:

	{it:x}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:]}

{p 4 4 2}
Inside the list-subscript brackets, comma means argument separation.  
That is why you have seen us type vectors inside parentheses:

	{it:x}{cmd:[(1\2\3),(1,2,3)]}

{p 4 4 2}
These are the two exceptions.  Range subscripting is not an exception.  Thus
in

	{it:x}{cmd:[|}{it:i}{cmd:,}{it:j}{cmd:|]}

{p 4 4 2}
there is one argument, {it:i}{cmd:,}{it:j}.  With range subscripts, 
you may program constructs such as 

	{cmd:IJ    = (}{it:i}{cmd:,}{it:j}{cmd:)}
	{cmd:RANGE = (1,2 \ 4,4)}
	...
	... {it:x}{cmd:[|IJ|]} ... {it:x}{cmd:[|RANGE|]} ...

{p 4 4 2}
You may not code in this way with list subscripts.  In particular, 
{it:x}{cmd:[IJ]} would be interpreted as a request to extract elements {it:i}
and {it:j} from vector {it:x}, and would be an error otherwise.
{it:x}{cmd:[RANGE]} would always be an error.

{p 4 4 2}
We said earlier that list subscripts 
{it:x}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:]}
are a little faster than range subscripts 
{it:x}{cmd:[|}{it:i}{cmd:,}{it:j}{cmd:|]}.  
That is true, but if {cmd:IJ}={cmd:(}{it:i}{cmd:,}{it:j}{cmd:)} already, 
{it:x}{cmd:[|IJ|]} is faster than 
{it:x}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:]}.  
You would, however, have to execute 
many millions of references to 
{it:x}{cmd:[|IJ|]}
before you could measure the 
difference.


{marker conformability}{...}
{title:Conformability}

    {it:x}{cmd:[}{it:i}{cmd:,} {it:j}{cmd:]}:
		{it:x}:  {it:r x c}
		{it:i}:  {it:m} {it:x} 1  or  1 {it:x} {it:m}  (does not matter which)
		{it:j}:  1 {it:x} {it:n}  or  {it:n} {it:x} 1  (does not matter which)
	   {it:result}:  {it:m x n}

    {it:x}{cmd:[}{it:i}{cmd:, .]}:
		{it:x}:  {it:r x c}
		{it:i}:  {it:m} {it:x} 1  or  1 {it:x} {it:m}  (does not matter which)
	   {it:result}:  {it:m x c}

    {it:x}{cmd:[.,} {it:j}{cmd:]}:
		{it:x}:  {it:r x c}
		{it:j}:  1 {it:x} {it:n}  or  {it:n} {it:x} 1  (does not matter which)
	   {it:result}:  {it:r x n}

    {it:x}{cmd:[., .]}:
		{it:x}:  {it:r x c}
	   {it:result}:  {it:r x c}


    {it:x}{cmd:[}{it:i}{cmd:]}:
		{it:x}:  {it:n x} 1                    1 {it:x n}
		{it:i}:  {it:m x} 1 or 1 {it:x m}           1 {it:x m} or {it:m x} 1
	   {it:result}:  {it:m x} 1                    1 {it:x m}

    {it:x}{cmd:[.]}:
		{it:x}:  {it:n x} 1                    1 {it:x n}
	   {it:result}:  {it:n x} 1                    1 {it:x n}

    {it:x}{cmd:[|}{it:k}{cmd:|]}:
		{it:x}:  {it:r x c}
		{it:k}:  1 {it:x} 2   
	   {it:result}:  1 {it:x} 1  if {it:k}[1]<.  & {it:k}[2]<.
		    {it:r x} 1  if {it:k}[1]>=. & {it:k}[2]<.
		    1 {it:x c}  if {it:k}[1]<.  & {it:k}[2]>=.
		    {it:r x c}  if {it:k}[1]>=. & {it:k}[2]>=.

    {it:x}{cmd:[|}{it:k}{cmd:|]}:
		{it:x}:  {it:r x c}
		{it:k}:  2 {it:x} 2   
	   {it:result}:  {it:k}[2,1]-{it:k}[1,1]+1 {it:x} {it:k}[2,2]-{it:k}[1,2]+1
		    (in the above formula, if {it:k}[2,1]>=., treat as if {it:k}[2,1]={it:r},
		     and similarly,        if {it:k}[2,2]>=., treat as if {it:k}[2,2]={it:c})

    {it:x}{cmd:[|}{it:k}{cmd:|]}:
		{it:x}:  {it:r x} 1                     1 {it:x c}
		{it:k}:  2 {it:x} 1                     2 x 1
	   {it:result}:  {it:k}[2]-{it:k}[1]+1 {it:x} 1           1 {it:x} {it:k}[2]-{it:k}[1]+1
		   (if {it:k}[2]>=., treat as      (if {it:k}[2]>=., treat as
		    if {it:k}[2]={it:r})                 if {it:k}[2]={it:c})


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
Both styles of subscripts abort with error if the subscript is out of 
range, if a reference is made to a nonexisting row or column.
{p_end}


{marker reference}{...}
{title:Reference}

{phang}
Gould, W. W. 2007.
{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0028":Mata Matters: Subscripting}.
{it:Stata Journal} 7: 106-116.
{p_end}
