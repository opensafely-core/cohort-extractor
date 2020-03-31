{smcl}
{* *! version 1.0.6  03apr2019}{...}
{vieweralsosee "[BAYES] Bayesian commands" "mansection BAYES Bayesiancommands"}{...}
{vieweralsosee "[BAYES] Intro" "mansection BAYES Intro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Description" "bayesian_commands##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayesian_commands##linkspdf"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[BAYES] Bayesian commands} {hline 2}}Introduction to commands for Bayesian analysis{p_end}
{p2col:}({mansection BAYES Bayesiancommands:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This entry describes commands to perform Bayesian analysis.  Bayesian analysis
is a statistical procedure that answers research questions by expressing
uncertainty about unknown parameters using probabilities.  It is based on the
fundamental assumption that not only the outcome of interest but also all the
unknown parameters in a statistical model are essentially random and are
subject to prior beliefs.


{p2colset 9 30 32 2}{...}
{pstd}
{bf:Estimation}

{p2col :{helpb Bayesian estimation}}Bayesian estimation commands{p_end}
{p2col :{helpb bayes}}Bayesian regression models using the {cmd:bayes} prefix{p_end}
{p2col :{helpb bayesmh}}Bayesian regression using MH{p_end}
{p2col :{helpb bayesmh evaluators}}User-defined Bayesian models using MH{p_end}


{pstd}
{bf:Convergence tests and graphical summaries}

{p2col :{helpb bayesgraph}}Graphical summaries{p_end}
{p2col :{helpb bayesstats grubin}}Gelman-Rubin convergence diagnostics{p_end}


{pstd}
{bf:Postestimation statistics}

{p2col :{helpb bayesstats ess}}Effective sample sizes and related statistics{p_end}
{p2col :{helpb bayesstats summary}}Bayesian summary statistics{p_end}
{p2col :{helpb bayesstats ic}}Bayesian information criteria and Bayes factors{p_end}


{pstd}
{bf:Predictions}

{p2col :{helpb bayespredict}}Bayesian predictions{p_end}
{p2col :{helpb bayesstats ppvalues}}Bayesian predictive p-values{p_end}


{pstd}
{bf:Hypothesis testing}

{p2col :{helpb bayestest model}}Hypothesis testing using model posterior probabilities{p_end}
{p2col :{helpb bayestest interval}}Interval hypothesis testing{p_end}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES BayesiancommandsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.
{p_end}
