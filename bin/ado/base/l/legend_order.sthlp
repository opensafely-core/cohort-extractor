{smcl}
{* *! version 1.1.2  11feb2011}{...}
{* this hlp file is called by one or more of the graphics dialogs}{...}
{vieweralsosee "[G-3] legend_options" "help legend_options"}{...}
{title:Labels (for use with Legend tab)}

{pstd}You enter {it:orderinfo} in the "Labels" edit field.  {it:orderinfo}
is either

{pin3}
{it:#} "{it:text}" {it:#} "{it:text}" ... {space 5} or {space 5} {it:#} {it:#} ...

{pstd}
{it:orderinfo} specifies which keys are to appear in the legend, what labels
they are to have, and the order in which they are to appear.

{phang}
{it:#} "{it:text}" {it:#} "{it:text}" ... is used to override the default
labeling.

{pin3}
{cmd:1 "A" 2 "B" 3 "C"}

{pmore}
would specify that key 1 is to appear first with label A, followed by key 2
with label B, and key 3 with label C.

{phang}
{it:#} {it:#} ... changes the order of the keys, without changing their
default text.

{pin3}
{cmd:2 1 3}

{pmore}
indicates that first key 2 would appear, followed by key 1, followed by key 3.
If there were four keys, the fourth would be suppressed.


{pstd}
A dash specifies that text is to be inserted into the legend.  For instance,

{pin3}
{cmd:1 2 - "}{it:text}{cmd:"} {cmd:3}

{pstd}
specifies key 1 is to appear first, followed by key 2, followed by the text
{it:text}, followed by key 3.  Imagine that the default key were

		{c TLC}{hline 19}{c TRC}
		{c |}  o   Observed     {c |}
		{c |} {hline 3}  linear       {c |}
		{c |} ---  Quadratic    {c |}
		{c BLC}{hline 19}{c BRC}

{pstd}
Specifying {cmd:1 - "Predicted:" 2 3} would produce

		{c TLC}{hline 19}{c TRC}
		{c |}  o   Observed     {c |}
		{c |}      Predicted:   {c |}
		{c |} {hline 3}  linear       {c |}
		{c |} ---  Quadratic    {c |}
		{c BLC}{hline 19}{c BRC}

{pstd}
and specifying {cmd:1 - " " "Predicted:" 2 3} would produce

		{c TLC}{hline 19}{c TRC}
		{c |}  o   Observed     {c |}
		{c |}                   {c |}
		{c |}      Predicted:   {c |}
		{c |} {hline 3}  linear       {c |}
		{c |} ---  Quadratic    {c |}
		{c BLC}{hline 19}{c BRC}

{pstd}
Note carefully the specification of a blank for the first line of the text
insertion:  we typed {cmd:" "} and not {cmd:""}.  {cmd:""} would insert
nothing.
{p_end}
