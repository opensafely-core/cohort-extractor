{smcl}
{* *! version 1.2.7  15may2018}{...}
{vieweralsosee "[M-5] cross()" "mansection M-5 cross()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] crossdev()" "help mf_crossdev"}{...}
{vieweralsosee "[M-5] mean()" "help mf_mean"}{...}
{vieweralsosee "[M-5] quadcross()" "help mf_quadcross"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Statistical" "help m4_statistical"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_cross##syntax"}{...}
{viewerjumpto "Description" "mf_cross##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_cross##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_cross##remarks"}{...}
{viewerjumpto "Conformability" "mf_cross##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_cross##diagnostics"}{...}
{viewerjumpto "Source code" "mf_cross##source"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] cross()} {hline 2}}Cross products
{p_end}
{p2col:}({mansection M-5 cross():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix}
{cmd:cross(}{it:X}{cmd:,}
{it:Z}{cmd:)}

{p 8 12 2}
{it:real matrix}
{cmd:cross(}{it:X}{cmd:,}
{it:w}{cmd:,}
{it:Z}{cmd:)}

{p 8 12 2}
{it:real matrix}
{cmd:cross(}{it:X}{cmd:,}
{it:xc}{cmd:,}
{it:Z}{cmd:,}
{it:zc}{cmd:)}

{p 8 12 2}
{it:real matrix}
{cmd:cross(}{it:X}{cmd:,}
{it:xc}{cmd:,}
{it:w}{cmd:,}
{it:Z}{cmd:,}
{it:zc}{cmd:)}


{p 4 8 2}
where

	             {it:X}:  {it:real matrix X}
	            {it:xc}:  {it:real scalar xc}
	             {it:w}:  {it:real vector w}
	             {it:Z}:  {it:real matrix Z}
	            {it:zc}:  {it:real scalar zc}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:cross()} makes calculations of the 
