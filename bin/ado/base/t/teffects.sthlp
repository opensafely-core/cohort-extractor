{smcl}
{* *! version 1.0.6  19oct2017}{...}
{viewerdialog teffects "dialog teffects"}{...}
{vieweralsosee "[TE] teffects" "mansection TE teffects"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects intro" "help teffects_intro"}{...}
{vieweralsosee "[TE] teffects intro advanced " "mansection TE teffectsintroadvanced"}{...}
{vieweralsosee "[TE] teffects multivalued" "help teffects_multivalued"}{...}
{viewerjumpto "Syntax" "teffects##syntax"}{...}
{viewerjumpto "Description" "teffects##description"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[TE] teffects} {hline 2}}Treatment-effects estimation for observational data{p_end}
{p2col:}({mansection TE teffects:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:teffects} {it:subcommand} ... [{cmd:,} {it:options}]

{synoptset 16}{...}
{synopthdr:subcommand}
{synoptline}
{synopt :{helpb teffects aipw:aipw}}augmented inverse-probability weighting{p_end}
{synopt :{helpb teffects ipw:ipw}}inverse-probability weighting{p_end}
{synopt :{helpb teffects ipwra:ipwra}}inverse-probability-weighted regression adjustment{p_end}
{synopt :{helpb teffects nnmatch:nnmatch}}nearest-neighbor matching{p_end}
{synopt :{helpb teffects overlap:overlap}}overlap plots{p_end}
{synopt :{helpb teffects psmatch:psmatch}}propensity-score matching{p_end}
{synopt :{helpb teffects ra:ra}}regression adjustment{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:teffects} estimates potential-outcome means (POMs), average treatment 
effects (ATEs), and average treatment effects on the treated (ATETs)
using observational data.  Regression-adjustment, inverse-probability-weighted,
and matching estimators are provided, as are doubly robust methods that 
combine regression adjustment and inverse-probability weighting.
{cmd:teffects overlap} plots the estimated densities of the probability 
of getting each treatment level.

{pstd}
The outcomes can be continuous, binary, count, fractional, or nonnegative.
The treatment model can be binary, or it can be multinomial, allowing for
multivalued treatments.

{pstd}
For a brief description and example of each estimator, see
{helpb teffects_intro##remarks:{it:Remarks}} in {helpb teffects intro}.
{p_end}
