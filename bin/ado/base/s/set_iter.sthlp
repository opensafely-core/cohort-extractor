{smcl}
{* *! version 1.0.1  10feb2020}{...}
{vieweralsosee "[R] set iter" "mansection R setiter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] Maximize" "help maximize"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] moptimize()" "help mf_moptimize"}{...}
{vieweralsosee "[M-5] optimize()" "help mf_optimize"}{...}
{vieweralsosee "[M-5] solvenl()" "help mf_solvenl"}{...}
{viewerjumpto "Syntax" "set_iter##syntax"}{...}
{viewerjumpto "Description" "set_iter##description"}{...}
{viewerjumpto "Links to PDF documentation" "set_iter##linkspdf"}{...}
{viewerjumpto "Option" "set_iter##option"}{...}
{viewerjumpto "Examples" "set_iter##examples"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[R]} {it:set iter} {hline 2}}Control iteration settings{p_end}
{p2col:}({mansection R setiter:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}Set whether to display the iteration log

{p 8 20 2}
{cmd:set}
{cmd:iterlog}
{c -(}{cmd:on} | {cmd:off}{c )-}
[{cmd:,} {cmdab:perm:anently}]


{phang}Set default maximum iterations

{p 8 20 2}
{cmd:set} {cmd:maxiter} {it:#} [{cmd:,} {opt perm:anently}]

{pstd}
{it:#} is any number between 0 and 16,000; the initial value is set to 300.


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:iterlog} and {cmd:set} {cmd:maxiter} control the display of the
iteration log and the maximum number of iterations, respectively, for
estimation commands that iterate and for the Mata optimization functions 
{manhelp mf_moptimize M-5:moptimize()},
{manhelp mf_optimize M-5:optimize()}, and
{manhelp mf_solvenl M-5:solvenl()}.

{pstd}
{cmd:set} {cmd:iterlog} specifies whether to display the iteration log.  The
default setting is {cmd:on}, which displays the log.  You can specify 
{bind:{cmd:set} {cmd:iterlog} {cmd:off}} to suppress it.  To change whether
the iteration log is displayed for a particular estimation command, you need
not reset {cmd:iterlog}; you can specify the {cmd:log} or {cmd:nolog} option
with that command.  If you do not specify {cmd:log} or {cmd:nolog}, the
{cmd:iterlog} setting is used.  To view the current setting of {cmd:iterlog},
type {cmd:display} {cmd:c(iterlog)}.

{pstd}
{cmd:set} {cmd:maxiter} specifies the default maximum number of iterations.
To change the maximum number of iterations performed by a particular
estimation command, you need not reset {cmd:maxiter}; you can specify the 
{opt iterate(#)} option with that command.  If you do not specify
{opt iterate(#)}, the {cmd:maxiter} value is used.  To view the current
setting of {cmd:maxiter}, type {cmd:display} {cmd:c(maxiter)}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R setiterRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}
Suppress {cmd:logit}'s iteration log that is displayed by default by specifying the 
{cmd:nolog} option{p_end}
{phang2}{cmd:. logit foreign mpg, nolog}{p_end}

{pstd}
Suppress the iteration log for {cmd:logit} and other iterative commands
without specifying the command's {cmd:nolog} option{p_end}
{phang2}{cmd:. set iterlog off}{p_end}
{phang2}{cmd:. logit foreign mpg}{p_end}
{phang2}{cmd:. mlogit rep78 mpg}{p_end}

{pstd}
Use the {cmd:log} option to display the iteration log for a specific 
command{p_end}
{phang2}{cmd:. mlogit rep78 mpg, log}{p_end}

{pstd}
Switch back to displaying iteration logs by default{p_end}
{phang2}{cmd:. set iterlog on}{p_end}
