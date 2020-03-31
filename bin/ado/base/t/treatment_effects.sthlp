{smcl}
{* *! version 1.0.13  02apr2019}{...}
{vieweralsosee "[TE] Treatment effects" "mansection TE Treatmenteffects"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects intro" "help teffects intro"}{...}
{vieweralsosee "[TE] teffects multivalued" "help teffects multivalued"}{...}
{vieweralsosee "[TE] stteffects intro" "help stteffects intro"}{...}
{vieweralsosee "[TE] Glossary" "help te_glossary"}{...}
{viewerjumpto "Description" "treatment effects##description"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[TE] Treatment effects} {hline 2}}Introduction to
treatment-effects commands{p_end}
{p2col:}({mansection TE Treatmenteffects:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This manual documents commands that use observational data to estimate the
effect caused by getting one treatment instead of another.  In observational
data, treatment assignment is not controlled by those who collect the data;
thus some common variables affect treatment assignment and treatment-specific
outcomes.  Observational data is sometimes called retrospective data or
nonexperimental data, but to avoid  confusion, we will always use the term
"observational data".

{pstd}
When all the variables that affect both treatment assignment and outcomes
are observable, the outcomes are said to be conditionally independent of
the treatment, and the {cmd:teffects} and {cmd:stteffects} estimators may
be used.

{pstd}
When not all of these variables common to both treatment assignment and
outcomes are observable, the outcomes are not conditionally independent 
of the treatment, and {cmd:eteffects}, {cmd:etpoisson}, or {cmd:etregress}
may be used.

{pstd}
{cmd:teffects} and {cmd:stteffects} offer much flexibility in estimators and
functional forms for the treatment-assignment models.  {cmd:teffects} provides
models for continuous, binary, count, fractional, and nonnegative outcome
variables.  {cmd:stteffects} provides many functional forms for survival-time
outcomes.  See
{bf:{mansection TE teffectsintro:[TE] teffects intro}},
{bf:{mansection TE teffectsintroadvanced:[TE] teffects intro advanced}}, and
{bf:{mansection TE stteffectsintro:[TE] stteffects intro}} for more
information.

{pstd}
{cmd:eteffects}, {cmd:etpoisson}, and {cmd:etregress} offer less flexibility
than {cmd:teffects} because more structure must be imposed when conditional
independence is not assumed.
{cmd:eteffects} is for continuous, binary, count, fractional, and nonnegative
outcomes and uses a probit model for binary treatments; see
{manhelp eteffects TE}.
{cmd:etpoisson} is for count outcomes and uses a normal distribution to model
treatment assignment; see {helpb etpoisson:[TE] etpoisson}.
{cmd:etregress} is for linear outcomes and uses
a normal distribution to model treatment assignment; see
{helpb etregress:[TE] etregress}.


    {title:Treatment effects}

{p 8 36 2}{helpb teffects aipw} {space 11} Augmented inverse-probability weighting{p_end}
{p 8 36 2}{helpb teffects ipw} {space 12} Inverse-probability weighting{p_end}
{p 8 36 2}{helpb teffects ipwra} {space 10} Inverse-probability-weighted
regression adjustment{p_end}
{p 8 36 2}{helpb teffects nnmatch} {space 8} Nearest-neighbor matching{p_end}
{p 8 36 2}{helpb teffects psmatch} {space 8} Propensity-score matching{p_end}
{p 8 36 2}{helpb teffects ra} {space 13} Regression adjustment{p_end}


    {title:Survival treatment effects}

{p 8 36 2}{helpb stteffects ipw} {space 10} Survival-time inverse-probability weighting{p_end}
{p 8 36 2}{helpb stteffects ipwra} {space 8} Survival-time inverse-probability-weighted
regression adjustment{p_end}
{p 8 36 2}{helpb stteffects ra} {space 11} Survival-time regression adjustment{p_end}
{p 8 36 2}{helpb stteffects wra} {space 10} Survival-time weighted regression adjustment{p_end}


    {title:Endogenous treatment effects}

{p 8 36 2}{helpb eteffects} {space 15} Endogenous treatment-effects estimation
{p_end}
{p 8 36 2}{helpb etpoisson} {space 15} Poisson regression with endogenous
treatment effects{p_end}
{p 8 36 2}{helpb etregress} {space 15} Linear regression with endogenous
treatment effects{p_end}


{pstd}{bf:{ul:Treatment effects with sample selection, endogenous covariates, and random effects}}

{p 8 36 2}{helpb eregress} {space 16} Extended linear regression{p_end}
{p 8 36 2}{helpb eintreg} {space 17} Extended interval regression{p_end}
{p 8 36 2}{helpb eprobit} {space 17} Extended probit regression{p_end}
{p 8 36 2}{helpb eoprobit} {space 16} Extended ordered probit regression
{p_end}


    {title:Postestimation tools}

{p 8 36 2}{helpb tebalance} {space 15} Check balance after teffects or stteffects
estimation{p_end}
{p 8 36 2}{helpb tebalance box} {space 11} Covariate balance box{p_end}
{p 8 36 2}{helpb tebalance density} {space 7} Covariate balance density{p_end}
{p 8 36 2}{helpb tebalance overid} {space 8} Test for covariate balance{p_end}
{p 8 36 2}{helpb tebalance summarize} {space 5} Covariate-balance summary
statistics{p_end}

{p 8 36 2}{helpb teffects overlap}{space 10}Overlap plots{p_end}

{p 8 36 2}{helpb eteffects postestimation}{space 2}Postestimation tools for
eteffects{p_end}
{p 8 36 2}{helpb etpoisson postestimation}{space 2}Postestimation tools for
etpoisson{p_end}
{p 8 36 2}{helpb etregress postestimation}{space 2}Postestimation tools for
etregress{p_end}
{p 8 36 2}{helpb stteffects postestimation}{space 2}Postestimation tools for
stteffects{p_end}
