{* *! version 1.0.0  22jun2019}{...}
{phang}
{cmd:missingok} specifies that, after fitting lassos, the estimation sample be
redefined based on only the nonmissing observations of variables in the final
model.  In all cases, any observation with missing values for {it:depvar},
{it:varsofinterest}, {it:alwaysvars}, and {it:othervars} is omitted from the
estimation sample for the lassos.  By default, the same sample is used for
calculation of the coefficients of the {it:varsofinterest} and their standard
errors.

{pmore}
When {cmd:missingok} is specified, the initial estimation sample is the same
as the default, but the sample used for the calculation of the coefficients of
the {it:varsofinterest} can be larger. Now observations with missing values
for any {it:othervars} not selected will be added to the estimation sample
(provided there are no missing values for any of the variables in the final
model). 

{pmore}
{cmd:missingok} may produce more efficient estimates when data are missing
completely at random.  It does, however, have the consequence that estimation
samples can change when selected variables differ in models fit using
different selection methods. That is, when {it:othervars} contain missing
values, the estimation sample for a model fit using the default
{cmd:selection(plugin)} will likely differ from the estimation sample for a
model fit using, for example, {cmd:selection(cv)}.
