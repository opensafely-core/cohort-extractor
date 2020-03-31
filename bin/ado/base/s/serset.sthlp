{smcl}
{* *! version 1.1.16  14jun2019}{...}
{vieweralsosee "[P] serset" "mansection P serset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] class" "help class"}{...}
{vieweralsosee "[P] file" "help file"}{...}
{vieweralsosee "[D] frames intro" "help frames intro"}{...}
{viewerjumpto "Syntax" "serset##syntax"}{...}
{viewerjumpto "Description" "serset##description"}{...}
{viewerjumpto "Links to PDF documentation" "serset##linkspdf"}{...}
{viewerjumpto "Options for serset create" "serset##options_create"}{...}
{viewerjumpto "Options for serset create_xmedians" "serset##options_create_xmedians"}{...}
{viewerjumpto "Option for serset create_cspline" "serset##option_create_cspline"}{...}
{viewerjumpto "Option for serset summarize" "serset##option_summarize"}{...}
{viewerjumpto "Option for serset use" "serset##option_use"}{...}
{viewerjumpto "Remarks" "serset##remarks"}{...}
{viewerjumpto "Stored results" "serset##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[P] serset} {hline 2}}Create and manipulate sersets{p_end}
{p2col:}({mansection P serset:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Create new serset from data in memory

{p 8 22 2}
{cmd:serset}
{cmdab:cr:eate}
{varlist}
{ifin}
[{cmd:,}
{cmdab:omitanym:iss}
{cmdab:omitallm:iss}
{cmdab:omitdupm:iss}
{cmdab:omitn:othing}
{opth sort(varlist)}]


    Create serset of cross medians

{p 8 22 2}
{cmd:serset}
{cmd:create_xmedians}
{it:{help serset##svn:svn}_y}
{it:{help serset##svn:svn}_x}
[{it:{help serset##svn:svn}_w}]
[{cmd:,}
{cmd:bands(}{it:#}{cmd:)}
{cmd:xmin(}{it:#}{cmd:)}
{cmd:xmax(}{it:#}{cmd:)}
{cmd:logx}
{cmd:logy}]


    Create serset of interpolated points from cubic spline interpolation

{p 8 22 2}
{cmd:serset}
{cmd:create_cspline}
{it:{help serset##svn:svn}_y}
{it:{help serset##svn:svn}_x}
[{cmd:,}
{cmd:n(}{it:#}{cmd:)}]


    Make previously created serset the current serset

{p 8 22 2}
{cmd:serset}
[{cmd:set}]
{it:{help serset##numbers:#_s}}


    Change order of observations in current serset

{p 8 22 2}
{cmd:serset}
{cmd:sort}
[{it:{help serset##svn:svn}} [{it:{help serset##svn:svn}} [...]]]


    Return summary statistics about current serset

{p 8 22 2}
{cmd:serset}
{cmdab:su:mmarize}
{it:{help serset##svn:svn}}
[{cmd:,}
{cmdab:d:etail}
]


    Return in r() information about current serset

{p 8 22 2}
{cmd:serset}


    Load serset into memory

{p 8 22 2}
{cmd:serset}
{cmd:use}
[{cmd:,}
{cmd:clear}
]


    Change ID of current serset 

{p 8 22 2}
{cmd:serset}
{cmd:reset_id}
{it:{help serset##numbers:#_s}}


    Eliminate specified sersets from memory

{p 8 22 2}
{cmd:serset}
{cmd:drop}
[{it:{help numlist}} | {cmd:_all}]


    Eliminate all sersets from memory

{p 8 22 2}
{cmd:serset}
{cmd:clear}


    Describe existing sersets

{p 8 22 2}
{cmd:serset}
{cmd:dir}


{pstd}
The {helpb file} command is also extended to allow

    Write serset into file

{p 8 22 2}
{cmd:file}
{cmd:sersetwrite}
{it:handle}


    Read serset from file

{p 8 22 2}
{cmd:file}
{cmd:sersetread}
{it:handle}


{pstd}
The following {help macro:macro functions} are also available:

	Macro function                Returns from the current serset
	{hline 61}
	{cmd:: serset id}                   ID
	{cmd:: serset k}                    number of variables
	{cmd:: serset N}                    number of observations
	{cmd:: serset varnum} {it:svn}           {it:svnum} of {it:svn}
	{cmd:: serset type} {it:svn}             storage type of {it:svn}
	{cmd:: serset format} {it:svn}           display format of {it:svn}
	{cmd:: serset varnames}             list of {it:svns}
	{cmd:: serset min} {it:svn}              minimum of {it:svn}
	{cmd:: serset max} {it:svn}              maximum of {it:svn}
	{hline 61}
	Macro functions have the syntax
		{cmd:local} {it:macname} {cmd::} ...
	The current serset is the most recently created or the most
		recently set by the {cmd:serset set} command.


{marker svn}{...}
{marker numbers}{...}
{pstd}
In the above syntax diagrams,

{phang2}
{it:#_s} refers to a serset number, 0 {ul:<} {it:#_s} {ul:<} 1,999.

{phang2}
{varlist} refers to the usual Stata varlist, that is, a list of
variables that appear in the current dataset, not the current serset.

{phang2}
{it:svn} refers to a variable in a serset.  The variable may be referred to
by either its name (for example, {cmd:mpg} or {cmd:l.gnp}) or its number (for
example, 1 or 5); which is used makes no difference.

{phang2}
{it:svnum} refers to a variable number in a serset.


{marker description}{...}
{title:Description}

{pstd}
{cmd:serset} creates and manipulates sersets.

{pstd}
{cmd:file} {cmd:sersetwrite} writes and {cmd:file} {cmd:sersetread} reads
sersets into files.

{pstd}
The macro function {cmd::serset} reports information about the
current serset.

{pstd}
{varlist} may contain {helpb data types:strL} variables or
{help data types:{bf:str}{it:#}} variables.  If it does, only the first 244
bytes of each value will be stored in the serset.

{pstd}
Sersets are primarily used by Stata's graphics system.  If you are
interested in working with multiple datasets in memory, you will
want to use Stata's data frames.  See {manhelp frames D}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P sersetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_create}{...}
{title:Options for serset create}

{phang}
{cmd:omitanymiss}, {cmd:omitallmiss}, {cmd:omitdupmiss}, and {cmd:omitnothing}
    specify how observations with missing values are to be treated.

{pmore}
    {cmd:omitanymiss} is the default.  Observations in which any of the
    numeric variables contain missing are omitted from the serset being
    created.

{pmore}
    {cmd:omitallmiss} specifies that only observations in which all the
    numeric variables contain missing be omitted.

{pmore}
    {cmd:omitdupmiss} specifies that only duplicate observations in which all
    the numeric variables contain missing be omitted.  Observations omitted
    will be a function of the sort order of the original data.

{pmore}
    {cmd:omitnothing} specifies that no observations be omitted
    (other than those excluded by {cmd:if} {it:exp} and {cmd:in}
    {it:range}).

{phang}
{opth sort(varlist)} specifies that the serset being created is to
   be sorted by the specified variables.  The result is no different from,
   after serset creation, using the {cmd:serset sort} command, but total
   execution time is a little faster.  The sort order of the data in memory is
   unaffected by this option.


{marker options_create_xmedians}{...}
{title:Options for serset create_xmedians}

{phang}
{cmd:bands(}{it:#}{cmd:)} specifies the number of divisions along the x scale
    in which cross medians are to be calculated; the default is
    {cmd:bands(200)}.  {cmd:bands()} may be specified to be between 3 and 200.

{pmore}
    Let {it:m} and {it:M} specify the minimum and maximum value of x.
    If the scale is divided into {it:n} bands (that is,
    {cmd:bands(}{it:n}{cmd:)}
    is specified), the first band is
    {it:m} to
    {it:m}+({it:M}-{it:m})/{it:n}, the second
    {it:m}+({it:M}-{it:m})/{it:n} to
    {it:m}+2*({it:M}-{it:m})/{it:n}, ..., and the nth
    {it:m}+({it:n}-1)*({it:M}-{it:m})/{it:n} to
    {it:m}+{it:n}*({it:M}-{it:m})/{it:n} = {it:m}+{it:M}-{it:m} = {it:M}.

{phang}
{cmd:xmin(}{it:#}{cmd:)} and {cmd:xmax(}{it:#}{cmd:)} specify the minimum and
    maximum values of the x variable to be used in the bands
    calculation -- {it:m} and {it:M} in the formulas above.  The actual
    minimum and maximum are used if these options are not specified. 
    Also, if {cmd:xmin()} is specified with a number that is greater than
    the actual minimum, the actual minimum is used, and if {cmd:xmax()} is
    specified with a number that is less than the actual maximum, the actual
    maximum is used.

{phang}
{cmd:logx} and {cmd:logy} specify that cross medians are to be created using a
    "log" scale.  The exponential of the median of the log of the values is
    calculated in each band.


{marker option_create_cspline}{...}
{title:Option for serset create_cspline}

{phang}
{cmd:n(}{it:#}{cmd:)} specifies the number of points to be evaluated between
    each pair of x values, which are treated as the knots.  The default is
    {cmd:n(5)}, and {cmd:n()} may be between 1 and 300.


{marker option_summarize}{...}
{title:Option for serset summarize}

{phang}
{cmd:detail} specifies additional statistics, including skewness,
    kurtosis, the four smallest and four largest values, and various
    percentiles.  This option is identical to the {cmd:detail} option of
    {helpb summarize}.


{marker option_use}{...}
{title:Option for serset use}

{phang}
{cmd:clear} permits the serset to be loaded, even if there is a dataset already
    in memory and even if that dataset has changed since it was last saved.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help serset##remarks1:Introduction}
        {help serset##remarks2:serset create}
        {help serset##remarks3:serset create_xmedians}
        {help serset##remarks4:serset create_cspline}
        {help serset##remarks5:serset set}
        {help serset##remarks6:serset sort}
        {help serset##remarks7:serset summarize}
        {help serset##remarks8:serset}
        {help serset##remarks9:serset use}
        {help serset##remarks10:serset reset_id}
        {help serset##remarks11:serset drop}
        {help serset##remarks12:serset clear}
        {help serset##remarks13:serset dir}
        {help serset##remarks14:file sersetwrite and file sersetread}


{marker remarks1}{...}
{title:Introduction}

{pstd}
Sersets are used in implementing Stata's graphics capabilities.  When you make
a graph, the data for the graph are extracted into a serset and then, at the
lowest levels of Stata's graphics implementation, are graphed from there.

{pstd}
Sersets are like datasets:  they contain observations on one or more
variables.  Each serset is assigned a number, and in your program, you use
that number when referring to a serset.  Thus multiple sersets can reside
simultaneously in memory.  (Sersets are, in fact, stored in a combination of
memory and temporary disk files, so accessing their contents is slower than
accessing the data in memory.  Sersets, however, are fast enough to keep up
with graphics operations.)


{marker remarks2}{...}
{title:serset create}

{pstd}
{cmd:serset create} creates a new serset from the data in memory.  For
instance,

	{cmd:. serset create mpg weight}

{pstd}
creates a new serset containing variables {cmd:mpg} and {cmd:weight}.  When
using the serset later, you can refer to these variables by their
names, {cmd:mpg} and {cmd:weight}, or by their numbers, {cmd:1} and {cmd:2}.

{pstd}
{cmd:serset create} also returns the following in {cmd:r()}:

	{cmd:r(N)}    the number of observations placed into the serset
	{cmd:r(k)}    the number of variables placed into the serset
	{cmd:r(id)}   the number assigned to the serset

{pstd}
{cmd:r(N)} and {cmd:r(k)} are just for your information; by far the most
important returned result is {cmd:r(id)}.  You will need to use this number
in subsequent commands to refer to this serset.

{pstd}
{cmd:serset create} also sets the current serset to the one just
created.  Commands that use sersets always use the current serset.  If, in
later commands, the current serset is not the one desired, you can set the
desired one by using {cmd:serset set}, described below.


{marker remarks3}{...}
{title:serset create_xmedians}

{pstd}
{cmd:serset create_xmedians} creates a new serset based on the currently set
serset.  The basic syntax is

{p 8 22 2}
{cmd:serset}
{cmd:create_xmedians}
{it:svn_y}
{it:svn_x}
[{it:svn_w}]
[{cmd:,}
...]

{pstd}
The new serset will contain cross medians.  Put that aside.  In the
{cmd:serset create_xmedians} command, you specify two or three variables to be
recorded in the current serset.  The result is to create a new serset
containing two variables ({it:svn_y} and {it:svn_x}) and a different number of
observations.  As with {cmd:serset create}, the result will also be to store
the following in {cmd:r()}:

	{cmd:r(id)}   the number assigned to the serset
	{cmd:r(k)}    the number of variables in the serset
	{cmd:r(N)}    the number of observations in the serset

{pstd}
The newly created serset will become the current serset.

{pstd}
In actual use, you might code

	{cmd:serset create `yvar' `xvar' `zvar'}
	{cmd:local base = r(id)}
	...
	{cmd:serset set `base'}
	{cmd:serset create_xmedians `yvar' `xvar'}
	{cmd:local cross = r(id)}
	...

{pstd}
{cmd:serset create_xmedians} obtains data from the original serset and
calculates the median values of {it:svn_y} and the median values of {it:svn_x}
for bands of {it:svn_x} values.  The result is a new dataset of {it:n}
observations (one for each band) containing median y and median x values,
where the variables have the same name as the original variables.
These results are stored in the newly created serset.  If a third variable is
specified, {it:svn_w}, the medians are calculated with weights.


{marker remarks4}{...}
{title:serset create_cspline}

{pstd}
{cmd:serset create_cspline} works in the same way as
{cmd:serset create_xmedians}:  it takes one serset and creates another serset
from it, leaving the first unchanged.  Thus, as with all serset creation
commands, returned in {cmd:r()} is

	{cmd:r(id)}   the number assigned to the serset
	{cmd:r(k)}    the number of variables in the serset
	{cmd:r(N)}    the number of observations in the serset

{pstd}
and the newly created serset will become the current serset.

{pstd}
{cmd:serset create_cspline} performs cubic spline interpolation, and here 
the new serset will contain the interpolated points.  The original
serset should contain the knots through which the cubic spline is to pass.
{cmd:serset create_cspline} also has the {cmd:n(}{it:#}{cmd:)} option, which 
specifies how many points are to be interpolated, so the resulting dataset
will have {it:N}+({it:N}-1)*{cmd:n()} observations, where {it:N} is the number
of observations in the original dataset.  A typical use of
{cmd:serset create_cspline} would be

	{cmd:serset create `yvar' `xvar'}
	{cmd:local base = r(id)}
	...
	{cmd:serset set `base'}
	{cmd:serset create_xmedians `yvar' `xvar'}
	{cmd:local cross = r(id)}
	...
	{cmd:serset set `cross'}
	{cmd:serset create_cspline `yvar' `xvar'}
	...

{pstd}
Here the spline is placed not through the original data but through
cross medians of the data.


{marker remarks5}{...}
{title:serset set}

{pstd}
{cmd:serset set} is used to make a previously created serset the current
serset.  You may omit the {cmd:set}.  Typing

	{cmd:serset 5}

{pstd}
is equivalent to typing

	{cmd:serset set 5}

{pstd}
You would never actually know ahead of time the number of a serset that you
needed to code.  Instead, when you created the serset, you would have recorded
the identity of the serset created, say, in a local macro, by typing

	{cmd:local id = r(id)}

{pstd}
and then later, you would make that serset the current serset by coding

	{cmd:serset set `id'}


{marker remarks6}{...}
{title:serset sort}

{pstd}
{cmd:serset sort} changes the order of the observations of the current
serset.  For instance,

	{cmd:serset create mpg weight length}
	{cmd:local id = r(id)}
	{cmd:serset sort weight mpg}

{pstd}
would place the observations of the serset in ascending order of variable
{cmd:weight} and, within equal values of {cmd:weight}, ascending order of
variable {cmd:mpg}.

{pstd}
If no variables are specified after {cmd:serset sort}, {cmd:serset sort}
does nothing.  That is not considered an error.


{marker remarks7}{...}
{title:serset summarize}

{pstd}
{cmd:serset summarize} returns summary statistics about a variable in the
current serset.  It does not display output or in any way change the
current serset.

{pstd}
Returned in {cmd:r()} is exactly what the {helpb summarize} command returns in
{cmd:r()}.


{marker remarks8}{...}
{title:serset}

{pstd}
{cmd:serset} typed without arguments produces no output but returns in
{cmd:r()} information about the current serset:

	{cmd:r(id)}   the number assigned to the current serset
	{cmd:r(k)}    the number of variables in the current serset
	{cmd:r(N)}    the number of observations in the current serset

{pstd}
If no serset is in use, {cmd:r(id)} is set to -1, and {cmd:r(k)} and {cmd:r(N)}
are left undefined; no error message is produced.


{marker remarks9}{...}
{title:serset use}

{pstd}
{cmd:serset use} loads a serset into memory.  That is, it copies the current
serset into the current data.  The serset is left unchanged.


{marker remarks10}{...}
{title:serset reset_id}

{pstd}
{cmd:serset reset_id} is a rarely used command.  Its syntax is

{p 8 22 2}
{cmd:serset}
{cmd:reset_id}
{it:#_s}

{pstd}
{cmd:serset reset_id} changes the ID of the current serset -- its
number -- to the number specified, if that is possible.  If not, it
produces the error message {err:series {it:#_s} in use}; r(111).

{pstd}
Either way, the same serset continues to be the current serset (that is, the
number of the current serset changes if the command is successful).


{marker remarks11}{...}
{title:serset drop}

{pstd}
{cmd:serset drop} eliminates (erases) the specified sersets from memory.  For
instance,

	{cmd:serset drop 5}

{pstd}
would eliminate serset 5, and

	{cmd:serset drop 5/9}

{pstd}
would eliminate sersets 5 through 9.  Using {cmd:serset drop} to drop a
serset that does not exist is not an error; it does nothing.

{pstd}
Typing {cmd:serset drop _all} would drop all existing sersets.

{pstd}
Be careful not to drop sersets that are not yours:  Stata's graphics system
creates and holds onto sersets frequently, and, if you drop one of its
sersets that are in use, the graph on the screen will eventually "fall apart",
and Stata will produce error messages (Stata will not crash).  The graphics
system will itself drop sersets when it is through with them.

{pstd}
The {helpb discard} command also drops all existing sersets.  This, however, is
safe because {cmd:discard} also closes any open graphs.


{marker remarks12}{...}
{title:serset clear}

{pstd}
{cmd:serset clear} is a synonym for {cmd:serset drop _all}.


{marker remarks13}{...}
{title:serset dir}

{pstd}
{cmd:serset dir} displays a description of all existing sersets.


{marker remarks14}{...}
{title:file sersetwrite and file sersetread}

{pstd}
{cmd:file} {cmd:sersetwrite} and {cmd:file} {cmd:sersetread} are extensions to 
the {cmd:file} command; see {helpb file:[P] file}.  These extensions write and
read sersets into files.  The files may be opened {cmd:text} or {cmd:binary},
but, either way, what is written into the file will be in a binary format.

{pstd}
{cmd:file sersetwrite} writes the current serset.  A code fragment might read

	{cmd:serset create} ...
	{cmd:local base = r(id)}
	...
	{cmd:tempname hdl}
	{cmd:file open `hdl' using "`filename'", write} ...
	...
	{cmd:serset set `base'}
	{cmd:file sersetwrite `hdl'}
	...
	{cmd:file close `hdl'}

{pstd}
{cmd:file sersetread} reads a serset from a file, creating a new serset in
memory.  {cmd:file sersetread} returns in {cmd:r(id)} the serset ID of the
newly created serset.  A code fragment might read

	{cmd:tempname hdl}
	{cmd:file open `hdl' using "`filename'", read} ...
	...
	{cmd:file sersetread `hdl'}
	{cmd:local new = r(id)}
	...
	{cmd:file close `hdl'}

{pstd}
See {manhelp file P} for more information on the {cmd:file} command.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:serset create}, {cmd:serset create_xmedians}, {cmd:serset create_cspline}, {cmd:serset set}, and {cmd:serset} store the following in
{cmd:r()}:

{synoptset 10 tabbed}{...}
{p2col 5 10 14 2: Scalars}{p_end}
{synopt:{cmd:r(id)}}the serset ID{p_end}
{synopt:{cmd:r(k)}}the number of variables in the serset{p_end}
{synopt:{cmd:r(N)}}the number of observations in the serset{p_end}
{p2colreset}{...}

{pstd}
{cmd:serset summarize} returns in {cmd:r()} the same results as returned by
the {cmd:summarize} command.

{pstd}
{cmd:serset use} returns in macro {cmd:r(varnames)} the names of the variables
in the newly created dataset.

{pstd}
{cmd:file sersetread} returns in scalar {cmd:r(id)} the serset ID, which is
the identification number assigned to the serset.
{p_end}
