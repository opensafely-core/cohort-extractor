{smcl}
{* *! version 1.2.11  27apr2019}{...}
{viewerdialog "Variables Manager" "stata varmanage"}{...}
{viewerdialog "drop/keep observations" "dialog drop_obs"}{...}
{vieweralsosee "[D] drop" "mansection D drop"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] clear" "help clear"}{...}
{vieweralsosee "[D] frame put" "help frame_put"}{...}
{vieweralsosee "[D] varmanage" "help varmanage"}{...}
{viewerjumpto "Syntax" "drop##syntax"}{...}
{viewerjumpto "Menu" "drop##menu"}{...}
{viewerjumpto "Description" "drop##description"}{...}
{viewerjumpto "Links to PDF documentation" "drop##linkspdf"}{...}
{viewerjumpto "Examples" "drop##examples"}{...}
{viewerjumpto "Stored results" "drop##results"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[D] drop} {hline 2}}Drop variables or observations{p_end}
{p2col:}({mansection D drop:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Drop variables

{p 8 13 2}{cmd:drop} {varlist}


    Drop observations

{p 8 13 2}{cmd:drop} {help if:{bf:if} {it:exp}}


    Drop a range of observations

{p 8 13 2}{cmd:drop} {help in:{bf:in} {it:range}} [{help if:{bf:if} {it:exp}}]


    Keep variables

{p  8 13 2}{cmd:keep} {varlist}


    Keep observations that satisfy specified condition

{p 8 13 2}{cmd:keep} {help if:{bf:if} {it:exp}}


    Keep a range of observations

{p 8 13 2}{cmd:keep} {help in:{bf:in} {it:range}} [{help if:{bf:if} {it:exp}}]


{phang}
{cmd:by} is allowed with the second syntax of {cmd:drop} and the second
syntax of {cmd:keep}; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

    {title:Drop or keep variables}

{phang2}
{bf:Data > Variables Manager}

    {title:Drop or keep observations}

{phang2}
{bf:Data > Create or change data > Drop or keep observations}


{marker description}{...}
{title:Description}

{pstd}
{cmd:drop} eliminates variables or observations from the data in memory.

{pstd}
{cmd:keep} works the same way as {cmd:drop}, except that you specify the
variables or observations to be kept rather than the variables or observations
to be deleted.

{pstd}
Warning: {cmd:drop} and {cmd:keep} are not reversible.  Once you have eliminated
observations, you cannot read them back in again.  You would need to go back to
the original dataset and read it in again.  Instead of applying {cmd:drop} or
{cmd:keep} for a subset analysis, consider using {cmd:if} or {cmd:in} to select
subsets temporarily.  This is usually the best strategy.  Alternatively,
applying {cmd:preserve} followed in due course by {cmd:restore} may be a good
approach.  You can also use {cmd:frame} {cmd:put} to place a subset
of variables or observations from the current dataset into another
frame; see {manhelp frame_put D:frame put}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D dropQuickstart:Quick start}

        {mansection D dropRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse census}{p_end}

{pstd}Describe the data{p_end}
{phang2}{cmd:. describe}

{pstd}Drop all variables with names that begin with {cmd:pop}{p_end}
{phang2}{cmd:. drop pop*}{p_end}

{pstd}Describe the resulting data{p_end}
{phang2}{cmd:. describe}

{pstd}Drop {cmd:marriage} and {cmd:divorce}{p_end}
{phang2}{cmd:. drop marriage divorce}

{pstd}Describe the resulting data{p_end}
{phang2}{cmd:. describe}

{pstd}Drop any observation for which {cmd:medage} is greater than 32{p_end}
{phang2}{cmd:. drop if medage > 32}

{pstd}Drop the first observation for each region{p_end}
{phang2}{cmd:. by region, sort: drop if _n == 1}

{pstd}Drop all but the last observation in each region{p_end}
{phang2}{cmd:. by region: drop if _n != _N}

{pstd}Keep the first 2 observations in the dataset{p_end}
{phang2}{cmd:. keep in 1/2}

{pstd}Describe the resulting data{p_end}
{phang2}{cmd:. describe}

{pstd}Drop all observations and variables{p_end}
{phang2}{cmd:. drop _all}

{pstd}Describe the resulting data{p_end}
{phang2}{cmd:. describe}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:drop} and {cmd:keep} store the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N_drop)}}number of observations dropped{p_end}
{synopt:{cmd:r(k_drop)}}number of variables dropped{p_end}
{p2colreset}{...}
