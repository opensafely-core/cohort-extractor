{smcl}
{* *! version 1.4.17  12dec2018}{...}
{viewerdialog arch "dialog arch"}{...}
{vieweralsosee "[TS] arch" "mansection TS arch"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arch postestimation" "help arch postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arima" "help arima"}{...}
{vieweralsosee "[TS] mgarch" "help mgarch"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{viewerjumpto "Syntax" "arch##syntax"}{...}
{viewerjumpto "Menu" "arch##menu"}{...}
{viewerjumpto "Description" "arch##description"}{...}
{viewerjumpto "Links to PDF documentation" "arch##linkspdf"}{...}
{viewerjumpto "Options" "arch##options"}{...}
{viewerjumpto "Examples" "arch##examples"}{...}
{viewerjumpto "Stored results" "arch##results"}{...}
{viewerjumpto "References" "arch##references"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[TS] arch} {hline 2}}Autoregressive conditional
heteroskedasticity (ARCH) family of estimators{p_end}
{p2col:}({mansection TS arch:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:arch}
{depvar}
[{indepvars}]
{ifin}
[{it:{help arch##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt:{opt nocons:tant}}suppress constant term{p_end}
{synopt:{opth arch(numlist)}}ARCH terms{p_end}
{synopt:{opth g:arch(numlist)}}GARCH terms{p_end}
{synopt:{opth saa:rch(numlist)}}simple asymmetric ARCH terms{p_end}
{synopt:{opth ta:rch(numlist)}}threshold ARCH terms{p_end}
{synopt:{opth aa:rch(numlist)}}asymmetric ARCH terms{p_end}
{synopt:{opth na:rch(numlist)}}nonlinear ARCH terms{p_end}
{synopt:{opth narchk(numlist)}}nonlinear ARCH terms with single shift{p_end}
{synopt:{opth ab:arch(numlist)}}absolute value ARCH terms{p_end}
{synopt:{opth at:arch(numlist)}}absolute threshold ARCH terms{p_end}
{synopt:{opth sd:garch(numlist)}}lags of s_t{p_end}
{synopt:{opth ea:rch(numlist)}}new terms in Nelson's EGARCH model{p_end}
{synopt:{opth eg:arch(numlist)}}lags of ln(s_t^2){p_end}
{synopt:{opth p:arch(numlist)}}power ARCH terms{p_end}
{synopt:{opth tp:arch(numlist)}}threshold power ARCH terms{p_end}
{synopt:{opth ap:arch(numlist)}}asymmetric power ARCH terms{p_end}
{synopt:{opth np:arch(numlist)}}nonlinear power ARCH terms{p_end}
{synopt:{opth nparchk(numlist)}}nonlinear power ARCH terms with single shift{p_end}
{synopt:{opth pg:arch(numlist)}}power GARCH terms{p_end}
{synopt:{cmdab:c:onstraints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:Model 2}
{synopt:{opt archm}}include ARCH-in-mean term in the mean-equation specification{p_end}
{synopt:{opth archml:ags(numlist)}}include specified lags of conditional variance in mean equation{p_end}
{synopt:{opth archme:xp(exp)}}apply transformation in {it:exp} to any ARCH-in-mean terms{p_end}
{synopt:{opt arima(#p, #d, #q)}}specify ARIMA({it:p,d,q}) model for dependent variable{p_end}
{synopt:{opth ar(numlist)}}autoregressive terms of the structural model disturbance{p_end}
{synopt:{opth ma(numlist)}}moving-average terms of the structural model disturbances{p_end}

{syntab:Model 3}
{synopt:{opt dist:ribution(dist [#])}}use {it:dist} distribution for errors  (may be {cmdab:gau:ssian}, {cmdab:nor:mal}, {cmd:t}, or {cmd:ged}; default is {cmd:gaussian}){p_end}
{synopt:{opth het(varlist)}}include {it:varlist} in the specification of the
conditional variance{p_end}
{synopt:{opt save:space}}conserve memory during estimation{p_end}

{syntab:Priming}
{synopt:{cmd:arch0(xb)}}compute priming values on the basis of the expected
unconditional variance; the default{p_end}
{synopt:{cmd:arch0(xb0)}}compute priming values on the basis of the estimated
variance of the residuals from OLS{p_end}
{synopt:{cmd:arch0(xbwt)}}compute priming values on the basis of the weighted sum of
squares from OLS residuals{p_end}
{synopt:{cmd:arch0(xb0wt)}}compute priming values on the basis of the weighted sum of
squares from OLS residuals, with more weight at earlier times {p_end}
{synopt:{cmd:arch0(zero)}}set priming values of ARCH terms to zero{p_end}
{synopt:{opt arch0(#)}}set priming values of ARCH terms to {it:#}{p_end}
{synopt:{cmd:arma0(zero)}}set all priming values of ARMA terms to zero; the default{p_end}
{synopt:{cmd:arma0(p)}}begin estimation after observation p, where p is
the maximum AR lag in model{p_end}
{synopt:{cmd:arma0(q)}}begin estimation after observation q, where q is
the maximum MA lag in model {p_end}
{synopt:{cmd:arma0(pq)}}begin estimation after observation (p + q){p_end}
{synopt:{opt arma0(#)}}set priming values of ARMA terms to {it:#}{p_end}
{synopt:{opt condo:bs(#)}}set conditioning observations at the start of the
sample to {it:#}{p_end}

{syntab:SE/Robust}
{synopt:{opth vce(vcetype)}}{it:vcetype} may be {opt opg}, {opt r:obust}, or
{opt oim}{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt:{opt det:ail}}report list of gaps in time series{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help arch##display_options:display_options}}}control columns
      and column formats, row spacing, and line width{p_end}

{syntab:Maximization}
{synopt:{it:{help arch##maximize_options:maximize_options}}}control the
maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {opt tsset} your data before using {opt arch};
see {manhelp tsset TS}.{p_end}
{p 4 6 2}
{it:depvar} and {it:varlist} may contain time-series operators; see {help tsvarlist}.
{p_end}
{p 4 6 2}
{opt by}, {opt fp}, {opt rolling}, {opt statsby}, and {cmd:xi} are allowed; see
{help prefix}.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt iweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp arch_postestimation TS:arch postestimation} for features available after estimation.{p_end}

{pstd}
To fit an ARCH({it:#m}) model with Gaussian errors, type

{pin}
{cmd:. arch} {it:depvar} {it:...}{cmd:,} {cmd:arch(1/}{it:#m}{cmd:)}

{pstd}
To fit a GARCH({it:#m,#k}) model assuming that the errors follow Student's t
distribution with 7 degrees of freedom, type

{pin}
{cmd:. arch} {it:depvar} {it:...}{cmd:,} {cmd:arch(1/}{it:#m}{cmd:)} {cmd:garch(1/}{it:#k}{cmd:)} {cmd:distribution(t 7)}

{pstd}
You can also fit many other models.


{marker menu}{...}
{title:Menu}

    {title:ARCH/GARCH}

{phang2}
{bf:Statistics > Time series > ARCH/GARCH > ARCH and GARCH models}

    {title:EARCH/EGARCH}

{phang2}
{bf:Statistics > Time series > ARCH/GARCH > Nelson's EGARCH model}

    {title:ABARCH/ATARCH/SDGARCH}

{phang2}
{bf:Statistics > Time series > ARCH/GARCH > Threshold ARCH model}

    {title:ARCH/TARCH/GARCH}

{phang2}
{bf:Statistics > Time series > ARCH/GARCH > GJR form of threshold ARCH model}

    {title:ARCH/SAARCH/GARCH}

{phang2}
{bf:Statistics > Time series > ARCH/GARCH > Simple asymmetric ARCH model}

    {title:PARCH/PGARCH}

{phang2}
{bf:Statistics > Time series > ARCH/GARCH > Power ARCH model}

    {title:NARCH/GARCH}

{phang2}
{bf:Statistics > Time series > ARCH/GARCH > Nonlinear ARCH model}

    {title:NARCHK/GARCH}

{phang2}
{bf:Statistics > Time series > ARCH/GARCH > Nonlinear ARCH model with one shift}

    {title:APARCH/PGARCH}

{phang2}
{bf:Statistics > Time series > ARCH/GARCH > Asymmetric power ARCH model}

    {title:NPARCH/PGARCH}

{phang2}
{bf:Statistics > Time series > ARCH/GARCH > Nonlinear power ARCH model}


{marker description}{...}
{title:Description}

{pstd}
{opt arch} fits regression models in which the volatility of a series varies
through time.  Usually, periods of high and low volatility are grouped
together.  ARCH models estimate future volatility as a function of prior
volatility.  To accomplish this, {opt arch} fits models of autoregressive
conditional heteroskedasticity (ARCH) by using conditional maximum likelihood.
In addition to ARCH terms, models may include multiplicative
heteroskedasticity.  Gaussian (normal), Student's t, and 
generalized error distributions are supported.

{pstd}
Concerning the regression equation itself, models may also contain
ARCH-in-mean and ARMA terms.

{pstd}
The following are commonly fitted models:

	Common term{right:Options to specify           }
        {hline -2}
	ARCH{right:{cmd:arch()}                       }

	GARCH{right:{cmd:arch()} {cmd:garch()}               }

	ARCH-in-mean{right:{cmd:archm} {cmd:arch()} [{cmd:garch()}]       }

	GARCH with ARMA terms{right:{cmd:arch()} {cmd:garch()} {cmd:ar()} {cmd:ma()}     }

	EGARCH{right:{cmd:earch()} {cmd:egarch()}             }

	TARCH, threshold ARCH{right:{cmd:abarch()} {cmd:atarch()} {cmd:sdgarch()}  }

	GJR, form of threshold ARCH{right:{cmd:arch()} {cmd:tarch()} [{cmd:garch()}]     }

	SAARCH, simple asymmetric ARCH{right:{cmd:arch()} {cmd:saarch()} [{cmd:garch()}]    }

	PARCH, power ARCH{right:{cmd:parch()} [{cmd:pgarch()}]           }

	NARCH, nonlinear ARCH{right:{cmd:narch()} [{cmd:garch()}]            }

	NARCHK, NARCH with one shift{right:{cmd:narchk()} [{cmd:garch()}]           }

	A-PARCH, asymmetric power ARCH{right:{cmd:aparch()} [{cmd:pgarch()}]          }

	NPARCH, nonlinear power ARCH{right:{cmd:nparch()} [{cmd:pgarch()}]          }
	{hline -2}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS archQuickstart:Quick start}

        {mansection TS archRemarksandexamples:Remarks and examples}

        {mansection TS archMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
  {bf:{help estimation options##noconstant:[R] Estimation options}}.

{phang}
{opth arch(numlist)} specifies the ARCH terms (lags of e_t^2).

{pmore}
   Specify {cmd:arch(1)} to include first-order terms, {cmd:arch(1/2)} to specify
   first- and second-order terms, {cmd:arch(1/3)} to specify first-, second-, and
   third-order terms, etc.  Terms may be omitted.  Specify
   {bind:{cmd:arch(1/3 5)}} to specify terms with lags 1, 2, 3, and 5.  All the
   options work this way.

{pmore}
   {opt arch()} may not be specified with {opt aarch()}, {opt narch()},
   {opt narchk()}, {opt nparchk()}, or {opt nparch()}, as this would result in
   collinear terms.

{phang}
{opth garch(numlist)} specifies the GARCH terms (lags of s_t^2).

{phang}
{opth saarch(numlist)} specifies the simple asymmetric ARCH
   terms.  Adding these terms is one way to make the standard ARCH and GARCH
   models respond asymmetrically to positive and negative innovations.
   Specifying {cmd:saarch()} with {cmd:arch()} and {cmd:garch()} corresponds
   to the SAARCH model of {help arch##E1990:Engle (1990)}.

{pmore}
{opt saarch()} may not be specified with {opt narch()}, {opt narchk()},
   {opt nparchk()}, or {opt nparch()}, as this would result in collinear terms.

{phang}
{opth tarch(numlist)} specifies the threshold ARCH terms.
   Adding these is another way to make the
   standard ARCH and GARCH models respond asymmetrically to positive and
   negative innovations.  Specifying {cmd:tarch()} with {cmd:arch()} and
   {cmd:garch()} corresponds to one form of the GJR model
   ({help arch##GJR1993:Glosten, Jagannathan, and Runkle 1993}).

{pmore}
   {opt tarch()} may not be specified with {opt tparch()} or {opt aarch()}, as
   this would result in collinear terms.

{phang}
{opth aarch(numlist)} specifies the lags of the two-parameter
   term a(|e_t|+g*e_t)^2.  This term provides the same underlying form of
   asymmetry as including {opt arch()} and {opt tarch()}, but it is expressed
   in a different way.
   
{pmore}
   {opt aarch()} may not be specified with {opt arch()} or {opt tarch()},
   as this would result in collinear terms.

{phang}
{opth narch(numlist)} specifies lags of the two-parameter
   term a(e_t-ki)^2.  This term allows the minimum conditional variance to
   occur at a value of lagged innovations other than zero.
   For any term specified at lag L, the minimum contribution to conditional
   variance of that lag occurs when the squared innovations at that lag
   are equal to the estimated constant k_L.

{pmore}
   {opt narch()} may not be specified with {opt arch()}, {opt saarch()},
   {opt narchk()}, {opt nparchk()}, or {opt nparch()}, as this would result in
   collinear terms.

{phang}
{opth narchk(numlist)} specifies lags of the two-parameter term a(e_t-k)^2;
   this is a variation of {opt narch()} with k held constant for all
   lags.

{pmore}
{opt narchk()} may not be specified with {opt arch()}, {opt saarch()},
   {opt narch()}, {opt nparchk()}, or {opt nparch()}, as this would result in
   collinear terms.

{phang}
{opth abarch(numlist)} specifies lags of the term |e_t|.

{phang}
{opth atarch(numlist)} specifies lags of |e_t|(e_t > 0), where (e_t > 0)
   represents the indicator function returning 1 when true and 0 when false.
   Like the TARCH terms, these ATARCH terms allow the effect of unanticipated
   innovations to be asymmetric about zero.

{phang}
{opth sdgarch(numlist)} specifies lags of s_t.
   Combining {opt atarch()}, {opt abarch()}, and {opt sdgarch()} produces the
   model by {help arch##Z1994:Zakoian (1994)} that the author called the TARCH
   model.  The acronym TARCH, however, refers to any model using thresholding
   to obtain asymmetry.

{phang}
{opth earch(numlist)} specifies lags of the two-parameter
   term {bind:a*z_t+g*(|z_t|- sqrt(2/pi))}.  These terms represent the
   influence of news -- lagged innovations -- in Nelson's
   ({help arch##N1991:1991}) EGARCH
   model.  For these terms, z_t=e_t/s_t, and {opt arch} assumes z_t ~ N(0,1).
   Nelson derived the general form of an EGARCH model for any assumed
   distribution and performed estimation assuming a generalized error
   distribution (GED).  See 
   {help arch##H1994:Hamilton (1994)} for a derivation where z_t is
   assumed normal.  The z_t terms can be parameterized
   in either of these two equivalent ways.  {opt arch} uses Nelson's original
   parameterization; see 
   {help arch##H1994:Hamilton (1994)} for an equivalent alternative.

{phang}
{opth egarch(numlist)} specifies lags of ln(s_t^2).

{pstd}
For the following options, the model is parameterized in terms of
h(e_t)^p and s_t^p.  One p is estimated, even when more than one option
is specified.

{phang}
{opth parch(numlist)} specifies lags of |e_t|^p.
   {opt parch()} combined with {opt pgarch()} corresponds to the class of
   nonlinear models of conditional variance suggested by 
   {help arch##HB1992:Higgins and Bera (1992)}.

{phang}
{opth tparch(numlist)} specifies lags of (e_t>0)|e_t|^p, where
   (e_t > 0) represents the indicator function returning 1 when true and 0
   when false.  As with {opt tarch()}, {opt tparch()} specifies terms that
   allow for a differential impact of "good" (positive innovations) and "bad"
   (negative innovations) news for lags specified by {it:numlist}.

{pmore}
   {opt tparch()} may not be specified with {opt tarch()}, as this would
   result in collinear terms.

{phang}
{opth aparch(numlist)} specifies lags of the two-parameter term
   a(|e_t|+g*e_t)^p.
  This asymmetric power ARCH model, A-PARCH, was proposed by 
  {help arch##DGE1993:Ding, Granger, and Engle (1993)}
  and corresponds to a Box-Cox function in the lagged
  innovations.  The authors fit the original A-PARCH model on more than
  16,000 daily observations of the Standard and Poor's 500, and for good
  reason.  As the number of parameters and the flexibility of the
  specification increase, more data are required to estimate the
  parameters of the conditional heteroskedasticity.  See 
  {help arch##DGE1993:Ding, Granger, and Engle (1993)} for a discussion of how
  seven popular ARCH models nest within the A-PARCH model.

{pmore}
   When g goes to 1, the full term goes to zero for many
   observations and can then be numerically unstable.

{phang}
{opth nparch(numlist)} specifies lags of the two-parameter
   term a|e_t-ki|^p.

{pmore}
{cmd:nparch()} may not be specified with {cmd:arch()},
   {cmd:saarch()}, {cmd:narch()}, {cmd:narchk()}, or {cmd:nparchk()}, as this
   would result in collinear terms.

{phang}
{opth nparchk(numlist)} specifies lags of the two-parameter
   term a|e_t-k|^p; this is a variation of {opt nparch()} with k
   held constant for all lags.  This is a direct analog of {opt narchk()},
   except for the power of p.
   {opt nparchk()} corresponds to an extended form of the model of 
   {help arch##HB1992:Higgins and Bera (1992)} as presented by 
   {help arch##BEN1994:Bollerslev, Engle, and Nelson (1994)}.
   {opt nparchk()} would typically be combined with the {opt pgarch()} option.

{pmore}
   {opt nparchk()} may not be specified with {opt arch()}, {opt saarch()},
   {opt narch()}, {opt narchk()}, or {opt nparch()}, as this would result in
   collinear terms.

{phang}
{opth pgarch(numlist)} specifies lags of (s_t)^p.

{phang}
{opt constraints(constraints)}; see
  {bf:{help estimation options:[R] Estimation options}}.

{dlgtab:Model 2}

{phang}
{opt archm} specifies that an ARCH-in-mean term be included in the
   specification of the mean equation.  This term allows the expected value of
   {depvar} to depend on the conditional variance.  ARCH-in-mean is most
   commonly used in evaluating financial time series when a theory supports a
   tradeoff between asset risk and return.  By default, no ARCH-in-mean terms
   are included in the model.

{pmore}
   {opt archm} specifies that the contemporaneous expected conditional
   variance be included in the mean equation.

{phang}
{opth archmlags(numlist)} is an expansion of {opt archm} that includes lags of
   the conditional variance s_t^2 in the mean equation.  To specify a
   contemporaneous and once-lagged variance, specify either
   {bf:{cmd:archm archmlags(1)}} or {cmd:archmlags(0/1)}.

{phang}
{opth archmexp(exp)} applies the transformation in {it:exp} to any
ARCH-in-mean terms in the model.  The expression should contain an {cmd:X}
wherever a value of the conditional variance is to enter the expression.  This
option can be used to produce the commonly used ARCH-in-mean of the
conditional standard deviation.

{phang}
{opt arima(#p,#d,#q)} is an alternative,
shorthand notation for specifying autoregressive models in the
dependent variable.  The dependent variable and any independent variables are
differenced {it:#d} times, 1 through {it:#p} lags of autocorrelations are
included, and 1 through {it:#q} lags of moving averages are included.
For example, the specification

{pin2}
{cmd:. arch y, arima(2,1,3)}

{pmore}
   is equivalent to

{pin2}
{cmd:. arch D.y, ar(1/2) ma(1/3)}

{pmore}
   The former is easier to write for classic ARIMA models of the mean
   equation, but it is not nearly as expressive as the latter.  If gaps in the
   AR or MA lags are to be modeled, or if different operators are to be
   applied to independent variables, the latter syntax is required.

{phang}
{opth ar(numlist)} specifies the autoregressive terms of the structural model
   disturbance to be included in the model.  For example, {cmd:ar(1/3)}
   specifies that lags 1, 2, and 3 of the structural disturbance be included
   in the model.  {cmd:ar(1,4)} specifies that lags 1 and 4 be included,
   possibly to account for quarterly effects.

{pmore}
   If the model does not contain regressors, these terms can also be
   considered autoregressive terms for the dependent variable; see
   {manhelp arima TS}.

{phang}
{opth ma(numlist)} specifies the moving-average terms to be
   included in the model.  These are the terms for the lagged innovations or
   white-noise disturbances.

{dlgtab:Model 3}

{phang}
{opt distribution(dist [#])} specifies the distribution to assume for 
   the error term.  {it:dist} may be {cmd:gaussian}, {cmd:normal}, {cmd:t}, 
   or {cmd:ged}.  {cmd:gaussian} and {cmd:normal} are synonyms, and {it:#} 
   cannot be specified with them.

{pmore}
If {cmd:distribution(t)} is specified, {cmd:arch} 
assumes that the errors follow Student's t distribution, and the 
degree-of-freedom parameter is estimated along with the other parameters 
of the model.  If {cmd:distribution(t} {it:#}{cmd:)} is specified, then 
{cmd:arch} uses Student's t distribution with {it:#} degrees of 
freedom.  {it:#} must be greater than 2.

{pmore}
If {cmd:distribution(ged)} is specified, {cmd:arch} assumes that the errors 
have a generalized error distribution, and the shape parameter is 
estimated along with the other parameters of the model.  If 
{cmd:distribution(ged} {it:#}{cmd:)} is specified, then {cmd:arch} uses 
the generalized error distribution with shape parameter {it:#}.  {it:#} 
must be positive.  The generalized error distribution is identical to the
normal distribution when the shape parameter equals 2.

{phang}
{opth het(varlist)} specifies that {it:varlist} be included in the
   specification of the conditional variance.  {it:varlist} may contain
   time-series operators.  This varlist enters the variance specification
   collectively as multiplicative heteroskedasticity; see
   {help arch##J1985:Judge et al. (1985)}.  If {cmd:het()} is not specified,
   the model will not contain multiplicative heteroskedasticity.

{phang}
{opt savespace} conserves memory by retaining only those variables required
   for estimation.  The original dataset is restored after estimation.  This
   option is rarely used and should be specified only if there is insufficient
   memory to fit a model without the option.  {opt arch} requires
   considerably more temporary storage during estimation than most estimation
   commands in Stata.

{dlgtab:Priming}

{phang}
{opt arch0(cond_method)} is a rarely used option that specifies
how to compute the conditioning (presample or priming) values for s_t^2 and
e_t^2.  In the presample period, it is assumed that s_t^2 = e_t^2 and that
this value is constant.  If {opt arch0()} is not specified, the priming values
are computed as the expected unconditional variance given the current
estimates of the b coefficients and any ARMA parameters.  See 
{mansection TS archOptionsarch0:{bf:[TS] arch}} for details.

{phang}
{opt arma0(cond_method)} is a rarely used option that specifies
how the e_t values are initialized at the beginning of the sample for the ARMA
component, if the model has one.  This option has an effect only when AR or MA
terms are included in the model (the {opt ar()}, {opt ma()}, or
{opt arima()} option specified).  See 
{mansection TS archOptionsarma0:{bf:[TS] arch}} for details.

{phang}
{opt condobs(#)} is a rarely used option that specifies a fixed
   number of conditioning observations at the start of the sample.
   Over these priming observations, the recursions necessary to generate
   predicted disturbances are performed, but only to initialize preestimation
   values of e_t, e_t^2, and s_t^2.  Any required lags of e_t before the
   initialization period are taken to be their expected value of 0 (or the
   value specified in {opt arma0()}), and required values of e_t^2 and s_t^2
   assume the values specified by {opt arch0()}.  {opt condobs()} can be used if
   conditioning observations are desired for the lags in the ARCH terms of the
   model.  If {opt arma()} is also specified, the maximum number of
   conditioning observations required by {opt arma()} and {opt condobs(#)} is
   used.

{dlgtab:SE/Robust}

INCLUDE help vce_roo

{pmore}
For ARCH models, the robust or quasi-maximum likelihood estimates (QMLE) of
variance are robust to symmetric nonnormality in the disturbances.  The
robust variance estimates generally are not robust to functional
misspecification of the mean equation; see 
{help arch##BW1992:Bollerslev and Wooldridge (1992)}.

{pmore}
The robust variance estimates computed by {opt arch} are based on
the full Huber/White/sandwich formulation, as discussed in
{bf:{help _robust:[P] _robust}}.
Many other software packages report robust estimates that set some terms to
their expectations of zero
({help arch##BW1992:Bollerslev and Wooldridge 1992}), which saves them
from calculating second derivatives of the log-likelihood function.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{bf:{help estimation options##level():[R] Estimation options}}.

{phang}
{opt detail} specifies that a detailed list of any gaps in the series
be reported, including gaps due to missing observations or missing data for
the dependent variable or independent variables.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noci},
{opt nopv:alues},
{opt vsquish},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)},
[{cmd:no}]{opt log},
{opt tr:ace}, 
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt gtol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)}; 
see {helpb maximize:[R] Maximize} for all options except {cmd:gtolerance()},
and see below for information on {cmd:gtolerance()}.

{pmore}
   These options are often more important for ARCH models than for other
   maximum likelihood models because of convergence problems associated with
   ARCH models -- ARCH model likelihoods are notoriously difficult to
   maximize.

{pmore}
Setting {cmd:technique()} to something other than the default or BHHH changes
the {it:vcetype} to {cmd:vce(oim)}.

{pmore}
   The following options are all related to maximization and are either
   particularly important in fitting ARCH models or not available for most
   other estimators.

{phang2}
{opt gtolerance(#)}
specifies the tolerance for the gradient relative to the
coefficients.  When |g_i*b_i| {ul:<} {opt gtolerance()} for all parameters b_i
and the corresponding elements of the gradient g_i, the gradient tolerance
criterion is met.
The default gradient tolerance for {opt arch} is {cmd:gtolerance(.05)}.

{pmore2}
{cmd:gtolerance(999)} may be specified to disable the gradient criterion.  If
the optimizer becomes stuck with repeated "(backed up)" messages, 
the gradient probably still contains substantial values, but an uphill direction
cannot be found for the likelihood.  With this option, results can often be
obtained, but whether the global maximum likelihood has been found is unclear.

{pmore2}
When the maximization is not going well, it is also possible to set the maximum
number of iterations (see {helpb maximize:[R] Maximize}) to the point where the optimizer
appears to be stuck and to inspect the estimation results at that point.

{phang2}
{opt from(init_specs)} specifies the initial values of the 
coefficients.  
ARCH models may be sensitive to initial values and may have coefficient values
that correspond to local maximums.  The default starting values are obtained via
a series of regressions, producing results that, on the basis of asymptotic
theory, are consistent for the b and ARMA parameters and generally reasonable
for the rest.  Nevertheless, these values may not always be feasible in that
the likelihood function cannot be evaluated at the initial values {opt arch}
first chooses.  In such cases, the estimation function is restarted with ARCH
and ARMA parameters initialized to zero.  It is possible, but unlikely, that
even these values will be infeasible and that you will have to supply initial
values yourself.

{pmore2}
The standard syntax for {opt from()} accepts a matrix, a list
of values, or coefficient name value pairs; see {helpb maximize:[R] Maximize}.
{opt arch} also allows the following:

{pmore2}
{cmd:from(archb0)}
sets the starting value for all the ARCH/GARCH/... parameters in the
conditional-variance equation to 0.

{pmore2}
{cmd:from(armab0)} sets the starting value for all ARMA parameters in the
model to 0.

{pmore2}
{cmd:from(archb0 armab0)} sets the starting values for all
ARCH/GARCH/... and ARMA parameters to 0.

{pstd}
The following options are available with {opt arch} but are not shown in the
dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse wpi1}

{pstd}ARCH model with three lags{p_end}
{phang2}{cmd:. arch D.ln_wpi, arch(1/3)}

{pstd}GARCH(2,1) model{p_end}
{phang2}{cmd:. arch D.ln_wpi, arch(1/2) garch(1)}

{pstd}Same as above, but assuming that errors follow the generalized error
distribution{p_end}
{phang2}{cmd:. arch D.ln_wpi, arch(1/2) garch(1) distribution(ged)}

    {hline}
    Setup
{phang2}{cmd:. webuse urates}

{pstd}GARCH(1,1) model with covariates{p_end}
{phang2}{cmd:. arch illinois indiana kentucky, arch(1) garch(1)}

{pstd}Same as above, but assuming that errors follow Student's t distribution
with 6 degrees of freedom{p_end}
{phang2}{cmd:. arch illinois indiana kentucky, arch(1) garch(1) distribution(t 6)}

    {hline}
    Setup
{phang2}{cmd:. webuse wpi1}

{pstd}GARCH(1,1) model with ARMA disturbances{p_end}
{phang2}{cmd:. arch D.ln_wpi, ar(1) ma(1 4) arch(1) garch(1)}

{pstd}EGARCH model with ARMA disturbances{p_end}
{phang2}{cmd:. arch D.ln_wpi, ar(1) ma(1 4) earch(1) egarch(1)}

    Setup
{phang2}{cmd:. constraint 1 (3/4)*[ARCH]l1.arch = [ARCH]l2.arch}{p_end}
{phang2}{cmd:. constraint 2 (2/4)*[ARCH]l1.arch = [ARCH]l3.arch}{p_end}
{phang2}{cmd:. constraint 3 (1/4)*[ARCH]l1.arch = [ARCH]l4.arch}{p_end}

{pstd}ARCH model with constraints{p_end}
{phang2}{cmd:. arch D.ln_wpi, ar(1) ma(1 4) arch(1/4) constraint(1/3)}

    {hline}
    Setup
{phang2}{cmd:. webuse dow1}{p_end}

{pstd}Threshold ARCH model{p_end}
{phang2}{cmd:. arch D.ln_dow, tarch(1)}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:arch} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_gaps)}}number of gaps{p_end}
{synopt:{cmd:e(condobs)}}number of conditioning observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(archi)}}sigma_0^2=epsilon_0^2, priming values{p_end}
{synopt:{cmd:e(archany)}}{cmd:1} if model contains ARCH terms, {cmd:0}
                   otherwise{p_end}
{synopt:{cmd:e(tdf)}}degrees of freedom for Student's t distribution{p_end}
{synopt:{cmd:e(shape)}}shape parameter for generalized error distribution{p_end}
{synopt:{cmd:e(tmin)}}minimum time{p_end}
{synopt:{cmd:e(tmax)}}maximum time{p_end}
{synopt:{cmd:e(power)}}varphi for power ARCH terms{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:arch}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(covariates)}}list of covariates{p_end}
{synopt:{cmd:e(eqnames)}}names of equations{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(tmins)}}formatted minimum time{p_end}
{synopt:{cmd:e(tmaxs)}}formatted maximum time{p_end}
{synopt:{cmd:e(dist)}}distribution for error term: {cmd:gaussian}, {cmd:t}, or
                   {cmd:ged}{p_end}
{synopt:{cmd:e(mhet)}}{cmd:1} if multiplicative heteroskedasticity{p_end}
{synopt:{cmd:e(dfopt)}}{cmd:yes} if degrees of freedom for t distribution or
                   shape parameter for GED distribution was estimated, {cmd:no}
		   otherwise{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(ma)}}lags for moving-average terms{p_end}
{synopt:{cmd:e(ar)}}lags for autoregressive terms{p_end}
{synopt:{cmd:e(arch)}}lags for ARCH terms{p_end}
{synopt:{cmd:e(archm)}}ARCH-in-mean lags{p_end}
{synopt:{cmd:e(archmexp)}}ARCH-in-mean exp{p_end}
{synopt:{cmd:e(earch)}}lags for EARCH terms{p_end}
{synopt:{cmd:e(egarch)}}lags for EGARCH terms{p_end}
{synopt:{cmd:e(aarch)}}lags for AARCH terms{p_end}
{synopt:{cmd:e(narch)}}lags for NARCH terms{p_end}
{synopt:{cmd:e(aparch)}}lags for A-PARCH terms{p_end}
{synopt:{cmd:e(nparch)}}lags for NPARCH terms{p_end}
{synopt:{cmd:e(saarch)}}lags for SAARCH terms{p_end}
{synopt:{cmd:e(parch)}}lags for PARCH terms{p_end}
{synopt:{cmd:e(tparch)}}lags for TPARCH terms{p_end}
{synopt:{cmd:e(abarch)}}lags for ABARCH terms{p_end}
{synopt:{cmd:e(tarch)}}lags for TARCH terms{p_end}
{synopt:{cmd:e(atarch)}}lags for ATARCH terms{p_end}
{synopt:{cmd:e(sdgarch)}}lags for SDGARCH terms{p_end}
{synopt:{cmd:e(pgarch)}}lags for PGARCH terms{p_end}
{synopt:{cmd:e(garch)}}lags for GARCH terms{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(ml_method)}}type of ml method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(tech)}}maximization technique, including number of iterations
{p_end}
{synopt:{cmd:e(tech_steps)}}number of iterations performed before switching
                    techniques{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker BEN1994}{...}
{phang}
Bollerslev, T., R. F. Engle, and D. B. Nelson. 1994.
ARCH models.  In {it:Handbook of Econometrics, Volume IV}, ed.
R. F. Engle and D. L. McFadden. New York: Elsevier.

{marker BW1992}{...}
{phang}
Bollerslev, T., and J. M. Wooldridge. 1992.
Quasi-maximum likelihood estimation and inference in dynamic models with
time-varying covariances. {it:Econometric Reviews} 11: 143-172.

{marker DGE1993}{...}
{phang}
Ding, Z., C. W. J. Granger, and R. F. Engle. 1993.
A long memory property of stock market returns and a new model.
{it:Journal of Empirical Finance} 1: 83-106.

{marker E1990}{...}
{phang}
Engle, R. F. 1990. Discussion: Stock volatility and the crash of '87.
{it:Review of Financial Studies} 3: 103-106.

{marker GJR1993}{...}
{phang}
Glosten, L. R., R. Jagannathan, and D. E. Runkle. 1993.
On the relation between the expected value and the volatility of the nominal
excess return on stocks. {it:Journal of Finance} 48: 1779-1801.

{marker H1994}{...}
{phang}
Hamilton, J. D. 1994. {it:Time Series Analysis}.
Princeton: Princeton University Press.

{marker HB1992}{...}
{phang}
Higgins, M. L., and A. K. Bera. 1992.
A class of nonlinear ARCH models. {it:International Economic Review} 33:
137-158.

{marker J1985}{...}
{phang}
Judge, G. G., W. E. Griffiths, R. C. Hill, H. L{c u:}tkepohl, and T.-C. Lee.
1985. {it:The Theory and Practice of Econometrics}. 2nd ed. New York: Wiley.

{marker N1991}{...}
{phang}
Nelson, D. B. 1991. Conditional heteroskedasticity in asset returns:
A new approach. {it:Econometrica} 59: 347-370.

{marker Z1994}{...}
{phang}
Zakoian, J. M. 1994. Threshold heteroskedastic models.
{it:Journal of Economic Dynamics and Control} 18: 931-955.
{p_end}
