{smcl}
{* *! version 1.1.6  11may2019}{...}
{vieweralsosee "[R] pk" "mansection R pk"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] menl" "help menl"}{...}
{viewerjumpto "Description" "pk##description"}{...}
{viewerjumpto "Links to PDF documentation" "pk##linkspdf"}{...}
{viewerjumpto "Remarks" "pk##remarks"}{...}
{viewerjumpto "Examples" "pk##examples"}{...}
{p2colset 1 11 13 2}{...}
{p2col:{bf:[R] pk} {hline 2}}Pharmacokinetic (biopharmaceutical) data{p_end}
{p2col:}({mansection R pk:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The term pk refers to pharmacokinetic data and the Stata commands, all of
which begin with the letters pk, designed to do some of the analyses commonly
performed in the pharmaceutical industry.  The system is intended for the
analysis of pharmacokinetic data, although some of the commands are for
general use.

{pstd}
The pk commands are

{p2colset 9 26 28 2}{...}
{p2col :{helpb pkexamine}}Calculate pharmacokinetic measures{p_end}
{p2col :{helpb pksumm}}Summarize pharmacokinetic data{p_end}
{p2col :{helpb pkshape}}Reshape (pharmacokinetic) Latin-square data{p_end}
{p2col :{helpb pkcross}}Analyze crossover experiments{p_end}
{p2col :{helpb pkequiv}}Perform bioequivalence tests{p_end}
{p2col :{helpb pkcollapse}}Generate pharmacokinetic measurement dataset{p_end}
{p2colreset}{...}

{pstd}
Also see {manhelp menl ME} for fitting pharmacokinetic models using
nonlinear mixed-effects models; for instance, see
{mansection ME menlRemarksandexamplesmenlextheoph:example 15} in
{bf:[ME] menl}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R pkRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Several types of clinical trials are commonly performed in the pharmaceutical
industry.  Examples include combination trials, multicenter trials,
equivalence trials, and active control trials.  For each type of trial, there
is an optimal study design for estimating the effects of interest.  The pk
system can be used to analyze equivalence trials, which are usually conducted
using a crossover design; however, it is possible to use a parallel design and
still draw conclusions about equivalence.

{pstd}
Equivalence trials assess bioequivalence between two drugs.  Although proving
that two drugs behave the same is impossible, regulatory agencies believe that
if the absorption properties of two drugs are similar, the two drugs will
produce similar effects and have similar safety profiles.  Generally, the goal
of an equivalence trial is to assess the equivalence of a generic drug to an
existing drug.  This goal is commonly accomplished by comparing a confidence
interval about the difference between a pharmacokinetic measurement of two
drugs with an equivalence limit constructed from regulations.  If the
confidence interval is entirely within the equivalence limit, the drugs are
declared bioequivalent.  Another approach to accessing bioequivalence is to
use the method of interval hypotheses testing.  {cmd:pkequiv} is used to
conduct these tests of bioequivalence.

{pstd}
Several pharmacokinetic measures can be used to ascertain how available a drug
is for cellular absorption.  The most common measure is the area under the
concentration-time curve (AUC).  Another common measure of drug availability
is the maximum concentration (Cmax) achieved by the drug during the follow-up
period.  Stata reports these and other less common measures of drug
availability, including the time at which the maximum drug concentration was
observed and the duration of the period during which the subject was being
measured.  Stata also reports the elimination rate, that is, the rate at which
the drug is metabolized, and the drug's half-life, that is, the time it takes
for the drug concentration to fall to one-half of its maximum concentration.

{pstd}
{cmd:pkexamine} computes and reports all the pharmacokinetic measures that
Stata produces, including four calculations of the AUC.  The standard AUC from
0 to the maximum observed time (AUC_0,tmax) is computed using cubic splines or
the trapezoidal rule.  {cmd:pkexamine} also computes the AUC from 0 to infinity
by extending the standard concentration-time curve from the maximum observed
time using three different methods.  The first method simply extends the
standard curve by using a least-squares linear fit through the last few data
points.  The second method extends the standard curve by fitting a decreasing
exponential curve through the last few data points.  The third method extends
the curve by fitting a least-squares linear regression line on the log
concentration.  The mathematical details of these extensions are described in
{mansection R pkexamineMethodsandformulas:{it:Methods and formulas}} of
{bf:[R] pkexamine}.

{pstd}
Data from an equivalence trial may also be analyzed using methods appropriate
to the particular study design.  When you have a crossover design,
{cmd:pkcross} can be used to fit an appropriate ANOVA model.  A crossover
design is simply a restricted Latin square; therefore, {cmd:pkcross} can also
be used to analyze any Latin-square design.

{pstd}
Some practical concerns arise when dealing with data from equivalence trials.
Primarily, the data must be organized in a manner that Stata can use.  The pk
commands include {cmd:pkcollapse} and {cmd:pkshape}, which are designed to
help transform data from a common format to one that is suitable for analysis
with Stata.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse auc}

{pstd}List the data{p_end}
{phang2}{cmd:. list, abbrev(14)}

{pstd}Calculate pharmacokinetic measures{p_end}
{phang2}{cmd:. pkexamine time conc}

    {hline}
    Setup
{phang2}{cmd:. webuse pkdata}

{pstd}List the variables {cmd:id}, {cmd:conc1}, and {cmd:time}, and separate
by {cmd:id}{p_end}
{phang2}{cmd:. list id conc1 time, sepby(id)}

{pstd}Produce summary statistics for pharmacokinetic measures{p_end}
{phang2}{cmd:. pksumm id time conc1}

{pstd}Generate pharmacokinetic dataset{p_end}
{phang2}{cmd:. pkcollapse time conc1 conc2, id(id) keep(seq) stat(auc)}

{pstd}Reshape data for use with {cmd:pkcross} and {cmd:pkequiv}{p_end}
{phang2}{cmd:. pkshape id seq auc*, order(RT TR)}

{pstd}Perform bioequivalence tests{p_end}
{phang2}{cmd:. pkequiv outcome treat period seq id}

{pstd}Analyze crossover experiments{p_end}
{phang2}{cmd:. pkcross outcome}{p_end}

    {hline}
