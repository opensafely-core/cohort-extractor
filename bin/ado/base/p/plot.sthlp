{smcl}
{* *! version 1.0.9  13apr2010}{...}
{cmd:help plot}{right:dialog:  {dialog plot}{space 17}}
{right:{help prdocumented:previously documented}}
{hline}
{pstd}
{cmd:plot} continues to work but, as of Stata 8, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.


{title:Title}

{p 4 18 2}
{hi:[R] plot} {hline 2} Draw scatterplot using typewriter characters


{title:Syntax}

{p 8 13 2}{cmdab:pl:ot} {it:yvar1} [{it:yvar2} [{it:yvar3}]] {it:xvar}
[{cmd:if} {it:exp}] [{cmd:in} {it:range}] [{cmd:,}
{cmdab:c:olumns:(}{it:#}{cmd:)} {cmdab:e:ncode}
{cmdab:h:lines:(}{it:#}{cmd:)} {cmdab:l:ines:(}{it:#}{cmd:)}
{cmdab:v:lines:(}{it:#}{cmd:)} ]

{pstd}
{cmd:by} is allowed; see {manhelp by D}.


{title:Description}

{pstd}
{cmd:plot} produces a two-way scatterplot of {it:yvar} against {it:xvar}
using typewriter characters.  If more than one {it:yvar} is specified, a
single diagram is produced that overlays the plot of each.

{pstd}
{cmd:graph} provides more sophisticated capabilities than does {cmd:plot};
see {manhelp graph G-2}.


{title:Options}

{phang}{cmd:columns(}{it:#}{cmd:)}, 30<= {it:#} <=133, specifies the column
width of the plot; the default is 75.  The plot itself occupies ten
fewer columns than the number specified.  The extra ten columns are used to
label the diagram.

{phang}{cmd:encode} plots points that occur more than once with a symbol
representing the number of occurrences.  Points that occur once are plotted
with "{hi:*}", twice with "{hi:2}", thrice with "{hi:3}", and so on.
Points that occur ten times are plotted with "{hi:A}", eleven with "{hi:B}",
and so on.  {cmd:encode} may not be specified with more than one {it:yvar}.

{phang}{cmd:hlines(}{it:#}{cmd:)} causes a line of dashes ({cmd:-}) to be
drawn across the diagram every {it:#}th line.

{phang}{cmd:lines(}{it:#}{cmd:)}, 10<= {it:#} <=83, specifies the line height
of the plot; the default is 23.  The plot itself occupies
three fewer lines than the number specified.  The three extra lines are used
to label the diagram.

{phang}{cmd:vlines(}{it:#}{cmd:)} causes a vertical line of bars ({hi:|}) to
be drawn on the diagram every {it:#}th column.


{title:Examples}

    {cmd:. plot mpg weight}

    {cmd:. plot brate drate medage}


{title:Also see}

{psee}
Manual:  {help prdocumented:previously documented}

{psee}
{space 2}Help:  {manhelp graph G-2}
{p_end}
