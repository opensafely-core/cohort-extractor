{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] cvpermute()" "mansection M-5 cvpermute()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Statistical" "help m4_statistical"}{...}
{viewerjumpto "Syntax" "mf_cvpermute##syntax"}{...}
{viewerjumpto "Description" "mf_cvpermute##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_cvpermute##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_cvpermute##remarks"}{...}
{viewerjumpto "Conformability" "mf_cvpermute##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_cvpermute##diagnostics"}{...}
{viewerjumpto "Source code" "mf_cvpermute##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] cvpermute()} {hline 2}}Obtain all permutations
{p_end}
{p2col:}({mansection M-5 cvpermute():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 16 38 2}
{it:info} {cmd:=} 
{cmd:cvpermutesetup(}{it:real colvector V} [{cmd:,}
{it:real scalar unique}]{cmd:)}

{p 8 12 2}
{it:real colvector}
{cmd:cvpermute(}{it:info}{cmd:)}


{p 4 4 2}
where {it:info} should be declared {it:transmorphic}.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:cvpermute()} returns all permutations of the values of column vector
{it:V}, one at a time.  
If {it:V}=(1\2\3), there are six permutations and they are
(1\2\3), 
(1\3\2),
(2\1\3), 
(2\3\1),
(3\1\2),
and
(3\2\1). 
If {it:V}=(1\2\1), there are three permutations and they are
(1\1\2),
(1\2\1), 
and
(2\1\1).


{p 4 4 2}
Vector {it:V} is specified by calling 
{cmd:cvpermutesetup()},

		{it:info} {cmd:= cvpermutesetup(}{it:V}{cmd:)}

{p 4 4 2}
{it:info} holds information that is needed by {cmd:cvpermute()} and 
it is {it:info}, not {it:V}, 
that is passed to {cmd:cvpermute()}.
To obtain the permutations,
repeated calls are made to {cmd:cvpermute()} until it returns {cmd:J(0,1,.)}:

		{it:info} {cmd:= cvpermutesetup(}{it:V}{cmd:)}
		{cmd:while ((}{it:p}{cmd:=cvpermute(}{it:info}{cmd:)) != J(0,1,.)) {c -(}}
			... {it:p} ...
		{cmd:{c )-}}

{p 4 4 2}
Column vector {it:p} will contain a permutation of {it:V}.

{p 4 4 2}
{cmd:cvpermutesetup()} may be specified with one or two arguments:


		{it:info} = {cmd:cvpermutesetup(}{it:V}{cmd:)} 

		{it:info} = {cmd:cvpermutesetup(}{it:V}{cmd:,} {it:unique}{cmd:)}

{p 4 4 2}
{it:unique} is usually not specified.  If {it:unique} is specified, it should
be 0 or 1.  Not specifying {it:unique} is equivalent to specifying
{it:unique}=0.
Specifying {it:unique}=1 states that the elements of {it:V} are unique or, 
at least, are to be treated that way.

{p 4 4 2}
When the arguments of {it:V} are unique -- for instance, {it:V}=(1\2\3) --
specifying {it:unique}=1 will make {cmd:cvpermute()} run faster.  The same
permutations will be returned, 
although usually in a different order.

{p 4 4 2}
When the arguments of {it:V} are not unique -- for instance, {it:V}=(1\2\1)
-- specifying {it:unique}=1 will make {cmd:cvpermute()} treat them as if they
were unique.  
With {it:unique}=0, 
there are three permutations of (1\2\1).  With {it:unique}=1,
there are six permutations, just as there are with (1\2\3).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 cvpermute()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

    {title:Example 1:}

{p 4 4 2}
You have the following data: 

		{cmd:v1}     {cmd:v2}
		---------
		22     29
                17     33
                21     26
                20     32
		16     35
		---------

{p 4 4 2}
You wish to do an exact permutation test for the correlation between {cmd:v1}
and {cmd:v2}.

{p 4 4 2}
That is, you wish to (1) calculate the correlation between {cmd:v1} and
{cmd:v2} -- call that value r -- and then (2) calculate the correlation
between {cmd:v1} and {cmd:v2} for all permutations of {cmd:v1}, and count how
many times the result is more extreme than r.

{p 4 4 2}
For the first step, 

{* junk1.smcl from cvpermute.do}{...}
	{com}: X = (22, 29 \
	>      17, 33 \
	>      21, 26 \
	>      20, 32 \
	>      16, 35)
	{res}
	{com}: 
	: correlation(X)
	{res}{txt}[symmetric]
	                  1              2
	    {c TLC}{hline 31}{c TRC}
	  1 {c |}  {res}           1               {txt}  {c |}
	  2 {c |}  {res}-.8468554653              1{txt}  {c |}
	    {c BLC}{hline 31}{c BRC}{txt}

{p 4 4 2}
The correlation is -.846855.  For the second step, 

{* junk2.smcl from cvpermute.do}{...}
	{com}: V1 = X[,1]
	{res}
	{com}: V2 = X[,2]
	{res}
	{com}: num = den = 0 
	{res}
	{com}: info = cvpermutesetup(V1)
	{res}
	{com}: while ((V1=cvpermute(info)) != J(0,1,.)) {c -(}
	>         rho = correlation((V1,V2))[2,1]
	>         if (rho<=-.846855 | rho>=.846855) num++
	>         den++
	> {c )-}
	{res}
	{com}: (num, den, num/den)
	{res}       {txt}          1             2             3
	    {c TLC}{hline 43}{c TRC}
	  1 {c |}  {res}         13           120   .1083333333{txt}  {c |}
	    {c BLC}{hline 43}{c BRC}{txt}

{p 4 4 2}
Of the 120 permutations, 13 (10.8%) were outside .846855 or -.846855.


    {title:Example 2:}

{p 4 4 2}
You now wish to do the same thing but using the Spearman rank-correlation
coefficient.  Mata has no function that will calculate that, but Stata has a
command that does -- see {bf:{help spearman:[R] spearman}} -- so we will use
the Stata command as our subroutine.  

{p 4 4 2}
This time, we will assume that the data have been loaded into a Stata dataset:

{* junk3.smcl from cvpermute.do}{...}
	{com}. list
	{txt}
	     {c TLC}{hline 6}{c -}{hline 6}{c TRC}
	     {c |} {res}var1   var2 {txt}{c |}
	     {c LT}{hline 6}{c -}{hline 6}{c RT}
	  1. {c |} {res}  22     29 {txt}{c |}
	  2. {c |} {res}  17     33 {txt}{c |}
	  3. {c |} {res}  21     26 {txt}{c |}
	  4. {c |} {res}  20     32 {txt}{c |}
	  5. {c |} {res}  16     35 {txt}{c |}
	     {c BLC}{hline 6}{c -}{hline 6}{c BRC}{txt}

{p 4 4 2}
For the first step:

{* junk4.smcl from cvpermute.do}{...}
	{com}. spearman var1 var2

	{txt} Number of obs = {res}      5
	{txt}Spearman's rho = {res}     -0.9000

	{txt}Test of Ho: var1 and var2 are independent
	    Prob > |t| = {res}      0.0374{txt}

{p 4 4 2}
For the second step

{* junk5.smcl from cvpermute.do}{...}
	{com}. mata
	{txt}{hline 20} mata (type {cmd:end} to exit) {hline}
	{com}: V1 = st_data(., "var1")
	{res}
	{com}: info = cvpermutesetup(V1)
	{res}
	{com}: num = den = 0
	{res}
	{com}: while ((V1=cvpermute(info)) != J(0,1,.)) {c -(}
	>         st_store(., "var1", V1)
	>         stata("quietly spearman var1 var2")
	>         rho = st_numscalar("r(rho)")
	>         if (rho<=-.9 | rho>=.9) num++
	>         den++
	> {c )-}
	{res}
	{com}: (num, den, num/den)
	{res}       {txt}          1             2             3
	    {c TLC}{hline 43}{c TRC}
	  1 {c |}  {res}          2           120   .0166666667{txt}  {c |}
	    {c BLC}{hline 43}{c BRC}{txt}

{p 4 4 2}
Only two of the permutations resulted in a rank correlation of at least .9 
in magnitude.

{p 4 4 2}
In the code above, we obtained the rank correlation from 
{cmd:r(rho)} which, we learned from 
{helpb spearman:[R] spearman}, is where {cmd:spearman} stores it.

{p 4 4 2}
Also note how we replaced the contents of {cmd:var1} by using
{helpb mf_st_store:st_store()}.
Our code leaves the dataset changed and so could be improved.


{marker conformability}{...}
{title:Conformability}

    {cmd:cvpermutesetup(}{it:V}{cmd:,} {it:unique}{cmd:)}:
		{it:V}:  {it:n x} 1
	   {it:unique}:  1 {it:x} 1    (optional)
	   {it:result}:  1 {it:x L}


    {cmd:cvpermute(}{it:info}{cmd:)}:
	     {it:info}:  1 {it:x L}
	   {it:result}:  {it:n x} 1  or  0 {it:x} 1

{p 4 4 2}
where 

			3                    if   {it:n} = 0
		{it:L} =     4                    if   {it:n} = 1
			({it:n}+3)({it:n}+2)/2 - 6     otherwise

{p 4 4 2}
The value of {it:L} is not important except that the {it:info} vector returned
by {cmd:cvpermutesetup()} and then passed to {cmd:cvpermute()} consumes
memory.  For instance,

		    n          L     Total memory (8*{it:L})
		{hline 39}
		    5         22        176 bytes
	           10         72        576
                   50      1,372     10,560
		  100      5,247     41,976
		1,000    502,497  4,019,976
		{hline 39}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:cvpermute()} returns {cmd:J(0,1,.)} when there are no more permutations.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view cvpermute.mata, adopath asis:cvpermute.mata} for both functions.
{p_end}
