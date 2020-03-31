{smcl}
{* *! version 1.0.7  02jan2013}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{viewerjumpto "Syntax" "_stubstar2names##syntax"}{...}
{viewerjumpto "Description" "_stubstar2names##description"}{...}
{viewerjumpto "Options" "_stubstar2names##options"}{...}
{viewerjumpto "Examples" "_stubstar2names##examples"}{...}
{viewerjumpto "Stored results" "_stubstar2names##results"}{...}
{title:Title}

{p 4 25 2}
{hi:[P] _stubstar2names} {hline 2} Parsing new variable lists


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_stubstar2names}
	{it:new_var_spec}
	{cmd:,}
	{opt nvars(#)}
	[
		{opt zero}
		{opt outcome}
		{opt single:ok}
		{opt nosubc:ommand}
	]

{phang}
where {it:new_var_spec} is either {it:newvarlist} or {it:stub}{cmd:*}; see
{help newvarlist}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_stubstar2names} is a programmer's tool that helps with parsing a
{it:newvarlist}; see {help newvarlist}.  This tool requires the programmer
to specify how many new variable names are expected. This tool will turn
{it:stub}{cmd:*} into a list of names that begin with {it:stub} and are
indexed by sequential integers.


{marker options}{...}
{title:Options}

{phang}
{opt nvars(#)} is required, and specifies the number of new variable names.

{pmore}
If supplied with {it:newvarlist}, this option enforces that there are {it:#}
names in {it:newvarlist}.

{pmore}
If supplied with {it:stub}{cmd:*}, this option identifies how many names to
generate.  By default, the names will be {it:stub}{cmd:1}, {it:stub}{cmd:2},
... {it:stub#}.

{phang}
{opt zero} indicates that the generated names start with {it:stub}{cmd:0}
instead of {it:stub}{cmd:1}.  This option is only effective when
{cmd:_stubstar2names} is supplied with {it:stub}{cmd:*}.

{phang}
{opt outcome} modifies the error message produced when {it:new_var_spec} is a
{it:newvarlist} with the incorrect number of variables.  By default, the error
message mentions "equations" and the {opt equation()} instead of "outcomes"
and the {opt outcome()}.

{phang}
{opt singleok} indicates that {it:new_var_spec} is allowed to contain one 
name, even if {it:#}>1 in the {opt nvars()} option.

{phang}
{opt nosubcommand} limits the error message display when the list of new
names is not equal to {opt nvars()}.  No reference to the use of option
{bf:equation()} (or {bf:outcome()}) is given.


{marker examples}{...}
{title:Examples}

    {cmd}. _stubstar2names ex*, nvars(5)
    {txt}
    {cmd}. sreturn list

    {txt}macros:
                  s(stub) : "{res}1{txt}"
               s(typlist) : "{res}float float float float float{txt}"
               s(varlist) : "{res}ex1 ex2 ex3 ex4 ex5{txt}"

    {cmd}. _stubstar2names ex, nvars(5)
    {err}too few variables specified
    {txt}{search r(102):r(102);}

    {cmd}. _stubstar2names ex, nvars(5) single
    {txt}
    {cmd}. sreturn list

    {txt}macros:
                  s(stub) : "{res}0{txt}"
               s(typlist) : "{res}float{txt}"
               s(varlist) : "{res}ex{txt}"

    {cmd}. _stubstar2names ex*, nvars(5) zero
    {txt}
    {cmd}. sreturn list

    {txt}macros:
                  s(stub) : "{res}1{txt}"
               s(typlist) : "{res}float float float float float{txt}"
               s(varlist) : "{res}ex0 ex1 ex2 ex3 ex4{txt}"

    {cmd}. _stubstar2names double ex*, nvars(5)
    {txt}
    {cmd}. sreturn list

    {txt}macros:
                  s(stub) : "{res}1{txt}"
               s(typlist) : "{res}double double double double double{txt}"
               s(varlist) : "{res}ex1 ex2 ex3 ex4 ex5{txt}"

    {cmd}. sysuse auto, clear
    {txt}(1978 Automobile Data)

    {cmd}. _stubstar2names ex1 ex2 ex3 mpg, nvars(4)
    {err}mpg already defined
    {txt}{search r(110):r(110);}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_stubstar2names} stores the following in {cmd:s()}:

{p2colset 9 25 32 2}{...}
{pstd}Macros:{p_end}
{p2col :{cmd:s(varlist)}}list of new variable names{p_end}
{p2col :{cmd:s(typlist)}}list of types for the new variables{p_end}
{p2col :{cmd:s(stub)}}{cmd:0},
	or {cmd:1}; indicator for {it:stub}{cmd:*} in {it:new_var_spec}{p_end}
