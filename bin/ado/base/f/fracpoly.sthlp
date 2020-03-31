{smcl}
{* *! version 1.2.19  21oct2012}{...}
{viewerdialog fracpoly "dialog fracpoly"}{...}
{viewerdialog fracgen "dialog fracgen"}{...}
{vieweralsosee "help prdocumented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] fracpoly postestimation" "help fracpoly postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] mfp" "help mfp"}{...}
{viewerjumpto "Syntax" "fracpoly##syntax"}{...}
{viewerjumpto "Menu" "fracpoly##menu"}{...}
{viewerjumpto "Description" "fracpoly##description"}{...}
{viewerjumpto "Options for fracpoly" "fracpoly##options_fracpoly"}{...}
{viewerjumpto "Options for fracgen" "fracpoly##options_fracgen"}{...}
{viewerjumpto "Examples" "fracpoly##examples"}{...}
{viewerjumpto "Stored results" "fracpoly##results"}{...}
{pstd}
{cmd:fracpoly} has been superseded by {helpb fp}.  {cmd:fracpoly}
continues to work but, as of Stata 13, is no longer an official part of Stata.
This is the original help file, which we will no longer update, so some links
may no longer work.

{hline}

{title:Title}

{p2colset 5 21 23 2}{...}
{p2col :{bf:[R] fracpoly} {hline 2}}Fractional polynomial regression{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Fractional polynomial regression

{p 8 17 2}
{cmd:fracpoly}
	[{cmd:,}
		{it:{help fracpoly##fracpoly_options:fracpoly_options}}]
        {cmd::} 
{it:{help fracpoly##regression_cmd:regression_cmd}}
[{it:{help varname:yvar1}} [{it:{help varname:yvar2}}]] 
{it:{help varname:xvar1}}
[{it:#} [{it:#}{it:...}]]
[{it:{help varname:xvar2}} [{it:#} [{it:#}{it:...}]]] [{it:...}]
[{it:{help varlist:xvarlist}}]
{ifin}
{weight}
[{cmd:,} {it:{help fracpoly##regression_cmd_options:regression_cmd_options}}]


{phang}
Display table showing the best fractional polynomial model for each degree

{p 8 17 2}{cmd:fracpoly} {cmd:,} {opt com:pare}


{phang}
Create variables containing fractional polynomial powers

{p 8 17 2}
{cmd:fracgen}
{varname}
{it:#} [{it:#} {it:...}]
{ifin}
[{cmd:,}
{it:{help fracpoly##fracgen_options:fracgen_options}}]


{synoptset 26 tabbed}{...}
{marker fracpoly_options}{...}
{synopthdr :fracpoly_options}
{synoptline}
{syntab :Model}
{synopt :{opt deg:ree(#)}}degree of fractional polynomial to fit; default is
{cmd:degree(2)}{p_end}

{syntab :Model 2}
{synopt :{opt nosca:ling}}suppress scaling of first independent variable{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth po:wers(numlist)}}list of fractional polynomial powers from
which models are chosen{p_end}
{synopt :{opth cent:er(fracpoly##cent_list:cent_list)}}specification of centering for the
independent variables{p_end}
{synopt :{opt all}}include
	out-of-sample observations in generated variables{p_end}

{syntab :Reporting}
{synopt :{opt log}}display iteration log{p_end}
{synopt :{opt com:pare}}compare models by degree{p_end}
{synopt :{it:{help fracpoly##display_options:display_options}}}control column
         formats and line width{p_end}
{synoptline}

{marker regression_cmd_options}{...}
{synopthdr :regression_cmd_options}
{synoptline}
{syntab :Model 2}
{synopt :{it:regression_cmd_options}}options appropriate to the regression command in use{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
All weight types supported by {it:regression_cmd} are allowed; see 
{help weight}.{p_end}
{p 4 6 2}
See {manhelp fracpoly_postestimation R:fracpoly postestimation}
for features available after estimation.{p_end}

{pstd}
where

{marker cent_list}{...}
{pin}
{it:cent_list} is a comma-separated list with elements
{varlist}{cmd::}{c -(}{opt mean}|{it:#}|{opt no}},
except that the first element may optionally be of the form
{c -(}{opt mean}|{it:#}|{opt no}} to specify the default for all variables.
{p_end}

{pin}
{marker regression_cmd}
{it:regression_cmd} may be
{helpb clogit},
{helpb glm},
{helpb intreg}, 
{helpb logistic},
{helpb logit},
{helpb mlogit},
{helpb nbreg},
{helpb ologit},
{helpb oprobit},
{helpb poisson},
{helpb probit},
{helpb qreg},
{helpb regress},
{helpb rreg},
{helpb stcox},
{helpb stcrreg},
{helpb streg},
or
{helpb xtgee}.


{synoptset 26 tabbed}{...}
{marker fracgen_options}{...}
{synopthdr :fracgen_options}
{synoptline}
{syntab:Main}
{synopt :{cmdab:cent:er(no}|{cmd:mean}|{it:#}{cmd:)}}center {varname} as specified; default is {cmd:center(no)}{p_end}
{synopt :{opt nosca:ling}}suppress scaling of {varname}{p_end}
{synopt :{cmd:restrict(}[{varname}] [{it:{help if}}]{cmd:)}}compute
         centering and scaling using specified subsample{p_end}
{synopt :{opt replace}}replace variables if they exist{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

    {title:fracpoly}

{phang2}
{bf:Statistics > Linear models and related > Fractional polynomials >}
      {bf:Fractional polynomial regression}

    {title:fracgen}

{phang2}
{bf:Statistics > Linear models and related > Fractional polynomials >}
      {bf:Create fractional polynomial powers}


{marker description}{...}
{title:Description}

{pstd}
{opt fracpoly} fits fractional polynomials (FPs) in {it:{help varname:xvar1}}
as part of the specified regression model.  After execution, {opt fracpoly}
leaves variables in the dataset named {bf:I}{it:xvar}{bf:__1},
{bf:I}{it:xvar}{bf:__2}, ..., where {it:xvar} represents the first four letters
of the name of {it:xvar1}.  The new variables contain the best-fitting FP
powers of {it:xvar1}.

{pstd}
Covariates other than {it:xvar1}, which are optional, are specified in
{it:xvar2}, ..., and {it:{help varlist:xvarlist}}.  They may be modeled
linearly and with specified FP transformations.  Fractional polynomial powers
are specified by typing numbers after the variable's name.  A variable name
typed without numbers is entered linearly.

{pstd}
{opt fracgen} creates new variables named {varname}{bf:_1},
{it:varname}{bf:_2}, ..., containing FP powers of
{it:varname} by using the powers {cmd:(}{it:#}[{it:#} {it:...}]{cmd:)}
specified.

{pstd}
See {manhelp fracpoly_postestimation R:fracpoly postestimation}
for information on {opt fracplot} and {opt fracpred}.

{pstd}
See {manhelp mfp R} for multivariable FP model fitting.


{marker options_fracpoly}{...}
{title:Options for fracpoly}

{dlgtab:Model}

{phang}
{opt degree(#)} determines the degree of FP to be fit.  The default is
{cmd:degree(2)}, that is, a model with two power terms.

{dlgtab:Model 2}

{phang}
{opt noscaling} suppresses scaling of {it:{help varname:xvar1}} and its powers.

{phang}
{opt noconstant} suppresses the regression constant if this is
permitted by {it:regression_cmd}.

{phang}
{opth powers(numlist)} is the set of FP powers from which models are to be
chosen.  The default is {cmd:powers(-2, -1, -.5, 0, .5, 1, 2, 3)} (0 means
log).

{phang}
{opt center(cent_list)} defines the centering for the
covariates {it:{help varname:xvar1}}, {it:xvar2}, ...,
{it:{help varlist:xvarlist}}.  The default is
{cmd:center(mean)}. 
A typical item in {it:cent_list} is
{varlist}{cmd::}{c -(}{cmd:mean}|{it:#}|{cmd:no}}.
Items are separated by commas.   The first
item is special because {it:varlist}{cmd::} is optional, and if omitted, the
default is (re)set to the specified value ({opt mean} or {it:#} or {opt no}).
For example, {cmd:center(no, age:mean)} sets the default to {opt no} and sets
the centering for {opt age} to {opt mean}.

{phang}
{it:regression_cmd_options} are options appropriate to the regression
command in use.  For example, for {opt stcox}, {it:regression_cmd_options} may
include {opt efron} or some alternate method for handling tied failures.

{phang}
{cmd:all} includes out-of-sample observations when generating the best-fitting
FP powers of {it:{help varname:xvar_1}}, {it:xvar_2}, etc.  By default, the
generated FP variables contain missing values outside the estimation sample.

{dlgtab:Reporting}

{phang}
{cmd:log} displays deviances and (for {cmd:regress}) residual standard
deviations for each FP model fit.

{phang}
{cmd:compare} reports a closed-test comparison between FP models.

{marker display_options}{...}
{phang}
{it:display_options}:
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] estimation options}.


{marker options_fracgen}{...}
{title:Options for fracgen}

{dlgtab:Main}

{phang}
{cmd:center(no}|{cmd:mean}|{it:#}{cmd:)}
specifies whether {varname} is to be centered; the default is
{cmd:center(no)}.

{phang}
{opt noscaling} suppresses scaling of {varname}.

{phang}
{cmd:restrict(}[{varname}] [{it:{help if}}]{cmd:)} specifies that centering and
scaling be computed using the subsample identified by {it:varname} and
{cmd:if}.

{pmore}
The subsample is defined by the observations for which {it:varname}!=0 that
also meet the {cmd:if} conditions.  Typically, {it:varname}=1 defines the
subsample and {it:varname}=0 indicates observations not belonging to the
subsample.  For observations whose subsample status is uncertain, {it:varname}
should be set to a missing value; such observations are dropped from the
subsample.

{pmore}
By default, {cmd:fracgen} computes the centering and scaling by using the
sample of observations identified in the {ifin} options.
The {opt restrict()} option identifies a subset of this sample.

{phang}
{opt replace} specifies that any existing variables named {varname}{bf:_1},
{it:varname}{bf:_2}, ..., may be replaced.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse igg}{p_end}

{pstd}Fit a second-degree fractional polynomial regression model{p_end}
{phang2}{cmd:. fracpoly: regress sqrtigg age}{p_end}

{pstd}Fit a fourth-degree fractional polynomial regression model and compare
to models of lower degrees{p_end}
{phang2}{cmd:. fracpoly, degree(4) compare: regress sqrtigg age}{p_end}

{pstd}Fit a fractional polynomial regression model using powers -2 and 2{p_end}
{phang2}{cmd:. fracpoly: regress sqrtigg age -2 2}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}

{pstd}Create variables containing fractional polynomial powers of -2 and -1 of
{cmd:mpg} without scaling{p_end}
{phang2}{cmd:. fracgen mpg -2 -1 if foreign==1, noscaling replace}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
In addition to what {it:regression_cmd} stores, {cmd:fracpoly} stores the following in {cmd:e()}:

{synoptset 27 tabbed}{...}
{p2col 5 27 31 2: Scalars}{p_end}
{synopt:{cmd:e(fp_N)}}number of nonmissing observations{p_end}
{synopt:{cmd:e(fp_dev)}}deviance for FP model of degree m{p_end}
{synopt:{cmd:e(fp_df)}}FP model degrees of freedom{p_end}
{synopt:{cmd:e(fp_d0)}}deviance for model without xvar_1{p_end}
{synopt:{cmd:e(fp_s0)}}residual SD for model without xvar_1{p_end}
{synopt:{cmd:e(fp_dlin)}}deviance for model linear in xvar_1{p_end}
{synopt:{cmd:e(fp_slin)}}residual SD model linear in xvar_1{p_end}
{synopt:{cmd:e(fp_d1), e(fp_d2), ...}}deviances for FP models of degree 1,2,...,m{p_end}
{synopt:{cmd:e(fp_s1), e(fp_s2), ...}}residual SDs for FP models of degree 1,2,...,m{p_end}

{synoptset 27 tabbed}{...}
{p2col 5 27 31 2: Macros}{p_end}
{synopt:{cmd:e(fp_cmd)}}{cmd:fracpoly}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(fp_depv)}}yvar1 (yvar2){p_end}
{synopt:{cmd:e(fp_rhs)}}xvar_1{p_end}
{synopt:{cmd:e(fp_base)}}variables in xvar_2, ..., xvarlist after centering 
and FP transformation{p_end}
{synopt:{cmd:e(fp_xp)}}{cmd:I}xvar{cmd:__1}, {cmd:I}xvar{cmd:__2}, etc.{p_end}
{synopt:{cmd:e(fp_fvl)}}variables in model finally estimated{p_end}
{synopt:{cmd:e(fp_wgt)}}weight type or {cmd:""}{p_end}
{synopt:{cmd:e(fp_wexp)}}weight expression if {cmd:`e(fp_wgt)' !=""}{p_end}
{synopt:{cmd:e(fp_pwrs)}}powers for FP model of degree m{p_end}
{synopt:{cmd:e(fp_x1), e(fp_x2), ...}}xvar_1 and variables in model{p_end}
{synopt:{cmd:e(fp_k1), e(fp_k2), ...}}powers for FP models of degree 1,2,...,m{p_end}

{pstd}
Residual SDs are stored only when {it:regression_cmd} is
{cmd:regress}.{p_end}
{p2colreset}{...}
