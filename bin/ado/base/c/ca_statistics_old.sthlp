{smcl}
{* *! version 1.0.5  14jun2010}{...}
Statistics reported by {cmd:ca} and {cmd:camat}
{hline}

{title:Decomposition of inertia}

{p2colset 5 26 28 2}{...}
{p2col:Statistic}Description{p_end}
{p2line}
{p2col:{cmd:total inertia}}(Pearson X2)/n = sum(principal inertia)
{p_end}
{p2col:{cmd:singular values}}computed for matrix of standardized residuals;
singular value equals the correlation of the row and column coordinates,
comparable to the canonical correlations
{p_end}
{p2col:{cmd:principal inertia}}square of singular value, inertia explained
by the principal axis
{p_end}
{p2line}
{p2colreset}{...}


{title:Summary statistics for the row and column points}

{p2colset 5 26 28 2}{...}
{p2col:Statistic}Description{p_end}
{p2line}
{p2col:{cmd:overall}}
{p_end}

{p2col:{space 2}{cmd:mass}}mass = marginal probability = f(i+) and f(+j).
The sum of {cmd:mass} over the active categories of a variable equals 1
{p_end}
{p2col:{space 2}{cmd:quality}}measure of fit: fraction of explained
row/column inertia by the selected dimensions; equivalently, the squared
correlation of the row/column profile with the subspace; in a saturated
model, {cmd:quality} = 1
{p_end}
{p2col:{space 2}{cmd:inertia}}inertia of the row/column profile;
the sum of the inertias of the active categories of a variable
equals the total inertia of the correspondence table.  Beware that some
textbooks display "percentage of inertias" in the categories of a variable,
so that the sum of the inertias over the categories equals 100, not total
inertia.
{p_end}
{p2line}
{p2col:{cmd:dimension_}{it:k}}
{p_end}

{p2col:{space 2}{cmd:coord}}coordinate on dimension k in the specified
normalization
{p_end}
{p2col:{space 2}{cmd:sqcorr}}squared correlation of profile
with dimension k.  The sum of {cmd:sqcorr} over the dimensions
equals {cmd:quality}
{p_end}
{p2col:{space 2}{cmd:contrib}}proportion of inertia on dimension k
explained by the profile.  The sum of {cmd:contrib} over all categories
of a variable equals 1
{p_end}
{p2line}
{p2colreset}{...}

{pstd}
The normalization of the coordinates is specified in the title of
the table.  See {helpb ca} for details.

{pstd}
In the {cmd:compact} display format, names of the statistics in the column
headers are abbreviated to {cmd:qualt} ({cmd:quality}), {cmd:inert}
({cmd:inertia}), {cmd:sqcor} ({cmd:sqcorr}), and {cmd:contr} ({cmd:contrib}).


{title:Also see}

{psee}
{space 2}Help:  {manhelp ca MV}, {manhelp ca_postestimation MV:ca postestimation}
{p_end}
