{* *! version 1.0.1  12mar2017}{...}
{phang}
{marker search_options}
{opt search(search_options)} searches for feasible initial values.
{it:search_options} are {opt on}, {opt repeat(#)}, and {opt off}.

{phang2}
{cmd:search(on)} is equivalent to {cmd:search(repeat(500))}.  This is the
default.

{phang2}
{cmd:search(repeat(}{it:k}{cmd:))}, {it:k}>0, specifies the number of random
attempts to be made to find a feasible initial-value vector, or
initial state.  The default is {cmd:repeat(500)}.  An initial-value vector is
feasible if it corresponds to a state with positive posterior probability.
If feasible initial values are not found after {it:k} attempts, an error will
be issued.  {cmd:repeat(0)} (rarely used) specifies that no random attempts be
made to find a feasible starting point.  In this case, if the specified
initial vector does not correspond to a feasible state, an error will be
issued.

{phang2}
{cmd:search(off)} prevents the command from searching for feasible initial
values.  We do not recommend specifying this option.

INCLUDE help bayesmh_corroptsdes
