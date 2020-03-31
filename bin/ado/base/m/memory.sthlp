{smcl}
{* *! version 2.2.7  27apr2019}{...}
{vieweralsosee "[D] memory" "mansection D memory"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] creturn" "help creturn"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "memory##syntax"}{...}
{viewerjumpto "Description" "memory##description"}{...}
{viewerjumpto "Links to PDF documentation" "memory##linkspdf"}{...}
{viewerjumpto "Options" "memory##options"}{...}
{viewerjumpto "Remarks" "memory##remarks"}{...}
{viewerjumpto "Stored results" "memory##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] memory} {hline 2}}Memory management{p_end}
{p2col:}({mansection D memory:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}Display memory usage report

{p 8 16 2}
{cmd:memory}


{pstd}Display memory settings

{p 8 15 2}
{opt q:uery} {cmd:memory}


{pstd}Modify memory settings

{p 8 13 2}
{cmd:set maxvar}{bind:      }{it:#}
{bind:  }[{cmd:,} {opt perm:anently}]

{p 8 12 2}
{cmd:set niceness}{bind:    }{it:#}
{bind:  }[{cmd:,} {opt perm:anently}]

{p 8 12 2}
{cmd:set min_memory}{bind:  }{it:amt}
[{cmd:,} {opt perm:anently}]

{p 8 12 2}
{cmd:set max_memory}{bind:  }{it:amt}
[{cmd:,} {opt perm:anently}]

{p 8 12 2}
{cmd:set segmentsize} {it:amt}
[{cmd:,} {opt perm:anently}]

{phang}
where {it:amt} is {it:#}[{cmd:b}|{cmd:k}|{cmd:m}|{cmd:g}], and the
default unit is {cmd:b}.


           {c TLC}{hline 13}{c TT}{hline 9}{c TT}{hline 31}{c TRC}
           {c |} Parameter   {c |} Default {c |}       Minimum        Maximum  {c |}
           {c LT}{hline 13}{c +}{hline 9}{c +}{hline 31}{c RT}
	   {c |} {cmd:maxvar}      {c |}   {cmd:5000}  {c |}          {cmd:2048}         {cmd:120000}  {c |} (MP)
	   {c |}             {c |}   {cmd:5000}  {c |}          {cmd:2048}          {cmd:32767}  {c |} (SE)
	   {c |}             {c |}   {cmd:2048}  {c |}          {cmd:2048}           {cmd:2048}  {c |} (IC)
	   {c |} {cmd:}            {c |}         {c |}                               {c |}
	   {c |} {cmd:niceness}    {c |}      {cmd:5}  {c |}             {cmd:0}             {cmd:10}  {c |}
	   {c |} {cmd:}            {c |}         {c |}                               {c |}
	   {c |} {cmd:min_memory}  {c |}      {cmd:0}  |             {cmd:0}     {cmd:max_memory}  {c |}
	   {c |} {cmd:max_memory}  {c |}      {cmd:.}  {c |} 2*{cmd:segmentsize}              .  {c |}
	   {c |} {cmd:segmentsize} {c |}     {cmd:32m} {c |}             {cmd:1m}            {cmd:32g} {c |} (64-bit)
           {c BLC}{hline 13}{c BT}{hline 9}{c BT}{hline 31}{c BRC}

{p 4 4 2}
Notes:

{p 6 10 2}
1. 
The maximum number of variables in your dataset is limited to {cmd:maxvar}.
The default value of {cmd:maxvar} is 5,000 for Stata/MP and Stata/SE, and
2,048 for Stata/IC.  With Stata/MP and Stata/SE,
this default value may be increased by using {cmd:set maxvar}.
The default value is fixed for Stata/IC.

{p 6 10 2}
2.
Most users do not need to read beyond this point.  Stata's memory management
is completely automatic.  If, however, you are using the Linux
operating system, see 
{it:{help memory##linuxbug:Serious bug in Linux OS}} under 
{it:Remarks} below.

{p 6 10 2}
3.
The maximum number of observations is fixed at 1,099,511,627,775 for
Stata/MP and is fixed at 2,147,483,619 for Stata/SE and Stata/IC regardless 
of computer size or memory settings.  Depending on the amount of memory 
on your computer, you may face a lower practical limit.  See
{help obs_advice:help obs_advice}.

{p 6 10 2}
4. 
{cmd:max_memory} specifies the maximum amount of 
memory Stata can use to store your data.
The default of missing ({cmd:.}) means all the memory the operating system 
is willing to supply.
There are three reasons to change the value from missing to a finite number.

{p 14 18 2}
1.
You are a Linux user; see 
{it:{help memory##linuxbug:Serious bug in Linux OS}} under 
{it:Remarks} below.

{p 14 18 2}
2.
You wish to reduce the chances of accidents, such 
as typing {bf:expand 100000} with a large dataset in memory
and actually having Stata do it.  You would rather see an 
insufficient-memory error message.
Set {cmd:max_memory} to the amount of physical
memory on your computer or more than that if you are willing to 
use virtual memory.

{p 14 18 2}
3.
You are a system administrator; see 
{it:{help memory##sysadmin:Notes for system administrators}} under
{it:Remarks} below.

{p 6 10 2}
5. 
The remaining memory parameters -- {cmd:niceness}, {cmd:min_memory}, and
{cmd:segment_size} -- affect efficiency only; they do not affect the size of
datasets you can analyze.

{p 6 10 2}
6.
Memory amounts for {cmd:min_memory}, {cmd:max_memory}, and
{cmd:segmentsize} may be specified in bytes, kilobytes, megabytes, or
gigabytes; suffix {cmd:b}, {cmd:k}, {cmd:m}, or {cmd:g} to the end of the 
number.  The following are equivalent ways of specifying 1 gigabyte:

		{cmd:1073741824}
		   {cmd:1048576k}
		      {cmd:1024m}
		         {cmd:1g}

{p 10 10 2}
Suffix {cmd:k} is defined as (multiply by) 1024, {cmd:m} is defined as
1024^2, and {cmd:g} is defined as 1024^3.

{p 6 10 2}
7. 
64-bit computers can theoretically provide up to 
18,446,744,073,709,551,616 bytes of memory, 
equivalent to 17,179,869,184 gigabytes,
16,777,216 terabytes, 16,384 petabytes, or 16 exabytes.  Real computers have
less.

{p 6 10 2}
8.
Stata allocates memory for data in units of {cmd:segmentsize}. 
Smaller values of {cmd:segmentsize} can result in more efficient use 
of available memory but require Stata to jump around more.  The default 
provides a good balance.  We recommend resetting {cmd:segmentsize} only 
if your computer has large amounts of memory.

{p 6 10 2}
9.
If you have large amounts of memory and you use it to process large 
datasets, you may wish to increase {cmd:segmentsize}.  Suggested values
are 

		        memory       {cmd:segmentsize}
			{hline 24}
		          32g            64m
                          64g           128m
                         128g           256m
                         256g           512m
                         512g             1g
                        1024g             2g
			{hline 24}

{p 5 10 2}
10.
{cmd:niceness} affects how soon Stata gives back unused segments to the
operating system.  If Stata releases them too soon, it often needs to turn
around and get them right back.  If Stata waits too long, Stata is consuming
memory that it is not using.  One reason to give memory back is to be nice to
other users on multiuser systems or to be nice to yourself if you are running
other processes.

{p 10 10 2}
    The default value of 5 is defined to provide good performance.  Waiting
    times are currently defined as

		    niceness       waiting time (m:s)
                    {hline 33}
                      10                 0:00.000
                       9                 0:00.125
		       8                 0:00.500
                       7                 0:01
                       6                 0:30
                       5                 1:00
                       4                 5:00
                       3                10:00
                       2                15:00
                       1                20:00
                       0                30:00
                    {hline 33}

{p 10 10 2}
Niceness 10 corresponds to being totally nice.  Niceness 0 corresponds to
being an inconsiderate, self-centered, totally selfish jerk.

{p 5 10 2}
11.
{cmd:min_memory} specifies an amount of memory Stata will not fall below.  For
instance, you have a long do-file.  You know that late in the do-file, you
will need 8 gigabytes.  You want to ensure that the memory will be available
later.  At the start of your do-file, you {cmd:set} {cmd:min_memory} {cmd:8g}.

{p 5 10 2}
12.
Concerning {cmd:min_memory} and {cmd:max_memory}, 
be aware that Stata allocates memory in {cmd:segmentsize} blocks.
Both {cmd:min_memory} and {cmd:max_memory} are rounded down.
Thus the actual minimum memory Stata will reserve will be 
{cmd:segmentsize}{cmd:*trunc(}{cmd:min_memory/segmentsize}{cmd:)}.
The effective maximum memory is calculated similarly.
(Stata does not round up {cmd:min_memory} because some users set 
{cmd:min_memory} equal to {cmd:max_memory}.)


{marker description}{...}
{title:Description}

{pstd}
Memory usage and settings are described here.

{pstd}
{cmd:memory} displays a report on Stata's current memory usage.

{pstd}
{cmd:query memory} displays the current values of Stata's memory settings.

{pstd}
{cmd:set maxvar}, {cmd:set niceness}, 
{cmd:set min_memory}, 
{cmd:set max_memory}, and 
{cmd:set segmentsize} change the values of the memory settings.

{pstd}
If you are a Unix user, see 
{it:{help memory##linuxbug:Serious bug in Linux OS}} under 
{it:Remarks} below.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D memoryQuickstart:Quick start}

        {mansection D memoryRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt permanently} 
    specifies that, in addition to making the change right now, the new limit
    be remembered and become the default setting when you invoke Stata.

{phang}
{opt once}
    is not shown in the syntax diagram but is allowed with 
    {cmd:set niceness}, 
    {cmd:set min_memory}, 
    {cmd:set max_memory}, and
    {cmd:set segmentsize}. 
    It is for use by system administrators; see 
    {it:{help memory##sysadmin:Notes for system administrators}} under
    {it:Remarks} below.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help memory##examples:Examples}
	{help memory##linuxbug:Serious bug in Linux OS}
	{help memory##sysadmin:Notes for system administrators}


{marker examples}{...}
{title:Examples}

    Obtain memory-usage report
        {cmd:. memory}

    Obtain current memory-settings report
	{cmd:. query memory}

    Reset  maximum number of allowed variables
	{cmd:. set maxvar 5000}

    Reset memory settings
	{cmd:. set max_memory 32g}
	{cmd:. set min_memory 8g}
	{cmd:. set max_memory .}
	{cmd:. set min_memory 0}


{* DO NOT DELETE Serious bug in Linus FROM ONLINE help}{...}
{marker linuxbug}{...}
{title:Serious bug in Linux OS}

{pstd}
If you use Linux OS, we strongly suggest that you set {cmd:max_memory}.
Here's why:

{p 8 8 2}
       "By default, Linux follows an optimistic memory allocation strategy.
       This means that when malloc() returns non-NULL there is no guarantee
       that the memory really is available. This is a really bad bug.  In case
       it turns out that the system is out of memory, one or more processes
       will be killed by the infamous OOM killer.  In case Linux is employed
       under circumstances where it would be less desirable to suddenly lose
       some randomly picked processes, and moreover the kernel version is
       sufficiently recent, one can switch off this overcommitting behavior
       using [...]"
{p_end}
{p 30 34 2}
-- Output from Unix command {cmd:man malloc}.

{pstd}
What this means is that Stata requests memory from Linux, Linux says yes, 
and then later when Stata uses that memory, the memory might not be available 
and Linux crashes Stata, or worse.  The Linux documentation writer exercised 
admirable restraint.  This bug can cause Linux itself to crash.  It is easy.

{pstd}
The proponents of this behavior call it "optimistic memory allocation".
We will, like the documentation writer, refer to it as a bug.

{pstd}
The bug is fixable.  Type {cmd:man} {cmd:malloc} at the Unix prompt for
instructions.  Note that {cmd:man} {cmd:malloc} is an instruction of Unix, not
Stata.  If the bug is not mentioned, perhaps it has been fixed.  Before
assuming that, we suggest using a search engine to search for "linux
optimistic memory allocation".

{pstd}
Alternatively, Stata can live with the bug if you set {cmd:max_memory}.  Find
out how much physical memory is on your computer and {cmd:set}
{cmd:max_memory} to that.  If you want to use virtual memory, you might 
set it larger, just make sure your Linux system can provide the 
requested memory.  Specify the option {cmd:permanently} so you
only need to do this once.  For example,

	{cmd:. set max_memory 16g, permanently}

{pstd}
Doing this does not guarantee that the bug does not bite, but it makes it
unlikely.


{marker sysadmin}{...}
{title:Notes for system administrators}

{pstd}
System administrators can set {cmd:max_memory}, {cmd:min_memory}, and
{cmd:niceness} so that Stata users cannot change them.  They can also
do this with {cmd:max_preservemem} (see {manhelp preserve P:preserve}).
You may want to do this on shared computers to prevent individual users
from hogging resources.

{pstd}
There is no reason you would want to do this on users' personal computers.

{pstd}
You can also set {cmd:segmentsize}, but there is no reason to do this 
even on shared systems.

{pstd}
The instructions are to 
create (or edit) the text file {cmd:sysprofile.do} in the directory where
the Stata executable resides.
Add the lines

		{cmd:set min_memory 0, once}
		{cmd:set max_memory 16g, once}
		{cmd:set niceness 5, once}

{pstd}
The file must be plain text, and there must be end-of-line characters 
at the end of each line, including the last line.  Blank lines at the 
end are recommended.

{pstd}
The {cmd:16g} on {cmd:set} {cmd:max_memory} is merely for example.  Choose 
an appropriate number.  

{pstd}
The values of 0 for {cmd:min_memory} and 5 for {cmd:niceness} are recommended.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:memory} stores all reported numbers in {cmd:r()}.
StataCorp may change what {cmd:memory} reports, and you
should not expect the same {cmd:r()} results to exist in future
versions of Stata.  To see the stored results from {cmd:memory}, type
{cmd:return} {cmd:list,} {cmd:all}.{p_end}
