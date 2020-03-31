{smcl}
{* *! version 1.1.10  19oct2017}{...}
{viewerdialog stgen "dialog stgen"}{...}
{vieweralsosee "[ST] stgen" "mansection ST stgen"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stci" "help stci"}{...}
{vieweralsosee "[ST] sts" "help sts"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{vieweralsosee "[ST] stvary" "help stvary"}{...}
{viewerjumpto "Syntax" "stgen##syntax"}{...}
{viewerjumpto "Menu" "stgen##menu"}{...}
{viewerjumpto "Description" "stgen##description"}{...}
{viewerjumpto "Links to PDF documentation" "stgen##linkspdf"}{...}
{viewerjumpto "Functions" "stgen##functions"}{...}
{viewerjumpto "Examples" "stgen##examples"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[ST] stgen} {hline 2}}Generate variables reflecting entire histories{p_end}
{p2col:}({mansection ST stgen:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}{cmd:stgen} {dtype} {it:{help newvar}} {cmd:=} {it:function}

{pstd}where {it:function} is

		{opth ever(exp)}
		{opth never(exp)}
		{opth always(exp)}
		{opth min(exp)}
		{opth max(exp)}
		{opth when(exp)}
		{opth when0(exp)}
		{opth count(exp)}
		{opth count0(exp)}
		{opth minage(exp)}
		{opth maxage(exp)}
		{opth avgage(exp)}
		{opt nfailures()}
		{opt ngaps()}
		{opt gaplen()}
		{opt hasgap()}

{pstd}
You must {cmd:stset} your data before using {cmd:stgen}; see
{manhelp stset ST}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Setup and utilities >}
       {bf:Generate variable reflecting entire histories}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stgen} provides a convenient way to generate new variables reflecting
entire histories.  These functions are intended for use with multiple-record
survival data but may be used with single-record data.  With single-record
data, each function reduces to one {helpb generate}, and {cmd:generate} would
be a more natural way to approach the problem.

{pstd}
{cmd:stgen} can be used with single- or multiple-failure st data.

{pstd}
If you want to generate calculated values, such as the survivor function,
see {manhelp sts ST}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stgenQuickstart:Quick start}

        {mansection ST stgenRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker functions}{...}
{title:Functions}

{pstd}
In the description of the functions below, time units refer to the
same units as {it:timevar} from {cmd:stset} {it:timevar}{cmd:,} {it:...}.
For instance, if {it:timevar} is in years -- years since 1960, years since
diagnosis, or whatever -- time units are years.

{pstd}
When we say variable X records a "time", we mean a variable that records when
something occurred in the same units and with the same base as {it:timevar}.
If {it:timevar} is a Stata date, "time" is correspondingly a Stata date.

{pstd}
t units, or analysis-time units, refer to a variable in the units 
{it:timevar}/{opt scale()} from 
{cmd:stset} {it:timevar}{cmd:, scale(}{it:...}{cmd:)} {it:...}".  If you did 
not specify a {opt scale()}, then t units are the same as time units.
Alternatively, say that {it:timevar} is recorded as a Stata date and you
specified {cmd:scale(365.25)}.  Then t units are years.  If you specified a
nonconstant scale -- {cmd:scale(myvar)}, where {cmd:myvar} varies from subject
to subject -- then t units are different for every subject.

{pstd}
"An analysis time" refers to the time something occurred, recorded in the units
{cmd:(}{it:timevar}{cmd:-origin())/scale()}.  We speak about analysis time 
only in terms of the beginning and end of each time-span record.

