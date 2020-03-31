{* *! version 1.0.1  07jan2019}{...}
{marker group_option}{...}
{phang}
{opth group(varname)} specifies that the model be fit separately for the
different values of {it:varname}; see
{manhelp irt_group IRT:irt, group()} for details.

{dlgtab:Model}

{marker cns_option}{...}
{phang}
{opt cns(spec)} constrains item parameters to a fixed value or constrains two
or more parameters to be equal; see
{manhelp irt_constraints IRT:irt constraints} for details.

{phang}
{opt listwise} handles missing values through listwise deletion, which means
that the entire observation is omitted from the estimation sample if any
of the items are missing for that observation.
By default, all nonmissing items in an observation are included in the
likelihood calculation; only missing items are excluded.
{p_end}
