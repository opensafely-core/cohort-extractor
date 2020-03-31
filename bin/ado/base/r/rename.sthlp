{smcl}
{* *! version 1.2.8  19oct2017}{...}
{viewerdialog "Variables Manager" "stata varmanage"}{...}
{viewerdialog rename "dialog rename"}{...}
{vieweralsosee "[D] rename" "mansection D rename"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] rename group" "help rename group"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] generate" "help generate"}{...}
{vieweralsosee "[D] varmanage" "help varmanage"}{...}
{viewerjumpto "Syntax" "rename##syntax"}{...}
{viewerjumpto "Menu" "rename##menu"}{...}
{viewerjumpto "Description" "rename##description"}{...}
{viewerjumpto "Links to PDF documentation" "rename##linkspdf"}{...}
{viewerjumpto "Examples" "rename##examples"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] rename} {hline 2}}Rename variable{p_end}
{p2col:}({mansection D rename:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt ren:ame} {it:old_varname} {it:new_varname}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Data utilities > Rename groups of variables}


{marker description}{...}
{title:Description}

{pstd}
{cmd:rename} changes the name of an existing variable {it:old_varname} to
{it:new_varname}; the contents of the variable are unchanged.
Also see {bf:{help rename group:[D] rename group}} for renaming groups 
of variables.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D renameQuickstart:Quick start}

        {mansection D renameRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

    Setup
{phang2}{cmd:. webuse renamexmpl}{p_end}
{phang2}{cmd:. describe}{p_end}

{pstd}Change name of {cmd:exp} to {cmd:experience} and change name of
{cmd:inc} to {cmd:income}{p_end}
{phang2}{cmd:. rename exp experience}{p_end}
{phang2}{cmd:. rename inc income}{p_end}

{pstd}Describe the data{p_end}
{phang2}{cmd:. describe}{p_end}
