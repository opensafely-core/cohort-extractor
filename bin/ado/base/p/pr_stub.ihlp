{* *! version 1.0.0  04jun2018}{...}
{phang}
{opt pr}, the default, computes the predicted probabilities for all outcomes
or for a specific outcome.  To compute probabilities for all outcomes, you
specify k new variables, where k is the number of categories of the dependent
variable.  Alternatively, you can specify {it:stub}{cmd:*}; in which case,
{cmd:pr} will store predicted probabilities in variables {it:stub}{cmd:1},
{it:stub}{cmd:2}, ..., {it:stub}k.  To compute the probability for a specific
outcome, you specify one new variable and, optionally, the outcome value in
option {cmd:outcome()}; if you omit {cmd:outcome()}, the first outcome value,
{cmd:outcome(#1)}, is assumed.

{pmore}
Say that you fit a model by typing {it:estimation_cmd} {cmd:y x1 x2}, and
{cmd:y} takes on four values.  Then, you could type {cmd:predict p1 p2 p3 p4}
to obtain all four predicted probabilities; alternatively, you could type
{cmd:predict p*} to generate the four predicted probabilities.  To compute
specific probabilities one at a time, you can type {cmd:predict p1,}
{cmd:outcome(#1)} (or simply {cmd:predict p1}), {cmd:predict p2,}
{cmd:outcome(#2)}, and so on.  See option
{cmd:outcome()} for other ways to refer to outcome values.
{p_end}
