{* *! version 1.0.0  27feb2019}{...}
{phang}
{opt parallel} requests that computations be performed in parallel over the
lists of numbers specified for at least two study parameters as command
arguments, starred options allowing {it:{help numlist}}, or both. That is,
when {opt parallel} is specified, the first computation uses the first value
from each list of numbers, the second computation uses the second value, and
so on.  If the specified number lists are of different sizes, the last value
in each of the shorter lists will be used in the remaining computations. By
default, results are computed over all combinations of the number lists.

{pmore}
For example, let a_1 and a_2 be the list of values for one study
parameter, and let b_1 and b_2 be the list of values for another study
parameter. By default, {cmd:ciwidth} will compute results for all possible
combinations of the two values in the two study parameters: (a_1,b_1),
(a_1,b_2), (a_2,b_1), and (a_2,b_2). If {opt parallel} is specified,
{cmd:ciwidth} will compute results for only two combinations: (a_1,b_1) and
(a_2,b_2).
{p_end}
