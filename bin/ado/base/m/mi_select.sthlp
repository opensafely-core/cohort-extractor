{smcl}
{* *! version 1.1.3  15may2018}{...}
{vieweralsosee "[MI] mi select" "mansection MI miselect"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi extract" "help mi_extract"}{...}
{vieweralsosee "[MI] Technical" "help mi_technical"}{...}
{viewerjumpto "Syntax" "mi_select##syntax"}{...}
{viewerjumpto "Description" "mi_select##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_select##linkspdf"}{...}
{viewerjumpto "Option" "mi_select##option"}{...}
{viewerjumpto "Remarks" "mi_select##remarks"}{...}
{viewerjumpto "Stored results" "mi_select##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[MI] mi select} {hline 2}}Programmer's alternative to mi extract
{p_end}
{p2col:}({mansection MI miselect:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi select init} [{cmd:, fast} ]

{p 8 12 2}
{cmd:mi select} {it:#}{...}

{p 4 4 2}
where 0 <= {it:#} <= {it:M}, and where typical usage is

              {cmd}quietly mi query 
              local M = r(M)

              preserve
              mi select init
              local priorcmd "`r(priorcmd)'"

              forvalues m=1(1)`M' {
                      mi select `m'
                      ...
                      `priorcmd'
              }

              restore{txt}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:select} is a programmer's command.  It is a faster, more
dangerous version of {bf:{help mi_extract:mi extract}}.
Before using {cmd:mi} {cmd:select}, the {cmd:mi} data must be 
preserved; see {bf:{help preserve:[P] preserve}}.

{p 4 4 2}
{cmd:mi} {cmd:select} {cmd:init} initializes {cmd:mi} {cmd:select} {it:#}
and must be used before the first call to {cmd:mi} {cmd:select} {it:#}. 

{p 4 4 2}
{cmd:mi} {cmd:select} {it:#} replaces the data in memory with a copy of the
data for {it:m}={it:#}.  The data are not {cmd:mi} {cmd:set}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miselectRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{p 4 8 2}
{cmd:fast}, specified with {cmd:mi} {cmd:select} {cmd:init}, specifies that the
   data delivered by {cmd:mi} {cmd:select} {it:#} commands not
   be changed except for sort order.  Then {cmd:mi} {cmd:select} can
   operate more quickly.  {cmd:fast} is allowed with all styles but currently
   affects the performance with the wide style only. 

{p 8 8 2}
    If {cmd:fast} is not specified, the data delivered by {cmd:mi} 
    {cmd:select} {it:#} may be modified freely before 
    the next {cmd:mi} {cmd:select} {it:#} call.  However, the data may not be 
    dropped.  {cmd:mi} {cmd:select} uses characteristics (see
    {manhelp char P}) stored 
    in {cmd:_dta[]} to know its state.


{marker remarks}{...}
{title:Remarks}

{pstd}
The two {cmd:mi} {cmd:select} commands work in tandem.  {cmd:mi} {cmd:select}
{cmd:init} initializes {cmd:mi} {cmd:select} {it:#}. 

{pstd}
{cmd:mi} {cmd:select} {cmd:init} returns macro {cmd:r(priorcmd)}, which you
are to issue as a command between each {cmd:mi} {cmd:select} {it:#} call.
{cmd:r(priorcmd)} is not required to be issued before the first call to
{cmd:mi} {cmd:select} {it:#}, although you may issue it if that is convenient.
{cmd:mi} {cmd:select} {it:#} calls can be made in any order, and the same
{it:m} may be selected repeatedly.

{p 4 4 2}
The data delivered by {cmd:mi} {cmd:select} {it:#} differ from those delivered
by {cmd:mi} {cmd:extract} in that there may be extra variables in the dataset.
One of the extra variables, {cmd:_mi_id}, is a unique observation identifier.

{pstd}
If you want to post changes made in the selected data back to the {cmd:mi}
data, you can write a file containing {cmd:mi_id} and the updated variables
and then use {cmd:_mi_id} to match that to the {cmd:mi} data after your final
{cmd:restore}.  By default, changes to the selected data will not be posted
back to the underlying {cmd:mi} data.

{p 4 4 2}
In the case of wide data, the {cmd:mi} data have no {cmd:_mi_id} variable.
{cmd:_mi_id} in the selected data is reflected in the current order of the
{cmd:mi} data.


{marker results}{...}
{title:Stored results}

{p 4 4 2}
{cmd:mi select init} stores the following in {cmd:r()}:

{p 8 8 2}
Macros
{p_end}
{p 13 30 2}
{cmd:r(priorcmd)}{bind:      }command 
to be issued prior to calling {cmd:mi} {cmd:select} {it:#};
this command will be either {cmd:restore, preserve} or nothing
{p_end}
