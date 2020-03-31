{smcl}
{* *! version 1.0.10  14may2018}{...}
{vieweralsosee "[SEM] ssd" "mansection SEM ssd"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] Intro 11" "mansection SEM Intro11"}{...}
{findalias assemssd}{...}
{findalias assemssdg}{...}
{findalias assemssdbuild}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] datasignature" "help datasignature"}{...}
{viewerjumpto "Syntax" "ssd##syntax"}{...}
{viewerjumpto "Description" "ssd##description"}{...}
{viewerjumpto "Links to PDF documentation" "ssd##linkspdf"}{...}
{viewerjumpto "Options" "ssd##options"}{...}
{viewerjumpto "Remarks" "ssd##remarks"}{...}
{viewerjumpto "Examples" "ssd##examples"}{...}
{viewerjumpto "Stored results" "ssd##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[SEM] ssd} {hline 2}}Making summary statistics data (sem only){p_end}
{p2col:}({mansection SEM ssd:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
To enter summary statistics data (SSD), the commands are
        
{phang2}{cmd:ssd init} {varlist}{p_end}

{phang2}{cmd:ssd set} [{it:#}] {cmdab:obs:ervations} {it:#}{p_end}

{phang2}{cmd:ssd set} [{it:#}] {cmdab:mean:s} {it:{help ssd##vector:vector}}
{p_end}

{phang2}{cmd:ssd set} [{it:#}] {{cmdab:var:iances} {c |} {cmd:sd}} 
{it:{help ssd##vector:vector}}{p_end}

{phang2}{cmd:ssd set} [{it:#}] {{cmdab:cov:ariances} {c |}
         {cmdab:cor:relations}} 
{it:{help ssd##matrix:matrix}}{p_end}


{phang2}{cmd:ssd} {cmdab:addgr:oup} {varname}{space 8}(to add second group)
  {p_end}

{phang2}{cmd:ssd} {cmdab:addgr:oup}{space 16}(to add subsequent groups){p_end}

{phang2}{cmd:ssd} {cmdab:unaddgr:oup} {it:#}{space 12}(to remove last group)
{p_end}


{phang2}{cmd:ssd} {cmdab:stat:us} [{it:#}]{space 14}(to review status){p_end}

       
{pstd}
To build SSD from raw data, the command is

{phang2}{cmd:ssd} {cmd:build} {varlist} [{cmd:,} {opth group(varname)} 
{opt clear}]{p_end}


{pstd}
To review the contents of SSD, the commands are

{phang2}{cmd:ssd} {cmdab:stat:us} [{it:#}]{p_end}

{phang2}{cmd:ssd} {cmdab:d:escribe}{p_end}

{phang2}{cmd:ssd} {cmdab:l:ist} [{it:#}]{p_end}


{pstd}
In an emergency ({cmd:ssd} will tell you when), you may use

{phang2}{cmd:ssd} {cmd:repair}{p_end}


{pstd}
In the above, 

{marker vector}{...}
{phang2}
A {it:vector} can be any of the following:

{phang3}
1.  A space-separated list of numbers, for example, 

{p 20 22 2}{cmd:. ssd set means 1 2 3}{p_end}

{phang3}
2.  {cmd: (stata)} {it:matname}{break} where {it:matname} is the name of a
Stata 1 x {it:k} or {it:k} x 1 matrix, for example,

{p 20 22 2}{cmd:. ssd set variances (stata) mymeans}{p_end}

{phang3}
3.  {cmd:(mata)} {it:matname}{break} where {it:matname} is the name of a
Mata 1 x {it:k} or {it:k} x 1 matrix, for example,

{p 20 22 2}{cmd:. ssd set sd (mata) mymeans}{p_end}


{marker matrix}{...}
{phang2}
A {it:matrix} can be any of the following:

{phang3}
1.  A space-separated list of numbers corresponding to the rows of the matrix,
with backslashes ({cmd:\}) between rows.  The numbers are either the lower
triangle and diagonal or the diagonal and upper triangle of the matrix, for
example,

{p 20 22 2}{cmd:. ssd set correlations 1 \ .2 1 \ .3 .5 1}{p_end}

{p 16 16 2}
or 
             
{p 20 22 2}{cmd:. ssd set correlations 1 .2 .3 \ 1 .5 \ 1}{p_end}

{phang3}
2.  {cmd:(ltd)} {it:# #} ...{break} which is to say, a space-separated
list of numbers corresponding to the lower triangle and diagonal of the
matrix, without backslashes between rows, for example,

{p 20 22 2}{cmd:. ssd set correlations (ltd) 1  .2 1  .3 .5 1}{p_end}

{phang3}
3.  {cmd:(dut)} {it:# #} ...{break} which is to say, a space-separated
list of numbers corresponding to diagonal and upper triangle of the matrix,
without backslashes between rows, for example,

{p 20 22 2}{cmd:. ssd set correlations (dut) 1 .2 .3   1 .5   1}{p_end}

{phang3}
4.  {cmd:(stata)} {it:matname}{break} where {it:matname} is the name of a
Stata {it:k} x {it:k} symmetric matrix, for example,

{p 20 22 2}{cmd:. ssd set correlations (stata) mymat}{p_end}

{phang3}
5.  {cmd:(mata)} {it:matname}{break} where {it:matname} is the name of a
Mata {it:k} x {it:k} symmetric matrix, for example,

{p 20 22 2}{cmd:. ssd set correlations (mata) mymat}{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:ssd} allows you to enter SSD to fit SEMs and allows you
to create SSD from original, raw data to publish or to send to others
(and thus preserve participant confidentiality).  Data created by
{cmd:ssd} may be used with {cmd:sem} but not {cmd:gsem}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM ssdRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth group(varname)} is for use with {cmd:ssd build}.  It specifies that
separate groups of summary statistics be produced for each value of 
{it:varname}.

{phang}
{cmd:clear} is for use with {cmd:ssd build}.  It specifies that it is okay to
replace the data in memory with SSD even if the original
dataset has not been saved since it was last changed.


{marker remarks}{...}
{title:Remarks}

{pstd}    
See 

{p2colset 8 28 30 2}{...}
{p2col:{manlink SEM Intro 11}}Fitting models with summary statistics data (sem only){p_end}

{pstd}    
for an introduction, and see 

{p2colset 8 28 30 2}{...}
{p2col:{findalias semssd}}Creating a dataset from published covariances{p_end}
{p2col:{findalias semssdg}}Creating multiple-group summary statistics data{p_end}
{p2col:{findalias semssdbuild}}Creating summary statistics data from raw data{p_end}

{pstd}    
A summary statistics dataset is different from a regular, raw Stata dataset.
Be careful not to use standard Stata data-manipulation commands with summary
statistics data in memory.  The commands include 

{phang2}{helpb generate}{p_end}
{phang2}{helpb replace}{p_end}
{phang2}{helpb merge}{p_end}
{phang2}{helpb append}{p_end}
{phang2}{helpb drop}{p_end}
{phang2}{helpb set obs}{p_end}

{pstd}    
to mention a few.  You may, however, use {helpb rename} to change the
names of the variables.

{pstd}    
The other data-manipulation commands can damage your summary statistics
dataset.  If you make a mistake and do use one of these commands, do not
attempt to repair the data yourself.  Let {cmd:ssd} repair your data by typing

{phang2}{cmd:. ssd repair}{p_end}

{pstd}    
{cmd:ssd} is usually successful as long as variables or observations have not
been dropped.

{pstd}    
Every time you use {cmd:ssd}, even for something as trivial as describing or
listing the data, {cmd:ssd} verifies that the data are not corrupted.  If
{cmd:ssd} finds that they are, it suggests you type {cmd:ssd repair}.

{pstd}    
In critical applications, we also recommend you digitally sign your summary
statistics dataset with the {cmd:datasignature set} command. 
Then at any future time, you can verify the data are still just as they
should be with the {cmd:datasignature confirm} command.  See 
{helpb datasignature: [D] datasignature} and
{it:{mansection SEM ssdRemarksandexamples:Remarks and examples}} in
{manlink SEM ssd}.


{marker examples}{...}
{title:Examples}


{title:Examples: Creating datasets from published covariances}

{pstd}For this example, we will create a dataset with 150 observations from
the following covariances:{p_end}

        {hline 10}{c TT}{hline 50}
        Affective {c |} 1         2         3         4         5
        {hline 10}{c +}{hline 50}
            1     {c |} 2038.035 
            2     {c |} 1631.766  1932.163 
            3     {c |} 1393.567  1336.871  1313.809 
            4     {c |} 1657.299  1647.164  1273.261  2034.216 
            5     {c |} 1721.830  1688.292  1498.401  1677.767  2061.875 
        {hline 10}{c BT}{hline 50}

{pstd}Setup{p_end}
{phang2}{cmd:. clear all}{p_end}

{pstd}Initialize summary statistics data{p_end}
{phang2}{cmd:. ssd init a1 a2 a3 a4 a5}{p_end}

{pstd}Set number of observations{p_end}
{phang2}{cmd:. ssd set observations 150}{p_end}

{pstd}Set covariance values{p_end}
{phang2}{cmd:. ssd set covariances}{break}
	{cmd: 2038.035 \}{break}
	{cmd: 1631.766 1932.163 \}{break}
	{cmd: 1393.567 1336.871 1313.809 \}{break}
	{cmd: 1657.299 1647.164 1273.261 2034.216 \}{break}
	{cmd: 1721.830 1688.292 1498.401 1677.767 2061.875}{p_end}

{pstd}Describe summary statistics data{p_end}
{phang2}{cmd:. ssd describe}{break}

{pstd}List summary statistics data{p_end}
{phang2}{cmd:. ssd list}{break}

{pstd}Save summary statistics data{p_end}
{phang2}{cmd:. save ssd_data}{break}


{title:Examples: Creating multiple-group summary statistics data}

{pstd}For this example, we will create a dataset with two groups and 100
observations for each group from the following correlations, standard
deviations, and means:{p_end}

{phang}Correlations{p_end}

        {hline 8}{c TT}{hline 30}
        Group 1 {c |}  x1     x2    x3    x4    
        {hline 8}{c +}{hline 30}
           x1   {c |}  1.0 
           x2   {c |}  0.50   1.0
           x3   {c |}  0.59   0.46  1.0
           x4   {c |}  0.58   0.43  0.66  1.0
        {hline 8}{c BT}{hline 30}
        
	{hline 8}{c TT}{hline 30}
        Group 2 {c |}  x1     x2    x3    x4    
        {hline 8}{c +}{hline 30}
           x1   {c |}  1.0 
           x2   {c |}  0.31   1.0
           x3   {c |}  0.52   0.45  1.0
           x4   {c |}  0.54   0.46  0.70  1.0
        {hline 8}{c BT}{hline 30}

{phang}Means(standard deviations){p_end}
        
	{hline 8}{c TT}{hline 30}
        Group   {c |}    x1     x2     x3     x4    
        {hline 8}{c +}{hline 30}
           1    {c |}   8.34   8.34   8.37   8.40 
                {c |}  (1.90) (1.75) (2.06) (1.88)
           2    {c |}   8.20   8.23   8.17   8.56 
                {c |}  (1.84) (1.94) (2.07) (1.88)
        {hline 8}{c BT}{hline 30}
	
{pstd}Setup{p_end}
{phang2}{cmd:. clear all}{p_end}
        
{pstd}Initialize summary statistics data for first group{p_end}
{phang2}{cmd:. ssd init x1 x2 x3 x4}{p_end}

{pstd}Set number of observations{p_end}
{phang2}{cmd:. ssd set observations 100}{p_end}

{pstd}Set the means for the first group{p_end}
{phang2}{cmd:. ssd set means 8.34 8.34 8.37 8.40}{p_end}

{pstd}Set the standard deviations for the first group{p_end}
{phang2}{cmd:. ssd set sd 1.90 1.75 2.06 1.88}{p_end}

{pstd}Set the correlations for the first group{p_end}
{phang2}{cmd:. ssd set correlations}{break}
	{cmd: 1.0 \ .50 1.0 \ .59 .46 1.0 \ .58 .43 .66 1.0}{p_end}

{pstd}Specify that there is another group{p_end}
{phang2}{cmd:. ssd addgroup group}{p_end}

{pstd}Repeat steps above for the second group{p_end}
{phang2}{cmd:. ssd set observations 100}{p_end}
{phang2}{cmd:. ssd set means 8.20 8.23 8.17 8.56}{p_end}
{phang2}{cmd:. ssd set sd 1.84 1.94 2.07 1.88}{p_end}
{phang2}{cmd:. ssd set correlations}{break}
	{cmd: 1.0 \ .31 1.0 \ .52 .45 1.0 \ .54 .46 .70 1.0}{p_end}

{pstd}Describe summary statistics data{p_end}
{phang2}{cmd:. ssd describe}{break}

{pstd}Save summary statistics data{p_end}
{phang2}{cmd:. save ssd_group}{break}


{title:Examples: Creating summary statistics data from raw data}

{pstd}For this example, we will create summary statistics data from the system
auto dataset.{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}

{pstd}Create summary statistics dataset with specified variables{p_end}
{phang2}{cmd:. ssd build price mpg turn displacement foreign}{p_end}

{pstd}Create summary statistics dataset for all variables in current dataset{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. drop make}{p_end}
{phang2}{cmd:. ssd build _all, clear}{p_end}

{pstd}Specify a group variable{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. drop make}{p_end}
{phang2}{cmd:. ssd build _all, group(foreign) clear}{p_end}

{pstd}Describe summary statistics data{p_end}
{phang2}{cmd:. ssd describe}{p_end}

{pstd}Save summary statistics data{p_end}
{phang2}{cmd:. save ssd_auto}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ssd describe} stores the following in {cmd:r()}:

{synoptset 26 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations (total across groups){p_end}
{synopt:{cmd:r(k)}}number of variables (excluding group variable){p_end}
{synopt:{cmd:r(G)}}number of groups {p_end}
{synopt:{cmd:r(complete)}}{cmd:1} if complete, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(complete_means)}}{cmd:1} if complete means, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(complete_covariances)}}{cmd:1} if complete covariances, {cmd:0} otherwise{p_end}

{synoptset 26 tabbed}{...}
{p2col 5 18 22 2: Macros}{p_end}
{synopt:{cmd:r(v}{it:#}{cmd:)}}variable names (excluding group variable){p_end}
{synopt:{cmd:r(groupvar)}}name of group variable (if there is one){p_end}
