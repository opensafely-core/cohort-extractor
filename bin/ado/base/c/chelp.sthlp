{smcl}
{* *! version 1.0.2  03jun2013}{...}
{vieweralsosee "prdocumented" "help previously documented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] hsearch" "help hsearch"}{...}
{vieweralsosee "[R] net search" "help net_search"}{...}
{vieweralsosee "[R] search" "help search"}{...}
{viewerjumpto "Syntax" "chelp##syntax"}{...}
{viewerjumpto "Description" "chelp##description"}{...}
{viewerjumpto "Remarks" "chelp##remarks"}{...}
{pstd}
{cmd:chelp} continues to work but, as of Stata 13, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.

{pstd}
See {helpb help} for a recommended alternative to {cmd:chelp}.


{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{hi:[R] chelp} {hline 2}}Display system help in the Results window{p_end}
{p2colreset}{...}

{hline}

{title:Stata's help system}

{pstd}
There are several kinds of help available to the Stata user. For more
information, see {help help_advice:Advice on getting help}.
The information below is technical details about Stata's {cmd:chelp} command.

{hline}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmdab:ch:elp} [{it:command_or_topic_name}]


{marker description}{...}
{title:Description}

{pstd}
The {cmd:chelp} command displays help information about the specified command
or topic.

{phang}Stata for Mac, Stata for Unix(GUI), and Stata for Windows:{break}
{cmd:chelp} displays help in the Results window.

{phang}Stata for Unix(both GUI and console):{break}
  {cmd:man} is a synonym for {cmd:chelp}.


{marker remarks}{...}
{title:Remarks}

{pstd}
To obtain help for any Stata command, type {cmd:chelp} {it:command}.

{pstd}
{cmd:chelp} is best explained by examples.

{p2colset 11 47 49 2}{...}
{p2col 9 45 49 2: To obtain help for ...}type{p_end}
{p2col: {cmd:regress}}{cmd:chelp regress}{p_end}
{p2col: postestimation tools for {cmd:regress}}{cmd:chelp regress postestimation}{p_end}
{p2col:}or{space 2} {cmd:chelp regress post}{p_end}
{p2col: graph option {cmd:xlabel()}}{cmd:chelp graph xlabel()}{p_end}
{p2col: Stata function {cmd:strpos()}}{cmd:chelp strpos()}{p_end}
{p2col: Mata function {cmd:optimize()}}{cmd:chelp mata optimize()}{p_end}
{p2colreset}{...}

{pstd}
Tips:

{phang2}
o {cmd:chelp} displays help information for the {cmd:help} command.

{phang2}
o {cmd:chelp guide} displays a table of contents for basic Stata concepts.

{phang2}
o {cmd:chelp estimation commands} displays an alphabetical listing of all Stata
estimation commands.

{phang2}
o {cmd:chelp functions} displays help on Stata functions by category.

{phang2}
o {cmd:chelp mata functions} displays a subject table of contents for Mata's
functions.

{phang2}
o {cmd:chelp ts glossary} displays the glossary for the time-series manual,
and similarly for the other Stata specialty manuals.

{pstd}
See {findalias frhelp} for a complete
description of how to use {cmd:chelp}.


{hline}

{title:What to do when you see  {hline 2}more{hline 2}}

{pstd}
Stata pauses and displays the characters {cmd:{hline 2}more{hline 2}} at the
bottom of the results window whenever the output from a command is about to
scroll off the screen.

{col 13}Action{col 49}Result
{col 5}{hline 23}{col 32}{hline 40}
{col 5}Press {hi:Enter} or {hi:Return}{col 32}One more line of text is displayed

{col 5}Press {hi:b}{col 32}The previous screen of text is displayed

{col 5}Press {hi:Ctrl-K}{col 32}{hline 2}more{hline 2} condition is cleared and output stops 

{col 5}Press {hi:q}{col 32}{hline 2}more{hline 2} condition is cleared and output stops

{col 5}Press any other key{col 32}The next screen of text is displayed
{col 9}(such as space bar)

{col 5}PCs:
{col 9}Press {hi:Ctrl-Break}{col 32}Stata stops processing the command ASAP

{col 5}Mac:
{col 9}Press {hi:Command-.}{col 34}"     "       "       "     "     "

{col 5}Unix(Console):
{col 9}Press {hi:Ctrl-C}{col 34}"     "       "       "     "     "

{col 5}Unix(GUI):
{col 9}Press {hi:Ctrl-Break}{col 34}"     "       "       "     "     "


{pstd}
{hline 2}more{hline 2} happens all the time, not just in {cmd:chelp}, because 
Stata does not scroll information off the screen without your permission.

{pstd}
These same keystrokes will work in response to a {hline 2}more{hline 2}
given by other commands, except that pressing {hi:b} works only with
{cmd:chelp}.  You cannot press {hi:b} to back up to the previous screen with
other commands.


{title:Interrupting Stata commands}

{pstd}
You can press {hi:Ctrl-Break} (or {hi:Command-.} or {hi:Ctrl-C}) at any
time to interrupt any command in Stata, not just in response to
{hline 2}more{hline 2}.
{p_end}
