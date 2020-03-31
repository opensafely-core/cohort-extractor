{smcl}
{* *! version 1.1.7  28aug2018}{...}
{vieweralsosee "[ME] me" "mansection ME me"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] Glossary" "help me_glossary"}{...}
{viewerjumpto "Description" "me##description"}{...}
{viewerjumpto "Mixed-effects linear regression" "me##MElinear"}{...}
{viewerjumpto "Mixed-effects generalized linear regression" "me##GLMM"}{...}
{viewerjumpto "Mixed-effects censored regression" "me##MEcensored"}{...}
{viewerjumpto "Mixed-effects binary regression" "me##MEbinary"}{...}
{viewerjumpto "Mixed-effects ordinal regression" "me##MEordinal"}{...}
{viewerjumpto "Mixed-effects count-data regression" "me##MEcount"}{...}
{viewerjumpto "Mixed-effects multinomial regression" "me##MEmulti"}{...}
{viewerjumpto "Mixed-effects survival model" "me##MEsurvival"}{...}
{viewerjumpto "Nonlinear mixed-effects regression" "me##NLME"}{...}
{viewerjumpto "Postestimation tools" "me##MEpost"}{...}
{viewerjumpto "Links to PDF documentation" "me##linkspdf"}{...}
{p2colset 1 12 14 2}{...}
{p2col:{bf:[ME] me} {hline 2}}Introduction to me commands{p_end}
{p2col:}({mansection ME me:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Mixed-effects models are characterized as containing both fixed effects
and random effects.  The fixed effects are analogous to standard
regression coefficients and are estimated directly.  The random effects are
not directly estimated (although they may be obtained postestimation) but are
summarized according to their estimated variances and covariances.  Random
effects may take the form of either random intercepts or random coefficients,
and the grouping structure of the data may consist of multiple levels of
nested groups.  As such, mixed-effects models are also known in the literature
as multilevel models and hierarchical models.
Mixed-effects commands fit mixed-effects models for a variety of distributions
of the response conditional on normally distributed random effects.


{marker MElinear}{...}
    {title:Mixed-effects linear regression}

{p 8 30 2}{helpb mixed}{space 15}Multilevel mixed-effects linear regression{p_end}


{marker GLMM}{...}
    {title:Mixed-effects generalized linear model}

{p 8 30 2}{helpb meglm}{space 15}Multilevel mixed-effects generalized linear model{p_end}


{marker MEcensored}{...}
    {title:Mixed-effects censored regression}

{p 8 30 2}{helpb metobit}{space 13}Multilevel mixed-effects tobit regression{p_end}
{p 8 30 2}{helpb meintreg}{space 12}Multilevel mixed-effects interval regression{p_end}


{marker MEbinary}{...}
    {title:Mixed-effects binary regression}

{p 8 30 2}{helpb melogit}{space 13}Multilevel mixed-effects logistic regression{p_end}
{p 8 30 2}{helpb meprobit}{space 12}Multilevel mixed-effects probit regression{p_end}
{p 8 30 2}{helpb mecloglog}{space 11}Multilevel mixed-effects complementary log-log regression{p_end}


{marker MEordinal}{...}
    {title:Mixed-effects ordinal regression}

{p 8 30 2}{helpb meologit}{space 12}Multilevel mixed-effects ordered logistic regression{p_end}
{p 8 30 2}{helpb meoprobit}{space 11}Multilevel mixed-effects ordered probit regression{p_end}


{marker MEcount}{...}
    {title:Mixed-effects count-data regression}

{p 8 30 2}{helpb mepoisson}{space 11}Multilevel mixed-effects Poisson regression{p_end}
{p 8 30 2}{helpb menbreg}{space 13}Multilevel mixed-effects negative binomial regression{p_end}


{marker MEmulti}{...}
    {title:Mixed-effects multinomial regression}

{pmore}
Although there is no {cmd:memlogit} command, multilevel mixed-effects
multinomial logistic models can be fit using {cmd:gsem}; see
{findalias gsemtmlogit}.
{p_end}


{marker MEsurvival}{...}
    {title:Mixed-effects survival model}

{p 8 30 2}{helpb mestreg}{space 13}Multilevel mixed-effects parametric survival
model{p_end}


{marker NLME}{...}
    {title:Nonlinear mixed-effects regression}

{p 8 30 2}{helpb menl}{space 16}Nonlinear mixed-effects regression{p_end}


{marker MEpost}{...}
    {title:Postestimation tools specific to mixed-effects commands}

{p 8 30 2}{helpb estat df}{space 12}Calculate and display degrees of freedom for fixed effects{p_end}
{p 8 30 2}{helpb estat group}{space 9}Summarize the composition of the nested groups{p_end}
{p 8 30 2}{helpb estat icc}{space 11}Estimate intraclass correlations{p_end}
{p 8 30 2}{helpb estat recovariance}{space 4}Display the estimated random-effects covariance matrices{p_end}
{p 8 30 2}{helpb me estat sd:estat sd}{space 12}Display variance components as standard deviations and correlations{p_end}
{p 8 30 2}{helpb me estat wcorrelation:estat wcorrelation}{space 2}Display within-cluster correlations and standard deviations{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ME meQuickstart:Quick start}

        {mansection ME meRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.
{p_end}
