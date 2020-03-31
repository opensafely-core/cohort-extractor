{smcl}
{* *! version 1.1.8  19oct2017}{...}
{vieweralsosee "[G-3] addplot_option" "mansection G-3 addplot_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway" "help twoway"}{...}
{viewerjumpto "Syntax" "addplot_option##syntax"}{...}
{viewerjumpto "Description" "addplot_option##description"}{...}
{viewerjumpto "Links to PDF documentation" "addplot_option##linkspdf"}{...}
{viewerjumpto "Option" "addplot_option##option"}{...}
{viewerjumpto "Remarks" "addplot_option##remarks"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[G-3]} {it:addplot_option} {hline 2}}Option for adding additional twoway plots to command{p_end}
{p2col:}({mansection G-3 addplot_option:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{it:command}
...
[{cmd:,}
...
{cmd:addplot(}{it:plot} ... [{cmd:||} 
     {it:plot} ... [...]] [{cmd:,} {cmd:below}]{cmd:)}
...]

{phang}
where {it:plot} may be
any subcommand of {helpb graph twoway},
such as
{helpb scatter},
{helpb line}, or {helpb twoway histogram:histogram}.


{marker description}{...}
{title:Description}

{pstd}
Some commands that draw graphs (but do not start with the word {cmd:graph})
are documented in the other reference manuals.  Many of those commands allow
the {cmd:addplot()} option.  This option allows them to overlay their results
on top of {cmd:graph} {cmd:twoway} plots; see
{manhelp graph_twoway G-2:graph twoway}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 addplot_optionRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:addplot(}{it:plots} [{cmd:,} {cmd:below}]{cmd:)}
    specifies the rest of the {cmd:graph} {cmd:twoway} subcommands to be
    added to the {cmd:graph} {cmd:twoway} command issued by {it:command}.

{phang2}
	{cmd:below}
                is a suboption of the {cmd:addplot()} option and specifies that
		the added plots be drawn before the plots drawn by the
		command.  Thus the added plots will appear below the plots
		drawn by {it:command}.  The default is to draw the added plots
		after the command's plots so that they appear above the
		command's plots.  {cmd:below} affects only the added plots
		that are drawn on the same x and y axes as the command's
		plots.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help addplot_option##remarks1:Commands that allow the addplot() option}
	{help addplot_option##remarks2:Advantage of graph twoway commands}
	{help addplot_option##remarks3:Advantages of graphic commands implemented outside graph twoway}
	{help addplot_option##remarks4:Use of the addplot() option}


{marker remarks1}{...}
{title:Commands that allow the addplot() option}

{pstd}
{cmd:graph} commands never allow the {cmd:addplot()} option.  The 
{cmd:addplot()} option is allowed by commands outside {cmd:graph} that are
implemented in terms of {cmd:graph} {cmd:twoway}.

{pstd}
For instance, the {cmd:histogram} command -- see
{manhelp histogram R} -- allows {cmd:addplot()}.  {cmd:graph} {cmd:twoway}
{cmd:histogram} -- see {manhelp twoway_histogram G-2:graph twoway histogram} --
does not.


{marker remarks2}{...}
{title:Advantage of graph twoway commands}

{pstd}
The advantage of {cmd:graph} {cmd:twoway} commands is that they can be
overlaid, one on top of the other.  For instance, you can type

{phang2}
	{cmd:. graph twoway scatter} {it:yvar} {it:xvar} {cmd:||}
		{cmd:lfit} {it:yvar} {it:xvar}

{pstd}
and the separate graphs produced, {cmd:scatter} and {cmd:lfit}, are
combined.
The variables to which each refers need not even be the same:

{phang2}
	{cmd:. graph twoway scatter} {it:yvar} {it:xvar} {cmd:||}
		{cmd:lfit} {it:y2var} {it:x2var}


{marker remarks3}{...}
{title:Advantages of graphic commands implemented outside graph twoway}

{pstd}
Graphic commands implemented outside {cmd:graph} {cmd:twoway} can
have simpler syntax.  For instance, the {cmd:histogram} command
has an option, {cmd:normal}, that will overlay a normal curve on top of
the histogram:

	{cmd:. histogram} {it:myvar}{cmd:, normal}

{pstd}
That is easier than typing

	{cmd:. summarize} {it:myvar}
	{cmd:. graph twoway histogram} {it:myvar} {cmd:||}
	    {cmd:function} {cmd:normden(x,`r(mean)',`r(sd)'),} {cmd:range(}{it:myvar}{cmd:)}

{pstd}
which is the {cmd:graph} {cmd:twoway} way of producing the same thing.

{pstd}
Thus the trade-off between {cmd:graph} and non{cmd:graph} commands is one of
greater flexibility versus easier use.


{marker remarks4}{...}
{title:Use of the addplot() option}

{pstd}
The {cmd:addplot()} option attempts to give back flexibility to non{cmd:graph}
graphic commands.  Such commands are, in fact, implemented in terms of
{cmd:graph} {cmd:twoway}.  For instance, when you type

	{cmd:. histogram} ...

{pstd}
or you type

	{cmd:. sts graph} ...

{pstd}
the result is that those commands construct a complicated
{cmd:graph} {cmd:twoway} command

	{cmd:-> graph twoway} {it:something_complicated}

{pstd}
and then run that for you.  When you specify the {cmd:addplot()} option, such
as in

	{cmd:. histogram} ...{cmd:, addplot(}{it:your_contribution}{cmd:)}

{pstd}
or

	{cmd:. sts graph, addplot(}{it:your_contribution}{cmd:)}

{pstd}
the result is that the commands construct

{phang2}
	{cmd:-> graph twoway} {it:something_complicated} {cmd:||}
		{it:your_contribution}

{pstd}
Let us assume that you have survival data and wish to visually compare the
Kaplan-Meier (that is, the empirical survivor function) with the function that
would be predicted if the survival times were assumed to be exponentially
distributed.  Simply typing

	{cmd:. sysuse cancer, clear}

	{cmd:. quietly stset studytime, fail(died) noshow}

	{cmd:. sts graph}
	  {it:({stata "gr_example2 plotop1":click to run})}
{* graph plotop1}{...}

{pstd}
will obtain a graph of the empirical estimate.
To obtain the exponential estimate, you might type

	{cmd:. quietly streg, distribution(exponential)}

	{cmd:. predict S, surv}

	{cmd:. graph twoway line S _t, sort}
	  {it:({stata "gr_example2 plotop2":click to run})}
{* graph plotop2}{...}

{pstd}
To put these two graphs together, you can type

	{cmd:. sts graph, addplot(line S _t, sort)}
	  {it:({stata "gr_example2 plotop3":click to run})}
{* graph plotop3}{...}

{pstd}
The result is just as if you typed

	{cmd:. sts graph || line S _t, sort}

{pstd}
if only that were allowed.
{p_end}
