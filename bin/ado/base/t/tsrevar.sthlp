{smcl}
{* *! version 1.1.5  02aug2018}{...}
{vieweralsosee "[TS] tsrevar" "mansection TS tsrevar"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] fvrevar" "help fvrevar"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{vieweralsosee "[P] unab" "help unab"}{...}
{viewerjumpto "Syntax" "tsrevar##syntax"}{...}
{viewerjumpto "Description" "tsrevar##description"}{...}
{viewerjumpto "Links to PDF documentation" "tsrevar##linkspdf"}{...}
{viewerjumpto "Options" "tsrevar##options"}{...}
{viewerjumpto "Examples" "tsrevar##examples"}{...}
{viewerjumpto "Stored results" "tsrevar##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[TS] tsrevar} {hline 2}}Time-series operator programming 
command{p_end}
{p2col:}({mansection TS tsrevar:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:tsrevar} [{varlist}] {ifin} [{cmd:,} {opt sub:stitute} {opt l:ist}]

{phang}
You must {cmd:tsset} your data before using {cmd:tsrevar}; see
{helpb tsset:[TS] tsset}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:tsrevar, substitute} takes a {varlist} that might contain
{it:op.varname} combinations and substitutes equivalent temporary variables
for the combinations.

{pstd}
{cmd:tsrevar, list} creates no new variables.  It returns in {hi:r(varlist)}
the list of base variables corresponding to {it:varlist}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS tsrevarQuickstart:Quick start}

        {mansection TS tsrevarRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:substitute} specifies that {cmd:tsrevar} resolve {it:op.varname}
combinations by creating temporary variables as described above.
{cmd:substitute} is the default action taken by {cmd:tsrevar}; you do not need
to specify the option.

{phang}
{cmd:list} specifies that {cmd:tsrevar} return a list of
base variable names.


{marker examples}{...}
{title:Example: tsrevar, substitute}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse tsrevarex}

{pstd}Display how data are currently {cmd:tsset}{p_end}
{phang2}{cmd:. tsset}

{pstd}Describe the data{p_end}
{phang2}{cmd:. describe}

{pstd}Create two temporary variables containing the values for {cmd:l.gnp} and
{cmd:d.gnp}{p_end}
{phang2}{cmd:. tsrevar l.gnp d.gnp r}

{pstd}Show contents of {cmd:r(varlist)}{p_end}
{phang2}{cmd:. display "`r(varlist)'"}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list gnp `r(varlist)' in 1/5}


{title:Example: tsrevar, list}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse tsrevarex}

{pstd}Create no new variables, but return in {cmd:r(varlist)} the list of base
variable names{p_end}
{phang2}{cmd:. tsrevar l.gnp d.gnp r, list}

{pstd}Show contents of {cmd:r(varlist)}{p_end}
{phang2}{cmd:. display "`r(varlist)'"}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tsrevar} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(varlist)}}the modified variable list or list of base variable
names{p_end}
{p2colreset}{...}
