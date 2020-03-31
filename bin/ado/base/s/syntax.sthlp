{smcl}
{* *! version 1.3.5  20dec2018}{...}
{vieweralsosee "[P] syntax" "mansection P syntax"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 11 Language syntax" "help language"}{...}
{vieweralsosee "[P] program" "help program"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] gettoken" "help gettoken"}{...}
{vieweralsosee "[P] mark" "help mark"}{...}
{vieweralsosee "[P] numlist" "help nlist"}{...}
{vieweralsosee "[P] tokenize" "help tokenize"}{...}
{vieweralsosee "[TS] tsrevar" "help tsrevar"}{...}
{vieweralsosee "[P] unab" "help unab"}{...}
{viewerjumpto "Syntax" "syntax##syntax"}{...}
{viewerjumpto "Description" "syntax##description"}{...}
{viewerjumpto "Links to PDF documentation" "syntax##linkspdf"}{...}
{viewerjumpto "Syntax, continued" "syntax##syntax_cont"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[P] syntax} {hline 2}}Parse Stata syntax{p_end}
{p2col:}({mansection P syntax:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 10 2}{cmd:syntax} {it:description_of_syntax}


{marker description}{...}
{title:Description}

{pstd}
For a general discussion of the Stata language, see {help language}.

{pstd}
There are two ways that a Stata program can interpret what the user types:

{phang2}1.  positionally, meaning first argument, second argument, and so on,
or

{phang2}2.  according to a grammar, such as standard Stata syntax.

{pstd}{cmd:args} does the first; see {manhelp args P:syntax (args)}.

{pstd}
{cmd:syntax} does the second.  You specify the new command's syntax on the
{cmd:syntax} command; for instance, you might code

	{cmd:program myprog}
		{cmd:version {ccl stata_version}}
		{cmd:syntax varlist [if] [in] [, DOF(integer 50) Beta(real 1.0)]}
		(the rest of the program would be coded in
		terms of {cmd:`varlist'}, {cmd:`if'}, {cmd:`in'}, {cmd:`dof'}, and {cmd:`beta'})
		{it:...}
	{cmd:end}

{pstd}
{cmd:syntax} examines what the user typed and attempts to match it to the
syntax diagram.  If it does not match, an error message is issued and the
program is stopped (a nonzero return code is returned).  If it does match, the
individual components are stored in particular local macros where you can
subsequently access them.  In the example above, the result would be to define
the local macros {cmd:`varlist'}, {cmd:`if'}, {cmd:`in'}, {cmd:`dof'}, and
{cmd:`beta'}.

{pstd}
For an introduction to Stata programming, see
{findalias frprograms} and especially
{findalias frarguments}.

{pstd}
Standard Stata syntax is

      {it:cmd} [{it:varlist} | {it:namelist} | {it:anything}]
               [{it:if}]
	       [{it:in}]
	       [{cmdab:usin:g} {it:filename}]
	       [{cmd:=} {it:exp}]
	       [{it:weight}]
	       [{cmd:,} {it:options}]

{pstd}
Each of these building blocks, such as {it:varlist}, {it:namelist}, and
{cmd:if}, is outlined below.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P syntaxRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_cont}{...}
{title:Syntax, continued}

{p 8 10 2}{cmd:syntax} {it:description_of_syntax}

{pstd}
where {it:description_of_syntax} may contain

	{it:{help syntax##description_of_varlist:description_of_varlist}}
	{it:{help syntax##description_of_namelist:description_of_namelist}}
	{it:{help syntax##description_of_anything:description_of_anything}}
	{it:{help syntax##description_of_if:description_of_if}}
	{it:{help syntax##description_of_in:description_of_in}}
	{it:{help syntax##description_of_using:description_of_using}}
	{it:{help syntax##description_of_=exp:description_of_=exp}}
	{it:{help syntax##description_of_weights:description_of_weights}}
	{it:{help syntax##description_of_options:description_of_options}}


{marker description_of_varlist}{...}
{title:description_of_varlist}

	type{col 29}{it:nothing}
     or
	optionally type{col 29}{cmd:[}
	then type one of{col 29}{cmd:varlist}  {cmd:varname}  {cmd:newvarlist}  {cmd:newvarname}
	optionally type{col 29}{cmd:(}{it:varlist_specifiers}{cmd:)}
	type{col 29}{cmd:]}     (if you typed {cmd:[} at the start)

    where {it:varlist_specifiers} are
	{cmd:default=none}
	{cmd:min=}{it:#}
	{cmd:max=}{it:#}
	{cmdab:num:eric}
	{cmdab:str:ing}
	{cmd:str#}
	{cmd:strL}
	{cmd:fv}
	{cmd:ts}
	{cmdab:gen:erate}        ({cmd:newvarlist} and {cmd:newvarname} only)

    Examples:
	{cmd:syntax varlist} {it:...}
	{cmd:syntax [varlist]} {it:...}
	{cmd:syntax varlist(min=2)} {it:...}
	{cmd:syntax varlist(max=4)} {it:...}
	{cmd:syntax varlist(min=2 max=4 numeric)} {it:...}
	{cmd:syntax [varlist(default=none)]} {it:...}
	{cmd:syntax newvarlist} {it:...}
	{cmd:syntax newvarlist(max=1)} {it:...}
	{cmd:syntax varname} {it:...}
	{cmd:syntax [varname]} {it:...}

{pstd}
If you type nothing, the command does not allow a varlist.

{pstd}
Typing {cmd:[} and {cmd:]} means the varlist is optional. 

{pstd}
{cmd:default=} specifies how the varlist is to be filled in when the
varlist is optional and the user does not specify it.  The default is to fill
it in with all the variables.  If {cmd:default=none} is specified, it is left
empty.

{pstd}
{cmd:min} and {cmd:max} specify the minimum and maximum number of
variables that may be specified.  Typing {cmd:varname} is equivalent to typing
{cmd:varlist(max=1)}.

{pstd}
{cmd:numeric}, {cmd:string}, {cmd:str#}, and {cmd:strL} restrict the
specified varlist to consist of entirely numeric, entirely string (meaning
{cmd:str}{it:#} or {cmd:strL}), entirely {cmd:str}{it:#}, or entirely {cmd:strL}
variables.

{pstd}
{cmd:fv} allows the varlist to contain factor variables.

{pstd}
{cmd:ts} allows the varlist to contain time-series operators.

{pstd}
{cmd:generate} specifies, for {cmd:newvarlist} or
{cmd:newvarname}, that the new variables be created and filled in
with missing values.

{pstd}
After the {cmd:syntax} command, the resulting varlist is returned in
{cmd:`varlist'}.  If there are new variables (you coded {cmd:newvarname} or
{cmd:newvarlist}), the macro {cmd:`typlist'} is also defined, containing the
storage type of each of the new variables, listed one after the other.


{marker description_of_namelist}{...}
{title:description_of_namelist}

	type                {it:nothing}
     or
	optionally type     {cmd:[}
	then type one of    {cmd:namelist}  {cmd:name}
	optionally type{col 29}{cmd:(}{it:namelist_specifiers}{cmd:)}
	type{col 29}{cmd:]}    (if you typed {cmd:[} at the start)

    where {it:namelist_specifiers} are

	{cmd:name=}{it:name}
	{cmd:id="}{it:text}{cmd:"}
	{cmd:local}
	{cmd:min=}{it:#}                ({cmd:namelist} only)
	{cmd:max=}{it:#}                ({cmd:namelist} only)

    Examples:
	{cmd:syntax namelist} {it:...}
	{cmd:syntax [namelist]} {it:...}
	{cmd:syntax name(id="equation name")} {it:...}
	{cmd:syntax [namelist(id="equation name")]} {it:...}
	{cmd:syntax namelist(name=eqlist id="equation list")} {it:...}
	{cmd:syntax [name(name=eqname id="equation name")]} {it:...}
	{cmd:syntax namelist(min=2 max=2)} {it:...}

{pstd}
{cmd:namelist} is an alternative to {cmd:varlist}; it relaxes the restriction
that the names the user specifies be of variables.  {cmd:name} is a shorthand
for {cmd:namelist(max=1)}.

{pstd}
{cmd:namelist} is for use when you want the command to have the nearly
standard syntax of command name followed by a list of names (not necessarily
variable names), followed by {cmd:if}, {cmd:in}, {it:options}, etc.
For instance, perhaps the command is to be followed by a list of
variable-label names.

{pstd}
If you type nothing, the command does not allow a namelist.  Typing
{cmd:[} and {cmd:]} means that the namelist is optional.  After the {cmd:syntax}
command, the resulting namelist is returned in {cmd:`namelist'}
unless {cmd:name=}{it:name} is specified, in which case the result is
returned in {cmd:`}{it:name}{cmd:'}.

{pstd}
{cmd:id=} specifies the name of namelist and is used in error messages.  The
default is {cmd:id=namelist}.  If {cmd:namelist} were required and {cmd:id=} was
not specified, and the user typed "{cmd:mycmd} {cmd:if} ..."  (omitting the
namelist), the error message would be "namelist required".  If you specified
{cmd:id="equation name"}, the error message would be "equation name required".

{pstd}
{cmd:name=} specifies the name of the local macro to receive the namelist;
not specifying the option is equivalent to specifying {cmd:name=namelist}.

{pstd}
{cmd:local} specifies that the names that the user specifies are to satisfy the
naming convention for local macro names.  If this option is not specified,
standard naming convention is used (names may begin with a letter or
underscore, may thereafter also include numbers, and must not be longer than
32 characters).  If the user specifies an invalid name, an error message
will be issued.  If {cmd:local} is specified, specified names are allowed
to begin with numbers but may not be longer than 31 characters.


{marker description_of_anything}{...}
{title:description_of_anything}

	type                {it:nothing}
     or
	optionally type     {cmd:[}
	type                {cmd:anything}
	optionally type{col 29}{cmd:(}{it:anything_specifiers}{cmd:)}
	type{col 29}{cmd:]} if you typed {cmd:[} at the start.

    where {it:anything_specifiers} are

	{cmd:name=}{it:name}
	{cmd:id="}{it:text}{cmd:"}
	{cmd:equalok}
	{cmd:everything}

    Examples:
	{cmd:syntax anything} {it:...}
	{cmd:syntax [anything]} {it:...}
	{cmd:syntax anything(id="equation name")} {it:...}
	{cmd:syntax [anything(id="equation name")]} {it:...}
	{cmd:syntax anything(name=eqlist id="equation list")} {it:...}
	{cmd:syntax [anything(name=eqlist id="equation list")]} {it:...}
	{cmd:syntax anything(equalok)} {it:...}
	{cmd:syntax anything(everything)} {it:...}
	{cmd:syntax [anything(name=0 id=clist equalok)]} {it:...}

{pstd}
{cmd:anything} is for use when you want the command to have the nearly
standard syntax of command name followed by something followed by {cmd:if},
{cmd:in}, {it:options}, etc.  For instance, perhaps the command is to be
followed by an expression or expressions, or a list of numbers.

{pstd}
If you type nothing, the command does not allow an "anything".  Typing
{cmd:[} and {cmd:]} means the "anything" is optional.  After the {cmd:syntax}
command, the resulting "anything list" is returned in {cmd:`anything'}
unless {cmd:name=}{it:name} is specified, in which case the result is
returned in {cmd:`}{it:name}{cmd:'}.

{pstd}
{cmd:id=} specifies the name of "anything" and is used only in error messages.
For instance, if {cmd:anything} were required and {cmd:id=} was not specified,
and the user typed "{cmd:mycmd} {cmd:if} ..."  (omitting the "anything"), the
error message would be "something required".  If you specified
{cmd:id="expression list"}, the error message would be "expression list
required".

{pstd}
{cmd:name=} specifies the name of the local macro to receive the "anything";
not specifying the option is equivalent to specifying {cmd:name=anything}.

{pstd}
{cmd:equalok} specifies that {cmd:=} is not to be treated as part of
{cmd:=}{it:exp} in subsequent standard syntax but instead as part of the
{cmd:anything}.

{pstd}
{cmd:everything} specifies that {cmd:if}, {cmd:in}, and {cmd:using} are
not to be treated as part of standard syntax but instead as part of
the {cmd:anything}.

{pstd}
{cmd:varlist}, {cmd:varname}, {cmd:namelist}, {cmd:name}, and {cmd:anything}
are alternatives; you may specify at most one.


{marker description_of_if}{...}
{title:description_of_if}

	type                {it:nothing}
     or
	optionally type     {cmd:[}
	type                {cmd:if}
	optionally type     {cmd:/}
	type                {cmd:]}      (if you typed {cmd:[} at the start)

    Examples:
	{cmd:syntax} {it:...} {cmd:if} {it:...}
	{cmd:syntax} {it:...} {cmd:[if]} {it:...}
	{cmd:syntax} {it:...} {cmd:[if/]} {it:...}
	{cmd:syntax} {it:...} {cmd:if/} {it:...}

{pstd}
If you type nothing, the command does not allow an {cmd:if} {it:exp}.

{pstd}
Typing {cmd:[} and {cmd:]} means that the {cmd:if} {it:exp} is
optional.

{pstd}
After the {cmd:syntax} command, the resulting {cmd:if} {it:exp} is returned in
{cmd:`if'}.  This macro contains {cmd:if} followed by the expression, unless
you specified {cmd:/}, in which case the macro contains just the expression.


{marker description_of_in}{...}
{title:description_of_in}

	type                {it:nothing}
     or
	optionally type     {cmd:[}
	type                {cmd:in}
	optionally type     {cmd:/}
	type                {cmd:]}      (if you typed {cmd:[} at the start)

    Examples:
	{cmd:syntax} {it:...} {cmd:in} {it:...}
	{cmd:syntax} {it:...} {cmd:[in]} {it:...}
	{cmd:syntax} {it:...} {cmd:[in/]} {it:...}
	{cmd:syntax} {it:...} {cmd:in/} {it:...}

{pstd}
If you type nothing, the command does not allow an {cmd:in} {it:range}.

{pstd}
Typing {cmd:[} and {cmd:]} means the {cmd:in} {it:range} is optional.

{pstd}
After the {cmd:syntax} command, the resulting {cmd:in} {it:range} is returned
in {cmd:`in'}.  The macro contains {cmd:in} followed by the range, unless you
typed {cmd:/}, in which case the macro contains just the range.


{marker description_of_using}{...}
{title:description_of_using}

	type                {it:nothing}
     or
	optionally type     {cmd:[}
	type                {cmd:using}
	optionally type     {cmd:/}
	type                {cmd:]}      (if you typed {cmd:[} at the start)

    Examples:
	{cmd:syntax} {it:...} {cmd:using} {it:...}
	{cmd:syntax} {it:...} {cmd:[using]} {it:...}
	{cmd:syntax} {it:...} {cmd:[using/]} {it:...}
	{cmd:syntax} {it:...} {cmd:using/} {it:...}

{pstd}
If you type nothing, the command does not allow {cmd:using} {it:filename}.

{pstd}
Typing {cmd:[} and {cmd:]} means the {cmd:using} {it:filename} is optional.

{pstd}
After the {cmd:syntax} command, the resulting filename is returned in
{cmd:`using'}.  The macro contains {cmd:using} followed by the filename in
quotes, unless you specified {cmd:/}, in which case the macro contains just the
filename without quotes.


{marker description_of_=exp}{...}
{title:description_of_=exp}

	type                {it:nothing}
     or
	optionally type     {cmd:[}
	type                {cmd:=}
	optionally type     {cmd:/}
	type                {cmd:exp}
	type                {cmd:]}      (if you typed {cmd:[} at the start)

    Examples:
	{cmd:syntax} {it:...} {cmd:=exp} {it:...}
	{cmd:syntax} {it:...} {cmd:[=exp]} {it:...}
	{cmd:syntax} {it:...} {cmd:[=/exp]} {it:...}
	{cmd:syntax} {it:...} {cmd:=/exp} {it:...}

{pstd}
If you type nothing, the command does not allow {cmd:=}{it:exp}.

{pstd}
Typing {cmd:[} and {cmd:]} means the {cmd:=}{it:exp} is optional.

{pstd}
After the {cmd:syntax} command, the resulting expression is returned in
{cmd:`exp'}.  The macro contains {cmd:=}, a space, and the expression, unless
you specified {cmd:/}, in which case the macro contains just the expression.


{marker description_of_weights}{...}
{title:description_of_weights}

	type                {it:nothing}
     or
	type                {cmd:[}
	type any of         {cmdab:fw:eight}  {cmdab:aw:eight}  {cmdab:pw:eight}  {cmdab:iw:eight}
	optionally type     {cmd:/}
	type                {cmd:]}

    Examples:
	{cmd:syntax} {it:...} {cmd:[fweight]} {it:...}
	{cmd:syntax} {it:...} {cmd:[fweight pweight]} {it:...}
	{cmd:syntax} {it:...} {cmd:[pweight fweight]} {it:...}
	{cmd:syntax} {it:...} {cmd:[fweight pweight iweight/]} {it:...}

{pstd}
If you type nothing, the command does not allow weights.  A command
may not allow both a weight and a {cmd:=}{it:exp}.

{pstd}
You must type {cmd:[} and {cmd:]}; they are not optional.  Weights are always
optional.

{pstd}
The first weight specified is the default weight type.

{pstd}
After the {cmd:syntax} command, the resulting weight and expression are
returned in {cmd:`weight'} and {cmd:`exp'}.  {cmd:`weight'} contains the
weight type or nothing if no weights were specified.  {cmd:`exp'} contains
{cmd:=}, a space, and the expression, unless you specified {cmd:/}, in which
case {cmd:`exp'} contains just the expression.


{marker description_of_options}{...}
{title:description_of_options}

	type                {it:nothing}
     or
	type                {cmd:[,}
	type                {it:option_descriptors} (these options will be optional)
	optionally type     {cmd:*}
	type                {cmd:]}
     or
	type                {cmd:,}
	type                {it:option_descriptors} (these options will be required)
	optionally type     {cmd:[}
	optionally type     {it:option_descriptors} (these options will be optional)
	optionally type     {cmd:*}
	optionally type     {cmd:]}

    Examples:
	{cmd:syntax} {it:...} {cmd:[, MYopt Thisopt]}
	{cmd:syntax} {it:...} {cmd:, MYopt Thisopt}
	{cmd:syntax} {it:...} {cmd:, MYopt [Thisopt]}
	{cmd:syntax} {it:...} {cmd:[, MYopt Thisopt *]}

{pstd}
If you type nothing, the command does not allow options.

{pstd}
The brackets distinguish optional from required options.  All options can be 
optional, all options can be required, or some can be optional and other be
required.

{pstd}
After the {cmd:syntax} command, options are returned to you in local macros
based on the first 31 letters of each option's name.  If you also specify
{cmd:*}, any remaining options are collected and placed, one after the other
in {cmd:`options'}.  If you do not specify {cmd:*}, an error is returned if
the user specifies any options that you do not list.

{pstd}
The {it:option_descriptors} include

		{it:{help syntax##optionally_on:optionally_on}}
		{it:{help syntax##optionally_off:optionally_off}}
		{it:{help syntax##optional_integer_value:optional_integer_value}}
		{it:{help syntax##optional_real_value:optional_real_value}}
		{it:{help syntax##optional_confidence_interval:optional_confidence_interval}}
		{it:{help syntax##optional_credible_interval:optional_credible_interval}}
		{it:{help syntax##optional_numlist:optional_numlist}}
		{it:{help syntax##optional_varlist:optional_varlist}}
		{it:{help syntax##optional_namelist:optional_namelist}}
		{it:{help syntax##optional_string:optional_string}}
		{it:{help syntax##optional_passthru:optional_passthru}}


{marker optionally_on}{...}
{title:option_descriptor optionally_on}

	type                {it:OPname}   (capitalization indicates minimal
	                                   abbreviation)

    Examples:
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:replace} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:REPLACE} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:detail} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:Detail} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:CONStant} {it:...}

{pstd}
The result of the option is returned in a macro name formed by the first
31 letters of the option's name.  Thus option {cmd:replace} is returned in
local macro {cmd:`replace'}; option {cmd:detail}, in local macro
{cmd:`detail'}; and option {cmd:constant}, in local macro {cmd:`constant'}.

{pstd}
The macro contains nothing if not specified, or else it contains the macro's
name, fully spelled out.

{pstd}
Warning:  Be careful if the first two letters of the option's name are
{cmd:no}, such as the option called {cmd:notice}.  You must capitalize at
least the {cmd:N} in such cases.


{marker optionally_off}{...}
{title:option_descriptor optionally_off}

	type                {cmd:no}
	type                {it:OPname}   (capitalization indicates minimal
	                                   abbreviation)

    Examples:
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:noreplace} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:noREPLACE} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:nodetail} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:noDetail} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:noCONStant} {it:...}

{pstd}
The result of the option is returned in a macro name formed by the first
31 letters of the option's name, excluding the {cmd:no}.  Thus option
{cmd:noreplace} is returned in local macro {cmd:`replace'}; option
{cmd:nodetail}, in local macro {cmd:`detail'}; and option {cmd:noconstant}, in
local macro {cmd:`constant'}.

{pstd}
The macro contains nothing if not specified, or else it contains the macro's
name, fully spelled out, with a {cmd:no} prefixed.  That is, in the 
{cmd:noREPLACE} example above, macro {cmd:`replace'} contains nothing,
or it contains {cmd:noreplace}.


{marker optional_integer_value}{...}
{title:option_descriptor optional_integer_value}

	type                {it:OPname}   (capitalization indicates minimal
	                                   abbreviation)
	type                {cmd:(integer}
	type                {it:#} (unless the option is required) 
	                      (the default integer value)
	type                {cmd:)}

    Examples:
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:Count(integer 3)} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:SEQuence(integer 1)} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:dof(integer -1)} {it:...}

{pstd}
The result of the option is returned in a macro name formed by the first
31 letters of the option's name.

{pstd}
The macro contains the integer specified by the user, or else it contains 
the default value.


{marker optional_real_value}{...}
{title:option_descriptor optional_real_value}

	type                {it:OPname}   (capitalization indicates minimal
	                                   abbreviation)
	type                {cmd:(real}
	type                {it:#} (unless the option is required)
	                      (the default value)
	type                {cmd:)}

    Examples:
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:Mean(real 2.5)} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:SD(real -1)} {it:...}

{pstd}
The result of the option is returned in a macro name formed by the first
31 letters of the option's name.

{pstd}
The macro contains the real number specified by the user, or else it contains
the default value.


{marker optional_confidence_interval}{...}
{title:option_descriptor optional_confidence_interval}

	type		    {it:OPname}   (capitalization indicates minimal
	                                   abbreviation)
	type		    {cmd:(cilevel)}
	
    Example:
        {cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:Level(cilevel)} {it:...}
        
{pstd}
The result of the option is returned in a macro name formed by the first
31 letters of the option's name.

{pstd}
If the user specifies a valid level for a confidence interval, the macro
contains that value; see {manhelp level R}.  If the user specifies an invalid
level, an error message is issued, and the return code is 198.

{pstd}
If the user does not type this option, the macro contains the current
default level obtained from {cmd:c(level)}.

{marker optional_credible_interval}{...}
{title:option_descriptor optional_credible_interval}

	type		    {it:OPname}   (capitalization indicates minimal
	                                   abbreviation)
	type		    {cmd:(crlevel)}
	
    Example:
        {cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:CLEVel(crlevel)} {it:...}
        
{pstd}
The result of the option is returned in a macro name formed by the first
31 letters of the option's name.

{pstd}
If the user specifies a valid level for a credible interval, the macro
contains that value; see {manhelp clevel BAYES}.  If the user specifies an
invalid level, an error message is issued, and the return code is 198.

{pstd}
If the user does not type this option, the macro contains the current
default level obtained from {cmd:c(clevel)}.


{marker optional_numlist}{...}
{title:option_descriptor optional_numlist}

	type                {it:OPname}   (capitalization indicates minimal
	                                   abbreviation)
	type                {cmd:(numlist}
	type                {cmdab:asc:ending}  or  {cmdab:desc:ending}  or {it:nothing}
	optionally type     {cmdab:int:eger}
	optionally type     {cmdab:miss:ingokay}
	optionally type     {cmd:min=}{it:#}
	optionally type     {cmd:max=}{it:#}
	optionally type     {cmd:>}{it:#}  or  {cmd:>=}{it:#}   or {it:nothing}
	optionally type     {cmd:<}{it:#}  or  {cmd:<=}{it:#}   or {it:nothing}
	optionally type     {cmd:sort}
	type                {cmd:)}

    Examples:
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:VALues(numlist)} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:VALues(numlist max=10 sort)} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:TIME(numlist >0)} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:FREQuency(numlist >0 integer)} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:OCCur(numlist missingokay >=0 <1e+9)} {it:...}

{pstd}
The result of the option is returned in a macro name formed by the first
31 letters of the option's name.

{pstd}
The macro contains the values specified by the user, but listed out, one after
the other.  For instance, the user might specify {hi:time(1(1)4,10)} so that
the local macro {cmd:`time'} would contain "{hi:1 2 3 4 10}".

{pstd}
{cmd:min} and {cmd:max} specify the minimum and maximum number of elements
that may be in the list.

{pstd}
{cmd:<}, {cmd:<=}, {cmd:>}, and {cmd:>=} specify the range of elements allowed
in the list.

{pstd}
{cmd:integer} indicates that the user may specify integer values only.

{pstd}
{cmd:missingokay} indicates that the user may specify
{help missing:missing values} as list elements.

{pstd}
{cmd:ascending} specifies that the user must give the list in ascending order
without repeated values.  {cmd:descending} specifies that the user must
give the list in descending order without repeated values.

{pstd}
{cmd:sort} specifies that the list be sorted before being returned.
Distinguish this from modifier {cmd:ascending}, which states that the user
must type the list in ascending order.  {cmd:sort} says the user may type the
list in any order but it is to be returned in ascending order.
{cmd:ascending} states that the list may have no repeated elements.
{cmd:sort} places no such restriction on the list.


{marker optional_varlist}{...}
{title:option_descriptor optional_varlist}

	type                {it:OPname}   (capitalization indicates minimal
	                                   abbreviation)
	type                {cmd:(varlist}   or   {cmd:(varname}
	optionally type     {cmdab:num:eric}    or   {cmdab:str:ing}
	optionally type     {cmd:min=}{it:#}
	optionally type     {cmd:max=}{it:#}
	optionally type     {cmd:fv}
	optionally type     {cmd:ts}
	type                {cmd:)}

    Examples:
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:ROW(varname)} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:BY(varlist)} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:Counts(varname numeric)} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:TItlevar(varname string)} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:Sizes(varlist numeric min=2 max=10)} {it:...}

{pstd}
The result of the option is returned in a macro name formed by the first
31 letters of the option's name.

{pstd}
The macro contains the names specified by the user, listed one after the
other.

{pstd}
{cmd:min} indicates the minimum number of variables to be specified if the
option is given.  {hi:min=1} is the default.

{pstd}
{cmd:max} indicates the maximum number of variables that may be specified
if the option is given.  {hi:max=800} is the default for {cmd:varlist}
(you may set it to be larger), and {hi:max=1} is the default for {cmd:varname}.

{pstd}
{cmd:numeric} specifies that the variable list must consist entirely
of numeric variables.  {cmd:string} specifies that the variable list
must consist entirely of string variables, meaning {cmd:str}{it:#} or
{cmd:strL}.  {cmd:str#} and {cmd:strL} specify that the variable list
must consist entirely of {cmd:str}{it:#} or {cmd:strL} variables,
respectively.

{pstd}
{cmd:fv} specifies that the variable list may contain factor variables.

{pstd}
{cmd:ts} specifies that the variable list may contain time-series operators.


{marker optional_namelist}{...}
{title:option_descriptor optional_namelist}

	type                {it:OPname}   (capitalization indicates minimal
	                                   abbreviation)
	type                {cmd:(namelist}   or   {cmd:(name}
	optionally type     {cmd:min=}{it:#}
	optionally type     {cmd:max=}{it:#}
	optionally type     {cmd:local}
	type                {cmd:)}

    Examples:
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:GENerate(name)} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:MATrix(name)} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:REsults(namelist min=2 max=10)} {it:...}

{pstd}
The result of the option is returned in a macro name formed by the first
31 letters of the option's name.

{pstd}
The macro contains the variables specified by the user, listed one after the
other.

{pstd}
Do not confuse {cmd:namelist} with {cmd:varlist}.  {cmd:varlist} is the
appropriate way to specify an option that is to receive the names of existing
variables.  {cmd:namelist} is the appropriate way to collect names of other
things -- such as matrices -- and {cmd:namelist} is sometimes
used to obtain the name of a new variable to be created.  It is then
your responsibility to verify that the name specified does not already
exist as a Stata variable.

{pstd}
{cmd:min} indicates the minimum number of names to be specified if the
option is given.  {hi:min=1} is the default.

{pstd}
{cmd:max} indicates the maximum number of names that may be specified
if the option is given.  The default is {hi:max=1} for {cmd:name}.  For
{cmd:namelist}, the default is the maximum number of variables allowed in
Stata.

{pstd}
{cmd:local} specifies that the names the user specifies are to satisfy the
naming convention for local macro names.


{marker optional_string}{...}
{title:option_descriptor optional_string}

	type                {it:OPname}   (capitalization indicates minimal
	                                   abbreviation)
	type                {cmdab:(str:ing}
	optionally type     {cmd:asis}
	type                {cmd:)}

    Examples:
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:Title(string)} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:XTRAvars(string)} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:SAVing(string asis)} {it:...}

{pstd}
The result of the option is returned in a macro name formed by the first
31 letters of the option's name.

{pstd}
The macro contains the string specified by the user, or else it contains
nothing.

{pstd}
{cmd:asis} specifies that the option's arguments be returned just as
the user typed them, with quotes (if specified) and with leading and trailing
blanks.  {cmd:asis} should be specified if the option's arguments might
contain suboptions or expressions that contain quoted strings.  If you
specify {cmd:asis}, be sure to use compound double quotes when referring to
the macro.


{marker optional_passthru}{...}
{title:option_descriptor optional_passthru}

	type                {it:OPname}   (capitalization indicates minimal
	                                   abbreviation)
	type                {cmd:(passthru)}

    Examples:
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:Title(passthru)} {it:...}
	{cmd:syntax} {it:...} {cmd:,} {it:...} {cmd:SAVing(passthru)} {it:...}

{pstd}
The result of the option is returned in a macro name formed by the first
31 letters of the option's name.

{pstd}
The macro contains the full option -- unabbreviated option name,
parentheses, and argument -- as specified by the user, or it contains
nothing.  For instance, were the user
to type {hi:ti("My Title")}, the macro would contain {hi:title("My Title")}.
{p_end}
