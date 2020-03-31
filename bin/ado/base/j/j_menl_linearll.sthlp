{smcl}
{* *! version 1.0.1  15feb2017}{...}
{title:What is linearization log likelihood?}

{pstd}
{cmd:menl} uses the term {it:linearization} {it:log} {it:likelihood} to refer
to the value of the objective function used in the optimization.

{pstd}
{cmd:menl} uses the linearization method of
{help j_menl_linearll##LB1990:Lindstrom and Bates (1990)},
with extensions from {help j_menl_linearll##PB1995:Pinheiro and Bates (1995)},
for estimation.  The linearization method uses a first-order Taylor-series
expansion of the specified nonlinear mean function to approximate it with a
linear function of fixed and random effects.  As a result, a nonlinear
mixed-effects (NLME) model is approximated by a linear mixed-effects (LME)
model, in which the fixed-effects and random-effects design matrices involve
derivatives of the nonlinear mean function with respect to fixed effects
(coefficients) and random effects, respectively.  Linearization log likelihood
is the value of the log likelihood of this approximating LME model.


{title:References}

{marker LB1990}{...}
{phang}
Lindstrom, M. J., and D. M. Bates. 1990. Nonlinear mixed effects models for
repeated measures data. {it:Biometrics} 46: 673-687.

{marker PB1995}{...}
{phang}
Pinheiro, J. C., and D. M. Bates. 1995. Approximations to the log-likelihood
function in the nonlinear mixed-effects model.
{it:Journal of Computational and Graphical Statistics} 4: 12-35.{p_end}
