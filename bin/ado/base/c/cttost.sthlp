{smcl}
{* *! version 1.1.7  19oct2017}{...}
{viewerdialog cttost "dialog cttost"}{...}
{vieweralsosee "[ST] cttost" "mansection ST cttost"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] ct" "help ct"}{...}
{vieweralsosee "[ST] ctset" "help ctset"}{...}
{viewerjumpto "Syntax" "cttost##syntax"}{...}
{viewerjumpto "Menu" "cttost##menu"}{...}
{viewerjumpto "Description" "cttost##description"}{...}
{viewerjumpto "Links to PDF documentation" "cttost##linkspdf"}{...}
{viewerjumpto "Options" "cttost##options"}{...}
{viewerjumpto "Example" "cttost##example"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[ST] cttost} {hline 2}}Convert count-time data to survival-time data{p_end}
{p2col:}({mansection ST cttost:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}{cmd:cttost} [{cmd:,} {it:options}]

{synoptset 14}{...}
{synopthdr}
{synoptline}
{synopt :{opt t0(t0var)}}name of entry-time variable{p_end}
{synopt :{opt w:var(wvar)}}name of frequency-weighted variable{p_end}
{synopt :{opt clear}}overwrite current data in memory{p_end}

{synopt :{opt nop:reserve}}do not save the original data; programmer's command{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}You must {cmd:ctset} your data before using {cmd:cttost}; see 
{manhelp ctset ST}.{p_end}
{p 4 6 2}{opt nopreserve} does not appear in the dialog box.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Setup and utilities >}
      {bf:Convert count-time data to survival-time data}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cttost} converts count-time data to their survival-time format so that 
they can be analyzed with Stata.  Do not confuse count-time data with
counting-process data, which can also be analyzed with the st commands; see
{manhelp ctset ST} for a definition and examples of count data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST cttostQuickstart:Quick start}

        {mansection ST cttostRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt t0(t0var)} specifies the name of the new variable to
create that records entry time.  (For most ct data, no entry-time variable is
necessary because everyone enters at time 0.)

{pmore}Even if an entry-time variable is necessary, you need not specify this
option.  {cmd:cttost} will, by default, choose {opt t0}, {opt time0}, or 
{opt etime} according to which name does not already exist in the data.

{phang}
{opt wvar(wvar)} specifies the name of the new variable to be
created that records the frequency weights for the new pseudo-observations.
Count-time data are actually converted to frequency-weighted st data, and a
variable is needed to record the weights.  This sounds more complicated than
it is.  Understand that {cmd:cttost} needs a new variable name, which will
become a permanent part of the st data.

{pmore}
If you do not specify {opt wvar()}, {cmd:cttost} will, by default, choose
{opt w}, {opt pop}, {opt weight}, or {opt wgt} according to which name does not
already exist in the data.

{phang}
{opt clear} specifies that it is okay to proceed with the conversion,
even though the current dataset has not been saved on disk.

{pstd}
The following option is available with {cmd:cttost} but is not shown in the
dialog box:

{phang}
{opt nopreserve} speeds the conversion by not saving the original
data that can be restored should things go wrong or should you press
{hi:Break}.  {opt nopreserve} is intended for use by programmers who use
{cmd:cttost} as a subroutine.  Programmers can specify this option if they
have already preserved the original data.  {opt nopreserve} does not affect
the conversion.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse cttost}

{pstd}Display identity of key ct variables{p_end}
{phang2}{cmd:. ctset}

{pstd}Convert count-time data to survival-time data{p_end}
{phang2}{cmd:. cttost}{p_end}
