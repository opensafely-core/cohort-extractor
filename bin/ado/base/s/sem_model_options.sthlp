{smcl}
{* *! version 1.0.10  14may2018}{...}
{vieweralsosee "[SEM] sem model description options" "mansection SEM semmodeldescriptionoptions"}{...}
{vieweralsosee "[SEM] Intro 2" "mansection SEM Intro2"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] sem and gsem option constraints()" "help sem and gsem option constraints"}{...}
{vieweralsosee "[SEM] sem and gsem option covstructure()" "help sem and gsem option covstructure"}{...}
{vieweralsosee "[SEM] sem and gsem option from()" "help sem_and gsem option_from"}{...}
{vieweralsosee "[SEM] sem and gsem option reliability()" "help sem_and gsem option_reliability"}{...}
{vieweralsosee "[SEM] sem and gsem path notation" "help sem_and_gsem_path_notation"}{...}
{vieweralsosee "[SEM] sem postestimation" "help sem_postestimation"}{...}
{viewerjumpto "Syntax" "sem_model_options##syntax"}{...}
{viewerjumpto "Description" "sem_model_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_model_options##linkspdf"}{...}
{viewerjumpto "Options" "sem_model_options##options"}{...}
{viewerjumpto "Remarks" "sem_model_options##remarks"}{...}
{viewerjumpto "Examples" "sem_model_options##examples"}{...}
{p2colset 1 40 42 2}{...}
{p2col:{bf:[SEM] sem model description options} {hline 2}}Model description
options{p_end}
{p2col:}({mansection SEM semmodeldescriptionoptions:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:sem} {it:{help sem_and_gsem_path notation:paths}} ...{cmd:,} ...
    {it:model_description_options}

{synoptset 28 tabbed}{...}
{synopthdr:model_description_options}
{synoptline}
{p2coldent :* {helpb sem and gsem path notation:{ul:cov}ariance()}}path notation for treatment of covariances{p_end}
{p2coldent :* {helpb sem and gsem path notation:{ul:var}iance()}}path notation for treatment of variances{p_end}
{p2coldent :* {helpb sem and gsem path notation:{ul:mean}s()}}path notation for treatment of means{p_end}

{p2coldent :* {helpb sem and gsem option covstructure:{ul:covstr}ucture()}}alternative method to place restrictions
on covariances{p_end}

{synopt :{opt nocons:tant}}do not fit intercepts{p_end}
{synopt :{opt nomean:s}}do not fit means or intercepts{p_end}
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
{it:paths} and the options above describe the model to be fit by {cmd:sem}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM semmodeldescriptionoptionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

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
{opt noconstant} specifies that all intercepts be constrained to 0.  See
{helpb sem_and gsem path_notation:[SEM] sem and gsem path notation}.

{phang}
{opt nomeans} specifies that means and intercepts not be fit.  The means and
intercepts are concentrated out of the function being optimized, which
is typically the likelihood function.  Results for all other
parameters are the same whether or not this option is specified.

{p 8 8 2}
This option is seldom specified.  {cmd:sem} issues this option to itself when
you use summary statistics data that do not include summary statistics for the
means.

{phang}
{opt noanchor} specifies that {cmd:sem} is not to check for lack of
identification and fill in anchors where needed.  {cmd:sem} is instead
to issue an error message if anchors would be needed.  You specify this option
when you believe you have specified the necessary normalization constraints
and want to hear about it if you are wrong.  See
{it:{mansection SEM Intro4RemarksandexamplesIdentification2Normalizationconstraints(anchoring):Identification 2: Normalization constraints (anchoring)}}
in {manlink SEM Intro 4}. 

{phang}
{opt forcenoanchor} is similar to {opt noanchor} except that rather than
issue an error message, {cmd:sem} proceeds to estimation.  There is no reason
you should specify this option.  {opt forcenoanchor} is used in testing of
{cmd:sem} at StataCorp.

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
process; see {helpb sem_and gsem option_from:[SEM] sem and gsem option from()}.  Starting values
can also be specified by using the {cmd:init()} suboption as described in 
{helpb sem_and gsem path_notation##item16:[SEM] sem and gsem path notation}.


{marker remarks}{...}
{title:Remarks}

{pstd}
To use {cmd:sem} successfully, you need to understand {it:paths}, 
{opt covariance()}, {opt variance()}, and {opt means()}; see 
{it:{mansection SEM Intro2RemarksandexamplesUsingpathdiagramstospecifystandardlinearSEMs:Using path diagrams to specify standard linear SEMs}} in
{bf:[SEM] Intro 2} and
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
