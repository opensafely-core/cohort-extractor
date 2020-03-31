{smcl}
{* *! version 1.0.17  27sep2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi describe" "mansection MI midescribe"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{viewerjumpto "Syntax" "mi describe##syntax"}{...}
{viewerjumpto "Menu" "mi describe##menu"}{...}
{viewerjumpto "Description" "mi describe##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_describe##linkspdf"}{...}
{viewerjumpto "Options" "mi describe##options"}{...}
{viewerjumpto "Examples" "mi describe##examples"}{...}
{viewerjumpto "Stored results" "mi describe##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[MI] mi describe} {hline 2}}Describe mi data{p_end}
{p2col:}({mansection MI midescribe:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi}
{cmdab:q:uery}

{p 8 12 2}
{cmd:mi}
{cmdab:d:escribe}
[{cmd:,}
{it:describe_options}]


{synoptset 18}{...}
{synopthdr:describe_options}
{synoptline}
{synopt:{cmdab:d:etail}}show missing-value counts for {it:m}=1, {it:m}=2, ...
{p_end}

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
{cmd:mi} {cmd:query} reports whether the data in memory are {cmd:mi} data
and, if they are, reports the style in which they are set.

{p 4 4 2}
{cmd:mi} {cmd:describe} provides a more detailed report on {cmd:mi} data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI midescribeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{p 4 8 2}
{cmd:detail} reports the number of missing values in {it:m}=1, {it:m}=2, ...,
    {it:m}={it:M} in the imputed and passive variables, along with the number
    of missing values in {it:m}=0.

{p 4 8 2}
{cmd:noupdate}
    in some cases suppresses the automatic {cmd:mi} {cmd:update} this 
    command might perform; 
    see {bf:{help mi_noupdate_option:[MI] noupdate option}}.


{marker examples}{...}
{title:Examples}

{pstd}
Query whether and how data are {cmd:mi set}{break}
(If your data are not {cmd:mi set}, you will receive a message stating this.){p_end}
{phang2}{cmd:. mi query}

{pstd}Setup{p_end}
{phang2}
{cmd:. webuse mheartintreg}
{p_end}

{pstd}Declare data{p_end}
{phang2}
{cmd:. mi set mlong}
{p_end}

{pstd}
Impute censored BMI values, recorded in the {cmd:lbmi} and {cmd:ubmi}
variables,
using an interval regression{p_end}
{phang2}
{cmd:. mi impute intreg newbmi attack smokes age female hsgrad, add(20) ll(lbmi) ul(ubmi)}
{p_end}

{pstd}Describe resulting {cmd:mi} data{p_end}
{phang2}
{cmd:. mi describe}
{p_end}

{pstd}Check when the last time the data was {cmd:mi} {cmd:update}d{p_end}
{phang2}
{cmd:. mi query}
{p_end}


{marker results}{...}
{title:Stored results}

{p 4 4 2}
{cmd:mi query} stores the following in {cmd:r()}:

{col 9}Scalars
{col 13}{cmd:r(update)}{col 30}seconds since last {cmd:mi update}
{col 13}{cmd:r(m)}{col 30}{it:m} if {cmd:r(style)=="flongsep"}
{col 13}{cmd:r(M)}{col 30}{it:M} if {cmd:r(style)!="flongsep"}

{col 9}Macros
{col 13}{cmd:r(style)}{col 30}{it:style}
{col 13}{cmd:r(name)}{col 30}{it:name} if {cmd:r(style)=="flongsep"}


{p 8 8 2}
Note that {cmd:mi query} issues a return code of 0 even if the data 
are not {cmd:mi}.  In that case, {cmd:r(style)} is "".

{p 4 4 2}
{cmd:mi describe} stores the following in {cmd:r()}:

{col 9}Scalars
{col 13}{cmd:r(update)}{col 30}seconds since last {cmd:mi update}
{col 13}{cmd:r(N)}{col 30}number of observations in {it:m}=0
{col 13}{cmd:r(N_incomplete)}{col 30}number of incomplete observations in {it:m}=0
{col 13}{cmd:r(N_complete)}{col 30}number of complete observations in {it:m}=0
{col 13}{cmd:r(M)}{col 30}{it:M}

{col 9}Macros
{col 13}{cmd:r(style)}{col 30}{it:style}
{col 13}{cmd:r(ivars)}{col 30}names of imputed variables
{col 13}{cmd:r(_0_miss_ivars)}{col 30}{it:#} = {cmd:.} in each {cmd:r(ivars)} in {it:m}=0
{col 13}{cmd:r(_0_hard_ivars)}{col 30}{it:#} > {cmd:.} in each {cmd:r(ivars)} in {it:m}=0

{col 13}{cmd:r(pvars)}{col 30}names of passive variables
{col 13}{cmd:r(_0_miss_pvars)}{col 30}{it:#} >= {cmd:.} in each {cmd:r(pvars)} in {it:m}=0

{col 13}{cmd:r(rvars)}{col 30}names of regular variables

{p 8 8 2}
If the {cmd:detail} option is specified, for each {it:m}, {it:m}=1, 2, ...,
{it:M}, also stored are

{col 9}Macros
{col 13}{cmd:r(_}{it:m}{cmd:_miss_ivars)}{col 30}{it:#} = {cmd:.} in each {cmd:r(ivars)} in {it:m}
{col 13}{cmd:r(_}{it:m}{cmd:_miss_pvars)}{col 30}{it:#} >= {cmd:.} in each {cmd:r(pvars)} in {it:m}
