{smcl}
{* *! version 1.0.6  04oct2018}{...}
{viewerdialog "fmm: glm" "dialog fmm, message(-glm-)"}{...}
{vieweralsosee "[FMM] fmm: glm" "mansection FMM fmmglm"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] glm" "help glm"}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "fmm_glm##syntax"}{...}
{viewerjumpto "Menu" "fmm_glm##menu"}{...}
{viewerjumpto "Description" "fmm_glm##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_glm##linkspdf"}{...}
{viewerjumpto "Remarks" "fmm_glm##remarks"}{...}
{viewerjumpto "Stored results" "fmm_glm##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col :{bf:[FMM] fmm: glm} {hline 2}}Finite mixtures of generalized linear
regression models{p_end}
{p2col:}({mansection FMM fmmglm:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 15 2}
{cmd:fmm} {it:#}{cmd::} {cmd:glm} {depvar} [{indepvars}]
[{cmd:,} {it:options}]


{pstd}
Full syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{help fmm glm##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_glm##fmmopts:fmmopts}}]{cmd::} {cmd:glm}
{depvar} [{indepvars}]
{bind:[{cmd:,} {it:options}]}


{pstd}
where {it:#} specifies the number of class models.

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opth f:amily(fmm_glm##family:familyname)}}distribution of {depvar};
default is {cmd:family(gaussian)}{p_end}
{synopt :{opth l:ink(fmm_glm##link:linkname)}}link function; default varies
per family{p_end}
{synopt :{opt nocons:tant}}suppress the constant term{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e})
in model with coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in
model with coefficient constrained to 1{p_end}
{synopt :{opt asis}}retain perfect predictor variables{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:indepvars} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see
{help tsvarlist}.{p_end}
{p 4 6 2}
For a detailed description of {it:options}, see 
{help glm##options:{it:Options}} in {manhelp glm R}.

{marker family}{...}
{synoptset 26}{...}
{synopthdr:familyname}
{synoptline}
{synopt :{opt gau:ssian}}Gaussian (normal); the default{p_end}
{synopt :{opt be:rnoulli}}Bernoulli{p_end}
{synopt :{opt beta}}beta{p_end}
{synopt :{opt bi:nomial} [{it:#}|{varname}]}binomial; default number of
binomial trials is 1{p_end}
{synopt :{opt p:oisson}}Poisson{p_end}
{synopt :{opt nb:inomial} [{opt mean}|{opt cons:tant}]}negative binomial;
default dispersion is {opt mean}{p_end}
{synopt :{opt e:xponential}}exponential{p_end}
{synopt :{opt gam:ma}}gamma{p_end}
{synopt :{opt logn:ormal}}lognormal{p_end}
{synopt :{opt logl:ogistic}}loglogistic{p_end}
{synopt :{opt wei:bull}}Weibull{p_end}
{synoptline}
{p 4 6 2}
{cmd:bernoulli}, {cmd:beta}, {cmd:exponential}, {cmd:lognormal},
{cmd:loglogistic}, and {cmd:weibull} are extensions available with
{cmd:fmm: glm} that are not available with {cmd:glm}.

{marker link}{...}
{synopthdr:linkname}
{synoptline}
{synopt :{opt iden:tity}}identity{p_end}
{synopt :{opt log}}log{p_end}
{synopt :{opt logit}}logit{p_end}
{synopt :{opt prob:it}}probit{p_end}
{synopt :{opt clog:log}}complementary log-log{p_end}
{synoptline}

INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > Generalized linear model (GLM)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: glm} fits mixtures of generalized linear regression models;
see {manhelp fmm FMM} and {manhelp glm R} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection FMM fmmintroRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
For a general introduction to finite mixture models, see
{manlink FMM fmm intro}.
For general information about generalized linear regression, see
{manhelp glm R}.  


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse stamp}{p_end}

{pstd}Mixture of three lognormal distributions of {cmd:thickness}{p_end}
{phang2}{cmd:. fmm 3: glm thickness, family(lognormal)}{p_end}

{pstd}Estimated probabilities of membership in the three classes{p_end}
{phang2}{cmd:. estat lcprob}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See
{help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
