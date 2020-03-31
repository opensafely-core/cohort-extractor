{smcl}
{* *! version 1.1.4  07apr2017}{...}
{findalias asfrsubscripts}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "[U] 11 Language syntax (by)" "help by"}{...}
{vieweralsosee "[U] 11.4 varname and varlists" "help varlist"}{...}
{vieweralsosee "[U] 13 Functions and expressions (expression)" "help exp"}{...}
{vieweralsosee "[U] 13.4 System variables (_variables)" "help _variables"}{...}
{viewerjumpto "Remarks" "subscripting##remarks"}{...}
{viewerjumpto "Examples" "subscripting##examples"}{...}
{title:Title}

{pstd}
{findalias frsubscripts}


{marker remarks}{...}
{title:Remarks}

{pstd}
Individual elements of variables and matrices may be referred to by  
subscripting.  For help on matrix subscripting, see
{manhelp matrix_define P:matrix define}.
Subscripting of {help variables} is discussed here.

{pstd}
Individual observations on variables can be referred to by subscripting the
variables.  Explicit subscripts are specified by following a variable name
with square brackets that contain an {help expression}.  The result of the
subscript expression is truncated to an integer, and the value of the variable
for the indicated observation is returned.  If the value of the subscript
expression is less than 1 or greater than _N (see {help _variables}), a
missing value is returned.

{pstd}For example:

{phang2}{cmd:. generate xlag = x[_n-1]}

{pstd}generates variable {cmd:xlag} containing the lagged value of {cmd:x}.
{cmd:_n} is understood by Stata to mean the observation number of the current
observation.  {cmd:_n-1} evaluates to the observation number of the previous
observation.  The first observation of {cmd:xlag} is missing since when
{cmd:_n} is 1, {cmd:x[_n-1]} refers to the nonexistent zeroth element of
{cmd:x}.  (See {findalias frtsvarlists} for
discussion of time-series operators that provide a more robust and convenient
method of generating lags and leads of a variable.)

{pstd}
The {helpb by} prefix command may be combined with {cmd:_n} to provide
subscripting within groups.

{pstd}For example:

{phang2}{cmd:. by pid (time), sort: generate growth = (bp - bp[_n-1])/bp}

{pstd}generates the {cmd:growth} variable as the relative first difference in
{cmd:bp} for each {cmd:pid}.  The first observation of {cmd:growth} for each
{cmd:pid} will be missing since {cmd:_n} is interpreted relative to each
individual {cmd:pid}.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. webuse womenwage}{p_end}
{phang}{cmd:. by wagecat: keep if _n == 1}{p_end}
{phang}{cmd:. generate wage1 = wagecat[_n-1]}

{phang}{cmd:. webuse evignet, clear}{p_end}
{phang}{cmd:. by caseid (pref), sort: generate best = pref == pref[_N]}
              {cmd:if job == 1}

{phang}{cmd:. webuse mfail, clear}{p_end}
{phang}{cmd:. stgen nf = nfailures()}{p_end}
{phang}{cmd:. egen newid = group(id nf)}{p_end}
{phang}{cmd:. by newid (t), sort: replace t = t - t0[1]}{p_end}
{phang}{cmd:. by newid: generate newt0 = t0 - t0[1]}{p_end}
