{smcl}
{* *! version 1.0.0  01mar2019}{...}
{title:Why are some standard errors reported missing?}

{pstd}
Standard errors are not computed for some values reported in 
{bf:estat steady}, {bf:estat policy}, and {bf:estat transition} after
{bf:dsgenl}.  This is because of the structure of the equations in
your model.  The structure can lead to situations in which the
steady-state values of variables, their policy parameters, or their
transition parameters do not depend on any of the parameters estimated
in the model.  They are therefore constrained to the values reported by
the {cmd:estat} commands.  No standard errors are estimated for these
constrained values.
{p_end}

{pstd}
Note that steady-state, policy, and transition values may have implied
constraints even when there are no constraints specified in
{bf:dsgenl}.
{p_end}
