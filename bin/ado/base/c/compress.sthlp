{smcl}
{* *! version 1.1.12  11may2018}{...}
{viewerdialog compress "dialog compress"}{...}
{vieweralsosee "[D] compress" "mansection D compress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] Data types" "help data_types"}{...}
{vieweralsosee "[D] recast" "help recast"}{...}
{viewerjumpto "Syntax" "compress##syntax"}{...}
{viewerjumpto "Menu" "compress##menu"}{...}
{viewerjumpto "Description" "compress##description"}{...}
{viewerjumpto "Links to PDF documentation" "compress##linkspdf"}{...}
{viewerjumpto "Option" "compress##option"}{...}
{viewerjumpto "Remarks" "compress##remarks"}{...}
{viewerjumpto "Example" "compress##example"}{...}
{viewerjumpto "Video example" "compress##video"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[D] compress} {hline 2}}Compress data in memory{p_end}
{p2col:}({mansection D compress:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:compress} [{varlist}] [{cmd:,} {cmd:nocoalesce}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Data utilities > Optimize variable storage}


{marker description}{...}
{title:Description}

{pstd}
{opt compress} attempts to reduce the amount of memory used by your data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D compressQuickstart:Quick start}

        {mansection D compressRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:nocoalesce} specifies that {cmd:compress} not try to find duplicate
values within {cmd:strL} variables in an attempt to save memory.  If
{cmd:nocoalesce} is not specified, {cmd:compress} must sort the data by each
{cmd:strL} variable, which can be time consuming in large datasets.


{marker remarks}{...}
{title:Remarks}

{pstd}
{opt compress} reduces the size of your dataset by considering
two things.  First, it considers demoting

{p 8 23 2}{cmd:double}s{space 3}to{space 3}{cmd:long}s, {cmd:int}s, or
	{cmd:byte}s{p_end}
{p 8 23 2}{cmd:float}s{space 4}to{space 3}{cmd:int}s or {cmd:byte}s{p_end}
{p 8 23 2}{cmd:long}s{space 5}to{space 3}{cmd:int}s or {cmd:byte}s{p_end}
{p 8 23 2}{cmd:int}s{space 6}to{space 3}{cmd:byte}s{p_end}
{p 8 23 2}{cmd:str}{it:#}s{space 5}to{space 3}shorter {cmd:str}{it:#}s{p_end}
{p 8 23 2}{cmd:strL}s{space 5}to{space 3}{cmd:str}{it:#}s

{pin}
See {manhelp data_types D:Data types} for an explanation of these storage types.

{pstd}
Second, it considers coalescing {cmd:strL}s within each {cmd:strL} variable.
That is to say, if a {cmd:strL} variable takes
on the same value in multiple observations, {cmd:compress} can link
those values to a single memory location to save memory.  To check
for this, {cmd:compress} must sort the data on each {cmd:strL}
variable.  You can use the {cmd:nocoalesce} option to tell {cmd:compress}
not to take the time to perform this check.  If {cmd:compress}
does check whether it can coalesce {cmd:strL} values, it will
do whichever saves more memory -- coalescing {cmd:strL} values
or demoting a {cmd:strL} to a {cmd:str}{it:#} -- or it will do
nothing if it cannot save memory by changing a {cmd:strL}.

{pstd}
{opt compress} leaves your data logically unchanged but (probably) appreciably
smaller.  {opt compress} never makes a mistake, results in loss of precision,
or hacks off strings.


{marker example}{...}
{title:Example}

    {cmd:. webuse compxmp2}
    {cmd:. compress}


{marker video}{...}
{title:Video example}

{phang2}{browse "https://www.youtube.com/watch?v=PIV9ugn6XL8":How to optimize the storage of variables}
