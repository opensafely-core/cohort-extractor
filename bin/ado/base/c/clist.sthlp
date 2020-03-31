{smcl}
{* *! version 1.1.6  13jan2011}{...}
{cmd:help clist}{right:also see:  {help prdocumented:previously documented}}
{hline}
{pstd}
{cmd:clist} continues to work but, as of Stata 12, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.

{pstd}
See {helpb list} for a recommended alternative to {cmd:clist}.


{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{bf:[D] clist} {hline 2}}List values of variables{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2} 
{opt cl:ist} [{varlist}] {ifin} [{cmd:,} {it:options}]{p_end}

{synoptset 20}{...}
{synopthdr :options}
{synoptline}
{synopt :[{cmdab:no:}]{opt d:isplay}}format into display or tabular 
nodisplay format{p_end}
{synopt :{opt noh:eader}}omit variable or observation number header
information{p_end}
{synopt :{opt nol:abel}}display numeric codes; default displays label
values{p_end}
{synopt :{opt noo:bs}}suppress printing of observation numbers{p_end}
{synopt :{opt do:ublespace}}insert a blank line between each observation when
in nodisplay mode; has no effect in display mode{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{it:varlist} may contain time-series operators; see {help tsvarlist}.
{p_end}
{p 4 6 2}{opt by} is allowed with {cmd:clist}; see {manhelp by D}.{p_end}


{title:Description}

{pstd}
{cmd:clist} is similar to {cmd:list, clean}; {cmd:clist} is the {cmd:list}
command that appeared in Stata before Stata 8, options and all.  {cmd:list}
continues to be the preferred command.  {cmd:clist} is provided for those
instances when the old style of output is desired.


{title:Options}

{phang}
[{opt no}]{opt display} forces the format into display or 
tabular (nodisplay) format.  If you do not specify one of these two
options, Stata chooses the one it believes would be most readable.

{phang}
{opt noheader} omits variable or observation number header information.  The
blank line and variable names at the top of the listing are omitted when in
nodisplay mode.  The observation number header and one blank line are
omitted for each observation when in display mode.

{phang}
{opt nolabel} specifies that numeric codes be displayed rather than label
values.

{phang}
{opt noobs} suppresses printing of the observation numbers.

{phang}
{opt doublespace} produces a blank line between each observation in the
listing when in nodisplay mode; it has no effect in display mode.


{title:Examples}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. clist}{p_end}
{phang}{cmd:. clist in 1/10}{p_end}
{phang}{cmd:. clist mpg weight}{p_end}
{phang}{cmd:. clist mpg weight in 1/20}{p_end}
{phang}{cmd:. clist if mpg>20}{p_end}
{phang}{cmd:. clist mpg weight if mpg>20}{p_end}
{phang}{cmd:. clist mpg weight if mpg>20 in 1/10}

{phang}{cmd:. by rep78, sort: clist, constant}


{title:Also see}

{psee}
Manual:  {help prdocumented:previously documented}

{psee}
{space 2}Help:  {manhelp display P}, {manhelp edit D}, {manhelp tabdisp P},
{manhelp table R}
{p_end}
