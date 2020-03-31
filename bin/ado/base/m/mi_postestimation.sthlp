{smcl}
{* *! version 1.0.15  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi estimate postestimation" "mansection MI miestimatepostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi predict" "help mi predict"}{...}
{vieweralsosee "[MI] mi test" "help mi test"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{vieweralsosee "[MI] mi estimate using" "help mi_estimate_using"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] Glossary" "help mi glossary"}{...}
{p2colset 1 36 38 2}{...}
{p2col:{bf:[MI] mi estimate postestimation} {hline 2}}Postestimation tools for mi estimate{p_end}
{p2col:}({mansection MI miestimatepostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:mi estimate} and {cmd:mi estimate using}:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb mi_test:mi test}}perform tests on coefficients{p_end}
{synopt :{helpb mi_test:mi testtransform}}perform tests on transformed coefficients{p_end}
{synopt :{helpb mi_predict:mi predict}}obtain linear predictions{p_end}
{synopt :{helpb mi_predict:mi predictnl}}obtain nonlinear predictions{p_end}
{synoptline}

{pstd}
After estimation by {cmd:mi estimate:} {it:estimation_command}, in general,
you may not use the standard postestimation commands such as {cmd:test},
{cmd:testnl}, or {cmd:predict}; nor may you use
{it:estimation_command}-specific postestimation commands such as {cmd:estat}.
As we have mentioned often, {cmd:mi estimate} is its own estimation command,
and the postestimation commands available after {cmd:mi estimate} (and 
{cmd:mi estimate using}) are listed in the table above.
{p_end}
