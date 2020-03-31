{smcl}
{* *! version 1.0.0  12jun2019}{...}
{vieweralsosee "[D] vl create" "mansection D vlcreate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] vl" "help vl"}{...}
{vieweralsosee "[D] vl drop" "help vl drop"}{...}
{vieweralsosee "[D] vl list" "help vl list"}{...}
{vieweralsosee "[D] vl rebuild" "help vl rebuild"}{...}
{vieweralsosee "[D] vl set" "help vl set"}{...}
{viewerjumpto "Syntax" "vl create##syntax"}{...}
{viewerjumpto "Description" "vl create##description"}{...}
{viewerjumpto "Links to PDF documentation" "vl create##linkspdf"}{...}
{viewerjumpto "Examples" "vl create##examples"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[D] vl create} {hline 2}}Create and modify user-defined variable
lists{p_end}
{p2col:}({mansection D vlcreate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Create user-defined variable lists

{p 8 16 2}
{cmd:vl create} {it:vlusername} {cmd:=} {cmd:(}{varlist}{cmd:)}

{p 8 16 2}
{cmd:vl create} {it:vlusername} {cmd:=} {it:vlname} {cmd:+}{c |}{cmd:-}
             {cmd:(}{varlist}{cmd:)}

{p 8 16 2}
{cmd:vl create} {it:vlusername} {cmd:=} {it:vlname1} [{cmd:+}{c |}{cmd:-}
            {it:vlname2}]


{pstd}
Modify user-defined variable lists

{p 8 16 2}
{cmd:vl} {cmdab:mod:ify} {it:vlusername} {cmd:=} {cmd:(}{varlist}{cmd:)}

{p 8 16 2}
{cmd:vl} {cmdab:mod:ify} {it:vlusername} {cmd:=} {it:vlname}
           {cmd:+}{c |}{cmd:-} {cmd:(}{varlist}{cmd:)}

{p 8 16 2}
{cmd:vl} {cmdab:mod:ify} {it:vlusername} {cmd:=} {it:vlname1}
            [{cmd:+}{c |}{cmd:-} {it:vlname2}]


{pstd}
Apply factor-variable operators to variable-list names

{p 8 16 2}
{cmd:vl} {cmdab:sub:stitute} {it:vlusername} {cmd:=} {cmd:i.}{it:vlname}

{p 8 16 2}
{cmd:vl} {cmdab:sub:stitute} {it:vlusername} {cmd:=}
            {cmd:i.}{it:vlname1}{cmd:#i.}{it:vlname2}

{p 8 16 2}
{cmd:vl} {cmdab:sub:stitute} {it:vlusername} {cmd:=}
            {cmd:i.}{it:vlname1}{cmd:##c.}{it:vlname2}


{pstd}
Label a user-defined variable-list name

{p 8 16 2}
{cmd:vl} {cmdab:lab:el} {it:vlusername} [{cmd:"}{it:label}{cmd:"}]


{phang}
{it:vlname} is an existing user-defined variable-list name or a system-defined
variable-list name.  When specifying {it:varlist}, it is always enclosed
in parentheses: {cmd:(}{it:varlist}{cmd:)}.  See {manhelp vl D}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:vl} {cmd:create} creates user-defined variable lists.

{pstd}
{cmd:vl} {cmd:modify} modifies existing user-defined variable lists.

{pstd}
{cmd:vl} {cmd:substitute} creates a variable list using factor-variable
operators operating on variable lists.

{pstd}
After creating a variable list called {it:vlusername}, the expression
{cmd:$}{it:vlusername} can be used in Stata anywhere a {varlist} is allowed.
Variable lists are actually {help macro:global macros}, and the {cmd:vl}
commands are a convenient way to create and manipulate them.  They are saved
with the dataset.  See {manhelp vl_rebuild D:vl rebuild}.

{pstd}
For an introduction to the {cmd:vl} commands, see
{manhelp vl D}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D vlcreateQuickstart:Quick start}

        {mansection D vlcreateRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.
{p_end}


{marker examples}{...}
{title:Examples}

{pstd}Create a new variable list from a list of variables{p_end}
{phang2}{cmd:. vl create myxvars = (x1-x100)}

{pstd}Create a new variable list from an existing variable list{p_end}
{phang2}{cmd:. vl create indepvars = myxvars}

{pstd}Modify an existing variable list to include two other variable lists
with duplicates removed{p_end}
{phang2}{cmd:. vl modify indepvars = myxvars + othervars}

{pstd}Modify that same list to obtain the difference of the two variable
lists{p_end}
{phang2}{cmd:. vl modify indepvars = myxvars - othervars}

{pstd}Create a new variable list with factor variables and then use the list
with {cmd:regress}{p_end}
{phang2}{cmd:. vl substitute myinteractions = i.myfactors##c.mycontinuous}{p_end}
{phang2}{cmd:. regress y $myinteractions}{p_end}
