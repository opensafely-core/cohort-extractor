{smcl}
{* *! version 1.0.13  12apr2019}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi expand" "mansection MI miexpand"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] expand" "help expand"}{...}
{viewerjumpto "Syntax" "mi_expand##syntax"}{...}
{viewerjumpto "Menu" "mi_expand##menu"}{...}
{viewerjumpto "Description" "mi_expand##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_expand##linkspdf"}{...}
{viewerjumpto "Options" "mi_expand##options"}{...}
{viewerjumpto "Remarks" "mi_expand##remarks"}{...}
{viewerjumpto "Examples" "mi_expand##examples"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[MI] mi expand} {hline 2}}Expand mi data{p_end}
{p2col:}({mansection MI miexpand:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:mi expand}
[{cmd:=}] {it:{help exp}} [{help if}]
[{cmd:,} {it:options}]

{synoptset 18}{...}
{synopthdr}
{synoptline}
{synopt:{opth gen:erate(newvar)}}create {it:newvar}; 0=original,
   1=expanded{p_end}

{synopt:{cmdab:noup:date}}see {bf:{help mi_noupdate_option:[MI] noupdate option}}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:expand} is {bf:{help expand:expand}} for {cmd:mi} data.
The syntax is identical to {cmd:expand} except that {cmd:in} {it:range} is not
allowed and the {cmd:noupdate} option is allowed.

{p 4 4 2}
{cmd:mi} {cmd:expand} {it:exp} replaces each observation in the dataset with
{it:n} copies of the observation, where {it:n} is equal to the required
expression rounded to the nearest integer.  If the expression is less than 1
or equal to missing, it is interpreted as if it were 1, meaning that the
observation is retained but not duplicated.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miexpandRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{p 4 8 2}
{opth generate(newvar)}
    creates new variable {it:newvar} containing 0 if the observation 
    originally appeared in the dataset and 1 if the observation is
    a duplication.

{p 4 8 2}
{cmd:noupdate}
    in some cases suppresses the automatic {cmd:mi} {cmd:update} this 
    command might perform; 
    see {bf:{help mi_noupdate_option:[MI] noupdate option}}.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:mi} {cmd:expand} amounts to performing {cmd:expand} on {it:m}=0, then
duplicating the result on {it:m}=1, {it:m}=2, ..., {it:m}={it:M}, and then
combining the result back into {cmd:mi} format.
Thus if the requested expansion specified by {it:exp} is a function of an
imputed, passive, varying, or super-varying variable, then it is the values 
of the variable in {it:m}=0 that will be used to produce the result 
for {it:m}=1, {it:m}=2, ..., {it:m}={it:M}, too.
{p_end}


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse stackxmpl2}{p_end}
{phang2}{cmd:. mi describe}

{pstd}List the original data for m = 1{p_end}
{phang2}{cmd:. mi xeq 1: list}

{pstd}Replace each observation with 2 copies of the observation (original
observation is retained and 1 new observation is created){p_end}
{phang2}{cmd:. mi expand 2}

{pstd}List the results for m = 1{p_end}
{phang2}{cmd:. mi xeq 1: list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse stackxmpl2, clear}

{pstd}List the original data for m = 1{p_end}
{phang2}{cmd:. mi xeq 1: list}

{pstd}Replace each observation with x copies of that observation, where x is the 
value of b for that observation{p_end}
{phang2}{cmd:. mi expand b}

{pstd}List the results for m = 1{p_end}
{phang2}{cmd:. mi xeq 1: list, sepby(b)}

    {hline}
