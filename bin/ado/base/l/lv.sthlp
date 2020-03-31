{smcl}
{* *! version 1.1.8  14may2018}{...}
{viewerdialog lv "dialog lv"}{...}
{vieweralsosee "[R] lv" "mansection R lv"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] Diagnostic plots" "help diagnostic plots"}{...}
{vieweralsosee "[R] stem" "help stem"}{...}
{vieweralsosee "[R] summarize" "help summarize"}{...}
{viewerjumpto "Syntax" "lv##syntax"}{...}
{viewerjumpto "Menu" "lv##menu"}{...}
{viewerjumpto "Description" "lv##description"}{...}
{viewerjumpto "Links to PDF documentation" "lv##linkspdf"}{...}
{viewerjumpto "Options" "lv##options"}{...}
{viewerjumpto "Examples" "lv##examples"}{...}
{viewerjumpto "Stored results" "lv##results"}{...}
{viewerjumpto "References" "lv##references"}{...}
{p2colset 1 11 13 2}{...}
{p2col:{bf:[R] lv} {hline 2}}Letter-value displays{p_end}
{p2col:}({mansection R lv:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:lv} [{varlist}] {ifin} [{cmd:,} {opt g:enerate} {opt t:ail(#)}]

{phang}
{opt by} is allowed; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Summaries, tables, and tests >}
    {bf:Distributional plots and tests > Letter-value display}


{marker description}{...}
{title:Description}

{pstd}
{cmd:lv} shows a letter-value display
({help lv##T1977:Tukey 1977, 44-49};
 {help lv##H1983:Hoaglin 1983}) for
each variable in {varlist}.  If no variables are specified, letter-value
displays are shown for each numeric variable in the data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R lvQuickstart:Quick start}

        {mansection R lvRemarksandexamples:Remarks and examples}

        {mansection R lvMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt generate} adds four new variables to the data:  {opt _mid}, containing
the midsummaries; {opt _spread}, containing the spreads; {opt _psigma},
containing the pseudosigmas; and {opt _z2}, containing the squared values from
a standard normal distribution corresponding to the particular letter value.
If the variables {opt _mid}, {opt _spread}, {opt _psigma}, and {opt _z2}
already exist, their contents are replaced.  At most, only the first 11
observations of each variable are used; the remaining observations contain
missing.  If {varlist} specifies more than one variable, the newly created
variables contain results for the last variable specified.  The {opt generate}
option may not be used with the {cmd:by} prefix.

{phang}
{opt tail(#)} indicates the inverse of the tail density through which letter
values are to be displayed:  2 corresponds to the median (meaning half in each
tail), 4 to the fourths (roughly the 25th and 75th percentiles), 8 to the
eighths, and so on. {it:#} may be specified as 4, 8, 16, 32, 64, 128, 256,
512, or 1,024 and defaults to a value of {it:#} that has corresponding depth
just greater than 1.  The default is taken as 1,024 if the calculation results
in a number larger than 1,024.  Given the intelligent default, this option is
rarely specified.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}Display a letter-value for {cmd:mpg}{p_end}
{phang2}{cmd:. lv mpg}

{pstd}Display a letter-value for {cmd:mpg}, generating four new variables{p_end}
{phang2}{cmd:. lv mpg, generate}

{pstd}Diagnostic for skewness{p_end}
{phang2}{cmd:. scatter _mid _z2}

{pstd}Diagnostic for elongation{p_end}
{phang2}{cmd:. scatter _psigma _z2}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:lv} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(min)}}minimum{p_end}
{synopt:{cmd:r(max)}}maximum{p_end}
{synopt:{cmd:r(median)}}median{p_end}
{synopt:{cmd:r(l_F)}}lower 4th{p_end}
{synopt:{cmd:r(u_F)}}upper 4th{p_end}
{synopt:{cmd:r(l_E)}}lower 8th{p_end}
{synopt:{cmd:r(u_E)}}upper 8th{p_end}
{synopt:{cmd:r(l_D)}}lower 16th{p_end}
{synopt:{cmd:r(u_D)}}upper 16th{p_end}
{synopt:{cmd:r(l_C)}}lower 32nd{p_end}
{synopt:{cmd:r(u_C)}}upper 32nd{p_end}
{synopt:{cmd:r(l_B)}}lower 64th{p_end}
{synopt:{cmd:r(u_B)}}upper 64th{p_end}
{synopt:{cmd:r(l_A)}}lower 128th{p_end}
{synopt:{cmd:r(u_A)}}upper 128th{p_end}
{synopt:{cmd:r(l_Z)}}lower 256th{p_end}
{synopt:{cmd:r(u_Z)}}upper 256th{p_end}
{synopt:{cmd:r(l_Y)}}lower 512th{p_end}
{synopt:{cmd:r(u_Y)}}upper 512th{p_end}
{synopt:{cmd:r(l_X)}}lower 1024th{p_end}
{synopt:{cmd:r(u_X)}}upper 1024th{p_end}

{pstd}
The lower/upper 8ths, 16ths, ..., 1024ths will be defined only if there are
sufficient data.
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker H1983}{...}
{phang}
Hoaglin, D. C. 1983.
Letter values:  A set of selected order statistics.  In
{it:Understanding Robust and Exploratory Data Analysis},
ed. D. C. Hoaglin, F. Mosteller, and J. W. Tukey, 33-57.
New York: Wiley.

{marker T1977}{...}
{phang}
Tukey, J. W. 1977.
{it:Exploratory Data Analysis}.
Reading, MA: Addison-Wesley.
{p_end}
