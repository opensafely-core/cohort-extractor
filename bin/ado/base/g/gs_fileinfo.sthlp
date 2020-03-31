{smcl}
{* *! version 1.0.5  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] gs_graphinfo" "help gs_graphinfo"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] gs_filetype" "help gs_filetype"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph describe" "help graph_describe"}{...}
{viewerjumpto "Syntax" "gs_fileinfo##syntax"}{...}
{viewerjumpto "Description" "gs_fileinfo##description"}{...}
{viewerjumpto "Option" "gs_fileinfo##option"}{...}
{viewerjumpto "Remarks" "gs_fileinfo##remarks"}{...}
{viewerjumpto "Stored results" "gs_fileinfo##results"}{...}
{title:Title}

{p 4 21 2}
{cmd:[G-2] gs_fileinfo} {hline 2} Subroutine to obtain information about .gph
file


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:gs_fileinfo}
{it:filename}
[{cmd:,}
{cmd:suffix}
]


{marker description}{...}
{title:Description}

{pstd}
{cmd:gs_fileinfo} returns whether {it:filename} is old, asis, or live and,
if it is live, returns additional information including the command that
generated the graph.


{marker option}{...}
{title:Option}

{phang}
{cmd:suffix}
    specifies that {it:filename} is to be suffixed with {cmd:.gph}
    if it does not already contain a suffix.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:gs_fileinfo} produces no output except for error messages.

{pstd}
{cmd:gs_fileinfo} is implemented in terms of {cmd:gs_filetype}; see
{helpb gs_filetype}.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:gs_fileinfo} stores the following in {cmd:r()}:

	local  {cmd:r(fn)}            {it:filename} or {it:filename}{cmd:.gph}
	local  {cmd:r(ft)}            "{cmd:old}", "{cmd:asis}", or "{cmd:live}"

{pstd}
If {cmd:r(ft)}=="{cmd:live}", then the following is also stored:

	scalar {cmd:r(fversion)}      file format
	scalar {cmd:r(cversion)}      code format

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
