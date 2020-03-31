{smcl}
{* *! version 1.2.14  14may2018}{...}
{viewerdialog swilk "dialog swilk"}{...}
{viewerdialog sfrancia "dialog sfrancia"}{...}
{vieweralsosee "[R] swilk" "mansection R swilk"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] Diagnostic plots" "help diagnostic plots"}{...}
{vieweralsosee "[R] lnskew0" "help lnskew0"}{...}
{vieweralsosee "[R] lv" "help lv"}{...}
{vieweralsosee "[MV] mvtest normality" "help mvtest_normality"}{...}
{vieweralsosee "[R] sktest" "help sktest"}{...}
{viewerjumpto "Syntax" "swilk##syntax"}{...}
{viewerjumpto "Menu" "swilk##menu"}{...}
{viewerjumpto "Description" "swilk##description"}{...}
{viewerjumpto "Links to PDF documentation" "swilk##linkspdf"}{...}
{viewerjumpto "Options for swilk" "swilk##options_swilk"}{...}
{viewerjumpto "Options for sfrancia" "swilk##options_sfrancia"}{...}
{viewerjumpto "Remarks" "swilk##remarks"}{...}
{viewerjumpto "Examples" "swilk##examples"}{...}
{viewerjumpto "Stored results" "swilk##results"}{...}
{viewerjumpto "References" "swilk##references"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] swilk} {hline 2}}Shapiro-Wilk and Shapiro-Francia tests for
normality{p_end}
{p2col:}({mansection R swilk:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Shapiro-Wilk normality test

{p 8 17 2}
{cmd:swilk} {varlist} {ifin} [{cmd:,}
         {it:{help swilk##swilk_options:swilk_options}}]


{pstd}
Shapiro-Francia normality test

{p 8 17 2}
{cmd:sfrancia} {varlist} {ifin} [{cmd:,}
          {it:{help swilk##sfrancia_options:sfrancia_options}}]


{marker swilk_options}{...}
{synoptset 20 tabbed}{...}
{synopthdr :swilk_options}
{synoptline}
{syntab:Main}
{synopt:{opth g:enerate(newvar)}}create {it:newvar} containing W test coefficients
{p_end}
{synopt:{opt l:nnormal}}test for three-parameter lognormality
{p_end}
{synopt:{opt not:ies}}do not use average ranks for tied values
{p_end}
{synoptline}
{p2colreset}{...}


{marker sfrancia_options}{...}
{synoptset 20 tabbed}{...}
{synopthdr :sfrancia_options}
{synoptline}
{syntab:Main}
{synopt:{opt boxcox}}use the Box-Cox transformation for W'; the default is to use the log transformation{p_end}
{synopt:{opt not:ies}}do not use average ranks for tied values{p_end}
{synoptline}
{p2colreset}{...}


{p 4 6 2}
{opt by} is allowed with {opt swilk} and {opt sfrancia}; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

    {title:swilk}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
    {bf:Distributional plots and tests > Shapiro-Wilk normality test}

    {title:sfrancia}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
     {bf:Distributional plots and tests > Shapiro-Francia normality test}


{marker description}{...}
{title:Description}

{pstd}
{opt swilk} performs the Shapiro-Wilk W test for normality for each
variable in the specified varlist.  Likewise, {cmd:sfrancia} performs the
Shapiro-Francia W' test for normality.
See {manhelp mvtest_normality MV:mvtest normality} for multivariate tests of
normality.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R swilkQuickstart:Quick start}

        {mansection R swilkRemarksandexamples:Remarks and examples}

        {mansection R swilkMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_swilk}{...}
{title:Options for swilk}

{dlgtab:Main}

{phang}
{opth generate(newvar)} creates new variable {it:newvar} containing the W
test coefficients.

{phang}
{opt lnnormal} specifies that the test be for three-parameter
lognormality, meaning that ln(X-k) is tested for normality, where k is
calculated from the data as the value that makes the skewness coefficient
zero.  When simply testing ln(X) for normality, do not specify this option.
See {manhelp lnskew0 R} for estimation of k.

{phang}
{opt noties} suppresses use of averaged ranks for tied values when
calculating the W test coefficients.


{marker options_sfrancia}{...}
{title:Options for sfrancia}

{dlgtab:Main}

{phang} 
{opt boxcox} specifies that the Box-Cox transformation of 
{help swilk##R1983:Royston (1983)} for
calculating W' test coefficients be used instead of the default log
transformation ({help swilk##R1993:Royston 1993}).  Under the Box-Cox
transformation, the normal
approximation to the sampling distribution of W', used by {cmd:sfrancia}, is
valid for 5<=n<=1000.  Under the log transformation, it is valid for
10<=n<=5000.

{phang}
{opt noties} suppresses use of averaged ranks for tied values when
calculating the W' test coefficients.


{marker remarks}{...}
{title:Remarks}

{pstd}
{opt swilk} can be used with 4<=n<=2000 observations. {opt sfrancia} can
be used with 10<=n<=5000 observations; however, if the {opt boxcox} option
is specified, it can be used with 5<=n<=1000 observations.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Test whether {cmd:mpg} and {cmd:trunk} are normally distributed{p_end}
{phang2}{cmd:. swilk mpg trunk}{p_end}

    {hline}
    Setup
{phang2}{cmd:. sysuse cancer}{p_end}
{phang2}{cmd:. generate lnstudytime = ln(studytime)}{p_end}

{pstd}Test that {cmd:studytime} is distributed lognormally{p_end}
{phang2}{cmd:. swilk lnstudytime}{p_end}

{pstd}Test that ln({cmd:studytime} - k) is normally distributed, where k is
chosen so that the resulting skewness is zero{p_end}
{phang2}{cmd:. lnskew0 lnstudytimek = studytime, level(95)}{p_end}
{phang2}{cmd:. swilk lnstudytimek, lnnormal}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse lbw, clear}{p_end}

{pstd}Perform Shapiro-Francia normality test using default log transformation
{p_end}
{phang2}{cmd:. sfrancia bwt}{p_end}

{pstd}Perform Shapiro-Francia normality test using Box-Cox transformation{p_end}
{phang2}{cmd:. sfrancia bwt, boxcox}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:swilk} and {cmd:sfrancia} store the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(p)}}p-value{p_end}
{synopt:{cmd:r(z)}}z statistic{p_end}
{synopt:{cmd:r(W)}}W or W'{p_end}
{synopt:{cmd:r(V)}}V or V'{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker R1983}{...}
{phang}
Royston, P. 1983.  A simple method for evaluating the Shapiro-Francia W' test
for non-normality.  {it:Statistician} 32: 297-300.

{marker R1993}{...}
{phang}
------. 1993.  A pocket-calculator algorithm for the Shapiro-Francia test
for non-normality: An application to medicine.  {it:Statistics in Medicine}
12: 181-184.
{p_end}
