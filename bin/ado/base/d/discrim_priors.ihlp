{* *! version 1.0.1  22may2007}{...}
{phang}
{opt priors(priors)}
specifies the prior probabilities for group membership. 
The following {it:priors} are allowed:

{phang2}
{cmd:priors(}{opt eq:ual}{cmd:)} specifies equal prior probabilities.
        This is the default.

{phang2}
{cmd:priors(}{opt prop:ortional}{cmd:)} specifies group-size-proportional
    prior probabilities.

{phang2}
{cmd:priors(}{it:matname}{cmd:)} specifies a row or column vector containing
the group prior probabilities.

{phang2}
{cmd:priors(}{it:matrix_exp}{cmd:)} specifies a matrix expression providing a
row or column vector of the group prior probabilities.

{phang}
{opt ties(ties)}
specifies how ties in group classification will be handled.
The following {it:ties} are allowed:

{phang2}
{cmd:ties(}{opt m:issing}{cmd:)} specifies that ties in group classification
produce missing values.  This is the default.

{phang2}
{cmd:ties(}{opt r:andom}{cmd:)} specifies that ties in group classification
are broken randomly.

{phang2}
{cmd:ties(}{opt f:irst}{cmd:)} specifies that ties in group classification are
set to the first tied group.
