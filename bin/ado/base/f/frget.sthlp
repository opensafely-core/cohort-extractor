{smcl}
{* *! version 1.0.2  14jun2019}{...}
{vieweralsosee "[D] frget" "mansection D frget"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frlink" "help frlink"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frames intro" "help frames intro"}{...}
{vieweralsosee "[D] merge" "help merge"}{...}
{viewerjumpto "Syntax" "frget##syntax"}{...}
{viewerjumpto "Description" "frget##description"}{...}
{viewerjumpto "Links to PDF documentation" "frget##linkspdf"}{...}
{viewerjumpto "Options" "frget##options"}{...}
{viewerjumpto "Examples" "frget##examples"}{...}
{viewerjumpto "Stored results" "frget##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[D] frget} {hline 2}}Copy variables from linked frame{p_end}
{p2col:}({mansection D frget:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 35 2}
{cmd:frget} {varlist}{cmd:,} 
{cmd:from(}{it:linkname}{cmd:)}
[{it:rename_options}]{bind:    (1)}

{p 8 35 2}
{cmd:frget} {newvar} {cmd:=} {varname}{cmd:,} 
{cmd:from(}{it:linkname}{cmd:)}
{bind:           (2)}


{marker linkname}{...}
{phang}
{it:linkname} is the name of a {it:linkvar} in the current frame 
         that was created by {cmd:frlink};  see {bf:{help frlink:[D] frlink}}.

{synoptset}{...}
{synopthdr:rename_option}
{synoptline}
{synopt :{opth pre:fix(string)}}prefix new variable names with
{it:string}{p_end}
{synopt :{opth suf:fix(strings:string)}}suffix new variable names with
{it:string}{p_end}
{synopt :{opth exclude(varlist)}}exclude specified variables{p_end}
{synoptline}

{phang}
Syntax 1 copies the variable names specified by {it:varlist} from the
         frame linked by {it:linkname} to the current frame.

{phang}
Syntax 2 copies {it:varname} from the frame linked by {it:linkname}
         to {it:newvar} in the current frame.

{pmore}
    Copy means copy and clone.  Display formats, variable labels, value
    labels, notes, and characteristics are also copied. 

{p 4 8 2}
In syntax 2, {it:newvar}{cmd:=}{it:varname} may be repeated.  
For example, 

{p 12 16 2}
{cmd:. frget edinc=income hval=homevalue, from(counties)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:frget} copies variables and their associated metadata 
from the data in the linked frame to the data in the current frame.
Copy means copying the relevant observations from the linked 
frame to the appropriate observations in the current frame. 

{pstd}
See {helpb frames intro:[D] frames intro} if you do not know what a
frame is.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D frgetQuickstart:Quick start}

        {mansection D frgetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:from(}{help frget##linkname:{it:linkname}}{cmd:)} 
    specifies the identity of the linked frame
    from which variables are copied.  Linkages to frames are created by
    the {bf:{help frlink:frlink}} command.  Linkages are usually named
    for the frame to which they link.  Linkage {cmd:counties} links to 
    frame {cmd:counties}, and so you specify {cmd:from(counties)}.  If
    linkage {cmd:c} links to frame {cmd:counties}, you specify
    {cmd:from(c)}.  {cmd:from()} is required.

{phang}
{opth prefix:(strings:string)}
    specifies a string to be prefixed to the names of
    the new variables created in the current frame.  Say that you type 

{p 12 14 2}
{cmd:. frget inc*, from(counties)}

{pmore}
    to request that variables {cmd:income} and {cmd:income_family} be
    copied to the current frame.  If variable {cmd:income} already
    exists in the current frame, the command would issue an error message to
    that effect and copy neither variable.  To copy the two variables, you
    could type

{p 12 14 2}
{cmd:. frget inc*, from(counties) prefix(c_)}

{pmore}
    Then the variables would be copied to variables named 
    {cmd:c_income} and {cmd:c_income_family}.

{phang}
{opth suffix:(strings:string)}
    works like {cmd:prefix(}{it:string}{cmd:)}, the difference being that 
    the string is suffixed rather than prefixed to the variable names. 
    Both options may be specified if you wish. 

{phang}
{opth exclude(varlist)}
   specifies variables that are not to be copied.  An example of the
   option is

{p 12 14 2}
{cmd:frget *, from(counties) exclude(emp*)}

{pmore}
    All variables except variables starting with {cmd:emp} would 
    be copied. 

{pmore}
    More correctly, all variables except {cmd:emp*}, {cmd:_*}, and the
    {help frlink:match variables} would be copied because
    {cmd:frget} always omits the underscore and match variables.  See the
    {mansection D frgetRemarksandexamplesexplain:explanation} below.


{marker examples}{...}
{title:Examples}

{pstd}
Obtain variables {cmd:a}, {cmd:b}, and {cmd:c} from another frame linked
to by linkage {cmd:lnk}{p_end}
{phang2}{cmd:. frget a b c, from(lnk)}

{pstd}
Obtain variables d and e via linkage {cmd:lnk}, naming them {cmd:newd}
and {newe} in the current frame{p_end}
{phang2}{cmd:. frget newd=d newe=e, from(lnk)}

{pstd}
Obtain all variables via linkage {cmd:lnk}, prefixing them with
{cmd:l_}{p_end}
{phang2}{cmd:frget *, from(lnk) prefix(l_)}

{pstd}
Obtain all variables via linkage {cmd:lnk}, excluding those matching
pattern {cmd:ind*}{p_end}
{phang2}{cmd:. frget *, from(lnk) exclude(ind*)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:frget} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(k)}}number of variables copied from linked frame{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(newlist)}}new variables in the current frame{p_end}
{synopt:{cmd:r(srclist)}}variables copied from linked frame{p_end}
{synopt:{cmd:r(excluded)}}variables not copied from linked frame{p_end}
{synopt:{cmd:r(dups)}}variables already present in the current frame{p_end}
{synopt:{cmd:r(notfound)}}variables not found in the linked frame{p_end}
{p2colreset}{...}

{pstd}
{cmd:r(dups)} is present only if {cmd:frget} exits with an error message
because a prospective new variable name already exists in the current frame.

{pstd}
{cmd:r(notfound)} is present only for syntax 2 when {cmd:frget} exits with
an error message because a {it:varname} is not found in the linked frame.
{p_end}
