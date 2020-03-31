{smcl}
{* *! version 1.4.5  07dec2018}{...}
{vieweralsosee "[M-4] Statistical" "mansection M-4 Statistical"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Intro" "help m4_intro"}{...}
{viewerjumpto "Contents" "m4_statistical##contents"}{...}
{viewerjumpto "Description" "m4_statistical##description"}{...}
{viewerjumpto "Links to PDF documentation" "m4_statistical##linkspdf"}{...}
{viewerjumpto "Remarks" "m4_statistical##remarks"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-4] Statistical} {hline 2}}Statistical functions
{p_end}
{p2col:}({mansection M-4 Statistical:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker contents}{...}
{title:Contents}

{col 2}   [M-5]
{col 2}Manual entry{col 18}Function{col 42}Purpose
{col 2}{hline}

{col 2}   {c TLC}{hline 23}{c TRC}
{col 2}{hline 3}{c RT}{it: Pseudorandom variates }{c LT}{hline}
{col 2}   {c BLC}{hline 23}{c BRC}

{col 2}{bf:{help mf_runiform:runiform()}}{...}
{col 18}{cmd:runiform()}{...}
{col 42}uniform random variates
{col 18}{cmd:rnormal()}{...}
{col 42}normal (Gaussian) random variates
{col 18}{cmd:rseed()}{...}
{col 42}obtain or set the random-variate seed
{col 18}{cmd:rngstate()}{...}
{col 42}obtain or set the random-number 
{col 42}  generator state
{col 18}{hline 10}
{col 18}{cmd:rbeta()}{...}
{col 42}beta random variates
{col 18}{cmd:rbinomial()}{...}
{col 42}binomial random variates
{col 18}{cmd:rcauchy()}{...}
{col 42}Cauchy random variates
{col 18}{cmd:rchi2()}{...}
{col 42}chi-squared random variates
{col 18}{cmd:rdiscrete()}{...}
{col 42}discrete random variates
{col 18}{cmd:rexponential()}{...}
{col 42}exponential random variates
{col 18}{cmd:rgamma()}{...}
{col 42}gamma random variates
{col 18}{cmd:rhypergeometric()}{...}
{col 42}hypergeometric random variates
{col 18}{cmd:rigaussian()}{...}
{col 42}inverse Gaussian random variates
{col 18}{cmd:rlaplace()}{...}
{col 42}Laplace random variates
{col 18}{cmd:rlogistic()}{...}
{col 42}logistic random variates
{col 18}{cmd:rnbinomial()}{...}
{col 42}negative binomial random variates
{col 18}{cmd:rpoisson()}{...}
{col 42}Poisson random variates
{col 18}{cmd:rt()}{...}
{col 42}Student's t random variates
{col 18}{cmd:runiformint()}{...}
{col 42}uniform random integer variates
{col 18}{cmd:rweibull()}{...}
{col 42}Weibull random variates
{col 18}{cmd:rweibullph()}{...}
{col 42}Weibull (proportional hazards)
{col 42}  random variates

{col 2}   {c TLC}{hline 34}{c TRC}
{col 2}{hline 3}{c RT}{it: Means, variances, & correlations }{c LT}{hline}
{col 2}   {c BLC}{hline 34}{c BRC}

{col 2}{bf:{help mf_mean:mean()}}{...}
{col 18}{cmd:mean()}{...}
{col 42}mean 
{col 18}{cmd:variance()}{...}
{col 42}variance 
{col 18}{cmd:quadvariance()}{...}
{col 42}quad-precision variance 
{col 18}{cmd:meanvariance()}{...}
{col 42}mean and variance
{col 18}{cmd:quadmeanvariance()}{...}
{col 42}quad-precision mean and variance
{col 18}{cmd:correlation()}{...}
{col 42}correlation
{col 18}{cmd:quadcorrelation()}{...}
{col 42}quad-precision correlation

{col 2}{bf:{help mf_cross:cross()}}{...}
{col 18}{cmd:cross()}{...}
{col 42}{it:X}'{it:X}, {it:X}'{it:Z}, {it:X}'diag({it:w}){it:Z}, etc.

{col 2}{bf:{help mf_corr:corr()}}{...}
{col 18}{cmd:corr()}{...}
{col 42}make correlation from variance matrix 

{col 2}{bf:{help mf_crossdev:crossdev()}}{...}
{col 18}{cmd:crossdev()}{...}
{col 42}({it:X}:-{it:x})'({it:X}:-{it:x}), ({it:X}:-{it:x})'({it:Z}:-{it:z}), etc.

{col 2}{bf:{help mf_quadcross:quadcross()}}{...}
{col 18}{cmd:quadcross()}{...}
{col 42}quad-precision {cmd:cross()}
{col 18}{cmd:quadcrossdev()}{...}
{col 42}quad-precision {cmd:crossdev()}

{col 2}   {c TLC}{hline 26}{c TRC}
{col 2}{hline 3}{c RT}{it: Factorial & combinations }{c LT}{hline}
{col 2}   {c BLC}{hline 26}{c BRC}

{col 2}{bf:{help mf_factorial:factorial()}}{...}
{col 18}{cmd:factorial()}{...}
{col 42}factorial
{col 18}{cmd:lnfactorial()}{...}
{col 42}natural logarithm of factorial
{col 18}{cmd:gamma()}{...}
{col 42}gamma function
{col 18}{cmd:lngamma()}{...}
{col 42}natural logarithm of gamma function
{col 18}{cmd:digamma()}{...}
{col 42}derivative of {cmd:lngamma()}
{col 18}{cmd:trigamma()}{...}
{col 42}second derivative of {cmd:lngamma()}

{col 2}{bf:{help mf_comb:comb()}}{...}
{col 18}{cmd:comb()}{...}
{col 42}combinatorial function {it:n} choose {it:k}

{col 2}{bf:{help mf_cvpermute:cvpermute()}}{...}
{col 18}{cmd:cvpermutesetup()}{...}
{col 42}permutation setup
{col 18}{cmd:cvpermute()}{...}
{col 42}return permutations, one at a time

{col 2}   {c TLC}{hline 27}{c TRC}
{col 2}{hline 3}{c RT}{it: Densities & distributions }{c LT}{hline}
{col 2}   {c BLC}{hline 27}{c BRC}

{col 2}{bf:{help mf_normal:normal()}}{...}
{col 18}{cmd:normalden()}{...}
{col 42}normal density
{col 18}{cmd:normal()}{...}
{col 42}cumulative normal
{col 18}{cmd:invnormal()}{...}
{col 42}inverse cumulative normal
{col 18}{cmd:lnnormalden()}{...}
{col 42}logarithm of the normal density
{col 18}{cmd:lnnormal()}{...}
{col 42}logarithm of the cumulative normal
{col 18}{hline 10}
{col 18}{cmd:binormal()}{...}
{col 42}cumulative binormal
{col 18}{hline 10}
{col 18}{cmd:lnmvnormalden()}{...}
{col 42}logarithm of the multivariate normal
{col 42}  density
{col 18}{hline 10}
{col 18}{cmd:betaden()}{...}
{col 42}beta density
{col 18}{cmd:ibeta()}{...}
{col 42}cumulative beta;
{col 42}  a.k.a. incomplete beta function
{col 18}{cmd:ibetatail()}{...}
{col 42}reverse cumulative beta
{col 18}{cmd:invibeta()}{...}
{col 42}inverse cumulative beta
{col 18}{cmd:invibetatail()}{...}
{col 42}inverse reverse cumulative beta
{col 18}{hline 10}
{col 18}{cmd:binomialp()}{...}
{col 42}binomial probability
{col 18}{cmd:binomial()}{...}
{col 42}cumulative binomial
{col 18}{cmd:binomialtail()}{...}
{col 42}reverse cumulative binomial
{col 18}{cmd:invbinomial()}{...}
{col 42}inverse cumulative binomial
{col 18}{cmd:invbinomialtail()}{...}
{col 42}inverse reverse cumulative binomial
{col 18}{hline 10}
{col 18}{cmd:cauchyden()}{...}
{col 42}Cauchy density
{col 18}{cmd:cauchy()}{...}
{col 42}cumulative Cauchy
{col 18}{cmd:cauchytail()}{...}
{col 42}reverse cumulative Cauchy
{col 18}{cmd:invcauchy()}{...}
{col 42}inverse cumulative Cauchy
{col 18}{cmd:invcauchytail()}{...}
{col 42}inverse reverse cumulative Cauchy
{col 18}{cmd:lncauchyden()}{...}
{col 42}logarithm of the Cauchy density
{col 18}{hline 10}
{col 18}{cmd:chi2()}{...}
{col 42}cumulative chi-squared
{col 18}{cmd:chi2den()}{...}
{col 42}chi-squared density
{col 18}{cmd:chi2tail()}{...}
{col 42}reverse cumulative chi-squared
{col 18}{cmd:invchi2()}{...}
{col 42}inverse cumulative chi-squared
{col 18}{cmd:invchi2tail()}{...}
{col 42}inverse reverse cumulative chi-squared
{col 18}{hline 10}
{col 18}{cmd:dunnettprob()}{...}
{col 42}cumulative multiple range; used in
{col 42}  Dunnett's multiple comparison
{col 18}{cmd:invdunnettprob()}{...}
{col 42}inverse cumulative multiple range;
{col 42}  used in Dunnett's multiple
{col 42}  comparison
{col 18}{hline 10}
{col 18}{cmd:exponentialden()}{...}
{col 42}exponential density
{col 18}{cmd:exponential()}{...}
{col 42}cumulative exponential
{col 18}{cmd:exponentialtail()}{...}
{col 42}reverse cumulative exponential
{col 18}{cmd:invexponential()}{...}
{col 42}inverse cumulative exponential
{col 18}{cmd:invexponentialtail()}{...}
{col 42}inverse reverse cumulative exponential
{col 18}{hline 10}
{col 18}{cmd:Fden()}{...}
{col 42}F density
{col 18}{cmd:F()}{...}
{col 42}cumulative F
{col 18}{cmd:Ftail()}{...}
{col 42}reverse cumulative F
{col 18}{cmd:invF()}{...}
{col 42}inverse cumulative F
{col 18}{cmd:invFtail()}{...}
{col 42}inverse reverse cumulative F
{col 18}{hline 10}
{col 18}{cmd:gammaden()}{...}
{col 42}gamma density
{col 18}{cmd:gammap()}{...}
{col 42}cumulative gamma;
{col 42}  a.k.a. incomplete gamma function
{col 18}{cmd:gammaptail()}{...}
{col 42}reverse cumulative gamma
{col 18}{cmd:invgammap()}{...}
{col 42}inverse cumulative gamma
{col 18}{cmd:invgammaptail()}{...}
{col 42}inverse reverse cumulative gamma
{col 18}{cmd:dgammapda()}{...}
{col 42}{it:dg/da}
{col 18}{cmd:dgammapdx()}{...}
{col 42}{it:dg/dx}
{col 18}{cmd:dgammapdada()}{...}
{col 42}{it:d2g/da2}
{col 18}{cmd:dgammapdadx()}{...}
{col 42}{it:d2g/dadx}
{col 18}{cmd:dgammapdxdx()}{...}
{col 42}{it:d2g/dx2}
{col 18}{cmd:lnigammaden()}{...}
{col 42}logarithm of the inverse gamma density
{col 18}{hline 10}
{col 18}{cmd:hypergeometricp()}{...}
{col 42}hypergeometric probability
{col 18}{cmd:hypergeometric()}{...}
{col 42}cumulative hypergeometric
{col 18}{hline 10}
{col 18}{cmd:igaussianden()}{...}
{col 42}inverse Gaussian density
{col 18}{cmd:igaussian()}{...}
{col 42}cumulative inverse Gaussian
{col 18}{cmd:igaussiantail()}{...}
{col 42}reverse cumulative inverse Gaussian 
{col 18}{cmd:invigaussian()}{...}
{col 42}inverse cumulative of inverse
{col 42}  Gaussian 
{col 18}{cmd:invigaussiantail()}{...}
{col 42}inverse reverse cumulative of
{col 42}  inverse Gaussian
{col 18}{cmd:lnigaussianden()}{...}
{col 42}logarithm of the inverse Gaussian
{col 42}  density
{col 18}{hline 10}
{col 18}{cmd:laplaceden()}{...}
{col 42}Laplace density
{col 18}{cmd:laplace()}{...}
{col 42}cumulative Laplace
{col 18}{cmd:laplacetail()}{...}
{col 42}reverse cumulative Laplace
{col 18}{cmd:invlaplace()}{...}
{col 42}inverse cumulative Laplace
{col 18}{cmd:invlaplacetail()}{...}
{col 42}inverse reverse cumulative Laplace
{col 18}{cmd:lnlaplaceden()}{...}
{col 42}logarithm of the Laplace density
{col 18}{hline 10}
{col 18}{cmd:logisticden()}{...}
{col 42}logistic density
{col 18}{cmd:logistic()}{...}
{col 42}cumulative logistic
{col 18}{cmd:logistictail()}{...}
{col 42}reverse cumulative logistic
{col 18}{cmd:invlogistic()}{...}
{col 42}inverse cumulative logistic
{col 18}{cmd:invlogistictail()}{...}
{col 42}inverse reverse cumulative logistic
{col 18}{hline 10}
{col 18}{cmd:nbetaden()}{...}
{col 42}noncentral beta density
{col 18}{cmd:nibeta()}{...}
{col 42}cumulative noncentral beta
{col 18}{cmd:invnibeta()}{...}
{col 42}inverse cumulative noncentral beta
{col 18}{hline 10}
{col 18}{cmd:nbinomialp()}{...}
{col 42}negative binomial probability
{col 18}{cmd:nbinomial()}{...}
{col 42}cumulative negative binomial
{col 18}{cmd:nbinomialtail()}{...}
{col 42}reverse cumulative negative binomial
{col 18}{cmd:invnbinomial()}{...}
{col 42}inverse cumulative negative binomial
{col 18}{cmd:invnbinomialtail()}{...}
{col 42}inverse reverse cumulative negative
{col 42}  binomial
{col 18}{hline 10}
{col 18}{cmd:nchi2()}{...}
{col 42}cumulative noncentral chi-squared
{col 18}{cmd:nchi2den()}{...}
{col 42}noncentral chi-squared density
{col 18}{cmd:nchi2tail()}{...}
{col 42}reverse cumulative noncentral
{col 42}  chi-squared
{col 18}{cmd:invnchi2()}{...}
{col 42}inverse cumulative noncentral
{col 42}  chi-squared
{col 18}{cmd:invnchi2tail()}{...}
{col 42}inverse reverse cumulative noncentral
{col 42}  chi-squared
{col 18}{cmd:npnchi2()}{...}
{col 42}noncentrality parameter of {cmd:nchi2()}
{col 18}{hline 10}
{col 18}{cmd:nF()}{...}
{col 42}cumulative noncentral F
{col 18}{cmd:nFden()}{...}
{col 42}noncentral F density
{col 18}{cmd:nFtail()}{...}
{col 42}reverse cumulative noncentral F
{col 18}{cmd:invnF()}{...}
{col 42}inverse cumulative noncentral F
{col 18}{cmd:invnFtail()}{...}
{col 42}inverse reverse cumulative
{col 42}  noncentral F
{col 18}{cmd:npnF()}{...}
{col 42}noncentrality parameter of {cmd:nF()}
{col 18}{hline 10}
{col 18}{cmd:nt()}{...}
{col 42}cumulative noncentral Student's t
{col 18}{cmd:ntden()}{...}
{col 42}noncentral Student's t density
{col 18}{cmd:nttail()}{...}
{col 42}reverse cumulative noncentral t
{col 18}{cmd:invnt()}{...}
{col 42}inverse cumulative noncentral t
{col 18}{cmd:invnttail()}{...}
{col 42}inverse reverse cumulative
{col 42}  noncentral t
{col 18}{cmd:npnt()}{...}
{col 42}noncentrality parameter of {cmd:nt()}
{col 18}{hline 10}
{col 18}{cmd:poissonp()}{...}
{col 42}Poisson probability
{col 18}{cmd:poisson()}{...}
{col 42}cumulative Poisson
{col 18}{cmd:poissontail()}{...}
{col 42}reverse cumulative Poisson
{col 18}{cmd:invpoisson()}{...}
{col 42}inverse cumulative Poisson
{col 18}{cmd:invpoissontail()}{...}
{col 42}inverse reverse cumulative Poisson
{col 18}{hline 10}
{col 18}{cmd:t()}{...}
{col 42}cumulative Student's t
{col 18}{cmd:tden()}{...}
{col 42}Student's t density
{col 18}{cmd:ttail()}{...}
{col 42}reverse cumulative Student's t
{col 18}{cmd:invt()}{...}
{col 42}inverse cumulative Student's t
{col 18}{cmd:invttail()}{...}
{col 42}inverse reverse cumulative Student's t
{col 18}{hline 10}
{col 18}{cmd:tukeyprob()}{...}
{col 42}cumulative multiple range;
{col 42}  used in Tukey's multiple comparison
{col 18}{cmd:invtukeyprob()}{...}
{col 42}inverse cumulative multiple range;
{col 42}  used in Tukey's multiple comparison
{col 18}{hline 10}
{col 18}{cmd:weibullden()}{...}
{col 42}Weibull density
{col 18}{cmd:weibull}{...}
{col 42}cumulative Weibull
{col 18}{cmd:weibulltail()}{...}
{col 42}reverse cumulative Weibull
{col 18}{cmd:invweibull()}{...}
{col 42}inverse cumulative Weibull
{col 18}{cmd:invweibulltail()}{...}
{col 42}inverse reverse cumulative Weibull
{col 18}{hline 10}
{col 18}{cmd:weibullphden()}{...}
{col 42}Weibull (proportional hazards) density
{col 18}{cmd:weibullph}{...}
{col 42}cumulative Weibull (proportional
{col 42}  hazards)
{col 18}{cmd:weibullphtail()}{...}
{col 42}reverse cumulative Weibull
{col 42}  (proportional hazards)
{col 18}{cmd:invweibullph()}{...}
{col 42}inverse cumulative Weibull
{col 42}  (proportional hazards)
{col 18}{cmd:invweibullphtail()}{...}
{col 42}inverse reverse cumulative Weibull
{col 42}  (proportional hazards)
{col 18}{hline 10}
{col 18}{cmd:lnwishartden()}{...}
{col 42}logarithm of the Wishart density
{col 18}{cmd:lniwishartden()}{...}
{col 42}logarithm of the inverse Wishart
{col 42}  density

{col 2}{bf:{help mf_mvnormal:mvnormal()}}{...}
{col 18}{cmd:mvnormal()}{...}
{col 42}multivariate normal probabilities
{col 42}  (correlation specified)
{col 18}{cmd:mvnormalcv()}{...}
{col 42}multivariate normal probabilities
{col 42}  (covariance specified)
{col 18}{cmd:mvnormalqp()}{...}
{col 42}{cmd:mvnormal()} with specified
{col 42}  quadrature points
{col 18}{cmd:mvnormalcvqp()}{...}
{col 42}{cmd:mvnormalcv()} with specified 
{col 42}  quadrature points
{col 18}{cmd:mvnormalderiv()}{...}
{col 42}derivatives of {cmd:mvnormal()}
{col 18}{cmd:mvnormalcvderiv()}{...}
{col 42}derivatives of {cmd:mvnormalcv()}
{col 18}{cmd:mvnormaldervqp()}{...}
{col 42}{cmd:mvnormalderiv()} with specified
{col 42}  quadrature points
{col 18}{cmd:mvnormalcvderivqp()}{...}
{col 42}{cmd:mvnormalcvderiv()} with specified
{col 42}  quadrature points

{col 2}   {c TLC}{hline 29}{c TRC}
{col 2}{hline 3}{c RT}{it: Maximization & minimization }{c LT}{hline}
{col 2}   {c BLC}{hline 29}{c BRC}

{col 2}{bf:{help mf_optimize:optimize()}}{...}
{col 18}{cmd:optimize()}{...}
{col 42}function maximization & minimization
{col 18}{cmd:optimize_evaluate()}{...}
{col 42}evaluate function at initial values
{col 18}{cmd:optimize_init()}{...}
{col 42}begin optimization
{col 18}{cmd:optimize_init_}{it:*}{cmd:()}{...}
{col 42}set details
{col 18}{cmd:optimize_result_}{it:*}{cmd:()}{...}
{col 42}access results
{col 18}{cmd:optimize_query()}{...}
{col 42}report settings

{col 2}{bf:{help mf_moptimize:moptimize()}}{...}
{col 18}{cmd:moptimize()}{...}
{col 42}function optimization
{col 18}{cmd:moptimize_evaluate()}{...}
{col 42}evaluate function at initial values
{col 18}{cmd:moptimize_init()}{...}
{col 42}begin setup of optimization problem
{col 18}{cmd:moptimize_init_}{it:*}{cmd:()}{...}
{col 42}set details 
{col 18}{cmd:moptimize_result_}{it:*}{cmd:()}{...}
{col 42}access {cmd:moptimize()} results
{col 18}{cmd:moptimize_ado_cleanup()}{...}
{col 42}perform cleanup after ado 
{col 18}{cmd:moptimize_query()}{...}
{col 42}report settings
{col 18}{cmd:moptimize_util_}{it:*}{cmd:()}{...}
{col 42}utility functions for writing
{col 42}  evaluators and processing results
{col 2}{bf:{help mf_linearprogram:LinearProgram()}}{...}
{col 18}{cmd:LinearProgram()}{...}
{col 42}linear programming

{col 2}   {c TLC}{hline 25}{c TRC}
{col 2}{hline 3}{c RT}{it: Logits, odds, & related }{c LT}{hline}
{col 2}   {c BLC}{hline 25}{c BRC}

{col 2}{bf:{help mf_logit:logit()}}{...}
{col 18}{cmd:logit()}{...}
{col 42}log of the odds ratio
{col 18}{cmd:invlogit()}{...}
{col 42}inverse log of the odds ratio
{col 18}{cmd:cloglog()}{...}
{col 42}complementary log-log
{col 18}{cmd:invcloglog()}{...}
{col 42}inverse complementary log-log

{col 2}   {c TLC}{hline 21}{c TRC}
{col 2}{hline 3}{c RT}{it: Multivariate normal }{c LT}{hline}
{col 2}   {c BLC}{hline 21}{c BRC}

{col 2}{bf:{help mf_ghk:ghk()}}{...}
{col 18}{cmd:ghk()}{...}
{col 42}GHK multivariate normal (MVN)
{col 42}  simulator
{col 18}{cmd:ghk_init()}{...}
{col 42}GHK MVN initialization
{col 18}{cmd:ghk_init_}{it:*}{cmd:()}{...}
{col 42}set details
{col 18}{cmd:ghk()}{...}
{col 42}perform simulation
{col 18}{cmd:ghk_query_npts()}{...}
{col 42}return number of simulation points

{col 2}{bf:{help mf_ghkfast:ghkfast()}}{...}
{col 18}{cmd:ghkfast()}{...}
{col 42}GHK MVN simulator
{col 18}{cmd:ghkfast_init()}{...}
{col 42}GHK MVN initialization
{col 18}{cmd:ghkfast_init_}{it:*}{cmd:()}{...}
{col 42}set details
{col 18}{cmd:ghkfast()}{...}
{col 42}perform simulation
{col 18}{cmd:ghkfast_i()}{...}
{col 42}results for the ith observation
{col 18}{cmd:ghk_query_}{it:*}{cmd:()}{...}
{col 42}display settings

{col 2}{hline}


{marker description}{...}
{title:Description}

{p 4 4 2}
The above functions are statistical, probabilistic, or designed to work 
with data matrices.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-4 StatisticalRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p2colset 8 29 32 2}{...}
{p 4 4 2}
Concerning data matrices, see 

{col 8}{...}
{bf:{help m4_stata:[M-4] Stata}}{...}
{col 30}Stata interface functions

{p 4 4 2}
and especially 

{col 8}{...}
{bf:{help mf_st_data:[M-5] st_data()}}{...}
{col 30}Load copy of current Stata dataset
{col 8}{...}
{p2col:{bf:{help mf_st_view:[M-5] st_view()}}}{...}
 Make matrix that is a view onto current Stata dataset

{p 4 4 2}
For other mathematical functions, see

{col 8}{...}
{bf:{help m4_matrix:[M-4] Matrix}}{...}
{col 30}Matrix mathematical functions

{col 8}{...}
{bf:{help m4_scalar:[M-4] Scalar}}{...}
{col 30}Scalar mathematical functions

{col 8}{...}
{bf:{help m4_mathematical:[M-4] Mathematical}}{...}
{col 30}Important mathematical functions
{p2colreset}{...}