{pstd}
Although in {help stgen##description:{it:Description}} above we said that
{cmd:stgen} creates variables reflecting entire histories, {cmd:stgen}
restricts itself to the {cmd:stset} observations, so "entire history" means the
entire history as it is currently {cmd:stset}.  If you really want to use
entire histories as recorded in the data, type {cmd:streset, past} or
{cmd:streset, past future} before using {cmd:stgen}.  Then type {cmd:streset}
to reset to the original analysis sample.

{pstd}
The following functions are available:

{phang}
{opth ever(exp)} creates {newvar} containing 1 (true) if the expression is 
ever true (nonzero) and 0 otherwise.

{phang}
{opth never(exp)} is the reverse of {opt ever()}; it creates {newvar} 
containing 1 (true) if the expression is always false (0) and 0 otherwise.

{phang}
{opth always(exp)} creates {newvar} containing 1 (true) if the expression is 
always true (nonzero) and 0 otherwise.

{phang}
{opth min(exp)} and {opt max(exp)} create {newvar} containing the minimum or 
maximum nonmissing value of {it:exp} within {opt id()}.  {opt min()} and 
{opt max()} are often used with variables recording a time (see
{help stgen##functions:definition} above), such as {cmd:min(visitdat)}.

{phang}
{opth when(exp)} and {opt when0(exp)} create {newvar} containing the time when
{it:exp} first became true within the previously {helpb stset} {opt id()}.  
The result is in time, not t units; see
{help stgen##functions:definition} above.

{pmore}
{opt when()} and {opt when0()} differ about when the {it:exp} became
true.  Records record time spans (time0,time1].  {opt when()} assumes the
expression became true at the end of the time span, time1.  {opt when0()}
assumes the expression became true at the beginning of the time span, time0.

{phang}
{opth count(exp)} and {opt count0(exp)} create {newvar} containing the number 
of occurrences when {it:exp} is true within {opt id()}.

{pmore}
{opt count()} and {opt count0()} differ in when they assume {it:exp} occurs.
{opt count()} assumes that {it:exp} corresponds to the end of the time-span
record.  Thus even if {it:exp} is true in this record, the count would remain
unchanged until the next record.

{pmore}
{opt count0()} assumes that {it:exp} corresponds to the beginning of the
time-span record.  Thus if {it:exp} is true in this record, the count is
immediately updated.

{phang}
{opth minage(exp)}, {opt maxage(exp)}, and {opt avgage(exp)} return the 
elapsed time, in time units, because {it:exp} is at the beginning, end, or
middle of the record, respectively.  {it:exp} is expected to evaluate to a time
in time units.  {opt minage()}, {opt maxage()}, and {opt avgage()} would be
appropriate for use with the result of {opt when()}, {opt when0()},
{opt min()}, and {opt max()}, for instance.

{pmore}
Also see {manhelp stsplit ST}; {cmd:stsplit} will divide the time-span
records into new time-span records that record specified intervals of ages.

{phang}
{opt nfailures()} creates {newvar} containing the cumulative number of failures
for each subject as of the entry time for the observation.  {opt nfailures()} 
is intended for use with multiple-failure data; with single-failure data, 
{opt nfailures()} is always 0.

{phang}
{opt ngaps()} creates {newvar} containing the cumulative number of
gaps for each subject as of the entry time for the record.  Delayed entry
(an opening gap) is not considered a gap.

{phang}
{opt gaplen()} creates {newvar} containing the time on gap, measured in
analysis-time units, for each subject as of the entry time for the observation.
Delayed entry (an opening gap) is not considered a gap.

{phang}
{opt hasgap()} creates {newvar} containing uniformly 1 if the subject ever has 
a gap and 0 otherwise.  Delayed entry (an opening gap) is not considered a 
gap.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse stgenxmpl}{p_end}
{phang2}{cmd:. keep in 1/10}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset t, id(id) failure(d)}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id t d bp, sepby(id)}

{pstd}By {cmd:id}, create {cmd:everlow} = 1 if {cmd:bp < 100} is true for
any observation; 0 otherwise{p_end}
{phang2}{cmd:. stgen everlow = ever(bp<100)}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id t d bp *low, sepby(id)}

{pstd}By {cmd:id}, create {cmd:neverlow} = 1 if {cmd:bp < 100} is false for
all observations; 0 otherwise{p_end}
{phang2}{cmd:. stgen neverlow = never(bp<100)}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id t d bp *low, sepby(id)}

