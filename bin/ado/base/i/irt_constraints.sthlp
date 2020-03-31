{smcl}
{* *! version 1.0.0  14may2019}{...}
{viewerdialog irt "dialog irt"}{...}
{viewerdialog "svy: irt" "dialog irt, message(-svy-) name(svy_irt)"}{...}
{vieweralsosee "[IRT] irt constraints" "mansection IRT irtconstraints"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] irt" "help irt"}{...}
{vieweralsosee "[IRT] irt 1pl" "help irt 1pl"}{...}
{vieweralsosee "[IRT] irt 2pl" "help irt 2pl"}{...}
{vieweralsosee "[IRT] irt 3pl" "help irt 3pl"}{...}
{vieweralsosee "[IRT] irt grm" "help irt grm"}{...}
{vieweralsosee "[IRT] irt, group()" "help irt group"}{...}
{vieweralsosee "[IRT] irt hybrid" "help irt hybrid"}{...}
{vieweralsosee "[IRT] irt nrm" "help irt nrm"}{...}
{vieweralsosee "[IRT] irt pcm" "help irt pcm"}{...}
{vieweralsosee "[IRT] irt rsm" "help irt rsm"}{...}
{viewerjumpto "Syntax" "irt constraints##syntax"}{...}
{viewerjumpto "Description" "irt constraints##description"}{...}
{viewerjumpto "Links to PDF documentation" "irt_constraints##linkspdf"}{...}
{viewerjumpto "Examples" "irt constraints##examples"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[IRT] irt constraints} {hline 2}}Specifying constraints{p_end}
{p2col:}({mansection IRT irtconstraints:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:irt} ... [{cmd:,}
     {opt cns(spec [spec ...])} ...]

{phang}
where {it:spec} is {it:parm}{cmd:@}{it:#} or {it:parm}{cmd:@}{it:symbol}.


{pstd}
In 1PL and 2PL models,
{it:parm} is one of {cmd:a} or {cmd:b}, which corresponds to the
discrimination or difficulty parameter in the IRT parameterization, or 
{it:parm} is one of {cmd:alpha} or {cmd:beta}, which corresponds to 
the slope or intercept in the slope-intercept parameterization. 

{pstd}
In 3PL models,
{it:parm} is one of {cmd:a}, {cmd:b}, or {cmd:c}, which corresponds to the
discrimination, difficulty, or guessing parameter in the IRT 
parameterization, or {it:parm} is one of {cmd:alpha} or {cmd:beta}, which 
corresponds to the slope or intercept in the slope-intercept parameterization.

{pstd}
In nominal response models, {it:parm} is one of {cmd:a1}, {cmd:a2}, ... for 
the multiple discrimination parameters per item, or {it:parm} is one of 
{cmd:b1}, {cmd:b2}, ... for the multiple difficulty parameters per item.

{pstd}
In graded response, partial credit, and 
rating scale models, {it:parm} is {cmd:a} for the discrimination 
parameter, or {it:parm} is one of {cmd:b1}, {cmd:b2}, ... for the multiple 
difficulty parameters per item.

{pstd}
{cmd:a} is a synonym for {cmd:a1}, and {cmd:b} is a synonym for {cmd:b1}.


{marker description}{...}
{title:Description}

{pstd}
Constraints are imposed on the estimated parameters of a
model.  {cmd:irt} allows you to constrain a parameter to a fixed value or
to constrain two or more parameters to be equal.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection IRT irtconstraintsQuickstart:Quick start}

        {mansection IRT irtconstraintsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse masc1}

{pstd}Fit a 2PL model using a hybrid specification to separate {cmd:q1}
from the other items{p_end}
{phang2}{cmd:. irt (2pl q1) (2pl q2 q3 q4)}

{pstd}Same as above, but constrain the discrimination to 1.5 and the 
difficulty to -0.5 for {cmd:q1}{p_end}
{phang2}{cmd:. irt (2pl q1, cns(a@1.5 b@-.5)) (2pl q2 q3 q4)}

    {hline}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse masc2}

{pstd}Fit a group 2PL model using a hybrid specification to separate {cmd:q1}
from the other items{p_end}
{phang2}{cmd:. irt (0: 2pl q1) (1: 2pl q1) (2pl q2 q3 q4), group(female)}

{pstd}Same as above, but constrain the intercept for item {cmd:q1} to be equal
across the two groups{p_end}
{phang2}{cmd:. irt (0: 2pl q1, cns(beta@k1)) (1: 2pl q1, cns(beta@k1))}
        {cmd:(2pl q2 q3 q4), group(female)}

    {hline}
