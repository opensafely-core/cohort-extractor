{smcl}
{* *! version 1.0.5  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] gs_fileinfo" "help gs_fileinfo"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph describe" "help graph_describe"}{...}
{viewerjumpto "Syntax" "gs_filetype##syntax"}{...}
{viewerjumpto "Description" "gs_filetype##description"}{...}
{viewerjumpto "Option" "gs_filetype##option"}{...}
{viewerjumpto "Remarks" "gs_filetype##remarks"}{...}
{viewerjumpto "Stored results" "gs_filetype##results"}{...}
{title:Title}

{p 4 21 2}
{hi:[G-2] gs_filetype} {hline 2} Subroutine to determine type of .gph file


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:gs_filetype}
{it:filename}
[{cmd:,}
{cmd:suffix}
]


{marker description}{...}
{title:Description}

{pstd}
{cmd:gs_filetype} returns whether {it:filename} is old, asis, or live
format.


{marker option}{...}
{title:Option}

{phang}
{cmd:suffix}
    specifies that {it:filename} is to be suffixed with {cmd:.gph}
    if it does not already contain a suffix.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:gs_filetype} produces no output except for the error messages:

	{err:invalid file specification}
	r(198);

	{err:file ____ not found}
	r(601);

	{err:file ____ not a Stata .gph file}
	r(610);

	{err:file ____ is a new format that this version of Stata does}
	{err:not know how to read}
	{err:    suggestion:  type -update query-}
	r(610);

	{err:file ____ is an old format that Stata no longer knows}
	{err:how to read}
	r(610);


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:gs_filetype} stores the following in {cmd:r()}:

	local  {cmd:r(fn)}            {it:filename} or {it:filename}{cmd:.gph}
	local  {cmd:r(ft)}            "{cmd:old}", "{cmd:asis}", or "{cmd:live}"
	local  {cmd:r(olddtl)}        "{cmd:real}" or "{cmd:emulation}", if {cmd:r(ft)}=="{cmd:old}"
	scalar {cmd:r(fversion)}      file format if {cmd:live}
	scalar {cmd:r(cversion)}      code format if {cmd:live}
