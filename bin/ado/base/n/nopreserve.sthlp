{smcl}
{* *! version 1.0.6  23oct2017}{...}
{vieweralsosee "[P] nopreserve option" "mansection P nopreserveoption"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] preserve" "help preserve"}{...}
{viewerjumpto "Syntax" "nopreserve##syntax"}{...}
{viewerjumpto "Description" "nopreserve##description"}{...}
{viewerjumpto "Links to PDF documentation" "nopreserve##linkspdf"}{...}
{viewerjumpto "Option" "nopreserve##option"}{...}
{viewerjumpto "Remarks" "nopreserve##remarks"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[P] nopreserve option} {hline 2}}nopreserve option{p_end}
{p2col:}({mansection P nopreserveoption:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2} 
{it:stata_command} 
...
[{cmd:,} ...
{cmd:nopreserve}
...]


{marker description}{...}
{title:Description}

{p 4 4 2}
Some Stata commands have a {cmd:nopreserve} option.  This option is 
for use by programmers when {it:stata_command} is used as a subroutine 
of another command.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P nopreserveoptionRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{p 4 8 2}
{cmd:nopreserve}
    specifies that {it:stata_command} need not bother to {cmd:preserve} 
    the data in memory.  The usual situation is that {it:stata_command} is
    being used as a subroutine by another program, the data in memory have
    been preserved by the caller, and the caller will not need to access the
    data again before the data are restored from the caller's preserved
    copy.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Some commands change the data in memory in the process of
performing their task even though the command officially does not change the
data in memory.  Such commands achieve this by using 
{helpb preserve} to make a temporary copy of the data on disk, which is later
restored to memory.

{p 4 4 2}
Even some commands whose entire purpose is to make a modification to 
the data in memory sometimes make temporary copies of the data just 
in case the user should press {hi:Break} while the changes to the data 
are still being completed.

{p 4 4 2}
This is done using {cmd:preserve}; see {manlink P preserve}.

{p 4 4 2}
Assume {cmd:alpha} and {cmd:beta} are each implemented using {cmd:preserve}.
Assume that {cmd:alpha} uses {cmd:beta} as a subroutine.  If {cmd:alpha} itself
does not intend to use the data after calling {cmd:beta}, then {cmd:beta}
preserving and restoring the data is unnecessary because {cmd:alpha} already
has preserved the data from which memory will be restored.  Then 
{cmd:alpha} should specify the {cmd:nopreserve} option when calling {cmd:beta}.
{p_end}
