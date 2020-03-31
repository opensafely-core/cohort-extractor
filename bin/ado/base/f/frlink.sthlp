{smcl}
{* *! version 1.0.3  14jun2019}{...}
{vieweralsosee "[D] frlink" "mansection D frlink"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frget" "help frget"}{...}
{vieweralsosee "[D] frames intro" "help frames intro"}{...}
{vieweralsosee "[D] merge" "help merge"}{...}
{viewerjumpto "Syntax" "frlink##syntax"}{...}
{viewerjumpto "Description" "frlink##description"}{...}
{viewerjumpto "Links to PDF documentation" "frlink##linkspdf"}{...}
{viewerjumpto "Options" "frlink##options"}{...}
{viewerjumpto "Examples" "frlink##examples"}{...}
{viewerjumpto "Stored results" "frlink##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] frlink} {hline 2}}Link frames{p_end}
{p2col:}({mansection D frlink:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{marker linkage}{...}
{pstd}
Create linkage between current frame and another

{p 8 35 2}
{cmd:frlink} {c -(}{cmd:1:1}|{cmd:m:1}{c )-}
{help frlink##varlist1:{it:varlist}}₁{cmd:,}
{cmd:frame(}{it:frame}₂
[{help frlink##varlist2:{it:varlist}}₂]{cmd:)}{break}
[{cmdab:gen:erate(}{help frlink##linkvar1:{it:linkvar}}₁{cmd:)}]


{marker dir}{...}
{pstd}
List names of existing linkages

{p 8 8 2}
{cmd:frlink} {cmd:dir}


{marker describe}{...}
{pstd}
List details about existing linkage, and verify it is still valid

{p 8 8 2}
{cmd:frlink} {cmdab:d:escribe}
{help frlink##linkvar2:{it:linkvar}}₂


{marker rebuild}{...}
{pstd}
Re-create existing linkage when data have changed or frames are renamed

{p 8 8 2}
{cmd:frlink} {cmd:rebuild} 
{help frlink##linkvar2:{it:linkvar}}₂
[{cmd:,} {cmd:frame(}{help frlink##frame3:{it:frame}}₃{cmd:)}]


{pstd}
Drop existing linkage (dropping the variable eliminates the linkage)

{p 8 8 2}
{cmd:drop}
{help frlink##linkvar2:{it:linkvar}}₂


{marker merge}{...}
{phang}
{cmd:1:1} and {cmd:m:1} indicate how observations are to be matched. 

{marker varlist1}{...}
{phang}
{varlist}₁ contains the match variables in the current frame, which
we will call frame 1. 
{p_end}

{marker linkvar1}{...}
{phang}
{it:linkvar}₁ is the name to be given to the new variable that
{cmd:frlink} creates.  The variable is added to the dataset in frame 1.
The variable contains all the information needed to link the frames.

{pmore}
You specify the name for {it:linkvar}₁ using the
{cmd:generate(}{it:linkvar}₁{cmd:)} option, or you let {cmd:frlink}
name it for you.  If {cmd:frlink()} chooses the name, the variable is
given the same name as {it:frame}₂.

{marker linkvar2}{...}
{phang}
{it:linkvar}₂ is the name of an existing link variable.


{marker description}{...}
{title:Description}

{pstd}
{cmd:frlink} creates and helps manage links between datasets in
different frames.  A link allows the variables in one frame to be
accessed by another.  See {helpb frames intro:[D] frames intro} if
you do not know what a frame is.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D frlinkQuickstart:Quick start}

        {mansection D frlinkRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}
Options are presented under the following headings:

        {help frlink##opts_merge:Options for frlink 1:1 and frlink m:1}
	{help frlink##opts_rebuild:Options for frlink rebuild}


{marker opts_merge}{...}
{title:Options for frlink 1:1 and frlink m:1}

{marker varlist2}{...}
{phang}
{cmd:frame(}{it:frame}₂ [{it:varlist}₂]{cmd:)} specifies the name of the
frame, {it:frame}₂, to which a linkage is created and optionally the names of
variables in {it:varlist}₂ on which to match.
If {it:varlist}₂ is not specified, the match variables are assumed to have 
the same names in both frames.  {cmd:frame()} is required.

{pmore}
     To create a link to a frame named {cmd:counties}, you can type 

{p 12 12 2}
{cmd:. frlink m:1 countyid, frame(counties)}

{pmore}
    This example omits specification of {it:varlist}₂, and it works 
    when the match variable {cmd:countyid} has the same name 
    in both frames. If the variable were named {cmd:cntycode}, however, in 
    the other frame, you type 

{p 12 12 2}
    {cmd:. frlink m:1 countyid, frame(counties cntycode)}

{pmore}
    The rule for matching observations is thus that
    {cmd:countyid} in the current frame equals {cmd:cntycode} in the
    other frame.

{pmore}
    You can specify multiple match variables when necessary. 
    For example, you want to match on county names in U.S. data.
    County names repeat across the states, so you match on the 
    combined county and state names by typing 

{p 12 12 2}
{cmd:. frlink m:1 countyname statename, frame(counties)}

{pmore}
    If the match variables had different names in frame {cmd:counties},
    such as {cmd:county} and {cmd:state}, you type

{p 12 12 2}
{cmd:. frlink m:1 countyname statename, frame(counties county state)}

{phang}
{opth generate:(frlink##linkvar1:linkvar₁)}
    specifies the name of the new variable that will contain
    all the information needed to link the frames.  This variable is added to
    the dataset in frame 1.  This option is rarely used.

{pmore}
     If this option is not specified, the link variable will then be named the
     same as the frame name specified in the {cmd:frame()} option. 


{marker opts_rebuild}{...}
{title:Options for frlink rebuild}

{marker frame3}{...}
{phang}
{cmd:frame(}{it:frame}₃{cmd:)}
    specifies a frame name that differs from the existing linkage.
    {it:frame}₃ is the new name of a frame linked by
    {help frlink##linkvar2:{it:linkvar}}₂.

{pmore}
    For instance, yesterday, you created a linkage named {cmd:george} to the
    data in the frame named {cmd:george} by typing 

{p 12 48 2}
{cmd:. frlink m:1 countyname statename, frame(george)}

{pmore}
    Today, you loaded the linked data into a frame named {cmd:counties}.  
    To rebuild the linkage so that linkage {cmd:george} links to 
    the data in frame {cmd:counties}, type 

{p 12 48 2}
{cmd:. frlink rebuild george, frame(counties)}

{pmore}
    If you also wish to rename the linkage to be {cmd:counties}, type

{p 12 48 2}
{cmd:. rename george counties}

{pmore}
    Then you would have a linkage named {cmd:counties} to the data 
    in the frame named {cmd:counties}.
    


{marker examples}{...}
{title:Examples}

    {hline}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse persons}{p_end}
{phang2}{cmd:. frame create txcounty}{p_end}
{phang2}{cmd:. frame txcounty: webuse txcounty}

{pstd}Create many-to-1 linkage to frame {cmd:counties}, matching variable
{cmd:countyid} in the current frame to variable {cmd:countyid} in frame
{cmd:txcounty}{p_end}
{phang2}{cmd:. frlink m:1 countyid, frame(txcounty)}

    {hline}

{pstd}Setup{p_end}
{phang2}{cmd:. clear all}{p_end}
{phang2}{cmd:. webuse family}{p_end}
{phang2}{cmd:. frame create family}{p_end}
{phang2}{cmd:. frame family: use family    // yes, the same data}

{pstd}Create many-to-1 linkages{p_end}
{phang2}{cmd:. frlink m:1 pid_m, frame(people pid) generate(m)}{p_end}
{phang2}{cmd:. frlink m:1 pid_f, frame(people pid) generate(f)}

{pstd}Create a variable containing the ID of the current person's 
mother's mother, of the current person's mother's father,
of the current person's father's mother, and of the current person's
father's father{p_end}
{phang2}{cmd:. frget pid_mm = pid_m, from(m)}{p_end}
{phang2}{cmd:. frget pid_mf = pid_f, from(m)}{p_end}
{phang2}{cmd:. frget pid_fm = pid_m, from(f)}{p_end}
{phang2}{cmd:. frget pid_ff = pid_f, from(f)}

{pstd}Create many-to-1 linkages for each of the newly created variables
{p_end}
{phang2}{cmd:. frlink m:1 pid_mm, frame(family pid) generate(mm)}{p_end}
{phang2}{cmd:. frlink m:1 pid_mf, frame(family pid) generate(mf)}{p_end}
{phang2}{cmd:. frlink m:1 pid_fm, frame(family pid) generate(fm)}{p_end}
{phang2}{cmd:. frlink m:1 pid_ff, frame(family pid) generate(ff)}{p_end}

    {hline}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse discharge1, clear}{p_end}
{phang2}{cmd:. frame create discharge2}{p_end}
{phang2}{cmd:. frame discharge2: webuse discharge2}{p_end}

{pstd}Create 1-to-1 linkage to frame {cmd:discharge2} on variable
{cmd:patientid}{p_end}
{phang2}{cmd:. frlink 1:1 patientid, frame(discharge2)}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:frlink} {cmd:m:1} and {cmd:frlink} {cmd:1:1} store the following in
{cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt :{cmd:r(unmatched)}}{it:#} of observations in the current
frame unable to be matched{p_end}


{pstd}
{cmd:frlink} {cmd:dir} stores the following in {cmd:r()}:
 
{p2col 5 15 19 2: Scalars}{p_end}
{synopt :{cmd:r(n_vars)}}{it:#} of link variables{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt :{cmd:r(vars)}}space-separated list of link-variable names{p_end}


{pstd}
{cmd:frlink} {cmd:describe} stores nothing in {cmd:r()}.


{pstd}
{cmd:frlink} {cmd:rebuild} stores the following in {cmd:r()}:

{p2col 5 15 19 2: Scalars}{p_end}
{synopt :{cmd:r(unmatched)}}{it:#} of observations in the current
frame unable to be matched{p_end}
{p2colreset}{...}
