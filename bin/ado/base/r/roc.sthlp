{smcl}
{* *! version 1.0.6  15oct2018}{...}
{viewerdialog roctab "dialog roctab"}{...}
{viewerdialog roccomp "dialog roccomp"}{...}
{viewerdialog rocgold "dialog rocgold"}{...}
{vieweralsosee "[R] roc" "mansection R roc"}{...}
{viewerjumpto "Description" "roc##description"}{...}
{viewerjumpto "Reference" "roc##reference"}{...}
{p2colset 1 12 14 2}{...}
{p2col:{bf:[R] roc} {hline 2}}Receiver operating characteristic (ROC) analysis
{p_end}
{p2col:}({mansection R roc:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
ROC analysis quantifies the
accuracy of diagnostic tests or other evaluation modalities used to
discriminate between two states or conditions, which
are here referred to as normal and abnormal or control and case.  
The discriminatory accuracy of a diagnostic test is measured by its ability 
to correctly classify known normal and abnormal subjects.  For this reason, 
we often refer to the diagnostic test as a classifier.  The analysis uses 
the ROC curve, a graph of the sensitivity versus 
1-specificity of the diagnostic test.  The sensitivity is the 
fraction of positive cases that are correctly classified by
the diagnostic test, whereas the specificity is the fraction of negative cases
that are correctly classified.  Thus the sensitivity is the true-positive
rate, and the specificity is the true-negative rate.

{pstd}
There are six ROC commands:

{p2colset 9 25 27 2}{...}
{p2col: Command}Description{p_end}
{p2line}
{p2col :{helpb roccomp}}Tests of equality of ROC areas{p_end}
{p2col :{helpb rocgold}}Tests of equality of ROC areas against a standard ROC curve{p_end}
{p2col :{helpb rocfit}}Parametric ROC models{p_end}
{p2col :{helpb rocreg}}Nonparametric and parametric ROC regression models{p_end}
{p2col :{helpb rocregplot}}Plot marginal and covariate-specific ROC curves
{p_end}
{p2col :{helpb roctab}}Nonparametric ROC analysis{p_end}
{p2line}

{pstd}
Postestimation commands are available after {cmd:rocfit} and {cmd:rocreg};
see {manhelp rocfit_postestimation R:rocfit postestimation} and
{manhelp rocreg_postestimation R:rocreg postestimation}.

{pstd}
Both nonparametric and parametric (semiparametric) methods have been 
suggested for generating the ROC curve.  The {cmd:roctab} command 
performs nonparametric ROC analysis for a single classifier.  
{cmd:roccomp} extends the nonparametric ROC analysis function of 
{cmd:roctab} to situations where we have multiple diagnostic tests of interest
to be compared and tested.  The {cmd:rocgold} command also provides ROC
analysis for multiple classifiers. {cmd:rocgold} compares each classifier's ROC
curve to a "gold standard" ROC curve and makes adjustments for multiple
comparisons in the analysis.  Both {cmd:rocgold} and {cmd:roccomp} also allow
parametric estimation of the ROC curve through a binormal fit.  In a binormal
fit, both the control and case populations are normal.

{pstd}
The {cmd:rocfit} command also estimates the ROC curve of a classifier 
through a binormal fit.  Unlike {cmd:roctab}, {cmd:roccomp}, and {cmd:rocgold},
{cmd:rocfit} is an estimation command.  In postestimation, graphs of the ROC
curve and confidence bands can be produced.  Additional tests on the parameters
can also be conducted. 

{pstd}
ROC analysis can be interpreted as a two-stage process.  First, the 
control distribution of the classifier is estimated, assuming a normal model 
or using a distribution-free estimation technique.  The classifier is 
standardized using the control distribution to 1-percentile value, 
the false-positive rate.  Second, the ROC curve is 
estimated as the case distribution of the standardized classifier values.

{pstd}
Covariates may affect both stages of ROC analysis.  The first stage 
may be affected, yielding a covariate-adjusted ROC curve.  
The second stage may also be affected, producing multiple covariate-specific
ROC curves.

{pstd}
The {cmd:rocreg} command performs ROC analysis under both types of 
covariate effects.  Both parametric (semiparametric) and nonparametric methods
may be used by {cmd:rocreg}.  Like {cmd:rocfit}, {cmd:rocreg} is an estimation 
command and provides many postestimation capabilities.

{pstd}
The global performance of a diagnostic test is commonly summarized by the area
under the ROC curve (AUC).  This area can be interpreted as the 
probability that the result of a diagnostic test of a randomly selected 
abnormal subject will be greater than the result of the same diagnostic test 
from a randomly selected normal subject.  The greater the AUC, the
better the global performance of the diagnostic test.  Each of the 
ROC commands provide computation of the AUC.

{pstd}
Citing a lack of clinical relevance for the AUC, other ROC 
summary measures have been suggested.  These include the partial area under 
the ROC curve for a given false-positive rate t [pAUC(t)].
This is the area under the ROC curve from the false-positive rate of 
0 to t.  The ROC value at a particular false-positive rate and the 
false-positive rate for a particular ROC value are also useful 
summary measures for the ROC curve.  These three measures are directly 
estimated by {cmd:rocreg} during the model fit or postestimation stages.  
Point estimates of ROC value are computed by the other ROC 
commands, but no standard errors are reported.  

{pstd}
See {help roc##P2003:Pepe (2003)} for a discussion of ROC analysis. Pepe has
posted Stata datasets and programs used to reproduce results presented in the
book
({browse "https://www.stata.com/bookstore/pepe.html":https://www.stata.com/bookstore/pepe.html}).


{marker reference}{...}
{title:Reference}

{marker P2003}{...}
{phang}
Pepe, M. S. 2003.
{browse "https://www.stata.com/bookstore/pepe.html":{it:The Statistical Evaluation of Medical Tests for Classification and Prediction}}.
New York: Oxford University Press.
{p_end}
