{smcl}
{* *! version 1.0.5  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] label" "help label"}{...}
{vieweralsosee "[P] _strip_labels" "help _strip_labels"}{...}
{viewerjumpto "Syntax" "_restore_labels##syntax"}{...}
{viewerjumpto "Description" "_restore_labels##description"}{...}
{viewerjumpto "Option" "_restore_labels##option"}{...}
{viewerjumpto "Examples" "_restore_labels##examples"}{...}
{title:Title}

{p 4 30 2}
{hi:[P] _restore_labels} {hline 2} restore value labels to variables


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_restore_labels}
	{varlist}
	{cmd:,}
		{opt labels(lblnamelist)} 


{marker description}{...}
{title:Description}

{pstd}
{cmd:_restore_labels} attaches the value label identifiers to the variables in
{it:varlist}.


{marker option}{...}
{title:Option}

{phang}
{opt labels(lblnameslist)} specifies the list of value label identifiers.  The
number of identifiers in {it:lblnamelist} must equal the number of variable in
{it:varlist}.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. _strip_labels rep78 foreign}{p_end}
{phang}{cmd:. local vlist `s(varlist)'}{p_end}
{phang}{cmd:. local llist `s(labellist)'}{p_end}
{phang}{cmd:. }{it:some work with the unlabeled values}{p_end}
{phang}{cmd:. _restore_labels `vlist', labels(`llist')}{p_end}
