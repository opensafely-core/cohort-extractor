{* *! version 1.1.3  18feb2015}{...}
{phang}
{opth fweight(varname)} specifies frequency weights at
higher levels in a multilevel model, whereas frequency weights at the
first level (the observation level) are specified in the usual manner,
for example, {cmd:[fw=}{it:fwtvar1}{cmd:]}.  {it:varname} can be any valid
Stata variable name, and you can specify {cmd:fweight()} at levels two and
higher of a multilevel model.  For example, in the two-level model

{p 12 16 4}{cmd:. me}... {it:fixed_portion} {cmd:[fw = wt1]}
{cmd:|| school:} ... {cmd:, fweight(wt2)} ...{p_end}

{pmore}
the variable {cmd:wt1} would hold the first-level (the observation-level)
frequency weights, and {cmd:wt2} would hold the second-level (the
school-level) frequency weights.

{phang}
{opth iweight(varname)} specifies importance weights at
higher levels in a multilevel model, whereas importance weights at the
first level (the observation level) are specified in the usual manner,
for example, {cmd:[iw=}{it:iwtvar1}{cmd:]}.  {it:varname} can be any valid
Stata variable name, and you can specify {cmd:iweight()} at levels two and
higher of a multilevel model.  For example, in the two-level model

{p 12 16 4}{cmd:. me}... {it:fixed_portion} {cmd:[iw = wt1]}
{cmd:|| school:} ... {cmd:, iweight(wt2)} ...{p_end}

{pmore}
the variable {cmd:wt1} would hold the first-level (the observation-level)
importance weights, and {cmd:wt2} would hold the second-level (the
school-level) importance weights.

{phang}
{opth pweight(varname)} specifies sampling weights at
higher levels in a multilevel model, whereas sampling weights at the
first level (the observation level) are specified in the usual manner,
for example, {cmd:[pw=}{it:pwtvar1}{cmd:]}.  {it:varname} can be any valid
Stata variable name, and you can specify {cmd:pweight()} at levels two
and higher of a multilevel model.  For example, in the two-level model

{p 12 16 4}{cmd:. me}... {it:fixed_portion} {cmd:[pw = wt1]}
{cmd:|| school:} ... {cmd:, pweight(wt2)} ...{p_end}

{pmore}
variable {cmd:wt1} would hold the first-level (the observation-level) sampling
weights, and {cmd:wt2} would hold the second-level (the school-level) sampling 
weights. 
{p_end}
