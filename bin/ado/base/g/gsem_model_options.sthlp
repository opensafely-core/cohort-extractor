{smcl}
{* *! version 1.1.3  14may2018}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] gsem model description options" "mansection SEM gsemmodeldescriptionoptions"}{...}
{vieweralsosee "[SEM] Intro 2" "mansection SEM Intro2"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SEM] sem and gsem option constraints()" "help sem and gsem option constraints"}{...}
{vieweralsosee "[SEM] sem and gsem option covstructure()" "help sem and gsem option covstructure"}{...}
{vieweralsosee "[SEM] sem and gsem option from()" "help sem and gsem option from"}{...}
{vieweralsosee "[SEM] sem and gsem option reliability()" "help sem and gsem option reliability"}{...}
{vieweralsosee "[SEM] sem and gsem path notation" "help sem and gsem path notation"}{...}
{viewerjumpto "Syntax" "gsem_model_options##syntax"}{...}
{viewerjumpto "Description" "gsem_model_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "gsem_model_options##linkspdf"}{...}
{viewerjumpto "Options" "gsem_model_options##options"}{...}
{viewerjumpto "Remarks" "gsem_model_options##remarks"}{...}
{viewerjumpto "Examples" "gsem_model_options##examples"}{...}
{p2colset 1 41 43 2}{...}
{p2col:{bf:[SEM] gsem model description options} {hline 2}}Model description
options{p_end}
{p2col:}({mansection SEM gsemmodeldescriptionoptions:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:gsem} {it:{help sem_and_gsem_path notation:paths}} ...{cmd:,} ...
    {it:model_description_options}

{synoptset 28 tabbed}{...}
{synopthdr:model_description_options}
{synoptline}
{synopt:{opt family()}, {cmd:link()}, ...}see {helpb gsem family and link options:[SEM] gsem family-and-link options}{p_end}

{p2coldent :* {helpb sem and gsem path notation:{ul:cov}ariance()}}path notation for treatment of covariances{p_end}
{p2coldent :* {helpb sem and gsem path notation:{ul:var}iance()}}path notation for treatment of variances{p_end}
{p2coldent :* {helpb sem and gsem path notation:{ul:mean}s()}}path notation for treatment of means{p_end}

{p2coldent :* {helpb sem and gsem option covstructure:{ul:covstr}ucture()}}alternative method to place restrictions on
covariances

{synopt :{opt col:linear}}keep collinear variables{p_end}
{synopt :{opt nocons:tant}}do not fit intercepts{p_end}
{synopt :{opt noasis}}omit perfect predictors from Bernoulli models{p_end}
{synopt :{opt noanchor}}do not apply default anchoring{p_end}
{synopt :{opt forcenoanchor}}programmer's option{p_end}

{p2coldent :* {helpb sem and gsem option reliability:{ul:rel}iability()}}reliability of measurement variables{p_end}

{synopt :{helpb sem and gsem option constraints:{ul:const}raints()}}specify constraints{p_end}
{synopt :{helpb sem and gsem option from:from()}}specify starting values{p_end}
{synoptline}
{p 4 6 2}
* Option may be specified more than once.
{p_end}


{marker description}{...}
{title:Description}

{pstd}
{it:paths} and the options above describe the model to be fit by {cmd:gsem}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM gsemmodeldescriptionoptionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:family()} and {cmd:link()}
     specify the distribution and link function,
     such as {cmd:family(poisson)} {cmd:link(log)},
     for generalized linear
     responses.  There are lots of synonyms, so you can specify, for example,
     just {cmd:poisson}.  In addition, there are {cmd:exposure()} and
     {cmd:offset()} options.  See
      {helpb gsem family and link options:[SEM] gsem family-and-link options}.

{phang}
{opt covariance()}, {opt variance()}, and {opt means()} fully
describe the model to be fit.  See 
{helpb sem_and gsem path_notation:[SEM] sem and gsem path notation}.

{phang}
{opt covstructure()} provides a convenient way to constrain covariances in
your model.  Alternatively or in combination, you can place constraints by
using the standard path notation.  See
{helpb sem_and gsem option_covstructure:[SEM] sem and gsem option covstructure()}.

{phang}
{cmd:collinear};
     see {helpb estimation options:[R] Estimation options}.

{phang}
{opt noconstant} specifies that all intercepts be constrained to 0.  See
{helpb sem_and gsem path_notation:[SEM] sem and gsem path notation}.

{pmore}
    This option is seldom specified.

{phang}
{cmd:noasis}
     specifies that perfect-predictor variables be omitted
     from all family Bernoulli models.  By default, {cmd:gsem}
     does not omit the variable, so one can specify tricky models
     where an equation contains perfect predictors that are
     still identified through other portions of the model.

{phang}
{opt noanchor} specifies that {cmd:gsem} is not to check for lack of
identification and fill in anchors where needed.  {cmd:gsem} is instead
to issue an error message if anchors would be needed.  You specify this option
when you believe you have specified the necessary normalization constraints
and want to hear about it if you are wrong.  See
{it:{mansection SEM Intro4RemarksandexamplesIdentification2Normalizationconstraints(anchoring):Identification 2: Normalization constraints (anchoring)}}
in {manlink SEM Intro 4}. 

{phang}
{opt forcenoanchor} is similar to {opt noanchor} except that rather than
issue an error message, {cmd:gsem} proceeds to estimation.  There is no reason
you should specify this option.  {opt forcenoanchor} is used in testing of
{cmd:gsem} at StataCorp.

{phang}
{opt reliability()} specifies the fraction of variance not due to measurement
error for a variable.  See 
{helpb sem_and gsem option_reliability:[SEM] sem and gsem option reliability()}.

{phang}
{opt constraints()} specifies parameter constraints you wish to impose on your
model; see {helpb sem_and gsem option_constraints:[SEM] sem and gsem option constraints()}.
Constraints can also be specified as described in 
{helpb sem_and gsem path_notation##item11:[SEM] sem and gsem path notation},
and they are usually more conveniently specified using the path notation.

{phang}
{opt from()} specifies the starting values to be used in the optimization
process; see {helpb sem_and gsem option_from:[SEM] sem and gsem option from()}.
Starting values can also be specified using the {cmd:init()} suboption as
 described in 
{helpb sem_and gsem path_notation##item16:[SEM] sem and gsem path notation}.


{marker remarks}{...}
{title:Remarks}

{pstd}
To use {cmd:gsem} successfully, you need to understand {it:paths}, 
{opt covariance()}, {opt variance()}, and {opt means()}; see 
{it:{mansection SEM Intro2RemarksandexamplesUsingpathdiagramstospecifystandardlinearSEMs:Using path diagrams to specify standard linear SEMs}}
in {bf:[SEM] Intro 2} and
{helpb sem_and gsem path_notation:[SEM] sem and gsem path notation}.

{pstd}
{opt covstructure()} is often convenient; see 
{helpb sem_and gsem option_covstructure:[SEM] sem and gsem option covstructure()}.


{marker examples}{...}
{title:Examples}

{pstd}
Examples of these options may be found in the indicated help files.

{synoptset 26 tabbed}{...}
{synopt:{cmd:covariance()}, {cmd:variance()}}see examples in
         {helpb sem and gsem path notation##examples:[SEM] sem and gsem path notation}{p_end}
{synopt:{space 2}and {cmd:mean()}}{p_end}
{synopt:{cmd:covstructure()}}see examples in
         {helpb sem and gsem option covstructure##examples:[SEM] sem and gsem option covstructure()}{p_end}
{synopt:{cmd:noconstant}}see examples in
         {helpb sem and gsem path notation##examples:[SEM] sem and gsem path notation}{p_end}
{synopt:{cmd:reliability()}}see examples in
         {helpb sem and gsem option reliability##examples:[SEM] sem and gsem option reliability()}{p_end}
{synopt:{cmd:constraints()}}see examples in
         {helpb sem and gsem option constraints##examples:[SEM] sem and gsem option constraints()}{p_end}
{synopt:{cmd:from()}}see examples in
         {helpb sem and gsem option from##examples:[SEM] sem and gsem option from()}{p_end}
{p2colreset}{...}
