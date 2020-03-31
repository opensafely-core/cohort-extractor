{smcl}
{* *! version 1.1.8  21mar2018}{...}
{viewerdialog constraint "dialog constraint"}{...}
{vieweralsosee "[R] constraint" "mansection R constraint"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] cnsreg" "help cnsreg"}{...}
{vieweralsosee "[P] makecns" "help makecns"}{...}
{viewerjumpto "Syntax" "constraint##syntax"}{...}
{viewerjumpto "Menu" "constraint##menu"}{...}
{viewerjumpto "Description" "constraint##description"}{...}
{viewerjumpto "Links to PDF documentation" "constraint##linkspdf"}{...}
{viewerjumpto "Examples" "constraint##examples"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[R] constraint} {hline 2}}Define and list constraints{p_end}
{p2col:}({mansection R constraint:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}Define constraints

{p 8 25 2}
{opt cons:traint} [{opt de:fine}] {it:#}
      [{it:{help exp}} {cmd:=} {it:{help exp}} |
       {it:{help test##coeflist:coeflist}}]


{phang}List constraints

{p 8 25 2}
{opt cons:traint} {opt d:ir}  [{it:{help numlist}}{c |}{cmd:_all}] {p_end}

{p 8 25 2}
{opt cons:traint} {opt l:ist} [{it:{help numlist}}{c |}{cmd:_all}] {p_end}


{phang}Drop constraints

{p 8 25 2}{opt cons:traint} {cmd:drop} {c -(}{it:{help numlist}}{c |}{cmd:_all}{c )-} {p_end}


{phang}Programmer's commands

{p 8 25 2}{opt cons:traint} {cmd:get} {it:#} {p_end}

{p 8 25 2}{opt cons:traint} {cmd:free} {p_end}


{phang}
where {it:coeflist} is as defined in {manhelp test R} and
{it:#} is restricted to the range 1 to 1,999, inclusive.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Other > Manage constraints}


{marker description}{...}
{title:Description}

{pstd}
{cmd:constraint} defines, lists, and drops linear constraints.  Constraints
are for use by models that allow constrained estimation.

{pstd}
Constraints are defined by the {cmd:constraint} command.  The currently
defined constraints can be listed by either {cmd:constraint list} or
{cmd:constraint dir}; both do the same thing.  Existing constraints can be 
eliminated by {cmd:constraint drop}.

{pstd}
{cmd:constraint get} and {cmd:constraint free} are programmer's commands.
{cmd:constraint get} returns the contents of the specified constraint in
macro {cmd:r(contents)} and returns in scalar {cmd:r(defined)} 0 or
1 -- 1 being returned if the constraint was defined.
{cmd:constraint free} returns the number of a free (unused) constraint in
macro {cmd:r(free)}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R constraintQuickstart:Quick start}

        {mansection R constraintRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
For use with {helpb cnsreg} (where there is one equation):

{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. constraint 1 price = weight}{p_end}
{phang2}{cmd:. cnsreg mpg price weight, constraints(1)}

{pstd}
For use with {helpb mlogit} (where there are multiple equations):

{phang2}{cmd:. webuse sysdsn1}{p_end}
{phang2}{cmd:. constraint 2 [Uninsure]2.site = 0}{p_end}
{phang2}{cmd:. mlogit insure age male i.site, constraints(2)}{p_end}

{phang2}{cmd:. constraint 10 [Indemnity]: 2.site 3.site}{p_end}
{phang2}{cmd:. constraint 11 [Indemnity=Prepaid]: 3.site}{p_end}
{phang2}{cmd:. mlogit insure age male i.site, constraints(10/11) baseoutcome(3)}

{pstd}
In all cases:

{phang2}{cmd:. constraint drop 1, 10-11}{p_end}
{phang2}{cmd:. constraint drop _all}{p_end}
