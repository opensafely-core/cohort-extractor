{smcl}
{* *! version 1.2.1  15may2018}{...}
{vieweralsosee "[G-4] Concept: repeated options" "mansection G-4 Conceptrepeatedoptions"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph" "help graph"}{...}
{viewerjumpto "Description" "repeated_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "repeated_options##linkspdf"}{...}
{viewerjumpto "Remarks" "repeated_options##remarks"}{...}
{p2colset 1 36 38 2}{...}
{p2col :{bf:{mansection G-4 Conceptrepeatedoptions:[G-4] Concept: repeated options}} {hline 2}}Interpretation of repeated options{p_end}
{p2col:}({mansection G-4 Conceptrepeatedoptions:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Options allowed with {cmd:graph} are categorized as being

	{it:unique}
	{it:rightmost}
	{it:merged-implicit}
	{it:merged-explicit}

{pstd}
What this means is described below.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 ConceptrepeatedoptionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
It may surprise you to learn that most {cmd:graph} options can be repeated
within the same {cmd:graph} command.  For instance, you can type

{phang2}
	{cmd:. graph twoway scatter mpg weight, msymbol(Oh) msymbol(O)}

{pstd}
and rather then getting an error, you will get back the same graph as if you
omitted typing the {cmd:msymbol(Oh)} option.  {cmd:msymbol()} is said to be a
{it:rightmost} option.

{pstd}
{cmd:graph} allows that because so many other commands are
implemented in terms of {cmd:graph}.  Imagine that an ado-file that constructs
the "{cmd:scatter mpg weight, msymbol(Oh)}" part, and you come along and use
that ado-file, and you specify to it the option "{cmd:msymbol(O)}".  The
result is that the ado-file constructs

{phang2}
	{cmd:. graph twoway scatter mpg weight, msymbol(Oh) msymbol(O)}

{pstd}
and, because {cmd:graph} is willing to ignore all but the rightmost
specification of the {cmd:msymbol()} option, the command works and does what
you expect.

{pstd}
Options in fact come in three forms, which are

{phang2}
1.  {it:rightmost}:  take the rightmost occurrence;

{phang2}
2.  {it:merged}:  merge the repeated instances together;

{phang2}
3.  {it:unique}:  the option may be specified only once; specifying it
more than once is an error.

{pstd}
You will always find options categorized one of these three ways; typically
that is done in the syntax diagram, but sometimes the categorization appears
in the description of the option.

{pstd}
{cmd:msymbol()} is an example of a {it:rightmost} option.  An example of a
{it:unique} option is {cmd:saving()}; it may be specified only once.

{pstd}
Concerning {it:merged} options, they are broken into two subcategories:

{p 7 12 2}
    2a.  {it:merged-implicit:}  always merge repeated instances together,

{p 7 12 2}
    2b.  {it:merged-explicit:} treat as {it:rightmost} unless an option within
	 the option is specified, in which case it is merged.

{pstd}
{cmd:merged} can apply only to options that take arguments because otherwise
there would be nothing to merge.  Sometimes those options themselves
take suboptions.  For instance, the syntax of the {cmd:title()} option (the
option that puts titles on the graph) is

{phang2}
	{cmd:title("}{it:string}{cmd:"} [{cmd:"}{it:string}{cmd:"} [...]] [{cmd:,} {it:suboptions}]{cmd:)}

{pstd}
{cmd:title()} has suboptions that specify how the title is to look and among
them is, for instance, {cmd:color()}; see {manhelpi title_options G-3}.
{cmd:title()} also has two other suboptions, {cmd:prefix} and {cmd:suffix},
that specify how repeated instances of the {cmd:title()} option are to be
merged.  For instance, specify

{phang2}
	... {cmd:title("My title")} ... {cmd:title("Second line", suffix)}

{pstd}
and the result will be the same as if you specified

	... {cmd:title("My title" "Second line")}

{pstd}
at the outset.  Specify

{phang2}
	... {cmd:title("My title")} ... {cmd:title("New line", prefix)}

{pstd}
and the result will be the same as if you specified

	... {cmd:title("New line" "My title")}

{pstd}
at the outset.  The {cmd:prefix} and {cmd:suffix} options specify exactly
how repeated instances of the option are to be merged.  If you do not specify
one of those options,

{phang2}
	... {cmd:title("My title")} ... {cmd:title("New title")}

{pstd}
the result will be as if you never specified the first option:

	... {cmd:title("New title")}

{pstd}
{cmd:title()} is an example of a {it:merged-explicit} option.  The suboption
names for handling {it:merged-explicit} are not always {cmd:prefix} and
{cmd:suffix}, but anytime an option is designated {it:merged-explicit}, it
will be documented under the heading {hi:Interpretation of repeated options}
exactly what and how the merge options work.


    {title:Technical note:}

{pin}
Even when an option is {it:merged-explicit} and its merge suboptions are not
specified, its other suboptions are merged.  For instance, consider

{phang3}
	    ... {cmd:title("My title", color(red))} ... {cmd:title("New title")}

{pin}
{cmd:title()} is {it:merged-explicit}, but because we did not specify one of its
merge options, it is being treated as {it:rightmost}.  Actually, it is almost
being treated as rightmost because, rather than the {cmd:title()} being
exactly what we typed, it will be

	    ... {cmd:title("New title", color(red))}

{pin}
This makes ado-files work as you would expect.  Say that you run the ado-file
{cmd:xyz.ado}, which constructs some graph and the command

{phang3}
	    {cmd:graph} ... {cmd:,} ... {cmd:title("Std. title", color(red))} ...

{pin}
You specify an option to {cmd:xyz.ado} to change the title:

{phang3}
	    {cmd:. xyz} ... {cmd:,} ... {cmd:title("My title")}

{pin}
The overall result will be just as you expect:  your title will be substituted,
but the color of the title (and its size, position, etc.) will not change.
If you wanted to change those things, you would have specified the appropriate
suboptions in your {cmd:title()} option.
{p_end}
