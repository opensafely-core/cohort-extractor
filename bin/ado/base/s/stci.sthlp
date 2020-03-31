{smcl}
{* *! version 1.1.13  19oct2017}{...}
{viewerdialog stci "dialog stci"}{...}
{vieweralsosee "[ST] stci" "mansection ST stci"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stdescribe" "help stdescribe"}{...}
{vieweralsosee "[ST] stir" "help stir"}{...}
{vieweralsosee "[ST] stptime" "help stptime"}{...}
{vieweralsosee "[ST] sts" "help sts"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{vieweralsosee "[ST] stvary" "help stvary"}{...}
{viewerjumpto "Syntax" "stci##syntax"}{...}
{viewerjumpto "Menu" "stci##menu"}{...}
{viewerjumpto "Description" "stci##description"}{...}
{viewerjumpto "Links to PDF documentation" "stci##linkspdf"}{...}
{viewerjumpto "Options" "stci##options"}{...}
{viewerjumpto "Examples" "stci##examples"}{...}
{viewerjumpto "Stored results" "stci##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[ST] stci} {hline 2}}Confidence intervals for means and percentiles of survival time{p_end}
{p2col:}({mansection ST stci:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:stci} {ifin} [{cmd:,} {it:options}]

{synoptset 16 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opth by(varlist)}}perform separate calculations for each group of 
{it:varlist}{p_end}
{synopt :{opt m:edian}}calculate median survival times; the default{p_end}
{synopt :{opt r:mean}}calculate mean survival time restricted to longest follow-up time{p_end}
{synopt :{opt e:mean}}calculate the mean survival time by exponentially extending the survival curve to zero{p_end}
{synopt :{opt p(#)}}compute the {it:#} percentile of survival times{p_end}
{synopt :{opt cc:orr}}calculate the standard error for {opt rmean} using a continuity correction{p_end}
{synopt :{opt nosh:ow}}do not show st setting information{p_end}
{synopt :{opt dd(#)}}set maximum number of decimal digits to report{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt g:raph}}plot exponentially extended survivor function{p_end}
{synopt :{opt t:max(#)}}set maximum analysis time of {it:#} to be plotted{p_end}

{syntab:Plot}
{synopt :{it:{help cline_options}}}affect rendition of the plotted lines{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in
    {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:stset} your data before using {cmd:stci}; see
{manhelp stset ST}.{p_end}
{p 4 6 2}
{opt by} is allowed; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Summary statistics, tests, and tables >}
       {bf:CIs for means and percentiles of survival time}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stci} computes means and percentiles of survival time, standard
errors, and confidence intervals.  For multiple-event data,
survival time is the time until a failure.

{pstd}
{cmd:stci} can be used with single- or multiple-record or single- or 
multiple-failure st data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stciQuickstart:Quick start}

        {mansection ST stciRemarksandexamples:Remarks and examples}

        {mansection ST stciMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth by(varlist)} specifies that separate calculations be made for each group
identified by equal values of the variables in {it:varlist}, resulting in
separate summaries and an overall total.  {it:varlist} may contain any number
of variables, each of which may be string or numeric.

{phang}
{opt median} specifies median survival times.  This is the default.

{phang}
{opt rmean} and {opt emean} specify mean survival times.  If the
longest follow-up time is censored, {opt emean} (extended mean) computes the
mean survival by exponentially extending the survival curve to zero, and
{opt rmean} (restricted mean) computes the mean survival time restricted to
the longest follow-up time.  If the longest follow-up time is a
failure, the restricted mean survival time and the extended mean survival time
are equal.

{phang}
{opt p(#)} specifies the percentile of survival time to be computed.  For 
example, {cmd:p(25)} will compute the 25th percentile of survival times, and 
{cmd:p(75)} will compute the 75th percentile of survival times.  
Specifying {cmd:p(50)} is the same as specifying the {opt median} option.

{phang}
{opt ccorr} specifies that the standard error for the restricted mean
survival time be computed using a continuity correction.  {opt ccorr} is 
valid only with the {opt rmean} option.

{phang}
{opt noshow} prevents {cmd:stci} from showing the key st variables.  This 
option is seldom used because most people type {cmd:stset, show} or 
{cmd:stset, noshow} to set whether they want to see these variables mentioned 
at the top of the output of every st command; see {manhelp stset ST}.

{phang}
{opt dd(#)} specifies the maximum number of decimal digits to be reported for 
standard errors and confidence intervals.  This option affects only how values 
are reported and not how they are calculated.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, 
for confidence intervals.  The default is {cmd:level(95)} or as set by 
{helpb set level}.

{phang}
{opt graph} specifies that the exponentially extended survivor function
be plotted.  This option is valid only when the {opt emean} option is also
specified and is not valid in conjunction with the {opt by()} option.

{phang}
{opt tmax(#)} is for use with the {opt graph} option.  It specifies the 
maximum analysis time to be plotted.

{dlgtab:Plot}

{phang}
{it:cline_options} affect the rendition of the plotted lines; see
{manhelpi cline_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the 
generated graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for 
titling the graph (see {manhelpi title_options G-3}) and for saving the 
graph to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples with single-record survival data}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse page2}

{pstd}Compute median survival time{p_end}
{phang2}{cmd:. stci}

{pstd}Compute median survival time by group{p_end}
{phang2}{cmd:. stci, by(group)}

{pstd}Compute the 25th percentile of survival time{p_end}
{phang2}{cmd:. stci, p(25)}

{pstd}Compute the 25th percentile of survival time by group{p_end}
{phang2}{cmd:. stci, p(25) by(group)}

{pstd}Compute mean survival time restricted to the longest follow-up time by
group{p_end}
{phang2}{cmd:. stci, rmean by(group)}

{pstd}Compute mean survival time by exponentially extending the survival curve
to 0{p_end}
{phang2}{cmd:. stci, emean}

{pstd}Same as above, but also plot the exponentially extended survivor
function{p_end}
{phang2}{cmd:. stci, emean graph}


{title:Examples with multiple-record survival data}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse stan3}

{pstd}Compute median survival time{p_end}
{phang2}{cmd:. stci}

{pstd}Compute median survival time by group{p_end}
{phang2}{cmd:. stci, by(posttran)}

{pstd}Report whether values of {cmd:posttran} within subject vary over
time{p_end}
{phang2}{cmd:. stvary posttran}


{title:Examples with multiple-failure data}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse mfail2}

{pstd}Show st settings{p_end}
{phang2}{cmd:. stset}

{pstd}Compute median survival time{p_end}
{phang2}{cmd:. stci}

{pstd}Create {cmd:nf} containing the cumulative number of failures for each
subject as of the entry time for the observation{p_end}
{phang2}{cmd:. stgen nf = nfailures()}

{pstd}Compute median survival time by group{p_end}
{phang2}{cmd:. stci, by(nf)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:stci} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N_sub)}}number of subjects{p_end}
{synopt:{cmd:r(p}{it:#}{cmd:)}}{it:#}th percentile{p_end}
{synopt:{cmd:r(rmean)}}restricted mean{p_end}
{synopt:{cmd:r(emean)}}extended mean{p_end}
{synopt:{cmd:r(se)}}standard error{p_end}
{synopt:{cmd:r(lb)}}lower bound of CI{p_end}
{synopt:{cmd:r(ub)}}upper bound of CI{p_end}
{p2colreset}{...}
