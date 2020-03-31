{smcl}
{* *! version 1.1.11  19oct2017}{...}
{viewerdialog mvencode "dialog mvencode"}{...}
{viewerdialog mvdecode "dialog mvdecode"}{...}
{vieweralsosee "[D] mvencode" "mansection D mvencode"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] generate" "help generate"}{...}
{vieweralsosee "[D] recode" "help recode"}{...}
{viewerjumpto "Syntax" "mvencode##syntax"}{...}
{viewerjumpto "Menu" "mvencode##menu"}{...}
{viewerjumpto "Description" "mvencode##description"}{...}
{viewerjumpto "Links to PDF documentation" "mvencode##linkspdf"}{...}
{viewerjumpto "Options" "mvencode##options"}{...}
{viewerjumpto "Examples" "mvencode##examples"}{...}
{viewerjumpto "Video example" "mvencode##video"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[D] mvencode} {hline 2}}Change missing values to numeric values and vice versa{p_end}
{p2col:}({mansection D mvencode:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Change missing values to numeric values

{p 8 18 2}
{cmd:mvencode} {varlist} {ifin}{cmd:,} {cmd:mv(}{it:#}|{it:mvc}{cmd:=}{it:#} [{bind:{cmd:\} {it:mvc}{cmd:=}{it:#}}...] 
[{bind:{cmd:\} {cmd:else=}{it:#}}]{cmd:)} [{opt o:verride}]


{phang}
Change numeric values to missing values

{p 8 18 2}
{cmd:mvdecode} {varlist} {ifin}{cmd:,} 
{cmd:mv(}{it:{help numlist}} | {it:{help numlist}}{cmd:=}{it:mvc} 
[{cmd:\} {it:{help numlist}}{cmd:=}{it:mvc}...]{cmd:)}


{phang}
where {it:mvc} is one of {cmd:.}|{cmd:.a}|{cmd:.b}|...|{cmd:.z}


{marker menu}{...}
{title:Menu}

    {title:mvencode}

{phang2}
{bf:Data > Create or change data > Other variable-transformation commands}
     {bf:> Change missing values to numeric}
  
    {title:mvdecode}

{phang2}
{bf:Data > Create or change data > Other variable-transformation commands}
     {bf:> Change numeric values to missing}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mvencode} changes missing values in the specified {varlist} to numeric
values.

{pstd}
{cmd:mvdecode} changes occurrences of a {help numlist} in the specified
{it:varlist} to a missing-value code. 

{pstd}
Missing-value codes may be sysmiss {cmd:(.)} and the extended missing-value
codes {cmd:.a}, {cmd:.b}, {cmd:...}, {cmd:.z}.

{pstd}
String variables in {it:varlist} are ignored.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D mvencodeQuickstart:Quick start}

        {mansection D mvencodeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:mv(}{it:#}|{it:mvc}{cmd:=}{it:#}
[{bind:{cmd:\} {it:mvc}{cmd:=}{it:#}}...] [{cmd:\} {opt else=}{it:#}]{cmd:)}
is required and specifies that the numeric values to which the missing values
are to be changed.

{pmore}
{opt mv(#)} specifies that all types of missing values be changed to {it:#}.

{pmore}
{opt mv(mvc=#)} specifies that occurrences of missing-value code {it:mvc} be
changed to {it:#}.  Multiple transformation rules may be specified, separated
by a backward slash ({cmd:\}).  The list may be terminated by the special rule
{opt else=}{it:#}, specifying that all types of missing values not yet
transformed be set to {it:#}.

{pmore}
Examples: {cmd:mv(9)}, {cmd:mv(.=99\.a=98\.b=97)}, {cmd:mv(.=99\else=98)}

{phang}
{cmd:mv(}{it:{help numlist}} | {it:numlist}{cmd:=}{it:mvc} [{cmd:\} {it:numlist}{cmd:=}{it:mvc}...]{cmd:)}
is required and specifies the numeric values that are to be changed to missing
values.

{pmore}
{cmd:mv(}{it:numlist}{cmd:=}{it:mvc}{cmd:)} specifies that the
values in {it:numlist} be changed into missing-value code {it:mvc}.  Multiple
transformation rules may be specified, separated by a backward slash ({cmd:\}).
See {help nlist} for the syntax of a numlist.  

{pmore}
Examples: {cmd:mv(9)}, {cmd:mv(99=.\98=.a\97=.b)}, {cmd:mv(99=.\100/999=.a)}

{phang}
{opt override} specifies the protection provided by {cmd:mvencode} be
overridden.  Without this option, {cmd:mvencode} refuses to make the requested
change if any of the numeric values are already used in the data. 


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}Translate missing values in the data to 999{p_end}
{phang2}{cmd:. mvencode _all, mv(999)}

{pstd}Change 999 values back to missing values{p_end}
{phang2}{cmd:. mvdecode _all, mv(999)}

{pstd}List the data{p_end}
{phang2}{cmd:. list rep78 if rep78 == .}{p_end}

{pstd}Set {cmd:rep78} to 999 in observation 3{p_end}
{phang2}{cmd:. replace rep78 = 999 in 3}

{pstd}Try to translate missing values in the data to 999{p_end}
{phang2}{cmd:. mvencode _all, mv(999)}

{pstd}Force the translation of missing values in the data to 999{p_end}
{phang2}{cmd:. mvencode _all, mv(999) override}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}

{pstd}List the data{p_end}
{phang2}{cmd:. list rep78 foreign if rep78 == .}

{pstd}Translate missing values for {cmd:rep78} to 998 if {cmd:foreign} is 
{cmd:Domestic} and translate to 999 if {cmd:foreign} is {cmd:Foreign}{p_end}
{phang2}{cmd:. mvencode rep78 if foreign == 0, mv(998)}{p_end}
{phang2}{cmd:. mvencode rep78 if foreign == 1, mv(999)}

{pstd}List the data{p_end}
{phang2}{cmd:. list rep78 foreign if rep78 > 900}

{pstd}For {cmd:rep78}, translate 998 to {cmd:.} and 999 to {cmd:.a}{p_end}
{phang2}{cmd:. mvdecode rep78, mv(998=. \ 999=.a)}

{pstd}List the data{p_end}
{phang2}{cmd:. list rep78 foreign if rep78 >= .}{p_end}
    {hline}
 

{marker video}{...}
{title:Video example}

{phang2}{browse "https://www.youtube.com/watch?v=6HV2773-dVM":How to convert missing value codes to missing values}
{p_end}
