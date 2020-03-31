{* *! version 1.0.4  12dec2018}{...}
{marker fmmopts}{...}
{synoptset 26 tabbed}{...}
{synopthdr:fmmopts}
{synoptline}
{syntab:Model}
{synopt :{opth lcin:variant(fmm##pclassname:pclassname)}}specify parameters
that are equal across classes; default is {cmd:lcinvariant(none)}{p_end}
{synopt :{opth lcpr:ob(varlist)}}specify independent variables for class
probabilities{p_end}
{synopt :{opt lcl:abel(name)}}name of the categorical latent
variable; default is {cmd:lclabel(Class)}{p_end}
{synopt :{opt lcb:ase(#)}}base latent class{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
	{opt r:obust},
	or {opt cl:uster} {it:clustvar}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{opt nohead:er}}do not display header above parameter table{p_end}
{synopt :{opt nodvhead:er}}do not display dependent variables information in
the header{p_end}
{synopt :{opt notable}}do not display parameter table{p_end}
{synopt :{it:{help fmm##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help fmm##maximize_options:maximize_options}}}control
	the maximization process{p_end}
{synopt :{opth startv:alues(fmm##startvalues:svmethod)}}method for obtaining
starting values; default is {cmd:startvalues(factor)}{p_end}
{synopt :{opth em:opts(fmm##emopts:maxopts)}}control
EM algorithm for improved starting values{p_end}
{synopt :{opt noest:imate}}do not fit the model; show starting values
instead{p_end}

{synopt :{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:varlist} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{cmd:by}, {cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.{p_end}
{p 4 6 2}{cmd:vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and 
{cmd:pweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp fmm_postestimation FMM:fmm postestimation} for features
available after estimation.
{p_end}
