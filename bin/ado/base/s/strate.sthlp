{smcl}
{* *! version 1.2.3  15oct2018}{...}
{viewerdialog strate "dialog strate"}{...}
{viewerdialog stmh "dialog stmh"}{...}
{viewerdialog stmc "dialog stmc"}{...}
{vieweralsosee "[ST] strate" "mansection ST strate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stci" "help stci"}{...}
{vieweralsosee "[ST] stir" "help stir"}{...}
{vieweralsosee "[ST] stptime" "help stptime"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{viewerjumpto "Syntax" "strate##syntax"}{...}
{viewerjumpto "Menu" "strate##menu"}{...}
{viewerjumpto "Description" "strate##description"}{...}
{viewerjumpto "Links to PDF documentation" "strate##linkspdf"}{...}
{viewerjumpto "Options for strate" "strate##options_strate"}{...}
{viewerjumpto "Options for stmh and stmc" "strate##options_stmh"}{...}
{viewerjumpto "Examples" "strate##examples"}{...}
{viewerjumpto "Stored results" "strate##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[ST] strate} {hline 2}}Tabulate failure rates and rate ratios{p_end}
{p2col:}({mansection ST strate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Tabulate failure rates

{p 8 15 2}
{cmd:strate} [{varlist}] {ifin} [{cmd:,}
      {it:{help strate##strate_options:strate_options}}] 


{phang}
Calculate rate ratios with the Mantel-Haenszel method

{p 8 15 2}
{cmd:stmh} {varname} [{varlist}] {ifin} [{cmd:,}
       {it:{help strate##options:options}}] 


{phang}
Calculate rate ratios with the Mantel-Cox method

{p 8 15 2}
{cmd:stmc} {varname} [{varlist}] {ifin} [{cmd:,}
        {it:{help strate##options:options}}]


{synoptset 28 tabbed}{...}
{marker strate_options}{...}
{synopthdr:strate_options}
{synoptline}
{syntab:Main}
{synopt :{opt per(#)}}units to be used in reported rates{p_end}
{synopt :{opth smr(varname)}}use {it:varname} as reference-rate variable to calculate SMRs{p_end}
{synopt :{opth cl:uster(varname)}}cluster variable to be used by the jackknife{p_end}
{synopt :{opt j:ackknife}}report jackknife confidence intervals{p_end}
{synopt :{opt m:issing}}include missing values as extra categories{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{cmdab:out:put:(}{it:{help filename}}[{cmd:,replace}]{cmd:)}}save summary dataset as {it:filename}; use {opt replace} to overwrite existing {it:filename}{p_end}
{synopt :{opt noli:st}}suppress listed output{p_end}
{synopt :{opt g:raph}}graph rates against exposure category{p_end}
{synopt :{opt now:hisker}}omit confidence intervals from the graph{p_end}

{syntab:Plot}
{synopt :{it:{help marker_options}}}change look of markers (color, size, etc.){p_end}
{synopt :{it:{help marker_label_options}}}add marker labels; change look or position{p_end}
{synopt :{it:{help cline_options}}}affect rendition of the plotted points{p_end}

{syntab:CI plot}
{synopt :{opth ciop:ts(rspike_options)}}affect rendition of the confidence intervals (whiskers){p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in
      {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 22 tabbed}{...}
{marker options}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opth by(varlist)}}tabulate rate ratio on {it:varlist}{p_end}
{synopt :{opt c:ompare(num1,den2)}}compare categories of exposure variable{p_end}
{synopt :{opt m:issing}}include missing values as extra categories{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}You must {cmd:stset} your data before using {cmd:strate}, {cmd:stmh}, and {cmd:stmc}; see {manhelp stset ST}.{p_end}
{p 4 6 2}{opt by} is allowed with {cmd:stmh} and {cmd:stmc}; see {manhelp by D}.{p_end}
{p 4 6 2}{opt fweight}s, {opt iweight}s, and {opt pweights} may be specified using {cmd:stset}; see {manhelp stset ST}.{p_end}


{marker menu}{...}
{title:Menu}

    {title:strate}

{phang2}
{bf:Statistics > Survival analysis > Summary statistics, tests, and tables >}
       {bf:Tabulate failure rates and rate ratios}

    {title:stmh}

{phang2}
{bf:Statistics > Survival analysis > Summary statistics, tests, and tables >}
       {bf:Tabulate Mantel-Haenszel rate ratios}

    {title:stmc}

{phang2}
{bf:Statistics > Survival analysis > Summary statistics, tests, and tables >}
        {bf:Tabulate Mantel-Cox rate ratios}


{marker description}{...}
{title:Description}

{pstd}
{cmd:strate} tabulates rates by one or more categorical variables declared in
{varlist}.  You can also save an optional summary dataset, which includes
event counts and rate denominators, for further analysis or display.  The
combination of the commands {cmd:stsplit} and {cmd:strate} implements most
of, if not all, the functions of the special-purpose person-years programs in
widespread use in epidemiology; see {manhelp stsplit ST}.

{pstd}
{cmd:stmh} calculates stratified rate ratios and significance tests by using a
Mantel-Haenszel-type method.

{pstd}
{cmd:stmc} calculates rate ratios that are stratified finely by time by using
the Mantel-Cox method.  The corresponding significance test (the log-rank
test) is also calculated.

{pstd}
Both {cmd:stmh} and {cmd:stmc} can estimate the failure-rate ratio for two
categories of the explanatory variable specified by the first argument of
{it:varlist}.  You can define categories to be compared by specifying them
with the {opt compare()} option.  The remaining variables in {it:varlist}
before the comma are categorical variables, which are to be "controlled for"
using stratification.  Strata are defined by cross-classification of these
variables.

{pstd}
You can also use {cmd:stmh} and {cmd:stmc} to carry out trend tests
for a metric explanatory variable.  Here a one-step Newton
approximation to the log-linear Poisson regression coefficient is computed.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST strateQuickstart:Quick start}

        {mansection ST strateRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_strate}{...}
{title:Options for strate}

{dlgtab:Main}

{phang}
{opt per(#)} specifies the units to be used in reported rates.  For example,
if the analysis time is in years, specifying {cmd:per(1000)} results in rates
per 1,000 person-years.

{phang}
{opth smr(varname)} specifies a reference-rate variable.  {cmd:strate} then
calculates SMRs rather than rates.  This option will usually follow using
{cmd:stsplit} to separate the follow-up records by age bands and possibly
calendar periods.

{phang}
{opth cluster(varname)} defines a categorical variable that indicates clusters
of data to be used by the jackknife.  If the {opt jackknife} option is
selected and this option is not specified, the cluster variable is taken as
the {opt id} variable defined in the st data.  Specifying {opt cluster()}
implies {opt jackknife}.

{phang}
{opt jackknife} specifies that jackknife confidence intervals be produced.
This is the default if weights were specified when the dataset was
{cmd:stset}.

{phang}
{opt missing} specifies that missing values of the explanatory variables be
treated as extra categories.  The default is to exclude such observations.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals.  The default is {cmd:level(95)} or as set by {helpb set level}.

{phang}
{cmd:output(}{it:{help filename}} [{cmd:,replace}]{cmd:)} saves a summary dataset in
{it:filename}.  The file contains counts of failures and person-time, rates
(or SMRs), confidence limits, and all the categorical variables in the
{varlist}.  This dataset could be used for further calculations or simply as
input to the {helpb table} command.

{pmore}
{opt replace} specifies that {it:filename} be overwritten if it exists.
This option is not shown in the dialog box.

{phang}
{opt nolist} suppresses the output.  This is used only when saving results to
a file specified by {opt output()}.

{phang}
{opt graph} produces a graph of the rate against the numerical code used for
categories of {varname}.

{phang}
{opt nowhisker} omits the confidence intervals from the graph.

{dlgtab:Plot}

{phang}
{it:marker_options} affect the rendition of markers drawn at the plotted
points, including their shape, size, color, and outline; see 
{manhelpi marker_options G-3}.

{phang}
{it:marker_label_options} specify if and how the markers are to be labeled;
see {manhelpi marker_label_options G-3}.

{phang}
{it:cline_options} affect whether lines connect the plotted points and the
rendition of those lines; see {manhelpi cline_options G-3}.

{dlgtab:CI plot}

{phang}
{opt ciopts(rspike_options)} affects the rendition of the confidence 
intervals (whiskers); see {manhelpi rspike_options G-3}.  

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated graph; 
see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for 
titling the graph (see {manhelpi title_options G-3}) and for saving the 
graph to disk (see {manhelpi saving_option G-3}).


{marker options_stmh}{...}
{title:Options for stmh and stmc}

{dlgtab:Main}

{phang}
{opth by(varlist)} specifies categorical variables by which the rate ratio is
to be tabulated.

{pmore}
A separate rate ratio is produced for each category or combination of
categories of {it:varlist}, and a test for unequal rate ratios (effect
modification) is displayed.

{phang}
{opt compare(num1,den2)} specifies the categories of the exposure variable to
be compared.  The first code defines the numerator categories, and the second
code defines the denominator categories.

{pmore}
When {opt compare} is absent and there are only two categories, the larger is
compared with the smaller; when there are more than two categories, 
{opt compare} analyzes log-linear trend.

{phang}
{opt missing} specifies that missing values of the explanatory variables be
treated as extra categories.  The default is to exclude such observations.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals.  The default is {cmd:level(95)} or as set by {helpb set level}.


{marker examples}{...}
{title:Examples of strate}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse diet}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset dox, origin(time doe) id(id) scale(365.25)}
               {cmd:fail(fail==1 3 13)}

{pstd}Split the data into ten-year age bands{p_end}
{phang2}{cmd:. stsplit ageband, at(40(10)70) after(time=dob) trim}

{pstd}Tabulate failure rates per 1,000 person-years for categories of
{cmd:ageband}{p_end}
{phang2}{cmd:. strate ageband, per(1000)}

{pstd}Merge reference population dataset with current dataset on
{cmd:ageband}{p_end}
{phang2}{cmd:. merge m:1 ageband using https://www.stata-press.com/data/r16/smrchd}

{pstd}Obtain SMRs and confidence intervals{p_end}
{phang2}{cmd:. strate ageband, per(1000) smr(rate)}


{title:Examples of stmh}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse diet, clear}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset dox, origin(time dob) enter(time doe) id(id)}
            {cmd:scale(365.25) fail(fail==1 3 13)}

{pstd}Split the data into ten-year age bands{p_end}
{phang2}{cmd:. stsplit ageband, at(40(10)70) after(time=dob) trim}

{pstd}Calculate rate ratio comparing categories of {cmd:hienergy}{p_end}
{phang2}{cmd:. stmh hienergy}

{pstd}Calculate rate ratio comparing categories of {cmd:hienergy} by
categories of {cmd:ageband}{p_end}
{phang2}{cmd:. stmh hienergy, by(ageband)}

{pstd}Compare the effect of {cmd:hienergy} between jobs, controlling for
{cmd:ageband}{p_end}
{phang2}{cmd:. stmh hienergy ageband, by(job)}

{pstd}Test for trend of heart disease rates with {cmd:height} controlling for
{cmd:ageband}{p_end}
{phang2}{cmd:. stmh height ageband}


{title:Examples of stmc}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse diet, clear}

{pstd}{cmd:stset} the data, specifying {cmd:dob} as the origin{p_end}
{phang2}{cmd:. stset dox, origin(time dob) enter(time doe) id(id)}
              {cmd:scale(365.25) fail(fail==1 3 13)}

{pstd}Obtain the effect of high energy controlling for age (time) by
stratifying very finely{p_end}
{phang2}{cmd:. stmc hienergy}

{pstd}Same as above, but comparing {cmd:hienergy} = 0 versus {cmd:hienergy} =
1{p_end}
{phang2}{cmd:. stmc hienergy, c(0,1)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:stmh} and {cmd:stmc} store the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(RR)}}overall rate ratio{p_end}
{p2colreset}{...}
