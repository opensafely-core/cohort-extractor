{smcl}
{* *! version 1.1.6  19oct2017}{...}
{viewerdialog vecnorm "dialog vecnorm"}{...}
{vieweralsosee "[TS] vecnorm" "mansection TS vecnorm"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] varnorm" "help varnorm"}{...}
{vieweralsosee "[TS] vec" "help vec"}{...}
{vieweralsosee "[TS] vec intro" "help vec_intro"}{...}
{viewerjumpto "Syntax" "vecnorm##syntax"}{...}
{viewerjumpto "Menu" "vecnorm##menu"}{...}
{viewerjumpto "Description" "vecnorm##description"}{...}
{viewerjumpto "Links to PDF documentation" "vecnorm##linkspdf"}{...}
{viewerjumpto "Options" "vecnorm##options"}{...}
{viewerjumpto "Examples" "vecnorm##examples"}{...}
{viewerjumpto "Stored results" "vecnorm##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[TS] vecnorm} {hline 2}}Test for normally distributed disturbances after vec{p_end}
{p2col:}({mansection TS vecnorm:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 19 2}
{cmd:vecnorm} [{cmd:,} {it:options}]

{synoptset}{...}
{synopthdr}
{synoptline}
{synopt :{opt j:bera}}report Jarque-Bera statistic; default is to report all
  three statistics{p_end}
{synopt :{opt s:kewness}}report skewness statistic; default is to report all
  three statistics{p_end}
{synopt :{opt k:urtosis}}report kurtosis statistic; default is to report all
  three statistics{p_end}
{synopt :{opt est:imates(estname)}}use previously stored results {it:estname};
  default is to use active results{p_end}
{synopt :{opt dfk}}make small-sample adjustment when computing the estimated
  variance-covariance matrix of the disturbances{p_end}
{synopt :{opt sep:arator(#)}}draw separator line after every {it:#}
  rows{p_end}
{synoptline}
{p 4 6 2}{cmd:vecnorm} can be used only after {cmd:vec}; see
{helpb vec:[TS] vec}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > VEC diagnostics and tests >}
      {bf:Test for normally distributed disturbances}


{marker description}{...}
{title:Description}

{pstd}
{cmd:vecnorm} computes and reports a series of statistics against the null 
hypothesis that the disturbances in a VECM are normally distributed.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS vecnormQuickstart:Quick start}

        {mansection TS vecnormRemarksandexamples:Remarks and examples}

        {mansection TS vecnormMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt jbera} requests that the Jarque-Bera statistic and any other explicitly
requested statistic be reported.  By default, the Jarque-Bera, skewness, and
kurtosis statistics are reported.

{phang}
{opt skewness} requests that the skewness statistic and any other explicitly
requested statistic be reported.  By default, the Jarque-Bera, skewness, and
kurtosis statistics are reported.

{phang}
{opt kurtosis} requests that the kurtosis statistic and any other explicitly
requested statistic be reported.  By default, the Jarque-Bera, skewness, and
kurtosis statistics are reported.

{phang}
{opt estimates(estname)} requests that {cmd:vecnorm} use the previously
obtained set of {cmd:vec} estimates stored as {it:estname}.  By default, 
{cmd:vecnorm} uses the active results.  See {manhelp estimates R} for more
information on manipulating estimation results.

{phang} 
{opt dfk} requests that a small-sample adjustment be made when computing the 
estimated variance-covariance matrix of the disturbances.

{phang}
{opt separator(#)} specifies how many rows should appear in the table between
separator lines.  By default, separator lines do not appear.  For example,
{cmd:separator(1)} would draw a line between each row, {cmd:separator(2)}
between every other row, and so on.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rdinc}{p_end}

{pstd}Fit vector error-correction model{p_end}
{phang2}{cmd:. vec ln_ne ln_se}

{pstd}Test for normally distributed disturbances after {cmd:vec}{p_end}
{phang2}{cmd:. vecnorm}{p_end}

{pstd}Same as above, but report only skewness and kurtosis statistics{p_end}
{phang2}{cmd:. vecnorm, skewness kurtosis}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:vecnorm} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(dfk)}}{cmd:dfk}, if specified{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(jb)}}Jarque-Bera chi-squared, df, and p-values{p_end}
{synopt:{cmd:r(skewness)}}skewness chi-squared, df, and p-values{p_end}
{synopt:{cmd:r(kurtosis)}}kurtosis chi-squared, df, and p-values{p_end}
{p2colreset}{...}
