{smcl}
{* *! version 2.0.3  19oct2017}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] sem and gsem option reliability()" "mansection SEM semandgsemoptionreliability()"}{...}
{findalias assemrel}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SEM] sem model description options" "help sem_model_options"}{...}
{vieweralsosee "[SEM] gsem model description options" "help gsem_model_options"}{...}
{viewerjumpto "Syntax" "sem_and_gsem_option_reliability##syntax"}{...}
{viewerjumpto "Description" "sem_and_gsem_option_reliability##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_and_gsem_option_reliability##linkspdf"}{...}
{viewerjumpto "Option" "sem_and_gsem_option_reliability##option"}{...}
{viewerjumpto "Remarks" "sem_and_gsem_option_reliability##remarks"}{...}
{viewerjumpto "Examples" "sem_and_gsem_option_reliability##examples"}{...}
{p2colset 1 44 46 2}{...}
{p2col:{bf:[SEM] sem and gsem option reliability()} {hline 2}}Fraction of variance
not due to measurement error{p_end}
{p2col:}({mansection SEM semandgsemoptionreliability():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:sem}|{cmd:gsem} ... [{cmd:,} ... {cmd:reliability(}{varname} {it:#}
        [{varname} {it:#} [...]]{cmd:)}]

{pstd}
where {it:varname} is the name of an observed variable and {it:#} is the
fraction or percentage of variance not due to measurement error:

{phang2}{cmd:. {sem|gsem} ..., ... reliability(x1 .8  x2 .9)}{p_end}

{phang2}{cmd:. {sem|gsem} ..., ... reliability(x1 80%  x2 90%)}{p_end}


{marker description}{...}
{title:Description}

{pstd}
Option {opt reliability()} allows you to specify the fraction of
variance not due to measurement error for measurement variables.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM semandgsemoptionreliability()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:reliability(}{varname} {it:#} [...]{cmd:)}
specifies the reliability for variable {it:varname}.  Reliability is bounded
by 0 and 1 and is equal to

{phang3}{cmd:1 - noise variance/total variance}{p_end}

{p 8 8 2}
The reliability is assumed to be 1 when not specified. 

 
{marker remarks}{...}
{title:Remarks}

{pstd}
See {findalias semrel}.

{pstd}
See the following sections in {manlink SEM sem and gsem option reliability()}:

{phang2}{mansection SEM semandgsemoptionreliability()RemarksandexamplesBackground:Background}{p_end}
{phang2}{mansection SEM semandgsemoptionreliability()RemarksandexamplesDealingwithmeasurementerrorofexogenousvariables:Dealing with measurement error of exogenous variables}{p_end}
{phang2}{mansection SEM semandgsemoptionreliability()RemarksandexamplesDealingwithmeasurementerrorofendogenousvariables:Dealing with measurement error of endogenous variables}{p_end}
{phang2}{mansection SEM semandgsemoptionreliability()RemarksandexamplesWhatcangowrong:What can go wrong}{p_end}


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_rel}{p_end}

{pstd}Fit model ignoring reliability{p_end}
{phang2}{cmd:. sem (x1 x2 <- X) (y <- X)}{p_end}

{pstd}Set reliability of {cmd:x1} to be 50%{p_end}
{phang2}{cmd:. sem (x1 <- X) (y <- X), reliability(x1 .5)}{p_end}

{pstd}Set reliability for multiple variables{p_end}
{phang2}{cmd:. sem (x1 x2 <- X) (y <- X), reliability(x1 .5 x2 .5)}{p_end}

{pstd}Use the percentage notation{p_end}
{phang2}{cmd:. sem (x1 x2 <- X) (y <- X), reliability(x1 50% x2 50%)}{p_end}
