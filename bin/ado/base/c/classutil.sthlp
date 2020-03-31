{smcl}
{* *! version 1.1.11  19oct2017}{...}
{vieweralsosee "[P] classutil" "mansection P classutil"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] class: classman" "help classman"}{...}
{viewerjumpto "Syntax" "classutil##syntax"}{...}
{viewerjumpto "Description" "classutil##description"}{...}
{viewerjumpto "Links to PDF documentation" "classutil##linkspdf"}{...}
{viewerjumpto "Options for classutil describe" "classutil##options_describe"}{...}
{viewerjumpto "Options for classutil dir" "classutil##options_dir"}{...}
{viewerjumpto "Options for classutil which" "classutil##options_which"}{...}
{viewerjumpto "Remarks" "classutil##remarks"}{...}
{viewerjumpto "Stored results" "classutil##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[P] classutil} {hline 2}}Class programming utility{p_end}
{p2col:}({mansection P classutil:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Drop class instances from memory

{p 8 21 2}
{cmd:classutil} {cmd:drop} {it:instance} [{it:instance} [...]]


    Describe object

{p 8 21 2}
{cmd:classutil} {opt d:escribe} {it:object} [{cmd:,} {opt r:ecurse} {opt n:ewok}]


    List all defined objects

{p 8 21 2}
{cmd:classutil} {cmd:dir} [{it:pattern}] [{cmd:,} {cmd:all} {opt d:etail}]


    Display directory of available classes

{p 8 21 2}
{cmd:classutil} {cmd:cdir} [{it:pattern}]


    List .class file corresponding to classname

{p 8 21 2}
{cmd:classutil} {cmd:which} {it:classname} [{cmd:,} {cmd:all}]
 

{phang}
where

{pmore}
{it:object}, {it:instance}, and {it:classname} may be specified
with or without a leading period.

{pmore}
{it:instance} and {it:object} are as defined in {help classman}:
{it:object} is an {it:instance} or a {it:classname}.

{pmore}
{it:pattern} is as allowed with the {cmd:strmatch()} function:
{cmd:*} means 0 or more characters go here, and {cmd:?}{space 1}means exactly
one character goes here.

{phang}
Command {cmd:cutil} is a synonym for {cmd:classutil}.


{marker description}{...}
{title:Description}

{pstd}
If you have not yet read {manhelp class P}, please do so.  {cmd:classutil}
stands outside the class system and provides utilities for examining and
manipulating what it contains.

{pstd}
{cmd:classutil} {cmd:drop} drops the specified top-level class instances from
memory.  To drop all class objects, type {helpb discard}.

{pstd}
{cmd:classutil} {cmd:describe} displays a description of an object.

{pstd}
{cmd:classutil} {cmd:dir} displays a list of all defined objects.

{pstd}
{cmd:classutil} {cmd:cdir} displays a directory of all classes available.

{pstd}
{cmd:classutil} {cmd:which} lists which {cmd:.class} file corresponds to the
class specified.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P classutilRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_describe}{...}
{title:Options for classutil describe}

{phang}
{opt recurse} specifies that {cmd:classutil} {cmd:describe} be repeated on any
class instances or definitions that occur within the specified object.
Consider the case where you type {cmd:classutil} {cmd:describe} {cmd:.myobj}
and {cmd:.myobj} contains {cmd:.myobj.c0}, which is a {cmd:coordinate}.
Without the {opt recurse} option, you will be informed that {cmd:.myobj.c0} is
a {cmd:coordinate}, and {cmd:classutil} {cmd:describe} will stop right there.

{pmore}
With the {opt recurse} option, you will be informed that {cmd:.myobj.c0} is a
{cmd:coordinate}, and then {cmd:classutil} {cmd:describe} will proceed to
describe {cmd:.myobj.c0}, just as if you had typed '{cmd:classutil}
{cmd:describe} {cmd:.myobj.c0}'.  If {cmd:.myobj.c0} itself includes classes
or class instances, they too will be described.

{phang}
{opt newok} is relevant only when describing a class, although it is
allowed -- and ignored -- at other times.  {opt newok} allows
classes to be described even when no instances of the class exist.

{pmore}
When asked to describe a class, Stata needs to access information about that
class, and Stata only knows the details about a class when one or more
instances of the class exist.  If there are no instances, Stata is 
stuck -- it does not know anything other than a class of that name
exists.  {opt newok} specifies that, in such a circumstance, Stata may
temporarily create an instance of the class by using {cmd:.new}.  If Stata is
not allowed to do this, then Stata cannot describe the class.  The only reason
you are being asked to specify {opt newok} is that in some complicated
systems, running {cmd:.new} can have side effects, although in most
complicated and well-written systems, that will not be the case.


{marker options_dir}{...}
{title:Options for classutil dir}

{phang}
{opt all} specifies that class definitions (classes) be listed, as well
as top-level instances.

{phang}
{opt detail} specifies that a more detailed description of each of the
top-level objects be provided.  The default is simply to list the names of the
objects in tabular form.


{marker options_which}{...}
{title:Options for classutil which}

{phang}
{opt all} specifies that {cmd:classutil} {cmd:which} list all files along the
search path with the specified name, not just the first one (the one Stata
will use).


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help classutil##remarks1:classutil drop}
        {help classutil##remarks2:classutil describe}
        {help classutil##remarks3:classutil dir}
        {help classutil##remarks4:classutil cdir}
        {help classutil##remarks5:classutil which}


{marker remarks1}{...}
{title:classutil drop}

{pstd}
{cmd:classutil drop} may only be used with top-level instances, meaning 
objects other than classes having names with no dots other than the leading
dot.  If {cmd:.mycoord} is of type {cmd:coordinate} (or of type
{cmd:double}), it would be allowed to drop {cmd:.mycoord} but not
{cmd:coordinate} (or {cmd:double}).  Thus each of the following would be
valid, assuming that each is not a class definition:

	{cmd:. classutil drop .this}
	{cmd:. classutil drop .mycolor}
	{cmd:. classutil drop .this .mycolor}

{pstd}
The following would be invalid, assuming {cmd:coordinate} is a class:

	{cmd:. classutil drop coordinate}

{pstd}
There is no need to drop classes because they are automatically dropped when
the last instance of them is dropped.

{pstd}
The following would not be allowed because they are not top-level objects:

	{cmd:. classutil drop .this.that}
	{cmd:. classutil drop .mycolor.color.rgb[1]}

{pstd}
Second, third, and higher level objects are dropped when the top-level objects
containing them are dropped.

{pstd}
In all the examples above, we have shown objects identified with leading
periods, as is typical.  The period may, however, be omitted:

	{cmd:. classutil drop this mycolor}

{phang}
{it:Technical note:}
Stata's graphics are implemented using classes.  If you have a graph
displayed, be careful not to drop objects that are not yours.  If you drop
a system object, Stata will not crash, but {cmd:graph} may produce some
strange error messages.  If you are starting a development project, it is
best to {helpb discard} before starting -- that will eliminate all objects
and clear any graphs.  This way, the only objects defined will be the objects
you have created.


{marker remarks2}{...}
{title:classutil describe}

{pstd}
{cmd:classutil describe} presents a description of the object specified.  The
object may be a class or an instance and may be of any depth.  The following
are all valid:

	{cmd:. classutil describe coordinate}
	{cmd:. classutil describe .this}
	{cmd:. classutil describe .color.rgb}
	{cmd:. classutil describe .color.rgb[1]}

{pstd}
The object may be specified with or without a leading period; it makes no
difference.

{pstd}
Also see the descriptions of the {opt recurse} and {opt newok} options.
The following would also be allowed,

	{cmd:. classutil describe coordinate, newok}
	{cmd:. classutil describe line, recurse}
	{cmd:. classutil describe line, recurse newok}


{marker remarks3}{...}
{title:classutil dir}

{pstd}
{cmd:classutil} {cmd:dir} lists all top-level instances currently defined.
Note the emphasis on instances:  class definitions ({it:classes}) are not
listed.  {cmd:classutil dir, all} will list all objects, including the class
definitions.

{pstd}
If option {opt detail} is specified, a more detailed description is presented,
but still less detailed than that provided by {cmd:classutil} {cmd:describe}.

{pstd}
{it:pattern}, if specified, is as defined for Stata's {cmd:strmatch()} function:
{cmd:*} means 0 or more characters go here and {cmd:?}{space 1}means exactly
one character goes here.  If {it:pattern} is specified, only top level
instances or objects matching the pattern will be listed.  Examples include:

	{cmd:. classutil dir}
	{cmd:. classutil dir, detail}
	{cmd:. classutil dir, detail all}
	{cmd:. classutil dir c*}
	{cmd:. classutil dir *_g, detail}


{marker remarks4}{...}
{title:classutil cdir}

{pstd}
{cmd:classutil cdir} lists the available classes.  Without arguments, all
classes are listed.  If {it:pattern} is specified, only classes
matching the pattern are listed:

	. {cmd:classutil cdir}
	. {cmd:classutil cdir c*}
	. {cmd:classutil cdir coord*}
	. {cmd:classutil cdir *_g}
	. {cmd:classutil cdir color_?_?_*}

{pstd}
{it:pattern} is as defined for Stata's {cmd:strmatch()} function:  {cmd:*} means
0 or more characters go here and {cmd:?}{space 1}means exactly one character
goes here.

{pstd}
{cmd:classutil cdir} obtains the list by searching for {it:*}{cmd:.class}
files along the ado-path; see {manhelp sysdir P}.


{marker remarks5}{...}
{title:classutil which}

{pstd}
{cmd:classutil} {cmd:which} identifies the {cmd:.class} file associated
with class {it:classname} and displays lines from the file that begin with
{cmd:*!}.  For example,

	{cmd:. classutil which mycolortype}
	C:\ado\personal\mycolortype.class
	*! version 1.0.1

	{cmd:. classutil which badclass}
	{err:file "badclass.class" not found}
	r(601);

{pstd}
{cmd:classutil} {cmd:which} searches in the standard way for the {cmd:.class}
files, which is to say, by looking for it along the ado-path; see 
{manhelp sysdir P}.

{pstd}
With the {opt all} option, {cmd:classutil} {cmd:which} lists all files along
the search path with the specified name, not just the first one found (the one
Stata would use):

	{cmd:. classutil which mycolortype, all}

	C:\ado\personal\mycolortype.class
	*! version 1.0.1

	C:\ado\plus\m\mycolortype.class
	*! version 1.0.0

{pstd}
{cmd:*!} lines have to do with versioning.  {cmd:*} is one of Stata's comment
markers, so {cmd:*!} lines are comment lines.  {cmd:*!} is a convention that
some programmers use to record version or author information.  If there are no
{cmd:*!} lines, then only the filename is listed.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:classutil drop} returns nothing.

{pstd}
{cmd:classutil describe} returns macro {cmd:r(type)} containing {cmd:double},
{cmd:string}, {it:classname}, or {cmd:array} and returns {cmd:r(bitype)}
containing the same, except that if {cmd:r(type)}=="{it:classname}",
{cmd:r(bitype)} contains {cmd:class} or {cmd:instance}, depending on whether
the object is the definition or an instance of the class.

{pstd}
{cmd:classutil cdir} returns in macro {cmd:r(list)} the names of the available
classes matching the pattern specified. The names will not be preceded by a
period.

{pstd}
{cmd:classutil dir} returns in macro {cmd:r(list)} the names of the top-level
instances matching the pattern specified as currently defined in memory. The
names will be preceded by a period if the corresponding object is an instance
and will be unadorned if the corresponding object is a class definition.

{pstd}
{cmd:classutil which} without the {cmd:all} option returns in {cmd:r(fn)}
the name of the file found; the name is not enclosed in quotes. With the
{cmd:all} option, {cmd:classutil which} returns in {cmd:r(fn)} the names of
all the files found, listed one after the other and each enclosed in quotes.
{p_end}
