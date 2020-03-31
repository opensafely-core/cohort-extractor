{smcl}
{* *! version 1.0.2  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{viewerjumpto "Syntax" "_mgarch_p_names##syntax"}{...}
{viewerjumpto "Description" "_mgarch_p_names##description"}{...}
{viewerjumpto "Options" "_mgarch_p_names##options"}{...}
{viewerjumpto "Examples" "_mgarch_p_names##examples"}{...}
{viewerjumpto "Stored results" "_mgarch_p_names##results"}{...}
{title:Title}

{p 4 25 2}
{hi:[P] _mgarch_p_names} {hline 2} Parse new variable lists for mgarch
postestimation


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_mgarch_p_names}
	{it:new_var_spec}{cmd:,}
	{opth suffix(varlist)}
	{opt stat(statistic)}
	[{opt eq:uation(eqnames)}]

{phang}
where {it:new_var_spec} is either {it:newvarlist} or {it:stub}{cmd:*}; see
{help newvarlist}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_mgarch_p_names} is a modification of {helpb _stubstar2names} and is used
for generating a list of new variables for {cmd:predict} after {helpb mgarch}.
{cmd:_mgarch_p_names} will turn {it:stub}{cmd:*} into a list of names that
begin with {it:stub} and are indexed by variable names provided in option
{bf:suffix()}.


{marker options}{...}
{title:Options}

{phang}
{opth suffix(varlist)} is required and contains the names of the
dependent variables in the model.  The returned {it:newvarlist} will be of the
form {it:stub}{bf:_}{it:varname1}, {it:stub}{bf:_}{it:varname2}, ....
Time-series operators will be converted to legal variable names.

{phang}
{opt stat(statistic)} is required and is one of {opt xb}, {opt r:esiduals}, or
{opt v:ariance}.  If the statistic is {bf:variance}, the returned
{it:newvarlist} will contain 0.5*k(k+1) variable names generated in vech order.

{phang}
{opt equation(eqnames)} specifies the names of equations for which predictions
are made.


{marker examples}{...}
{title:Examples}

    {cmd}. _mgarch_p_names xb*, suffix(y1 y2 y3) stat(xb)
    {txt}
    {cmd}. sreturn list

    {txt}macros:
                  s(stub) : "{res}1{txt}"
               s(typlist) : "{res}float float float{txt}"
            s(newvarlist) : "{res}xb_y1 xb_y2 xb_y3{txt}"
               s(lablist) : "{res}(y1) (y2) (y3){txt}"
               s(depvars) : "{res}y1 y2 y3{txt}"

    {cmd}. _mgarch_p_names v*, suffix(y1 y2 y3) stat(var)
    {txt}
    {cmd}. sreturn list

    {txt}macros:
                  s(stub) : "{res}1{txt}"
               s(typlist) : "{res}float float float float float float{txt}"
            s(newvarlist) : "{res}v_y1_y1 v_y2_y1 v_y3_y1 v_y2_y2 v_y3_y2 v_y3_y3{txt}"
               s(lablist) : "{res}(y1,y1) (y2,y1) (y3,y1) (y2,y2) (y3,y2) (y3,y3){txt}"
               s(depvars) : "{res}y1 y2 y3{txt}"

    {cmd}. _mgarch_p_names v23, suffix(y1 y2 y3) stat(var) eq(y2,y3)
    {txt}
    {cmd}. sreturn list

    {txt}macros:
                  s(stub) : "{res}0{txt}"
               s(typlist) : "{res}float{txt}"
            s(newvarlist) : "{res}v23{txt}"
               s(lablist) : "{res}(y2,y3){txt}"
               s(depvars) : "{res}y1 y2 y3{txt}"
                   s(ix1) : "{res}2{txt}"
                   s(ix2) : "{res}3{txt}"

    {cmd}. _mgarch_p_names e3, suffix(y1 y2 y3) stat(res) eq(y3)
    {txt}
    {cmd}. sreturn list

    {txt}macros:
                  s(stub) : "{res}0{txt}"
               s(typlist) : "{res}float{txt}"
            s(newvarlist) : "{res}e3{txt}"
               s(lablist) : "{res}(y3){txt}"
               s(depvars) : "{res}y3{txt}"
                   s(ix1) : "{res}3{txt}"


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_mgarch_p_names} stores the following in {cmd:s()}:

{p2colset 9 25 32 2}{...}
{pstd}Macros{p_end}
{p2col :{cmd:s(newvarlist)}}list of new variable names{p_end}
{p2col :{cmd:s(typlist)}}list of types for the new variables{p_end}
{p2col :{cmd:s(lablist)}}list of parenthesized equation names{p_end}
{p2col :{cmd:s(depvars)}}names of equations {bf:predict} will use{p_end}
{p2col :{cmd:s(stub)}}{cmd:0}
	or {cmd:1}; indicator for {it:stub}{cmd:*} in {it:new_var_spec}{p_end}
{p2col :{cmd:s(ix1)}}index of first equation{p_end}
{p2col :{cmd:s(ix2)}}index of second equation{p_end}
