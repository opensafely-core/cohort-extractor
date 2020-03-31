{smcl}
{* *! version 1.1.13  31jan2020}{...}
{viewerdialog dydx "dialog dydx"}{...}
{viewerdialog integ "dialog integ"}{...}
{vieweralsosee "[R] dydx" "mansection R dydx"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] obs" "help obs"}{...}
{vieweralsosee "[D] range" "help range"}{...}
{viewerjumpto "Syntax" "dydx##syntax"}{...}
{viewerjumpto "Menu" "dydx##menu"}{...}
{viewerjumpto "Description" "dydx##description"}{...}
{viewerjumpto "Links to PDF documentation" "dydx##linkspdf"}{...}
{viewerjumpto "Options for dydx" "dydx##options_dydx"}{...}
{viewerjumpto "Options for integ" "dydx##options_integ"}{...}
{viewerjumpto "Examples" "dydx##examples"}{...}
{viewerjumpto "Stored results" "dydx##results"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[R] dydx} {hline 2}}Calculate numeric derivatives and integrals{p_end}
{p2col:}({mansection R dydx:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Derivatives of numeric functions

{p 8 13 2}
{cmd:dydx} {it:yvar} {it:xvar} {ifin} {cmd:,}
 {opth g:enerate(newvar)} [{it:{help dydx##dydx_options:dydx_options}}]


{phang}
Integrals of numeric functions

{p 8 15 2}
{cmd:integ} {it:yvar} {it:xvar} {ifin} [{cmd:,} 
{it:{help dydx##integ_options:integ_options}}]


{synoptset 20 tabbed}{...}
{marker dydx_options}{...}
{synopthdr :dydx_options}
{synoptline}
{syntab :Main}
{p2coldent :* {opth g:enerate(newvar)}}store results in variable named {it:newvar}{p_end}
{synopt :{opt replace}}overwrite the existing variable{p_end}
{synopt :{opt double}}store new variable as {cmd:double}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt generate(newvar)} is required.

{synoptset 20 tabbed}{...}
{marker integ_options}{...}
{synopthdr :integ_options}
{synoptline}
{syntab :Main}
{synopt :{opt t:rapezoid}}use trapezoidal rule to compute integrals; default is cubic splines{p_end}
{synopt :{opth g:enerate(newvar)}}store results in variable named {it:newvar}{p_end}
{synopt :{opt replace}}overwrite the existing variable{p_end}
{synopt :{opt double}}store new variable as {cmd:double}{p_end}
{synopt :{opt i:nitial(#)}}initial value of integral; default is {cmd:initial(0)}{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
{opt by} is allowed with {cmd:dydx} and {cmd:integ}; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

    {title:dydx}

{phang2}
{bf:Data > Create or change data > Other variable-creation commands >}
     {bf:Calculate numerical derivatives}

    {title:integ}

{phang2}
{bf:Data > Create or change data > Other variable-creation commands >}
     {bf:Calculate numeric integrals}


{marker description}{...}
{title:Description}

{pstd}
{cmd:dydx} and {cmd:integ} calculate derivatives and integrals of numeric
"functions".


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R dydxQuickstart:Quick start}

        {mansection R dydxRemarksandexamples:Remarks and examples}

        {mansection R dydxMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{marker options_dydx}{...}
{title:Options for dydx}

{dlgtab:Main}

{phang}
{opth generate(newvar)} specifies that results be stored in a new 
variable.  {cmd:generate()} is required.

{phang}
{opt replace} specifies that if an existing variable is specified for 
{opt generate()}, it should be overwritten.

{phang}
{opt double} specifies that the new variable in {cmd:generate()} be stored as
{cmd:double}.  If the {cmd:double} option is not specified, the variable is
stored using the current type as set by {helpb set type}, which is
{cmd:float} by default.


{marker options_integ}{...}
{title:Options for integ}

{dlgtab:Main}

{phang}
{opt trapezoid} requests that the trapezoidal rule (the sum of (x[i] -
x[i-1])(y[i] + y[i-1])/2) be used to compute integrals.  The default is cubic
splines, which give superior results for most smooth functions; for irregular
functions, {opt trapezoid} may give better results.

{phang}
{opth generate(newvar)} specifies that results be stored in a new 
variable.

{phang}
{opt replace} specifies that if an existing variable is specified for 
{opt generate()}, it should be overwritten.

{phang}
{opt double} specifies that the new variable in {cmd:generate()} be stored as
{cmd:double}.  If the {cmd:double} option is not specified, the variable is
stored using the current type as set by {helpb set type}. 

{phang}
{opt initial(#)} specifies the initial condition for calculating definite
integrals; see {mansection R dydxMethodsandformulas:{it:Methods and formulas}}.
The default is {cmd:initial(0)}.


{marker examples}{...}
{title:Examples}

    {cmd:. range x 0 12.56 100}            (create 100 obs on {cmd:x}, 0 to 4*pi)
    {cmd:. generate y = exp(-x/6)*sin(x)}  (generate {cmd:y} = f(x))
    {cmd:. dydx y x, gen(yprime)}          (create derivative of function)
    {cmd:. line y yprime x}                (graph function and derivative)
    {cmd:. integ y x, gen(Sy)}             (create integral of function)
    {cmd:. line y Sy x}                    (graph function and integral)


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:dydx} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(y)}}name of {it:yvar}{p_end}
{p2colreset}{...}

{pstd}
{cmd:integ} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N_points)}}number of unique x points{p_end}
{synopt:{cmd:r(integral)}}estimate of the integral{p_end}
{p2colreset}{...}
