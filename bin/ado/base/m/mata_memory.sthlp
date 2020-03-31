{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-3] mata memory" "mansection M-3 matamemory"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] Limits" "help m1_limits"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] mata clear" "help mata_clear"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] Intro" "help m3_intro"}{...}
{viewerjumpto "Syntax" "mata_memory##syntax"}{...}
{viewerjumpto "Description" "mata_memory##description"}{...}
{viewerjumpto "Links to PDF documentation" "mata_memory##linkspdf"}{...}
{viewerjumpto "Remarks" "mata_memory##remarks"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-3] mata memory} {hline 2}}Report on Mata's memory usage
{p_end}
{p2col:}({mansection M-3 matamemory:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
	: {cmd:mata memory}


{p 4 4 2}
This command is for use in Mata mode following Mata's colon prompt.
To use this command from Stata's dot prompt, type

		. {cmd:mata: mata memory}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mata} {cmd:memory} provides a summary of Mata's current memory 
utilization.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-3 matamemoryRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

	: {cmd:mata memory}
	{txt}                                 #              bytes
	  {hline 51}
	  autoloaded functions   {res}       15              5,514
	  {txt}ado functions          {res}        0                  0
	  {txt}defined functions      {res}        0                  0

	  {txt}matrices & scalars     {res}       14              8,256

	  {txt}overhead                            {res}          1,972
	{txt}  {hline 51}
	  total                  {res}       29             15,742{txt}


{p 4 4 2}
Functions are divided into three types:

{p 8 12 2}
1.  {it:Autoloaded functions}, which refer to library functions 
    currently loaded (and which will be automatically unloaded)
    from {helpb mata_mlib:.mlib} library files and {helpb mata_mosave:.mo}
    object files.

{p 8 12 2}
2.  {it:Ado-functions}, which refer to functions currently loaded 
    whose source appears in ado-files themselves. These functions will be 
    cleared when the ado-file is automatically cleared.

{p 8 12 2}
3.  {it:Defined functions}, which refer to functions that have been 
    defined either interactively or from do-files and which will be 
    cleared only when a {cmd:mata clear}, {cmd:mata drop}, Stata
    {cmd:clear mata}, or Stata {cmd:clear all} command is executed; see
    {bf:{help mata_clear:[M-3] mata clear}},
    {bf:{help mata_drop:[M-3] mata drop}}, and
    {bf:{help clear:[D] clear}}.
{p_end}