form 

		{it:X}'{it:X} 

		{it:X}'{it:Z} 

		{it:X}{bf:'}diag({it:w}){it:X}

		{it:X}{bf:'}diag({it:w}){it:Z}

{p 4 4 2}
{cmd:cross()} is designed for making calculations 
that often arise in statistical formulas.  
In one sense, 
{cmd:cross()} does nothing that you cannot easily write out 
in standard matrix notation.  For instance, 
{cmd:cross(}{it:X}{cmd:,}
{it:Z}{cmd:)}
calculates {it:X}'{it:Z}. 
{cmd:cross()}, however, has the following differences and 
advantages over the standard matrix-notation approach:

{p 8 12 2}
1.  {cmd:cross()} omits the rows in {it:X} and {it:Z} 
     that contain missing values, which amounts to dropping observations with
     missing values.

{p 8 12 2}
2.  {cmd:cross()} uses less memory and is especially efficient 
    when used with views.

{p 8 12 2}
3.  {cmd:cross()} watches for special cases and makes calculations 
    in those special cases more efficiently.  For instance, if you code 
    {bind:{cmd:cross(}{it:X}{cmd:,} {it:X}{cmd:)}}, {cmd:cross()} 
    observes that the two matrices are the same and makes the calculation 
    for a symmetric matrix result.
    
{p 4 4 2}
{cmd:cross(}{it:X}{cmd:,}
{it:Z}{cmd:)}
returns {it:X}'{it:Z}.  
Usually 
{cmd:rows(}{it:X}{cmd:)==rows(}{it:Z}{cmd:)}, but {it:X} is 
also allowed to be a scalar, 
which is then treated as if 
{cmd:J(rows(}{it:Z}{cmd:), 1, 1)} were specified.  Thus
{cmd:cross(1,} {it:Z}{cmd:)} is equivalent to 
{cmd:colsum(}{it:Z}{cmd:)}.

{p 4 4 2}
{cmd:cross(}{it:X}{cmd:,}
{it:w}{cmd:,}
{it:Z}{cmd:)}
returns {it:X}{bf:'}{cmd:diag(}{it:w}{cmd:)}{it:Z}.
Usually, {cmd:rows(}{it:w}{cmd:)==rows(}{it:Z}{cmd:)} 
or {cmd:cols(}{it:w}{cmd:)==rows(}{it:Z}{cmd:)}, but {it:w} 
is also allowed to be a scalar, which is treated as 
if 
{cmd:J(rows(}{it:Z}{cmd:), 1,} {it:w}{cmd:)} were specified.  Thus
{cmd:cross(}{it:X}{cmd:,1,}{it:Z}{cmd:)} 
is the same as {cmd:cross(}{it:X}{cmd:,}{it:Z}{cmd:)}.
{it:Z} may also be a scalar, just as in the two-argument case.

{p 4 4 2}
{cmd:cross(}{it:X}{cmd:,}
{it:xc}{cmd:,}
{it:Z}{cmd:,}
{it:zc}{cmd:)}
is similar to 
{cmd:cross(}{it:X}{cmd:,}
{it:Z}{cmd:)} in that 
{it:X}'{it:Z} is returned.  
In the four-argument case, however, {it:X} is augmented on the 
right with a column of 
1s if {it:xc}!=0 and {it:Z} is similarly augmented if {it:zc}!=0.
{cmd:cross(}{it:X}{cmd:,}
{cmd:0,}
{it:Z}{cmd:,}
{cmd:0)} 
is equivalent to 
{cmd:cross(}{it:X}{cmd:,}
{it:Z}{cmd:)}.  {it:Z} may be specified as a scalar.

{p 4 4 2}
{cmd:cross(}{it:X}{cmd:,}
{it:xc}{cmd:,}
{it:w}{cmd:,}
{it:Z}{cmd:,}
{it:zc}{cmd:)}
is similar to
{cmd:cross(}{it:X}{cmd:,}
{it:w}{cmd:,}
{it:Z}{cmd:)}
in that 
{it:X}{bf:'}{cmd:diag(}{it:w}{cmd:)}{it:Z} is returned.
As with the four-argument {cmd:cross()}, 
{it:X} is augmented on the right with a column of 
1s if {it:xc}!=0 and {it:Z} is similarly augmented if {it:zc}!=0.
Both {it:Z} and {it:w} may be specified as scalars.
{cmd:cross(}{it:X}{cmd:,}
{cmd:0,}
{cmd:1,}
{it:Z}{cmd:,}
{cmd:0)} 
is equivalent to 
{cmd:cross(}{it:X}{cmd:,}
{it:Z}{cmd:)}. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 cross()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
In the following examples, we are going to calculate linear regression
coefficients using {it:b} = ({it:X}'{it:X})^(-1){it:X}'{it:y}, means using
Sum({it:x})/{it:n}, and variances using (Sum({it:x}^2)/{it:n} -
{it:mean}^2)*{it:n}/({it:n}-1).  
See {bf:{help mf_crossdev:[M-5] crossdev()}} for examples of the
same calculations made in a more numerically stable way.

{p 4 4 2}
The examples use the automobile data.  Because we are using the absolute form 
of the calculation equations, it would be better if all variables had 
values near 1 (in which case the absolute form of the calculation equations 
are perfectly adequate).  Thus we suggest

	{cmd:. sysuse auto}
	{cmd:. replace weight = weight/1000}

{p 4 4 2} 
Some of the examples use a weight {cmd:w}.  For that, you might try 

	{cmd:. gen w = int(4*runiform()+1)}


{marker example1}{...}
    {title:Example 1:  Linear regression, the traditional way}

	{cmd}: y = X = .
	: st_view(y, ., "mpg")
	: st_view(X, ., "weight foreign")
	:
	: X = X, J(rows(X),1,1)
	: b = invsym(X'X)*X'y{txt}

{p 4 4 2}
{it:Comments:}
Does not handle missing values and uses much memory if {cmd:X} is large.


    {title:Example 2:  Linear regression using cross()}

	{cmd}: y = X = .
	: st_view(y, ., "mpg")
	: st_view(X, ., "weight foreign")
	:
	: XX = cross(X,1 , X,1)
	: Xy = cross(X,1 , y,0)
	: b  = invsym(XX)*Xy{txt}

{p 4 4 2}
{it:Comments:}
There is still an issue with missing values; {cmd:mpg} might not be missing 
everywhere {cmd:weight} and {cmd:foreign} are missing.


{marker example3}{...}
    {title:Example 3:  Linear regression using cross() and one view}

	{cmd}: // We will form
	: // 
	: //   (y X)'(y X)  =  (y'y, y'X  \  X'y, X'X)
	:
	: M = .
	: st_view(M, ., "mpg weight foreign", 0)
	:
	: CP = cross(M,1 , M,1)
	: XX = CP[|2,2 \ .,.|]
	: Xy = CP[|2,1 \ .,1|]
	: b  = invsym(XX)*Xy{txt}

{p 4 4 2}
{it:Comments:}
Using one view handles all missing-value issues (we 
specified fourth argument 0 to {cmd:st_view()}; see  
{bf:{help mf_st_view:[M-5] st_view()}}).
	

{marker example4}{...}
    {title:Example 4:  Linear regression using cross() and subviews}

	{cmd}: M = X = y = .
	: st_view(M, ., "mpg weight foreign", 0)
	: st_subview(y, M, ., 1)
	: st_subview(X, M, ., (2\.))
	:
	: XX = cross(X,1 , X,1)
	: Xy = cross(X,1 , y,0)
	: b  = invsym(XX)*Xy{txt}

{p 4 4 2}
{it:Comments:}
Using subviews also handles all missing-value issues; see 
{bf:{help mf_st_subview:[M-5] st_subview()}}.
The subview approach is a little less efficient than the previous 
solution but is perhaps easier to understand.
The efficiency issue concerns only the 
extra memory required by the subviews {cmd:y} and {cmd:X}, which is not 
much.

{p 4 4 2}
Also, this subview solution could be used to handle the 
missing-value problems of calculating linear regression coefficients 
the traditional way, shown in {help mf_cross##example1:example 1}:

	{cmd}: M = X = y = .
	: st_view(M, ., "mpg weight foreign", 0)
	: st_subview(y, M, ., 1)
	: st_subview(X, M, ., (2\.))
	:
	: X = X, J(rows(X), 1, 1)
	: b = invsym(X'X)*X'y


    {title:Example 5:  Weighted linear regression, the traditional way}

	{cmd}: M = w = y = X = .
	: st_view(M, ., "w mpg weight foreign", 0)
	: st_subview(w, M, ., 1)
	: st_subview(y, M, ., 2)
	: st_subview(X, M, ., (3\.))
	:
	: X = X, J(rows(X), 1, 1)
	: b = invsym(X'diag(w)*X)*X'diag(w)'y{txt}

{p 4 4 2}
{it:Comments:}
The memory requirements are now truly impressive because 
{cmd:diag(w)} is an {it:N} {it:x} {it:N} matrix!  That is, the memory
requirements are truly
impressive when {it:N} is large.  Part of the power of Mata is that 
you can write things like {cmd:invsym(X'diag(w)*X)*X'diag(w)'y}
and obtain solutions.  
We do not mean to be dismissive of the traditional approach; we merely 
wish to emphasize its memory requirements and note that there are 
alternatives.


{marker example6}{...}
    {title:Example 6:  Weighted linear regression using cross()}

	{cmd}: M = w = y = X = .
	: st_view(M, ., "w mpg weight foreign", 0)
	: st_subview(w, M, ., 1)
	: st_subview(y, M, ., 2)
	: st_subview(X, M, ., (3\.))
	:
	: XX = cross(X,1 ,w, X,1)
	: Xy = cross(X,1 ,w, y,0)
	: b  = invsym(XX)*Xy{txt}

{p 4 4 2}
{it:Comments:}
The memory requirements here are no greater than they were in
{help mf_cross##example4:example 4},
which this example closely mirrors.  We could also have mirrored
the logic of {help mf_cross##example3:example 3}:

	{cmd}: M = w = .
	: st_view(M, ., "w mpg weight foreign", 0)
	: st_subview(w, M, ., 1)
	:
	: CP = cross(M,1 ,w, M,1)
	: XX = CP[|3,3 \ .,.|]
	: Xy = CP[|3,2 \ .,2|]
	: b  = invsym(XX)*Xy{txt}

{p 4 4 2}
Note how similar these solutions are to their unweighted counterparts.
The only 
important difference is the appearance of {cmd:w} as the middle 
argument of {cmd:cross()}.  Because specifying the middle argument 
as a scalar 1 is also allowed and produces unweighted estimates, 
the above code could be 
modified to produce unweighted or weighted estimates, depending on 
how {cmd:w} is defined.


    {title:Example 7:  Mean of one variable}

	{cmd}: x = .
	: st_view(x, ., "mpg", 0)
	:
	: CP = cross(1,0 , x,1)
	: mean = CP[1]/CP[2]{txt}

{p 4 4 2}
{it:Comments:}
An easier and every bit as good a solution would be 

	{cmd}: x = .
	: st_view(x, ., "mpg", 0)
	:
	: mean = mean(x,1){txt}

{p 4 4 2}
{cmd:mean()} (see {helpb mf_mean:[M-5] mean()}) is implemented in terms of
{cmd:cross()}.  Actually, {cmd:mean()} is implemented using the quad-precision
version of {cmd:cross()}; see {bf:{help mf_quadcross:[M-5] quadcross()}}.  We
could implement our solution in terms of {cmd:quadcross()}:

	{cmd}: x = .
	: st_view(x, ., "mpg", 0)
	:
	: CP = quadcross(1,0 , x,1)
	: mean = CP[1]/CP[2]{txt}

{p 4 4 2}
{cmd:quadcross()} returns a double-precision result just as does 
{cmd:cross()}.  The difference is that {cmd:quadcross()} 
uses quad precision internally in calculating sums.


    {title:Example 8:  Means of multiple variables}

	{cmd}: X = .
	: st_view(X, ., "mpg weight displ", 0)
	:
	: CP = cross(1,0 , X,1)
	: n  = cols(CP)
	: means = CP[|1\n-1|] :/ CP[n]{txt}

{p 4 4 2}
{it:Comments:}
The above logic will work for one variable, too.
With {cmd:mean()}, the solution would be

	{cmd}: X = .
	: st_view(X, ., "mpg weight displ", 0)
	:
	: means = mean(X, 1){txt}


    {title:Example 9:  Weighted means of multiple variables}

	{cmd}: M = w = X = .
	: st_view(M, ., "w mpg weight displ", 0)
	: st_subview(w, M, ., 1)
	: st_subview(X, M, ., (2\.))
	:
	: CP = cross(1,0, w,  X,1)
	: n  = cols(CP)
	: means = CP[|1\n-1|] :/ CP[n]{txt}

{p 4 4 2}
{it:Comments:}
Note how similar this solution is to the unweighted solution:  {cmd:w} 
now appears as the middle argument of {cmd:cross()}.
The line {cmd:CP} {cmd:=} {cmd:cross(1,0, w, X,1)} could 
also be coded 
{cmd:CP} {cmd:=} {cmd:cross(w,0, X,1)}; it would make no difference.

{p 4 4 2}
The {cmd:mean()} solution to the problem is

	{cmd}: M = w = X = .
	: st_view(M, ., "w mpg weight displ", 0)
	: st_subview(w, M, ., 1)
	: st_subview(X, M, ., (2\.))
	:
	: means = mean(X, w){txt}


    {title:Example 10:  Variance matrix, traditional approach 1}

	{cmd}: X = .
	: st_view(X, ., "mpg weight displ", 0)
	:
	: n     = rows(X)
	: means = mean(X, 1)
	: cov   = (X'X/n - means'means)*(n/(n-1)){txt}

{p 4 4 2}
{it:Comments:}
This above is not 100% traditional since we used {cmd:mean()} to obtain
the means, but that does make the solution more understandable.  
The solution requires calculating {cmd:X'}, requiring that the data matrix
be duplicated.  Also, we have used a numerically poor 
calculation formula.


    {title:Example 11:  Variance matrix, traditional approach 2}

	{cmd}: X = .
	: st_view(X, ., "mpg weight displ", 0)
	:
	: n     = rows(X)
	: means = mean(X, 1)
	: cov   = (X:-means)'(X:-means) :/ (n-1){txt}

{p 4 4 2}
{it:Comments:}
We use a better calculation formula and, in the process, increase our 
memory usage substantially.


{marker example12}{...}
    {title:Example 12:  Variance matrix using cross()}

	{cmd}: X = .
	: st_view(X, ., "mpg weight displ", 0)
	:
	: n     = rows(X)
	: means = mean(X, 1)
	: XX    = cross(X, X)
	: cov   = ((XX:/n)-means'means)*(n/(n-1)){txt}{txt}

{p 4 4 2}
{it:Comments:}
The above solution conserves memory but uses the numerically poor 
calculation formula.  A related function, {cmd:crossdev()}, 
will calculate deviation crossproducts:

	{cmd}: X = .
	: st_view(X, ., "mpg weight displ", 0)
	:
	: n     = rows(X)
	: means = mean(X, 1)
	: xx    = crossdev(X,means, X,means)
	: cov   = xx:/(n-1){txt}

{p 4 4 2}
See {bf:{help mf_crossdev:[M-5] crossdev()}}.  
The easiest solution, however, is 

	{cmd}: X = .
	: st_view(X, ., "mpg weight displ", 0)
	:
	: cov = variance(X, 1){txt}

{p 4 4 2}
See {bf:{help mf_mean:[M-5] mean()}} for a description of the 
{cmd:variance()} function.  
{cmd:variance()} is implemented in terms of 
{cmd:crossdev()}.


    {title:Example 13:  Weighted variance matrix, traditional approaches}

	{cmd}: M = w = X = .
	: st_view(M, ., "w mpg weight displ", 0)
	: st_subview(w, M, ., 1)
	: st_subview(X, M, ., (2\.))
	:
	: n     = colsum(w)
	: means = mean(X, w)
	: cov   = (X'diag(w)*X:/n - means'means)*(n/(n-1)){txt}

{p 4 4 2}
{it:Comments:}
Above we use the numerically poor formula.  Using the better deviation 
formula, we would have 

	{cmd}: M = w = X = .
	: st_view(M, ., "w mpg weight displ", 0)
	: st_subview(w, M, ., 1)
	: st_subview(X, M, ., (2\.))
	:
	: n     = colsum(w)
	: means = mean(X, w)
	: cov   = (X:-means)'diag(w)*(X:-means) :/ (n-1){txt}

{p 4 4 2} 
The memory requirements include making a copy of the data with the 
means removed and making an {it:N} {it:x} {it:N} diagonal matrix.


{marker example14}{...}
    {title:Example 14:  Weighted variance matrix using cross()}

	{cmd}: M = w = X = .
	: st_view(M, ., "w mpg weight displ", 0)
	: st_subview(w, M, ., 1)
	: st_subview(X, M, ., (2\.))
	:
	: n     = colsum(w)
	: means = mean(X, w)
	: cov   = (cross(X,w,X):/n - means'means)*(n/(n-1)){txt}

{p 4 4 2}
{it:Comments:}
As in {help mf_cross##example12:example 12}, the above solution conserves
memory but uses a numerically poor calculation formula.  Better is to use
{cmd:crossdev()}:

	{cmd}: M = w = X = .
	: st_view(M, ., "w mpg weight displ", 0)
	: st_subview(w, M, ., 1)
	: st_subview(X, M, ., (2\.))
	:
	: n     = colsum(w)
	: means = mean(X, w)
	: cov   = crossdev(X,means, w, X,means) :/ (n-1){txt}

{p 4 4 2}
and easiest is to use {cmd:variance()}:

	{cmd}: M = w = X = .
	: st_view(M, ., "w mpg weight displ", 0)
	: st_subview(w, M, ., 1)
	: st_subview(X, M, ., (2\.))
	:
	: cov = variance(X, w){txt}

{p 4 4 2}
See 
{bf:{help mf_crossdev:[M-5] crossdev()}}
and  
{bf:{help mf_mean:[M-5] mean()}}.


    {title:Comment concerning cross() and missing values}

{p 4 4 2}
{cmd:cross()} automatically omits rows containing missing values 
in making its calculation.  Depending on this feature, however, is 
considered bad style because so many other Mata functions do not provide 
that feature and it is easy to make a mistake.  

{p 4 4 2}
The right way to handle missing values is to exclude them when constructing
views and subviews, as we have done above.
When we constructed a view, we invariably specified fourth argument 0
to {cmd:st_view()}.  In formal programming situations, you will probably
specify the name of the {cmd:touse} variable you have previously constructed
in your ado-file that calls your Mata function.


{marker conformability}{...}
{title:Conformability}

{p 4 8 2}
{cmd:cross(}{it:X}{cmd:,}
{it:xc}{cmd:,}
{it:w}{cmd:,}
{it:Z}{cmd:,}
{it:zc}{cmd:)}:
{p_end}
		{it:X}:  {it:n x v1} or 1 {it:x} 1, 1 {it:x} 1 treated as if {it:n x} 1
	       {it:xc}:  1 {it:x} 1                       (optional)
		{it:w}:  {it:n x} 1 or 1 {it:x n} or 1 {it:x} 1     (optional)
		{it:Z}:  {it:n x v2}
	       {it:zc}:  1 {it:x} 1                       (optional)
	   {it:result}:  ({it:v1}+({it:xc}!=0)) {it:x} ({it:v2}+({it:zc}!=0))


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:cross(}{it:X}{cmd:,}
{it:xc}{cmd:,}
{it:w}{cmd:,}
{it:Z}{cmd:,}
{it:zc}{cmd:)} omits rows in {it:X} and {it:Z} that contain missing values.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
