{smcl}
{* *! version 1.1.11  19oct2017}{...}
{vieweralsosee "[P] class" "mansection P class"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] class: classassign" "help classassign"}{...}
{vieweralsosee "[P] class: classbi" "help classbi"}{...}
{vieweralsosee "[P] class: classdeclare" "help classdeclare"}{...}
{vieweralsosee "[P] class: classmacro" "help classmacro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] class exit" "help class exit"}{...}
{vieweralsosee "[P] classutil" "help classutil"}{...}
{vieweralsosee "[P] sysdir" "help sysdir"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] class" "help m2_class"}{...}
{viewerjumpto "Description" "classman##description"}{...}
{viewerjumpto "Links to PDF documentation" "classman##linkspdf"}{...}
{viewerjumpto "Remarks" "classman##remarks"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[P] class} {hline 2}}Class programming
{p_end}
{p2col:}({mansection P class:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Ado classes are a programming feature of Stata that are especially useful
for dealing with graphics and GUI problems, although their use need not
be restricted to those topics.  Ado class programming is an advanced
programming topic and will not be useful to most programmers.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P classRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{hi:{help classman##introduction:1. Introduction}}
	{hi:{help classman##definitions:2. Definitions}}
	    {hi:{help classman##class_definition:2.1 Class definition}}
	    {hi:{help classman##class_instance:2.2 Class instance}}
	    {hi:{help classman##class_context:2.3 Class context}}
	{hi:{help classman##version_control:3. Version control}}
	{hi:{help classman##member_variables:4. Member variables}}
	    {hi:{help classman##types:4.1 Types}}
	    {hi:{help classman##default_initialization:4.2 Default initialization}}
     	    {hi:{help classman##specifying_initialization:4.3 Specifying initialization}}
    	    {hi:{help classman##specifying_initialization2:4.4 Specifying initialization 2, .new}}
	    {hi:{help classman##alternative_way_of_declaring:4.5 Another way of declaring}}
	    {hi:{help classman##scope:4.6 Scope}}
	    {hi:{help classman##adding_dynamically:4.7 Adding dynamically}}
    	    {hi:{help classman##specifying_initialization3:4.8 Advanced initialization, .oncopy}}
    	    {hi:{help classman##destructors:4.9 Advanced cleanup, destructors}}
	{hi:{help classman##inheritance:5. Inheritance}}
	{hi:{help classman##member_programs:6. Member programs' return values}}
	{hi:{help classman##assignment:7. Assignment}}
	    {hi:{help classman##type_matching:7.1 Type matching}}
	    {hi:{help classman##arrays:7.2 Arrays and array elements}}
	    {hi:{help classman##lvalues_and_rvalues:7.3 lvalues and rvalues}}
	    {hi:{help classman##assignment_of_reference:7.4 Assignment of reference}}
	{hi:{help classman##built-ins:8. Built-ins}}
	    {hi:{help classman##built-in_functions:8.1 Built-in functions}}
	    {hi:{help classman##built-in_modifiers:8.2 Built-in modifiers}}
	{hi:{help classman##prefix_operators:9. Prefix operators}}
	{hi:{help classman##using_object_values:10. Using object values}}
	{hi:{help classman##object_destruction:11. Object destruction}}
	{hi:{help classman##advanced_topics:12. Advanced topics}}
	    {hi:{help classman##keys:12.1 Keys}}
	    {hi:{help classman##unames:12.2 Unames}}
	    {hi:{help classman##arrays_of_member_variables:12.3 Arrays of member variables}}
	{hi:Appendix A:  {help classman##appendix_a:Finding, loading, and clearing class definitions}}
	{hi:Appendix B:  {help classman##jargon:Jargon}}
	{hi:Appendix C:  {help classman##syntax:Syntax diagrams}}
	    {hi:Appendix C.1:  {help classdeclare:Class declaration}}
	    {hi:Appendix C.2:  {help classassign:Assignment}}
	    {hi:Appendix C.3:  {help classmacro:Macro substitution}}
	    {hi:Appendix C.4:  {help classbi:Quick summary of built-ins}}


{marker introduction}{...}
{title:1. Introduction}

{pstd}
A {it:class} is a collection of (1) member variables and (2) member programs.
The member programs of a class manipulate or make calculations based on the
member variables.  Classes are defined in {cmd:.class} files.  For
instance, we might define the class {cmd:coordinate} in the file
{cmd:coordinate.class}:

	{hline 33} begin {cmd:coordinate.class} {hline}
	{cmd}version {ccl stata_version}
	class coordinate {
			 double	x
			 double	y
	}
	program .set
			 args x y
			 .x = `x'
			 .y = `y'
	end{txt}
	{hline 33} end {cmd:coordinate.class} {hline}

{pstd}
The above file does not create anything.  It merely defines the concept of a
"coordinate".  Now that the file exists, you could create a "scalar" variable
of type {cmd:coordinate} by typing

	{cmd:.coord = .coordinate.new}

{pstd}
{cmd:.coord} is called an {it:instance} of {cmd:coordinate}; it contains
{cmd:.coord.x} (a particular x coordinate) and {cmd:.coord.y} (a particular y
coordinate).  Because we did not specify otherwise, {cmd:.coord.x} and
{cmd:.coord.y} contain missing values, but we could reset {cmd:.coord} to
contain (1,2) by typing

	{cmd}.coord.x = 1
	.coord.y = 2{txt}

{pstd}
In this case, we can do that more conveniently by typing

	{cmd:.coord.set 1 2}

{pstd}
because {cmd:.coordinate.class} contains a member program called {cmd:.set}
that allows us to set the member variables.  There is nothing especially
useful about {cmd:.set}; we wrote it mainly to emphasize that classes could,
in fact, contain member programs.  Our {cmd:coordinate.class} definition would
be nearly as good if we deleted the {cmd:.set} program.  Classes are not
required to have member functions, but they may.

{pstd}
If we typed

	{cmd}.coord2 = .coordinate.new
	.coord2.set 2 4{txt}

{pstd}
we would now have a second instance of a {cmd:coordinate}, this one named
{cmd:.coord2}, and it would contain (2,4).

{pstd}
Now consider another class, {cmd:line.class}:

	{hline 33} begin {cmd:line.class} {hline}
	{cmd}version {ccl stata_version}
	class line {
		coordinate c0
		coordinate c1
	}
	program .set
		args x0 y0 x1 y1
		.c0.set `x0' `y0'
		.c1.set `x1' `y1'
	end
	program .length
		class exit sqrt((`.c0.y'-`.c1.y')^2 + (`.c0.x'-`.c1.x')^2)
	end
	program .midpoint
		local cx = (`.c0.x' + `.c1.x')/2
		local cy = (`.c0.y' + `.c1.y')/2
		tempname b
		.`b'=.coordinate.new
		.`b'.set `cx' `cy'
		class exit .`b'
		end{txt}
	{hline 33} end {cmd:line.class} {hline}

{pstd}
Like {cmd:coordinate.class}, {cmd:line.class} has two member 
variables -- they are named {cmd:.c0} and {cmd:.c1} -- but rather
than being numbers, {cmd:.c0} and {cmd:.c1} are {cmd:coordinate}s as we have
previously defined the term.  Thus the full list of the member variables for
{cmd:line.class} is

	{cmd:.c0}         first {cmd:coordinate}
	{cmd:.c0.x}       x value (a {cmd:double})
	{cmd:.c0.y}       y value (a {cmd:double})
	{cmd:.c1}         second {cmd:coordinate}
	{cmd:.c1.x}       x value (a {cmd:double})
	{cmd:.c1.y}       y value (a {cmd:double})

{pstd}
If we typed

	{cmd:.li = .line.new}

{pstd}
we would have a {cmd:line} named {cmd:.li} in which

	{cmd:.li.c0}      first {cmd:coordinate} of {cmd:line} {cmd:.li}
	{cmd:.li.c0.x}    x value (a {cmd:double})
	{cmd:.li.c0.y}    y value (a {cmd:double})
	{cmd:.li.c1}      second {cmd:coordinate} of {cmd:line} {cmd:.li}
	{cmd:.li.c1.x}    x value (a {cmd:double})
	{cmd:.li.c1.y}    y value (a {cmd:double})

{pstd}
What are the values of these variables?  Because we did not specify otherwise,
{cmd:.li.c0} and {cmd:.li.c1} will receive default values for their type,
{cmd:coordinate}.  That default is (.,.) because we did not specify otherwise
when we defined {cmd:line}s or {cmd:coordinate}s.  Therefore, the default values
are (.,.) and (.,.) and we have a missing line.

{pstd}
As with {cmd:coordinate}, we included the member function {cmd:.set} to make
setting the line easier.  We can type

	{cmd:.li.set 1 2 2 4}

{pstd}
and we will have a line going from (1,2) to (2,4).

{pstd}
{cmd:line.class} contains the following member programs:

	{cmd:.set}        program to set {cmd:.c0} and {cmd:.c1}
	{cmd:.c0.set}     program to set {cmd:.c0}
	{cmd:.c1.set}     program to set {cmd:.c1}
	{cmd:.length}     program to return length of line
	{cmd:.midpoint}   program to return {cmd:coordinate} of midpoint of line

{pstd}
{cmd:.set}, {cmd:.length}, and {cmd:.midpoint} came from {cmd:line.class}.
{cmd:.c0.set} and {cmd:.c1.set} came from {cmd:coordinate.class}.

{pstd}
Member program {cmd:.length} returns the length of a line.

	{cmd:.len = .li.length}

{pstd}
would create {cmd:.len} containing the result of {cmd:.li.length}, the
result of running the program {cmd:.length} on the object {cmd:.li}.
{cmd:.length} returns a {cmd:double}, and therefore, {cmd:.len} will be
{cmd:double}.

{pstd}
{cmd:.midpoint} returns the midpoint of a line.

	{cmd:.mid = .li.midpoint}

{pstd}
would create {cmd:.mid} containing the result of {cmd:.li.midpoint}.  The
result of running the program {cmd:.midpoint} on the object {cmd:.li}.
{cmd:.midpoint} returns a {cmd:coordinate}, and therefore, {cmd:.mid} will be
a {cmd:coordinate}.


{marker definitions}{...}
{title:2. Definitions}

{marker class_definition}{...}
{title:2.1 Class definition}

{pstd}
Class {it:classname} is defined in file {it:classname}{cmd:.class}.  The
definition does not create any instances of the class.

{pstd}
The {it:classname}{cmd:.class} file has three parts:

	{hline 33} begin {it:classname}{cmd:.class} {hline}
	{cmd:version} ...           // Part 1:  version statement
	{cmd:class} {it:classname} {cmd:{c -(}}     // Part 2:  declaration of member variables
			...
	{cmd:{c )-}}
	{cmd:program} ...           // Part 3:  code for member programs
			...
	{cmd:end}
	{cmd:program} ...
		...
	{cmd:end}
	...
	{hline 33} end {it:classname}{cmd:.class} {hline}


{marker class_instance}{...}
{title:2.2 Class instance}

{pstd}
To create a "variable" {it:name} of type {it:classname}, you type

	{cmd:.}{it:name} {cmd:= .}{it:classname}{cmd:.new}

{pstd}
After that, {cmd:.}{it:name} is variously called an identifier, class
variable, class instance, object, object instance, or sometimes just an
instance.  Call it what you will, the above creates new 
{cmd:.}{it:name} -- or replaces existing
{cmd:.}{it:name} -- to contain the result of an application of the
definition of {it:classname}.  And, just as with any variable, you can have
many different variables with different names all of the same type.

{pstd}
{cmd:.}{it:name} is called a first-level or top-level identifier.
{cmd:.}{it:name1}{cmd:.}{it:name2} is called a second-level identifier, and so
on.  Assignment into top-level identifiers is allowed if (1) the identifier
does not already exist or (2) if the identifier exists and is of type
{it:classname}.  If the top-level identifier already exists and is of a
different type, you must drop the identifier first and then re-create it; see
{hi:{help classman##object_destruction:Object destruction}}.

{pstd}
Consider the assignment

	{cmd:.}{it:name1}{cmd:.}{it:name2} {cmd:= .}{it:classname}{cmd:.new}

{pstd}
The above statement is allowed if {cmd:.}{it:name1} already exists and if
{cmd:.}{it:name2} is declared, in {cmd:.}{it:name1}'s class definition, to be of
type {it:classname}.  In that case, {cmd:.}{it:name1}{cmd:.}{it:name2}
previously contained a {it:classname} instance and now contains a
{it:classname} instance, the difference being that the old contents were
discarded and replaced with new ones.  The same rule applies to third-level
and higher identifiers.

{pstd}
Classes, and class instances, may also contain member programs.
Member programs are identified in the same way as class variables.
{cmd:.}{it:name1}{cmd:.}{it:name2} might refer to a member variable or to a
member program.


{marker class_context}{...}
{title:2.3 Class context}

{pstd}
When a class program executes, it executes in the context of the current
instance.  For example, consider the instance creation

	{cmd:.mycoord = .coordinate.new}

{pstd}
and recall that {cmd:coordinate.class} provides member program {cmd:.set},
which reads

	{cmd}program .set
			args x y
			.x = `x'
			.y = `y'
	end{txt}

{pstd}
Assume we type "{cmd:.mycoord.set 2 4}".  When {cmd:.set}
executes, it executes in the {it:context} of {cmd:.mycoord}.  In the program,
the references to {cmd:.x} and {cmd:.y} are assumed to be to {cmd:.mycoord.x}
and {cmd:.mycoord.y}.  If we typed "{cmd:.other.set}", the references would be
to {cmd:.other.x} and {cmd:.other.y}.

{pstd}
Look at the statement "{cmd:.x = `x'}" in {cmd:.set}.  Pretend that {cmd:`x'}
is {cmd:2} so that, after macro substitution, the statement reads 
"{cmd:.x = 2}".  Is this a statement that the first-level identifier {cmd:.x}
is to be set to 2?  No, it is a statement that
{cmd:.}{it:impliedcontext}{cmd:.x} is to be set to 2.  The same would be true
whether {cmd:.x} appeared to the right of the equal sign or anywhere else in
the program.

{pstd}
The rules for resolving things like {cmd:.x} and {cmd:.y} are actually more
complicated.  They are resolved to the implied context if they exist in the
implied context,  and otherwise they are interpreted to be in the global
context.  Hence, in the above examples, {cmd:.x} and {cmd:.y} were interpreted
as being references to {cmd:.}{it:impliedcontext}{cmd:.x} and
{cmd:.}{it:impliedcontext}{cmd:.y} because {cmd:.x} and {cmd:.y} existed in
{cmd:.}{it:impliedcontext}.  If, however, our program made a reference to
{cmd:.c}, that would be assumed to be in the global context (that is, to be
just {cmd:.c}) because there is no {cmd:.c} in the implied context.  This is
discussed at length in {hi:{help classman##prefix_operators: Prefix operators}}.

{pstd}
If a member program calls a regular program -- a regular 
ado-file -- that program will also run in the same class context; for
example, if {cmd:.set} included the lines

	{cmd}move_to_right
	.x = r(x)
	.y = r(y){txt}

{pstd}
and program {cmd:move_to_right.ado} had lines in it referring to {cmd:.x} and
{cmd:.y}, they would be interpreted as {cmd:.}{it:impliedcontext}{cmd:.x} and
{cmd:.}{it:impliedcontext}{cmd:.y}.

{pstd}
In all programs -- member programs or ado-files -- we can explicitly
control whether we want identifiers in the implied context or globally with
the {cmd:.Local} and {cmd:.Global} prefixes; see 
{hi:{help classman##prefix_operators:Prefix operators}}.


{marker version_control}{...}
{title:3. Version control}

{pstd}
The first thing that should appear in a {cmd:.class} file is a {cmd:version}
statement; see {manhelp version P}.  For instance, {cmd:coordinate.class}
reads

	{hline 33} begin {cmd:coordinate.class} {hline}
	{cmd}version {ccl stata_version}
	{txt}{it:[}{cmd:class} {it:statement defining member variables omitted]}{cmd}
	program .set
			args x y
			.x = `x'
			.y = `y'
	end{txt}
	{hline 33} end {cmd:coordinate.class} {hline}

{pstd}
The {cmd:version {ccl stata_version}} at the top of the file specifies not
only that, when the class definition is read, it be interpreted
according to version {ccl stata_version} syntax, but it also specifies that
when each of the member programs run, it be interpreted according to
version {ccl stata_version}.  Thus you do not need to include a {cmd:version}
statement inside the definition of each member program, although you may
if you want that one program to run according to the syntax of a different
version of Stata.

{pstd}
Including the {cmd:version} statement at the top is of vital importance.
Stata is under continual development, and so is the class subsystem.  Syntax
and features can change.  Including the {cmd:version} command ensures that
your class will continue to work as you intended.


{marker member_variables}{...}
{title:4. Member variables}

{marker types}{...}
{title:4.1 Types}

{pstd}
The second thing that appears in a {cmd:.class} file is the definition of
the member variables.  We have seen two examples,

	{hline 33} begin {cmd:coordinate.class} {hline}
	{cmd}version {ccl stata_version}
	class coordinate {
			double	x
			double	y
	}
	{txt}{it:[member programs omitted]}
	{hline 33} end {cmd:coordinate.class} {hline}

{pstd}
and

	{hline 33} begin {cmd:line.class} {hline}
	{cmd}version {ccl stata_version}
	class line {
			coordinate c0
			coordinate c1
	}
	{txt}{it:[member programs omitted]}
	{hline 33} end {cmd:line.class} {hline}

{pstd}
In the first example, the member variables are {cmd:.x} and {cmd:.y}, and in
the second, {cmd:.c0} and {cmd:.c1}.  In the first example, the member
variables are of type {cmd:double}, and in the second of type
{cmd:coordinate}, another class.

{pstd}
The member variables may be of {it:type}

{synoptset 15 tabbed}{...}
{synopt :{cmd:double}}double precision scalar numeric value, which
includes missing values {cmd:.}, {cmd:.a}, ..., {cmd:.z}{p_end}

{synopt :{cmd:string}}scalar string value, with minimum length 0 ("")
and maximum length the same as for macros, which is to say, long{p_end}

{p2col 5 24 24 2:}The class {cmd:string} type is different
         from Stata's {cmd:str}{it:#} and {cmd:strL} types.  It can hold
         much longer string values than can the {cmd:str}{it:#} type, but
         not as long of string values as the {cmd:strL} type.  Additionally,
         unlike {cmd:strL}s, class {cmd:string}s cannot contain binary 0.

{synopt :{it:classname}}other classes excluding the class being defined{p_end}

{synopt :{cmd:array}}array containing any of the {it:types}, including
other {cmd:array}s{p_end}
{p2colreset}{...}

{pstd}
A class definition might read

	{hline 33} begin {cmd:todolist.class} {hline}
	{cmd}version {ccl stata_version}
	class todolist {
		       double  n            {txt:// no. of elements in list}
		       string  name         {txt:// who the list is for}
		       array   list         {txt:// the list itself}
		       actions x            {txt:// things that have been done}
	}{txt}
	{hline 33} end {cmd:todolist.class} {hline}

{pstd}
In the above, note that {cmd:actions} is a class, not a primitive type.
Somewhere else, we have written {cmd:actions.class}, which defines what we
mean by {cmd:actions}.

{pstd}
Note that {cmd:array}s are not typed when they are declared.  An {cmd:array}
is not an array of {cmd:double}s or an array of {cmd:string}s or an array of
{cmd:coordinate}s; rather, each array element is separately typed at run time,
so an array may turn out to be an array of {cmd:double}s or an array of
{cmd:strings} or array of {cmd:coordinate}s, or it may turn out that its first
element is a {cmd:double}, its second element a {cmd:string}, its third
element a {cmd:coordinate}, its fourth element something else, and so on.

{pstd}
Similarly, {cmd:array}s are not declared to be of a predetermined size.  The
size is automatically determined at run time according to how the array is
used.  In addition, arrays can be sparse.  The first element of an array might
be a {cmd:double}, its fourth element a {cmd:coordinate}, and its second and
third elements left undefined.  There is no inefficiency associated with this.
Later, a value might be assigned to the fifth element of the array, thus
extending it, or a value might be assigned to the second and third elements,
thus filling in the gaps.


{marker default_initialization}{...}
{title:4.2 Default initialization}

{pstd}
When an instance of a class is created, the member variables are filled
in as follows:

	{cmd:double}      .  (missing value)
	{cmd:string}      ""
	{it:classname}   as specified by class definition
	{cmd:array}       empty, an array with no elements yet defined


{marker specifying_initialization}{...}
{title:4.3 Specifying initialization}

{pstd}
You may specify in {it:classname}{cmd:.class} the initial values for member
variables.   To do this, you type an equal sign after the identifier, and
then you type the initial value.  For example,

	{hline 33} begin {cmd:todolist.class} {hline}
	{cmd}version {ccl stata_version}
	class todolist {
			double  n    = 0
			string  name = "nobody"
			array   list = {"show second syntax", "mark as done"}
			actions x    = .actions.new {txt:{it:arguments}}
	}{txt}
	{hline 33} end {cmd:todolist.class} {hline}

{pstd}
The initialization rules are as follows:

{phang2}
{cmd:double} {it:membervarname} = ...{break}
After the equal sign, you may type any number or expression.  To initialize
the member variable with missing value ({cmd:.}, {cmd:.a}, {cmd:.b}, ...,
{cmd:.z}), you must enclose the missing value in parentheses.  Examples
include

{pmore3}
{cmd:double n = 0}{break}
{cmd:double a = (.)}{break}
{cmd:double b = (.b)}{break}
{cmd:double z = (2+3)/sqrt(5)}

{pmore2}
Alternatively, after the equal sign, you may specify the identifier of a
member variable to be copied or program to be run as long as the member
variable is a {cmd:double} or the program returns a {cmd:double}.  If a member
program is specified that requires arguments, they must be specified following
the identifier.  Examples include,

{pmore3}
{cmd:double n = .clearcount}{break}
{cmd:double a = .gammavalue 4 5 2}{break}
{cmd:double b = .color.cvalue, color(green)}

{pmore2}
The identifiers are interpreted in terms of the global context, not the
class context being defined.  Thus, {cmd:.clearcount}, {cmd:.gammavalue}, and
{cmd:.color.cvalue} must exist in the global context.

{phang2}
{cmd:string} {it:membervarname} = ...{break}
    After the equal sign, you type the initial value for the member variable
    enclosed in quotes, which may be either simple
    ({cmd:"} and {cmd:"}) or compound ({cmd:`"} and {cmd:"'}).
    Examples include,

{pmore3}
{cmd:string name = "nobody"}{break}
{cmd:string s = `"quotes "inside" strings"'}{break}
{cmd:string a = ""}

{pmore2}
You may also specify a string expression, but you must enclose it in
parentheses.

{pmore3}
{cmd:string name = ("no" + "body")}{break}
{cmd:string b    = (char(11))}

{pmore2}
Or you may specify the identifier of a member variable to be
copied or member program to be run, as long as the member variable is a
{cmd:string} or the program returns a {cmd:string}.  If a member program is
specified that requires arguments, they must be specified following the
identifier.  Examples include

{pmore3}
{cmd:string n = .defaultname}{break}
{cmd:string a = .recapitalize "john smith"}{break}
{cmd:string b = .names.defaults, category(null)}

{pmore2}
The identifiers are interpreted in terms of the global context, not the
class context being defined.  Thus, {cmd:.defaultname}, {cmd:.recapitalize},
and {cmd:.names.defaults} must exist in the global context.

{phang2}
{cmd:array} {it:membervarname} = {cmd:{c -(}} ... {cmd:{c )-}}{break}
    After the equal sign, you type the set of elements in braces ({cmd:{c -(}}
    and {cmd:{c )-}}), with each element separated from the next by a comma.

{pmore2}
    If an element is enclosed in quotes (simple or compound), the
    corresponding array element is defined to be {cmd:string} with the
    contents specified.

{pmore2}
    If an element is a literal number excluding {cmd:.}, {cmd:.a}, ...,
    {cmd:.z}, the corresponding array element is defined to be {cmd:double}
    and filled in with the number specified.

{pmore2}
    If an element is enclosed in parentheses, what appears inside the
    parentheses is evaluated as an expression.  If the expression evaluates to
    a string, the corresponding array element is defined to be {cmd:string}
    and the result filled in.  If the expression evaluates to a number, the
    corresponding array element is defined to be {cmd:double} and the result
    filled in.  Missing values may be assigned to array elements by being
    enclosed in parentheses.

{pmore2}
    An element that begins with a period is interpreted as an object
    identifier in the global context.  That object may be a member variable or
    member program.  The corresponding array element is defined to be of the
    same type as the specified member variable or of the same type as the
    member program returns.  If a member program is specified that requires
    arguments, the arguments may be specified following the identifier, but
    the entire syntactical elements must be enclosed in square brackets
    ({cmd:[} and {cmd:]}).

{pmore2}
    If the element is nothing, the corresponding array element is left
    undefined.

{pmore2}
    Examples include

{pmore3}
    {cmd:array mixed = {c -(}1, 2, "three", 4{c )-}}{break}
    {cmd:array els   = {c -(}.box.new, , .table.new{c )-}}{break}
    {cmd:array rad   = {c -(}[.box.new 2 3], , .table.new{c )-}}

{pmore2}
    Note the double commas in the last two initializations.
    The second element is left undefined.  Some programmers
    would code

{pmore3}
    {cmd:array els   = {c -(}.box.new, /*nothing*/, .table.new{c )-}}{break}
    {cmd:array rad   = {c -(}[.box.new 2 3], /*nothing*/, .table.new{c )-}}

{pmore2}
    to emphasize the null initialization.


{phang2}
{it:classname membervarname} {cmd:=} ...{break}
After the equal sign, you specify the identifier of a member variable to be
copied or member program to be run, as long as the member variable is of type
{it:classname} or the member program returns something of type {it:classname}.
If a member program is specified that requires arguments, they must be
specified following the identifier.  In either case, the identifier will be
interpreted in the global context.  Examples include

{pmore3}
    {cmd:box mybox1 = .box.new}{break}
    {cmd:box mybox2 = .box.new 2 4 7 8, tilted}

{pstd}
All the types can be initialized by copying other member variables
or by running other member programs.  These other member variables and member
programs must be defined in the global context and not the class context.  In
such cases, each initialization value or program is, in fact, copied or run only
once -- at the time the class definition is read -- and the values
are recorded for future use.  This makes initialization fast.  This also
means, however, that

{phang2}
1.  If, in a class definition called, say, {cmd:border.class}, you defined 
    a member variable that was initialized by {cmd:.box.new}, and if
    {cmd:.box.new} counted how many times it is run, even if you were to
    create 1,000 instances of {cmd:border}, you would discover that
    {cmd:.box.new} was run only once.  If {cmd:.box.new} changed what it
    returned over time (perhaps due to a change in some state of the system
    being implemented), the initial values would not change when a new border
    object was created.

{phang2}
2.  If, in {cmd:border.class}, you were to define a member variable that
    is initialized as {cmd:.system.curvals.no_of_widgets}, which we will
    assume is another member variable, even if
    {cmd:.system.curvals.no_of_widgets} were changed, the new instances of
    {cmd:border.class} would always have the same value -- the value of
    {cmd:.system.curvals.no_of_widgets} current at the time {cmd:border.class}
    was read.

{pstd}
In both of the above examples, the method just described -- the prerecorded
assignment method of specifying initial values -- would be inadequate.  The
method just described is suitable for specifying constant initial values only.


{marker specifying_initialization2}{...}
{title:4.4 Specifying initialization 2, .new}

{pstd}
An alternative way to specify how member variables are to be initialized is
to define a {cmd:.new} program within the class.

{pstd}
To create a new instance of a class, you type

	{cmd:.}{it:name} {cmd:= .}{it:classname}{cmd:.new}

{pstd}
{cmd:.new} is, in fact, a member program of {it:classname}, it is just one
that is built in, and you do not have to define it to use it.  The
built-in {cmd:.new} allocates the memory for the instance and fills in the
default or specified initial values for the member variables.  If you define a
{cmd:.new}, your {cmd:.new} will be run after the built-in {cmd:.new} finishes
its work.

{pstd}
For example, our example {cmd:coordinate.class} could be improved by adding a
{cmd:.new} member program:

	{hline 33} begin {cmd:coordinate.class} {hline}
	{cmd}version {ccl stata_version}
	class coordinate {
			double	x
			double	y
	}

	program .new
			if "`0'" != "" {
				.set `0'
			}
	end

	program .set
			args x y
			.x = `x'
			.y = `y'
	end{txt}
	{hline 33} end {cmd:coordinate.class} {hline}

{pstd}
With this addition, we could type

	{cmd:.coord = .coordinate.new}
	{cmd:.coord.set 2 4}

{pstd}
or we could type

	{cmd:.coord = .coordinate.new 2 4}

{pstd}
We have arranged {cmd:.new} to take arguments -- optional ones here --
that specify where the new point is to be located.  We wrote the code so that
{cmd:.new} calls {cmd:.set}, although we could just as well have written the
code so that the lines in {cmd:.set} appeared in {cmd:.new} and then deleted
the {cmd:.set} program.  In fact, the two-part construction can be desirable
because then we have a function that will reset the contents of an existing
class as well.

{pstd}
In any case, by defining your own {cmd:.new}, you can arrange for any sort of
complicated initialization of the class, and that initialization can be a
function of arguments specified if that is necessary.

{pstd}
The {cmd:.new} program need not return anything; see
{hi:{help classman##member_programs:Member programs' return values}}.

{pstd}
{cmd:.new} programs are not restricted just to filling in initial values.
They are programs that you can code however you wish; {cmd:.new} is run every
time a new instance of a class is created with one exception:  when an
instance is created as a member of another instance (in which case, the
results are prerecorded).


{marker alternative_way_of_declaring}{...}
{title:4.5 Another way of declaring}

{pstd}
In addition to the syntax,

	{it:type} {it:name} [{cmd:=} {it:initialization}]

{pstd}
where {it:type} is one of {cmd:double}, {cmd:string}, {it:classname}, or
{cmd:array}, there is an alternate syntax that reads

	{it:name} {cmd:=} {it:initialization}

{pstd}
That is, you may omit specifying {it:type} when you specify how the member
variable is to be initialized because, then the type of the member
variable can be inferred from the initialization.


{marker scope}{...}
{title:4.6 Scope}

{pstd}
In the examples we have seen so far, the member variables are unique
to the instance.  For instance, if we have

	{cmd:.coord1 = .coordinate.new}
	{cmd:.coord2 = .coordinate.new}

{pstd}
the member variables of {cmd:.coord1} have nothing to do with the member
variables of {cmd:.coord2}.  If we were to change {cmd:.coord1.x},
{cmd:.coord2.x} would remain unchanged.

{pstd}
Classes can also have variables that are shared across all instances of the
class.  Consider

	{hline 33} begin {cmd:coordinate2.class} {hline}
	{cmd}version {ccl stata_version}
	class coordinate2 {
			classwide:
				double x_origin = 0
				double y_origin = 0
			instancespecific:
				double x = 0
				double y = 0
	}
	{txt}{hline 33} end {cmd:coordinate2.class} {hline}

{pstd}
In this class definition, {cmd:.x} and {cmd:.y} are as they were in
{cmd:coordinate.class} -- they are unique to the instance.  {cmd:.x_origin}
and {cmd:.y_origin}, however, are shared across all instances of the class.
That is, if we were to type

	{cmd:.ac = .coordinate2.new}
	{cmd:.bc = .coordinate2.new}

{pstd}
there would be only one copy of {cmd:.x_origin} and of {cmd:.y_origin}.
If we changed {cmd:.x_origin} in {cmd:.ac},

	{cmd:.ac.x_origin = 2}

{pstd}
we would find that {cmd:.bc.x_origin} had similarly been changed.  That is
because {cmd:.ac.x_origin} and {cmd:.bc.x_origin} are, in fact, the same
variable.

{pstd}
The effects of initialization are a little different for classwide
variables.  In {cmd:coordinate2.class}, we specified that {cmd:.origin_x} and
{cmd:.origin_y} both be initialized as 0, and so they were when we
typed "{cmd:.ac = .coordinate2.new}", creating the first instance of the
class.  After that, however, {cmd:.origin_x} and {cmd:.origin_y} will never be
reinitialized because they need not be re-created, being shared.  (That is
not exactly accurate because, once the last instance of a {cmd:coordinate2}
has been destroyed, the variables will need to be reinitialized the next time
a new first instance of {cmd:coordinate2} is created.)

{pstd}
Classwide variables, just as with instance-specific variables, can be of any
type.  We can define

	{hline 33} begin {cmd:supercoordinate.class} {hline}
	{cmd}version {ccl stata_version}
	class supercoordinate {
			classwide:
				coordinate  origin
			instancespecific:
				coordinate  pt
	}
	{txt}{hline 33} end {cmd:supercoordinate.class} {hline}

{pstd}
The qualifiers {cmd:classwide:}{space 1}and {cmd:instancespecific:}{space 1}are 
used to designate the scope of the member variables that follow.  When neither
is specified, {cmd:instancespecific:}{space 1}is assumed.


{marker adding_dynamically}{...}
{title:4.7 Adding dynamically}

{pstd}
Once an instance of a class exists, you can add new (instance-specific) member
variables to it.  The syntax for doing this is

	{it:name} {cmd:.Declare} {it:attribute_declaration}

{pstd}
where {it:name} is the identifier of an instance and {it:attribute_declaration}
is any valid attribute declaration such as

	{cmd:double}      {it:varname}
	{cmd:string}      {it:varname}
	{cmd:array}        {it:varname}
	{it:classname}   {it:varname}

{pstd}
and, on top of that, we can include {cmd:=} and initializer information
as defined in 
{hi:{help classman##specifying_initialization:Specifying initialization}} above.

{pstd}
For example, we might start with

	{cmd:.coord = .coordinate.new}

{pstd}
and discover that there is some extra information that we would like to carry
around with the particular instance {cmd:.coord}.  Here we want to
carry around some color information which we will use later, and we have at
our fingertips {cmd:color.class}, which defines what we mean by {cmd:color}.
We can type

	{cmd:.coord.Declare color mycolor}

{pstd}
or even

	{cmd:.coord.Declare color mycolor = .color.new, color(default)}

{pstd}
to cause the new class instance to be initialized the way we want.  After that
command, {cmd:.coord} now contains {cmd:.coord.color} and whatever
third-or-higher level identifiers {cmd:color} provides.  We can still
invoke the member programs of {cmd:coordinate} on {cmd:.coord}, and to them,
{cmd:coord} will look just like a {cmd:coordinate} because they will know
nothing about the extra information (although if they were to make a copy of
{cmd:.coord}, the copy would include the extra information).  We can use the
extra information in our main program and even in subroutines that we write.

{p 8 8 6}
{it:Technical note:}
Just as with declaration of member variables inside the {cmd:class}
{cmd:{c -(} {c )-}} statement, you can omit specifying the {it:type}
when you specify the initialization.  In the above, the following would also
be allowed: 

{pmore2}
{cmd:.coord.Declare mycolor = .color.new, color(default)}


{marker specifying_initialization3}{...}
{title:4.8 Advanced initialization, .oncopy}

{pstd}
Advanced initialization is an advanced concept, and we need concern ourselves
with it only when our class is storing references to items outside the class
system.  In such cases, the class system knows nothing about these items
other than their names.  We must manage the contents of these items.

{pstd}
Assume that our coordinates class was storing not scalar coordinates but
rather the names of Stata variables that contained coordinates.  When we
create a copy of such a class,

	{cmd:.coord = .coordinate.new 2 4}
	{cmd:.coordcopy = .coord}

{pstd}
{cmd:.coordcopy} will contain copies of the names of the variables holding the
coordinates, but the variables themselves will not be copied.  To be
consistent with how all other objects are treated, we may prefer that the
contents of the variables be copied to new variables.

{pstd}
As with {cmd:.new} we can define an {cmd:.oncopy} member program that will be
run after the default copy operation has been completed.  We will probably need
to refer to the source object of the copy with the built-in
{cmd:.oncopy_src}, which returns a key to the source object.

{pstd}
Let's write the beginnings of a coordinate class that uses Stata variables to
store vectors of coordinates.

	{hline 33} begin {cmd:varcoordinate.class} {hline}
	{cmd}version {ccl stata_version}
	class varcoordinate {
		classwide:
			n = 0

		instancespecific:
			string	x
			string	y
	}

	program .new
			.nextnames
			if "`0'" != "" {
				.set `0'
			}
	end

	program .set
			args x y
			replace `.x' = `x'
			replace `.y' = `y'
	end

	program .nextnames
			.n = `.n' + 1
			.x = "__varcorrd_vname_`.n'"
			.n = `.n' + 1
			.y = "__varcorrd_vname_`.n'"

			gen `.x' = .
			gen `.y' = .
	end

	program .oncopy
		.nextnames
		.set `.`.oncopy_src'.x' `.`.oncopy_src'.y'
	end{txt}
	{hline 33} end {cmd:varcoordinate.class} {hline}


{pstd}
This class is more complicated than what we have seen before.  We are
going to use our own unique variable names to store the x- and y-coordinate
variables.  To ensure that we do not try to reuse the same name, we number
these variables by using the classwide counting variable {cmd:.n}.  Every time
a new instance is created, unique x- and y-coordinate variables are created
and filled in with missing.  This work is done by {cmd:.nextnames}.

{pstd}
The {cmd:.set} looks similar to the one from {cmd:.varcoordinates} except that
now we are holding variable names in {cmd:`.x'} and {cmd:`.y'}, and we use
{cmd:replace} to store the values from the specified variables into our
coordinate variables.

{pstd}
The {cmd:.oncopy} member function creates unique names to hold the variables,
using {cmd:.nextnames}, and then copies the contents of the coordinate variables
from the source object, using {cmd:.set}.

{pstd}
Now, when we type

	{cmd:.coordcopy = .coord},

{pstd}
the x- and y-coordinate variables in {cmd:.coordcopy} will be different
variables from those in {cmd:.coord} with copies of their values.

{pstd}
The {cmd:varcoordinate} class doesn't yet do anything interesting, and
other than the example in the following section, we will not develop it
further.


{marker destructors}{...}
{title:4.9 Advanced cleanup, destructors}

{pstd}
We rarely need to concern ourselves with objects being removed when they are
deleted or replaced.  

{pstd}
When we type

	{cmd:.a = .}{it:classname}{cmd:.new}
	{cmd:.b = .}{it:classname}{cmd:.new}
	{cmd:.a = .b}

{pstd}
The last command causes the original object {cmd:.a} to be destroyed and
replaces it with {cmd:.b}.  The class system handles this task, which is
usually all we want done.  An exception is objects that are holding onto
items outside the class system, such as the coordinate variables in our
{cmd:destructor} class.

{pstd}
When we need to perform actions before the system deletes an object, we
write a {cmd:.destructor} member program in the class file.  The
{cmd:.destructor} for our {cmd:varcoordinate} class is particularly simple; it
drops the coordinate variables.

	{hline 30} {cmd:varcoordinate.class} -- {cmd:.destructor} {hline}
	{cmd}program .destructor
			capture drop `.x'
			capture drop `.y'
	end{txt}
	{hline 30} {cmd:varcoordinate.class} -- {cmd:.destructor} {hline}


{marker inheritance}{...}
{title:5. Inheritance}

{pstd}
One class definition can inherit from other class definitions.  This is done
by including the {cmd:inherit(}{it:classnamelist}{cmd:)} option:

	{hline 33} begin {it:newclassname}{cmd:.class} {hline}
	{cmd}version {ccl stata_version}
	class {txt:{it:newclassname}} {
			{txt:...}
	}, inherit({txt:{it:classnamelist}})
	program {txt:...}
			{txt:...}
	end
	{txt}...
	{hline 33} end {it:newclassname}{cmd:.class} {hline}

{pstd}
{it:newclassname} inherits the member variables and member programs from
{it:classnamelist}.  In general, {it:classnamelist} contains one
class name.  When {it:classnamelist} contains more than one class name,
that is called multiple inheritance.

{pstd}
To be precise, {it:newclassname} inherits all the member variables from the
classes specified except those that are explicitly defined in
{it:newclassname}, in which case the definition provided in
{it:newclassname}{cmd:.class} takes precedence.  It is considered bad style to
name member variables that conflict.

{pstd}
For multiple inheritance, it is possible that, while a member
variable is not defined in {it:newclassname}, it is defined in more than one
of the "parents" ({it:classnamelist}).  Then it will be the
definition in the rightmost parent that is operative.  This too is to be
avoided, because it almost always results in programs' breaking.

{pstd}
{it:newclassname} also inherits all the member programs from the classes
specified.  Here name conflicts are not considered bad style, and, in fact,
redefinition of member programs is one of the primary reasons to use
inheritance.

{pstd}
{it:newclassname} inherits all the programs from {it:classnamelist} -- even
those with names in common -- and a way is provided to specify which of
the programs you wish to run.  In the case of single inheritance, if member
program {cmd:.zifl} is defined in both classes, {cmd:.zifl} is taken as the
instruction to run {cmd:.zifl} as defined in {it:newclassname}, and
{cmd:.Super.zifl} is taken as the instruction to run {cmd:.zifl} as defined in
the parent.

{pstd}
In the case of multiple inheritance, {cmd:.zifl} is taken as the instruction
to run {cmd:.zifl} as defined in {it:newclassname} and
{cmd:.Super(}{it:classname}{cmd:).zifl} is taken as the instruction to run
{cmd:.zifl} as defined in the parent {it:classname}.

{pstd}
A good reason to use inheritance is to "steal" a class and to modify it to suit
your purposes.  Pretend that you have {cmd:alreadyexists.class} and from that
you want to make {cmd:alternative.class}, something that is much like
{cmd:alreadyexists.class} -- so much like it that it could be used
wherever {cmd:alreadyexists.class} is used -- but it does one thing a
little differently.  Perhaps you are writing a graphics system, and
{cmd:alreadyexists.class} defines everything about the circles used to
mark points on a graph, and now you want to create {cmd:alternate.class} that
does the same, but this time for little solid circles.  Hence, there is only
one member program of {cmd:alreadyexists.class} that you want to change:  how
to draw the symbol.

{pstd}
In any case, we will assume that {cmd:alternative.class} is to be identical
to {cmd:alreadyexists.class} except that it has changed or improved
member function {cmd:.zifl}.  In such a circumstance, it would not be
uncommon to create

	{hline 33} begin {cmd:alternative.class} {hline}
	{cmd}version {ccl stata_version}
	class alternative {
	}, inherit(alreadyexists)
	program .zifl
			{txt:...}
	end
	{txt}{hline 33} end {cmd:alternative.class} {hline}

{pstd}
Moreover, in writing {cmd:.zifl}, you might well call {cmd:.Super.zifl}
so that the old {cmd:.zifl} performed its tasks, and all you had to do was code
what was extra (filling in the circles, say).  In the example above, we added
no member variables to the class.

{pstd}
Perhaps the new {cmd:.zifl} needs a new member variable -- a 
{cmd:double} -- and let us call it {cmd:.sizeofresult}.  Then we
might code

	{hline 33} begin {cmd:alternative.class} {hline}
	{cmd}version {ccl stata_version}
	class alternative {
			double   sizeofresult
	}, inherit(alreadyexists)
	program .zifl
			{txt:...}
	end
	{txt}{hline 33} end {cmd:alternative.class} {hline}

{pstd}
Now let's consider initialization of the new variable {cmd:.sizeofresult}.
Perhaps having it initialized as missing is adequate.  Then our code
above is adequate.  Suppose that we want to initialize it to 5.  Then we
could include an initializer statement.  Perhaps we need something more
complicated that must be handled in a {cmd:.new}.  In this final case,
we must call the inherited classes' {cmd:.new}
programs using the {cmd:.Super} modifier:

	{hline 33} begin {cmd:alternative.class} {hline}
	{cmd}version {ccl stata_version}
	class alternative {
			double   sizeofresult
	}, inherit(alreadyexists)
	program .new
			{txt:...}
			.Super.new
			{txt:...}
	end

	program .zifl
			{txt:...}
	end
	{txt}{hline 33} end {cmd:alternative.class} {hline}


{marker member_programs}{...}
{title:6. Member programs' return values}

{pstd}
Member programs may optionally return "values", and those can be
{cmd:double}s, {cmd:string}s, {cmd:array}s, or class instances.  These return
values can be used in assignment, and thus you can code

	{cmd:.len    = .li.length}
	{cmd:.coord3 = .li.midpoint}

{pstd}
Just because a member program returns something, it does not mean it has to be
consumed.  The programs {cmd:.li.length} and {cmd:.li.midpoint} can still be
executed directly,

	{cmd:.li.length}
	{cmd:.li.midpoint}

{pstd}
and, then return value is ignored.  ({cmd:.midpoint} and
{cmd:.length} are member programs that we included in {cmd:line.class}.
{cmd:.length} returns a {cmd:double}, and {cmd:.midpoint} returns a
{cmd:coordinate}.)

{pstd}
You cause member programs to return values using the {cmd:class exit} command;
see {manhelp class_exit P:class exit}.

{pstd}
Do not confuse returned values with return codes, which all Stata programs
set, even member programs.  Member programs exit when they execute

	Condition                       Returned value    Return code
	{hline 64}
	{cmd:class exit} with arguments       as specified      0
	{cmd:class exit} without arguments    nothing           0
	{cmd:exit} without arguments          nothing           0
	{cmd:exit} with arguments             nothing           as specified
	{cmd:error}                           nothing           as specified
	command having error            nothing           as appropriate
	{hline 64}

{pstd}
Any of the preceding are valid ways of exiting a member program, although the
last is perhaps best avoided.  {cmd:class exit} without arguments has the same
effect as {cmd:exit} without arguments; it does not matter which you code.

{pstd}
If a member program returns nothing, the result is as if it returned
{cmd:string} containing {cmd:""} (nothing).

{pstd}
Member programs may, in addition, return values in {cmd:r()}, {cmd:e()},
and {cmd:s()}, just as can regular programs.  Using {cmd:class exit} to return
a class result does not prevent member programs from also being {cmd:r}-class,
{cmd:e}-class, or {cmd:s}-class.


{marker assignment}{...}
{title:7. Assignment}

{pstd}
Consider {cmd:.coord} defined

	{cmd:.coord = .coordinate.new}

{pstd}
That is an example of assignment.  A new instance of class {cmd:coordinate} is
created and assigned to {cmd:.coord}.  In the same way,

	{cmd:.coord2 = .coord}

{pstd}
is another example of assignment.  A copy of {cmd:.coord} is made and assigned
to {cmd:.coord2}.

{pstd}
Assignment is not allowed just with top-level names.  The following are also
valid examples of assignment:

	{cmd:.coord.x = 2}
	{cmd:.li.c0 = .coord}
	{cmd:.li.c0.x = 2+2}
	{cmd:.todo.name = "Jane Smith"}
	{cmd:.todo.n = 2}
	{cmd:.todo.list[1] = "Turn in report"}
	{cmd:.todo.list[2] = .li.c0}

{pstd}
In each case, what appears on the right is evaluated, and a copy is placed
into the specified place.  Assignment based on the returned value of a program
is also allowed, so the following are also valid:

	{cmd:.coord.x = .li.length}
	{cmd:.li.c0 = .li.midpoint}

{pstd}
{cmd:.length} and {cmd:.midpoint} are member programs of {cmd:line.class}, and
{cmd:.li} is an instance of {cmd:line}.  In the first example,
{cmd:.li.length} returns a {cmd:double} and that {cmd:double} is assigned to
{cmd:.coord.x}.  In the second example, {cmd:.li.midpoint} returns a
{cmd:coordinate}, and that {cmd:coordinate} is assigned to {cmd:.li.c0}.

{pstd}
Also allowed would be

	{cmd:.todo.list[3] = .color.cvalue, color(green)}
	{cmd:.todo.list = {"Turn in report", .li.c0, [.color.cvalue, color(green)]}}

{pstd}
In both examples, the result of running {cmd:.color.cvalue, color(green)}
is assigned to the third array element of {cmd:.todo.list}.


{marker type_matching}{...}
{title:7.1 Type matching}

{pstd}
All the examples above are valid because either (1) a new identifier is
being created or (2) the identifier previously existed and was of the same
type as the identifier being assigned.

{pstd}
For instance, the following would be invalid:

	{cmd:.newthing = 2}           // valid so far ...
	{cmd:.newthing = "new"}       // ... invalid

{pstd}
The first line is valid because {cmd:.newthing} did not previously exist.
After the first assignment, however, {cmd:.newthing} did exist and was of
type {cmd:double}.  That caused the second assignment to be invalid,
the error being "{err:type mismatch}"; r(109).

{pstd}
The following are also invalid:

	{cmd:.coord.x = .li.midpoint}
	{cmd:.li.c0 = .li.length}

{pstd}
They are invalid because {cmd:.li.midpoint} returns a {cmd:coordinate} and
{cmd:.coord.x} is a {cmd:double}, and because {cmd:.li.length} returns a
{cmd:double}, and {cmd:.li.c0} is a {cmd:coordinate}.


{marker arrays}{...}
{title:7.2 Arrays and array elements}

{pstd}
The statements

	{cmd:.todo.list[1] = "Turn in report"}
	{cmd:.todo.list[2] = .li.c0}
	{cmd:.todo.list[3] = ".color.cvalue, color(green)}

{pstd}
and

	{cmd:.todo.list = {"Turn in report", .li.c0, [.color.cvalue, color(green)]}}

{pstd}
do not have the same effect.  The first reassigns elements 1, 2, 3 and
leaves any other defined elements unchanged.  The second replaces the
entire array with an array that has only elements 1, 2, and 3 defined.

{pstd}
After an element has been assigned, it may be unassigned (cleared) using
{cmd:.Arrdropel}.  For instance, to unassign {cmd:.todo.list[1]}, you would
type

	{cmd:.todo.list[1].Arrdropel}

{pstd}
Clearing an element does not affect the other elements of the array.
In the above example, {cmd:.todo.list[2]} and {cmd:.todo.list[3]}
continue to exist.

{pstd}
New and existing elements may be assigned and reassigned freely, except that
if an array element already exists, it may be reassigned only to something of
the same type.  

	{cmd:.todo.list[2] = .coordinate[2]}

{pstd}
but

	{cmd:.todo.list[2] = "Clear the coordinate"}

{pstd}
would not be allowed because
{cmd:.todo.list[2]} is a {cmd:coordinate} and {cmd:"Clear the coordinate"}
is a {cmd:string}.
If you wish to reassign an array element to a different type, you
first drop the existing array element and then assign it.

	{cmd:.todo.list[2].Arrdropel}
	{cmd:.todo.list[2] = "Clear the coordinate"}


{marker lvalues_and_rvalues}{...}
{title:7.3 lvalues and rvalues}

{pstd}
Not withstanding everything that has been said, the syntax for assignment is

	{it:lvalue} {cmd:=} {it:rvalue}

{pstd}
{it:lvalue} stands for what may appear to the left of the equal sign,
and {it:rvalue} stands for what may appear to the right.

{pstd}
The syntax for specifying an {it:lvalue} is

	{cmd:.}{it:id}[{cmd:.}{it:id}[...]]

{pstd}
where {it:id} is either a {it:name} or {it:name}{cmd:[}{it:exp}{cmd:]},
the latter being the syntax for specifying an array element, and
{it:exp} must evaluate to a number; if {it:exp} evaluates to a noninteger
number, it is truncated.

{pstd}
Also an {it:lvalue} must be assignable, meaning that {it:lvalue} cannot
refer to a member program; that is, an {it:id} element of
{it:lvalue} cannot be a program name.  (In an {it:rvalue}, if a program
name is specified, it must be in the last {it:id}.)

{pstd}
The syntax for specifying an {it:rvalue} is any of the following

	{cmd:"}[{it:string}]{cmd:"}
	{cmd:`"}[{it:string}]{cmd:"'}
	{it:#}
	{it:exp}
	{cmd:(}{it:exp}{cmd:)}
	{cmd:.}{it:id}[{cmd:.}{it:id}[...]] [{it:program_arguments}]
	{cmd:{c -(}}{cmd:{c )-}}
	{cmd:{c -(}}{it:el}[{cmd:,}{it:el}[{cmd:,}...]]{cmd:{c )-}}

{pstd}
The last two syntaxes concern assignment to arrays and {it:el} may be

	{it:nothing}
	{cmd:"}[{it:string}]{cmd:"}
	{cmd:`"}[{it:string}]{cmd:"'}
	{it:#}
	{cmd:(}{it:exp}{cmd:)}
	{cmd:.}{it:id}[{cmd:.}{it:id}[...]]
	{cmd:[}{cmd:.}{it:id}[{cmd:.}{it:id}[...]] [{it:program_arguments}]{cmd:]}

{pstd}
Let us consider each of the syntaxes for an {it:rvalue} in turn:

{phang}
{cmd:"}[{it:string}]{cmd:"} and {cmd:`"}[{it:string}]{cmd:"'}{break}
    If the {it:rvalue} begins with a double quote (simple or compound),
    returned will be a {cmd:string} containing {it:string}.  {it:string}
    may be long -- up to the length of a macro.

{phang}
{it:#}{break}
    If the {it:rvalue} is a number excluding missing values {cmd:.}, {cmd:.a},
    ..., {cmd:.z}, returned will be a {cmd:double} equal to the number
    specified.

{phang}
{it:exp} and {cmd:(}{it:exp}{cmd:)}{break}
    If the {it:rvalue} is an expression, the expression will be evaluated
    and the result returned.  Returned will be a {cmd:double} if the
    expression returns a numeric result and a {cmd:string} if expression
    returns a string.  Expressions returning matrices are not allowed.

{p 8 8 2}
    The expression need not be enclosed in parentheses if
    the expression does not begin with simple or compound double quotes
    and does not begin with a period followed by nothing or a letter.  In
    the cases just mentioned, the expression must be enclosed in parentheses.
    All expressions may be enclosed in parentheses.

{p 8 8 2}
    An implication of the above is that missing value literals must
    be enclosed in parentheses:  {bind:{it:lvalue} {cmd:= (.)}}.

{phang}
{cmd:.}{it:id}[{cmd:.}{it:id}[...]] [{it:program_arguments}]{break}
    If the {it:rvalue} begins with a period, it is interpreted as an
    object reference.  The object is evaluated and returned.
    {cmd:.}{it:id}[{cmd:.}{it:id}[...]] may refer to a member variable
    or a member program.

{pmore}
    If {cmd:.}{it:id}[{cmd:.}{it:id}[...]] refers to a member variable, the
    value of the variable is returned.

{pmore}
    If {cmd:.}{it:id}[{cmd:.}{it:id}[...]] refers to a member program, 
    the program will be executed and the result returned.  If the member
    program returns nothing, a {cmd:string} containing "" (nothing) is
    returned.

{pmore}
    If {cmd:.}{it:id}[{cmd:.}{it:id}[...]] refers to a member program,
    arguments may be specified following the program name.

{phang}
{cmd:{c -(}}{cmd:{c )-}} and
{cmd:{c -(}}{it:el}[{cmd:,}{it:el}[{cmd:,}...]]{cmd:{c )-}}{break}
If the {it:rvalue} begins with an open brace, an {cmd:array} is returned.

{pmore}
If the {it:rvalue} is {cmd:{c -(}}{cmd:{c )-}}, an empty array is returned.

{pmore}
    If the {it:rvalue} is
    {cmd:{c -(}}{it:el}[{cmd:,}{it:el}[{cmd:,}...]]{cmd:{c )-}},
    an array containing the specified elements is returned.

{pmore}
    If an {it:el} is nothing, the corresponding array element is left
    undefined.

{pmore}
    If an {it:el} is {cmd:"}[{it:string}]{cmd:"} or
    {cmd:`"}[{it:string}]{cmd:"'}, the corresponding array element is defined
    as a {cmd:string} containing {it:string}.

{pmore}
    If an {it:el} is {it:#} excluding missing values {cmd:.}, {cmd:.a}, ...,
    {cmd:.z}, the corresponding array element is defined as a {cmd:double}
    containing the number specified.

{pmore}
    If an {it:el} is {cmd:(}{it:exp}{cmd:)}, the expression is evaluated, and
    the corresponding array element is defined as a {cmd:double} if the
    expression returns a numeric result or as a {cmd:string} if the expression
    returns a string.  Expressions returning matrices are not allowed.

{pmore}
    If an {it:el} is {cmd:.}{it:id}[{cmd:.}{it:id}[...]] or
    {cmd:[}{cmd:.}{it:id}[{cmd:.}{it:id}[...]] [{it:program_arguments}]{cmd:]},
    the object is evaluated, and the corresponding array element is defined
    according to what was returned.  Note that if the object is a member
    program and arguments need to be specified, the {it:el} must be
    enclosed in square brackets.

{pmore}
    Recursive array definitions are not allowed.

{pstd}
Finally, in 
{hi:{help classman##specifying_initialization:Specifying initialization}} -- where we discussed member variable
initialization -- what actually appears to the right of the equal sign is
an {it:rvalue}, and everything just said applies.  The previous discussion was
incomplete.


{marker assignment_of_reference}{...}
{title:7.4 Assignment of reference}

{pstd}
Consider two different identifiers, {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c}
and {cmd:.}{it:d}{cmd:.}{it:e} that are of the same type.  For example,
perhaps both are {cmd:double}s or both are {cmd:coordinate}s.  When you type

	{cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c} {cmd:=} {cmd:.}{it:d}{cmd:.}{it:e}

{pstd}
the result is to copy the values of {cmd:.}{it:d}{cmd:.}{it:e} into
{cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c}.  If you type

	{cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c}{cmd:.ref} {cmd:=} {cmd:.}{it:d}{cmd:.}{it:e}{cmd:.ref}

{pstd}
the result is to make {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c} and
{cmd:.}{it:d}{cmd:.}{it:e} be the same object.  That is, if you were
later to change some element of {cmd:.}{it:d}{cmd:.}{it:e}, the
corresponding element of {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c} would change,
and vice versa.

{pstd}
To understand this, think of member values as being written on an index card.
Each instance of a class has its own collection of cards (assuming no
classwide variables).  When you type

	{cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c}{cmd:.ref} {cmd:=} {cmd:.}{it:d}{cmd:.}{it:e}{cmd:.ref}

{pstd}
the card for {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c} is removed and a note is
substituted that says to use the card for {cmd:.}{it:d}{cmd:.}{it:e}.  Thus
both {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c} and {cmd:.}{it:d}{cmd:.}{it:e}
become literally the same object.

{pstd}
More than one object can share references.  If we were now to code

	 {cmd:.}{it:i}{cmd:.ref} {cmd:=} {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c}{cmd:.ref}

{pstd}
or

	 {cmd:.}{it:i}{cmd:.ref} {cmd:=} {cmd:.}{it:d}{cmd:.}{it:e}{cmd:.ref}

{pstd}
the result would be the same:  {cmd:.}{it:i} would also share the
already-shared object.

{pstd}
We now have {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c}, 
{cmd:.}{it:d}{cmd:.}{it:e}, and {cmd:.}{it:i} all being the same object.  Say
we want to make {cmd:.}{it:d}{cmd:.}{it:e} into its own unique object again.
We type

{p 8 20 2}
{cmd:.}{it:d}{cmd:.}{it:e}{cmd:.ref} {cmd:=} {it:anything evaluating to the right type not ending in} {cmd:.ref}

{pstd}
We could, for instance, type any of the following,

	{cmd:.}{it:d}{cmd:.}{it:e}{cmd:.ref} {cmd:=} {cmd:.}{it:classname}{cmd:.new}
	{cmd:.}{it:d}{cmd:.}{it:e}{cmd:.ref} {cmd:=} {cmd:.}{it:j}{cmd:.}{it:k}
	{cmd:.}{it:d}{cmd:.}{it:e}{cmd:.ref} {cmd:=} {cmd:.}{it:d}{cmd:.}{it:e}

{pstd}
All the above will make {cmd:.}{it:d}{cmd:.}{it:e} unique because what is
returned on the right is a copy.  The last of the three examples is intriguing
because it results in {cmd:.}{it:d}{cmd:.}{it:e} not changing its values but
becoming once again unique. 


{marker built-ins}{...}
{title:8. Built-ins}

{pstd}
{cmd:.new} and {cmd:.ref} are examples of built-in member programs that are
included in every class.  There are other built-ins as well.

{pstd}
Built-ins may be used on any object except programs and other
built-ins.  Let {cmd:.}{it:B} refer to a built-in.  Then

{phang2}
1.  if {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:myprog} refers to
a program, {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:myprog.}{it:B} is
an error (and, in fact,
{cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:myprog.}{it:anything} is
also an error).

{phang2}
2.  {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:B}{cmd:.}{it:anything}
is an error.

{pstd}
Built-ins come in two forms, built-in functions and built-in modifiers.
Built-in functions return information about the class or class instance on
which they operate but do not modify the class or class instance.
Built-in modifiers might return something -- in general they do 
not -- but they modify (change) the class or class instance.

{pstd}
Except for {cmd:.new} (and that was covered in
{hi:{help classman##specifying_initialization2:Specifying initialization 2, .new}}), built-ins may not be redefined.


{marker built-in_functions}{...}
{title:8.1 Built-in functions}

{pstd}
In the documentation below, {it:object} refers to the context of the
built-in function.  For example, if {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:F} is
how the built-in function {cmd:.}{it:F} was invoked, then
{cmd:.}{it:a}{cmd:.}{it:b} is the object on which it operates.

{pstd}
The built-in functions are

{phang}
{cmd:.new}{break}
	returns a new instance of {it:object}.  {cmd:.new} may be used whether
	the {it:object} is a class name or an instance, although it is most
	usually used with a class name.  For example, if {cmd:coordinate} is a
	class, {cmd:.coordinate.new} returns a new instance of
	{cmd:coordinate}.

{p 8 8 2}
	If {cmd:.new} is used with an instance, a new instance of the class of
	the object is returned; the current instance is not modified.  For
	example, if {cmd:.}{it:a}{cmd:.}{it:b} is an instance of
	{cmd:coordinate}, then
	{cmd:.}{it:a}{cmd:.}{it:b}{cmd:.new} does exactly what
	{cmd:.coordinate.new} would do;
	{cmd:.}{it:a}{cmd:.}{it:b} is not modified in any way.

{p 8 8 2}
	If you define your own {cmd:.new} program, it is run after the
	built-in {cmd:.new} is run.

{phang}
{cmd:.copy}{break}
	returns a new instance -- a copy -- of {it:object}, which must
	be an instance.  {cmd:.copy} returns a new object that is a
	copy of the original.

{phang}
{cmd:.ref}{break}
	returns a reference to the object.
	See {hi:{help classman##assignment_of_reference:Assignment of reference}}.

{phang}
{cmd:.objtype}{break}
	returns a {cmd:string} indicating the type of {it:object}.
	Returned is one of {cmd:"double"}, {cmd:"string"}, {cmd:"array"}, or
	{cmd:"}{it:classname}{cmd:"}.

{phang}
{cmd:.isa}{break}
	returns a {cmd:string} indicating the category of {it:object}.
	Returned is one of {cmd:"double"},
	{cmd:"string"}, {cmd:"array"}, {cmd:"class"}, or
	{cmd:"classtype"}.  {cmd:"classtype"} is returned when {it:object} is
	a class definition; {cmd:"class"} is returned when the object is an
	instance of a class {it:(sic)}.

{phang}
{cmd:.classname}{break}
	returns a {cmd:string} indicating the name of the class.  Returned is
	{cmd:"}{it:classname}{cmd:"} or, if {it:object} is of type
	{cmd:double}, {cmd:string}, or {cmd:array}, returned is {cmd:""}.

{phang}
{cmd:.isofclass} {it:classname}{break}
	returns a {cmd:double}.  Returns 1 if {it:object} is of class type
	{it:classname} and 0 otherwise.  To be of a class type, {it:object}
	must be an instance of {it:classname}, inherited from the class
	{it:classname}, or inherited from a class that inherits anywhere along
	its inheritance path from {it:classname}.

{phang}
{cmd:.objkey}{break}
	returns a {cmd:string} that can be used to reference an {it:object}
	outside the implied context.  See {hi:{help classman##keys:Keys}}.

{phang}
{cmd:.uname}{break}
	returns a {cmd:string} that can be used as a {it:name} throughout
	Stata that corresponds to the object.  See 
	{hi:{help classman##unames:Unames}}.

{phang}
{cmd:.ref_n}{break}
	returns a {cmd:double}.  Returned is the total number of identifiers
	sharing {it:object}.  Returned is 1 if the object is unshared.  See 
	{hi:{help classman##assignment_of_reference:Assignment of reference}}.

{phang}
{cmd:.arrnels}{break}
	returns a {cmd:double}.  {cmd:.arrnels} is for use with {cmd:array}s; it
	returns the largest index of the array that has been assigned data.
	If {it:object} is not an array, it returns an error.

{phang}
{cmd:.arrindexof "}{it:string}{cmd:"}{break}
	returns a {cmd:double}.  {cmd:.arrindexof} is for use with {cmd:array}s;
	it searches the array for the first element equal to {it:string} and
	returns the index of that element.  If {it:string} is not found,
	{cmd:.arrindexof} returns 0.  If {it:object} is not an array,
	it returns an error.

{phang}
{cmd:.classmv}{break}
	returns an {cmd:array} containing the {cmd:.ref}s of each
	classwide member variable in {it:object}.
	See {hi:{help classman##arrays_of_member_variables:Arrays of member variables}}.

{phang}
{cmd:.instancemv}{break}
	returns an {cmd:array} containing the {cmd:.ref}s of each
	instance-specific member variable in {it:object}.
	See {hi:{help classman##arrays_of_member_variables:Arrays of member variables}}.

{phang}
{cmd:.dynamicmv}{break}
	returns an {cmd:array} containing the {cmd:.ref}s of each
	dynamically allocated member variable in {it:object}.
	See {hi:{help classman##arrays_of_member_variables:Arrays of member variables}}.

{phang}
{cmd:.superclass}{break}
	returns an {cmd:array} containing the {cmd:.refs} of each
	of the classes from which the specified object inherited.
	See {hi:{help classman##arrays_of_member_variables:Arrays of member variables}}.

{phang}
{cmd:.oncopy_src}{break}
        returns a string containing the object key of the class instance that
        is the source for the current {cmd:.oncopy}.  This string can be used
	to reference the source object and is used only in
        conjunction with {cmd:.oncopy} programs.
	See {hi:{help classman##specifying_initialization3:Advanced initialization, .oncopy}}.

{marker built-in_modifiers}{...}
{title:8.2 Built-in modifiers}

{phang}
Modifiers are built-ins that change the object to which they are applied.
All built-in modifiers have names beginning with a capital letter.
The built-in modifiers are

{phang}
{cmd:.Declare} {it:declarator}{break}
	returns nothing.  {cmd:.Declare} may be used only when {it:object} is
	a class instance.  {cmd:.Declare} adds the specified new member
	variable to the class instance.
	See {hi:{help classman##adding_dynamically:Adding dynamically}}.

{phang}
{cmd:.Arrdropel} {it:#}{break}
	returns nothing.  {cmd:.Arrdropel} may be used only with {cmd:array}
	elements.  {cmd:.Arrdropel} drops the specified array element, making
	it as if it was never defined.  {cmd:.arrnels} is, of course, updated.
	See {hi:{help classman##arrays:Arrays and array elements}}.
	
{phang}
{cmd:.Arrdropall}{break}
	returns nothing.  {cmd:.Arrdropall} may be used only with
	{cmd:array}s.  {cmd:.Arrdropall} drops all elements of an array.  
	{cmd:.Arrdropall} is the same as {cmd:.}{it:arrayname} {cmd:= {}}. 
	If {it:object} is not an array, {cmd:.Arrdropall} returns an error.

{phang}
{cmd:.Arrpop}{break}
	returns nothing.  {cmd:.Arrpop} may be used only with {cmd:array}s.
	{cmd:.Arrpop} finds the top element of an array (largest index), and
	removes it from the array.  To access the top element before popping,
	use {cmd:.}{it:arrayname}{cmd:[`.}{it:arrayname}{cmd:.arrnels']}.
	If {it:object} is not an array, {cmd:.Arrpop} returns an error.

{phang}
{cmd:.Arrpush} {cmd:"}{it:string}{it:"}{break}
	returns nothing.  {cmd:.Arrpush} may be used only with {cmd:array}s.
	{cmd:.Arrpush} pushes {it:string} onto the end of the array, where end
	is defined as {cmd:.arrnels}+1.  If {it:object} is not an array,
	{cmd:.Arrpush} returns an error.


{marker prefix_operators}{...}
{title:9. Prefix operators}

{pstd}
There are three prefix operators:

	{cmd:.Global}
	{cmd:.Local}
	{cmd:.Super}

{pstd}
Prefix operators determine how object names such as
{cmd:.}{it:a}, {cmd:.}{it:a}{cmd:.}{it:b},
{cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c}, ...
are resolved.

{pstd}
Consider a program invoked by typing {cmd:.alpha.myprog}.
In program {cmd:.myprog}, any lines such as

	{cmd:.a = .b}

{pstd}
are interpreted according to the implied context, if that is possible.
{cmd:.a} is interpreted to mean {cmd:.alpha.a} if {cmd:.a} exists in
{cmd:.alpha}; otherwise, it is taken to mean {cmd:.a} in the global context,
meaning that it is taken to mean just {cmd:.a}.  Similarly, {cmd:.b} is taken
to mean {cmd:.alpha.b} if {cmd:.b} exists in {cmd:.alpha}; otherwise, it is
taken to mean {cmd:.b}.

{pstd}
What if {cmd:.myprog} wants {cmd:.a} to be interpreted in the global context
even if {cmd:.a} exists in {cmd:.alpha}?  Then the code would read

	{cmd:.Global.a = .b}

{pstd}
If instead {cmd:.myprog} wanted {cmd:.b} to be interpreted in the global
context (and {cmd:.a} to be interpreted in the implied context), the code
would read

	{cmd:.a = .Global.b}

{pstd}
Obviously, if the program wanted both to be interpreted in the global context,
the code would read

	{cmd:.Global.a = .Global.b}

{pstd}
{cmd:.Local} is the reverse of {cmd:.Global}:  it ensures that the object
reference is interpreted in the implied context.  {cmd:.Local} is rarely
specified because the local context is searched first, but if there is a
circumstance where you wish to be certain that the object is not found in the
global context, you may specify its reference preceded by {cmd:.Local}.
Understand, however, that if the object is not found, an error will result, so
you would need to precede commands containing such references with
{cmd:capture}; see {manhelp capture P}.

{pstd}
In fact, if used at all, {cmd:.Local} is nearly always used in a
macro-substitution context -- something discussed in the next
session -- where errors are suppressed and where nothing is substituted
when an error occurs.  Thus in advanced code, if you were trying to determine
whether member variable {cmd:.addedvar} exists in the local context, you could
code

	{cmd}if "`Local.addedvar.objtype'" == "" {
			/* it does not exist */
	}
	else {
			/* it does */
	}{txt}

{pstd}
The {cmd:.Super} prefix is used only in front of program names and concerns
inheritance when one program occults another.  This was discussed in
{hi:{help classman##inheritance:Inheritance}}.


{marker using_object_values}{...}
{title:10. Using object values}

{pstd}
We have discussed definition and assignment of objects, but we have not yet
discussed how you might use class objects in a program.  How do you refer to
their values in a program?  How do you find out what a value is, skip some
code if the value is one thing, and loop if it is another?

{pstd}
The most common way to refer to objects (and the returned results of
member programs) is through macro substitution, for example,

	{cmd:local x = `.li.c0.x'}
	{cmd:local clr "`.color.cvalue, color(green)'"}
	{cmd:scalar len = `.coord.length'}
	{cmd}forvalues i=1(1)`.todo.n' {
			Mysub "`todo.list[`i']'"
	}{txt}

{pstd}
When a class object is quoted, its printable form is substituted.  This is
defined as

{p2colset 5 18 20 22}{...}
{p2col :Object type}Printable form{p_end}
{p2line}
{p2col :{cmd:string}}contents of the string{p_end}
{p2col :{cmd:double}}number printed using {cmd:%18.0g}, spaces stripped{p_end}
{p2col :{cmd:array}}nothing{p_end}
{p2col :{it:classname}}nothing or, if member program {cmd:.macroexpand} is
defined, then {cmd:string} or {cmd:double} returned{p_end}
{p2line}
{p2colreset}{...}


{pstd}
Any object may be quoted, including programs.  If the program takes arguments,
they are included inside the quotes:

	{cmd:scalar len = `.coord.length'}
	{cmd:local clr "`.color.cvalue, color(green)'"}

{pstd}
If the quoted reference results in an error, the error message is suppressed,
and nothing is substituted.

{pstd}
Similarly, if a class instance is quoted -- or a program returning a
class instance is quoted -- nothing is substituted.  That is, nothing is
substituted assuming the member program {cmd:.macroexpand} has not been
defined for the class, as is usually the case.  If {cmd:.macroexpand} has been
defined, however, it is executed, and what {cmd:macroexpand} returns{hline
2}which may be a {cmd:string} or a {cmd:double} -- is substituted.

{pstd}
For example, say that we wanted to make all objects of type {cmd:coordinate}
substitute {cmd:(}{it:#}{cmd:,}{it:#}{cmd:)} when they were quoted.  In the
class definition for {cmd:coordinate}, we could define
{cmd:.macroexpand},

	{hline 33} begin {cmd:coordinate.class} {hline}
	{cmd:version {ccl stata_version}}
	{cmd:class coordinate {c -(}}
			{it:[declaration of member variables omitted]}
	{cmd:{c )-}}
	{it:[definitions of class programs omitted]}

	{cmd}program .macroexpand
			local tosub : display "(" `.x' "," `.y' ")"
			class exit "`tosub'"
	end{txt}
	{hline 33} end {cmd:coordinate.class} {hline}

{pstd}
and now {cmd:coordinate}s will be substituted.  Say {cmd:.mycoord} is a
{cmd:coordinate} currently set to (2,3).  Understand, if we did not include
{cmd:.macroexpand} in the {cmd:coordinate.class} file, typing

	...{cmd:`.mycoord'}...

{pstd}
would not be an error, it would merely result in

	......

{pstd}
Having defined {cmd:.macroexpand}, it will result in

	...{cmd:(2,3)}...

{pstd}
A {cmd:.macroexpand} member function is intended as a utility for
returning the printable form of a class instance and nothing more.  In fact,
the class system prevents unintended corruption of class-member variables by
making a copy, returning the printable form, and then destroying the copy.
These steps insure that implicitly calling {cmd:.macroexpand} has no side
effects on the class instance.


{marker object_destruction}{...}
{title:11. Object destruction}

{pstd}
To create an instance of a class, you type

	{cmd:.}{it:name} {cmd:= .}{it:classname}{cmd:.new} [{it:arguments}]

{pstd}
To destroy the resulting object and thus release the memory associated with it,
you type

	{cmd:classutil drop} {cmd:.}{it:name}

{pstd}
See {manhelp classutil P} for more information on the {cmd:classutil} command.
You can drop only top-level instances.  Objects deeper than that are dropped
when the higher-level object containing them is dropped, and
classes are automatically dropped when the last instance of the class is
dropped.

{pstd}
Also any top-level object named with a name obtained from 
{cmd:tempname} -- see {manhelp macro P} -- is automatically dropped
when the program concludes.  Even so, {cmd:tempname} objects may be returned
by {cmd:class exit}.  The following is valid:

	{cmd}program .tension
			...
			tempname a b
			.`a' = .bubble.new
			.`b' = .bubble.new
			...
			class exit .`a'
	end{txt}

{pstd}
The program creates two new class instances of {cmd:bubble}s in the global
context, both with temporary names.  We can be assured that {cmd:.`a'} and
{cmd:.`b'} are global because the names {cmd:`a'} and {cmd:`b'} were obtained
from {cmd:tempname} and, therefore, cannot already exist in whatever context in
which {cmd:.tension} runs.  Therefore, when the program ends, {cmd:.`a'} and
{cmd:.`b'} will be automatically dropped.  Even so, {cmd:.tension} can return
{cmd:.`a'}.  It can do that because, at the time {cmd:class exit} is executed,
the program has not yet concluded and {cmd:.`a'} still exists.  You can even
code

	{cmd}program .tension
			...
			tempname a b
			.`a' = .bubble.new
			.`b' = .bubble.new
			...
			class exit .`a'.ref
	end{txt}

{pstd}
and that also will return {cmd:.a} and, in fact, will be faster because no extra
copy will be made.  This form is recommended when returning an object stored
in a temporary name.  Do not, however, add {cmd:ref}s on the end of "real"
(nontemporary) objects being returned because then you would be returning not
just the same values as in the real object but the object itself.

{pstd}
You can clear the entire class system by typing {helpb discard}.  There is no
{cmd:classutil drop _all} command.  That is because Stata's graphics system
also uses the class system, and dropping all the class definitions and
instances would cause {cmd:graph} difficulty.  {cmd:discard} also clears all
open graphs, so the disappearance of class definitions and instances causes
{cmd:graph} no difficulty.

{pstd}
During the development of class-based systems, you should 
type {cmd:discard} any time you make a change to any part of the system, no
matter how minor or how certain you are that no instances of the definition
modified yet exist.


{marker advanced_topics}{...}
{title:12. Advanced topics}

{marker keys}{...}
{title:12.1 Keys}

{pstd}
The {cmd:.objkey} built-in function returns a {cmd:string} called a key that
can be used to reference the object as an {it:rvalue} but not as an
{it:lvalue}.  This would typically be used in

	{cmd:local k = `.a.b.objkey'}
    or
	{cmd:.c.k = .a.b.objkey}

{pstd}
where {cmd:.c.k} is a {cmd:string}.
Thus the keys stored could be then used as follows:

	{cmd:.d = .`k'.x}                  meaning to assign {cmd:.a.b.x} to {cmd:.d}
	{cmd:.d = .`.c.k'.x}               (same)
	{cmd:local z = `.`k'.x'}           meaning to put value of {cmd:.a.b.x} in {cmd:`z'}
	{cmd:local z = `.`.c.k'.x'}        (same)

{pstd}
It does not matter if the key is stored in a
macro or a string member variable -- it can be used equally 
well -- and you always use the key by macro quoting.

{pstd}
A key is a special string that stands for the object.  Why not, you wonder,
simply type {cmd:.a.b} rather than {cmd:.`.c.k'} or {cmd:.`k'}?  The answer
has to do with implied context.

{pstd}
Pretend that {cmd:.myvar.bin.myprogram} runs {cmd:.myprogram}.  Obviously, it
runs {cmd:.myprogram} in the context {cmd:.myvar.bin}.  Thus {cmd:.myprogram}
can include lines such as

	{cmd:.x = 5}

{pstd}
and that is understood to mean that {cmd:.myvar.bin.x} is to be set to 5.
{cmd:.myprogram}, however, might also include a line that reads

	{cmd:.Global.utility.setup `.x.objkey'}

{pstd}
Here {cmd:.myprogram} is calling a utility that runs in a different
context (namely, {cmd:.utility}), but {cmd:myprogram} needs to pass 
{cmd:.x} -- of whatever type it might be -- to the utility as an
argument.  Perhaps {cmd:.x} is a {cmd:coordinate}, and {cmd:.utility.setup}
expects to receive the identifier of a {cmd:coordinate} as its argument.
{cmd:.myprogram}, however, does not know that {cmd:.myvar.bin.x} is the full
name of {cmd:.x}, which is what {cmd:.utility.setup} will need, so
{cmd:.myprogram} passes {cmd:`.x.objkey'}.  Program {cmd:.utility.setup} can
use what it receives as its argument just as if it contained
{cmd:.myvar.bin.x}, except that {cmd:.utility.setup} cannot use that received
reference on the left-hand side of an assignment.

{pstd}
If {cmd:myprogram} needed to pass to {cmd:.utility.setup} a reference
to the entire implied context ({cmd:.myvar.bin}), the line would read

	{cmd:.Global.utility.setup `.objkey'}

{pstd}
because {cmd:.objkey} by itself means to return the key of the implied context.


{marker unames}{...}
{title:12.2 Unames}

{pstd}
The built-in function {cmd:.uname} returns a {it:name} that can be used
throughout Stata that uniquely corresponds to the object.  The mapping is
one-way.  Unames can be obtained for objects, but the original object's
name cannot be obtained from the uname.

{pstd}
Pretend that you have object {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c}, and you wish
to obtain a name you can associate with that object because you want to create
a variable in the current dataset, or a value label, or whatever else, to go
along with the object.  Later, you want to be able to reobtain that name from
the object's name.  {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c}{cmd:.uname} will
provide that name.  The name will be ugly, but it will be unique.  The name is
not temporary:  it will be your responsibility to drop whatever you create
with the name later.

{pstd}
Unames are, in fact, are based on the object's {cmd:.ref}.  That is to say,
consider two objects, {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c} and
{cmd:.}{it:d}{cmd:.}{it:e}, and pretend that they refer to the same data: that
is, you have previously executed

	{cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c}{cmd:.ref} {cmd:=} {cmd:.}{it:d}{cmd:.}{it:e}{cmd:.ref}

	or

	{cmd:.}{it:d}{cmd:.}{it:e}{cmd:.ref} {cmd:=} {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c}{cmd:.ref}

{pstd}
Then {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:c}{cmd:.uname} will equal
{cmd:.}{it:d}{cmd:.}{it:e}{cmd:.uname}.  The names returned are unique to
the data being recorded, not the identifiers used to arrive to the data.

{pstd}
As an example of use, within Stata's graphics system sersets are used to hold
the data behind a graph; see {manhelp serset P}.  An overall graph might
consist of several graphs.  In the object nesting for a graph, each
individual graph has its own object holding a serset for its use.  The
individual objects, however, are shared when the same serset will work for two
or more graphs, so that the same data are not recorded again and again.  That
is accomplished by simply setting their {cmd:.ref}s equal.  Much later in the
graphics code, when that code is writing a graph out to disk for saving, it
needs to figure out which sersets need to be saved, and it does not wish to
write shared sersets out multiple times.  Stata finds out what sersets are
shared by looking at their unames and, in fact, uses the unames to help
it keep track of which sersets go with which graph.


{marker arrays_of_member_variables}{...}
{title:12.3 Arrays of member variables}

{pstd}
Note: the following functions are of little use in class programming.  They
are of use to those writing utilities to describe the contents of the class
system, such as the features documented in {manhelp classutil P}.

{pstd}
The built-in functions {cmd:.classmv}, {cmd:.instancemv}, and {cmd:.dynamicmv}
each return an {cmd:array} containing the {cmd:.ref}s of each classwide,
instance-specific, and dynamically declared member variables.  These array
elements may be used as either {it:lvalues} or {it:rvalues}.

{pstd}
{cmd:.superclass} also returns an {cmd:array} containing {cmd:.refs}, these
being references to the classes from which the current object inherited.
These array elements may be used as {it:rvalues} but should not be used as
{cmd:lvalues} because they refer to underlying class definitions themselves.

{pstd}
{cmd:.classmv}, {cmd:.instancemv}, {cmd:.dynamicmv}, and {cmd:.superclass},
although documented as built-in functions, are not really functions, but
instead are built-in member variables.  This means that, unlike built-in
functions, their references may be followed by other built-in functions, and
it is not an error to type, for instance,

	... {cmd:.li.instancemv.arrnels} ...

{pstd}
and it would be odd (but allowed) to type

	{cmd:.myarray = .li.instancemv}

{pstd}
It would be odd simply because there is no reason to copy them because you can
use them in place.

{pstd}
Each of the above member functions are a little sloppy in that they return
nothing (produce an error) if there are no classwide, instance-specific, and
dynamically declared member variables, or no inherited classes.  This
sloppiness has to do with system efficiency, and the proper way to work around
the sloppiness is to obtain the number of elements in each array as
{cmd:0`.classmv.arrnels'}, {cmd:0`.instancemv.arrnels'},
{cmd:0`.dynamicmv.arrnels'}, and {cmd:0`.superclass.arrnels'}.  If an array
does not exist, then nothing will be substituted, and you will still be left
with the result {cmd:0}.

{pstd}
For instance, assume that {cmd:.my.c} is of type {cmd:coordinate2}, defined as

	{hline 33} begin {cmd:coordinate2.class} {hline}
	{cmd}version {ccl stata_version}
	class coordinate2 {
			classwide:
				double x_origin = 0
				double y_origin = 0
			instancespecific:
				double x = 0
				double y = 0
	}
	{txt}{hline 33} end {cmd:coordinate2.class} {hline}

{pstd}
Then

	referring to                is equivalent to referring to
	{hline 57}{cmd}
	.my.c.classmv[1]            .my.c.c.x_origin
	.my.c.classmv[2]            .my.c.c.y_origin
	.my.c.instancemv[1]         .my.c.c.x
	.my.c.instancemv[2]         .my.c.c.y{txt}
	{hline 57}

{pstd}
If any member variables were added dynamically using {cmd:.Dynamic}, they
could equally well be accessed via {cmd:.my.c.dynamicmv[]} or their names.
Either of the above could be used on the left or right of an assignment.

{pstd}
If {cmd:coordinate2.class} inherited from another class (it does not),
referring to {cmd:.coordinate2.superclass[1]} would be equivalent to
referring to the inherited class; {cmd:.coordinate2.superclass[1].new},
for instance, would be allowed.

{pstd}
These "functions" are mainly of interest to those writing utilities to act on
class instances as a general structure.


{marker appendix_a}{...}
{title:Appendix A:  Finding, loading, and clearing class definitions}

{pstd}
As mentioned, the definition for class {it:xyz} is located in file
{it:xyz}{cmd:.class}.

{pstd}
Stata looks for {it:xyz}{cmd:.class} along the ado-path in the same way it
looks for ado-files; see {manhelp sysdir P}.

{pstd}
Class definitions are loaded automatically, as they are needed, and are
cleared from memory as they fall into disuse.

{pstd}
When you type {cmd:discard}, all class definitions and all existing instances
of classes are dropped; see {manhelp discard P}.


{marker jargon}{...}
{title:Appendix B:  Jargon}

{phang}
{bf:built-in}:  a member program which is automatically defined, such as
    {cmd:.new}.  A {bf:built-in function} is a member program that returns
    a result without changing the object on which it was run.  A
    {bf:built-in modifier} is a member program that changes the object on
    which it was run and might return a result as well.

{phang}
{bf:class}:  a name for which there is a class definition.  If we say that
    {cmd:coordinate} is a class, then {it:coordinate}{cmd:.class} is the name
    of the file that contains its definition.

{phang}
{bf:class instance}:  a "variable"; a specific, named copy (instance) of a
    class with its member values filled in; an identifier that is defined to
    be of {it:type classname}.

{phang}
{bf:classwide variable}:  a member variable that is shared
    by all instances of a class.  Its alternative is an instance-specific
    variable.

{phang}
{bf:inheritance}:  the ability to define a class in terms of one (single
    inheritance) or more (multiple inheritance) existing classes.  The existing
    class is typically called the base or super class, and by default, the new
    class inherits all the member variables and member programs of the base
    class.

{phang}
{bf:identifier}:  the name by which an object is identified, such as
{cmd:.mybox} or {cmd:.mybox.x}.

{phang}
{bf:implied context}:
    the instance on which a member program is run.  For example, in
    {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{cmd:myprog},
    {cmd:.}{it:a}{cmd:.}{it:b} is the implied context, and any references to,
    say, {cmd:.}{it:x} within the program, are first assumed to, in fact, be
    references to {cmd:.}{it:a}{cmd:.}{it:b}{cmd:.}{it:x}.

{phang}
{bf:instance}:  a class instance.

{phang}
{bf:instance-specific variable}:
    a member variable that is unique to each instance of a class; each
    instance has its own copy of the member variable.  Its alternative is a
    classwide variable.

{phang}
{bf:lvalue}:  an identifier that may appear to the left of the {cmd:=}
    assignment operator.

{phang}
{bf:member program}:  a program that is a member of a class or of an instance.

{phang}
{bf:member variable}:  a variable that is a member of a class or of an
    instance.

{phang}
{bf:object}: a class or an instance; most commonly this is a synonym for an
    instance, but in formal syntax definitions, if something is said to be
    allowed to be used with an object, that means it may be used with a class
    or with an instance.

{phang}
{bf:polymorphism}:  when a system allows the same program name to invoke
    different programs according to the class of the object.  For example,
    {cmd:.draw} might invoke one program when used on a star object
    {cmd:.mystar.draw} and a different program when used on a box object
    {cmd:.mybox.draw}.

{phang}
{bf:reference}:  most often the word is used according to its
    English-language definition, but a {cmd:.ref} reference
    can be used to obtain the data associated with an object.  If two
    identifiers have the same reference, then they are the same object.

{phang}
{bf:return value}:  what an object returns, which might be of type
    {cmd:double}, {cmd:string}, {cmd:array}, or {it:class}.
    Generally, return value is used in discussions of member programs,
    but all objects have a return value; they typically return
    a copy of themselves.

{phang}
{bf:rvalue}:  an identifier that may appear to the right of the {cmd:=}
    assignment operator.

{phang}
{bf:scope}:  how it is determined to what object an identifier references.
    {cmd:.}{it:a}{cmd:.}{it:b} might be interpreted in the global context
    and so mean literally
    {cmd:.}{it:a}{cmd:.}{it:b}, or it might be interpreted in an implied
    context to mean {cmd:.}{it:impliedcontext}{cmd:.}{it:a}{cmd:.}{it:b}.

{phang}
{bf:shared object}:  an object to which two or more different identifiers
    refer.

{phang}
{bf:type}:  the type of a member variable or of a return value, which is
    {cmd:double}, {cmd:string}, {cmd:array}, or {it:class}.


{marker syntax}{...}
{title:Appendix C:  Syntax diagrams}

{title:Appendix C.1:  Class declaration}

{pstd}
See {help classdeclare}.


{title:Appendix C.2:  Assignment}

{pstd}
See {help classassign}.


{title:Appendix C.3:  Macro substitution}

{pstd}
See {help classmacro}.


{title:Appendix C.4:  Quick summary of built-ins}

{pstd}
See {help classbi}.
{p_end}
