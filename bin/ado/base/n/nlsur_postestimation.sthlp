{smcl}
{* *! version 1.2.6  19oct2017}{...}
{viewerdialog predict "dialog nlsur_p"}{...}
{vieweralsosee "[R] nlsur postestimation" "mansection R nlsurpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] nlsur" "help nlsur"}{...}
{viewerjumpto "Postestimation commands" "nlsur postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "nlsur_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "nlsur postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "nlsur postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "nlsur postestimation##examples"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[R] nlsur postestimation} {hline 2}}Postestimation tools for nlsur{p_end}
{p2col:}({mansection R nlsurpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:nlsur}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_hausman
INCLUDE help post_lincom
INCLUDE help post_lrtest
{p2coldent:* {helpb nlsur_postestimation##margins:margins}}marginal means,
		predictive margins, marginal
                effects, and average marginal effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb nlsur postestimation##predict:predict}}predictions and residuals{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{phang}* You must specify the {cmd:variables()} option with {cmd:nlsur}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R nlsurpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} 
{dtype} 
{newvar} 
{ifin}
[{cmd:,} {opt eq:uation}{cmd:(#}{it:eqno}{cmd:)}
{opt y:hat} {opt r:esiduals}]

INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
fitted values and residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:equation(#}{it:eqno}{cmd:)} specifies to which equation you 
are referring.  {cmd:equation(#1)} would mean the calculation is to be 
made for the first equation, {cmd:equation(#2)} would mean the second, 
and so on.  If you do not specify {opt equation()}, results are the same 
as if you specified {cmd:equation(#1)}.

{phang}
{opt yhat}, the default, calculates the fitted values for the specified
equation.

{phang}
{opt residuals} calculates the residuals for the specified equation.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt y:hat}}fitted values; the default{p_end}
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for fitted values.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. nlsur (mpg = {b0} + {b1} / turn) (gear_ratio = {c0} + {c1}*length)}{p_end}

{pstd}Calculate fitted values for the first equation{p_end}
{phang2}{cmd:. predict mpghat, equation(#1)}{p_end}

{pstd}Calculate residuals for the second equation{p_end}
{phang2}{cmd:. predict gearerr, residuals equation(#2)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse mfgcost, clear}{p_end}
{phang2}{cmd:. nlsur (s_k = {c -(}bk{c )-} + {c -(}dkk{c )-}*ln(pk/pm) +}
                       {cmd:{c -(}dkl{c )-}*ln(pl/pm) +}
                       {cmd:{c -(}dke{c )-}*ln(pe/pm))}
                {cmd:(s_l = {c -(}bl{c )-} + {c -(}dkl{c )-}*ln(pk/pm) +}
                       {cmd:{c -(}dll{c )-}*ln(pl/pm) +}
                       {cmd:{c -(}dle{c )-}*ln(pe/pm))}
                {cmd:(s_e = {c -(}be{c )-} + {c -(}dke{c )-}*ln(pk/pm) +}
                       {cmd:{c -(}dle{c )-}*ln(pl/pm) +}
                       {cmd:{c -(}dee{c )-}*ln(pe/pm)),}
                       {cmd:ifgnls variables(pk pm pl pe)}

{pstd}Measure change in energy cost share with respect to change in price of
energy{p_end}
{phang2}{cmd:. margins, dydx(pe) predict(equation(#3))}{p_end}

    {hline}
