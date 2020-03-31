{smcl}
{* *! version 1.0.6  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{viewerjumpto "Syntax" "_score_spec##syntax"}{...}
{viewerjumpto "Description" "_score_spec##description"}{...}
{viewerjumpto "Options" "_score_spec##options"}{...}
{viewerjumpto "Examples" "_score_spec##examples"}{...}
{viewerjumpto "Stored results" "_score_spec##results"}{...}
{title:Title}

{p 4 21 2}
{hi:[P] _score_spec} {hline 2}
Parsing tool for generating scores


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_score_spec}
	{it:new_var_spec} {ifin}
	[{cmd:,}
		{opt b(matname)}
		{opt sc:ores}
		{opt eq:uation(eqname)}
	]

{phang}
where {it:new_var_spec} is either {it:newvarlist} or {it:stub}{cmd:*}; see
{help newvarlist}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_score_spec} is a programmer's tool that helps with parsing the standard
syntax for generating score variables after a model fit.

{pstd}
{cmd:_score_spec} looks at the column names in {cmd:e(b)} to determine how
many score variables are to be generated, and parses {it:new_var_spec} using
{cmd:_stubstar2names} (see {helpb _stubstar2names}).


{marker options}{...}
{title:Options}

{phang}
{opt b(matname)} specifies an alternative matrix to look at for determining the
number of score variables to generate.  The default is equivalent to
specifying {cmd:b(e(b))}.

{phang}
{opt scores} is the default, and indicates that one score variable from each
equation is going to be generated.

{phang}
{opt equation(eqname)} indicates that one score variable is to be
generated, and identifies the equation that the observation score values are
to come from.


{marker examples}{...}
{title:Examples}

    {cmd}. sysuse auto, clear
    {txt}(1978 Automobile Data)
    
    {cmd}. quietly regress mpg turn displ
    {txt}
    {cmd}. _score_spec sc*
    {txt}
    {cmd}. sreturn list
    
    {txt}macros:
               s(typlist) : "{res}float{txt}"
               s(varlist) : "{res}sc1{txt}"
    
    {cmd}. _score_spec res, equation(#1)
    {txt}
    {cmd}. sreturn list
    
    {txt}macros:
               s(typlist) : "{res}float{txt}"
               s(varlist) : "{res}res{txt}"
                s(eqspec) : "{res}#1{txt}"
    
    {cmd}. _score_spec res, equation(#2)
    {err}equation [#2] not found
    {txt}{search r(303):r(303);}
    
    {cmd}. quietly mlogit rep turn trunk
    {txt}
    {cmd}. _score_spec double sc*
    {txt}
    {cmd}. sreturn list
    
    {txt}macros:
               s(typlist) : "{res}double double double double{txt}"
               s(varlist) : "{res}sc1 sc2 sc3 sc4{txt}"
                 s(coleq) : "{res}1 2 4 5{txt}"
    
    {cmd}. _score_spec sc, equation(#3)
    {txt}
    {cmd}. sreturn list
    
    {txt}macros:
               s(typlist) : "{res}float{txt}"
               s(varlist) : "{res}sc{txt}"
                 s(coleq) : "{res}1 2 4 5{txt}"
                s(eqname) : "{res}4{txt}"
                s(eqspec) : "{res}#3{txt}"


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_score_spec} stores the following in {cmd:s()}:

{p2colset 9 24 32 2}{...}
{pstd}Macros:{p_end}
{p2col :{cmd:s(varlist)}}list of new variable names{p_end}
{p2col :{cmd:s(typlist)}}list of types for the new variables{p_end}
{p2col :{cmd:s(coleq)}}equation names from {cmd:e(b)} matrix{p_end}
{p2col :{cmd:s(eqname)}}equation
	name for equation identified in the {opt equation()} option{p_end}
{p2col :{cmd:s(eqspec)}}{cmd:#}{it:#}
	for equation identified in the {opt equation()} option{p_end}
{p2colreset}{...}
