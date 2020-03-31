{smcl}
{* *! version 1.2.10  17may2019}{...}
{viewerdialog generate "dialog generate"}{...}
{viewerdialog replace "dialog replace"}{...}
{vieweralsosee "[D] generate" "mansection D generate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] compress" "help compress"}{...}
{vieweralsosee "[D] corr2data" "help corr2data"}{...}
{vieweralsosee "[D] drawnorm" "help drawnorm"}{...}
{vieweralsosee "[D] dyngen" "help dyngen"}{...}
{vieweralsosee "[D] edit" "help edit"}{...}
{vieweralsosee "[D] egen" "help egen"}{...}
{vieweralsosee "[D] encode" "help encode"}{...}
{vieweralsosee "[D] label" "help label"}{...}
{vieweralsosee "[D] recode" "help recode"}{...}
{vieweralsosee "[D] rename" "help rename"}{...}
{vieweralsosee "[U] 13 Functions and expressions (expressions)" "help exp"}{...}
{vieweralsosee "[U] 13 Functions and expressions (operators)" "help operators"}{...}
{viewerjumpto "Syntax" "generate##syntax"}{...}
{viewerjumpto "Menu" "generate##menu"}{...}
{viewerjumpto "Description" "generate##description"}{...}
{viewerjumpto "Links to PDF documentation" "generate##linkspdf"}{...}
{viewerjumpto "Options" "generate##options"}{...}
{viewerjumpto "Examples" "generate##examples"}{...}
{viewerjumpto "Video examples" "generate##video"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[D] generate} {hline 2}}Create or change contents of variable{p_end}
{p2col:}({mansection D generate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Create new variable

{p 8 17 2}
{opt g:enerate}
{dtype}
{newvar}[{cmd::}{it:lblname}] {cmd:=}{it:{help exp}}
{ifin} [{cmd:,} {opth b:efore(varname)} | {opth a:fter(varname)}]


{phang}
Replace contents of existing variable

{p 8 17 2}
{cmd:replace}
{it:oldvar}
{cmd:=}{it:{help exp}}
{ifin}
[{cmd:,} {opt nop:romote}]


{phang}
Specify default storage type assigned to new variables

{p 8 17 2}
{cmd:set}
{opt ty:pe} {c -(}{opt float}{c |}{opt double}{c )-}
[{cmd:,} {opt perm:anently}]


{phang}
where {it:type} is one of{break}
	{opt byte}{c |}{opt int}{c |}{opt long}{c |}{opt float}{c |}{opt double}{c |}{opt str}{c |}{opt str1}{c |}{opt str2}{c |}...{c |}{cmd:str{ccl maxstrvarlen}}

{phang}
See {help generate##description:{it:Description}} below for an explanation of
{opt str}.  For the other types, see {manhelp data_types D:Data types}.

{phang}
{opt by} is allowed with {opt generate} and {opt replace}; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

    {title:generate}

{phang2}
{bf:Data > Create or change data > Create new variable}

    {title:replace}

{phang2}
{bf:Data > Create or change data > Change contents of variable}


{marker description}{...}
{title:Description}

{pstd}
{opt generate} creates a new variable.  The values of the variable are
specified by {cmd:=}{it:{help exp}}.

{pstd}
If no {it:{help data types:type}} is specified, the new variable type is
determined by the type of result returned by {cmd:=}{it:exp}.  A {opt float}
variable (or a {opt double}, according to {opt set type}) is created if the
result is numeric, and a string variable is created if the result is a string.
In the latter case, if the string variable contains values greater than
2,045 characters or contains values with a binary 0 ({cmd:\0}), a {cmd:strL}
variable is created.  Otherwise, a {opt str}{it:#} variable is created, where
{it:#} is the smallest string that will hold the result.

{pstd}
If a {it:type} is specified, the result returned by {cmd:=}{it:exp} must
be string or numeric according to whether {it:type} is string or numeric.  If
{opt str} is specified, a {cmd:strL} or a {opt str}{it:#} variable is created
using the same rules as above.

{pstd}
See {manhelp egen D} for extensions to {opt generate}.

{pstd}
{opt replace} changes the contents of an existing variable.
Because {opt replace} alters data, the command cannot be abbreviated.

{pstd}
{opt set type} specifies the default storage type assigned to new variables
(such as those created by {opt generate}) when the storage type is not
explicitly specified.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D generateQuickstart:Quick start}

        {mansection D generateRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth before(varname)} or {opth after(varname)} may be used with
{cmd:generate} to place the newly generated variable in a specific position
within the dataset.  These options are primarily used by the Data Editor and
are of limited use in other contexts.  A more popular alternative for most
users is {helpb order}.

{phang}
{opt nopromote} prevents {opt replace} from promoting the 
{help data types:variable type} to accommodate the change.  For instance,
consider a variable stored as an integer type ({opt byte}, {opt int}, or
{opt long}), and assume that you {opt replace} some values with nonintegers.
By default, {opt replace} changes the variable type to a floating point
({opt float} or {opt double}) and thus correctly stores the changed
values.  Similarly, {opt replace} promotes {opt byte} and {opt int}
variables to longer integers ({opt int} and {opt long}) if the replacement
value is an integer but is too large in absolute value for the current storage
type.  {opt replace} promotes strings to longer strings.  {opt nopromote}
prevents {opt replace} from doing this; instead, the replacement values are
truncated to fit the current storage type.

{phang}
{opt permanently} specifies that, in addition to making the change right now,
the new limit be remembered and become the default setting when you invoke
Stata.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse genxmpl3}

{pstd}Create new variable {cmd:age2} containing the values of {cmd:age}
squared{p_end}
{phang2}{cmd:. generate age2 = age^2}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse genxmpl3, clear}

{pstd}Create variable {cmd:age2} with a storage type of {cmd:int} and
containing the values of {cmd:age} squared{p_end}
{phang2}{cmd:. generate int age2 = age^2}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse genxmpl1, clear}

{pstd}Replace the values in {cmd:age2} with those of {cmd:age^2}{p_end}
{phang2}{cmd:. replace age2 = age^2}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse genxmpl2, clear}

{pstd}List the {cmd:name} variable{p_end}
{phang2}{cmd:. list name}

{pstd}Create variable {cmd:lastname} containing the second word of {cmd:name}
{p_end}
{phang2}{cmd:. generate lastname = word(name,2)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse genxmpl3, clear}

{pstd}Create variable {cmd:age2} with a storage type of {cmd:int} and
containing the values of {cmd:age} squared for all observations for which
{cmd:age} is more than 30{p_end}
{phang2}{cmd:. generate int age2 = age^2 if age > 30}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse genxmpl4, clear}

{pstd}Replace the value of {cmd:odd} in the third observation{p_end}
{phang2}{cmd:. replace odd = 5 in 3}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse stan2, clear}

{pstd}Create duplicate of every observation for which {cmd:transplant} is true
(!=0){p_end}
{phang2}{cmd:. expand 2 if transplant}{p_end}

{pstd}Sort observations into ascending order of {cmd:id}{p_end}
{phang2}{cmd:. sort id}

{pstd}Create variable {cmd:posttran}, with storage type of {cmd:byte}, equal
to 1 for the second observation of each {cmd:id} and equal to 0
otherwise{p_end}
{phang2}{cmd:. by id: generate byte posttran = (_n==2)}

{pstd}Create variable {cmd:t1} equal to {cmd:stime} for the last observation
of {cmd:id}{p_end}
{phang2}{cmd:. by id: generate t1 = stime if _n==_N}{p_end}
    {hline}


{marker video}{...}
{title:Video examples}

{phang2}{browse "https://www.youtube.com/watch?v=E_wCh0rf4p8":How to create a new variable that is calculated from other variables}

{phang2}{browse "https://www.youtube.com/watch?v=jIiHb0gsyVo":How to identify and replace unusual data values}
{p_end}
