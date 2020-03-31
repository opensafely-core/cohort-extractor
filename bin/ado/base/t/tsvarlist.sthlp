{smcl}
{* *! version 1.1.5  31oct2018}{...}
{findalias asfrtsvarlists}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 11 Language syntax" "help language"}{...}
{vieweralsosee "[U] 11.1.8 numlist" "help numlist"}{...}
{vieweralsosee "[U] 11.4 varname and varlists" "help varlist"}{...}
{vieweralsosee "[U] 13.7 Explicit subscripting" "help subscripting"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{viewerjumpto "Description" "tsvarlist##description"}{...}
{viewerjumpto "Remarks" "tsvarlist##remarks"}{...}
{viewerjumpto "Examples" "tsvarlist##examples"}{...}
{viewerjumpto "Video example" "tsvarlist##video"}{...}
{title:Title}

    {findalias frtsvarlists}


{marker description}{...}
{title:Description}

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


{marker remarks}{...}
{title:Remarks}

{p 5 9 2}
1.  Time-series operators may be repeated and combined.  
{cmd:L3.gnp} refers to the third lag of variable {cmd:gnp}, as do 
{cmd:LLL.gnp}, {cmd:LL2.gnp}, and {cmd:L2L.gnp}.

{p 5 9 2}
2.  The lead operator (sometimes called the forward operator) {cmd:F.} is the
complement of the lag operator {cmd:L.}, so {cmd:FL.gnp} is just {cmd:gnp}.

{p 5 9 2}
3.  Note that {cmd:D1.gnp} equals {cmd:S1.gnp}, but {cmd:D2.gnp} does 
not equal {cmd:S2.gnp} because

{p 13 13 2}
{cmd:D2.gnp} = (gnp_t - gnp_t-1) - (gnp_t-1 - gnp_t-2){p_end}
{p 19 19 2}
= gnp_t - 2*gnp_t-1 + gnp_t-2
       
{p 9 9 2}
while

{p 13 13 2}
{cmd:S2.gnp} = (gnp_t - gnp_t-2)

{p 5 9 2}
4.  Operators may be typed in lowercase or uppercase.

{p 5 9 2}
5.  Operators can be typed in any order; Stata will convert the 
expression to its canonical form.  For example, Stata will convert
{cmd:ld2ls12d.gnp} to {cmd:L2D3S12.gnp}.

{p 5 9 2}
6.  In addition to {it:operator#}, Stata understands 
{it:operator({help numlist})} to mean a set of operated variables.  For 
example, specifying

{p 13 13 2}
{cmd:L(1/3).gnp} 

{p 9 9 2}
in a varlist is the same as typing 

{p 13 13 2}
{cmd:L.gnp L2.gnp L3.gnp}

{p 5 9 2}
7.  In {it:operator#}, making {it:#} zero returns the variable itself.  
Thus, instead of typing

{p 13 13 2}
{cmd:regress y x L(1/3).x}

{p 9 9 2}
you can save a few keystrokes by typing

{p 13 13 2}
{cmd:regress y L(0/3).x}

{p 5 9 2}
8.  Before using time-series operators, you must declare the time 
variable using {bf:{help tsset}}.

{p 13 13 2}
{cmd:. list l.gnp}{p_end}
{p 13 13 2}
time variable not set{p_end}
{p 13 13 2}
{search r(111)}{p_end}
{p 13 13 2}
{cmd:. tsset time}{p_end}
{p 13 13 2}
{it:(output omitted)}{p_end}
{p 13 13 2}
{cmd:. list l.gnp}{p_end}
{p 13 13 2}
{it:(output omitted)}

{p 5 9 2}
9.  Variable names can be abbreviated subject to the usual Stata 
conventions.  If the only variable in your dataset that begins with 
{cmd:gn} is {cmd:gnp}, then you can type {cmd:L.gn} instead of 
{cmd:L.gnp}

{p 4 9 2}
10.  The time-series operators respect the time variable.  {cmd:L2.gnp} 
refers to gnp_t-2 regardless of missing observations in the dataset.  
Notice in the following dataset that the observation for 1992 is 
missing:

{col 12}     {c TLC}{hline 6}{c -}{hline 8}{c -}{hline 8}{c TRC}
{col 12}     {c |} {res}year      gnp   L2.gnp {txt}{c |}
{col 12}     {c LT}{hline 6}{c -}{hline 8}{c -}{hline 8}{c RT}
{col 12}  1. {c |} {res}1989   5452.8        . {txt}{c |}
{col 12}  2. {c |} {res}1990   5764.9        . {txt}{c |}
{col 12}  3. {c |} {res}1991   5932.4   5452.8 {txt}{c |}
{col 12}  4. {c |} {res}1993   6560.0   5932.4 {txt}{c |} <- Note, filled in correctly
{col 12}  5. {c |} {res}1994   6922.4        . {txt}{c |}
{col 12}  6. {c |} {res}1995   7237.5   6560.0 {txt}{c |}
{col 12}     {c BLC}{hline 6}{c -}{hline 8}{c -}{hline 8}{c BRC}

{p 4 9 2}
11.  Time-series operators work with panel data as well as pure time-series
data.  The only difference is in how you {cmd:tsset} your data.

{p 13 13 2}
{cmd:. webuse grunfeld}{break}
{cmd:. tsset company time}

{p 4 9 2}
12. The time-series operators {cmd:L.} and {cmd:F.} may be combined with factor
    variables.

{p 13 13 2}
{cmd:. sysuse census}{break}
{cmd:. generate t = _n}{break}
{cmd:. tsset t}{break}
{cmd:. regress death medage iL.region [aw=pop]}

{p 9 9 2}
     You could have specified {cmd:Li.region} instead of {cmd:iL.region}; the
     results would be the same.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. webuse gxmpl1}{p_end}
{phang}{cmd:. list cpi L.cpi L2.cpi L3.cpi}{p_end}
{phang}{cmd:. list cpi L(1/3).cpi}

{phang}{cmd:. list cpi L2.cpi LL.cpi}

{phang}{cmd:. list cpi F.cpi F2.cpi F3.cpi}{p_end}
{phang}{cmd:. list cpi F2.cpi FF.cpi}

{phang}{cmd:. generate cpi_diff = cpi[_n] - cpi[_n-1]}{p_end}
{phang}{cmd:. list cpi cpi_diff D.cpi}

{phang}{cmd:. list cpi D.cpi S.cpi D2.cpi S2.cpi}{p_end}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=ik8r4WvrPkc":Time series, part 3: Time-series operators}
{p_end}
