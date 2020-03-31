{smcl}
{* *! version 1.0.5  25feb2019}{...}
{vieweralsosee "[DSGE] Glossary" "mansection DSGE Glossary"}{...}
{viewerjumpto "Description" "dsge_glossary##description"}{...}
{viewerjumpto "Glossary" "dsge_glossary##glossary"}{...}
{viewerjumpto "Reference" "dsge_glossary##reference"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[DSGE] Glossary} {hline 2}}Glossary of terms{p_end}
{p2col:}({mansection DSGE Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}Commonly used terms are defined here.


{marker glossary}{...}
{title:Glossary}

{phang}
{bf:autoregressive process}.
An autoregressive process is a time series in which the current value of
a variable is a linear function of its own past values and a white-noise error
term.  A first-order autoregressive process, denoted as an AR(1) process, is
y_t = rho y_{t-1} + epsilon_t.  An AR(p) model contains p lagged values of the
dependent variable.

{marker conditional_mean}{...}
{phang}
{bf:conditional mean}.
A conditional mean expresses the mean of one variable as a function of some
other variables.  A regression function is a conditional mean.

{marker control_variable}{...}
{phang}
{bf:control variable}.
A control variable is an
{help dsge_glossary##endogenous_variable:endogenous variable}.
Control variables can be observed or unobserved.

{pmore}
In a {help dsge_glossary##structural_model:structural} DSGE model, 
the current value of a control variable depends on the current value of other
control variables, on the expected future values of any control variable, and
on the current values of state variables.  The current value of a control
variable is found by solving the model for the 
{help dsge_glossary##state_space:state-space form}.

{marker covariance_stationary}{...}
{phang}
{bf:covariance stationary}.
A covariance stationary process is a 
{help dsge_glossary##weakly_stationary:weakly stationary} process.

{marker dynamic_forecast}{...}
{phang}
{bf:dynamic forecast}.
A dynamic forecast uses forecasted values wherever lagged values of the
endogenous variables appear in the model, allowing one to forecast multiple
periods into the future.

{phang}
{bf:dynamic stochastic general equilibrium model}.
A dynamic stochastic general equilibrium model is a multivariate
time-series model that specifies the structural relationship
between
{help dsge_glossary##state_variable:state variables}
and 
{help dsge_glossary##control_variable:control variables}
and is typically derived from economic theory.

{marker endogenous_variable}{...}
{phang}
{bf:endogenous variable}.
An endogenous variable is a variable whose values are determined by the
equilibrium of a
{help dsge_glossary##structural_model:structural model}.
The values of an endogenous variable are determined inside the system.

{phang}
{bf:equilibrium}.
The equilibrium values of variables in a model are the values that
satisfy all the model's equations simultaneously.

{marker exogenous_variable}{...}
{phang}
{bf:exogenous variable}.
An exogenous variable is one whose values change independently of the other
variables in a 
{help dsge_glossary##structural_model:structural model}.
The values of an exogenous variable are determined outside the system.
In a time-series model, an exogenous variable is also a 
{help dsge_glossary##predetermined:predetermined variable}.

{phang}
{bf:expected future value}.
An expected future value is a forecast of the value of a variable in the
future based on current information.  In DSGE models, expected future
values are computed under 
{help dsge_glossary##rational_expectations:rational expectations}.

{pmore}
Under rational expectations, E_t(y_{t+1}) is the condition mean of
y_{t+1} conditional on the complete history of all variables in the model
and the structure of the model itself.

{marker forward_operator}{...}
{phang}
{bf:forward operator}.
The forward operator F denotes the value of a variable at time t + 1.
Formally, Fy_t = y_{t+1}, and F^2y_t = Fy_{t+1} = y_{t+2}.
A forward operator is also called a lead operator.

{phang}
{bf:identified}.
Identified is a condition required to estimate the parameters of a model.  In
other words, only identified parameters can be estimated.

{pmore}
In DSGE models, the parameters are identified when there is a unique
parameter vector that maximizes the likelihood function.  For a discussion of
identification, see {manlink DSGE Intro 6}.

{phang}
{bf:impulse-response function}.
An impulse-response function (IRF) measures the effect of a
shock to an endogenous variable on itself or another endogenous
variable.  The kth impulse-response function of variable i on
variable j measures the effect on variable j in period t + k in
response to a one-unit shock to variable i in period t, holding
everything else constant.

{phang}
{bf:independent and identically distributed}.
A series of observations is independent and identically distributed
(i.i.d.) if each observation is an independent realization from the same
underlying distribution.  In some contexts, the definition is relaxed to
mean only that the observations are independent and have identical means
and variances; see {help dsge_glossary##DM1993:Davidson and MacKinnon (1993)}.

{phang}
{bf:initial values}.
Initial values specify the starting place for the iterative maximization
algorithm used by DSGE.

{phang}
{bf:Kalman filter}.  The Kalman filter is a recursive procedure for predicting
the state vector in a state-space model.

{phang}
{bf:lag operator}.
The lag operator L denotes the value of a variable at time t - 1.
Formally, Ly_t = y_{t-1}, and L^2y_t = Ly_{t-1} = y_{t-2}.

{phang}
{bf:lead operator}.  See
{it:{help dsge_glossary##forward_operator:forward operator}}.

{phang}
{bf:likelihood-ratio (LR) test}.
The LR test is a classical testing procedure used to compare the fit of two
models, one of which, the constrained model, is nested within the full
(unconstrained) model.  Under the null hypothesis, the constrained model fits
the data as well as the full model.  The LR test requires one to determine the
maximal value of the log-likelihood function for both the constrained and the
full models.

{phang}
{bf:linearized model}.
A linearized model is an approximation to a model that is nonlinear in the
variables and nonlinear in the parameters.  The approximation is linear in
variables but potentially nonlinear in the parameters.  In a linearized model,
variables are interpreted as unit deviations from steady state.

{phang}
{bf:log-linear model}
A log-linear model is an approximation to a model that is nonlinear in the
variables and nonlinear in the parameters.  In a log-linear model,
variables are interpreted as percentage deviations from steady state.

{phang}
{bf:model solution}.
A model solution is a function for the 
{help dsge_glossary##endogenous_variable:endogenous variables}
in terms of the 
{help dsge_glossary##exogenous_variable:exogenous variables}.
A model solution is also known as the 
{help dsge_glossary##reduced_form:reduced form}
of a model.

{pmore}
In DSGE terminology, a model solution expresses the 
{help dsge_glossary##control_variable:control variables}
as a function of the 
{help dsge_glossary##state_variable:state variables}
alone and expresses the state variables as a function of their values in the
previous period and shocks.  The reduced form of a DSGE model is also known as
the {help dsge_glossary##state_space:state-space form} of the DSGE model.

{marker model_consistent}{...}
{phang} 
{bf:model-consistent expectation}.
A model-consistent expectation is the 
{help dsge_glossary##conditional_mean:conditional mean}
of a variable implied by the model under consideration.

{pmore}
For example, under 
{help dsge_glossary##rational_expectations:rational expectations}
the model-consistent expectation of E_t(y_{t+1}) is the mean of y_{t+1}
implied by the model, conditional on the realizations of variables dated
time t or previously.

{phang}
{bf:nonpredetermined variable}.
A nonpredetermined variable is a variable whose value at time t is
determined by the system of equations in the model.  Contrast with 
{help dsge_glossary##predetermined:predetermined variable}.

{phang} 
{bf:null hypothesis}.
In hypothesis testing, the null hypothesis typically represents the conjecture
that one is attempting to disprove.  Often the null hypothesis is that a
parameter is zero or that a statistic is equal across populations.

{phang}
{bf:one-step-ahead forecast}.  See
{help dsge_glossary##static_forecast:{it:static forecast}}.

{phang}
{bf:policy matrix}.
The policy matrix in the 
{help dsge_glossary##reduced_form:reduced form}
of a DSGE model is the matrix that expresses 
{help dsge_glossary##control_variable:control variables}
as a function of 
{help dsge_glossary##state_variable:state variables}.

{marker predetermined}{...}
{phang}
{bf:predetermined variable}.
A predetermined variable is a variable whose value is fixed at time t,
given everything that has occurred previously.  More technically, the
value of a predetermined variable is fixed, given the 
{help dsge_glossary##realization:realizations}
of all observed and unobserved variables at times t - 1, t - 2, ....

{marker rational_expectations}{...}
{phang}
{bf:rational expectations}.
A rational expectation of a variable does not deviate from the mean of that
variable in a predictable way.  More technically, a rational expectation of a
variable is the {help dsge_glossary##conditional_mean:conditional mean} of the
variable implied by the model.

{marker realization}{...}
{phang}
{bf:realization}.
The realization of a random variable is the value it takes on when drawn.

{marker reduced_form}{...}
{phang}
{bf:reduced form}.
The reduced form of a model expresses the endogenous variables as functions
of the exogenous variables.

{pmore}
The reduced form of a DSGE model expresses the 
{help dsge_glossary##control_variable:control variables}
as a function of the 
{help dsge_glossary##state_variable:state variables}
alone and expresses the state variables as a function of their values in the
previous period and shocks.  The reduced form of a DSGE model is a 
{help dsge_glossary##state_space:state-space model}.

{phang}
{bf:saddle-path stable}.
A saddle-path stable model is a
{help dsge_glossary##structural_model:structural model}
that can be solved for its state-space form.  The existence of a saddle-path
stable solution depends on the parameter values of the model.  For a
discussion of saddle-path stability, see {manlink DSGE Intro 5}.

{phang}
{bf:shock variable}.
A shock variable is a random variable whose value is specified as an
independently and identically distributed (i.i.d.) random variable.
The maximum likelihood estimator is derived under normally distributed
shocks but remains consistent under i.i.d. shocks.  Robust standard errors
must be specified when the errors are i.i.d. but not normally distributed.

{phang}
{bf:state transition matrix}.
The state transition matrix in the 
{help dsge_glossary##reduced_form:reduced form}
of a DSGE model is the matrix that expresses how the future values of 
{help dsge_glossary##state_variable:state variables}
depend on their current values.

{marker state_variable}{...}
{phang}
{bf:state variable}.
A state variable is an unobserved exogenous variable.

{pmore}
In DSGE models, a state variable is an unobserved exogenous variable that may
depend on its own previous value, the previous values of other state
variables, and shocks.

{marker state_space}{...}
{phang}
{bf:state-space model}.
A state-space model describes the relationship between an observed time series
and an unobservable state vector that represents the "state" of the world.
The measurement equation expresses the observed series as a function of the
state vector, and the transition equation describes how the unobserved state
vector evolves over time.  By defining the parameters of the measurement and
transition equations appropriately, one can write a wide variety of
time-series models in the state-space form.

{pmore}
For DSGE models, the state-space form is the
{help dsge_glossary##reduced_form:reduced form} of the
{help dsge_glossary##structural_model:structural model}.

{pmore}
The DSGE framework changes the jargon and the structure of
state-space models.
The measurement equation is the vector of equations for the 
{help dsge_glossary##control_variable:control variables},
and the transition equation is the vector of equations for the 
{help dsge_glossary##state_variable:state variables}.
In contrast to the standard state-space model, DSGE
models allow a control variable to be unobserved.

{marker static_forecast}{...}
{phang}
{bf:static forecast}.
A static forecast uses actual values wherever lagged values of the
endogenous variables appear in the model.  As a result, static
forecasts perform at least as well as
{help dsge_glossary##dynamic_forecast:dynamic forecasts},
but static forecasts cannot produce forecasts into the future when lags of
the endogenous variables appear in the model.

{pmore}
Because actual values will be missing beyond the last historical time
period in the dataset, static forecasts can forecast only one period
into the future (assuming only first lags appear in the model); thus
they are often called one-step-ahead forecasts.

{phang}
{bf:steady-state equilibrium}.
A steady-state equilibrium is a time-invariant rest point of a dynamic system.

{pmore}
More technically, a steady-state equilibrium is a set of values for the
endogenous variables to which the dynamic system will return after an
exogenous variable is changed or a random shock occurs.  This set of values
is time invariant in that it does not depend on the time period in which the
change or shock occurs.  Multistep
{help dsge_glossary##dynamic_forecast:dynamic forecasts} converge to these
values.  A steady-state equilibrium is also known as a long-run equilibrium
because it specifies time-invariant values for the endogenous variables to
which the dynamic system will return, if left unshocked.

{phang}
{bf:stochastic equation}.
A stochastic equation, in contrast to an identity, is an equation in a
forecast model that includes a random component, most often in the form of
an additive error term.  Stochastic equations include parameters that must
be estimated from historical data.

{phang}
{bf:stochastic trend}.
A stochastic trend is a nonstationary random process.  Unit-root
process and random coefficients on time are two common stochastic
trends.  See {manhelp ucm TS} for examples and discussions of more commonly
applied stochastic trends.

{phang}
{bf:strict stationarity}.
A process is strictly stationary if the joint distribution of y_{1}, 
..., y_{k} is the same as the joint distribution of y_{1+tau}, ..., 
y_{k+tau} for all k and tau.  Intuitively, shifting the origin of
the series by tau units has no effect on the joint distributions.

{marker structural_model}{...}
{phang}
{bf:structural model}.
A structural model specifies the theoretical relationship among a set of
variables.  Structural models contain both 
{help dsge_glossary##endogenous_variable:endogenous variables}
and 
{help dsge_glossary##exogenous_variable:exogenous variables}.
Parameter estimation and interpretation require that
structural models be solved for a 
{help dsge_glossary##reduced_form:reduced form}.

{phang}
{bf:trend}.
The trend specifies the long-run behavior in a time series.  The trend
can be deterministic or stochastic.  Many economic, biological,
health, and social time series have long-run tendencies to increase or
decrease.  Before the 1980s, most time-series analysis specified the
long-run tendencies as deterministic functions of time.  Since the
1980s, the stochastic trends implied by unit-root processes have
become a standard part of the toolkit.

{phang} 
{bf:Wald test}.
A Wald test is a classical testing procedure used to compare the fit
of two models, one of which, the constrained model, is nested within
the full (unconstrained) model.  Under the null hypothesis, the
constrained model fits the data as well as the full model.  The Wald
test requires one to fit the full model but does not require one to
fit the constrained model.

{marker weakly_stationary}{...}
{phang}
{bf:weakly stationary}.
A process is weakly stationary if the mean of the process is finite and
independent of t, the unconditional variance of the process is finite and
independent of t, and the covariance between periods t and t - s is finite and
depends on t - s but not on t or s themselves.  Weakly-stationary
processes are also known as covariance stationary processes.

{phang}
{bf:white noise}.
A variable u_t represents a white-noise process if the mean of u_t
is zero, the variance of u_t is sigma^2, and the covariance between
u_t and u_s is zero for all s != t.


{marker reference}{...}
{title:Reference}

{marker DM1993}{...}
{phang}
Davidson, R., and J. G. MacKinnon. 1993.
{browse "http://www.stata.com/bookstore/eie.html":{it:Estimation and Inference in Econometrics}}.
New York: Oxford University Press.
{p_end}
