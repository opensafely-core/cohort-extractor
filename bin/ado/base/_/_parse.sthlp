{smcl}
{* *! version 1.0.7  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] gettoken" "help gettoken"}{...}
{vieweralsosee "[G-2] graph" "help graph"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{viewerjumpto "Syntax" "_parse##syntax"}{...}
{viewerjumpto "Description" "_parse##description"}{...}
{viewerjumpto "" "--"}{...}
{viewerjumpto "Description of _parse expand" "_parse##description_expand"}{...}
{viewerjumpto "Description of _parse canonicalize" "_parse##description_canonicalize"}{...}
{viewerjumpto "Description of _parse factor" "_parse##description_factor"}{...}
{viewerjumpto "Description of _parse factordot" "_parse##description_factordot"}{...}
{viewerjumpto "Description of _parse combine" "_parse##description_combine"}{...}
{viewerjumpto "Description of _parse combop" "_parse##description_combop"}{...}
{viewerjumpto "Description of _parse expandarg" "_parse##description_expandarg"}{...}
{viewerjumpto "Description of _parse comma" "_parse##description_comma"}{...}
{viewerjumpto "" "--"}{...}
{viewerjumpto "Options for use with _parse expand" "_parse##options_expand"}{...}
{viewerjumpto "Options for use with _parse canonicalize" "_parse##options_canonicalize"}{...}
{viewerjumpto "Options for use with _parse factor" "_parse##options_factor"}{...}
{viewerjumpto "Option for use with _parse factordot" "_parse##option_factordot"}{...}
{viewerjumpto "Options for use with _parse combop" "_parse##options_combop"}{...}
{viewerjumpto "Options for use with _parse expandarg" "_parse##options_expandarg"}{...}
{title:Title}

{p 4 16 2}
{hi:[P] _parse} {hline 2} Extended parsing


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:_parse}
{cmd:expand}
{it:lcstub}
{it:lgstub}
{cmd::}{space 1}{it:lin}
[{cmd:,}
{cmdab:com:mon:(}{it:opnamelist}{cmd:)}
{opt gw:eight}
]

{p 8 15 2}
{cmd:_parse}
{cmdab:canon:icalize}
{it:lres}
{cmd::}{space 1}{it:lcstub}
{it:lgstub}
[{cmd:,}
{cmd:drop}
{opt gw:eight}
]

