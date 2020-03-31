{smcl}
{* *! version 1.0.16  12apr2019}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi misstable" "mansection MI mimisstable"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] misstable" "help misstable"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi varying" "help mi_varying"}{...}
{viewerjumpto "Syntax" "mi_misstable##syntax"}{...}
{viewerjumpto "Menu" "mi_misstable##menu"}{...}
{viewerjumpto "Description" "mi_misstable##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_misstable##linkspdf"}{...}
{viewerjumpto "Options" "mi_misstable##options"}{...}
{viewerjumpto "Remarks" "mi_misstable##remarks"}{...}
{viewerjumpto "Examples" "mi_misstable##examples"}{...}
{viewerjumpto "Stored results" "mi_misstable##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[MI] mi misstable} {hline 2}}Tabulate pattern of missing values
{p_end}
{p2col:}({mansection MI mimisstable:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{cmd:mi} 
{cmdab:misstab:le}
{cmdab:sum:marize} [{varlist}]
[{it:{help if}}]
[{cmd:,} {it:options}]

{p 8 8 2}
{cmd:mi} 
{cmdab:misstab:le}
{cmdab:pat:terns}{bind:  }[{varlist}]
[{it:{help if}}]
[{cmd:,} {it:options}]

{p 8 8 2}
{cmd:mi} 
{cmdab:misstab:le}
{cmd:tree}{bind:      }[{varlist}]
[{it:{help if}}]
[{cmd:,} {it:options}]

{p 8 8 2}
{cmd:mi} 
{cmdab:misstab:le}
{cmdab:nest:ed}{bind:    }[{varlist}]
[{it:{help if}}]
[{cmd:,} {it:options}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{cmd:exmiss}}treat {cmd:.a}, {cmd:.b}, ..., {cmd:.z} as missing{p_end}
{synopt:{cmd:m(}{it:#}{cmd:)}}run {cmd:misstable} on
    {it:m}={it:#}; default {it:m}=0{p_end}
{synopt:{it:other_options}}see {bf:{help misstable:[R] misstable}}
   ({bf:generate()} is not allowed; {bf:exok} is assumed){p_end}

{synopt:{cmd:nopreserve}}programmer's option; see
   {bf:{help nopreserve:[P] nopreserve option}}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:misstable} runs 
{cmd:misstable} on {it:m}=0 or on {it:m}={it:#} if the {cmd:m(}{it:#}{cmd:)}
option is specified.  {cmd:misstable} makes tables to help in understanding
the pattern of missing values in your data;
see {bf:{help misstable:[R] misstable}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI mimisstableRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{p 4 8 2}
{cmd:exmiss} 
    specifies that the extended missing values, {cmd:.a}, {cmd:.b}, ...,
    {cmd:.z}, are to be treated as missing.  {cmd:misstable} treats them as
    missing by default and has the {cmd:exok} option to treat them as
    nonmissing.  {cmd:mi} {cmd:misstable} turns that around and has the
    {cmd:exmiss} option.

{p 8 8 2}
    In the {cmd:mi} system, extended missing values that are recorded in
    imputed variables indicate values not to be imputed and thus are, in a
    sense, not missing, or more accurately, missing for a good and valid reason.

{p 8 8 2}
    The {cmd:exmiss} option is intended for use with the {cmd:patterns},
    {cmd:tree}, and {cmd:nested} subcommands.  You may specify {cmd:exmiss}
    with the {cmd:summarize} subcommand, but the option is ignored because 
    {cmd:summarize} reports both extended and system missing in separate 
    columns.

{p 4 8 2}
{cmd:m(}{it:#}{cmd:)} 
    specifies the imputation dataset on which {cmd:misstable} is to be run.
    The default is {it:m}=0, the original data.

{p 4 8 2}
{it:other_options}
     are allowed; see {bf:{help misstable:[R] misstable}}.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
    See {bf:{help misstable:[R] misstable}}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse studentsvy}{p_end}
{phang2}{cmd:. mi describe}{p_end}

{pstd}Report counts of missing values in m = 0{p_end}
{phang2}{cmd:. mi misstable summarize}

{pstd}Report counts of missing values in m = 3{p_end}
{phang2}{cmd:. mi misstable summarize, m(3)}

{pstd}Report the pattern of missing values in m = 7, including
extended missing values{p_end}
{phang2}{cmd:. mi misstable patterns, m(7) exmiss}

{pstd}Replace the dataset in memory with a dataset of the 
pattern of missing values in m = 0{p_end}
{phang2}{cmd:. mi misstable patterns, replace clear}{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse studentsvy, clear}

{pstd}Show tree view of the pattern of missing values in m = 0{p_end}
{phang2}{cmd:. mi misstable tree, frequency}

{pstd}List nesting rules that describe the missing-value pattern in m = 0{p_end}
{phang2}{cmd:. mi misstable nested}

    {hline}


{marker results}{...}
{title:Stored results}

{p 4 4 2}
    See {bf:{help misstable:[R] misstable}}.
{p_end}
