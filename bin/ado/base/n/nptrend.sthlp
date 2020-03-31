{smcl}
{* *! version 1.2.6  15may2018}{...}
{viewerdialog nptrend "dialog nptrend"}{...}
{vieweralsosee "[R] nptrend" "mansection R nptrend"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] Epitab" "help epitab"}{...}
{vieweralsosee "[R] kwallis" "help kwallis"}{...}
{vieweralsosee "[R] signrank" "help signrank"}{...}
{vieweralsosee "[R] spearman" "help spearman"}{...}
{vieweralsosee "[ST] strate" "help strate"}{...}
{vieweralsosee "[R] symmetry" "help symmetry"}{...}
{viewerjumpto "Syntax" "nptrend##syntax"}{...}
{viewerjumpto "Menu" "nptrend##menu"}{...}
{viewerjumpto "Description" "nptrend##description"}{...}
{viewerjumpto "Links to PDF documentation" "nptrend##linkspdf"}{...}
{viewerjumpto "Options" "nptrend##options"}{...}
{viewerjumpto "Example" "nptrend##example"}{...}
{viewerjumpto "Stored results" "nptrend##results"}{...}
{viewerjumpto "References" "nptrend##references"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] nptrend} {hline 2}}Test for trend across ordered groups{p_end}
{p2col:}({mansection R nptrend:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:nptrend} {varname} {ifin} {cmd:,} {opth by:(varlist:groupvar)}
[{opt nod:etail} {opt nol:abel} {opt s:core(scorevar)}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Nonparametric analysis > Tests of hypotheses >}
     {bf:Trend test across ordered groups}


{marker description}{...}
{title:Description}

{pstd}
{opt nptrend} performs the nonparametric test for trend across ordered groups.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R nptrendQuickstart:Quick start}

        {mansection R nptrendRemarksandexamples:Remarks and examples}

        {mansection R nptrendMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth by:(varlist:groupvar)} is required; it specifies the group on which the
data are to be ordered.

{phang}
{opt nodetail} suppresses the listing of group rank sums. 

{phang}
{opt nolabel} specifies that {cmd:group()} values be displayed instead of
value labels.

{phang}
{opt score(scorevar)} defines scores for groups.  When it is not specified,
the values of {it:{help varlist:groupvar}} are used for the scores.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sg}{p_end}

{pstd}Test for trend of increasing exposure across the 3 groups defined by
group{p_end}
{phang2}{cmd:. nptrend exposure, by(group)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:nptrend} stores the following in {cmd:r()}:

{synoptset 10 tabbed}{...}
{p2col 5 10 14 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}
{synopt:{cmd:r(z)}}z statistic{p_end}
{synopt:{cmd:r(T)}}test statistic{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker C1999}{...}
{phang}
Conover, W. J. 1999.
{it:Practical Nonparametric Statistics}, 3rd ed.
New York: Wiley.

{marker C1985}{...}
{phang}
Cuzick, J. 1985. A Wilcoxon-type test for trend.
{it:Statistics in Medicine} 4: 87-90.
{p_end}
