{smcl}
{* *! version 1.0.5  07apr2017}{...}
{findalias asfrfvvarlists}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 11 Language syntax" "help language"}{...}
{vieweralsosee "[U] 11.1.8 numlist" "help numlist"}{...}
{vieweralsosee "[U] 11.4 varname and varlists" "help varlist"}{...}
{vieweralsosee "[U] 13.7 Explicit subscripting" "help subscripting"}{...}
{viewerjumpto "Description" "fvvarlist##description"}{...}
{viewerjumpto "Remarks" "fvvarlist##remarks"}{...}
{title:Title}

    {findalias frfvvarlists}


{marker description}{...}
{title:Description}

{pstd}
Factor variables are extensions of varlists of existing variables.  When a
command allows factor variables, in addition to typing variable names from
your data, you can type factor variables, which might look like

{phang2}
	{cmd:i.}{it:varname}

{phang2}
	{cmd:i.}{it:varname}{cmd:#i.}{it:varname}

{phang2}
	{cmd:i.}{it:varname}{cmd:#i.}{it:varname}{cmd:#i.}{it:varname}

{phang2}
	{cmd:i.}{it:varname}{cmd:##i.}{it:varname}

{phang2}
	{cmd:i.}{it:varname}{cmd:##i.}{it:varname}{cmd:##i.}{it:varname}

{pstd}
Factor variables create indicator variables from categorical variables,
interactions of indicators of categorical variables, interactions of
categorical and continuous variables, and interactions of continuous variables
(polynomials).  They are allowed with most estimation and postestimation
commands, along with a few other commands.

{pstd}
There are five factor-variable operators:

{p2colset 10 19 21 2}{...}
{p2col:Operator} Description{p_end}
{p2line}
{p2col:{cmd:i.}} unary operator to specify indicators{p_end}
{p2col:{cmd:c.}} unary operator to treat as continuous{p_end}
{p2col:{cmd:o.}} unary operator to omit a variable or indicator{p_end}
{p2col:{cmd:#}}  binary operator to specify interactions{p_end}
{p2col:{cmd:##}} binary operator to specify factorial interactions{p_end}
{p2line}
{p2colreset}{...}

{pstd}
The indicators and interactions created by factor-variable operators are
referred to as virtual variables.  They act like variables in varlists but do
not exist in the dataset.

{pstd}
Categorical variables to which factor-variable operators are applied must
contain nonnegative integers with values in the range 0 to 32,740, inclusive.

{pstd}
Factor variables may be combined with the {cmd:L.} and {cmd:F.} time-series
operators.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help fvvarlist##intro:Basic examples}
	{help fvvarlist##bases:Base levels}
	{help fvvarlist##selecting:Selecting levels}
	{help fvvarlist##parens:Applying operators to a group of variables}
	{help fvvarlist##video:Video examples}


{marker intro}{...}
{title:Basic examples}

{pstd}
Here are some examples of use of the operators:

{p2colset 10 28 30 2}{...}
{p2col:Factor} {p_end}
{p2col:specification}Result {p_end}
{p2line}
{p2col:{cmd:i.group}}indicators for levels of {cmd:group}{p_end}

{p2col:{cmd:i.group#i.sex}}indicators for each combination of levels of {cmd:group} 
	and {cmd:sex}, a two-way interaction{p_end}

{p2col:{cmd:group#sex}}same as {cmd:i.group#i.sex}

{p2col:{cmd:group#sex#arm}}indicators for each combination of levels of 
	{cmd:group}, {cmd:sex}, and {cmd:arm}, a three-way interaction{p_end}

{p2col:{cmd:group##sex}}same as {cmd:i.group} {cmd:i.sex} {cmd:group#sex}{p_end}

{p2col:{cmd:group##sex##arm}}same as {cmd:i.group} {cmd:i.sex} {cmd:i.arm} 
	{cmd:group#sex} {cmd:group#arm} {cmd:sex#arm} {cmd:group#sex#arm}{p_end}

{p2col:{cmd:sex#c.age}}two variables -- {cmd:age} for males and 0 elsewhere,
	and {cmd:age} for females and 0 elsewhere; if {cmd:age} is also in the
	model, one of the two virtual variables will be treated as a base{p_end}

{p2col:{cmd:sex##c.age}}same as {cmd:i.sex} {cmd:age} {cmd:sex#c.age}{p_end}

{p2col:{cmd:c.age}}same as {cmd:age}{p_end}

{p2col:{cmd:c.age#c.age}}{cmd:age} squared{p_end}

{p2col:{cmd:c.age#c.age#c.age}}{cmd:age} cubed{p_end}
{p2line}
{p2colreset}{...}


{marker bases}{...}
{title:Base levels}

{pstd}
You can specify the base level of a factor variable by using the 
{cmd:ib.} operator.  The syntax is

{p2colset 12 26 28 2}{...}
{p2col:Base}{p_end}
{p2col:operator(*)} Description{p_end}
{p2line}
{p2col:{cmd:ib}{it:#}{cmd:.}} use {it:#} as base, {it:#}=value of variable{p_end}
{p2col:{cmd:ib(#}{it:#}{cmd:).}} use the {it:#}th ordered value as base (**){p_end}
{p2col:{cmd:ib(first).}} use smallest value as base (the default){p_end}
{p2col:{cmd:ib(last).}}  use largest value as base{p_end}
{p2col:{cmd:ib(freq).}}  use most frequent value as base{p_end}
{p2col:{cmd:ibn.}}  no base level{p_end}
{p2line}
{p2colreset}{...}
{p 12 16 2}
(*) The {cmd:i} may be omitted.  For instance, you may type {cmd:ib2.group} or
{cmd:b2.group}.
{p_end}
{p 11 16 2}
(**) For example, {cmd:ib(#2).} means to use the second value as the base.

{pstd}
Thus, if you want to use {cmd:group}=3 as the base in a regression, you can
type

	. {cmd:regress y  i.sex ib3.group}

{pstd}
You can also permanently set the base levels of categorical variables by using
the {helpb fvset} command.


{marker selecting}{...}
{title:Selecting levels}

{pstd}
You can select a range of levels -- a range of virtual variables -- by using the
{cmd:i(}{it:numlist}{cmd:).}{bind: }operator.  

{p2colset 10 28 30 2}{...}
{p2col:Examples}Description{p_end}
{p2line}
{p2col:{cmd:i2.cat}}a single indicator for {cmd:cat}=2{p_end}

{p2col:{cmd:2.cat}}same as {cmd:i2.cat}{p_end}

{p2col:{cmd:i(2 3 4).cat}}three indicators, {cmd:cat}=2, 
        {cmd:cat}=3, and {cmd:cat}=4;{break}
        same as {cmd:i2.cat i3.cat i4.cat}
{p_end}

{p2col:{cmd:i(2/4).cat}}same as {cmd:i(2 3 4).cat}{p_end}

{p2col:{cmd:2.cat#1.sex}}a single indicator that is 1 when {cmd:cat}=2 and
	{cmd:sex}=1, and is 0 otherwise{p_end}

{p2col:{cmd:i2.cat#i1.sex}}same as {cmd:2.cat#1.sex}{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Rather than selecting the levels that should be included, you can specify the
levels that should be omitted by using the {cmd:o.} operator.  When you use
{cmd:io(}{it:numlist}{cmd:).}{it:varname} in a command, indicators for the
levels of {it:varname} other than those specified in {it:numlist} are
included.  When omitted levels are specified with the {cmd:o.} operator, the
{cmd:i.} operator is implied, and the remaining indicators for the levels of
{it:varname} will be included.

{p2colset 10 28 30 2}{...}
{p2col:Examples}Description{p_end}
{p2line}
{p2col:{cmd:io2.cat}}indicators for levels of {cmd:cat}, omitting the indicator
                  for {cmd:cat}=2{p_end}

{p2col:{cmd:o2.cat}}same as {cmd:io2.cat}{p_end}

{p2col:{cmd:io(2 3 4).cat}}indicators for levels of {cmd:cat}, omitting three
                  indicators, {cmd:cat}=2, {cmd:cat}=3, and {cmd:cat}=4{p_end}

{p2col:{cmd:o(2 3 4).cat}}same as {cmd:io(2 3 4).cat}{p_end}

{p2col:{cmd:o(2/4).cat}}same as {cmd:io(2 3 4).cat}{p_end}

{p2col:{cmd:o2.cat#o1.sex}}indicators for each combination of the levels of
                   {cmd:cat} and {cmd:sex}, omitting the indicator for 
                   {cmd:cat}=2 and {cmd:sex}=1{p_end}
{p2line}
{p2colreset}{...}


{marker parens}{...}
{title:Applying operators to a group of variables}

{pstd}
Factor-variable operators may be applied to groups of variables by using
parentheses.

{pstd}
In the examples that follow, 
variables {cmd:group}, {cmd:sex}, {cmd:arm}, and {cmd:cat} are categorical, 
and variables {cmd:age}, {cmd:wt}, and {cmd:bp} are continuous:

{p2colset 10 36 36 2}{...}
{p2col:Examples}Expansion{p_end}
{p2line}
{p2col:{cmd:i.(group sex arm)}}{cmd:i.group} {cmd:i.sex} {cmd:i.arm}{p_end}

{p2col:{cmd:group#(sex arm cat)}}{cmd:group#sex} {cmd:group#arm} {cmd:group#cat}{p_end}

{p2col:{cmd:group##(sex arm cat)}}{cmd:i.group} {cmd:i.sex} {cmd:i.arm} {cmd:i.cat}
	{cmd:group#sex} {cmd:group#arm} {cmd:group#cat}{p_end}

{p2col:{cmd:group#(c.age c.wt c.bp)}}{cmd:i.group} 
	{cmd:group#c.age} {cmd:group#c.wt} {cmd:group#c.bp}{p_end}

{p2col:{cmd:group#c.(age wt bp)}}same as {cmd:group#(c.age c.wt c.bp)}{p_end}
{p2line}
{p2colreset}{...}


{marker video}{...}
{title:Video examples}

{phang}
{browse "http://www.youtube.com/watch?v=Wa1Nd9epHmY":Introduction to factor variables in Stata, part 1: The basics}

{phang}
{browse "http://www.youtube.com/watch?v=f-tLLX8v11c":Introduction to factor variables in Stata, part 2: Interactions}

{phang}
{browse "http://www.youtube.com/watch?v=9vR9n35aX5k":Introduction to factor variables in Stata, part 3: More interactions}
{p_end}
