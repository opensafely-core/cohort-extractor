{smcl}
{* *! version 1.0.2  14jun2019}{...}
{vieweralsosee "[D] memory" "help memory"}{...}
{vieweralsosee "help limits" "help limits"}{...}
{title:Advice on 2+ billion observations}

{pstd}
Stata/MP allows more than 2 billion observations.
How many observations depends solely on the amount of memory on
your computer.  Stata will not limit you; it can count up to 1
trillion observations.

{pstd}
We have advice on using this feature.  Setting {cmd:min_memory} and
{cmd:segmentsize} will dramatically improve performance with large
numbers of observations.

{pstd}
First, let's address how many observations you will likely be able 
to process:

                                       Billions of observations
                   Computer's  Memory          scenario 
                     memory     used       (1)    (2)    (3) 
		   {hline 43}
                      128GB    112GB      1.8    1.4    1.0
                      256GB    240GB      3.8    2.9    2.1
                      512GB    496GB      7.9    6.1    4.4
                     1024GB   1008GB     16.2   12.3    9.8
                     1536GB   1520GB     24.4   18.5   13.6
		   {hline 43}
{p 12 12 12}
Notes:
{p_end}
{p 12 12 12}
{it:Memory used} is total used for storing data.  We left 16GB free for Stata
and other processes.  We assume that Stata consumes nearly all the
computer's resources (single user).

{p 12 12 12}
{it:Observations} leaves extra room for adding three doubles because 
Stata commands often add working variables.  The {it:width} used by 
the three scenarios is for your data exclusive of working variables. 

{p 12 12 2}
         Scenario 1:  width = 43 bytes (same as auto.dta) {break}
         Scenario 2:  width = 64 bytes{break}
         Scenario 3:  width = 96 bytes

{p 12 16 2}
	 Calculation:
{p_end}
{*             {it:obs} = (({it:memory_used}/{it:width}+24)*(1024²/1000²)}
		          {it:memory_used}    1024³
                 {it:obs}  =  {hline 12} × {hline 6}
                          {it:width} + 24     1000³

{p 12 16 2}
where {it:memory_used} is in gigabytes and {it:obs} is in billions.


{pstd}
Stata will run faster with large numbers of observations if you
change two memory settings, 
{cmd:segmentsize} and {cmd:min_memory}.  
Set {cmd:segmentsize} to 2g (the default is 32m),

	. {cmd:set segmentsize 2g}

{pstd}
Set {cmd:min_memory} to the amount of memory you want Stata to use, which
should be {it:Memory used} for your size of computer in the table above or a
smaller value:

	. {cmd:set min_memory 240g}   /* or smaller value on a 256g computer  */

	. {cmd:set min_memory 496g}   /* or smaller value on a 512g computer  */

	. {cmd:set min_memory 1008g}  /* or smaller value on a 1TB computer   */

	. {cmd:set min_memory 1520g}  /* or smaller value on a 1.5TB computer */

{pstd}
If you use a multiuser computer, be aware that setting 
{cmd:min_memory} causes Stata to allocate and reserve the memory 
for you and thus harms other users. 

{pstd}
If you are using frames (see {helpb frames intro:[D] frames intro}) to work
with multiple datasets in memory, be aware that the {cmd:min_memory} setting
operates on a per-frame basis.  Each frame will use the default value for
{bf:min_memory}.  If you {cmd:set} {cmd:min_memory} to, say, {bf:240g} in your
current frame, and you then create and change to another frame, you need to
{cmd:set} {cmd:min_memory} for that frame if you wish it to use something
other than the default.

{pstd}
If you are working with large datasets and have lots of memory available on
your system, you may also want to adjust the {cmd:set} {cmd:max_preservemem}
setting, which controls how much memory Stata will use as temporary storage
space for preserved datasets.  See {manhelp preserve D}.

{pstd}
When you are done using large numbers of observations, return 
the values to their defaults (or just exit Stata). 

	. {cmd:set min_memory 0}

	. {cmd:set segmentsize 32m}
