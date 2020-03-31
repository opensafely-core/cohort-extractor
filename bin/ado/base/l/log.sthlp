{smcl}
{* *! version 1.3.8  19oct2017}{...}
{viewerdialog log "dialog log_dlg"}{...}
{vieweralsosee "[R] log" "mansection R log"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{vieweralsosee "[R] translate" "help translate"}{...}
{viewerjumpto "Syntax" "log##syntax"}{...}
{viewerjumpto "Menu" "log##menu"}{...}
{viewerjumpto "Description" "log##description"}{...}
{viewerjumpto "Links to PDF documentation" "log##linkspdf"}{...}
{viewerjumpto "Options for use with both log and cmdlog" "log##options_both"}{...}
{viewerjumpto "Options for use with log" "log##options_log"}{...}
{viewerjumpto "Option for use with set logtype" "log##option_set_logtype"}{...}
{viewerjumpto "Remarks" "log##remarks"}{...}
{viewerjumpto "Examples" "log##examples"}{...}
{viewerjumpto "Stored results" "log##results"}{...}
{p2colset 1 12 14 2}{...}
{p2col:{bf:[R] log} {hline 2}}Echo copy of session to file{p_end}
{p2col:}({mansection R log:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Report status of log file

{p 8 13 2}
{opt log}

{p 8 13 2}
{opt log} {cmd:query} [{it:logname} | {cmd:_all}]


{phang}
Open log file

{p 8 13 2}
{opt log} {cmd:using} {it:{help filename}} [{cmd:,} {cmd:append}
{cmd:replace} [{opt t:ext}{c |}{opt s:mcl}] {opt name(logname)} {cmd:nomsg}]


{phang}
Close log

{p 8 13 2}
{opt log} {opt c:lose} [{it:logname} | {cmd:_all}]


{phang}
Temporarily suspend logging or resume logging

{p 8 13 2}
{opt log} {c -(}{opt of:f}{c |}{opt on}{c )-} [{it:logname}]


{phang}
Report status of command log file

{p 8 16 2}
{cmd:cmdlog}


{phang}
Open command log file

{p 8 16 2}
{cmd:cmdlog} {cmd:using} {it:{help filename}} [{cmd:,} {cmd:append}
       {cmd:replace}]


{phang}
Close command log, temporarily suspend logging, or resume logging

{p 8 16 2}
{cmd:cmdlog} {c -(}{opt c:lose}{c |}{opt on}{c |}{opt of:f}{c )-}


{phang}
Set default format for logs

{p 8 16 2}
{cmd:set logtype} {c -(}{opt t:ext}{c |}{opt s:mcl}{c )-}
[{cmd:,} {opt perm:anently}]


{phang}
Specify screen width

{p 8 16 2}
{ul:{cmd:set}} {opt li:nesize} {it:#}


{phang}
In addition to using the {cmd:log} command, you may access the capabilities of
{cmd:log} by selecting {bf:File > Log} from the menu and choosing one of the
options in the list.


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Log}


{marker description}{...}
{title:Description}

{pstd}
{cmd:log} and its subcommands tell Stata to open a log file and create a
record of what you type and any output that appears in the Results window,
to suspend or resume logging, to check logging status, and to close the log
file.  The default format is Stata Markup and Control Language (SMCL)
but can be plain text.  You can have up to five SMCL and five text
logs open at a time.  {cmd:cmdlog} and its subcommands are similar to
{cmd:log} but create a command log recording only what you type and can be
only plain text.  You can have only one command log open at a time.

{pstd}
{cmd:set logtype} and {cmd:set linesize} are commands to control system
parameters that relate to logs.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R logQuickstart:Quick start}

        {mansection R logRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_both}{...}
{title:Options for use with both log and cmdlog}

{phang}
{opt append} specifies that results be appended to an existing
file.  If the file does not already exist, a new file is created.

{phang}
{opt replace} specifies that {it:{help filename}}, if it already exists, be
overwritten.  When you do not specify either {opt replace} or {opt append},
the file is assumed to be new.  If the specified file already exists, an error
message is issued and logging is not started.


{marker options_log}{...}
{title:Options for use with log}

{phang}
{opt text} and {opt smcl} specify the format in which the log is to be
recorded.  The default is complicated to describe but is what you would
expect:

{pmore}
If you specify the file as {it:{help filename}}{cmd:.smcl}, the default is to
write the log in SMCL format (regardless of the value of {cmd:set logtype}).

{pmore}
If you specify the file as {it:filename}{cmd:.log}, the default is to write
the log in text format (regardless of the value of {cmd:set logtype}).

{pmore}
If you type {it:filename} without an extension and specify neither the
{opt smcl} option nor the {opt text} option, the default is to write the file
according to the value of {cmd:set logtype}.  If you have not
{cmd:set logtype}, then the default is SMCL.  Also, the {it:filename}
you specified will be fixed to read {it:filename}{cmd:.smcl} if a SMCL log is
being created or {it:filename}{cmd:.log} if a text log is being created.

{pmore}
If you specify either the {cmd:text} or {cmd:smcl} option, then
what you specify determines how the log is written.  If {it:filename} was
specified without an extension, the appropriate extension is added for you.

{pmore}
If you open multiple log files, you may choose a
different format for each file.

{phang}
{opt name(logname)} specifies an optional name you may use to refer
to the log while it is open.  You can start multiple log files,
give each a different {it:logname}, and then close, temporarily
suspend, or resume them each individually.  The default {it:logname} is
{cmd:<unnamed>}.

{phang}
{opt nomsg} suppresses  the default message displayed at the top and bottom of
the log file.  This message consists of the log name (if specified in 
{cmd:name()}, otherwise {cmd:unnamed}), log path, log type, and date opened
or closed.


{marker option_set_logtype}{...}
{title:Option for use with set logtype}

{phang}
{opt permanently} specifies that, in addition to making the change right now,
the {cmd:logtype} setting be remembered and become the default setting 
when you invoke Stata.


{marker remarks}{...}
{title:Remarks}

{pstd}
A full log is a file containing what you type and Stata's output that is shown
in the Results window.  To begin logging your session, you type {cmd:log}
{cmd:using} {it:filename}.  If {it:filename} contains embedded spaces,
remember to enclose it in double quotation marks.

{pstd}
When the default log format is SMCL, {cmd:log} will add the extension
{cmd:.smcl} if {it:filename} is specified without one.  If {cmd:text}
is specified or the default log type is changed to text, {cmd:log} adds the
extension {cmd:.log}.

{pstd}
We recommend using SMCL because it preserves fonts and colors.  SMCL logs can
be viewed and printed from the Viewer window, as can any text file; see
{manhelp view R}.  Users of console Stata can use {cmd:translate} to produce
printable versions of log files.  {cmd:translate} also converts SMCL
logs to text or other formats, such as PostScript or PDF; see
{manhelp translate R}.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. log using mylog}

{phang}{cmd:. log close}

{phang}{cmd:. log using mylog, append}

{phang}{cmd:. log close}

{phang}{cmd:. log using "filename containing spaces"}

{phang}{cmd:. log using firstfile, name(log1) text}

{phang}{cmd:. log using secondfile, name(log2) smcl}

{phang}{cmd:. log using thirdfile, name(log3) smcl}

{phang}{cmd:. log query _all}

{phang}{cmd:. log close log1}

{phang}{cmd:. log close _all}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:log} and {cmd:cmdlog} store the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(name)}}{it:logname}{p_end}
{synopt:{cmd:r(filename)}}name of file{p_end}
{synopt:{cmd:r(status)}}{cmd:on} or {cmd:off}{p_end}
{synopt:{cmd:r(type)}}{cmd:smcl} or {cmd:text}{p_end}
{p2colreset}{...}

{pstd}
{cmd:log} {cmd:query} {cmd:_all} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(numlogs)}}number of open log files{p_end}

{pstd}
For each open log file, {cmd:log} {cmd:query} {cmd:_all} also stores

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(name}{it:#}{cmd:)}}{it:logname}{p_end}
{synopt:{cmd:r(filename}{it:#}{cmd:)}}name of file{p_end}
{synopt:{cmd:r(status}{it:#}{cmd:)}}{cmd:on} or {cmd:off}{p_end}
{synopt:{cmd:r(type}{it:#}{cmd:)}}{cmd:smcl} or {cmd:text}{p_end}
{p2colreset}{...}

{pstd}
where {it:#} varies between {cmd:1} and the value of {cmd:r(numlogs)}.
Be aware that {it:#} will not necessarily represent the order in which
the log files were first opened, nor will it necessarily remain constant
for a given log file upon multiple calls to {cmd:log} {cmd:query}.
{p_end}
