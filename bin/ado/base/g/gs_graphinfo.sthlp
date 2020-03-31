{smcl}
{* *! version 1.0.6  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] gs_fileinfo" "help gs_fileinfo"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] gs_filetype" "help gs_filetype"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph describe" "help graph_describe"}{...}
{viewerjumpto "Syntax" "gs_graphinfo##syntax"}{...}
{viewerjumpto "Description" "gs_graphinfo##description"}{...}
{viewerjumpto "Remarks" "gs_graphinfo##remarks"}{...}
{viewerjumpto "Stored results" "gs_graphinfo##results"}{...}
{title:Title}

{p 4 26 2}
{hi:[G-2] gs_graphinfo} {hline 2} Subroutine to obtain information about memory
graph


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:gs_graphinfo}
{it:graphname}


{marker description}{...}
{title:Description}

{pstd}
{cmd:gs_graphinfo} returns information, including the command that generated
the graph.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:gs_graphinfo} produces no output except for error messages.

{pstd}
{cmd:gs_graphinfo} mirrors {cmd:gs_fileinfo}; see
{helpb gs_fileinfo}.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:gs_graphinfo} stores the following in {cmd:r()}:

	local  {cmd:r(fn)}            graph name
	local  {cmd:r(ft)}            "{cmd:live}"

	local  {cmd:r(scheme)}        scheme name
	local  {cmd:r(ysize)}         {cmd:ysize()} value
	local  {cmd:r(xsize)}         {cmd:xsize()} value

	local  {cmd:r(command)}       command
	local  {cmd:r(command_date)}  date on which command was run
	local  {cmd:r(command_time)}  time at which command was run
	local  {cmd:r(family)}        family to which command belongs

	local  {cmd:r(dtafile)}       .dta file in memory at command_time
	local  {cmd:r(dtafile_date)}  .dta file date

{pstd}
Note that any of {cmd:r(command)}, ..., {cmd:r(dtafile_date)}
may be undefined, so refer to contents using macro quoting.
{p_end}
