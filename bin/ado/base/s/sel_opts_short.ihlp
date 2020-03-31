{* *! version 1.0.0  22jun2019}{...}
{synopt :{opt stopok}}when the CV function does not have an identified minimum
and the {opt stop(#)} stopping criterion for lambda was reached at
lambda_{stop}, set the selected lambda* to be lambda_{stop}; the
default{p_end}
{synopt :{opt strict}}do not select lambda* when the CV function does not have
an identified minimum; this is a stricter alternative to the default
{cmd:stopok}{p_end}
{synopt :{opt gridminok}}when the CV function does not have an identified
minimum and the {opt stop(#)} stopping criterion for lambda was not reached,
set the selected lambda* to be the minimum of the lambda grid, lambda_{gmin};
this is a looser alternative to the default {cmd:stopok} and is rarely
used{p_end}
