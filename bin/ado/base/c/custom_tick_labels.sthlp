{smcl}
{* *! version 1.1.3  11feb2011}{...}
{* this hlp file is called by graxis.idlg (and others)}{...}
{vieweralsosee "[G-3] axis_label_options" "help axis_label_options"}{...}
{title:Custom axis labels}

{pstd}
Specifying nonnumeric labels along an axis is a matter of supplying the
numeric position on the axis followed by its label contained in double quotes
({cmd:""}).  Here are a few examples:

{pin2}
{cmd:0 "male" 1 "female"}

{pin2}
{cmd:1 "first" 2 "second" 3 "third"}

{pin2}
{cmd:1 "M"} {cmd:2 "T"} {cmd:3 "W"} {cmd:4 "Th"}
{cmd:5 "F"} {cmd:6 "Sa"} {cmd:7 "Su"}

{pin2}
{cmd:1 "J"} {cmd:2 "F"}
{cmd:3 "M"}{space 2}{cmd:4 "A"}{space 2}{cmd:5 "M"}{space 2}{cmd:6 "J"}{break}
{cmd:7 "J"} {cmd:8 "A"} {cmd:9 "S"} {cmd:10 "O"} {cmd:11 "N"} {cmd:12 "D"}
{p_end}
