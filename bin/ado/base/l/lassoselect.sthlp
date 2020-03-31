{smcl}
{* *! version 1.0.0  21jun2019}{...}
{viewerdialog lassoselect "dialog lassoselect"}{...}
{vieweralsosee "[LASSO] lassoselect" "mansection lasso lassoselect"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] lasso postestimation" "help lasso postestimation"}{...}
{viewerjumpto "Syntax" "lassoselect##syntax"}{...}
{viewerjumpto "Menu" "lassoselect##menu"}{...}
{viewerjumpto "Description" "lassoselect##description"}{...}
{viewerjumpto "Links to PDF documentation" "lassoselect##linkspdf"}{...}
{viewerjumpto "Options" "lassoselect##options"}{...}
{viewerjumpto "Examples" "lassoselect##examples"}{...}
{viewerjumpto "Stored results" "lassoselect##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[LASSO] lassoselect} {hline 2}}Select lambda after lasso{p_end}
{p2col:}({mansection LASSO lassoselect:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
After {cmd:lasso}, {cmd:sqrtlasso}, and {cmd:elasticnet}

{p 8 16 2}
{cmd:lassoselect id =} {it:#}


{pstd}
After {cmd:lasso} and {cmd:sqrtlasso}

{p 8 16 2}
{cmd:lassoselect lambda =} {it:#}


{pstd}
After {cmd:elasticnet}

{p 8 16 2}
{cmd:lassoselect alpha =} {it:#} {cmd:lambda =} {it:#}


{pstd}
After {cmd:ds} and {cmd:po} with {cmd:selection(cv)} or 
{cmd:selection(adaptive)}

{p 8 16 2}
{cmd:lassoselect} { {cmd:id} | {cmd:lambda} } {cmd:=} {it:#}{cmd:,} {opt for(varspec)}


{pstd}
After {cmd:xpo} without {cmd:resample} and with {cmd:selection(cv)} or 
{cmd:selection(adaptive)}

{p 8 16 2}
{cmd:lassoselect} { {cmd:id} | {cmd:lambda} } {cmd:=} {it:#}{cmd:,} {opt for(varspec)} 
{opt xfold(#)}


{pstd}
After {cmd:xpo} with {cmd:resample} and {cmd:selection(cv)} or 
{cmd:selection(adaptive)}

{p 8 16 2}
{cmd:lassoselect} { {cmd:id} | {cmd:lambda} } {cmd:=} {it:#}{cmd:,}
{opt for(varspec)}
{opt xfold(#)}
{opt resample(#)}


{phang}
{it:varspec} is a {varname}, except after {cmd:poivregress}
and {cmd:xpoivregress}, when it is either {it:varname} or 
{mansection LASSO lassoinfoRemarksandexamplespred_varname:{bf:pred(}{it:varname}{bf:)}}.

{synoptset 25}{...}
{synopthdr}
{synoptline}
INCLUDE help for_short
{synoptline}
INCLUDE help for_footnote


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:lassoselect} allows the user to select a different lambda* after
{helpb lasso} and {helpb sqrtlasso} when the selection method was
{cmd:selection(cv)}, {cmd:selection(adaptive)}, or {cmd:selection(none)}.

{pstd}
After {helpb elasticnet}, the user can select a different (alpha*, lambda*)
pair.

{pstd}
When the {cmd:ds}, {cmd:po}, and {cmd:xpo} commands fit models using
{cmd:selection(cv)} or {cmd:selection(adaptive)} 
({manhelp lasso_options LASSO:lasso options}), {cmd:lassoselect} can be used
to select a different lambda* for a particular lasso.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO lassoselectQuickstart:Quick start}

        {mansection LASSO lassoknotsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

INCLUDE help for_long


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. set seed 1234}{p_end}
{phang2}{cmd:. lasso linear mpg i.foreign i.rep78 headroom weight turn}
    {cmd:gear_ratio price trunk length displacement}{p_end}
{phang2}{cmd:. lassoknots}

{pstd}Change selected lambda* to that with ID = 43{p_end}
{phang2}{cmd:. lassoselect id=43}

{pstd}Change lambda* to the one closest to 0.095{p_end}
{phang2}{cmd:. lassoselect lambda=0.095}

{pstd}Setup{p_end}
{phang2}{cmd:. elasticnet linear mpg i.foreign i.rep78 headroom weight turn}
    {cmd:gear_ratio price trunk length displacement}{p_end}
{phang2}{cmd:. lassoknots}

{pstd}Change the selected (alpha*, lambda*) to (0.5; 0.165){p_end}
{phang2}{cmd:. lassoselect alpha=0.5 lambda=0.165}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse nlsy80, clear}{p_end}
{phang2}{cmd:. poivregress wage exper}
    {cmd:(educ = i.pcollege##c.(meduc feduc) i.urban sibs iq),}
    {cmd:controls(c.age##c.age tenure kww i.(married black south urban))}
    {cmd:selection(cv)}{p_end}
{phang2}{cmd:. lassoknots, for(pred(educ))}

{pstd}Change the selected lambda* to the lambda closest to 0.1 for the
lasso for the prediction of the variable {cmd:educ}{p_end}
{phang2}{cmd:. lassoselect lambda = 0.1, for(pred(educ))}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:lassoselect} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(varlist)}}selected variables{p_end}
{p2colreset}{...}
