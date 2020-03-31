{smcl}
{* *! version 1.1.12  19oct2017}{...}
{viewerdialog mkspline "dialog mkspline"}{...}
{vieweralsosee "[R] mkspline" "mansection R mkspline"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] fp" "help fp"}{...}
{viewerjumpto "Syntax" "mkspline##syntax"}{...}
{viewerjumpto "Menu" "mkspline##menu"}{...}
{viewerjumpto "Description" "mkspline##description"}{...}
{viewerjumpto "Links to PDF documentation" "mkspline##linkspdf"}{...}
{viewerjumpto "Options" "mkspline##options"}{...}
{viewerjumpto "Examples" "mkspline##examples"}{...}
{viewerjumpto "Stored results" "mkspline##results"}{...}
{viewerjumpto "Reference" "mkspline##reference"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[R] mkspline} {hline 2}}Linear and restricted cubic spline construction{p_end}
{p2col:}({mansection R mkspline:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Linear spline with knots at specified points

{p 8 17 2}
{cmd:mkspline}
{it:{help newvar:newvar_1}}
{it:#1}
[{it:{help newvar:newvar_2}}
{it:#2}
[{it:...}]]
{it:{help newvar:newvar_k}}
{cmd:=}
{it:oldvar}
{ifin}
[{cmd:,}
{opt m:arginal}
{opt di:splayknots}]


{phang}
Linear spline with knots equally spaced or at percentiles of data

{p 8 17 2}
{cmd:mkspline}
{it:stubname}
{it:#}
{cmd:=}
{it:oldvar}
{ifin}
[{it:{help mkspline##weight:weight}}]
[{cmd:,} {opt m:arginal} {opt p:ctile} {opt di:splayknots}]


{phang}
Restricted cubic spline

{p 8 17 2}
{cmd:mkspline}
{it:stubname}
{cmd:=}
{it:oldvar}
{ifin}
[{it:{help mkspline##weight:weight}}]
{cmd:, cubic} [{opt nk:nots(#)} {opth k:nots(numlist)} {opt di:splayknots}]

{marker weight}{...}
{phang}
{opt fweight}s are allowed with the second and third syntax; see {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Other variable-creation commands >}
      {bf:Linear and cubic spline construction}


{marker description}{...}
{title:Description}

{pstd}
{opt mkspline} creates variables containing a linear spline or a restricted
cubic spline of an existing variable.
For linear splines, knots can be user specified, equally spaced over the range
of the variable, or placed at percentiles.  For restricted cubic splines, also
known as natural splines, knot locations are based on Harrell's
({help mkspline##harrell2001:2001}) recommended percentiles or user-specified
points.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R mksplineQuickstart:Quick start}

        {mansection R mksplineRemarksandexamples:Remarks and examples}

        {mansection R mksplineMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Options}

{phang}
{opt marginal} is allowed with the first or second syntax.  It specifies that
the new variables be constructed so that, when used in estimation, the
coefficients represent the change in the slope from the preceding interval.
The default is to construct the variables so that, when used in estimation,
the coefficients measure the slopes for the interval.

{phang}
{opt displayknots} displays the values of the knots that were used in creating
the linear or restricted cubic spline.

{phang}
{opt pctile} is allowed only with the second syntax.  It specifies that
the knots be placed at percentiles of the data rather than being equally
spaced over the range.

{phang}
{opt nknots(#)} is allowed only with the third syntax.  It specifies the
number of knots that are to be used for a restricted cubic spline.  This
number must be between 3 and 7 unless the knot locations are specified using
{opt knots()}.  The default number of knots is 5.

{phang}
{opth knots(numlist)} is allowed only with the third syntax. It specifies the
exact location of the knots to be used for a restricted cubic spline.  The
values of these knots must be given in increasing order.  When this option is
omitted, the default knot values are based on Harrell's recommended
percentiles with the additional restriction that the smallest knot may not be
less than the fifth-smallest value of {it:oldvar} and the largest knot may not
be greater than the fifth-largest value of {it:oldvar}.  If both
{opt nknots()} and {opt knots()} are given, they must specify the same number
of knots.


{marker examples}{...}
{title:Examples}

{pstd}Fit a regression of log income on education and age by using a piecewise
linear function for age{p_end}
{phang2}{cmd:. webuse mksp1}{p_end}
{phang2}{cmd:. mkspline age1 20 age2 30 age3 40 age4 50 age5 60 age6 = age}{p_end}
{phang2}{cmd:. regress lninc educ age1-age6}{p_end}

{pstd}Fit the model so that the coefficients on the spline variables represent
the change in slope from the preceding group{p_end}
{phang2}{cmd:. webuse mksp1, clear}{p_end}
{phang2}{cmd:. mkspline age1 20 age2 30 age3 40 age4 50 age5 60 age6 = age, marginal}
{p_end}
{phang2}{cmd:. regress lninc educ age1-age6}{p_end}

{pstd}Create variables containing a linear spline of dosage with knots chosen
so that data are divided into five groups of equal size{p_end}
{phang2}{cmd:. webuse mksp2, clear}{p_end}
{phang2}{cmd:. mkspline dose 5 = dosage, pctile}{p_end}
{phang2}{cmd:. logistic outcome dose1-dose5}{p_end}

{pstd}Perform a logistic regression of outcome against a restricted cubic spline
function of dosage with four knots chosen according to Harrell's recommended
percentiles{p_end}
{phang2}{cmd:. webuse mksp2, clear}{p_end}
{phang2}{cmd:. mkspline dose = dosage, cubic nknots(4)}{p_end}
{phang2}{cmd:. logistic outcome dose*}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mkspline} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N_knots)}}number of knots{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(knots)}}location of knots{p_end}


{marker reference}{...}
{title:Reference}

{marker harrell2001}{...}
{phang}
Harrell, F. E., Jr.  2001.
{it:Regression Modeling Strategies: With Applications to Linear Models, Logistic Regression, and Survival Analysis}.
New York: Springer.
{p_end}
