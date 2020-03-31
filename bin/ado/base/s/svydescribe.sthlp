{smcl}
{* *! version 1.1.12  15may2018}{...}
{viewerdialog svydescribe "dialog svydescribe"}{...}
{vieweralsosee "[SVY] svydescribe" "mansection SVY svydescribe"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{vieweralsosee "[SVY] svyset" "help svyset"}{...}
{vieweralsosee "[SVY] Survey" "help survey"}{...}
{viewerjumpto "Syntax" "svydescribe##syntax"}{...}
{viewerjumpto "Menu" "svydescribe##menu"}{...}
{viewerjumpto "Description" "svydescribe##description"}{...}
{viewerjumpto "Links to PDF documentation" "svydescribe##linkspdf"}{...}
{viewerjumpto "Options" "svydescribe##options"}{...}
{viewerjumpto "Examples" "svydescribe##examples"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[SVY] svydescribe} {hline 2}}Describe survey data{p_end}
{p2col:}({mansection SVY svydescribe:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:svydescribe} [{varlist}] {ifin} [{cmd:,} {it:options}]


{synoptset 20 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt :{opt stage(#)}}sampling
	stage to describe; default is {cmd:stage(1)}{p_end}
{synopt :{opt final:stage}}display
	information per sampling unit in the final stage{p_end}
{synopt :{opt single}}display
	only the strata with one sampling unit{p_end}
{synopt :{opth gen:erate(newvar)}}generate
	a variable identifying strata with one sampling unit{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:svydescribe} requires that the survey design variables be identified using
{cmd:svyset}; see {manhelp svyset SVY}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survey data analysis > Setup and utilities >}
      {bf:Describe survey data}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:svydescribe} displays a table that describes the strata and the sampling
units for a given sampling stage in a survey dataset.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SVY svydescribeQuickstart:Quick start}

        {mansection SVY svydescribeRemarksandexamples:Remarks and examples}

        {mansection SVY svydescribeMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt stage(#)} specifies the sampling stage to describe.
The default is {cmd:stage(1)}.

{phang}
{opt finalstage} specifies that results be displayed for each sampling unit
in the final sampling stage; that is, a separate line of output is produced
for every sampling unit in the final sampling stage.
This option is not allowed with {opt stage()}, {opt single}, or
{opt generate()}.

{phang}
{opt single} specifies that only the strata containing one sampling unit be
displayed in the table.

{phang}
{opth generate(newvar)} stores a variable that identifies strata
containing one sampling unit for a given sampling stage.


{marker examples}{...}
{title:Examples}

{phang}
{cmd:. webuse nhanes2b}
{p_end}
{phang}
{cmd:. svyset psuid [pweight=finalwgt], strata(stratid)}
{p_end}
{phang}
{cmd:. svydescribe}
{p_end}
{phang}
{cmd:. svy: mean hdresult}
{p_end}
{phang}
{cmd:. svydescribe hdresult, single}
{p_end}
{phang}
{cmd:. svydescribe hdresult, finalstage}
{p_end}
{phang}
{cmd:. gen newstr = stratid}
{p_end}
{phang}
{cmd:. gen newpsu = psuid}
{p_end}
{phang}
{cmd:. replace newpsu = psuid + 2 if stratid == 1}
{p_end}
{phang}
{cmd:. replace newstr = 2 if stratid == 1}
{p_end}
{phang}
{cmd:. svyset newpsu [pweight=finalwgt], strata(newstr)}
{p_end}
{phang}
{cmd:. svydescribe hdresult, finalstage}
{p_end}
{phang}
{cmd:. svy: mean hdresult}
{p_end}

{phang}
{cmd:. webuse nhanes2b, clear}
{p_end}
{phang}
{cmd:. svy: mean hdresult}
{p_end}
{phang}
{cmd:. svydescribe if e(sample), single}
{p_end}
