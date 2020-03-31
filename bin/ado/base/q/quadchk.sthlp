{smcl}
{* *! version 1.2.3  19oct2017}{...}
{viewerdialog quadchk "dialog quadchk"}{...}
{vieweralsosee "[XT] quadchk" "mansection XT quadchk"}{...}
{viewerjumpto "Syntax" "quadchk##syntax"}{...}
{viewerjumpto "Menu" "quadchk##menu"}{...}
{viewerjumpto "Description" "quadchk##description"}{...}
{viewerjumpto "Links to PDF documentation" "quadchk##linkspdf"}{...}
{viewerjumpto "Options" "quadchk##options"}{...}
{viewerjumpto "Remarks" "quadchk##remarks"}{...}
{viewerjumpto "Examples" "quadchk##examples"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[XT] quadchk} {hline 2}}Check sensitivity of quadrature approximation{p_end}
{p2col:}({mansection XT quadchk:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}{cmd:quadchk} [{it:#1 #2}] [{cmd:,} {opt noout:put} {opt nofrom} ]

{pstd}
{it:#1} and {it:#2} specify the number of quadrature points to use in the
comparison runs of the previous model.  The default is to use approximately
2{it:n_q}/3 and 4{it:n_q}/3 points, where {it:n_q} is the number
of quadrature points used in the original estimation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Setup and utilities >}
     {bf:Check sensitivity of quadrature approximation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:quadchk} checks the quadrature approximation used in the random-effects
estimators of the following commands:

	{helpb xtcloglog}
	{helpb xtintreg}
	{helpb xtlogit}
	{helpb xtologit}
	{helpb xtoprobit}
{phang2}{helpb xtpoisson}{cmd:, re} with the {opt normal} option{p_end}
	{helpb xtprobit}
	{helpb xtstreg}
	{helpb xttobit}

{pstd}
{cmd:quadchk} refits the model for different numbers of quadrature points and
then compares the different solutions.  {cmd:quadchk} respects all options
supplied to the original model except {cmd:or}, {cmd:vce()}, and the
{it:maximize_options}.



{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT quadchkQuickstart:Quick start}

        {mansection XT quadchkRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt nooutput} suppresses the iteration log and output of the refitted models.

{phang}
{opt nofrom} forces refitted models to start from scratch rather than starting
from the previous estimation results.  Specifying the {cmd:nofrom} option can
level the playing field in testing estimation results.


{marker remarks}{...}
{title:Remarks}

{pstd}
As a rule of thumb, if the coefficients do not change by more than a
relative difference of 10^-4 (0.01%), the choice of quadrature points does not
significantly affect the outcome, and the results may be confidently
interpreted.  However, if the results do change appreciably -- greater
than a relative difference of 10^-2 (1%) -- then you should question
whether the model can be reliably fit using the chosen quadrature method
and the number of integration points.

{pstd}
Two aspects of random-effects models have the potential to make the
quadrature approximation inaccurate: large group sizes and large correlations
within groups.  These factors can also work in tandem, decreasing or increasing
the reliability of the quadrature.  Increasing the number of integration
points increases the accuracy of the quadrature approximation.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse quad1}{p_end}
{phang2}{cmd:. xtset id}

{pstd}Fit random-effects (RE) probit model{p_end}
{phang2}{cmd:. xtprobit z x1-x6}{p_end}

{pstd}Check stability of quadrature calculation{p_end}
{phang2}{cmd:. quadchk}{p_end}

{pstd}Fit RE probit model using nonadaptive Gauss-Hermite quadrature{p_end}
{phang2}{cmd:. xtprobit z x1-x6, intmethod(ghermite)}{p_end}

{pstd}Check stability of quadrature approximation, suppressing output of
models{p_end}
{phang2}{cmd:. quadchk, nooutput}{p_end}

{pstd}Same as above {cmd:xtprobit}, but increase the number of iteration
points to 120{p_end}
{phang2}{cmd:. xtprobit z x1-x6, intmethod(ghermite) intpoints(120)}{p_end}

{pstd}Check stability of quadrature approximation, suppressing output of
models{p_end}
{phang2}{cmd:. quadchk, nooutput}{p_end}
