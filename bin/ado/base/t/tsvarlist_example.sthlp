{smcl}
{* *! version 1.0.4  11feb2011}{...}
{* this hlp file called by _tsdepvars.idlg}{...}
{vieweralsosee "tsvarlist" "help tsvarlist"}{...}
{title:Time-series varlists}

{pstd}
The variables in this list may be time-series operated, which simply means that
for variable {cmd:income}

{center:{c TLC}{hline 13}{c TT}{hline 37}{c TRC}}
{center:{c |}   Typing    {c |}  Means{space 30}{c |}}
{center:{c LT}{hline 13}{c +}{hline 37}{c RT}}
{center:{c |}   {cmd:L.income}  {c |}  first lag of {cmd:income}{space 16}{c |}}
{center:{c |}  {cmd:L3.income}  {c |}  third lag of {cmd:income}{space 16}{c |}}
{center:{c |}   {cmd:D.income}  {c |}  first difference of {cmd:income}{space 9}{c |}}
{center:{c |}  {cmd:D2.income}  {c |}  second difference of {cmd:income}{space 8}{c |}}
{center:{c |}   {cmd:F.income}  {c |}  first lead of {cmd:income}{space 15}{c |}}
{center:{c |}  {cmd:F2.income}  {c |}  second lead of {cmd:income}{space 14}{c |}}
{center:{c |} {cmd:S12.income}  {c |}  the 12-period seasonal difference, {c |}}
{center:{c |}{space 13}{c |}      e.g. ({cmd:income - L12.income})     {c |}}
{center:{c BLC}{hline 13}{c BT}{hline 37}{c BRC}}

{pstd}
A convenient notation is

	    {cmd:D2.(x y z)}

{pstd}
which means, {cmd:D2.x D2.y D2.z}, or the second difference of each variable
in the parenthesis.  This convenient notation can be used with all the
time-series operators.
{p_end}
