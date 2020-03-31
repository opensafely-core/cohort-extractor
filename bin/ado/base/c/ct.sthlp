{smcl}
{* *! version 1.1.5  20sep2018}{...}
{vieweralsosee "[ST] ct" "mansection ST ct"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] ctset" "help ctset"}{...}
{vieweralsosee "[ST] cttost" "help cttost"}{...}
{vieweralsosee "[ST] st" "help st"}{...}
{vieweralsosee "[ST] Survival analysis" "help survival_analysis"}{...}
{p2colset 1 12 14 2}{...}
{p2col:{bf:[ST] ct} {hline 2}}Count-time data{p_end}
{p2col:}({mansection ST ct:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{title:Description}

{pstd}
The term ct refers to count-time data and the commands -- all of which
begin with the letters "ct" -- for analyzing them.  If you have data on
populations, whether people or generators, with observations recording the
number of units under test at time t (subjects alive) and the number of
subjects that failed or were lost because of censoring, you have what we call
count-time data.

{pstd}
If, on the other hand, you have data on individual subjects with observations 
recording that this subject came under observation at time t0 and that later, 
at t1, a failure or censoring was observed, you have what we call 
survival-time data.  If you have survival-time data, see {manhelp st ST}.

{pstd}
Do not confuse count-time data with counting-process data, which can be analyzed
using the st commands; see {manhelp st ST}.

{pstd}
There are two ct commands:

{p 8 29 2}{helpb ctset} {space 5} Declare data to be count-time data{p_end}
{p 8 29 2}{helpb cttost} {space 4} Convert count-time data to survival-time data

{pstd}
The key is the {cmd:cttost} command.  Once you have converted your
count-time data to survival-time data, you can use the st commands to analyze
the data.  The entire process is as follows:

{phang2}1.  {cmd:ctset} your data so that Stata knows that they are count-time 
data; see {manhelp ctset ST}.

{phang2}2.  Type {cmd:cttost} to convert your data to survival-time data; see 
{manhelp cttost ST}. 

{phang2}3.  Use the st commands; see {manhelp st ST}.
{p_end}
