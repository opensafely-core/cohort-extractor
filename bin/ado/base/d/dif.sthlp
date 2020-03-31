{smcl}
{* *! version 1.0.6  14may2019}{...}
{viewerdialog irt "dialog irt"}{...}
{vieweralsosee "[IRT] DIF" "mansection IRT DIF"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] diflogistic" "help diflogistic"}{...}
{vieweralsosee "[IRT] difmh" "help difmh"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] irt" "help irt"}{...}
{viewerjumpto "Description" "irt##description"}{...}
{viewerjumpto "Links to PDF documentation" "dif##linkspdf"}{...}
{viewerjumpto "Remarks" "dif##remarks"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[IRT] DIF} {hline 2}}Introduction to differential item
functioning{p_end}
{p2col:}({mansection IRT DIF:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Differential item functioning (DIF) occurs when items that are intended to
measure a latent trait are unfair, favoring one group of individuals over
another.  See the following help files for details about the individual DIF
tests, including syntax and worked examples.

{p2colset 9 24 26 2}{...}
{p2col :{helpb diflogistic}}Logistic regression DIF test{p_end}
{p2col :{helpb difmh}}Mantel-Haenszel DIF test{p_end}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection IRT DIFRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
DIF is often investigated in conjunction with fitting item response theory
models.  For an introduction to the IRT features in Stata, we encourage
you to read {manlink IRT irt} first.

{pstd}
Investigating DIF involves evaluating whether a test item behaves
differently across respondents with the same value of the latent trait.  An
item "functions differently" across individuals with the same latent trait if
these individuals have different probabilities of selecting a given response.
{p_end}
