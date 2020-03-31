{smcl}
{* *! version 1.1.8  15may2018}{...}
{vieweralsosee "[M-3] mata matsave" "mansection M-3 matamatsave"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] Intro" "help m3_intro"}{...}
{viewerjumpto "Syntax" "mata_matsave##syntax"}{...}
{viewerjumpto "Description" "mata_matsave##description"}{...}
{viewerjumpto "Links to PDF documentation" "mata_matsave##linkspdf"}{...}
{viewerjumpto "Options for mata matsave" "mata_matsave##options_mata_matsave"}{...}
{viewerjumpto "Option for mata matuse" "mata_matsave##option_mata_matuse"}{...}
{viewerjumpto "Remarks" "mata_matsave##remarks"}{...}
{viewerjumpto "Diagnostics" "mata_matsave##diagnostics"}{...}
{viewerjumpto "Source code" "mata_matsave##source_code"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-3] mata matsave} {hline 2}}Save and restore matrices
{p_end}
{p2col:}({mansection M-3 matamatsave:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
: {cmd:mata} {cmd:matsave}
{it:{help filename}}
{it:namelist}
[{cmd:,}
{cmd:replace}
]

{p 8 16 2}
: {cmd:mata} {cmd:matuse}
{it:{help filename}}
[{cmd:,}
{cmd:replace}
]

{p 8 16 2}
: {cmd:mata} {cmdab:matd:escribe}
{it:{help filename}}


{p 4 4 2}
where {it:namelist} is a list of matrix names as defined in 
{bf:{help m3_namelists:[M-3] namelists}}.

{p 4 4 2}
If {it:filename} is specified without a suffix, {cmd:.mmat} is assumed.

{p 4 4 2}
These commands are for use in Mata mode following Mata's colon prompt.
To use these commands from Stata's dot prompt, type

		. {cmd:mata: mata matsave} ...


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mata} {cmd:matsave} saves the specified global matrices in 
{it:{help filename}}.

{p 4 4 2}
{cmd:mata} {cmd:matuse} loads the matrices stored in {it:filename}.

{p 4 4 2}
{cmd:mata} {cmd:matdescribe} describes the contents of {it:filename}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-3 matamatsaveRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_mata_matsave}{...}
{title:Option for mata matsave}

{p 4 8 2}
{cmd:replace} specifies that {it:{help filename}} may be replaced if it already
exists.


{marker option_mata_matuse}{...}
{title:Option for mata matuse}

{p 4 8 2}
{cmd:replace} specifies that any matrices in memory with the same name as
those stored in {it:{help filename}} can be replaced.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
These commands are for interactive use; they are not for use 
inside programs.  See {bf:{help mf_fopen:[M-5] fopen()}} for Mata's
programming functions for reading and writing files.
In the programming environment, 
if you have a matrix {it:X} and want to write it to file
{cmd:mymatrix.myfile}, you code 

		{cmd}fh = fopen("mymatrix.myfile", "w")
		fputmatrix(fh, X)
		fclose(fh){txt}

{p 4 4 2}
Later, you can read it back by coding

		{cmd}fh = fopen("mymatrix.myfile", "r")
		X = fgetmatrix(fh)
		fclose(fh){txt}

{p 4 4 2}
{cmd:mata} {cmd:matsave}, 
{cmd:mata} {cmd:matuse}, 
and
{cmd:mata} {cmd:matdescribe} 
are for use outside programs, when you are working interactively.
You can save your global matrices

	: {cmd:mata matsave mywork *}
	(saving A, X, Z, beta)
	file mywork.mmat saved

{p 4 4 2}
and then later get them back:

	: {cmd:mata matuse mywork}
	(loading A, X, Z, beta)

{p 4 4 2}
{cmd:mata} {cmd:matdescribe} will tell you the contents of a file:

	: {cmd:mata matdescribe mywork}
	file mywork.mmat saved on 4 Apr 2016 08:46:39 contains 
	X, X, Z, beta


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:mata} {cmd:matsave} saves the contents of view matrices.  Thus
when they are restored by {cmd:mata} {cmd:matuse}, the contents will be
correct regardless of the data Stata has loaded in memory.


{marker source_code}{...}
{title:Source code}

{p 4 4 2}
{view mata_matsave.ado, adopath asis:mata_matsave.ado},
{view mata_matuse.ado, adopath asis:mata_matuse.ado},
{view mata_matdescribe.ado, adopath asis:mata_matdescribe.ado},
{view mmat_.mata, adopath asis:mmat_.mata}
{p_end}
