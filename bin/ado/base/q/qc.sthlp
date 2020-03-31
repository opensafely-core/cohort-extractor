{smcl}
{* *! version 1.1.12  18sep2018}{...}
{viewerdialog cchart "dialog cchart"}{...}
{viewerdialog pchart "dialog pchart"}{...}
{viewerdialog rchart "dialog rchart"}{...}
{viewerdialog xchart "dialog xchart"}{...}
{viewerdialog shewhart "dialog shewhart"}{...}
{vieweralsosee "[R] QC" "mansection R QC"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] serrbar" "help serrbar"}{...}
{viewerjumpto "Syntax" "qc##syntax"}{...}
{viewerjumpto "Menu" "qc##menu"}{...}
{viewerjumpto "Description" "qc##description"}{...}
{viewerjumpto "Links to PDF documentation" "qc##linkspdf"}{...}
{viewerjumpto "Options" "qc##options"}{...}
{viewerjumpto "Examples" "qc##examples"}{...}
{viewerjumpto "Stored results" "qc##results"}{...}
{p2colset 1 11 13 2}{...}
{p2col:{bf:[R] QC} {hline 2}}Quality control charts{p_end}
{p2col:}({mansection R QC:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Draw a c chart

{p 8 15 2}
{cmd:cchart} {it:defect_var} {it:unit_var} [{cmd:,} {it:{help qc##cchart_options:cchart_options}}]


{phang}
Draw a p (fraction-defective) chart

{p 8 15 2}
{cmd:pchart} {it:reject_var} {it:unit_var} {it:ssize_var}
	[{cmd:,} {it:{help qc##pchart_options:pchart_options}}]


{phang}
Draw an R (range or dispersion) chart

{p 8 15 2}
{cmd:rchart} {varlist} {ifin} [{cmd:,} {it:{help qc##rchart_options:rchart_options}}]


{phang}
Draw an X-bar (control line) chart

{p 8 15 2}
{cmd:xchart} {varlist} {ifin} [{cmd:,} {it:{help qc##xchart_options:xchart_options}}]


{phang}
Draw vertically aligned X-bar and R charts

{p 8 17 2}
{cmd:shewhart} {varlist} {ifin} [{cmd:,} {it:{help qc##shewhart_options:shewhart_options}}]


{synoptset 25 tabbed}{...}
{marker cchart_options}{...}
{synopthdr :cchart_options}
{synoptline}
{syntab :Main}
{synopt :{opt nogr:aph}}suppress graph{p_end}

{syntab :Plot}
{synopt :{it:{help connect_options}}}affect rendition of the plotted points{p_end}
INCLUDE help gr_markopt

{syntab :Control limits}
{synopt :{opth clop:ts(cline_options)}}affect rendition of the control limits{p_end}

{syntab :Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab :Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in
     {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 25 tabbed}{...}
{marker pchart_options}{...}
{synopthdr :pchart_options}
{synoptline}
{syntab :Main}
{synopt :{opt sta:bilized}}stabilize the p chart when sample sizes are unequal{p_end}
{synopt :{opt nogr:aph}}suppress graph{p_end}
{synopt:{opth g:enerate(newvar:newvar_f newvar_lcl newvar_ucl)}}store the 
fractions of defective elements and the lower and upper control limits{p_end}

{syntab :Plot}
{synopt :{it:{help connect_options}}}affect rendition of the plotted points{p_end}
INCLUDE help gr_markopt

{syntab :Control limits}
{synopt :{opth clop:ts(cline_options)}}affect rendition of the control limits{p_end}

{syntab :Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab :Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in
      {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 25 tabbed}{...}
{marker rchart_options}{...}
{synopthdr :rchart_options}
{synoptline}
{syntab :Main}
{synopt :{opt st:d(#)}}user-specified standard deviation{p_end}
{synopt :{opt nogr:aph}}suppress graph{p_end}

{syntab :Plot}
{synopt :{it:{help connect_options}}}affect rendition of the plotted points{p_end}
INCLUDE help gr_markopt

{syntab :Control limits}
{synopt :{opth clop:ts(cline_options)}}affect rendition of the control limits{p_end}

{syntab :Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab :Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in
     {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 25 tabbed}{...}
{marker xchart_options}{...}
{synopthdr :xchart_options}
{synoptline}
{syntab :Main}
{synopt :{opt st:d(#)}}user-specified standard deviation{p_end}
{synopt :{opt m:ean(#)}}user-specified mean{p_end}
{synopt :{opt lo:wer(#)} {opt up:per(#)}}lower and upper limits of the X-bar limits{p_end}
{synopt :{opt nogr:aph}}suppress graph{p_end}

{syntab :Plot}
{synopt :{it:{help connect_options}}}affect rendition of the plotted points{p_end}
INCLUDE help gr_markopt

{syntab :Control limits}
{synopt :{opth clop:ts(cline_options)}}affect rendition of the control limits{p_end}

{syntab :Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab :Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in
     {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 25 tabbed}{...}
{marker shewhart_options}{...}
{synopthdr :shewhart_options}
{synoptline}
{syntab :Main}
{synopt :{opt st:d(#)}}user-specified standard deviation{p_end}
{synopt :{opt m:ean(#)}}user-specified mean{p_end}
{synopt :{opt nogr:aph}}suppress graph{p_end}

{syntab :Plot}
{synopt :{it:{help connect_options}}}affect rendition of the plotted points{p_end}
INCLUDE help gr_markopt

{syntab :Control limits}
{synopt :{opth clop:ts(cline_options)}}affect rendition of the control limits{p_end}

{syntab :Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:combine_options}}any options documented in
   {manhelp graph_combine G-2:graph combine}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

    {title:cchart}

{phang2}
{bf:Statistics > Other > Quality control > C chart}

    {title:pchart}

{phang2}
{bf:Statistics > Other > Quality control > P chart}

    {title:rchart}

{phang2}
{bf:Statistics > Other > Quality control > R chart}

    {title:xchart}

{phang2}
{bf:Statistics > Other > Quality control > X-bar chart}

    {title:shewhart}

{phang2}
{bf:Statistics > Other > Quality control > Vertically aligned X-bar and R chart}


{marker description}{...}
{title:Description}

{pstd}
These commands provide standard quality-control charts.  {cmd:cchart} draws a
c chart; {cmd:pchart}, a p (fraction-defective) chart; {cmd:rchart},
an R (range or dispersion) chart; {cmd:xchart}, an X-bar (control line)
chart; and {cmd:shewhart}, vertically aligned X-bar and R charts.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R QCQuickstart:Quick start}

        {mansection R QCRemarksandexamples:Remarks and examples}

        {mansection R QCMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}{opt stabilized} stabilizes the p chart when sample sizes are
unequal.

{phang}{opt std(#)} specifies the standard deviation of the process.  The R
chart is calculated (based on the range) if this option is not specified.

{phang}{opt mean(#)} specifies the grand mean, which is calculated if not
specified.

{phang}{opt lower(#)} and {opt upper(#)} must be specified together or not at
all.  They specify the lower and upper limits of the X-bar chart.
Calculations based on the mean and standard deviation (whether specified by
option or calculated) are used otherwise.

{phang}{opt nograph} suppresses the graph.

{phang}{opth "generate(newvar:newvar_f newvar_lcl newvar_ucl)"} stores the 
plotted values in the p chart.  {it:newvar_f} will contain the fractions of 
defective elements; 
{it:newvar_lcl} and {it:newvar_ucl} will contain the lower and upper
control limits, respectively.

{dlgtab:Plot}

{phang}
{it:connect_options} affect whether lines connect the plotted points and the
rendition of those lines; see {manhelpi connect_options G-3}.

INCLUDE help gr_markoptf

{dlgtab:Control limits}

{phang}
{opt clopts(cline_options)} affect the rendition of the control limits; see
{manhelpi cline_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated
graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {cmd:by()}.  These include options for 
titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).

{phang}
{it:combine_options} ({cmd:shewhart} only) are any of the options documented
in {helpb graph combine:[G-2] graph combine}.  These include options for titling
the graph (see {manhelpi title_options G-3}) and for saving the graph to disk
(see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Example:  {cmd:cchart}}

{pstd}
Assume that the variable {cmd:day} contains the sample identification
number and {cmd:defects} contains the number of defects in the sample:

{phang2}{cmd:. webuse ncu}{p_end}
{phang2}{cmd:. cchart defects day, title(c Chart for Subassemblies)}


{title:Example:  {cmd:pchart}}

{pstd}
Assume that the variable {cmd:day} contains the day of the inspection (1, 2,
...), {cmd:rejects} contains the number rejected, and {cmd:ssize} contains the
number inspected:

{phang2}{cmd:. webuse ncu2}{p_end}
{phang2}{cmd:. pchart rejects day ssize}


{title:Example:  {cmd:rchart}}

{pstd}
Assume that we take five samples of 5 observations each.  Variables {cmd:m1}
through {cmd:m5} contain the measurements for each sample:

{phang2}{cmd:. webuse rchartxmpl}{p_end}
{phang2}{cmd:. rchart m1-m5, connect(l)}


{title:Example:  {cmd:xchart}}

{pstd}
Using the same data as for {cmd:rchart}:

{phang2}
{cmd:. xchart m1-m5, connect(l)}


{title:Example:  {cmd:shewhart}}

{pstd}
Using the same data as for {cmd:rchart}:

{phang2}
{cmd:. shewhart m1-m5, connect(l)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:cchart} stores the following in {cmd:r()}:

{synoptset 17 tabbed}{...}
{p2col 5 17 19 2: Scalars}{p_end}
{synopt:{cmd:r(cbar)}}expected number of nonconformities{p_end}
{synopt:{cmd:r(lcl_c)}}lower control limit{p_end}
{synopt:{cmd:r(ucl_c)}}upper control limit{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(out_c)}}number of units out of control{p_end}
{synopt:{cmd:r(below_c)}}number of units below the lower limit{p_end}
{synopt:{cmd:r(above_c)}}number of units above the upper limit{p_end}
{p2colreset}{...}

{pstd}
{cmd:pchart} stores the following in {cmd:r()}:

{synoptset 17 tabbed}{...}
{p2col 5 17 19 2: Scalars}{p_end}
{synopt:{cmd:r(pbar)}}average fraction of nonconformities{p_end}
{synopt:{cmd:r(lcl_p)}}lower control limit{p_end}
{synopt:{cmd:r(ucl_p)}}upper control limit{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(out_p)}}number of units out of control{p_end}
{synopt:{cmd:r(below_p)}}number of units below the lower limit{p_end}
{synopt:{cmd:r(above_p)}}number of units above the upper limit{p_end}
{p2colreset}{...}


{pstd}
{cmd:rchart} stores the following in {cmd:r()}:

{synoptset 17 tabbed}{...}
{p2col 5 17 19 2: Scalars}{p_end}
{synopt:{cmd:r(central_line)}}ordinate of the central line{p_end}
{synopt:{cmd:r(lcl_r)}}lower control limit{p_end}
{synopt:{cmd:r(ucl_r)}}upper control limit{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(out_r)}}number of units out of control{p_end}
{synopt:{cmd:r(below_r)}}number of units below the lower limit{p_end}
{synopt:{cmd:r(above_r)}}number of units above the upper limit{p_end}
{p2colreset}{...}

{pstd}
{cmd:xchart} stores the following in {cmd:r()}:

{synoptset 17 tabbed}{...}
{p2col 5 17 19 2: Scalars}{p_end}
{synopt:{cmd:r(xbar)}}grand mean{p_end}
{synopt:{cmd:r(lcl_x)}}lower control limit{p_end}
{synopt:{cmd:r(ucl_x)}}upper control limit{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(out_x)}}number of units out of control{p_end}
{synopt:{cmd:r(below_x)}}number of units below the lower limit{p_end}
{synopt:{cmd:r(above_x)}}number of units above the upper limit{p_end}
{p2colreset}{...}

{pstd}
{cmd:shewhart} stores in {cmd:r()} the combination of stored results from
{cmd:xchart} and {cmd:rchart}.
{p_end}
