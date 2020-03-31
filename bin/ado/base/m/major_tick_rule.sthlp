{smcl}
{* *! version 1.1.3  11feb2011}{...}
{* this hlp file is called by graxis.idlg (and others)}{...}
{vieweralsosee "[G-3] axis_label_options" "help axis_label_options"}{...}
{viewerjumpto "Axis rules for major ticks" "major_tick_rule##axis_rules"}{...}
{viewerjumpto "Custom axis labels" "major_tick_rule##custom"}{...}
{marker axis_rules}{...}
{title:Axis rules for major ticks}

{pstd}
An axis rule specifies where to place major ticks and labels on an axis.
The following table illustrates how axis rules may be specified.

	{it:rule}{col 18}Example{col 30}Description
	{hline -2}
	{cmd:#}{it:#}{...}
{col 18}{cmd:#6}{...}
{col 30}6 nice values
	{it:#}{cmd:(}{it:#}{cmd:)}{it:#}{...}
{col 18}{cmd:-4(.5)3}{...}
{col 30}specified range: -4 to 3 in steps of .5
	{cmd:minmax}{...}
{col 18}{cmd:minmax}{...}
{col 30}minimum and maximum values
	{cmd:none}{...}
{col 18}{cmd:none}{...}
{col 30}label no values
	{cmd:.}{...}
{col 18}{cmd:.}{...}
{col 30}skip the rule
	{hline -2}

{pstd}
A {it:numlist} can also be used to specify an axis rule, see
{help numlist}.


{marker custom}{...}
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
