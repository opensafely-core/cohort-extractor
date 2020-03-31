{smcl}
{* *! version 1.1.7  23oct2017}{...}
{vieweralsosee "[R] more" "mansection R more"}{...}
{vieweralsosee "[P] more" "mansection P more"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] creturn" "help creturn"}{...}
{vieweralsosee "[P] sleep" "help sleep"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "more##syntax"}{...}
{viewerjumpto "Description" "more##description"}{...}
{viewerjumpto "Links to PDF documentation" "more##linkspdf"}{...}
{viewerjumpto "Option" "more##option"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[R] more} {hline 2}}The {hline 2}more{hline 2} message{p_end}
{p2col:}({mansection R more:View complete PDF manual entry}){p_end}

{p2col :{bf:[P] more} {hline 2}}Pause until key is pressed{p_end}
{p2col:}({mansection P more:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    The more message

        {cmdab:mor:e}


    Tell Stata to pause or not pause for {hline 2}more{hline 2} messages

{p 8 12 2}
{cmd:set}
{cmdab:mo:re}
{c -(}{opt on}{c |}{opt off}{c )-}
[{cmd:,}
{opt perm:anently}]


    Set number of lines between {hline 2}more{hline 2} messages

{p 8 12 2}
{cmd:set}
{opt pa:gesize}
{it:#}


{marker description}{...}
{title:Description}

{pstd}
{opt more} causes Stata to display {opt {hline 2}more{hline 2}} and pause
until any key is pressed.

{pstd}
{opt set more off}, which is the default, tells Stata not to pause or display
a {opt {hline 2}more{hline 2}} message.  {opt set more on} tells Stata to wait
until you press a key before continuing when a {opt {hline 2}more{hline 2}}
message is displayed.

{pstd}
{opt set pagesize} {it:#} sets the number of lines between
{opt {hline 2}more{hline 2}} messages.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R moreRemarksandexamples:Remarks and examples} ({bf:[R] more})
        {mansection P moreRemarksandexamples:Remarks and examples} ({bf:[P] more})

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt permanently} specifies that, in addition to making the change right now,
    the {opt more} setting be remembered and become the default setting when
    you invoke Stata.
{p_end}
