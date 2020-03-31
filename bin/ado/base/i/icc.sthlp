{smcl}
{* *! version 1.1.7  19oct2017}{...}
{viewerdialog "icc" "dialog icc"}{...}
{vieweralsosee "[R] icc" "mansection R icc"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] alpha" "help alpha"}{...}
{vieweralsosee "[R] anova" "help anova"}{...}
{vieweralsosee "[R] correlate" "help correlate"}{...}
{vieweralsosee "[R] loneway" "help loneway"}{...}
{viewerjumpto "Syntax" "icc##syntax"}{...}
{viewerjumpto "Menu" "icc##menu"}{...}
{viewerjumpto "Description" "icc##description"}{...}
{viewerjumpto "Links to PDF documentation" "icc##linkspdf"}{...}
{viewerjumpto "Options for one-way RE model" "icc##options_oneway"}{...}
{viewerjumpto "Options for two-way RE and ME model" "icc##options_twoway"}{...}
{viewerjumpto "Examples" "icc##examples"}{...}
{viewerjumpto "Stored results" "icc##results"}{...}
{p2colset 1 12 12 2}{...}
{p2col:{bf:[R] icc} {hline 2}}Intraclass correlation coefficients{p_end}
{p2col:}({mansection R icc:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Calculate intraclass correlations for one-way random-effects model

{p 8 16 2}
{cmd:icc} {depvar} {it:{help varname:target}} {ifin} [{cmd:,}
    {help icc##oneway_options:{it:oneway_options}}]


{pstd}
Calculate intraclass correlations for two-way random-effects model

{p 8 16 2}
{cmd:icc} {depvar} {it:{help varname:target}} {it:{help varname:rater}}
     {ifin} [{cmd:,} 
     {help icc##twoway_re_options:{it:twoway_re_options}}]


{pstd}
Calculate intraclass correlations for two-way mixed-effects model

{p 8 16 2}
{cmd:icc} {depvar} {it:{help varname:target}} {it:{help varname:rater}}
     {ifin}{cmd:,} {cmd:mixed}
     [{help icc##twoway_me_options:{it:twoway_me_options}}]


{marker oneway_options}{...}
{synoptset 22 tabbed}{...}
{synopthdr:oneway_options}
{synoptline}
{syntab:Main}
{synopt:{opt abs:olute}}estimate absolute agreement; the default{p_end}
{synopt:{opt testval:ue(#)}}test whether intraclass correlations equal {it:#}; 
    default is {cmd:testvalue(0)}{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt f:ormat}{cmd:(%}{it:{help format:fmt}}{cmd:)}}display format 
    for statistics and confidence intervals; default is {cmd:format(%9.0g)}
{p_end}
{synoptline}
{p2colreset}{...}


{marker twoway_re_options}{...}
{synoptset 22 tabbed}{...}
{synopthdr:twoway_re_options}
{synoptline}
{syntab:Main}
{synopt:{opt abs:olute}}estimate absolute agreement; the default{p_end}
{synopt:{opt cons:istency}}estimate consistency of agreement{p_end}
{synopt:{opt testval:ue(#)}}test whether intraclass correlations equal {it:#}; 
    default is {cmd:testvalue(0)}{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt f:ormat}{cmd:(%}{it:{help format:fmt}}{cmd:)}}display format 
    for statistics and confidence intervals; default is {cmd:format(%9.0g)}
{p_end}
{synoptline}
{p2colreset}{...}


{marker twoway_me_options}{...}
{synoptset 22 tabbed}{...}
{synopthdr:twoway_me_options}
{synoptline}
{syntab:Main}
{p2coldent:* {opt mixed}}estimate intraclass correlations for a 
    mixed-effects model{p_end}
{synopt:{opt cons:istency}}estimate consistency of agreement; the default{p_end}
{synopt:{opt abs:olute}}estimate absolute agreement{p_end}
{synopt:{opt testval:ue(#)}}test whether intraclass correlations equal {it:#}; 
    default is {cmd:testvalue(0)}{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt f:ormat}{cmd:(%}{it:{help format:fmt}}{cmd:)}}display format 
    for statistics and confidence intervals; default is {cmd:format(%9.0g)}
{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt mixed} is required.{p_end}


{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, and {cmd:statsby} are
 allowed; see {help prefix}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Summaries, tables, and tests >}
     {bf:Summary and descriptive statistics > Intraclass correlations}


{marker description}{...}
{title:Description}

{pstd}
{opt icc} estimates intraclass correlations for one-way random-effects models, 
two-way random-effects models, or two-way mixed-effects models for both
individual and average measurements.  Intraclass correlations measuring
consistency of agreement or absolute agreement of the measurements may be
estimated.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R iccQuickstart:Quick start}

        {mansection R iccRemarksandexamples:Remarks and examples}

        {mansection R iccMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_oneway}{...}
{title:Options for one-way RE model}

{dlgtab:Main}

{phang} 
{opt absolute} specifies that intraclass correlations measuring absolute
agreement of the measurements be estimated.  This is the default for
random-effects models.

{phang}
{opt testvalue(#)} tests whether intraclass correlations equal {it:#}.
The default is {cmd:testvalue(0)}.

{dlgtab:Reporting}

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals.  The default is {cmd:level(95)} or as set by {helpb set level}.

{phang}
{cmd:format(%}{it:{help format:fmt}}{cmd:)} specifies how the intraclass
correlation estimates and confidence intervals are to be formatted.  The
default is {cmd:format(%9.0g)}.


{marker options_twoway}{...}
{title:Options for two-way RE and ME models}

{dlgtab:Main}

{phang}
{opt mixed} is required to calculate two-way mixed-effects models.
{opt mixed} specifies that intraclass correlations for a mixed-effects model be
estimated. 

{phang} 
{opt absolute} specifies that intraclass correlations measuring absolute
agreement of the measurements be estimated.  This is the default for
random-effects models.  Only one of {cmd:absolute} or {cmd:consistency} may be
specified.

{phang} 
{opt consistency} specifies that intraclass correlations measuring consistency
of agreement of the measurements be estimated.  This is the default for
mixed-effects models.  Only one of {cmd:absolute} or {cmd:consistency} may be
specified.

{phang}
{opt testvalue(#)} tests whether intraclass correlations equal {it:#}.
The default is {cmd:testvalue(0)}.

{dlgtab:Reporting}

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals.  The default is {cmd:level(95)} or as set by {helpb set level}.

{phang}
{cmd:format(%}{it:{help format:fmt}}{cmd:)} specifies how the intraclass
correlation estimates and confidence intervals are to be formatted.  The
default is {cmd:format(%9.0g)}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse judges}{p_end}

{pstd} Calculate ICCs for one-way random-effects model{p_end}
{phang2}{cmd:. icc rating target}{p_end}

{pstd} Same as above but test whether ICCs equal 0.5{p_end}
{phang2}{cmd:. icc rating target, testvalue(.5)}{p_end}

{pstd} Calculate ICCs for two-way random-effects model{p_end}
{phang2}{cmd:. icc rating target judge}{p_end}

{pstd} Same as above but estimate consistency of agreement{p_end}
{phang2}{cmd:. icc rating target judge, consistency}{p_end}

{pstd}Calculate ICCs for two-way mixed-effects model{p_end}
{phang2}{cmd:. icc rating target judge, mixed}{p_end}

{pstd}Same as above but estimate absolute agreement{p_end}
{phang2}{cmd:. icc rating target judge, mixed absolute}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:icc} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N_target)}}number of targets{p_end}
{synopt:{cmd:r(N_rater)}}number of raters{p_end}
{synopt:{cmd:r(icc_i)}}intraclass correlation for individual measurements{p_end}
{synopt:{cmd:r(icc_i_F)}}F test statistic for individual ICC{p_end}
{synopt:{cmd:r(icc_i_df1)}}numerator degrees of freedom for 
{cmd:r(icc_i_F)}{p_end}
{synopt:{cmd:r(icc_i_df2)}}denominator degrees of freedom for 
{cmd:r(icc_i_F)}{p_end}
{synopt:{cmd:r(icc_i_p)}}p-value for F test of individual ICC{p_end}
{synopt:{cmd:r(icc_i_lb)}}lower endpoint for confidence intervals
    of individual ICC{p_end}
{synopt:{cmd:r(icc_i_ub)}}upper endpoint for confidence intervals
    of individual ICC{p_end}
{synopt:{cmd:r(icc_avg)}}intraclass correlation for average measurements{p_end}
{synopt:{cmd:r(icc_avg_F)}}F test statistic for average ICC{p_end}
{synopt:{cmd:r(icc_avg_df1)}}numerator degrees of freedom for 
{cmd:r(icc_avg_F)}{p_end}
{synopt:{cmd:r(icc_avg_df2)}}denominator degrees of freedom for 
{cmd:r(icc_avg_F)}{p_end}
{synopt:{cmd:r(icc_avg_p)}}p-value for F test of average ICC{p_end}
{synopt:{cmd:r(icc_avg_lb)}}lower endpoint for confidence intervals
    of average ICC{p_end}
{synopt:{cmd:r(icc_avg_ub)}}upper endpoint for confidence intervals
    of average ICC{p_end}
{synopt:{cmd:r(testvalue)}}null hypothesis value{p_end}
{synopt:{cmd:r(level)}}confidence level{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(model)}}analysis-of-variance model{p_end}
{synopt:{cmd:r(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:r(target)}}target variable{p_end}
{synopt:{cmd:r(rater)}}rater variable{p_end}
{synopt:{cmd:r(type)}}type of ICC estimated 
({cmd:absolute} or {cmd:consistency}){p_end}
{p2colreset}{...}
