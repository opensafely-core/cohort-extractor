{* *! version 1.0.0  22jun2019}{...}
{phang2}
{cmd:stopok}, {cmd:strict}, and {cmd:gridminok} specify what to do when the CV
function does not have an identified minimum. A minimum is identified at
lambda* when the CV function at both larger and smaller adjacent lambda is
greater than it is at lambda*.  When the CV function has an identified
minimum, {cmd:stopok}, {cmd:strict}, and {cmd:gridminok} all do the same
thing: the selected lambda* is the lambda that gives the minimum.

{pmore2}
In some cases, however, the CV function declines monotonically as lambda gets
smaller and never rises to identify a minimum.  When the CV function does not
have an identified minimum, {cmd:stopok} and {cmd:gridminok} make alternative
selections for lambda*, and {cmd:strict} makes no selection.  When
{cmd:stopok}, {cmd:strict}, or {cmd:gridminok} is not specified, the default
is {cmd:stopok}.  With each of these suboptions, estimation results are always
left in place, and alternative lambda* can be selected and evaluated.

{phang3}
{cmd:stopok} specifies that when the CV function does not have an identified
minimum and the {opt stop(#)} stopping tolerance for lambda was reached, the
selected lambda* is lambda_{stop}, the lambda that met the stopping criterion.
lambda_{stop} is the smallest lambda for which coefficients are estimated, and
it is assumed that lambda_{stop} has a CV function value close to the true
minimum.  When no minimum is identified and the {opt stop(#)} criterion is not
met, an error is issued. 

{phang3}
{cmd:strict} requires the CV function to have an identified minimum.  If it
does not, an error is issued. 

{phang3}
{cmd:gridminok} is a rarely used suboption that specifies that when the CV
function has no identified minimum and the {opt stop(#)} stopping criterion
was not met, lambda_{gmin}, the minimum of the lambda grid, is the selected
lambda*. 

{pmore2}
The {cmd:gridminok} selection criterion is looser than the default
{cmd:stopok}, which is looser than {cmd:strict}.  With {cmd:strict}, only an
identified minimum is selected.  With {cmd:stopok}, either the identified
minimum or lambda_{stop} is selected.  With {cmd:gridminok}, either the
identified minimum or lambda_{stop} or lambda_{gmin} is selected, in this
order.
