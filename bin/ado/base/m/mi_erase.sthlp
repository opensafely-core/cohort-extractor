{smcl}
{* *! version 1.0.7  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi erase" "mansection MI mierase"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi copy" "help mi_copy"}{...}
{vieweralsosee "[MI] Styles" "help mi_styles"}{...}
{viewerjumpto "Syntax" "mi_erase##syntax"}{...}
{viewerjumpto "Menu" "mi_erase##menu"}{...}
{viewerjumpto "Description" "mi_erase##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_erase##linkspdf"}{...}
{viewerjumpto "Option" "mi_erase##option"}{...}
{viewerjumpto "Remarks" "mi_erase##remarks"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[MI] mi erase} {hline 2}}Erase mi datasets{p_end}
{p2col:}({mansection MI mierase:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi erase} {it:name} [{cmd:, clear}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:erase} erases {cmd:mi} {cmd:.dta} datasets.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI mieraseRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{p 4 8 2}
{cmd:clear} specifies that it is okay to erase the files even if one of the
    files is currently in memory.  If {cmd:clear} is specified, the data are
    dropped from memory and the files are erased.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Stata's ordinary {bf:{help erase:erase}}
is not sufficient for erasing {cmd:mi} datasets because an {cmd:mi}
dataset might 
be flongsep, in which case the single name would refer to a collection of 
files, one containing {it:m}=0, another containing {it:m}=1, and so on.
{cmd:mi} {cmd:erase} deletes all the files associated with {cmd:mi} 
dataset {it:name}{cmd:.dta}, which is to say, it erases 
{it:name}{cmd:.dta}, 
{cmd:_1_}{it:name}{cmd:.dta}, 
{cmd:_2_}{it:name}{cmd:.dta}, and so on:

	. {cmd:mi erase mysep}
	(files mysep.dta, _1_mysep.dta _2_mysep.dta _3_mysep.dta erased)
