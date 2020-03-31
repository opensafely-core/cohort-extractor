{smcl}
{* *! version 1.2.6  09dec2014}{...}
{findalias asfrvarlists}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrsyntax}{...}
{findalias asfrvarabbrev}{...}
{vieweralsosee "[U] 11 Language syntax" "help language"}{...}
{vieweralsosee "[U] 11.1.8 numlist" "help numlist"}{...}
{vieweralsosee "[U] 11.4.2 Lists of new variables" "help newvarlist"}{...}
{vieweralsosee "[U] 11.4.3 Factor variables" "help fvvarlist"}{...}
{vieweralsosee "[U] 11.4.4 Time-series varlists" "help tsvarlist"}{...}
{vieweralsosee "[U] 13.7 Explicit subscripting" "help subscripting"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{viewerjumpto "Description" "varlist##description"}{...}
{viewerjumpto "Examples" "varlist##examples"}{...}
{title:Title}

    {findalias frvarlists}


{marker description}{...}
{title:Description}

{pstd}
A {it:varlist} is a list of variable names.  The 
{mansection U 11.3Namingconventions:variable names} in a {it:varlist} refer
either exclusively to new (not yet created) variables or exclusively to
existing variables. A {it:{help newvarlist}} always refers exclusively to new
(not yet created) variables.  Similarly, a {it:varname} refers to one variable,
either existing or not yet created.  A {it:newvar} always refers to one new
variable.

{pstd}
Sometimes a command will refer to a varname in another way, such as
"{it:groupvar}".  This is still a varname.  The different name is used
to give you an extra hint about the purpose of that variable.  For example, a
{it:groupvar} is the name of a variable that defines groups within your
data.   Other common ways of referring to a {it:varname} or
{it:varlist} in Stata are

{phang2}
    {it:depvar}, which means the dependent variable for an estimation command;

{phang2}
    {it:indepvars}, which means a {it:varlist} containing the independent
    variables for an estimation command;

{phang2}
    {it:xvar}, which means a continuous real variable, often plotted on the x
    axis of a graph;

{phang2}
    {it:yvar}, which means a variable that is a function of an {it:xvar},
    often plotted on the y axis of a graph;

{phang2}
    {it:clustvar}, which means a numeric variable that identifies the cluster
    or group to which an observation belongs;

{phang2}
    {it:panelvar}, which means a numeric variable that identifies panels in
    panel data, also known as cross-sectional time-series data; and

{phang2}
    {it:timevar}, which means a numeric variable with a {cmd:%td}, {cmd:%tc},
     or {cmd:%tC} format.

{pstd}
Examples include

{p 8 34 2}{cmd:myvar} {space 17} just one variable{p_end}
{p 8 34 2}{cmd:myvar thisvar thatvar} {space 1} three variables{p_end}
{p 8 34 2}{cmd:myvar*} {space 16} variables starting with {cmd:myvar}{p_end}
{p 8 34 2}{cmd:*var} {space 18} variables ending with {cmd:var}{p_end}
{p 8 34 2}{cmd:my*var} {space 16} variables starting with {cmd:my} & ending
		with {cmd:var} with any number of other characters
		between{p_end}
{p 8 34 2}{cmd:my~var} {space 16} one variable starting with {cmd:my} &
		ending with {cmd:var} with any number of other characters
		between{p_end}
{p 8 34 2}{cmd:my?var} {space 16} variables starting with {cmd:my} & ending with
		{cmd:var} with one other character between{p_end}
{p 8 34 2}{cmd:myvar1-myvar6} {space 9} {cmd:myvar1}, {cmd:myvar2}, ...,
		{cmd:myvar6} (probably){p_end}
{p 8 34 2}{cmd:this-that} {space 13} variables {cmd:this} through {cmd:that},
		inclusive{p_end}

{pstd}
The {cmd:*} character indicates to match one or more characters.  All
variables matching the pattern are returned.

{pstd}
The {cmd:~} character also indicates to match one or more characters, but
unlike {cmd:*}, only one variable is allowed to match.  If more than one
variable matches, an error message is presented.

{pstd}
The {cmd:?} character matches one character.  All variables matching
the pattern are returned.

{pstd}
The {cmd:-} character indicates that all variables in the dataset, starting
with the variable to the left of the {cmd:-} and ending with the variable to
the right of the {cmd:-} are to be returned.


{pstd}
Many commands understand the keyword {cmd:_all} to mean all variables.
Some commands default to using all variables if none are specified.


{pstd}
Factor variables are extensions of varlists of existing variables.  When a
command allows factor variables, in addition to typing variable names from
your data, you can type factor variables using factor-variable operators.

{pstd}
Factor variables create indicator variables from categorical variables,
interactions of indicators of categorical variables, interactions of
categorical and continuous variables, and interactions of continuous variables
(polynomials).  

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
For complete syntax and usage of factor variables, see {help fvvarlist}.


{pstd}
Time-series {it:varlists} are a variation on {it:varlists} of existing
variables.  When a command allows a time-series {it:varlist}, you may include
time-series operators.  For instance, {cmd:L.gnp} refers to the lagged value of
variable {cmd:gnp}.  The time-series operators are

	Operator{col 19}Meaning
	{hline 57}
	{cmd:L.}{col 19}lag (x_t-1)
	{cmd:L2.}{col 19}2-period lag (x_t-2)
	...
	{cmd:F.}{col 19}lead (x_t+1)
	{cmd:F2.}{col 19}2-period lead (x_t+2)
	...
	{cmd:D.}{col 19}difference (x_t - x_t-1)
	{cmd:D2.}{col 19}difference of difference (x_t - 2x_t-1 + x_t-2)
	...
	{cmd:S.}{col 19}"seasonal" difference (x_t - x_t-1)
	{cmd:S2.}{col 19}lag-2 (seasonal) difference (x_t - x_t-2)
	...
	{hline 57}

{pstd}
Time-series operators may be repeated and combined and both lowercase and
uppercase letters are understood.  For more details, see help {help tsvarlist}.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. webuse census4}{p_end}
{phang}{cmd:. describe}

{pstd}These four {cmd:regress} commands are equivalent.{p_end}
{phang}{cmd:. regress brate medage medagesq reg2 reg3 reg4}{p_end}
{phang}{cmd:. regress brate medage medagesq reg2-reg4}{p_end}
{phang}{cmd:. regress brate med* reg2-reg4}{p_end}
{phang}{cmd:. regress brate medage c.medage#c.medage i.region}{p_end}

{phang}{cmd:. summarize _all}

{phang}{cmd:. sysuse citytemp}{p_end}
{phang}{cmd:. describe}

{phang}{cmd:. summarize *dd}{p_end}
{phang}{cmd:. summarize temp*}{p_end}
{phang}{cmd:. summarize temp???}{p_end}
{phang}{cmd:. summarize t*n}

{phang}{cmd:. webuse fvex}{p_end}
{phang}{cmd:. describe}

{phang}{cmd:. regress y distance i.group}{p_end}
{phang}{cmd:. regress y i.sex sex#c.distance}{p_end}

{pstd}These two commands are equivalent.{p_end}
{phang}{cmd:. regress y distance i.sex i.group sex#group}{p_end}
{phang}{cmd:. regress y distance sex##group}{p_end}
