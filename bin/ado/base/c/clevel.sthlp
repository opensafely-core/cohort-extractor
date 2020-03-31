{smcl}
{* *! version 1.0.5  15may2018}{...}
{vieweralsosee "[BAYES] set clevel" "mansection BAYES setclevel"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian estimation"}{...}
{vieweralsosee "[P] creturn" "help creturn"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "clevel##syntax"}{...}
{viewerjumpto "Description" "clevel##description"}{...}
{viewerjumpto "Links to PDF documentation" "clevel##linkspdf"}{...}
{viewerjumpto "Option" "clevel##option"}{...}
{viewerjumpto "Remarks" "clevel##remarks"}{...}
{viewerjumpto "Note concerning estimation commands" "clevel##note"}{...}
{viewerjumpto "Examples" "clevel##examples"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[BAYES] set clevel} {hline 2}}Set default credible level{p_end}
{p2col:}({mansection BAYES setclevel:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:set} {opt clevel} {it:#} [{cmd:,} {opt perm:anently}]

{phang}
{it:#} is any number between 10.00 and 99.99 and may be specified with at most
two digits after the decimal point.


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:clevel} specifies the default credible level for credible
intervals for all Bayesian commands
(see {manhelp bayesian_commands BAYES:Bayesian commands}) that report
credible intervals.  The initial value is 95, meaning 95% credible intervals.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES setclevelRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt permanently} specifies that in addition to making the change right now,
the {cmd:clevel} setting be remembered and become the default setting when you
invoke Stata.


{marker remarks}{...}
{title:Remarks}

{pstd}
To change the level of credible intervals reported by a particular command,
you need not reset the default credible level.  All commands that report
credible intervals have a {opt clevel(#)} option.  When you do not specify the
option, the credible intervals are calculated for the default level set by
{cmd:set} {cmd:clevel} or for 95% if you have not reset {cmd:set}
{cmd:clevel}.


{marker note}{...}
{title:Note concerning estimation commands}

{pstd}
All Bayesian estimation commands can redisplay results when they are typed
without arguments.  The width of the reported credible intervals is a property
of the display, not the estimation, for example,

{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. bayesmh mpg, likelihood(normal(1)) prior({mpg:_cons}, uniform(15,25))}{break}
        (output appears)

{phang2}{cmd:. bayesmh, clevel(90)}{break}
       (output reappears, this time with 90% credible intervals)


{marker examples}{...}
{title:Examples}

{phang}{cmd:. set clevel 90}

{phang}{cmd:. set clevel 99, permanently}
{p_end}