{pstd}By {cmd:id}, create {cmd:minbp}, minimum value of variable
{cmd:bp}{p_end}
{phang2}{cmd:. stgen minbp = min(bp)}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id t d bp minbp, sepby(id)}

{pstd}By {cmd:id}, create {cmd:maxdiff}, maximum value of the difference
between {cmd:bp} and {cmd:minbp}{p_end}
{phang2}{cmd:. stgen maxdiff = max(bp - minbp)}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id t d bp minbp maxdiff, sepby(id)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse mrmf, clear}

{pstd}Show st settings{p_end}
{phang2}{cmd:. st}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list in 1/9, sepby(id)}

{pstd}By {cmd:id}, create {cmd:x1b0} containing the time when first
{cmd:x1 > 0.1}, considering that this assertion became true at the beginning
of the corresponding record{p_end}
{phang2}{cmd:. stgen x1b0 = when0(x1>.1)}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id t0 t d x1 x1b0 in 38/50, sepby(id)}

{pstd}By {cmd:id}, create {cmd:x1b} containing the time when first
{cmd:x1 > 0.1}, considering that this assertion became true at the end of
the corresponding record{p_end}
{phang2}{cmd:. stgen x1b = when(x1>.1)}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id t0 t d x1 x1b0 x1b in 38/50, sepby(id)}

{pstd}By {cmd:id}, create {cmd:x1n0} containing the cumulative number of
records where {cmd:x1 > 0.1}, considering that this assertion became true 
at the beginning of the corresponding record{p_end}
{phang2}{cmd:. stgen x1n0 = count0(x1>.1)}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id t0 t d x1 x1n0 in 1/11, sepby(id)}

{pstd}By {cmd:id}, create {cmd:x1n} containing the cumulative number of records 
where  {cmd:x1 > 0.1}, considering that this
assertion became true at the end of the corresponding record{p_end}
{phang2}{cmd:. stgen x1n = count(x1>.1)}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id t0 t d x1 x1n0 x1n in 1/11, sepby(id)}

{pstd}Create {cmd:min1b} containing the time from the value in variable
{cmd:x1b} to the beginning of each record {p_end}
{phang2}{cmd:. stgen min1b = minage(x1b)}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id t0 t d x1b min1b in 1/11, sepby(id)}

{pstd}Create {cmd:avg1b} containing the time from the value in variable 
{cmd:x1b} to the middle of each record {p_end}
{phang2}{cmd:. stgen avg1b = avgage(x1b)}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id t0 t d x1b min1b avg1b in 1/11, sepby(id)}

{pstd}Create {cmd:max1b} containing the time from the value in variable 
{cmd:x1b}
to the end of each record {p_end}
{phang2}{cmd:.  stgen max1b = maxage(x1b)}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id t0 t d x1b min1b avg1b max1b in 1/11, sepby(id)}

{pstd}By {cmd:id}, create {cmd:nf} containing the cumulative number of failures
as of the entry time for each record{p_end}
{phang2}{cmd:. stgen nf = nfailures()}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id t0 t d nf in 38/49, sepby(id) }

{pstd}By {cmd:id}, create {cmd:ng} containing the cumulative number of gaps 
as for the entry time for each record {p_end}
{phang2}{cmd:. stgen ng = ngaps()}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id t0 t ng in 540/550, sepby(id)}

{pstd}By {cmd:id}, create {cmd:hg} = 1 if subject ever has a gap; 0
otherwise{p_end}
{phang2}{cmd:. stgen hg = hasgap()}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id t0 t ng hg in 540/550, sepby(id)}

{pstd}Determine how many subjects have gaps in data{p_end}
{phang2}{cmd:. count if hg == 1 & id[_n] !=id[_n-1]}

{pstd}By {cmd:id}, create {cmd:gl} containing the time on gap (in analysis
time units) as of the entry time for each record{p_end}
{phang2}{cmd:. stgen gl = gaplen()}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id t0 t ng hg gl in 540/550, sepby(id)}{p_end}
    {hline}
