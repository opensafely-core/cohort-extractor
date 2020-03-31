{smcl}
{* *! version 1.2.4  15oct2018}{...}
{viewerdialog stptime "dialog stptime"}{...}
{vieweralsosee "[ST] stptime" "mansection ST stptime"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] strate" "help strate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] Epitab" "help epitab"}{...}
{vieweralsosee "[ST] stci" "help stci"}{...}
{vieweralsosee "[ST] stir" "help stir"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{vieweralsosee "[ST] stsplit" "help stsplit"}{...}
{viewerjumpto "Syntax" "stptime##syntax"}{...}
{viewerjumpto "Menu" "stptime##menu"}{...}
{viewerjumpto "Description" "stptime##description"}{...}
{viewerjumpto "Links to PDF documentation" "stptime##linkspdf"}{...}
{viewerjumpto "Options" "stptime##options"}{...}
{viewerjumpto "Examples" "stptime##examples"}{...}
{viewerjumpto "Video example" "stptime##video"}{...}
{viewerjumpto "Stored results" "stptime##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[ST] stptime} {hline 2}}Calculate person-time, incidence rates, and SMR{p_end}
{p2col:}({mansection ST stptime:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:stptime} [{it:{help if}}] [{cmd:,} {it:options}] 

{synoptset 29 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opth at(numlist)}}compute person-time at specified intervals; default
is to compute overall person-time and incidence rates{p_end}
{synopt :{opt trim}}exclude observations <= minimum or > maximum of {opt at()}{p_end}
{synopt :{opth by(varname)}}compute incidence rates or SMRs by {it:varname}{p_end}

{syntab:Options}
{synopt :{opt per(#)}}units to be used in reported rates{p_end}
{synopt :{opt dd(#)}}number of decimal digits to be displayed{p_end}
{synopt :{opt smr(groupvar ratevar)}}use {it:groupvar} and {it:ratevar} in {opt using()} dataset to calculate SMRs{p_end}
{synopt :{opth u:sing(filename)}}specify filename to merge that contains {opt smr()} variables{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nosh:ow}}do not show st setting information{p_end}

{syntab:Advanced}
{synopt :{opt j:ackknife}}jackknife confidence intervals{p_end}
{synopt :{opth t:itle(strings:string)}}label output table with {it:string}{p_end}
{synopt :{cmdab:out:put:(}{it:{help filename}} [{cmd:,replace}]{cmd:)}}save summary dataset as {it:filename}; use {opt replace} to overwrite existing {it:filename}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:stset} your data before using {cmd:stptime}; see
{manhelp stset ST}.{p_end}
{p 4 6 2}
{cmd:by} is allowed; see {manhelp by D}.{p_end}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s may be specified using {cmd:stset}; see {manhelp stset ST}. 


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Summary statistics, tests, and tables >}
        {bf:Person-time, incidence rates, and SMR}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stptime} calculates person-time and incidence rates.  {cmd:stptime}
computes standardized mortality/morbidity ratios (SMRs) after merging the data 
with a suitable file of standard rates specified with the {opt using()} option.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stptimeQuickstart:Quick start}

        {mansection ST stptimeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth at(numlist)} specifies intervals at which person-time is to be 
computed.  The intervals are specified in analysis time t units. If {opt at()} 
is not specified, overall person-time and incidence rates are computed.

{pmore}
If, for example, you specify {cmd:at(5(5)20)} and the {opt trim} option
is not specified, person-time is reported for the intervals t = (0 - 5],
t = (5 - 10], t = (10 -15], and t = (15 - 20].

{phang}
{opt trim} specifies that observations less than or equal to the minimum or 
greater than the maximum value listed in {opt at()} be excluded from the 
computations.

{phang}
{opth by(varname)} specifies a categorical variable by which incidence rates 
or SMRs are to be computed.

{dlgtab:Options}

{phang}
{opt per(#)} specifies the units to be used in reported rates.  For example, 
if the analysis time is in years, specifying {cmd:per(1000)} results in rates 
per 1,000 person-years.

{phang}
{opt dd(#)} specifies the maximum number of decimal digits to be reported for 
rates, ratios, and confidence intervals. This option affects only how values 
are displayed, not how they are calculated.

{phang}
{opt smr(groupvar ratevar)} specifies two variables in the {opt using()} 
dataset.  The {it:groupvar} identifies the age-group or calendar-period 
variable used to match the data in memory and the {opt using()} dataset.  
The {it:ratevar} variable contains the appropriate reference rates.  
{cmd:stptime} then calculates SMRs rather than incidence rates.

{phang}
{opth using(filename)} specifies the filename that contains a file of standard 
rates that is to be merged with the data so that SMRs can be calculated.

{phang}
{opt level(#)} specifies the confidence level, as a percentage,
for confidence intervals.  The default is {cmd:level(95)} or as set by 
{helpb set level}.

{phang}
{opt noshow} prevents {cmd:stptime} from showing the key st variables.  This 
option is seldom used because most people type {cmd:stset, show} or 
{cmd:stset, noshow} to set whether they want to see these variables mentioned 
at the top of the output of every st command; see {manhelp stset ST}.

{dlgtab:Advanced}

{phang}
{opt jackknife} specifies that jackknife confidence intervals be produced.  
This is the default if {opt pweight}s or {opt iweight}s were specified when 
the dataset was {cmd:stset}.

{phang}
{opth title:(strings:string)} replaces the default "person-time" label
on the output table with {it:string}. 

{phang}
{cmd:output(}{it:{help filename}} [{cmd:, replace}]{cmd:)} saves a summary
dataset in {it:filename}.  The file contains counts of failures and
person-time, incidence rates (or SMRs), confidence limits, and categorical
variables identifying the time intervals.  This dataset could be used for
further calculations or simply as input to the {cmd:table} command. 

{pmore}
{opt replace} specifies that {it:filename} be overwritten if it exists.
This option is not shown in the dialog box.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse stptime}

{pstd}List part of the data{p_end}
{phang2}{cmd:. list in 1/5}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset year, fail(fail) id(id) noshow}

{pstd}Calculate person-time and incidence rate{p_end}
{phang2}{cmd:. stptime}

{pstd}Calculate person-time and incidence rate per 1,000 person-years{p_end}
{phang2}{cmd:. stptime, per(1000)}

{pstd}Same as above, but tabulate in ten-year intervals and display rates to
four decimal places{p_end}
{phang2}{cmd:. stptime, per(1000) at(0(10)40) dd(4)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse diet}{p_end}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset dox, origin(time dob) enter(time doe) id(id)}
           {cmd:scale(365.25) fail(fail==1 3 13) noshow}

{pstd}Calculate person-time and incidence rates per 1,000 person-years,
tabulating in ten-year intervals, and excluding observations <=40 or >70
{p_end}
{phang2}{cmd:. stptime, per(1000) at(40(10)70) trim}

{pstd}Calculate standardized mortality ratios using {cmd:ageband} and
{cmd:rate} in {cmd:smrchd.dta}{p_end}
{phang2}{cmd:. stptime, smr(ageband rate)}
          {cmd:using(https://www.stata-press.com/data/r16/smrchd) per(1000)}
	  {cmd:at(40(10)70) trim}

{pstd}Calculate person-years and incidence rates per 1,000 person-years by
categories of {cmd:hienergy}{p_end}
{phang2}{cmd:. stptime, per(1000) by(hienergy)}

{pstd}Same as above, but tabulating in ten-year intervals, and excluding
observations <=40 or >70{p_end}
{phang2}{cmd:. stptime, per(1000) by(hienergy) at(40(10)70) trim}

{pstd}Same as above, but compute the SMR using {cmd:ageband} and {cmd:rate} in
{cmd:smrchd.dta}{p_end}
{phang2}{cmd:. stptime, smr(ageband rate)}
         {cmd:using(https://www.stata-press.com/data/r16/smrchd) per(1000)}
	 {cmd:by(hienergy) at(40(10)70) trim}{p_end}
    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=ItmXrcfpTfE&list=UUVk4G4nEtBS4tLOyHqustDA":How to calculate incidence rates and incidence-rate ratios}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:stptime} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(ptime)}}person-time{p_end}
{synopt:{cmd:r(failures)}}observed failures{p_end}
{synopt:{cmd:r(rate)}}failure rate{p_end}
{synopt:{cmd:r(expected)}}expected number of failures{p_end}
{synopt:{cmd:r(smr)}}standardized mortality ratio{p_end}
{synopt:{cmd:r(lb)}}lower bound for SMR{p_end}
{synopt:{cmd:r(ub)}}upper bound for SMR{p_end}
{p2colreset}{...}
