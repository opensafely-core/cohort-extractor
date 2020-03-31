{smcl}
{* *! version 1.4.16  19oct2017}{...}
{viewerdialog misstable "dialog misstable"}{...}
{vieweralsosee "[R] misstable" "mansection R misstable"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi misstable" "help mi_misstable"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] summarize" "help summarize"}{...}
{vieweralsosee "[R] tabulate oneway" "help tabulate_oneway"}{...}
{vieweralsosee "[R] tabulate twoway" "help tabulate_twoway"}{...}
{viewerjumpto "Syntax" "misstable##syntax"}{...}
{viewerjumpto "Menu" "misstable##menu"}{...}
{viewerjumpto "Description" "misstable##description"}{...}
{viewerjumpto "Links to PDF documentation" "misstable##linkspdf"}{...}
{viewerjumpto "Options for misstable summarize" "misstable##options_summarize"}{...}
{viewerjumpto "Options for misstable patterns" "misstable##options_patterns"}{...}
{viewerjumpto "Options for misstable tree" "misstable##options_tree"}{...}
{viewerjumpto "Option for misstable nested" "misstable##option_nested"}{...}
{viewerjumpto "Common options" "misstable##options_common"}{...}
{viewerjumpto "Examples" "misstable##examples"}{...}
{viewerjumpto "Stored results" "misstable##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] misstable} {hline 2}}Tabulate missing values
{p_end}
{p2col:}({mansection R misstable:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Report counts of missing values

{p 8 12 2}
{cmd:misstable} {cmdab:sum:marize}
[{varlist}]
{ifin}
[{cmd:,}
{it:{help misstable##summarize_options:summarize_options}}]


    Report pattern of missing values

{p 8 12 2}
{cmd:misstable} {cmdab:pat:terns}
[{varlist}]
{ifin}
[{cmd:,}
{it:{help misstable##patterns_options:patterns_options}}]


    Present a tree view of the pattern of missing values

{p 8 12 2}
{cmd:misstable} {cmd:tree}
[{varlist}]
{ifin}
[{cmd:,}
{it:{help misstable##tree_options:tree_options}}]


    List the nesting rules that describe the missing-value pattern

{p 8 12 2}
{cmd:misstable} {cmdab:nest:ed}
[{varlist}]
{ifin}
[{cmd:,}
{it:{help misstable##nested_options:nested_options}}]


{marker summarize_options}{...}
{synoptset 22}{...}
{synopthdr:summarize_options}
{synoptline}
{synopt :{cmd:all}}show all variables{p_end}
{synopt :{cmdab:show:zeros}}show zeros in table{p_end}
{synopt :{cmdab:gen:erate(}{it:stub} [{cmd:, exok}]{cmd:)}}generate missing-value indicators{p_end}
{synoptline}


{marker patterns_options}{...}
{synopthdr:patterns_options}
{synoptline}
{synopt :{cmd:asis}}use variables in order given{p_end}
{synopt :{cmdab:freq:uency}}report frequencies instead of percentages{p_end}
{synopt :{cmd:exok}}treat {cmd:.a}, {cmd:.b}, ..., {cmd:.z} as nonmissing{p_end}
{synopt :{cmd:replace}}replace data in memory with dataset of patterns{p_end}
{synopt :{cmd:clear}}okay to replace even if original unsaved{p_end}
{synopt :{cmdab:bypat:terns}}list by patterns rather than by frequency{p_end}
{synoptline}


{marker tree_options}{...}
{synopthdr:tree_options}
{synoptline}
{synopt :{cmd:asis}}use variables in order given{p_end}
{synopt :{cmdab:freq:uency}}report frequencies instead of percentages{p_end}
{synopt :{cmd:exok}}treat {cmd:.a}, {cmd:.b}, ..., {cmd:.z} as nonmissing{p_end}
{synoptline}


{marker nested_options}{...}
{synopthdr:nested_options}
{synoptline}
{synopt :{cmd:exok}}treat {cmd:.a}, {cmd:.b}, ..., {cmd:.z} as nonmissing{p_end}
{synoptline}


{p 4 4 2}
In addition, programmer's option 
{cmd:nopreserve} is allowed with all syntaxes;
see {bf:{help nopreserve_option:[P] nopreserve option}}.
{* do not even think of mentioning that nopreserve does not appear}{...}
{* in the dialog box.  Of course it doesn't.}{...}
  

{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Summaries, tables, and tests > Other tables > }
   {bf:Tabulate missing values}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:misstable} makes tables that help you understand the pattern of missing
values in your data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R misstableQuickstart:Quick start}

        {mansection R misstableRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_summarize}{...}
{title:Options for misstable summarize}

{p 4 8 2}
{cmd:all} 
    specifies that the table should include all the variables specified or 
    all the variables in the dataset.  The default is to include 
    only numeric variables that contain missing values.

{p 4 8 2}
{cmd:showzeros} 
    specifies that zeros in the table should display as 0 rather than 
    being omitted. 

{p 4 8 2}
{cmd:generate(}{it:stub} [{cmd:, exok}]{cmd:)} 
requests that a missing-value indicator {it:newvar}, a new binary variable
containing {cmd:0} for complete observations and {cmd:1} for incomplete
observations, be generated for every numeric variable in {it:varlist}
containing missing values.  If the {cmd:all} option is specified, missing-value
indicators are created for all the numeric variables specified or for all the
numeric variables in the dataset.  If {cmd:exok} is specified within
{cmd:generate()}, the extended missing values {cmd:.a}, {cmd:.b}, ..., {cmd:.z}
are treated as if they do not designate missing.

{p 8 8 2}
   For each variable in {it:varlist}, {it:newvar} is the corresponding
   variable name {it:varname} prefixed with {it:stub}.  If the total length of
   {it:stub} and {it:varname} exceeds {ccl namelenchar} characters, {it:newvar} is
   abbreviated so that its name does not exceed {ccl namelenchar} characters.


{marker options_patterns}{...}
{title:Options for misstable patterns}

{p 4 8 2}
{cmd:asis}, {cmd:frequency}, and {cmd:exok} -- see
     {it:{help misstable##commonopts:Common options}} below.

{p 4 8 2}
{cmd:replace}
    specifies that the data in memory be replaced with a dataset 
    corresponding to the table just displayed; see 
    {mansection R misstableRemarksandexamplesmisstablepatterns:{it:misstable patterns}}
    in {bf:[R] misstable}.

{p 4 8 2}
{cmd:clear}
    is for use with {cmd:replace}; it
    specifies that it is okay to change the data in memory even if they
    have not been saved to disk.

{p 4 8 2}
{cmd:bypatterns}
    specifies the table be ordered by pattern rather than by frequency.
    That is, {cmd:bypatterns} 
    specifies that patterns containing one incomplete variable be listed 
    first, followed by those for two incomplete variables, and so on.
    The default is to list the most frequent pattern first, 
    followed by the next most frequent pattern, etc.


{marker options_tree}{...}
{title:Options for misstable tree}

{p 4 8 2}
{cmd:asis}, {cmd:frequency}, and {cmd:exok} -- see 
     {it:{help misstable##commonopts:Common options}} below.


{marker option_nested}{...}
{title:Option for misstable nested}

{p 4 8 2}
{cmd:exok} -- see 
     {it:{help misstable##commonopts:Common options}} below.


{marker options_common}{...}
{marker commonopts}{...}
{title:Common options}

{p 4 8 2}
{cmd:asis} 
    specifies that the order of the variables in the table be the same 
    as the order in which they are specified on the {cmd:misstable} 
    command.  
    The default is to order the variables 
    by the number of missing values, and within that, by the amount 
    of overlap of missing values.

{p 4 8 2}
{cmd:frequency} 
    specifies that the table should report frequencies instead of percentages.

{p 4 8 2}
{cmd:exok} 
    specifies that the extended missing values {cmd:.a}, {cmd:.b}, ..., 
    {cmd:.z} should be treated as if they do not designate missing.  
    Some users use extended missing values to designate values that are 
    missing for a known and valid reason.

{p 4 8 2}
{cmd:nopreserve} is a programmer's option allowed with all 
    {cmd:misstable} commands;
    see {bf:{help nopreserve_option:[P] nopreserve option}}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse studentsurvey}{p_end}

{pstd}Report counts of missing values{p_end}
{phang2}{cmd:. misstable summarize}{p_end}

{pstd}Report counts of missing values and create missing-value indicators{p_end}
{phang2}{cmd:. misstable summarize, generate(miss_)}{p_end}
{phang2}{cmd:. describe miss_*}{p_end}

{pstd}Report the pattern of missing values{p_end}
{phang2}{cmd:. misstable patterns}{p_end}

{pstd}Same as above, but also obtain dataset of the patterns{p_end}
{phang2}{cmd:. misstable patterns, replace clear}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse studentsurvey, clear}{p_end}

{pstd}Show tree view of the pattern of missing values{p_end}
{phang2}{cmd:. misstable tree, frequency}{p_end}

{pstd}List nesting rules that describe the missing-value pattern{p_end}
{phang2}{cmd:. misstable nested}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{p 4 4 2}
{cmd:misstable summarize} stores the following 
values of the last variable summarized in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N_eq_dot)}}number of observations containing {cmd:.}{p_end}
{synopt:{cmd:r(N_gt_dot)}}number of observations containing {cmd:.a}, {cmd:.b}, ..., {cmd:.z}{p_end}
{synopt:{cmd:r(N_lt_dot)}}number of observations containing nonmissing{p_end}
{synopt:{cmd:r(K_uniq)}  }number of unique, nonmissing values{p_end}
{synopt:{cmd:r(min)}     }variable's minimum value{p_end}
{synopt:{cmd:r(max)}     }variable's maximum value{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(vartype)}}{cmd:numeric}, {cmd:string}, or {cmd:none}{p_end}

{p 6 6 2}
    {cmd:r(K_uniq)} contains {cmd:.} if the number of unique, nonmissing
    values is greater than 500.  {cmd:r(vartype)} contains {cmd:none} if no
    variables are summarized, and in that case, the value of the scalars are
    all set to missing ({cmd:.}).  Programmers intending to access results
    after {cmd:misstable} {cmd:summarize} should specify the {cmd:all} option.


{p 4 4 2}
{cmd:misstable patterns} stores the following in {cmd:r()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N_complete)}}number of complete observations{p_end}
{synopt:{cmd:r(N_incomplete)}}number of incomplete observations{p_end}
{synopt:{cmd:r(K)}          }number of patterns{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(vars)}}variables used in order presented{p_end}

{p 6 6 2}
    {cmd:r(N_complete)} and {cmd:r(N_incomplete)} are defined with respect to
    the variables specified if variables were specified and otherwise, defined
    with respect to all the numeric variables in the dataset.
    {cmd:r(N_complete)} is the number of observations that contain no 
    missing values.  


{p 4 4 2}
{cmd:misstable tree} stores the following in {cmd:r()}:

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(vars)}}variables used in order presented{p_end}


{p 4 4 2}
{cmd:misstable nested} stores the following in {cmd:r()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(K)}}number of statements{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(stmt1)}}first statement{p_end}
{synopt:{cmd:r(stmt2)}}second statement{p_end}
{synopt: . }.{p_end}
{synopt: . }.{p_end}
{synopt:{cmd:r(stmt`r(K)')}}last statement{p_end}
{synopt:{cmd:r(stmt1wc)}}{cmd:r(stmt1)} with missing-value counts{p_end}
{synopt:{cmd:r(vars)}}variables considered{p_end}

{p 6 6 2}
    A statement is encoded "{it:varname}", "{it:varname} {it:op}
    {it:varname}", or "{it:varname} {it:op} {it:varname} {it:op}
    {it:varname}", and so on; {it:op} is either "{cmd:->}" or
    "{cmd:<->}".{p_end}
{p2colreset}{...}
