{smcl}
{* *! version 1.0.5  25sep2018}{...}
{vieweralsosee "[BAYES] bayestest" "mansection BAYES bayestest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian postestimation"}{...}
{vieweralsosee "[BAYES] bayestest interval" "help bayestest interval"}{...}
{vieweralsosee "[BAYES] bayestest model" "help bayestest model"}{...}
{viewerjumpto "Description" "bayestest##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayestest##linkspdf"}{...}
{viewerjumpto "Remarks" "bayestest##remarks"}{...}
{p2colset 1 22 22 2}{...}
{p2col:{bf:[BAYES] bayestest} {hline 2}}Bayesian hypothesis testing{p_end}
{p2col:}({mansection BAYES bayestest:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayestest} provides two types of Bayesian hypothesis testing,
interval hypothesis testing and model hypothesis testing, using current
Bayesian estimation results.

{pstd}
{cmd:bayestest interval} performs interval hypothesis tests for model
parameters and functions of model parameters; see 
{helpb bayestest interval}.

{pstd}
{cmd:bayestest model} tests hypotheses about models by computing posterior
probabilities of the models; see {helpb bayestest model}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayestestRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Bayesian hypothesis testing is fundamentally different from the conventional
frequentist hypothesis testing using p-values.  Frequentist hypothesis testing
is based on the deterministic decision of whether to reject a null hypothesis
against an alternative hypothesis based on the obtained p-value.  Bayesian
hypothesis testing is built upon a probabilistic formulation for a parameter
of interest.  For example, it can provide a probabilistic summary of how
likely that parameter of interest belongs to some prespecified set of values.
Also, Bayesian testing can assign a probability to a hypothesis of interest or
model of interest given the observed data.  This cannot be done in the
frequentist testing.  The ability to assign a probability to a hypothesis
often provides a more natural interpretation of the results.  For example,
Bayesian hypothesis testing provides a direct answer to the following
questions.  How likely is it that the mean height of males is larger than six
feet?  What is the probability that a person is guilty versus being innocent?
How likely is one model over the other model? Frequentist hypothesis testing
cannot be used to answer these questions.

{pstd}
We consider two forms of Bayesian hypothesis testing: interval hypothesis
testing and what we call model hypothesis testing.

{pstd}
The goal of interval hypothesis testing is to estimate the probability that a
model parameter lies in a certain interval; see {helpb bayestest interval}
for details.

{pstd}
The goal of model hypothesis testing is to test hypotheses about models by
computing probabilities of the specified models given the observed data; see
{helpb bayestest model} for details.
{p_end}
