{smcl}
{* *! version 1.1.12  18sep2018}{...}
{vieweralsosee "[P] macro lists" "mansection P macrolists"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] macro" "help macro"}{...}
{viewerjumpto "Syntax" "macrolists##syntax"}{...}
{viewerjumpto "Description" "macrolists##description"}{...}
{viewerjumpto "Links to PDF documentation" "macrolists##linkspdf"}{...}
{viewerjumpto "Remarks" "macrolists##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[P] macro lists} {hline 2}}Manipulate lists{p_end}
{p2col:}({mansection P macrolists:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{c -(}{cmdab:loc:al} | {cmdab:gl:obal}{c )-}
{it:macname}
{cmd::} {cmd:list}
{cmd:uniq}
{it:macname}

{p 8 14 2}
{c -(}{cmdab:loc:al} | {cmdab:gl:obal}{c )-}
{it:macname}
{cmd::} {cmd:list}
{cmd:dups}
{it:macname}

{p 8 14 2}
{c -(}{cmdab:loc:al} | {cmdab:gl:obal}{c )-}
{it:macname}
{cmd::} {cmd:list}
{cmd:sort}
{it:macname}

{p 8 14 2}
{c -(}{cmdab:loc:al} | {cmdab:gl:obal}{c )-}
{it:macname}
{cmd::} {cmd:list}
{cmdab:retok:enize}
{it:macname}

{p 8 14 2}
{c -(}{cmdab:loc:al} | {cmdab:gl:obal}{c )-}
{it:macname}
{cmd::} {cmd:list}
{cmd:clean}
{it:macname}


{p 8 14 2}
{c -(}{cmdab:loc:al} | {cmdab:gl:obal}{c )-}
{it:macname}
{cmd::} {cmd:list}
{it:macname}
{cmd:|}
{it:macname}

{p 8 14 2}
{c -(}{cmdab:loc:al} | {cmdab:gl:obal}{c )-}
{it:macname}
{cmd::} {cmd:list}
{it:macname}
{cmd:&}
{it:macname}

{p 8 14 2}
{c -(}{cmdab:loc:al} | {cmdab:gl:obal}{c )-}
{it:macname}
{cmd::} {cmd:list}
{it:macname}
{cmd:-}
{it:macname}


{p 8 14 2}
{c -(}{cmdab:loc:al} | {cmdab:gl:obal}{c )-}
{it:macname}
{cmd::} {cmd:list}
{it:macname}
{cmd:==}
{it:macname}

{p 8 14 2}
{c -(}{cmdab:loc:al} | {cmdab:gl:obal}{c )-}
{it:macname}
{cmd::} {cmd:list}
{it:macname}
{cmd:===}
{it:macname}

{p 8 14 2}
{c -(}{cmdab:loc:al} | {cmdab:gl:obal}{c )-}
{it:macname}
{cmd::} {cmd:list}
{it:macname}
{cmd:in}
{it:macname}

{p 8 14 2}
{c -(}{cmdab:loc:al} | {cmdab:gl:obal}{c )-}
{it:macname}
{cmd::} {cmd:list}
{cmd:sizeof}
{it:macname}

{p 8 14 2}
{c -(}{cmdab:loc:al} | {cmdab:gl:obal}{c )-}
{it:macname}
{cmd::} {cmd:list}
{cmd:posof}
{cmd:"}{it:element}{cmd:"}
{cmd:in}
{it:macname}


{phang}
Note: Where {it:macname} appears above, it is the name of a macro and not its 
contents that you are to type.  For example, you are to type

{pin2}
{cmd:local result : list list1 | list2}

{pmore}
and not

{pin2}
{cmd:local result : list "`list1'" | "`list2'"}

{pmore}
{it:macname}s that appear to the right of the colon are assumed to be the
names of local macros.  You may type {cmd:local(}{it:macname}{cmd:)} to
emphasize that fact.  Type {cmd:global(}{it:macname}{cmd:)} if you wish to
refer to a global macro.


{marker description}{...}
{title:Description}

{pstd}
The macro function {cmd:list} manipulates lists.  See 
{helpb macro:[P] macro} for other macro functions.

{phang}
{cmd:uniq} {it:A} returns {it:A} with duplicate elements removed.  The
resulting list has the same ordering of its elements as {it:A}; duplicate
elements are removed from their rightmost position.
If {it:A}="{it:a b a c a}", {cmd:uniq} returns "{it:a b c}".

{phang}
{cmd:dups} {it:A} returns the duplicate elements of {it:A}.
If {it:A}="{it:a b a c a}", {cmd:dups} returns "{it:a a}".

{phang}
{cmd:sort} {it:A} returns {it:A} with its elements placed in alphabetical
(ascending ASCII or code-point) order.

{phang}
{cmd:retokenize} {it:A} returns {it:A} with single spaces between elements.
    Logically speaking, it makes no difference how many spaces a list has
    between elements, and thus {cmd:retokenize} leaves the list logically
    unchanged.

{phang}
{cmd:clean} {it:A} returns {it:A} retokenized and with each element adorned
    minimally.  An element is said to be unadorned if it is not enclosed in
    quotes (for example, {it:a}).  An element may be adorned in
    simple or compound quotes (for example, {cmd:"}{it:a}{cmd:"} or
    {cmd:`"}{it:a}{cmd:"'}).  Logically speaking, it makes no difference how
    elements are adorned, assuming that they are adorned adequately.  The list

{pin2}
{cmd:`"}{it:a}{cmd:"'} {cmd:`"}{it:b c}{cmd:"'} {cmd:`"}{it:b} {cmd:"}{it:c}{cmd:"} {it:d}{cmd:"'}

{pmore}
is equal to

{pin2}
{it:a} {cmd:"}{it:b c}{cmd:"} {cmd:`"}{it:b} {cmd:"}{it:c}{cmd:"} {it:d}{cmd:"'}

{pmore}
{cmd:clean}, in addition to performing the actions of {cmd:retokenize},
adorns each element minimally:  not at all if the element contains no
spaces or quotes, in simple quotes ({cmd:"} and {cmd:"}) if it contains spaces
but not quotes, and in compound quotes ({cmd:`"} and {cmd:"'}) otherwise.

{phang}
{it:A} {cmd:|} {it:B} returns the union of {it:A} and {it:B}, the result being
equal to {it:A} with elements of {it:B} not found in {it:A} added to the tail.
For instance, if {it:A}="{it:a b c}" and {it:B}="{it:b d e}", {it:A} {cmd:|}
{it:B} is "{it:a b c d e}".  If you instead want list concatenation, you
code,

{pin2}
{cmd:local} {it:newlist} {cmd:`"`}{it:A}{cmd:' `}{it:B}{cmd:'"'}

{pmore}
In the example above, this would return "{it:a b c b d e}".

{phang}
{it:A} {cmd:&} {it:B} returns the intersection of {it:A} and {it:B}.  If
{it:A}="{it:a b c d}" and {it:B}="{it:b c f g}", then {it:A} {cmd:&} {it:B} =
"{it:b c}".

{phang}
{it:A} {cmd:-} {it:B} returns a list containing elements of {it:A} with the
elements of {it:B} removed, with the resulting elements in the same order as
{it:A}.  For instance, if {it:A}="{it:a b c d}" and {it:B}="{it:b e}", the
result is "{it:a c d}".

{phang}
{it:A} {cmd:==} {it:B} returns 0 or 1; it returns 1 if {it:A} is equal to
{it:B}, that is, if {it:A} has the same elements as {it:B} and in the same
order. Otherwise, 0 is returned.

{phang}
{it:A} {cmd:===} {it:B} returns 0 or 1; it returns 1 if {it:A} is equivalent
to {it:B}, that is, if {it:A} has the same elements as {it:B} regardless of
the order in which the elements appear.  Otherwise, 0 is returned.

{phang}
{it:A} {cmd:in} {it:B} returns 0 or 1; it returns 1 if all elements of {it:A}
are found in {it:B}.  If {it:A} is empty, {cmd:in} returns 1.  Otherwise,
0 is returned.

{phang}
{cmd:sizeof} {it:A} returns the number of elements of {it:A}.
If {it:A}="a b c", {cmd:sizeof} {it:A} is 3.
({cmd:sizeof} returns the same result as the macro function
{helpb macro##parsing:word count}.)

{phang}
{cmd:posof} {cmd:"}{it:element}{cmd:"} {cmd:in} {it:A} returns the location of
{it:macname} in {it:A} or returns 0 if not found.  For instance, if {it:A}
contains "{it:a b c d}", then {cmd:posof "}{it:b}{cmd:" in} {it:A} returns 2.
({helpb macro##parsing:word # of} may be used to extract positional
elements from lists, as can {helpb tokenize} and {helpb gettoken}.)

{pmore}
It is the element itself and not a macroname that you type as
the first argument.  In a program where macro {cmd:tofind} contained an element
to be found in list (macro) {cmd:variables}, you might code

{pin2}
{cmd:local i : list posof `"`tofind'"' in variables}

{pmore}
{it:element} must be enclosed in simple or compound quotes.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P macrolistsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

Remarks are presented under the following headings:

{pmore}
{help macrolists##adornment:Treatment of adornment}{break}
{help macrolists##duplicate:Treatment of duplicate elements in lists}{break}

{pstd}
A list is a space-separated set of elements listed one after the other.
The individual elements may be enclosed in quotes and elements containing
spaces obviously must be enclosed in quotes.  The following are examples
of lists:

{pmore}
{cmd:this that what}

{pmore}
{cmd:"first element" second "third element" 4}

{pmore}
{cmd:this that what this that}

{pstd}
Also a list could be empty.

{pstd}
Do not confuse varlist with list.  Varlists are a special notation,
such as "id m* pop*", which is a shorthand way of specifying a list of
variables; see {it:{help varlist}}.  Once expanded, however, a varlist is
a list.


{marker adornment}{...}
{title:Treatment of adornment}

{pstd}
An element of a list is said to be adorned if it is enclosed in quotes.
Adornment, however, plays no role in the substantive interpretation
of lists.  The list

{pmore}
{it:a} {cmd:"}{it:b}{cmd:"} {it:c}

{pstd}
is identical to the list

{pmore}
{it:a b c}


{marker duplicate}{...}
{title:Treatment of duplicate elements in lists}

{pstd}
With the exception of {cmd:uniq} and {cmd:dups}, all list functions treat
duplicates as being distinct.  For instance, consider the list {it:A},

{pmore}
{it:a b c b}

{pstd}
Notice that {it:b} appears twice in this list.
You want to think of the list as containing {it:a}, the first occurrence of
{it:b}, {it:c}, and the second occurrence of {it:b}:

{pmore}
{it:a b_1 c b_2}

{pstd}
Do the same thing with the duplicate elements of all lists, carry out the
operation on the now unique elements, and then erase the subscripts from
the result.

{pstd}
If you were to ask whether {it:B}="{it:b b}" is {cmd:in} {it:A}, the answer
would be yes, because {it:A} contains two occurrences of {it:b}.  If
{it:B} contained "{it:b b b}", however, the answer would be no because
{it:A} does not contain three occurrences of {it:b}.

{pstd}
Similarly, if {it:B}="{it:b b}", {it:A}{cmd:|}{it:B}="{it:a b c b}", but if
{it:B}="{it:b b b}", {it:A}{cmd:|}{it:B}="{it:a b c b b}".
{p_end}
