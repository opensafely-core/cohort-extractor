{smcl}
{* *! version 1.1.2  19oct2017}{...}
{viewerdialog forecast "dialog forecast"}{...}
{vieweralsosee "[TS] forecast coefvector" "mansection TS forecastcoefvector"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{vieweralsosee "[TS] forecast solve" "help forecast solve"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix rownames"}{...}
{viewerjumpto "Syntax" "forecast_coefvector##syntax"}{...}
{viewerjumpto "Description" "forecast_coefvector##description"}{...}
{viewerjumpto "Links to PDF documentation" "forecast_coefvector##linkspdf"}{...}
{viewerjumpto "Options" "forecast_coefvector##options"}{...}
{viewerjumpto "Example" "forecast_coefvector##example"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[TS] forecast coefvector} {hline 2}}Specify an equation via a
coefficient vector{p_end}
{p2col:}({mansection TS forecastcoefvector:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:fore:cast} {cmdab:co:efvector} {it:cname}
[{cmd:,} {it:options}]

{phang}
{it:cname} is a Stata matrix with one row.

{synoptset 26}{...}
{synopthdr}
{synoptline}
{synopt :{opt v:ariance(vname)}}specify parameter variance matrix{p_end}
{synopt :{opt err:orvariance(ename)}}specify additive error variance
matrix{p_end}
{synopt :{cmdab:na:mes(}{it:namelist}[{cmd:, replace}]{cmd:)}}use {it:namelist} for names of
left-hand-side variables{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:forecast coefvector} adds equations that are stored as coefficient
vectors to your forecast model.  Typically, equations are added using
{cmd:forecast estimates} and {cmd:forecast identity}.
{cmd:forecast coefvector} is used in less-common situations where you have a
vector of parameters that represent a linear equation.

{pstd}
Most users of the {cmd:forecast} commands will not need to use
{cmd:forecast coefvector}.  We recommend skipping this manual entry until you
are familiar with the other features of {cmd:forecast}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS forecastcoefvectorQuickstart:Quick start}

        {mansection TS forecastcoefvectorRemarksandexamples:Remarks and examples}

        {mansection TS forecastcoefvectorMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt variance(vname)} specifies that Stata matrix {it:vname} contains
the variance matrix of the estimated parameters.  This option only has an
effect if you specify the {cmd:simulate()} option when calling {cmd:forecast}
{cmd:solve} and request {it:sim_technique}'s {cmd:betas} or {cmd:residuals}.
See {helpb forecast solve:[TS] forecast solve}.

{phang} 
{opt errorvariance(ename)} specifies that the equations being added include an
additive error term with variance {it:ename}, where {it:ename} is the name of
a Stata matrix.  The number of rows and columns in {it:ename} must match the
number of equations represented by coefficient vector {it:cname}.  This option
only has an effect if you specify the {cmd:simulate()} option when calling
{cmd:forecast} {cmd:solve} and request {it:sim_technique}'s {cmd:errors} or
{cmd:residuals}.  See {helpb forecast solve:[TS] forecast solve}.

{phang}
{cmd:names(}{it:namelist}[{cmd:, replace}]{cmd:)} instructs {cmd:forecast}
{cmd:coefvector} to use {it:namelist} as the names of the left-hand-side
variables in the coefficient vector being added.  By default, {cmd:forecast}
{cmd:coefvector} uses the equation names on the column stripe of {it:cname}.
You must use this option if any of the equation names stored with {it:cname}
contains time-series operators.  


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. set obs 20}{p_end}
{phang2}{cmd:. generate t = _n}{p_end}
{phang2}{cmd:. tsset t}{p_end}
{phang2}{cmd:. generate y = 0}{p_end}

{pstd}Create the coefficient vector{p_end}
{phang2}{cmd:. matrix y = (.9, -.6, 0.3)}{p_end}
{phang2}{cmd:. matrix coleq y = y:L.y y:L2.y y:L3.y}{p_end}

{pstd}Create the forecast model and add {cmd:y}{p_end}
{phang2}{cmd:. forecast create}{p_end}
{phang2}{cmd:. forecast coefvector y}{p_end}
