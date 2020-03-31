{smcl}
{* *! version 1.0.3  11feb2011}{...}
{* this hlp file is called by ds.dlg}{...}
{vieweralsosee "[D] ds" "help ds"}{...}
{title:Pattern matching for ds}

{p 4 4 2}
Patterns are used with the {cmd:has()} and {cmd:not()} options to {cmd:ds}.
A pattern consists of the expected text with the addition of the characters
{cmd:*} and {cmd:?}.  {cmd:*} indicates one or more characters go here
and {cmd:?} indicates exactly one character goes here.

	{it:example}{col 30}matches{col 55}does not match
	{hline 70}
	this{col 30}this{col 55}this or that
	{col 55}that
	{col 55}that or this
	{hline 70}
	th?s{col 30}this {col 55}thanks
	{col 30}thus{col 55}the Eagles
	{hline 70}
	th*s{col 30}this{col 55}this or that
	{col 30}ths{col 55}thanks for all the fish
	{col 30}thanks
	{col 30}the Eagles
	{col 30}thanks for all this
	{hline 70}
	this or that{col 30}this{col 55}this or that
	{col 30}or
	{col 30}that
	{hline 70}
	"this or that"{col 30}this or that{...}
{col 55}this or that xyzfoo
	{hline 70}
	"*his * tha*"{...}
{col 30}this or that{col 55}that or this
	{col 30}do this and thank Fred
	{hline 70}
	*is th*{col 30}this{col 55}What is that
	{col 30}that{col 55}fish
	{col 30}this is{col 55}Is this thing matching?
	{col 30}that is
	{col 30}It is where it is
	{col 30}that this
	{col 30}this that
	{col 30}this or that
	{hline 70}
