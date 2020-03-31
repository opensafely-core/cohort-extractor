{smcl}
{* *! version 1.1.22  31jul2019}{...}
{vieweralsosee "[TS] Glossary" "mansection TS Glossary"}{...}
{viewerjumpto "Description" "ts_glossary##description"}{...}
{viewerjumpto "Glossary" "ts_glossary##glossary"}{...}
{viewerjumpto "References" "ts_glossary##references"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[TS] Glossary} {hline 2}}Glossary of terms{p_end}
{p2col:}({mansection TS Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}Commonly used terms are defined here.


{marker glossary}{...}
{title:Glossary}

{phang}
{bf:add factor}.
An add factor is a quantity added to an endogenous variable in a forecast
model.  Add factors can be used to incorporate outside information into a
model, and they can be used to produce forecasts under alternative scenarios.

{phang}
{marker ARCH_model}{...}
{bf:ARCH model}.
An autoregressive conditional heteroskedasticity (ARCH) model is a
regression model in which the conditional variance is modeled as an
{help ts_glossary##auto_process:autoregressive (AR) process}.
The ARCH({it:m}) model is

{phang2}{it:y}_{it:t} = {bf:x}_{it:t} beta + epsilon_{it:t}

{phang2}
        {it:E}(epsilon_{it:t}^2 | epsilon_[{it:t}-1]^2, epsilon_[{it:t}-2]^2, ...) = alpha_0 + alpha_1 epsilon_[{it:t}-1]^2 + ... + alpha_{it:m} epsilon_[{it:t}-{it:m}]^2

{pmore}
where epsilon_{it:t} is a white-noise error term.  The equation for
{it:y}_{it:t} represents the conditional mean of the process, and the equation
for {it:E}(epsilon_{it:t}^2 | epsilon_[{it:t}-1]^2, epsilon_[{it:t}-2]^2, ...)
specifies the conditional variance as an autoregressive function of its past
realizations.  Although the conditional variance changes over time, the
unconditional variance is time invariant because {it:y}_{it:t} is a
{help ts_glossary##stationary_process:stationary process}.
Modeling the conditional variance as an AR process raises the
implied unconditional variance, making this model particularly appealing to
researchers modeling fat-tailed data, such as financial data.

{phang}
{bf:ARFIMA model}.
An autoregressive fractionally integrated moving-average (ARFIMA)
model is a time-series model suitable for use with
{help ts_glossary##long_memory:long-memory processes}.
ARFIMA models generalize autoregressive integrated moving-average
(ARIMA) models by allowing the differencing parameter to be a real
number in (-0.5, 0.5) instead of requiring it to be an integer.

{marker ARIMA_model}{...}
{phang}
{bf:ARIMA model}.
An autoregressive integrated moving-average (ARIMA) model is a
time-series model suitable for use with
{help ts glossary##integrated_process:integrated processes}.  In an
ARIMA({it:p},{it:d},{it:q}) model, the data are differenced {it:d} times to
obtain a stationary series, and then an ARMA({it:p},{it:q}) model is fit to
this differenced data.  ARIMA models that include exogenous
explanatory variables are known as ARMAX models.

{phang}
{bf:ARMA model}.
An autoregressive moving-average (ARMA) model is a time-series model
in which the current period's realization is the sum of an
{help ts_glossary##auto_process:autoregressive (AR) process} and a
{help ts_glossary##MA_process:moving-average (MA) process}.
An ARMA({it:p},{it:q}) model includes {it:p} AR terms and {it:q} MA terms.
ARMA models with just a few lags are often able to fit data as well as pure AR
or MA models with many more lags.

{marker ARMA_process}{...}
{phang}
{bf:ARMA process}.
An autoregressive moving average (ARMA) process is a time series in
which the current value of the variable is a linear function of its own past
values and a weighted average of current and past realizations of a
{help ts_glossary##white_noise:white-noise process}.
It consists of an autoregressive component and a
moving-average component; see
{help ts_glossary##auto_process:{it:autoregressive (AR) process}} and
{help ts_glossary##MA_process:{it:moving-average (MA) process}}.

{phang}
{bf:ARMAX model}.
An ARMAX model is a time-series model in which the current period's
realization is an {help ts_glossary##ARMA_process:ARMA process}
plus a linear function of a set of exogenous variables.  Equivalently, an
ARMAX model is a linear regression model in which the error term is specified
to follow an ARMA process.

{phang}
{bf:autocorrelation function}.
The autocorrelation function (ACF) expresses the correlation 
between periods {it:t} and {it:t}-{it:k} of a time series as function of the
time {it:t} and the lag {it:k}.  For a stationary time series, the ACF does not
depend on {it:t} and is symmetric about {it:k}=0, meaning that the correlation
between periods {it:t} and {it:t}-{it:k} is equal to the correlation between
periods {it:t} and {it:t}+{it:k}.

{marker auto_process}{...}
{phang}
{bf:autoregressive (AR) process}.
An autoregressive (AR) process is a time series in which the current value of
a variable is a linear function of its own past values and a white-noise error
term.  A first-order AR process, denoted as an AR(1)
process, is {it:y}_{it:t} = rho {it:y}_[{it:t}-1] + epsilon_{it:t}.  An
AR({it:p}) model contains {it:p} lagged values of the dependent variable.

{phang}
{bf:band-pass filter}.
Time-series filters are designed to pass or block
{help ts_glossary##stochastic_cycle:stochastic cycles} at
specified frequencies. Band-pass filters, such as those implemented in
{helpb tsfilter bk} and {helpb tsfilter cf}, pass through stochastic cycles in
the specified range of frequencies and block all other stochastic cycles.

{phang}
{bf:Cholesky ordering}.
Cholesky ordering is a method used to orthogonalize the error term in a
{help ts_glossary##VAR:VAR} or
{help ts_glossary##VECM:VECM}
to impose a recursive structure on the dynamic
model, so that the resulting
{help ts_glossary##impulse_response:impulse-response functions} can be given a
causal interpretation.  The method is so named because it uses the Cholesky
decomposition of the error-covariance matrix.

{phang}
{marker CO_estimator}{...}
{bf:Cochrane-Orcutt estimator}.
This estimation is a linear regression estimator that can be used when the
error term exhibits first-order autocorrelation.  An initial estimate of the
autocorrelation parameter rho is obtained from OLS residuals, and
then OLS is performed on the transformed data tilde{{it:y}}_{it:t} =
{it:y}_{it:t} - rho {it:y}_[{it:t}-1] and tilde{{bf:x}}_{it:t} = {bf:x}_{it:t} -
rho {bf:x}_[{it:t}-1].

{phang}
{bf:cointegrating vector}.
A cointegrating vector specifies a stationary linear combination of
nonstationary variables.  Specifically, if each of the variables 
{it:x}_1, {it:x}_2, ..., {it:x}_{it:k} is integrated of order one and there
exists a set of parameters beta_1, beta_2, ..., beta_{it:k} such that 
{it:z}_{it:t} = beta_1 {it:x}_1 + beta_2 {it:x}_2 + ... + beta_{it:k}
{it:x}_{it:k} is a 
{help ts_glossary##stationary_process:stationary process},
the variables {it:x}_1, {it:x}_2, ..., {it:x}_{it:k} are said to be
cointegrated, and the vector beta is known as a cointegrating vector.

{phang}
{bf:conditional variance}.
Although the conditional variance is simply the variance of a conditional
distribution, in time-series analysis the conditional variance is often 
modeled as an
{help ts_glossary##auto_process:autoregressive (AR) process},
giving rise to {help ts_glossary##ARCH_model:ARCH models}.

{phang}
{bf:correlogram}.
A correlogram is a table or graph showing the sample autocorrelations or
partial autocorrelations of a time series.

{marker cov_stationary_process}{...}
{phang}
{bf:covariance stationary process}.
A process is covariance stationary if the mean of the process is finite and
independent of {it:t}, the unconditional variance of the process is finite and
independent of {it:t}, and the covariance between periods {it:t} and
{it:t}-{it:s} is finite and depends on {it:t}-{it:s} but not on {it:t} or
{it:s} themselves.  Covariance stationary processes are also known as weakly
stationary processes.  See also
{help ts_glossary##stationary_process:{it:stationary process}}.

{phang}
{bf:cross-correlation function}.
The cross-correlation function expresses the correlation between one 
series at time {it:t} and another series at time {it:t}-{it:k} as a function of 
the time {it:t} and lag {it:k}.  If both series are stationary, the 
function does not depend on {it:t}.  The function is not symmetric about 
{it:k}=0: rho_[12]({it:k}) != rho_[12](-{it:k}).

{marker cyclical_component}{...}
{phang}
{bf:cyclical component}.
A cyclical component is a part of a time series that is a periodic function of
time.  Deterministic functions of time are deterministic cyclical components,
and random functions of time are stochastic cyclical components.  For example,
fixed seasonal effects are deterministic cyclical components, and random
seasonal effects are stochastic seasonal components.

{pmore}
Random coefficients on time inside of periodic functions form an especially
useful class of stochastic cyclical components; see {helpb ucm:[TS] ucm}.

{phang}
{bf:deterministic trend}.
A deterministic trend is a deterministic function of time that specifies the
long-run tendency of a time series.

{phang}
{bf:difference operator}.
The difference operator Delta denotes the change in the value of a 
variable from period {it:t}-1 to period {it:t}.

{phang}
{bf:drift}.
Drift is the constant term in a
{help ts_glossary##unit_root_process:unit-root process}.  In

            {it:y}_{it:t} = alpha + {it:y}_({it:t}-1) + epsilon_{it:t}

{pmore}
alpha is the drift when epsilon_{it:t} is a stationary, zero-mean process.

{marker dynamic_forecast}{...}
{phang}
{bf:dynamic forecast}.
A dynamic forecast uses forecast values wherever lagged values of the
endogenous variables appear in the model, allowing one to forecast multiple
periods into the future.  See also
{it:{help ts_glossary##static_forecast:static forecast}}.

{phang}
{bf:dynamic-multiplier function}.
A dynamic-multiplier function measures the effect of a shock to an exogenous
variable on an endogenous variable.  The {it:k}th dynamic-multiplier function
of variable {it:i} on variable {it:j} measures the effect on variable {it:j}
in period {it:t}+{it:k} in response to a one-unit shock to variable {it:i} in
period {it:t}, holding everything else constant.

{marker endogenous_variable}{...}
{phang}
{bf:endogenous variable}.
 An endogenous variable is a regressor that is correlated with the unobservable
error term.  Equivalently, an endogenous variable is one whose values are
determined by the equilibrium or outcome of a structural model.
                                                                                
{marker exogenous_variable}{...}
{phang}
{bf:exogenous variable}.
An exogenous variable is one that is correlated with none of the unobservable
error terms in the model.  Equivalently, an exogenous variable is one whose
values change independently of the other variables in a structural model.

{phang}
{bf:exponential smoothing}.
Exponential smoothing is a method of
{help ts_glossary##smoothing:smoothing} a time series in which the
smoothed value at period {it:t} is equal to a fraction alpha of the series
value at time {it:t} plus a fraction 1-alpha of the previous period's
smoothed value.  The fraction alpha is known as the smoothing parameter.

{phang}
{bf:forecast-error variance decomposition}.
Forecast-error variance decompositions measure the fraction of the 
error in forecasting variable {it:i} after {it:h} periods that is attributable 
to the orthogonalized shocks to variable {it:j}.

{marker forward_operator}{...}
{phang}
{bf:forward operator}.
The forward operator {it:F} denotes the value of a variable at time {it:t}+1.
Formally, {it:F}y_{it:t} = y_{{it:t}+1}, and {it:F}^2y_{it:t} =
{it:F}y_{{it:t}+1} = y_{{it:t}+2}.
A forward operator is also known as a lead operator.

{phang}
{marker frequency_domain}{...}
{bf:frequency-domain analysis}.
Frequency-domain analysis is analysis of time-series data by considering its
frequency properties.  The
{help ts_glossary##spectral_density:spectral density function}
and the
{help ts_glossary##spectral_distribution:spectral distribution function}
are key components of frequency-domain analysis, so it is often called
spectral analysis.  In Stata, the {helpb cumsp} and {helpb pergram} commands
are used to analyze the sample spectral distribution and density functions,
respectively.  {helpb psdensity} estimates the spectral density or the
spectral distribution function after estimating the parameters of a parametric
model using {helpb arfima}, {helpb arima}, or {helpb ucm}.

{phang}
{bf:gain (of a linear filter)}.
The gain of a 
{help ts_glossary##linear_filter:linear filter} scales the spectral density of
the unfiltered series into the spectral density of the filtered series for
each frequency.  Specifically, at each frequency, multiplying the spectral
density of the unfiltered series by the square of the gain of a linear filter
yields the spectral density of the filtered series.  If the gain at a
particular frequency is 1, the filtered and unfiltered spectral densities are
the same at that frequency and the corresponding
{help ts_glossary##stochastic_cycle:stochastic cycles} are passed through
perfectly.  If the gain at a particular frequency is 0, the filter removes all
the corresponding stochastic cycles from the unfiltered series.

{phang}
{bf:GARCH model}.
A generalized autoregressive conditional heteroskedasticity (GARCH) model is a
regression model in which the conditional variance is modeled as an
{help ts_glossary##ARMA_process:ARMA process}.  The GARCH({it:m},{it:k}) model
is

{phang2}{it:y}_{it:t} = {bf:x}_{it:t} beta + epsilon_{it:t}

{phang2}sigma_{it:t}^2 = gamma_0 + gamma_1 epsilon_[{it:t}-1]^2 + ... + gamma_{it:m  } epsilon_[{it:t}-{it:m}]^2 + delta_1 sigma_[{it:t}-1]^2 + ... + delta_{it:k} sigma_[{it:t}-{it:k}]^2

{pmore}
where the equation for {it:y}_{it:t} represents the conditional mean of the 
process and sigma_{it:t} represents the conditional variance.  See 
{helpb arch:[TS] arch} or 
{help ts glossary##H1994:Hamilton (1994, chap. 21)} for details on how the 
conditional variance equation can be viewed as an ARMA process.
GARCH models are often used because the ARMA 
specification often allows the conditional variance to be modeled with 
fewer parameters than are required by a pure ARCH model.  Many 
extensions to the basic GARCH model exist; see {helpb arch:[TS] arch} for 
those that are implemented in Stata.  See also
{it:{help ts_glossary##ARCH_model:ARCH model}}.

{phang}
{bf:generalized least-squares estimator}.
A generalized least-squares (GLS) estimator is used to estimate
the parameters of a regression function when the error term is
heteroskedastic or autocorrelated.  In the linear case, GLS is 
sometimes described as "OLS on transformed data" because the 
GLS estimator can be implemented by applying an appropriate 
transformation to the dataset and then using OLS.

{phang}
{bf:Granger causality}.
The variable {it:x} is said to Granger-cause variable {it:y} if, given the
past values of {it:y}, past values of {it:x} are useful for predicting
{it:y}.

{phang}
{bf:high-pass filter}.
Time-series filters are designed to pass or block 
{help ts_glossary##stochastic_cycle:stochastic cycles} at
specified frequencies. High-pass filters, such as those implemented in
{helpb tsfilter bw} and {helpb tsfilter hp}, pass through stochastic cycles
above the cutoff frequency and block all other stochastic cycles.

{phang}
{bf:Holt-Winters smoothing}.
A set of methods for {help ts_glossary##smoothing:smoothing}
time-series data that assume that the value of a time series at time {it:t}
can be approximated as the sum of a mean term that drifts over time, as well
as a time trend whose strength also drifts over time.  Variations of the basic
method allow for seasonal patterns in data, as well.  

{marker impulse_response}{...}
{phang}
{bf:impulse-response function}.
An impulse-response function (IRF) measures the effect of a 
shock to an endogenous variable on itself or another endogenous 
variable.  The {it:k}th impulse-response function of variable {it:i} on 
variable {it:j} measures the effect on variable {it:j} in period {it:t}+{it:k}
in response to a one-unit shock to variable {it:i} in period {it:t}, holding
everything else constant.

{phang}
{bf:independent and identically distributed}.
A series of observations is independent and identically distributed 
(i.i.d.) if each observation is an independent realization from the same 
underlying distribution.  In some contexts, the definition is relaxed to 
mean only that the observations are independent and have identical means 
and variances; see {help ts glossary##DM1993:Davidson and MacKinnon (1993, 42)}.

{marker integrated_process}{...}
{phang}
{bf:integrated process}.
A nonstationary process is integrated of order {it:d}, written 
I({it:d}), if the process must be differenced {it:d} times to produce a 
stationary series.  An I(1) process {it:y}_{it:t} is one in which 
Delta {it:y}_{it:t} is stationary.

{phang}
{bf:Kalman filter}. The Kalman filter is a recursive procedure for predicting
the state vector in a state-space model.

{phang}
{bf:lag operator}.
The lag operator {it:L} denotes the value of a variable at time {it:t}-1.  
Formally, {it:Ly}_{it:t} = {it:y}_[{it:t}-1], and {it:L}^2{it:y}_{it:t} =
{it:Ly}_[{it:t}-1] = {it:y}_[{it:t}-2].

{phang}
{bf:lead operator}.  See
{it:{help ts_glossary##forward_operator:forward operator}}.

{marker linear_filter}{...}
{phang}
{bf:linear filter}.
A linear filter is a sequence of weights used to compute a weighted average of
a time series at each time period.  More formally, a linear filter alpha({it:L})
is      

{phang3}
alpha({it:L}) =  alpha_0 + alpha_1 {it:L} + alpha_2 {it:L}^2 + ...
         = sum_(tau=0)^(infty) alpha_(tau) {it:L}^(tau)

{pmore}
where {it:L} is the lag operator.  Applying the linear filter alpha({it:L}) to
the time series {it:x}_{it:t} yields a sequence of weighted averages of
{it:x}_{it:t}:

{phang3}
alpha({it:L}) {it:x}_{it:t} =
          sum_(tau=0)^(infty) alpha_(tau) {it:L}^(tau) {it:x}_({it:t}-tau)

{marker long_memory}{...}
{phang}
{bf:long-memory process}.  A long-memory process is a
{help ts_glossary##stationary_process:stationary process}
whose autocorrelations decay at a slower rate than a short-memory process.
ARFIMA models are typically used to represent long-memory processes,
and ARMA models are typically used to represent short-memory
processes.

{marker MA_process}{...}
{phang}
{bf:moving-average (MA) process}.
A moving-average (MA) process is a time-series process in which the current
value of a variable is modeled as a weighted average of current and past
realizations of a {help ts_glossary##white_noise:white-noise process} and,
optionally, a time-invariant constant.  By convention, the weight on the
current realization of the white-noise process is equal to one, and the
weights on the past realizations are known as the MA coefficients.  A
first-order MA process, denoted as an MA(1) process, is {it:y}_{it:t} = theta
epsilon_[{it:t}-1] + epsilon_{it:t}.

{phang}
{bf:multivariate GARCH models}.
Multivariate GARCH models are multivariate time-series models in
which the conditional covariance matrix of the errors depends on its own
past and its past shocks.  The acute trade-off between parsimony and
flexibility has given rise to a plethora of models; see {manhelp mgarch TS}.

{phang}
{bf:Newey-West covariance matrix}.
The Newey-West covariance matrix is a member of the class of 
heteroskedasticity- and autocorrelation-consistent (HAC) 
covariance matrix estimators used with time-series data that produces 
covariance estimates that are robust to both arbitrary heteroskedasticity 
and autocorrelation up to a prespecified lag.

{phang}
{bf:one-step-ahead forecast}.  See
{it:{help ts_glossary##static_forecast:static forecast}}.

{phang}
{bf:orthogonalized impulse-response function}.
An orthogonalized impulse-response function (OIRF) measures
the effect of an orthogonalized shock to an endogenous variable on itself or
another endogenous variable.  An orthogonalized shock is one that affects 
one variable at time {it:t} but no other variables.  See
{helpb irf create:[TS] irf create}
for a discussion of the difference between IRFs and OIRFs.

{phang}
{bf:output gap}.
The output gap, sometimes called the GDP gap, is the difference 
between the actual output of an economy and its potential output.

{phang}
{bf:partial autocorrelation function}.
The partial autocorrelation function (PACF) expresses the 
correlation between periods {it:t} and {it:t}-{it:k} of a time series as a 
function of the time {it:t} and lag {it:k}, after controlling for the effects 
of intervening lags.  For a stationary time series, the PACF 
does not depend on {it:t}.  The PACF is not symmetric about {it:k}=0: 
the partial autocorrelation between {it:y}_{it:t} and {it:y}_[{it:t}-{it:k}]
is not equal to the partial autocorrelation between {it:y}_{it:t} and
{it:y}_[{it:t}+{it:k}].

{phang}
{bf:periodogram}.
A periodogram is a graph of the spectral density function of a time series as
a function of frequency.  The {helpb pergram} command first standardizes the
amplitude of the density by the sample variance of the time series, and then
plots the logarithm of that standardized density.  Peaks in the periodogram
represent cyclical behavior in the data.

{phang}
{bf:phase function}.
The phase function of a {help ts_glossary##linear_filter:linear filter}
specifies how the filter changes the relative importance of the random
components at different frequencies in the frequency domain.

{phang}
{bf:Phillips curve}.
The Phillips curve is a macroeconomic relationship between inflation and
economic activity, usually expressed as an equation involving inflation and
the output gap.  Historically, the Phillips curve describes an inverse
relationship between the unemployment rate and the rate of rises in wages.

{phang}
{bf:portmanteau statistic}.
The portmanteau, or {it:Q}, statistic is used to test for white noise and is
calculated using the first {it:m} autocorrelations of the series, where {it:m}
is chosen by the user.  Under the null hypothesis that the series is a
{help ts_glossary##white_noise:white-noise process}, the portmanteau statistic
has a chi-squared distribution with {it:m} degrees of freedom.

{phang}
{bf:Prais-Winsten estimator}.
A Prais-Winsten estimator is a linear regression estimator that is
used when the error term exhibits first-order autocorrelation; see also 
{it:{help ts_glossary##CO_estimator:Cochrane-Orcutt estimator}}.  Here the
first observation in the dataset is transformed as tilde{{it:y}}_1 =
sqrt{1-rho^2} {it:y}_1 and tilde{{bf:x}}_1 = sqrt{1-rho^2} {bf:x}_1, so that
the first observation is not lost.  The Prais-Winsten estimator is a
generalized least-squares estimator.

{phang}
{bf:priming values}.
Priming values are the initial, preestimation values used to begin a recursive
process.

{phang}
{bf:random walk}.
A random walk is a time-series process in which the current period's
realization is equal to the previous period's realization plus a white-noise
error term: {it:y}_{it:t} = {it:y}_[{it:t}-1] + epsilon_{it:t}.  A random walk
with drift also contains a nonzero time-invariant constant: {it:y}_{it:t} =
delta + {it:y}_[{it:t}-1] + epsilon_{it:t}.  The constant term delta is known
as the drift parameter.  An important property of random-walk processes is
that the best predictor of the value at time {it:t}+1 is the value at time
{it:t} plus the value of the drift parameter.

{phang}
{bf:recursive regression analysis}.
A recursive regression analysis involves performing a regression at time
{it:t} by using all available observations from some starting time {it:t}_0
through time {it:t}, performing another regression at time {it:t}+1 by using all
observations from time {it:t}_0 through time {it:t}+1, and so on.  Unlike a
{help ts_glossary##rolling_reg:rolling regression analysis}, the first period
used for all regressions is held fixed.

{phang}
{bf:regressand}.  The regressand is the variable that is being explained or
predicted in a regression model.  Synonyms include dependent variable,
left-hand-side variable, and
{help ts_glossary##endogenous_variable:endogenous variable}.

{phang}
{bf:regressor}.  Regressors are variables in a regression model used to
predict the regressand.  Synonyms include independent variable,
right-hand-side variable, explanatory variable, predictor variable, and
{help ts_glossary##exogenous_variable:exogenous variable}.

{marker rolling_reg}{...}
{phang}
{bf:rolling regression analysis}.
A rolling, or moving window, regression analysis involves performing
regressions for each period by using the most recent {it:m} periods' data, where
{it:m} is known as the window size.  At time {it:t} the regression is fit
using observations for times {it:t}-19 through time {it:t}; at time {it:t}+1
the regression is fit using the observations for time {it:t}-18 through
{it:t}+1; and so on.

{phang}
{bf:seasonal difference operator}.
The period-{it:s} seasonal difference operator Delta_{it:s} denotes the 
difference in the value of a variable at time {it:t} and time {it:t}-{it:s}.  
Formally, Delta_{it:s} {it:y}_{it:t} = {it:y}_{it:t} - {it:y}_[{it:t}-{it:s}],
and Delta_{it:s}^2 {it:y}_{it:t} = Delta_{it:s}({it:y}_{it:t} -
{it:y}_[{it:t}-{it:s}]) = ({it:y}_{it:t} - {it:y}_[{it:t}-{it:s}]) -
({it:y}_[{it:t}-{it:s}]-{it:y}_[{it:t}-2{it:s}]) = {it:y}_{it:t} -
2{it:y}_[{it:t}-{it:s}] + {it:y}_[{it:t}-2{it:s}].

{phang}
{bf:serial correlation}.
Serial correlation refers to regression errors that are correlated 
over time.  If a regression model does not contained lagged dependent 
variables as regressors, the OLS estimates are 
consistent in the presence of mild serial correlation, but the 
covariance matrix is incorrect.  When the model includes lagged 
dependent variables and the residuals are serially correlated, the 
OLS estimates are biased and inconsistent.  See, for example, 
{help ts glossary##DM1993:Davidson and MacKinnon (1993, chap. 10)}
for more information.

{phang}
{bf:serial correlation tests}.
Because OLS estimates are at least inefficient and potentially 
biased in the presence of serial correlation, econometricians have 
developed many tests to detect it.  Popular ones include the 
Durbin-Watson ({help ts glossary##DW1950:1950},
               {help ts glossary##DW1951:1951},
               {help ts glossary##DW1971:1971}) test, the Breusch-Pagan 
({help ts glossary##BP1980:1980}) test, and Durbin's
({help ts glossary##D1970:1970}) alternative test.  See 
{helpb regress_postestimationts:[R] regress postestimation time series}.

{marker smoothing}{...}
{phang}
{bf:smoothing}.
Smoothing a time series refers to the process of extracting an overall 
{help ts_glossary##trend:trend} in the data.  The motivation behind smoothing
is the belief that a time series exhibits a trend component as well as an
irregular component and that the analyst is interested only in the trend
component.  Some smoothers also account for seasonal or other cyclical
patterns.

{phang}
{bf:spectral analysis}.
See {it:{help ts_glossary##frequency_domain:frequency-domain analysis}}.

{phang}
{marker spectral_density}{...}
{bf:spectral density function}.
The spectral density function is the derivative of the spectral 
distribution function.  Intuitively, the spectral density function 
{it:f}(omega) indicates the amount of variance in a time series that is 
attributable to sinusoidal components with frequency omega.  See also 
{it:{help ts_glossary##spectral_distribution:spectral distribution function}}.
The spectral density function is sometimes called the spectrum.

{phang}
{marker spectral_distribution}{...}
{bf:spectral distribution function}.
The (normalized) spectral distribution function {it:F}(omega) of a process 
describes the proportion of variance that can be explained by 
sinusoids with frequencies in the range (0, omega), where 0 <= 
omega <= pi. The spectral distribution and density functions used 
in {help ts_glossary##frequency_domain:frequency-domain analysis}
are closely related to the autocorrelation function used in time-domain
analysis; see {help ts glossary##C2004:Chatfield (2004, chap. 6)}.

{phang}
{bf:spectrum}.
See {it:{help ts_glossary##spectral_density:spectral density function}}.

{phang}
{bf:state-space model}.
A state-space model describes the relationship between an observed time series
and an unobservable state vector that represents the "state" of the world.
The measurement equation expresses the observed series as a function of the
state vector, and the transition equation describes how the unobserved state
vector evolves over time.  By defining the parameters of the measurement and
transition equations appropriately, one can write a wide variety of time-series
models in the state-space form.

{marker static_forecast}{...}
{phang}
{bf:static forecast}.
A static forecast uses actual values wherever lagged values of the endogenous
variables appear in the model.  As a result, static forecasts perform at least
as well as {help ts_glossary##dynamic_forecast:dynamic forecasts},
but static forecasts cannot produce forecasts
into the future if lags of the endogenous variables appear in the model.

{pmore}
Because actual values will be missing beyond the last historical time period
in the dataset, static forecasts can forecast only one period into the future
(assuming only first lags appear in the model); thus they are
often called one-step-ahead forecasts.

{marker stationary_process}{...}
{phang}
{bf:stationary process}.
A process is stationary if the joint distribution of {it:y}_1, 
..., {it:y}_{it:k} is the same as the joint distribution of {it:y}_{1+tau},
..., {it:y}_[{it:k}+tau] for all {it:k} and tau.  Intuitively, shifting the
origin of the series by tau units has no effect on the joint distributions;
the marginal distribution of the series does not change over time.  A
stationary process is also known as a strictly stationary process or a
strongly stationary process.  See also
{help ts_glossary##cov_stationary_process:{it:covariance stationary process}}.

{phang}
{bf:steady-state equilibrium}.
The steady-state equilibrium is the predicted value of a variable in a dynamic
model, ignoring the effects of past shocks, or, equivalently, the value of a
variable, assuming that the effects of past shocks have fully died out and no
longer affect the variable of interest.

{marker stochastic_cycle}{...}
{phang}
{bf:stochastic cycle}.
A stochastic cycle is a cycle characterized by an amplitude, phase, or
frequency that can be random functions of time. See
{help ts_glossary##cyclical_component:{it:cyclical component}}.

{phang}
{bf:stochastic equation}.
A stochastic equation, in contrast to an identity, is an equation in a
forecast model that includes a random component, most often in the form of
an additive error term.  Stochastic equations include parameters that must
be estimated from historical data.

{phang}
{bf:stochastic trend}.
A stochastic trend is a nonstationary random process.
{help ts_glossary##unit_root_process:Unit-root process} and
random coefficients on time are two common stochastic trends.  See
{helpb ucm:[TS] ucm} for examples and discussions of more commonly applied
stochastic trends.

{phang}
{bf:strictly stationary process}.
See 
{help ts_glossary##stationary_process:{it:stationary process}}.

{phang}
{bf:strongly stationary process}.
See 
{help ts_glossary##stationary_process:{it:stationary process}}.

{phang}
{bf:structural model}.
In time-series analysis, a structural model is one that describes the
relationship among a set of variables, based on underlying theoretical
considerations.  Structural models may contain both endogenous and exogenous
variables.

{phang}
{bf:SVAR}.
A structural vector autoregressive (SVAR) model is a type of  VAR in which
short- or long-run constraints are placed on the resulting
{help ts_glossary##impulse_response:impulse-response functions}.  The
constraints are usually motivated by economic theory and therefore allow
causal interpretations of the IRFs to be made.

{phang}
{bf:time-domain analysis}.
Time-domain analysis is analysis of data viewed as a sequence of observations
observed over time.  The autocorrelation function, linear regression, 
{help ts_glossary##ARCH_model:ARCH models},
and
{help ts_glossary##ARIMA_model:ARIMA models}
are common tools used in time-domain analysis.

{marker trend}{...}
{phang}
{bf:trend}.
The trend specifies the long-run behavior in a time series.  The trend can be
deterministic or stochastic.  Many economic, biological, health, and social
time series have long-run tendencies to increase or decrease.  Before the
1980s, most time-series analysis specified the long-run tendencies as
deterministic functions of time.  Since the 1980s, the stochastic trends 
implied by unit-root processes have become a standard part of the toolkit.

{marker unit_root_process}{...}
{phang}
{bf:unit-root process}.
A unit-root process is one that is integrated of order one, meaning 
that the process is nonstationary but that first-differencing the process 
produces a stationary series.  The simplest example of a unit-root 
process is the random walk.  See 
{help ts glossary##H1994:Hamilton (1994, chap. 15)} for a 
discussion of when general {help ts_glossary##ARMA_process:ARMA processes}
may contain a unit root.

{phang}
{bf:unit-root tests}.
Whether a process has a unit root has both important statistical and 
economic ramifications, so a variety of tests have been developed to 
test for them.  Among the earliest tests proposed is the one by 
{help ts glossary##DF1979:Dickey and Fuller (1979)},
though most researchers now use an improved variant 
called the augmented Dickey-Fuller test instead of the original version.
Other common unit-root tests implemented in Stata include the DF-GLS test of
{help ts glossary##ERS1996:Elliott, Rothenberg, and Stock (1996)} and the
{help ts glossary##PP1988:Phillips-Perron (1988)} test.  See
{helpb dfuller:[TS] dfuller}, {helpb dfgls:[TS] dfgls}, and
{helpb pperron:[TS] pperron}.

{marker VAR}{...}
{phang}
{bf:VAR}.
A vector autoregressive (VAR) model is a multivariate regression 
technique in which each dependent variable is regressed on lags of 
itself and on lags of all the other dependent variables in the model.  
Occasionally, exogenous variables are also included in the model. 

{marker VECM}{...}
{phang}
{bf:VECM}.
A vector error-correction model (VECM) is a type of VAR 
that is used with variables that are cointegrated.  Although 
first-differencing variables that are integrated of order one makes 
them stationary, fitting a VAR to such first-differenced 
variables results in misspecification error if the variables are 
cointegrated.  See
{mansection TS vecintroRemarksandexamplesThemultivariateVECMspecification:{it:The multivariate VECM specification}}
in {bf:[TS] vec intro} for more on this point.

{phang}
{bf:weak stationary process}.
See 
{help ts_glossary##cov_stationary_process:{it:covariance stationary process}}.

{marker white_noise}{...}
{phang}
{bf:white-noise process}.
A variable {it:u}_{it:t} represents a white-noise process if the mean of
{it:u}_{it:t} is zero, the variance of {it:u}_{it:t} is sigma^2, and the
covariance between {it:u}_{it:t} and {it:u}_{it:s} is zero for all
{it:s} != {it:t}.

{phang}
{bf:Yule-Walker equations}.
The Yule-Walker equations are a set of difference equations that
describe the relationship among the autocovariances and autocorrelations of an
{help ts_glossary##ARMA_process:autoregressive moving-average (ARMA) process}.


{marker references}{...}
{title:References}

{marker BP1980}{...}
{phang}
Breusch, T. S., and A. R. Pagan. 1980. The Lagrange multiplier test and its 
applications to model specification in econometrics.
{it:Review of Economic Studies} 47: 239-253.

{marker C2004}{...}
{phang}
Chatfield, C. 2004.
{it:The Analysis of Time Series: An Introduction}. 6th ed.
Boca Raton, FL: Chapman & Hall/CRC.

{marker DM1993}{...}
{phang}
Davidson, R., and J. G. MacKinnon. 1993.
{browse "http://www.stata.com/bookstore/eie.html":{it:Estimation and Inference in Econometrics}.}
New York: Oxford University Press.

{marker DF1979}{...}
{phang}
Dickey, D. A., and W. A. Fuller. 1979.
Distribution of the estimators for autoregressive time series with a
unit root.
{it:Journal of the American Statistical Association} 74: 427-431.

{marker D1970}{...}
{phang}
Durbin, J. 1970.
Testing for serial correlation in least-squares regressions when some of the
regressors are lagged dependent variables.
{it:Econometrica} 38: 410-421.

{marker DW1950}{...}
{phang}
Durbin, J., and G. S. Watson. 1950.
Testing for serial correlation in least squares regression I.
{it:Biometrika} 37: 409-428.

{marker DW1951}{...}
{phang}
------. 1951.
Testing for serial correlation in least squares regression II.
{it:Biometrika} 38: 159-177.

{marker DW1971}{...}
{phang}
------. 1971.
Testing for serial correlation in least squares regression III.
{it:Biometrika} 58: 1-19.

{marker ERS1996}{...}
{phang}
Elliott, G., T. J. Rothenberg, and J. H. Stock. 1996.
Efficient tests for an autoregressive unit root.
{it:Econometrica} 64: 813-836. 

{marker H1994}{...}
{phang}
Hamilton, J. D. 1994.
{it:Time Series Analysis}.
Princeton: Princeton University Press.

{marker PP1988}{...}
{phang}
Phillips, P. C. B., and P. Perron. 1988. Testing for a unit root in 
time series regression. {it:Biometrika} 75: 335-346.
{p_end}