{p 8 15 2}
{cmd:_parse}
{cmd:factor}
{it:lnew}
{cmd::}{space 1}{it:lold}{cmd:,}
{cmdab:op:tion:(}{it:OPname}{cmd:)}
[
{cmd:to(}{it:str}{cmd:X}{it:ing}{cmd:)}
{cmd:n(}{it:#}{cmd:)}
{cmdab:rmq:uotes}
]

{p 8 15 2}
{cmd:_parse}
{cmd:factordot}
{it:lnew}
{cmd::}{space 1}{it:lold}{cmd:,}
{cmd:n(}{it:#}{cmd:)}

{p 8 15 2}
{cmd:_parse}
{cmd:combine}
{it:lnew}
{cmd::}{space 1}{it:lold}

{p 8 15 2}
{cmd:_parse}
{cmd:combop}
{it:lnew}
{cmd::}{space 1}{it:lold}{cmd:,}
{cmdab:op:tion:(}{it:OPname}{cmd:)}
[
{cmdab:ops:in}
{cmdab:r:ightmost}
]

{p 8 15 2}
{cmd:_parse}
{cmd:expandarg}
{it:lnew}
{cmd::}{space 1}{it:lold}{cmd:,}
{cmd:n(}{it:#}{cmd:)}
{cmdab:op:tion:(}{it:string}{cmd:)}

{p 8 15 2}
{cmd:_parse}
{cmd:comma}
{it:lhs}
{it:rhs}
{cmd::}
{it:lin}

{pstd}
where
{it:lcstub} and {it:lgstub} are the stub of local macronames and
{it:lin},
{it:lres},
{it:lhs},
{it:rhs},
{it:lnew}, and
{it:lold} are macronames,

{pstd}
and where

{p 8 15 2}
{it:opnamelist} :=
{it:op}
[{it:op} [...]]

{p 16 22 2}
{it:op} :=
{it:OPname}{break}
{it:OPname}{cmd:(}[{it:string}]{cmd:)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_parse} provides a suite of commands to assist in the parsing of
complicated syntaxes and, in particular, the {helpb graph} syntax.


{marker description_expand}{...}
{title:Description of _parse expand}

{pstd}
{cmd:_parse} {cmd:expand} parses the contents of local macro {it:lin} and
creates local macros

	{it:lcstub}{cmd:_n}     number of subcommands
	{it:lcstub}{cmd:_1}     first subcommand (without parentheses)
	{it:lcstub}{cmd:_2}     second subcommand (without parentheses)
	...
	{it:lgstub}{cmd:_if}	global (common) if (contains "{cmd:if} {it:exp}" or "")
	{it:lgstub}{cmd:_in}	global (common) in (contains "{cmd:in} {it:range}" or "")
	{it:lgstub}{cmd:_op}	global (common) options (without leading comma)

{pstd}
{it:lin} is assumed to contain something of the form allowed by {helpb graph},
which is to say,

{phang2}
[{it:el}
[{it:el}
[...]]]

{pstd}
where

{p 16 22 2}
{it:el} :=
{cmd:(}{it:cmd}{cmd:)} [{it:el}]{break}
{cmd:(}{it:cmd}{cmd:)} {cmd:||} [{it:el}]{break}
{it:cmd} {cmd:||} [{it:el}]{break}
{it:cmd}{break}
{cmd:,} {it:ops}{break}
{cmd:,} {it:ops}{cmd:,} [{it:el}]{break}
{cmd:,} {it:ops} {cmd:||} [{it:el}]

{p 15 22 2}
{it:cmd} :=
{it:string}{cmd:,} {it:ops}{cmd:,} {it:cmd}{break}
{it:string}{cmd:,} {it:ops}{break}
{it:string}

{pstd}
and where {it:string} is any nonempty string of characters, correctly nested
if it contains quotes, parenthesis, or brackets.

{pstd}
With the {opt gweight} option, {cmd:_parse} {cmd:expand} will also create
local macro

	{it:lgstub}{cmd:_wt}	global (common) weight (contains "{weight}" or "")



{marker description_canonicalize}{...}
{title:Description of _parse canonicalize}

{pstd}
{cmd:_parse} {cmd:canonicalize} takes the output left behind by
{cmd:_parse} {cmd:expand} and returns in {it:lres} the command in
canonical form.  For instance, consider the command pair

	{cmd:_parse expand cmd op : 0}
	{cmd:_parse canon c : cmd op}

{pstd}
The above two commands would result in:

	{cmd:`0'}    a b c if mpg in 1/2, op1 op2
	{cmd:`c'}    a b c if mpg in 1/2, op1 op2

	{cmd:`0'}    a b c if mpg in 1/2, op1 op2 || d e if mpg, op3 ||, op4
	{cmd:`c'}    (a b c if mpg in 1/2, op1 op2) (d e if mpg, op3), op4

	{cmd:`0'}    a b c, op1, if mpg in 1/2, op2 || d e if mpg, op3 ||, op4
	{cmd:`c'}    (a b c if mpg in 1/2, op1 op2) (d e if mpg, op3), op4

	{cmd:`0'}    a b c, op1, if mpg in 1/2, op2 (d e if mpg, op3) ||, op4
	{cmd:`c'}    (a b c if mpg in 1/2, op1 op2) (d e if mpg, op3), op4


{marker description_factor}{...}
{title:Description of _parse factor}

{pstd}
{cmd:_parse factor} creates local macro {it:lnew} from local macro {it:lold}.
{it:lold} is assumed to contain something resembling a Stata command in
canonical form, that is,

{phang2}
{it:string}[{cmd:,} {it:options}]

{pstd}
{it:lin} could be, for instance, one of the {it:lcstub}{cmd:_}{it:#} macros
returned by {cmd:_parse} {cmd:_expand}.

{pstd}
In any case, {cmd:_parse} {cmd:factor} does two related things:

{phang2}
1.  It searches {it:options} for
{cmd:p}{it:#}{cmd:(}...{it:opname}{cmd:(}{it:arg}{cmd:)}...{cmd:)}
and replaces the {it:opname}{cmd:(}{it:arg}{cmd:)} part with {it:arg}
processed through the {cmd:to()} filter.

{phang2}
2.  It searches {it:options} for {it:opname}{cmd:(}{it:arg_1} [{it:arg_2}
[...]]{cmd:)}.  If found, the option is removed and each of {it:arg_1},
{it:arg_2}, ..., processed through the {cmd:to()} filter, and used to produce a
new set of options {cmd:p1()}, {cmd:p2()}, etc.

{pstd}
The {cmd:to()} filter must contain a capital {cmd:X}, and
processing an argument through the {cmd:to()} filter is defined as substituting
the argument for {cmd:X}.  For instance, if an argument were "{cmd:red}" and
the {cmd:to()} filter "{cmd:color(X)}", the result would be
"{cmd:color(red)}".

{pstd}
Consider the command

{phang2}
{cmd:_parse}
{cmd:factor}
{it:lnew}
{cmd::}{space 1}{it:lold}{cmd:,}
{cmd:option(LColor)}
{cmd:to(color(X))}

{pstd}
run on local macro {it:lold} containing

{phang2}
{cmd:xy v1 v2 v3, titl("mytitle") p3(lc(green)) lc(red blue) bold}

{pstd}
The result would be to place

{phang2}
{cmd:xy v1 v2 v3, titl("mytitle") bold p3(color(green)) p1(color(red)) p2(color(blue))}

{pstd}
in local macro {it:lnew}.

{pstd}
If the specified option is not found, {it:lnew}={it:lold} is returned.

{pstd}
When
{it:opname}{cmd:()} occurs outside of {cmd:p}{it:#}{cmd:()} (that is, case 2),
{cmd:_parse} {cmd:factor} also understands {it:opname}{cmd:()} containing
"{cmd:=}" and "{cmd:..}"{space 1}and "{cmd:...}".  {cmd:=} is understood to
mean "repeat the previous argument", for example, {it:lold} containing

{phang2}
{cmd:xy v1 v2 v3, lc(red = =)}

{pstd}
would expand to

{phang2}
{cmd:xy v1 v2 v3, p1(color(red)) p2(color(red)) p3(color(red))}

{pstd}
{cmd:..}{space 1}and {cmd:...}{space 1}(which are synonyms) expand into option
{cmd:pstar()}:

{phang2}
{cmd:xy v1 v2 v3, lc(blue red ...)}

{pstd}
becomes

{phang2}
{cmd:xy v1 v2 v3, p1(color(blue)) pstar(2 color(red))}

{pstd}
It is the job of {cmd:_parse} {cmd:factordot} to finish the expansion.


{marker description_factordot}{...}
{title:Description of _parse factordot}

{pstd}
{cmd:_parse} {cmd:factordot} looks for {cmd:pstar()} options created by
{cmd:_parse} {cmd:factor} and finishes the expansion.  For instance,

{phang2}
{cmd:xy v1 v2 v3, p1(color(blue)) pstar(2 color(red))}

{pstd}
becomes

{phang2}
{cmd:xy v1 v2 v3, p1(color(blue)) p2(color(red)) p3(color(red))}

{pstd}
if {cmd:n()} is 3.  With {cmd:n(2)}, it becomes

{phang2}
{cmd:xy v1 v2 v3, p1(color(blue)) p2(color(red))}

{pstd}
and with {cmd:n(1)} it becomes

{phang2}
{cmd:xy v1 v2 v3, p1(color(blue))}


{marker description_combine}{...}
{title:Description of _parse combine}

{pstd}
{cmd:_parse} {cmd:combine} brings all {cmd:p1()} options together,
all {cmd:p2()} options together, and so on.  For instance,

{phang2}
{cmd:xy v1 v2 v3, p1(color(blue)) p2(color(red)) p1(style(a)) p2(style(b))}

{pstd}
becomes

{phang2}
{cmd:xy v1 v2 v3, p1(color(blue) style(a)) p2(color(red) style(b))}


{marker description_combop}{...}
{title:Description of _parse combop}

{pstd}
{cmd:_parse combop} creates local macro {it:lnew} from local macro {it:lold},
removing repeated instances of an option.  If option {cmd:opsin} is not
specified, {it:lold} is assumed to contain something resembling a Stata
command in canonical form, that is,

{phang2}
{it:string}[{cmd:,} {it:options}]

{pstd}
Otherwise, {it:lold} is assumed to contain something of the form

{phang2}
[{it:options}]

{pstd}
In either case, returned is the original, with multiple instances of
{it:OPname}{cmd:()} removed.  If option {cmd:rightmost} is not specified,
all instances of {it:OPname}{cmd:()} are brought together into one 
instance of {it:OPname}{cmd:()}.  For example

	{cmd}. local input "cmd a b c, lab(1 2) noorigin label(3 4)"
	{txt}
	{cmd}. _parse combop output : input, option(LAbel)
	{txt}
	{cmd}. display "`output'"
	{res}cmd a b c, noorigin label(1 2 3 4){txt}

{pstd}
If option {cmd:rightmost} is specified, only the rightmost option is kept:

	{cmd}. local input "cmd a b c, lab(1 2) noorigin label(3 4)"
	{txt}
	{cmd}. _parse combop output : input, option(LAbel) rightmost
	{txt}
	{cmd}. display "`output'"
	{res}cmd a b c, noorigin label(3 4){txt}


{marker description_expandarg}{...}
{title:Description of _parse expandarg}

{pstd}
{cmd:_parse} {cmd:expandarg} expands an argument string for {cmd:=} and
{cmd:..}[{cmd:.}].  Note that {cmd:_parse} {cmd:factor} and {cmd:_parse}
{cmd:factordot} already do this.  {cmd:_parse} {cmd:expandarg} is for the
special case where you have already extracted an argument and want to expand
it.

{pstd}
For instance, if {it:lold} contained "{cmd:a = b}", the result would be
"{cmd:a a b}".
If {it:lold} contained "{cmd:a b ..}" and it was expanded with {cmd:n(4)},
the result would be "{cmd:a b b b}".


{marker description_comma}{...}
{title:Description of _parse comma}

{pstd}
{cmd:_parse} {cmd:comma} looks for the first unbound comma in {it:lin} and
splits the string into {it:lhs} and {it:rhs}.  Both {it:lhs} and {it:rhs} are
trimmed of leading and trailing blanks.  The first character of {it:rhs} will
be comma if {it:lin} contained an unbound comma.

{pstd}
Unbound in the above is a comma outside of quotes, parentheses, or brackets.


{marker options_expand}{...}
{title:Options for use with _parse expand}

{phang}
{cmd:common(}{it:opnamelist}{cmd:)} specifies options common to the
    subcommands.

{phang}
{opt gweight} specifies parsing for global weights.


{marker options_canonicalize}{...}
{title:Options for use with _parse canonicalize}

{phang}
{cmd:drop} specifies that the macros left behind by the previous {cmd:_parse}
    {cmd:expand} command are to be dropped.

{phang}
{opt gweight} specifies that local macro {it:lgstub}{cmd:_wt} is to be
    consumed in addition to the local macros for common if, common in, and
    common options.


{marker options_factor}{...}
{title:Options for use with _parse factor}

{phang}
{cmd:option(}{it:OPname}{cmd:)} specifies the option to be consumed.
    {cmd:option()} is not optional.  Capitalization of {it:OPname}
    indicates minimal abbreviation.

{phang}
{cmd:to(}{it:str}{cmd:X}{it:ing}{cmd:)} specifies the template for
    creating expanded options.  Arguments specified by the user will
    be substituted for {cmd:X}.  {cmd:X} may occur up to twice in
    {it:str}{cmd:X}{it:ing}.

{phang}
{cmd:n(}{it:#}{cmd:)} specifies the maximum number of {cmd:p}{it:#}{cmd:()}
    options to be allowed.  If {cmd:n()} is specified and if the user
    specifies {it:opname}{cmd:()} with more arguments than that, a "too many
    arguments" error message will be generated.

{phang}
{cmd:rmquotes} specifies that quotes are to be removed from any arguments
    that are specified by the user.


{marker option_factordot}{...}
{title:Option for use with _parse factordot}

{phang}
{cmd:n(}{it:#}{cmd:)} is not optional. It specifies the maximum index of the
    {cmd:p}{it:#}{cmd:()} options to be created.


{marker options_combop}{...}
{title:Options for use with _parse combop}

{phang}
{cmd:option(}{it:OPname}{cmd:)} specifies the option to be consumed.
    {cmd:option()} is not optional.  Capitalization of {it:OPname}
    indicates minimal abbreviation.

{phang}
{cmd:opsin} specifies that {it:lold} contains {it:options} without a
    leading comma.  The default is to assume that {it:lold} contains
    standard Stata syntax in canonical form.

{phang}
{cmd:rightmost} specifies that only the rightmost instance of
    {it:OPname}{cmd:()} is to be kept.  The default is to combine instances
    of {it:OPname}{cmd:()}.


{marker options_expandarg}{...}
{title:Options for use with _parse expandarg}

{phang}
{cmd:n(}{it:#}{cmd:)} is not optional. It specifies the maximum number of
    arguments for expansion of {cmd:..}[{cmd:.}].

{phang}
{cmd:option(}{it:string}{cmd:)} is not optional. It specifies the name of the
    option for which {it:lold} is an argument, and will be used for error
    messages if {it:lold} contains incorrect syntax such as
    "{cmd:a b ... c}", in which case the error message would be
    "{it:string}{cmd:(a b ... c):  option invalid}".
{p_end}
