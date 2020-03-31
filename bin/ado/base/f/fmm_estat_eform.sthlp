{smcl}
{* *! version 1.0.11  14feb2019}{...}
{viewerdialog estat "dialog fmm_estat"}{...}
{vieweralsosee "[FMM] estat eform" "mansection FMM estateform"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm_postestimation"}{...}
{viewerjumpto "Syntax" "fmm_estat_eform##syntax"}{...}
{viewerjumpto "Menu" "fmm_estat_eform##menu_estat"}{...}
{viewerjumpto "Description" "fmm_estat_eform##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_estat_eform##linkspdf"}{...}
{viewerjumpto "Options" "fmm_estat_eform##options"}{...}
{viewerjumpto "Examples" "fmm_estat_eform##examples"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[FMM] estat eform} {hline 2}}Display exponentiated
coefficients{p_end}
{p2col:}({mansection FMM estateform:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmd:eform}
[{it:eqnamelist}]
[{cmd:,} {opt l:evel(#)} {it:display_options}]

{phang} 
where {it:eqnamelist} is a list of equation names.  With {opt fmm}, 
    equation names correspond to the names of the response variables. 
    If no {it:eqnamelist} is specified, exponentiated results for the first
    equation are shown.


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{opt fmm} reports coefficients. 
You can obtain exponentiated coefficients and their standard errors
by using {opt estat} {opt eform} after estimation to redisplay results. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection FMM estateformRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt level(#)};
    see {helpb estimation options:[R] Estimation options}.

{phang}
{it:display_options}
     control the display of factor variables and more.
     Allowed {it:display_options} are
{opt noci},
{opt nopv:alues},
{opt noomit:ted},
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels},
{opt nofvlab:el},
{opt fvwrap(#)},
{opt fvwrapon(style)},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.
{p_end}


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse epay}

{pstd}Mixture of two logistic regression models{p_end}
{phang2}{cmd:. fmm 2: logit epay age i.male}

{pstd}Report exponentiated coefficients (odds ratios) rather than coefficients
{p_end}
{phang2}{cmd:. estat eform}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse sim_car}

{pstd}Mixture of two multinomial logistic regression models{p_end}
{phang2}{cmd:. fmm 2, lcinvariant(cons): mlogit model i.female income}

{pstd}Report exponentiated coefficients (relative-risk ratios) rather than
coefficients{p_end}
{phang2}{cmd:. estat eform}{p_end}

    {hline}
