{* *! version 1.0.0  10jan2017}{...}
INCLUDE help bayesmh_credintoptsdes

{phang}
  {it:eform_option} causes the coefficient table to be displayed in
  exponentiated form; see {manhelpi eform_option R}.  The estimation command
  determines which {it:eform_option} is allowed ({opt eform(string)}
  and {cmd:eform} are always allowed).

INCLUDE help bayesmh_batchoptdes

{phang}
{cmd:saving(}{it:{help filename}}[{cmd:, replace}]{cmd:)} saves simulation
results in {it:filename}{cmd:.dta}.  The {cmd:replace} option specifies to
overwrite {it:filename}{cmd:.dta} if it exists. If the {opt saving()} option
is not specified, the {cmd:bayes} prefix saves simulation results in a
temporary file for later access by postestimation commands.  This temporary
file will be overridden every time the {cmd:bayes} prefix is run and will also
be erased if the current estimation results are cleared. {cmd:saving()} may be
specified during estimation or on replay.

{pmore}
The saved dataset has the following structure. Variance {cmd:_index} records
iteration numbers.  The {cmd:bayes} prefix saves only states (sets of
parameter values) that are different from one iteration to another and the
frequency of each state in variable {cmd:_frequency}. (Some states may be
repeated for discrete parameters.) As such, {cmd:_index} may not necessarily
contain consecutive integers. Remember to use {cmd:_frequency} as a frequency
weight if you need to obtain any summaries of this dataset.  Values for each
parameter are saved in a separate variable in the dataset.  Variables
containing values of parameters without equation names are named as
{cmd:eq0_p}{it:#}, following the order in which parameters are declared in
the {cmd:bayes} prefix.  Variables containing values of parameters with
equation names are named as {cmd:eq}{it:#}{cmd:_p}{it:#}, again following the
order in which parameters are defined.  Parameters with the same equation
names will have the same variable prefix {cmd:eq}{it:#}.  For example,

{phang3}
  {cmd:. bayes, saving(mcmc):} ...

{pmore}
will create a dataset, {cmd:mcmc.dta}, with variable names {cmd:eq1_p1} for
{cmd:{c -(}y:x1{c )-}}, {cmd:eq1_p2} for {cmd:{c -(}y:_cons{c )-}}, and
{cmd:eq0_p1} for {cmd:{c -(}var{c )-}}.
Also see macros {cmd:e(parnames)} and {cmd:e(varnames)} for the correspondence
between parameter names and variable names.

{pmore}
In addition, the {cmd:bayes} prefix saves variable {cmd:_loglikelihood} to
contain values of the log likelihood from each iteration and variable
{cmd:_logposterior} to contain values of the log posterior from each
iteration.

{phang}
{opt nomodelsummary} suppresses the detailed summary of the specified model.
The model summary is reported by default.

{phang}
{opt dots} and {opt dots(#)} specify to display dots during simulation.
{opt dots(#)} displays a dot every {it:#} iterations.  During the
adaptation period, a symbol {cmd:a} is displayed instead of a dot. If
{cmd:dots(}...{cmd:,} {opt every(#)}{cmd:)} is specified, then an
iteration number is displayed every {it:#}th iteration instead of a dot or
{cmd:a}. {cmd:dots(, every(}{it:#}{cmd:))} is equivalent to
{cmd:dots(1, every(}{it:#}{cmd:))}.  {cmd:dots} displays dots every 100
iterations and iteration numbers every 1,000 iterations; it is a synonym for
{cmd:dots(100), every(1000)}. By default, no dots are displayed
({cmd:dots(0)}).

{marker noshow()}{...}
{phang}
{opth show:(bayesmh##paramref:paramref)} or
{opth noshow:(bayesmh##paramref:paramref)} specifies a list of model
parameters to be included in the output or excluded from the
output, respectively.  By default, all model parameters 
are displayed. Do not confuse {opt noshow()} with {opt exclude()}, which
excludes the specified parameters from the MCMC sample.

{phang}
{opt notable} suppresses the estimation table from the output.  By default, a
summary table is displayed containing all model parameters except those listed
in the {opt exclude()} and {opt noshow()} options.  Regression model
parameters are grouped by equation names.  The table includes six columns and
reports the following statistics using the MCMC simulation results:
posterior mean, posterior standard deviation, MCMC standard error or
MCSE, posterior median, and credible intervals.  

{phang}
{opt noheader} suppresses the output header either at estimation or upon
replay.

{phang}
{opt title(string)} specifies an optional title for the command that is
displayed above the table of the parameter estimates.  The default title is
specific to the specified likelihood model.

INCLUDE help bayesmh_displayoptsdes
