{smcl}
{* *! version 1.0.4  19oct2017}{...}
{viewerdialog stteffects "dialog stteffects"}{...}
{vieweralsosee "[TE] stteffects" "mansection TE stteffects"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] stteffects intro" "help stteffects_intro"}{...}
{viewerjumpto "Syntax" "stteffects##syntax"}{...}
{viewerjumpto "Description" "stteffects##description"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[TE] stteffects} {hline 2}}Treatment-effects estimation for
observational survival-time data{p_end}
{p2col:}({mansection TE stteffects:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:stteffects} {it:subcommand} ... [{cmd:,} {it:options}]

{synoptset 16}{...}
{synopthdr:subcommand}
{synoptline}
{synopt :{helpb stteffects ra:ra}}regression adjustment{p_end}
{synopt :{helpb stteffects ipw:ipw}}inverse-probability weighting{p_end}
{synopt :{helpb stteffects ipwra:ipwra}}inverse-probability-weighted regression
adjustment{p_end}
{synopt :{helpb stteffects wra:wra}}weighted regression adjustment{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stteffects} estimates average treatment effects, average treatment
effects on the treated, and potential-outcome means using observational
survival-time data.  The available estimators are regression adjustment,
inverse-probability weighting, and more efficient methods that combine
regression adjustment and inverse-probability weighting.

{pstd}
For a brief description and example of each estimator, see
{it:{mansection TE stteffectsintroRemarksandexamples:Remarks and examples}}
in {bf:[TE] stteffects intro}.
{p_end}
