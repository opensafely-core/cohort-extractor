{smcl}
{* *! version 1.3.3  07oct2014}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _coef_table" "help _coef_table"}{...}
{vieweralsosee "[P] ereturn display" "help ereturn"}{...}
{viewerjumpto "Syntax" "_get_diopts##syntax"}{...}
{viewerjumpto "Description" "_get_diopts##description"}{...}
{viewerjumpto "Examples" "_get_diopts##examples"}{...}
{title:Title}

{pstd}
{hi:[P] _get_diopts} {hline 2}
Parsing tool for estimation commands


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_get_diopts} {it:diopts} [{it:rest}] [{cmd:,} {it:options}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_get_diopts} helps with syntax checking and parsing options for
estimation commands.  The options specified in {it:options} will be separated
into groups and returned in local macros specified by the caller.  The names of
the local macros are identified by {it:diopts} and {it:rest}.

{phang}
{it:diopts} is required and will contain those options that control how the
coefficient table generates output.  Options returned in {it:diopts} are

{pmore}
	{opt level(#)}
	{opt vsquish}
	{opt base:levels}
	{opt allbase:levels}
	{opt nocnsr:eport}
	{opt fullcnsr:eport}
	{opt noomit:ted}
	{opt noempty:cells}
	{opt nolstretch}
	{opt coefl:egend}
	{opt selegend}
	{opt noci}
	{opt nopv:alues}
	{opt cformat()}
	{opt sformat()}
	{opt pformat()}
	{opt nolstretch}
	{opt nofvlab:el}
	{opt fvwrap(#)}
	{opt fvwrapon(style)}

{phang}
{it:rest}, if specified, will contain all other options that
were not returned in {it:diopts}.  If {it:rest} is not specified, then any
extra options will cause an error.


{marker examples}{...}
{title:Examples}

    {cmd}. _get_diopts diopts options, `options'

    {cmd}. _get_diopts options, `options'
