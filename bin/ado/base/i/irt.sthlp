{smcl}
{* *! version 1.0.10  04mar2020}{...}
{vieweralsosee "[IRT] irt" "mansection IRT irt"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] Glossary" "help irt_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] DIF" "help dif"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{viewerjumpto "Description" "irt##description"}{...}
{viewerjumpto "Links to PDF documentation" "irt##linkspdf"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[IRT] irt} {hline 2}}Introduction to IRT models{p_end}
{p2col:}({mansection IRT irt:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Item response theory (IRT) is used in the design, analysis, scoring,
and comparison of tests and similar instruments whose purpose is to
measure unobservable characteristics of the respondents.
The {mansection IRT irt:PDF manual entry} discusses some fundamental and
theoretical aspects of IRT and illustrates these with worked examples.

{pstd}
The entries that follow describe how you can use the {cmd:irt} suite of
commands to fit a variety of IRT models and to evaluate the results.
The commands for fitting models can be grouped by the type of responses you
are modeling.

{p2colset 9 38 40 2}{...}
{pstd}
{bf:Binary response models}

{p2col :{helpb irt 1pl}}One-parameter logistic model{p_end}
{p2col :{helpb irt 2pl}}Two-parameter logistic model{p_end}
{p2col :{helpb irt 3pl}}Three-parameter logistic model{p_end}

{pstd}
{bf:Categorical response models}

{p2col :{helpb irt grm}}Graded response model{p_end}
{p2col :{helpb irt nrm}}Nominal response model{p_end}
{p2col :{helpb irt pcm}}Partial credit model{p_end}
{p2col :{helpb irt rsm}}Rating scale model{p_end}

{pstd}
{bf:Multiple IRT models combined}

{p2col :{helpb irt hybrid}}Hybrid IRT model{p_end}

{pstd}
These models can allow for differences across groups in the population.

{pstd}
{bf:Multiple-group IRT models}

{p2col :{helpb irt_group:irt, group()}}IRT models for multiple groups{p_end}

{pstd}
Constraints can be applied when fitting any IRT model, and they are
particularly useful for constraining parameters across groups in
multiple-group models.

{pstd}
{bf:Constraints}

{p2col :{helpb irt constraints}}Specifying constraints{p_end}

{pstd}
After fitting any IRT model, results can be reported, interpreted, and
evaluated using postestimation commands.

{pstd}
{bf:IRT graphs}

{p2col: {helpb irtgraph icc}}Item characteristic curve plot{p_end}
{p2col: {helpb irtgraph tcc}}Test characteristic curve plot{p_end}
{p2col: {helpb irtgraph iif}}Item information function plot{p_end}
{p2col: {helpb irtgraph tif}}Test information function plot{p_end}

{pstd}
{bf:IRT reports}

{p2col: {helpb estat report}}Report estimated IRT parameters{p_end}
{p2col: {helpb estat greport}}Report estimated group IRT parameters{p_end}

{pstd}
{bf:Model-specific postestimation overview}

{p2col: {helpb irt 1pl postestimation}}Postestimation tools for irt 1pl{p_end}
{p2col: {helpb irt 2pl postestimation}}Postestimation tools for irt 2pl{p_end}
{p2col: {helpb irt 3pl postestimation}}Postestimation tools for irt 3pl{p_end}
{p2col: {helpb irt grm postestimation}}Postestimation tools for irt grm{p_end}
{p2col: {helpb irt nrm postestimation}}Postestimation tools for irt nrm{p_end}
{p2col: {helpb irt pcm postestimation}}Postestimation tools for irt pcm{p_end}
{p2col: {helpb irt rsm postestimation}}Postestimation tools for irt rsm{p_end}
{p2col: {helpb irt hybrid postestimation}}Postestimation tools for irt hybrid{p_end}
{p2col: {helpb irt, group() postestimation}}Postestimation tools for group IRT{p_end}

{pstd}
Differential item functioning (DIF) occurs when items that are intended to
measure a trait are unfair, favoring one group of individuals over another.
DIF can be evaluated by fitting a multiple-group IRT model using
{cmd:irt, group()} or by using a logistic regression or Mantel–Haenszel DIF
test.

{bf:Differential item functioning}

{p2col: {helpb DIF}}Introduction to differential item functioning{p_end}
{p2col: {helpb diflogistic}}Logistic regression DIF{p_end}
{p2col: {helpb difmh}}Mantel–Haenszel DIF{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection IRT irtRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


