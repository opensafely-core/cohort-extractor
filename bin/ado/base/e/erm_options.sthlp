{smcl}
{* *! version 1.0.7  14may2019}{...}
{vieweralsosee "[ERM] ERM options" "mansection ERM ERMoptions"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] eintreg" "help eintreg"}{...}
{vieweralsosee "[ERM] eoprobit" "help eoprobit"}{...}
{vieweralsosee "[ERM] eprobit" "help eprobit"}{...}
{vieweralsosee "[ERM] eregress" "help eregress"}{...}
{viewerjumpto "Syntax" "erm options##syntax"}{...}
{viewerjumpto "Description" "erm options##description"}{...}
{viewerjumpto "Options" "erm options##options"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[ERM] ERM options} {hline 2}}Extended regression model options{p_end}
{p2col:}({mansection ERM ERMoptions:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{it:erm_cmd} ... [{cmd:,} {it:extensions}
{help erm_options##synoptions:{it:options}}]

{pstd}
{it:erm_cmd} is one of 
{helpb eregress},
{helpb eprobit},
{helpb eoprobit},
{helpb eintreg},
{helpb xteregress},
{helpb xteprobit},
{helpb xteoprobit}, or
{helpb xteintreg}.

{marker extensions}{...}
{synoptset 25 tabbed}{...}
{synopthdr:extensions}
{synoptline}
{syntab:Model}
{synopt :{opth endog:enous(erm_options##enspec:enspec)}}model for endogenous covariates; may be repeated{p_end}
{synopt :{opth entr:eat(erm_options##entrspec:entrspec)}}model for endogenous treatment assignment{p_end}
{synopt :{opth extr:eat(erm_options##extrspec:extrspec)}}exogenous treatment{p_end}
{synopt :{opth sel:ect(erm_options##selspec:selspec)}}probit model for selection{p_end}
{synopt :{opth tobitsel:ect(erm_options##tselspec:tselspec)}}tobit model for selection{p_end}
{synoptline}

{marker synoptions}{...}
{synopthdr}
{synoptline}
{syntab:Model}
INCLUDE help erm_model_tab

{syntab:SE/Robust}
INCLUDE help erm_vce_tab

{syntab:Reporting}
INCLUDE help erm_report_tab
{synopt :{it:{help erm_options##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Integration}
INCLUDE help erm_integration_tab

{syntab:Maximization}
{synopt :{help erm_options##maximize_options:{it:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt :{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt reintpoints()} and {opt reintmethod()} are available only with
{opt xteregress}, {opt xteintreg}, {opt xteprobit}, and
{opt xteoprobit}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.


{marker enspec}{...}
{phang}
{it:enspec} is {depvars}_en {cmd:=} {varlist}_en
    [{cmd:,} {help erm_options##enopts:{it:enopts}}]

{pmore}
where {it:depvars}_en is a list of endogenous covariates.  Each variable in
{it:depvars}_en specifies an endogenous covariate model using the
common {it:varlist}_en and options.

{marker entrspec}{...}
{phang}
{it:entrspec} is {depvar}_tr [{cmd:=} {varlist}_tr]
    [{cmd:,} {help erm_options##entropts:{it:entropts}}]

{pmore}
where {it:depvar}_tr is a variable indicating treatment assignment.
{it:varlist}_tr is a list of covariates predicting treatment assignment.

{marker extrspec}{...}
{phang}
{it:extrspec} is {it:tvar}
    [{cmd:,} {help erm_options##extropts:{it:extropts}}]

{pmore}
where {it:tvar} is a variable indicating treatment assignment.

{marker selspec}{...}
{phang}
{it:selspec} is {depvar}_s {cmd:=} {varlist}_s
    [{cmd:,} {help erm_options##selopts:{it:selopts}}]

{pmore}
where {it:depvar}_s is a variable indicating selection status.
{it:depvar}_s must be coded as 0, indicating that the
observation was not selected, or 1, indicating that the observation was
selected.  {it:varlist}_s is a list of covariates predicting selection.

{marker tselspec}{...}
{phang}
{it:tselspec} is {depvar}_s {cmd:=} {varlist}_s
    [{cmd:,} {help erm_options##tselopts:{it:tselopts}}]

{pmore}
where {it:depvar}_s is a continuous variable.
{it:varlist}_s is a list of covariates predicting {it:depvar}_s.
The censoring status of {it:depvar}_s indicates selection, where a censored
{it:depvar}_s indicates that the observation was not selected and a
noncensored {it:depvar}_s indicates that the observation was selected.

{synoptset 26 tabbed}{...}
INCLUDE help erm_reg_enopts_table
{p 4 6 2}
{opt povariance} is available only with {cmd:eregress}, {cmd:eintreg},
{cmd:xteregress}, and {cmd:xteintreg}.
{p_end}
{p 4 6 2}
{opt nore} is available only with {cmd:xteregress}, {cmd:xteintreg},
{cmd:xteprobit}, and {cmd:xteoprobit}.

{marker entropts}{...}
{synopthdr:entropts}
{synoptline}
{syntab :Model}
{synopt :{opt povar:iance}}estimate a different variance for each potential outcome{p_end}
{synopt :{opt pocorr:elation}}estimate different correlations for each potential outcome{p_end}
{synopt :{opt nom:ain}}do not add treatment indicator to main equation{p_end}
{synopt :{opt nocutsint:eract}}do not interact treatment with cutpoints{p_end}
{synopt :{opt noint:eract}}do not interact treatment with covariates in main equation{p_end}
{synopt :{opt nore}}do not include random effects in model for endogenous treatment{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with coefficient constrained to 1{p_end}
{synoptline}
{p 4 6 2}
{opt povariance} is available only with {cmd:eregress},
{cmd:eintreg}, {cmd:xteregress}, and {cmd:xteintreg}.{p_end}
{p 4 6 2}
{opt nocutsinteract} is available only with {cmd:eoprobit}.{p_end}
{p 4 6 2}
{opt nore} is available only with {cmd:xteregress}, {cmd:xteintreg},
{cmd:xteprobit}, and {cmd:xteoprobit}.

{marker extropts}{...}
{synopthdr:extropts}
{synoptline}
{syntab :Model}
{synopt :{opt povar:iance}}estimate a different variance for each potential outcome{p_end}
{synopt :{opt pocorr:elation}}estimate different correlations for each potential outcome{p_end}
{synopt :{opt nom:ain}}do not add treatment indicator to main equation{p_end}
{synopt :{opt nocutsint:eract}}do not interact treatment with cutpoints{p_end}
{synopt :{opt noint:eract}}do not interact treatment with covariates in main equation{p_end}
{synoptline}
{p 4 6 2}
{opt povariance} is available only with {cmd:eregress},
{cmd:eintreg}, {cmd:xteregress}, and {cmd:xteintreg}.{p_end}
{p 4 6 2}
{opt nocutsinteract} is available only with {cmd:eoprobit}.

INCLUDE help erm_selopts_table
{p2colreset}{...}
{p 4 6 2}
{opt nore} is available only with {cmd:xteregress}, {cmd:xteintreg},
{cmd:xteprobit}, and {cmd:xteoprobit}.

INCLUDE help erm_tselopts_table
{p2colreset}{...}
{p 4 6 2}
{opt nore} is available only with {cmd:xteregress}, {cmd:xteintreg},
{cmd:xteprobit}, and {cmd:xteoprobit}.


{marker description}{...}
{title:Description}

{pstd}
This entry describes the options that are common to the extended regression
commands; see {manhelp eregress ERM}, {manhelp eprobit ERM},
{manhelp eoprobit ERM}, and {manhelp eintreg ERM}.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:endogenous(}{depvars}_en {cmd:=} {varlist}_en [{cmd:,} {it:enopts}]{cmd:)}
specifies the model for endogenous covariates.  {it:depvars}_en is a list of
one or more endogenous covariates modeled with {it:varlist}_en.  This
option may be repeated to allow a different model specification for each
endogenous covariate.  By default, the endogenous covariates are assumed to be
continuous, and a linear Gaussian model is used.  Unless the {cmd:nomain}
suboption is specified, the variables specified in {it:depvars}_en are
automatically included in the main equation.  The following {it:enopts} 
are available:

{phang2}
{cmd:probit} specifies to use a probit model for the endogenous
covariates.
{cmd:probit} may not be specified with {cmd:oprobit}; however,
you may specify {cmd:endogenous(}...{cmd:, probit)} and
{cmd:endogenous(}...{cmd:, oprobit)}.

{phang2}
{cmd:oprobit}
specifies to use an ordered probit model
for the endogenous covariates.
{cmd:oprobit} may not be specified with {cmd:probit}; however,
you may specify 
{cmd:endogenous(}...{cmd:, probit)} and {cmd:endogenous(}...{cmd:, oprobit)}.

{phang2}
{cmd:povariance}
specifies that different variance parameters be estimated for each level of
the endogenous covariates.  In a treatment-effects framework, we refer to
levels of endogenous covariates as potential outcomes, and {cmd:povariance}
specifies that the variance be estimated separately for each potential
outcome.  {cmd:povariance} may be specified only with {cmd:eregress} and
{cmd:eintreg} and with a binary or an ordinal endogenous covariate.

{phang2}
{cmd:pocorrelation} specifies that different correlation parameters be
estimated for each level of the endogenous covariates. In a treatment-effects
framework, we refer to levels of endogenous covariates as potential outcomes,
and {cmd:pocorrelation} specifies that correlations be estimated separately
for each potential outcome.  {cmd:pocorrelation} may be specified only with a
binary or an ordinal endogenous covariate.

{phang2}
{cmd:nomain}
specifies that the endogenous covariate of covariates be excluded from 
the main model, thus removing the effect.  This option is 
for those who intend to manually construct the effect by
adding it to the main model in their own way.

{phang2}
{cmd:nore}
specifies that random effects not be included in the equations for the 
endogenous covariates. 

{phang2}
{cmd:noconstant}
suppresses the constant term (intercept) in the model for the endogenous
covariates.

{phang}
{opt entreat()} and {opt extreat()} specify a model for treatment assignment.
You may specify only one.

{phang2}
{cmd:entreat(}{depvar}_tr [{cmd:=} {varlist}_tr]
[{cmd:,} {it:trtopts modopts}]{cmd:)}
specifies a model for endogenous treatment assignment with 
{it:depvar}_tr = 1 indicating treatment and {it:depvar}_tr = 0 
indicating no treatment.  {it:varlist}_tr are the covariates for the 
treatment model; they are optional.

{phang2}
{cmd:extreat(}{depvar}_tr [{cmd:,} {it:trtopts}]{cmd:)} 
specifies a variable that signals exogenous treatment.
{it:depvar}_tr = 1 indicates treatment and {it:depvar}_tr = 0 
indicates no treatment.

{phang2}
{it:trtopts} are

{phang3}
{cmd:povariance}
specifies that different variance parameters be estimated for each potential
outcome (for each treatment level).  {cmd:povariance} may be specified only
with {cmd:eregress} and {cmd:eintreg}.

{phang3}
{cmd:pocorrelation} specifies that different correlation parameters be
estimated for each potential outcome (for each treatment level).

{phang3}
{opt nomain}, {opt nocutsinteract}, and {opt nointeract}
affect the way the treatment enters the 
main equation.

{p 16 20 2}
{opt nomain} specifies that the main effect of treatment be excluded from
the main equation.  Thus, a separate intercept is not estimated for each 
treatment level.  In the case of {opt eoprobit}, this means separate
cutpoints are not added.

{p 16 20 2}
{opt nocutsinteract} specifies that instead of the default of having 
separate cutpoints for each treatment level, you get one set of 
cutpoints that are shifted by a constant value for each treatment level.
This is implemented by placing a separate constant in the main equation 
for each treatment level.  {opt nocutsinteract} is available
only with {opt eoprobit}.

{p 16 20 2}
{opt nointeract} specifies that the treatment variable not be interacted
with the other covariates in the main equation.

{pmore2}
These options allow you to customize how the treatment enters the main
equation.  When {opt nomain} and {opt nointeract} are specified together, 
they remove the effect entirely,
and you will need to explicitly reintroduce the treatment effect.

{phang2}
{it:modopts} are

{phang3}
{opt nore}
specifies that a random effect not be included in the treatment equation. 

{phang3}
{opt noconstant}
suppresses the constant term (intercept) in the treatment model.

{phang3}
{cmdab:offset(}{varname}_o{cmd:)}
specifies that {it:varname}_o be included in the treatment
model with the coefficient constrained to 1.

{phang}
{opt select()} and {opt tobitselect()} specify a model for endogenous sample
selection.  You may specify only one.

{phang2}
{cmd:select(}{depvar}_s {cmd:=} {varlist}_s [{cmd:,} {it:modopts}]{cmd:)}
specifies a probit model for sample selection with {it:varlist}_s as the 
covariates for the selection model.  When {it:depvar}_s = 1, the model's 
dependent variable is treated as observed (selected); when
{it:depvar}_s = 0, 
it is treated as unobserved (not selected).

{phang2}
{cmd:tobitselect(}{depvar}_s {cmd:=} {varlist}_s
[{cmd:,} {cmd:ll(}{varname}{c |}{it:#}{cmd:)} 
{cmd:ul(}{varname}{c |}{it:#}{cmd:)} {opt main} {it:modopts}]{cmd:)}
specifies a tobit model for sample selection with {it:depvar}_s as
a censored selection variable and {it:varlist}_s as the covariates for the
selection model.

{phang3}
{cmd:ll(}{it:arg}{cmd:)} specifies that when {it:depvar}_s {ul:<} {it:arg},
the selection variable is treated as censored and the model's dependent
variable is unobserved (not selected).

{phang3}
{opt ul(arg)} specifies that when {it:depvar}_s {ul:>} {it:arg}, the 
selection variable is treated as censored and the model's dependent variable 
is unobserved (not selected).

{phang3}
{opt main} specifies that the censored selection variable be
included as a covariate in the main equation.  By default, it is
excluded from the main equation.

{pmore3}
Only the uncensored values of the selection variable contribute to
the likelihood through the main equation.  Thus, the selection
variable participates as though it were uncensored.

{pmore}
{it:modopts} are

{phang3}
{opt nore}
specifies that a random effect not be included in the selection equation. 

{phang3}
{opt noconstant} suppresses the constant term (intercept) in the selection
model.

{phang3}
{cmdab:offset(}{varname}_o{cmd:)}
specifies that {it:varname}_o be included in the selection 
model with the coefficient constrained to 1.

{phang}
{opt noconstant}, {cmdab:offset(}{varname}_o{cmd:)},
{opth constraints:(numlist)}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}, {opt nocnsreport}; see
{helpb estimation options:[R] Estimation options}.

INCLUDE help displayopts_list

{dlgtab:Integration}

{phang} 
{opt intpoints(#)} and {opt triintpoints(#)} control the number of
integration (quadrature) points used to approximate multivariate normal
probabilities in the likelihood and scores.

{phang2}
{opt intpoints()} sets the number of integration (quadrature) points for
integration over four or more dimensions.  The number of integration points
must be between 3 and 5,000.  The default is {cmd:intpoints(128)}.

{phang2}
{opt triintpoints()} sets the number of integration (quadrature) points
for integration over three dimensions.  The number of 
integration points must be between 3 and 5,000.
The default is {cmd:triintpoints(10)}.

{pmore}
When four dimensions of
integration are used in the likelihood, three will be used in the scores.  The
algorithm for integration over four or more dimensions differs from the
algorithm for integration over three dimensions.
 
{phang}
{opt reintpoints(#)} and {opt reintmethod(intmethod)} control how the
integration of random effects is numerically calculated.

{phang2}
{opt reintpoints()} sets the number of integration (quadrature) points used
for integration of the random effects.  The default is {cmd:intpoints(7)}.
Increasing the number increases accuracy but also increases computational
time.  Computational time is roughly proportional to the number specified.
See {mansection ERM eprobitMethodsandformulaslikelihood:{it:Likelihood for multiequation models}}
in {bf:[ERM] eprobit} for more details.

{phang2}
{opt reintmethod()} specifies the integration method.  The default method is
mean-variance adaptive Gauss-Hermite quadrature,
{cmd:reintmethod(mvaghermite)}.  We recommend this method.
{cmd:reintmethod(ghermite)} specifies that nonadaptive Gauss-Hermite
quadrature be used.  This method is less computationally intensive and less
accurate. It is sometimes useful to try {cmd:reintmethod(ghermite)} to get the
model to converge and then perhaps use the results as initial values specified
in option {cmd:from} when fitting the model using the more accurate
{cmd:intmethod(mvaghermite)}.  See
{mansection ERM eprobitMethodsandformulaslikelihood:{it:Likelihood for multiequation models}}
in {bf:[ERM] eprobit} for more details.

{marker maximize_options}{...}
{dlgtab:Maximization}

INCLUDE help erm_max_optdes

{pmore}
The default technique for {cmd:eintreg}, {cmd:eoprobit}, {cmd:eprobit}, and
{cmd:eregress} is {cmd:technique(nr)}.  The default technique for
{cmd:xteintreg}, {cmd:xteoprobit}, {cmd:xteprobit}, and {cmd:xteregress} is
{cmd:technique(bhhh 10 nr 2)}.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following option is available with {it:erm_cmd} but is not shown in
the dialog box:

{phang}
{cmd:collinear}, {cmd:coeflegend}; see
{helpb estimation_options:[R] Estimation options}.
{p_end}
