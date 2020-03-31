{smcl}
{* *! version 1.1.10  27sep2018}{...}
{findalias asfrimmediate}{...}
{title:Title}

{pstd}
{findalias frimmediate}


{title:Remarks}

{pstd}
An immediate command is a command that obtains data not from the data
stored in memory but from numbers typed as arguments.  Immediate commands, in
effect, turn Stata into a glorified hand calculator.

{pstd}
Sometimes you may not have the data, but you know something
about the data and what you do know is adequate to perform the statistical
test.

{pstd}
Immediate commands have the following properties:

{phang2}1.  They never disturb the data in memory.

{phang2}2.  The syntax for all is the same: the command name followed by
numbers that are the summary statistics from which the statistic is
calculated.

{phang2}3.  Immediate commands end in the letter i, although the converse is
not true.

{phang2}4.  Immediate commands are documented along with their nonimmediate
cousins.

{pstd}
Immediate commands include the following:

{p2colset 9 25 27 2}{...}
{p2col :Command}Description{p_end}
{p2line}
{p2col :{helpb bitesti}}Binomial probability test{p_end}
{p2col :{helpb cci}}Tables for epidemiologists; see {manhelp Epitab R}{p_end}
{p2col :{helpb csi}}{p_end}
{p2col :{helpb iri}}{p_end}
{p2col :{helpb mcci}}{p_end}
{p2col :{helpb cii}}Confidence intervals for means, proportions, and variances{p_end}
{p2col :{helpb esizei}}Effects size based on mean comparison{p_end}
{p2col :{helpb prtesti}}Tests of proportions{p_end}
{p2col :{helpb sdtesti}}Variance comparison tests{p_end}
{p2col :{helpb symmi}}Symmetry and marginal homogeneity tests{p_end}
{p2col :{helpb tabi}}Two-way tables of frequencies{p_end}
{p2col :{helpb ttesti}}t tests (mean-comparison tests){p_end}
{p2col :{helpb twoway pci}}Paired-coordinate plot with spikes or lines{p_end}
{p2col :{helpb twoway pcarrowi}}Paired-coordinate plot with arrows{p_end}
{p2col :{helpb twoway scatteri}}Twoway scatterplot{p_end}
{p2col :{helpb ztesti}}z tests (mean-comparison tests, known variance){p_end}
{p2line}

{pstd}
The {cmd:display} command is not really an immediate command, but it can be
used to perform as a hand calculator; see {manhelp display P}.
{p_end}

{pstd}
{cmd:power} is not technically an immediate command because it does not do
something on typed numbers that another command does on the dataset.  It does,
however, work strictly on numbers you type on the command line and does not
disturb the data in memory.  {cmd:power} performs power and sample-size
analysis.  See {helpb power}.
