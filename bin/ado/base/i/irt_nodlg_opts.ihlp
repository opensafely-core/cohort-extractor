{* *! version 1.0.2  10jan2019}{...}
{pstd}
The following options are available with {cmd:irt} but are not shown in
the dialog box:

{marker startvalues}{...}
{phang} 
{opt startvalues()} specifies how starting values are to be computed.
Starting values specified in {cmd:from()} override the computed starting
values.

{phang2}
{cmd:startvalues(zero)} specifies that all starting values be set to 0.
This option is typically useful only when specified with the
{opt from()} option.

{phang2}
{cmd:startvalues(constantonly)} builds on {cmd:startvalues(zero)} by
fitting a constant-only model for each response to obtain estimates of
intercept and cutpoint parameters.

{phang2} 
{cmd:startvalues(fixedonly)} builds on {cmd:startvalues(constantonly)}
by fitting a full fixed-effects model for each response variable to
obtain estimates of coefficients along with intercept and cutpoint
parameters.  You can also add suboption {opt iterate(#)} to limit the number
of iterations {cmd:irt} allows for fitting the fixed-effects model.

{phang2} 
{cmd:startvalues(ivloadings)} builds on {cmd:startvalues(fixedonly)} by
using instrumental-variable methods with the generalized residuals from
the fixed-effects models to compute starting values for latent-variable
loadings.  This is the default behavior.

{phang} 
{opt noestimate} specifies that the model is not to be fit.  Instead,
starting values are to be shown (as modified by the above options if
modifications were made), and they are to be shown using the {cmd:coeflegend}
style of output.  An important use of this option is before you have modified
starting values at all; you can type the following:

            {cmd:. irt} ...{cmd:,} ... {cmd:noestimate}

            {cmd:. matrix b = e(b)}

            {cmd:.} ... ({it:modify elements of} {cmd:b}) ...

            {cmd:. irt} ...{cmd:,} ... {cmd:from(b)}

{* different description from -mixed- because truly in the est metric here*}{...}
{phang}
{opt estmetric} displays parameter estimates in the slope-intercept metric that
is used for estimation.

{phang}
{opt dnumerical} specifies that during optimization, the gradient vector
and Hessian matrix be computed using numerical techniques instead of
analytical formulas.  By default, {opt irt} uses analytical formulas
for computing the gradient and Hessian for all integration methods.

{phang}
{opt coeflegend}; see {helpb estimation_options:[R] Estimation options}.
{p_end}
