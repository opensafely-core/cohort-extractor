{smcl}
{* *! version 1.0.7  15mar2019}{...}
{vieweralsosee "[ERM]" "mansection ERM"}{...}
{viewerjumpto "Description" "erm_intro##description"}{...}
{viewerjumpto "Resources" "erm_intro##resources"}{...}
{viewerjumpto "Reference" "erm_intro##reference"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:erm introduction }{hline 2}}Introduction to erm{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
ERM stands for extended regression model, a term we at Stata
created.  Although the term is new, the method is not. ERMs are 
regression models with continuous outcomes (including censored 
and tobit outcomes), binary outcomes, and ordered outcomes that are fit 
with maximum likelihood.  These models can account for endogenous 
covariates, sample selection, and nonrandom treatment assignment. 
ERMs provide a unifying framework for handling these complications 
individually or in combination.


{marker resources}{...}
{title:Resources}

{pstd}
If you are new to ERMs, see the introductions in the following manual 
entries:{p_end}

{synoptset 30}{...}
{synoptline}
{synopt :{manlink ERM Intro}}Introduction{p_end}
{synopt :{manlink ERM Intro 1}}An introduction to the ERM commands{p_end}
{synopt :{manlink ERM Intro 2}}The models that ERMs fit{p_end}
{synopt :{manlink ERM Intro 3}}Endogenous covariates features{p_end}
{synopt :{manlink ERM Intro 4}}Endogenous sample-selection features{p_end}
{synopt :{manlink ERM Intro 5}}Treatment assignment features{p_end}
{synopt :{manlink ERM Intro 6}}Panel data and grouped data model features{p_end}
{synopt :{manlink ERM Intro 7}}Model interpretation{p_end}
{synopt :{manlink ERM Intro 8}}A Rosetta stone for extended regression commands{p_end}
{synopt :{manlink ERM Intro 9}}Conceptual introduction via worked example{p_end}
{synoptline}

{pstd}
If you are already familiar with ERMs, see the following help files for
descriptions of the commands for fitting ERMs:{p_end}

{synoptline}
{synopt :{helpb eintreg:[ERM] eintreg}}Extended interval regression{p_end}
{synopt :{helpb eoprobit:[ERM] eoprobit}}Extended ordered probit regression{p_end}
{synopt :{helpb eprobit:[ERM] eprobit}}Extended probit regression{p_end}
{synopt :{helpb eregress:[ERM] eregress}}Extended linear regression{p_end}
{synopt :{helpb erm_options:[ERM] ERM options}}Extended regression model options{p_end}
{synoptline}

{pstd}
See the following help files for descriptions of the commands available after
fitting ERMs:{p_end}

{synoptline}
{synopt :{helpb eintreg_postestimation:[ERM] eintreg postestimation}}Postestimation tools for eintreg and xteintreg{p_end}
{synopt :{helpb eintreg_predict:[ERM] eintreg predict}}predict after eintreg and xteintreg{p_end}
{synopt :{helpb eoprobit_postestimation:[ERM] eoprobit postestimation}}Postestimation tools for eoprobit and xteoprobit{p_end}
{synopt :{helpb eoprobit_predict:[ERM] eoprobit predict}}predict after eoprobit and xteoprobit{p_end}
{synopt :{helpb eprobit_postestimation:[ERM] eprobit postestimation}}Postestimation tools for eprobit and xteprobit{p_end}
{synopt :{helpb eprobit_predict:[ERM] eprobit predict}}predict after eprobit and xteprobit{p_end}
{synopt :{helpb eregress_postestimation:[ERM] eregress postestimation}}Postestimation tools for eregress and xteregress{p_end}
{synopt :{helpb eregress_predict:[ERM] eregress predict}}predict after eregress and xteregress{p_end}
{synoptline}

{pstd}
The following manual entries demonstrate examples of how to fit models using 
{cmd:eregress}, {cmd:eintreg}, {cmd:eprobit}, and {cmd:eoprobit}:

{synoptline}
{synopt :{manlink ERM Example 1a}}Linear regression with continuous endogenous covariate{p_end}
{synopt :{manlink ERM Example 1b}}Interval regression with continuous endogenous covariate{p_end}
{synopt :{manlink ERM Example 1c}}Interval regression with endogenous covariate and sample selection{p_end}
{synopt :{manlink ERM Example 2a}}Linear regression with binary endogenous covariate{p_end}
{synopt :{manlink ERM Example 2b}}Linear regression with exogenous treatment{p_end}
{synopt :{manlink ERM Example 2c}}Linear regression with endogenous treatment{p_end}
{synopt :{manlink ERM Example 3a}}Probit regression with continuous endogenous covariate{p_end}
{synopt :{manlink ERM Example 3b}}Probit regression with endogenous covariate and treatment{p_end}
{synopt :{manlink ERM Example 4a}}Probit regression with endogenous sample selection{p_end}
{synopt :{manlink ERM Example 4b}}Probit regression with endogenous treatment and sample selection{p_end}
{synopt :{manlink ERM Example 5}}Probit regression with endogenous ordinal treatment{p_end}
{synopt :{manlink ERM Example 6a}}Ordered probit regression with endogenous treatment{p_end}
{synopt :{manlink ERM Example 6b}}Ordered probit regression with endogenous treatment and sample selection{p_end}
{synopt :{manlink ERM Example 7}}Random-effects regression with continuous endogenous covariate{p_end}
{synopt :{manlink ERM Example 8a}}Random effects in one equation and endogenous covariate{p_end}
{synopt :{manlink ERM Example 8b}}Random effects, endogenous covariate, and endogenous sample selection{p_end}
{synopt :{manlink ERM Example 9}}Ordered probit regression with endogenous treatment and random effects{p_end}
{synoptline}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{phang}
Gould, W. W. 2018. Ermistatas and Stata's new ERMs commands.
The Stata Blog: Not Elsewhere Classified.
{browse "https://blog.stata.com/2018/03/27/ermistatas-and-statas-new-erms-commands/"}.
{p_end}
