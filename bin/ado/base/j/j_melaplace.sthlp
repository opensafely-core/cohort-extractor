{smcl}
{* *! version 1.0.5  23may2018}{...}
{vieweralsosee "[ME] me" "mansection ME me"}{...}
{vieweralsosee "[ME] meglm" "mansection ME meglm"}{...}
{vieweralsosee "[ME] mixed" "mansection ME mixed"}{...}
{viewerjumpto "What is the Laplacian approximation" "j_melaplace##define"}{...}
{viewerjumpto "How is the Laplacian approximation calculated?" "j_melaplace##calculate"}{...}
{viewerjumpto "If Laplacian estimates are biased, why should I want them" "j_melaplace##want"}{...}
{viewerjumpto "References" "j_melaplace##references"}{...}
{marker define}{...}
{title:What is the Laplacian approximation?}

{pstd}
The Laplacian approximation is a computationally efficient method of calculating
the log likelihood in a {help me##GLMM:generalized linear mixed-effects model}.

{marker calculate}{...}
{title:How is the Laplacian approximation calculated?}

{pstd}
Calculating the log likelihood in a mixed-effects model requires integrating out
the random effects, which are assumed to be normally distributed, so that the
likelihood may be expressed as a function of the fixed effects and the
variance components that summarize the random effects.  When the response is
non-Gaussian (binary, for instance), the integral has no closed form and must
instead be approximated by some other means.  The Laplacian method handles
this task by approximating the integrand with a normal distribution centered at
the values of the random effects that maximize the integrand.  These
maximizers correspond to the modes of the posterior distributions of the
random effects given the response.

{pstd}
Another way to estimate the integral is by adaptive Gauss-Hermite
quadrature, and this method is also available in
{help me##GLMM:generalized linear mixed-effects commands}.
Adaptive quadrature is merely plain quadrature in which the
quadrature abscissas are adjusted to better capture the features of the
integrand.  In {helpb meglm} and other generalized linear mixed-effects
commands, the Laplacian approximation is equivalent to the mode-curvature
adaptive Gauss-Hermite quadrature with one integration point as described in
{help j_melaplace##SRH2004:Skrondal and Rabe-Hesketh (2004)}.
The Laplacian approximation is quadrature performed using
one abscissa, the mode itself.

{pstd}
Because the Laplacian approximation involves only one abscissa, estimation can
be much faster than adaptive quadrature using many abscissas.  Of course,
there is a price to be paid for this speed.  Parameter estimates based on the
Laplacian approximation tend to exhibit more bias than those based on
multiabscissa adaptive quadrature, with the bias diminishing as the number of
abscissas (and the computation time involved) increases.


{marker want}{...}
{title:If Laplacian estimates are biased, why should I want them?}

{pstd}
Despite its simplicity, the Laplacian approximation can perform well
({help j_melaplace##LP1994:Liu and Pierce 1994};
 {help j_melaplace##TK1986:Tierney and Kadane 1986}),
and on the basis of our own empirical evidence and the simulation studies of
 {help j_melaplace##PC2006:Pinheiro and Chao (2006)},
bias tends to be more prominent in the estimated variance components than in
the estimated fixed effects.  If you are more interested in inference
on fixed effects adjusted for multilevel random effects than in
estimates of the variance components that summarize the random effects, then
the Laplacian approximation may be adequate for your needs.  

{pstd}
Also, the Laplacian approximation often produces a good 
approximation of the overall model log likelihood.  Therefore, 
the Laplacian approximation can be useful during the model-building phase of
your analysis as you compare competing models with LR tests (which are based on
log likelihoods) before settling on a final model.


{marker references}{...}
{title:References}

{marker LP1994}{...}
{phang}
Liu, Q., and D. A. Pierce. 1994. A note on Gauss-Hermite quadrature.
{it:Biometrika} 81: 624-629.{p_end}

{marker PC2006}{...}
{phang}Pinheiro, J. C., and E. C. Chao. 2006. Efficient Laplacian and 
adaptive Gaussian quadrature algorithms for multilevel generalized 
linear mixed models.  
{it:Journal of Computational and Graphical Statistics} 15: 58-81.{p_end}

{marker SRH2004}{...}
{phang}Skrondal, A., and S. Rabe-Hesketh. 2004.
{browse "http://www.stata.com/bookstore/generalized-latent-variable-modeling/":{it:Generalized Latent Variable Modeling: Multilevel, Longitudinal, and Structural Equation Models}}.
Boca Raton, FL: Chapman & Hall/CRC.{p_end}

{marker TK1986}{...}
{phang}Tierney, L., and J. B. Kadane. 1986. Accurate approximations for 
posterior moments and marginal densities.  
{it:Journal of the American Statistical Association} 81: 82-86.{p_end}
