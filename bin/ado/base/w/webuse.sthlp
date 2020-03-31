{smcl}
{* *! version 1.3.3  15oct2018}{...}
{viewerdialog webuse "dialog webuse"}{...}
{vieweralsosee "[D] webuse" "mansection D webuse"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 1.2.2 Example datasets" "help dta_contents"}{...}
{vieweralsosee "[D] sysuse" "help sysuse"}{...}
{vieweralsosee "[D] use" "help use"}{...}
{viewerjumpto "Syntax" "webuse##syntax"}{...}
{viewerjumpto "Menu" "webuse##menu"}{...}
{viewerjumpto "Description" "webuse##description"}{...}
{viewerjumpto "Links to PDF documentation" "webuse##linkspdf"}{...}
{viewerjumpto "Option" "webuse##option"}{...}
{viewerjumpto "Examples" "webuse##examples"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] webuse} {hline 2}}Use dataset from Stata website{p_end}
{p2col:}({mansection D webuse:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Load dataset over the web

{p 8 16 2}
{cmd:webuse} [{cmd:"}]{it:{help filename}}[{cmd:"}] [{cmd:,} {cmd:clear}]


{phang}
Report URL from which datasets will be obtained

{p 8 16 2}
{cmd:webuse} {cmd:query}


{phang}
Specify URL from which dataset will be obtained

{p 8 16 2}
{cmd:webuse} {cmd:set} [{cmd:https://}]{it:url}[{cmd:/}]

{p 8 16 2}
{cmd:webuse} {cmd:set} [{cmd:http://}]{it:url}[{cmd:/}]


{phang}
Reset URL to default

{p 8 16 2}
{cmd:webuse} {cmd:set}


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Example datasets...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:webuse} {it:{help filename}} loads the specified dataset, obtaining it
over the web.  By default, datasets are obtained from
{cmd:https://www.stata-press.com/data/r16/}.
If {it:filename} is specified without a suffix, {cmd:.dta} is assumed.

{pstd}
{cmd:webuse} {cmd:query} reports the URL from which datasets will be obtained.

{pstd}
{cmd:webuse} {cmd:set} allows you to specify the URL to be used as the source
for datasets.  {cmd:webuse} {cmd:set} without arguments resets the source
to {cmd:https://www.stata-press.com/data/r16/}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D webuseQuickstart:Quick start}

        {mansection D webuseRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:clear} specifies that it is okay to replace the data in memory, even
though the current data have not been saved to disk.


{marker examples}{...}
{title:Examples}

{pstd}Report URL from which datasets will be obtained{p_end}
{phang2}{cmd:. webuse query}

{pstd}Change URL from which datasets will be obtained{p_end}
{phang2}{cmd:. webuse set https://www.zzz.edu/users/~sue}

{pstd}Reset URL to the default{p_end}
{phang2}{cmd:. webuse set}

{pstd}Load the {cmd:lifeexp} dataset that is stored at 
https://www.stata-press.com/data/r16{p_end}
{phang2}{cmd:. webuse lifeexp}

{pstd}Equivalent to above command{p_end}
{phang2}{cmd:. use https://www.stata-press.com/data/r16/lifeexp}{p_end}
