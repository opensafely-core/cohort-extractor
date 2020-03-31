{smcl}
{* *! version 1.0.10  11feb2011}{...}
{vieweralsosee "[MV] ca" "help ca"}{...}
{vieweralsosee "[MV] mca" "help mca"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] ca postestimation" "help ca_postestimation"}{...}
{vieweralsosee "[MV] mca postestimation" "help mca_postestimation"}{...}
{title:Statistics reported by ca, camat, and mca: Decomposition of inertia}

{p2colset 5 26 28 2}{...}
{p2col:Statistic}Description{p_end}
{p2line}
{p2col:{cmd:total inertia}}(Pearson X2)/n = sum(principal inertia)
{p_end}
{p2col:{cmd:singular values}}({cmd:ca} only) computed for matrix of
standardized residuals;
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
{p2col:{space 2}{cmd:%inert}}inertia of the row/column profile;
gives the percentage of the total inertia of the correspondence table
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
the table.  See {manhelp ca MV} or {manhelp mca MV} for details.

{pstd}
In the {cmd:compact} display format, names of the statistics in the column
headers are abbreviated to {cmd:qualt} ({cmd:quality}), {cmd:%inert},
{cmd:sqcor} ({cmd:sqcorr}), and {cmd:contr} ({cmd:contrib}).
{p_end}
