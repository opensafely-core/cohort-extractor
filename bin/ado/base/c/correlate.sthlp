{smcl}
{* *! version 1.2.1  18feb2020}{...}
{viewerdialog correlate "dialog correlate"}{...}
{viewerdialog pwcorr "dialog pwcorr"}{...}
{vieweralsosee "[R] correlate" "mansection R correlate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] esize" "help esize"}{...}
{vieweralsosee "[R] estat vce" "help estat vce"}{...}
{vieweralsosee "[R] icc" "help icc"}{...}
{vieweralsosee "[R] pcorr" "help pcorr"}{...}
{vieweralsosee "[R] spearman" "help spearman"}{...}
{vieweralsosee "[R] summarize" "help summarize"}{...}
{vieweralsosee "[R] tetrachoric" "help tetrachoric"}{...}
{viewerjumpto "Syntax" "correlate##syntax"}{...}
{viewerjumpto "Menu" "correlate##menu"}{...}
{viewerjumpto "Description" "correlate##description"}{...}
{viewerjumpto "Links to PDF documentation" "correlate##linkspdf"}{...}
{viewerjumpto "Options for correlate" "correlate##options_correlate"}{...}
{viewerjumpto "Options for pwcorr" "correlate##options_pwcorr"}{...}
{viewerjumpto "Examples" "correlate##examples"}{...}
{viewerjumpto "Video example" "correlate##video"}{...}
{viewerjumpto "Stored results" "correlate##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] correlate} {hline 2}}Correlations of variables{p_end}
{p2col:}({mansection R correlate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}Display correlation matrix or covariance matrix

{p 8 18 2}
{opt cor:relate}
[{varlist}]
{ifin}
[{it:{help correlate##weight:weight}}]
[{cmd:,} {it:{help correlate##correlate_options:correlate_options}}]


{phang}Display all pairwise correlation coefficients

{p 8 18 2}
{cmd:pwcorr}
[{varlist}]
{ifin}
[{it:{help correlate##weight:weight}}]
[{cmd:,} {it:{help correlate##pwcorr_options:pwcorr_options}}]


{synoptset 19 tabbed}{...}
{marker correlate_options}{...}
{synopthdr :correlate_options}
{synoptline}
{syntab :Options}
{synopt :{opt m:eans}}display means, standard deviations, minimums, and
maximums with matrix{p_end}
{synopt :{opt nof:ormat}}ignore display format associated with variables{p_end}
{synopt :{opt c:ovariance}}display covariances{p_end}
{synopt :{opt w:rap}}allow wide matrices to wrap{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 19 tabbed}{...}
{marker pwcorr_options}{...}
{synopthdr :pwcorr_options}
{synoptline}
{syntab :Main}
{synopt :{opt o:bs}}print number of observations for each entry{p_end}
{synopt :{opt sig}}print significance level for each entry{p_end}
{synopt :{opt list:wise}}use listwise deletion to handle missing values{p_end}
{synopt :{opt case:wise}}synonym for {opt listwise}{p_end}
{synopt :{opt p:rint(#)}}significance level for displaying coefficients{p_end}
{synopt :{opt st:ar(#)}}significance level for displaying with a star{p_end}
{synopt :{opt b:onferroni}}use Bonferroni-adjusted significance level{p_end}
{synopt :{opt sid:ak}}use Sidak-adjusted significance level{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
{it:varlist} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt by} is allowed with {opt correlate} and {opt pwcorr}; see 
{manhelp by D}.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt aweight}s and {opt fweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

    {title:correlate}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
     {bf:Summary and descriptive statistics > Correlations and covariances}

    {title:pwcorr}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
      {bf:Summary and descriptive statistics > Pairwise correlations}


{marker description}{...}
{title:Description}

{pstd}
The {opt correlate} command displays the correlation matrix or covariance
matrix for a group of variables. If {varlist} is not specified, the matrix
is displayed for all variables in the dataset.

{pstd}
{opt pwcorr} displays all the pairwise correlation coefficients between
the variables in {it:varlist} or, if {it:varlist} is not specified, all the
variables in the dataset.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R correlateQuickstart:Quick start}

        {mansection R correlateRemarksandexamples:Remarks and examples}

        {mansection R correlateMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_correlate}{...}
{title:Options for correlate}

{dlgtab:Options}

{phang}
{opt means} displays summary statistics (means, standard deviations,
minimums, and maximums) with the matrix.

{phang}
{opt noformat} displays the summary statistics requested by the
{opt means} option in {opt g} format, regardless of the display formats
associated with the variables.

{phang}
{opt covariance} displays the covariances rather than the correlation
coefficients.

{phang}
{opt wrap} requests that no action be taken on wide correlation matrices to
make them readable.  It prevents Stata from breaking wide matrices into
pieces to enhance readability.
You might want to specify this option if you are displaying results in a
window wider than 80 characters.  Then you may need to 
{opt set linesize} to however many characters you can display across a line;
see {manhelp log R}.


{marker options_pwcorr}{...}
{title:Options for pwcorr}

{dlgtab:Main}

{phang}
{opt obs} adds a line to each row of the matrix reporting the number of
observations used to calculate the correlation coefficient.

{phang}
{opt sig} adds a line to each row of the matrix reporting the
significance level of each correlation coefficient.

{phang}
{opt listwise} handles missing values through listwise deletion, meaning
that the entire observation is omitted from the estimation sample if any of
the variables in {it:varlist} is missing for that observation.  By default,
{cmd:pwcorr} handles missing values by pairwise deletion; all available
observations are used to calculate each pairwise correlation without regard to
whether variables outside that pair are missing.

{pmore}
{cmd:correlate} uses listwise deletion.  Thus, {opt listwise} allows 
users of {cmd:pwcorr} to mimic {cmd:correlate}'s treatment of missing values
while retaining access to {cmd:pwcorr}'s features.

{phang}
{opt casewise} is a synonym for {opt listwise}.

{phang}
{opt print(#)} specifies the significance level of correlation coefficients to
be printed.  Correlation coefficients with larger significance levels are left
blank in the matrix.  Typing {cmd:pwcorr, print(.10)} would list only
correlation coefficients significant at the 10% level or better.

{phang}
{opt star(#)} specifies the significance level of
correlation coefficients to be starred.  Typing {cmd:pwcorr, star(.05)} would
star all correlation coefficients significant at the 5% level or better.

{phang}
{opt bonferroni} makes the Bonferroni adjustment to calculated
significance levels.  This option affects printed significance levels and the
{cmd:print()} and {cmd:star()} options.  Thus,
{bind:{cmd:pwcorr, print(.05) bonferroni}} prints coefficients with
Bonferroni-adjusted significance levels of 0.05 or less.

{phang}
{opt sidak} makes the Sidak adjustment to calculated significance levels.
This option affects printed significance levels and the {cmd:print()} and
{cmd:star()} options.  Thus, {bind:{cmd:pwcorr, print(.05) sidak}} prints
coefficients with Sidak-adjusted significance levels of 0.05 or less.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse census13}{p_end}

{pstd}Estimate correlation matrix{p_end}
{phang2}{cmd:. correlate mrgrate dvcrate medage}{p_end}

{pstd}Estimate covariance matrix; use population as analytic weight{p_end}
{phang2}{cmd:. correlate mrgrate dvcrate medage [aweight=pop], covariance}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Estimate all pairwise correlations{p_end}
{phang2}{cmd:. pwcorr price headroom mpg displacement}{p_end}

{pstd}Add significance level to each entry{p_end}
{phang2}{cmd:. pwcorr price headroom mpg displacement, sig}{p_end}

{pstd}Add stars to correlations significant at the 1% level after Bonferroni
 adjustment{p_end}
{phang2}{cmd:. pwcorr price headroom mpg displacement, star(.01) bonferroni}
{p_end}

    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=o7ko844ff-g":Pearson's correlation coefficient in Stata}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:correlate} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(rho)}}rho (first and second variables){p_end}
{synopt:{cmd:r(cov_12)}}covariance ({cmd:covariance} only){p_end}
{synopt:{cmd:r(Var_1)}}variance of first variable ({cmd:covariance} only){p_end}
{synopt:{cmd:r(Var_2)}}variance of second variable ({cmd:covariance} only){p_end}
{synopt:{cmd:r(sum_w)}}sum of weights{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(C)}}correlation or covariance matrix{p_end}

{pstd} 
{cmd:pwcorr} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations (first and second variables){p_end}
{synopt:{cmd:r(rho)}}rho (first and second variables){p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(C)}}pairwise correlation matrix{p_end}
{synopt:{cmd:r(sig)}}significance level of each correlation coefficient{p_end}
{p2colreset}{...}
