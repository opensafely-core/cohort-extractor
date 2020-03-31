{smcl}
{* *! version 1.0.12  20sep2018}{...}
{viewerdialog tebalance "dialog tebalance"}{...}
{vieweralsosee "[TE] tebalance box" "mansection TE tebalancebox"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] tebalance" "help tebalance"}{...}
{vieweralsosee "[TE] teffects nnmatch" "help teffects nnmatch"}{...}
{vieweralsosee "[TE] teffects overlap" "help teffects overlap"}{...}
{vieweralsosee "[TE] teffects psmatch" "help teffects psmatch"}{...}
{viewerjumpto "Syntax" "tebalance box##syntax"}{...}
{viewerjumpto "Menu" "tebalance box##menu"}{...}
{viewerjumpto "Description" "tebalance box##description"}{...}
{viewerjumpto "Links to PDF documentation" "tebalance_box##linkspdf"}{...}
{viewerjumpto "Options" "tebalance box##options"}{...}
{viewerjumpto "Example" "tebalance box##example"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[TE] tebalance box} {hline 2}}Covariate balance box{p_end}
{p2col:}({mansection TE tebalancebox:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{pstd}
Box plots for the propensity score

{p 8 12 2}
{cmd:tebalance} {cmd:box} [{cmd:,} {it:options}]


{pstd}
Box plots for a covariate

{p 8 12 2}
{cmd:tebalance} {cmd:box} {it:varname} [{cmd:,} {it:options}]


{synoptset 25 tabbed}{...}
{marker omodel}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{it:{help graph box##boxlook_options:boxlook_options}}}{cmd:graph box} options controlling how
the box looks{p_end}
{synopt :{it:{help graph box##legending_options:legending_options}}}{cmd:graph box} options controlling how the variables are labeled{p_end}
{synopt :{it:{help graph box##axis_options:axis_options}}}{cmd:graph box} options controlling how numerical y axis is labeled{p_end}
{synopt :{it:{help graph box##title_and_other_options:title_and_other_options}}}{cmd:graph box} options controlling titles, added text, aspect ratio, etc.{p_end}
{synopt :{it:{help by_option}}}suboptions inside {cmd:by()} controlling plots by raw and matched samples{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Treatment effects > Balance > Graphs}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tebalance box} produces box plots that are used to check for balance
in matched samples after {helpb teffects nnmatch} and 
{helpb teffects psmatch}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE tebalanceboxQuickstart:Quick start}

        {mansection TE tebalanceboxRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{it:boxlook_options} are any of the options documented in 
{it:{help graph box##boxlook_options:boxlook_options}} in 
{manhelp graph_box G-2:graph box}.

{phang}
{it:legending_options} are any of the options documented in
{it:{help graph box##legending_options:legending_options}} in
{manhelp graph_box G-2:graph box}.

{phang}
{it:axis_options} are any of the options documented in
{it:{help graph box##axis_options:axis_options}} in
{manhelp graph_box G-2:graph box}.

{phang}
{it:title_and_other_options} are any of the options, except {cmd:by()},
documented in 
{it:{help graph box##title_and_other_options:title_and_other_options}} in
{manhelp graph_box G-2:graph box}.  {cmd:tebalance box} uses {cmd:by()} to
differentiate between raw and matched samples, and some {it:twoway_options}
will be repeated for by {cmd:graph} and might be better specified as
{cmd:byopts()}.

{phang}
{it:by_options} are any of the {it:byopts} documented in 
{manhelpi by_options G-3}.  {cmd:byopts()} generally affects the entire graph,
and some {it:by_options} may be better specified as {it:twoway_options}; see
{manhelpi twoway_options G-3}.


{marker example}{...}
{title:Example}

{pstd}
Setup
{p_end}
{phang2}{cmd:. webuse cattaneo2}

{pstd}
Estimate the effect of a mother's smoking behavior ({cmd:mbsmoke}) on
the birthweight of her child ({cmd:bweight}), controlling for marital
status ({cmd:mmarried}), the mother's age ({cmd:mage}), whether the
mother had a prenatal doctor's visit in the baby's first trimester
({cmd:prenatal1}), and whether this baby is the mother's first child
({cmd:fbaby}){p_end}
{phang2}{cmd:. teffects psmatch (bweight) (mbsmoke mmarried mage prenatal1 fbaby), generate(matchv)}

{pstd}
Now we look at the box plots{p_end}
{phang2}{cmd:. tebalance box mage}{p_end}
