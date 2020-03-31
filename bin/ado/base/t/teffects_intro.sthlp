{smcl}
{* *! version 1.0.11  19oct2017}{...}
{viewerdialog teffects "dialog teffects"}{...}
{vieweralsosee "[TE] teffects intro" "mansection TE teffectsintro"}{...}
{vieweralsosee "[TE] teffects intro advanced " "mansection TE teffectsintroadvanced"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects" "help teffects"}{...}
{vieweralsosee "[TE] teffects multivalued" "help teffects_multivalued"}{...}
{viewerjumpto "Description" "teffects intro##description"}{...}
{viewerjumpto "Links to PDF documentation" "teffects_intro##linkspdf"}{...}
{viewerjumpto "Remarks" "teffects intro##remarks"}{...}
{viewerjumpto "Video examples" "teffects intro##video"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[TE] teffects intro} {hline 2}}Introduction to treatment
effects estimation for observational data{p_end}
{p2col:}({mansection TE teffectsintro:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This entry provides a nontechnical introduction to treatment-effects
estimators and the {cmd:teffects} command in Stata.  Advanced users may want
to instead read 
{bf:{mansection TE teffectsintroadvanced:[TE] teffects intro advanced}}
or skip to the individual commands' entries.

{pstd}
The {cmd:teffects} command estimates average treatment effects (ATEs), average
treatment effects among treated subjects (ATETs), and potential-outcome means
(POMs) using observational data.

{pstd}
Treatment effects can be estimated using regression adjustment (RA),
inverse-probability weights (IPW), and "doubly robust" methods,
including inverse-probability-weighted regression adjustment (IPWRA)
and augmented inverse-probability weights (AIPW), and via matching on
the propensity score or nearest neighbors.

{pstd}
The outcome can be continuous, binary, count, fractional, or nonnegative.
Treatments can be binary or multivalued.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE teffectsintroRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks: A quick tour of the estimators}

{pstd}
The {cmd:teffects} command implements six estimators of treatment effects.  We
introduce each one by showing the basic syntax one would use to apply them to
our birthweight example.  See each command's entry for more information.


    {bf:Regression adjustment}

{pstd}
{helpb teffects ra} implements the RA estimator.  We estimate the effect
of a mother's smoking behavior ({cmd:mbsmoke}) on the birthweight of her child
({cmd:bweight}), controlling for marital status ({cmd:mmarried}), the mother's
age ({cmd:mage}), whether the mother had a prenatal doctor's visit in the
baby's first trimester ({cmd:prenatal1}), and whether this baby is the
mother's first child ({cmd:fbaby}).  We use linear regression (the default) to
model {cmd:bweight}:

{phang2}{cmd:. webuse cattaneo2}{p_end}
{phang2}{cmd:. teffects ra (bweight mmarried mage prenatal1 fbaby) (mbsmoke)}


    {bf:Inverse-probability weighting}

{pstd}
{helpb teffects ipw} implements the IPW estimator.  Here we estimate the
effect of smoking by using a probit model to predict the mother's smoking
behavior as a function of marital status, the mother's age, and indicators for
first-trimester doctor's visits and firstborn status:

{phang2}{cmd:. teffects ipw (bweight) (mbsmoke mmarried mage prenatal1 fbaby,}
         {cmd:probit)}


    {bf:Inverse-probability-weighted regression adjustment}

{pstd}
{helpb teffects ipwra} implements the IPWRA estimator.  We model the
outcome, birthweight, as a linear function of marital status, the mother's age,
and indicators for first-trimester doctor's visits and firstborn status.  We
use a  logistic model (the default) to predict the mother's smoking behavior,
using the same covariates as explanatory variables:

{phang2}{cmd:. teffects ipwra (bweight mmarried mage prenatal1 fbaby)}
           {cmd:(mbsmoke mmarried mage prenatal1 fbaby)}


    {bf:Augmented inverse-probability weighting}

{pstd}
{helpb teffects aipw} implements the AIPW estimator.  Here we use the
same outcome- and treatment-model specifications as we did with the
IPWRA estimator:

{phang2}{cmd:. teffects aipw (bweight mmarried mage prenatal1 fbaby)}
         {cmd:(mbsmoke mmarried mage prenatal1 fbaby)}


    {bf:Nearest-neighbor matching}

{pstd}
{helpb teffects nnmatch} implements the NNM estimator.  In this example,
we match treated and untreated subjects based on marital status, the mother's
age, the father's age, and indicators for first-trimester doctor's visits and
firstborn status.   We use the Mahalanobis distance based on the mother's and
father's ages to find matches.  We use exact matching on the other three
variables to enforce the requirement that treated subjects are matched with
untreated subjects who have the same marital status and indicators for
first-trimester doctor's visits and firstborn statuses.  Because we are
matching on two continuous covariates, we request that {cmd:teffects nnmatch}
include a bias-correction term based on those two covariates:

{phang2}{cmd:. teffects nnmatch (bweight mage fage) (mbsmoke),}
        {cmd:ematch(prenatal1 mmarried fbaby) biasadj(mage fage)}


    {bf:Propensity-score matching}

{pstd}
{helpb teffects psmatch} implements the PSM estimator.  Here we model
the propensity score using a probit model, incorporating marital status,
the mother's age, and indicators for first-trimester doctor's visits and
firstborn status as covariates:

{phang2}{cmd:. teffects psmatch (bweight) (mbsmoke mmarried mage}
        {cmd:prenatal1 fbaby, probit)}


{marker video}{...}
{title:Video examples}

{phang2}{browse "http://www.youtube.com/watch?v=p578jxAPJT4&feature=c4-overview&list=UUVk4G4nEtBS4tLOyHqustDA":Introduction to treatment effects in Stata, part 1}

{phang2}{browse "https://www.youtube.com/watch?v=v4l3F3BrtlQ":Introduction to treatment effects in Stata, part 2}
{p_end}
