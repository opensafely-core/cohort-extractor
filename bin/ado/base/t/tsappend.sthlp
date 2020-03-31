{smcl}
{* *! version 1.2.3  19oct2017}{...}
{viewerdialog tsappend "dialog tsappend"}{...}
{vieweralsosee "[TS] tsappend" "mansection TS tsappend"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "tsappend##syntax"}{...}
{viewerjumpto "Menu" "tsappend##menu"}{...}
{viewerjumpto "Description" "tsappend##description"}{...}
{viewerjumpto "Links to PDF documentation" "tsappend##linkspdf"}{...}
{viewerjumpto "Options" "tsappend##options"}{...}
{viewerjumpto "Examples" "tsappend##examples"}{...}
{viewerjumpto "Stored results" "tsappend##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[TS] tsappend} {hline 2}}Add observations to a time-series dataset{p_end}
{p2col:}({mansection TS tsappend:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:tsappend}{cmd:,} {c -(} {opt add(#)} | {opt last(date|clock)}
  {opth tsfmt:(strings:string)} {c )-} [{it:options}]

{synoptset tabbed}{...}
{synopthdr:options}
{synoptline}
{p2coldent:* {opt add(#)}}add {it:#} observations{p_end}
{p2coldent:* {opt last(date|clock)}}add observations at {it:date} or
               {it:clock}{p_end}
{p2coldent:* {opth tsfmt:(strings:string)}}use time-series function {it:string} with 
{opt last(date|clock)}{p_end}
{synopt :{opt panel(panel_id)}}add observations to panel {it:panel_id}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* Either {opt add(#)} is required, or {opt last(date|clock)} and 
{opt tsfmt(string)} are required.{p_end}
{p 4 6 2}You must {cmd:tsset} or {cmd:xtset} your data before using
{cmd:tsappend}; see {helpb tsset:[TS] tsset} and {helpb xtset:[XT] xtset}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Setup and utilities >}
    {bf:Add observations to time-series dataset}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tsappend} appends observations to a time-series dataset or to a
panel dataset.  {cmd:tsappend} uses and updates the information set by
{cmd:tsset} or {cmd:xtset}.  Any gaps in the dataset are removed.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS tsappendQuickstart:Quick start}

        {mansection TS tsappendRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt add(#)} specifies the number of observations to add.

{phang}
{opt last(date|clock)} and {opth tsfmt:(strings:string)} must be specified
together and are an alternative to {opt add()}.

{pmore}
{opt last(date|clock)} specifies the date or the date and time of the last
observation to add.

{pmore}
{opt tsfmt(string)} specifies the name of the Stata time-series
function to use in converting the date specified in {opt last()} to an
integer.  The function names are {cmd:tc} (clock), {cmd:tC} (Clock), 
{cmd:td} (daily), {cmd:tw} (weekly), {cmd:tm} (monthly), {cmd:tq} (quarterly),
and {cmd:th} (half-yearly).

{pmore}
For clock times, the last time added (if any) will be earlier than the time
requested in {opt last(date|clock)} if {cmd:last()} is not a multiple of delta
units from the last time in the data.

{pmore}
For instance, you might specify {bind:{cmd:last(17may2007)}} {cmd:tsfmt(td)},
{bind:{cmd:last(2001m1)} {cmd:tsfmt(tm)}}, or 
{bind:{cmd:last(17may2007 15:30:00) tsfmt(tc)}}.

{phang}
{opt panel(panel_id)} specifies that observations be added only to panels with
the ID specified in {opt panel()}.


{marker examples}{...}
{title:Examples with time-series data}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse tsappend1}

{pstd}Display how data are currently {cmd:tsset}{p_end}
{phang2}{cmd:. tsset}

{pstd}Display general information about the dataset{p_end}
{phang2}{cmd:. describe, short}

{pstd}Add 12 observations to end of dataset{p_end}
{phang2}{cmd:. tsappend, add(12)}

{pstd}Display general information about the dataset{p_end}
{phang2}{cmd:. describe, short}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse tsappend1, clear}

{pstd}Display how data are currently {cmd:tsset}{p_end}
{phang2}{cmd:. tsset}

{pstd}Add observations through the first month of 2001{p_end}
{phang2}{cmd:. tsappend, last(2001m1) tsfmt(tm)}

{pstd}Display how data are currently {cmd:tsset}{p_end}
{phang2}{cmd:. tsset}{p_end}
    {hline}


{title:Examples with panel data}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse tsappend3, clear}

{pstd}Describe pattern of xt data{p_end}
{phang2}{cmd:. xtdescribe}

{pstd}Display summary information for {cmd:t2} by {cmd:id}{p_end}
{phang2}{cmd:. by id: summarize t2}

{pstd}Add 6 observations to each panel  (panels not ending at a uniform date)
{p_end}
{phang2}{cmd:. tsappend, add(6)}

{pstd}Describe pattern of xt data{p_end}
{phang2}{cmd:. xtdescribe}

{pstd}Display summary information for {cmd:t2} by {cmd:id}{p_end}
{phang2}{cmd:. by id: summarize t2}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse tsappend2, clear}

{pstd}Add observations through the seventh month of 2000  (panels ending at a
uniform date){p_end}
{phang2}{cmd:. tsappend, last(2000m7) tsfmt(tm)}

{pstd}Display summary information for {cmd:t2} by {cmd:id}{p_end}
{phang2}{cmd:. by id: sum t2}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tsappend} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(add)}}number of observations added{p_end}
{p2colreset}{...}
