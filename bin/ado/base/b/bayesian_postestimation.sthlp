{smcl}
{* *! version 1.1.7  14may2019}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "mansection BAYES Bayesianpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "[BAYES] bayesmh evaluators" "help bayesmh evaluators"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian commands"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Description" "bayesian postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayesian_postestimation##linkspdf"}{...}
{viewerjumpto "Remarks" "bayesian_postestimation##remarks"}{...}
{p2colset 1 36 38 2}{...}
{p2col:{bf:[BAYES] Bayesian postestimation} {hline 2}}Postestimation tools 
for bayesmh and the bayes prefix{p_end}
{p2col:}({mansection BAYES Bayesianpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The following Bayesian postestimation commands are available after
the {cmd:bayesmh} command ({manhelp bayesmh BAYES}) and the {cmd:bayes} prefix
({manhelp bayes BAYES}): 

{synoptset 24 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb bayesgraph}}graphical summaries and convergence diagnostics{p_end}
{synopt :{helpb bayesstats grubin}}Gelman-Rubin convergence diagnostics{p_end}
{synopt :{helpb bayesstats ess}}effective sample sizes and related statistics{p_end}
{synopt :{helpb bayesstats ppvalues}}Bayesian predictive p-values (available only after {cmd:bayesmh}){p_end}
{synopt :{helpb bayesstats summary}}Bayesian summary statistics for model parameters and their functions{p_end}
{synopt :{helpb bayesstats ic}}Bayesian information criteria and Bayes factors{p_end}
{synopt :{helpb bayestest model}}hypothesis testing using model posterior probabilities{p_end}
{synopt :{helpb bayestest interval}}interval hypotheses testing{p_end}
{synopt :{helpb bayespredict}}Bayesian predictions (available only after {cmd:bayesmh}){p_end}
{p2coldent:* {helpb estimates}}cataloging estimation results{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:estimates table} and {cmd:estimates stats} are not appropriate with
{cmd:bayesmh} and {cmd:bayes:} estimation results.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES BayesianpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{marker bayesian_post_reref}{...}
{pstd}
For multilevel models, there are various ways, {it:reref}, in which you can
refer to individual random-effects parameters.  Suppose that your model has
random intercepts at the {cmd:id} level, which are labeled as {cmd:{U0[id]}}
or {cmd:{U0}} for short. To refer to all random intercepts, you can use
{cmd:{U0}}, {cmd:{U0[.]}}, and {cmd:{U0[id]}}. To refer to specific random
intercepts, you can use {cmd:{c -(}U0[}{it:#}{cmd:]{c )-}}, where {it:#}
refers to the {it:#}th element of the random-effects vector, or use
{cmd:{c -(}U0[}{it:#}{cmd:.id]{c )-}}, where {it:#} refers to the {it:#}th
level of the {cmd:id} variable. You can also refer to a subset
{it:{help numlist}} of random intercepts by using
{cmd:{c -(}U0[}{it:numlist}{cmd:]{c )-}} or
{cmd:{c -(}U0[(}{it:numlist}{cmd:).id]{c )-}}. For nested random effects,
for example, {cmd:{UU0[id1>id2]}}, you can refer to all random effects as
{cmd:{UU0}} or {cmd:{UU0[.,.]}} and to subsets of random effects as
{cmd:{c -(}UU0[}{it:numlist}{cmd:,}{it:numlist}{cmd:]{c )-}} or
{cmd:{c -(}UU0[(}{it:numlist}{cmd:).id1,}{cmd:(}{it:numlist}{cmd:).id2]{c )-}}.
{p_end}
