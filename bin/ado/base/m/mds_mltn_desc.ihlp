{* *! version 1.0.9  04dec2014}{...}
{marker method()}{...}
{phang}
{opt method(method)} specifies the method for MDS.

{phang2}
{cmd:method(classical)} specifies classical metric scaling,
also known as "principal coordinates analysis" when used with Euclidean
proximities.  Classical MDS obtains equivalent results to modern MDS with
{cmd:loss(strain)} and {cmd:transform(identity)} without weights.  The
calculations for classical MDS are fast; consequently, classical MDS is
generally used to obtain starting values for modern MDS.  If the options
{cmd:loss()} and {cmd:transform()} are not specified, {cmd:mds} computes the
classical solution, likewise if {cmd:method(classical)} is specified
{cmd:loss()} and {cmd:transform()} are not allowed.

{phang2}
{cmd:method(modern)} specifies modern scaling.  If {cmd:method(modern)}
is specified but not {cmd:loss()} or {cmd:transform()}, then
{cmd:loss(stress)} and {cmd:transform(identity)} are assumed.  All
values of {cmd:loss()} and {cmd:transform()} are valid with
{cmd:method(modern)}.

{phang2}
{cmd:method(nonmetric)} specifies nonmetric scaling, which is a type of
modern scaling.  If {cmd:method(nonmetric)} is
specified, {cmd:loss(stress)} and {cmd:transform(monotonic)} are assumed.
Other values of {cmd:loss()} and {cmd:transform()} are not allowed.

{marker loss()}{...}
{phang}
{opt loss(loss)} specifies the loss criterion.

{phang2}
{cmd:loss(stress)}
specifies that the stress loss function be used, normalized by the squared
Euclidean distances.  This criterion is often called
Kruskal's stress-1.  Optimal configurations for {cmd:loss(stress)} and for
{cmd:loss(nstress)} are equivalent up to a scale factor, but the
iteration paths may differ.  {cmd:loss(stress)} is the default.

{phang2}
{cmd:loss(nstress)}
specifies that the stress loss function be used, normalized by the squared
disparities, that is, transformed dissimilarities.  Optimal configurations for
{cmd:loss(stress)} and for {cmd:loss(nstress)} are equivalent up to a scale
factor, but the iteration paths may differ.

{phang2}{cmd:loss(sstress)}
specifies that the squared stress loss function be used, normalized by the
fourth power of the Euclidean distances.

{phang2}{cmd:loss(nsstress)}
specifies that the squared stress criterion, normalized by the fourth power of
the disparities (transformed dissimilarities) be used.

{marker loss(strain)}{...}
{phang2}{cmd:loss(strain)}
specifies the strain loss criterion.  Classical scaling is equivalent to
{cmd:loss(strain)} and {cmd:transform(identity)} but is computed by
a faster noniterative algorithm.  Specifying {cmd:loss(strain)} still
allows transformations.

{phang2}{cmd:loss(sammon)} specifies the 
    {help mdslong##S1969:Sammon (1969)} loss criterion.

{marker transform()}{...}
{phang}
{opt transform(tfunction)} specifies the class of allowed transformations
of the dissimilarities; transformed dissimilarities are called disparities.

{phang2}{cmd:transform(identity)} specifies that the only allowed
transformation is the identity; that is, disparities are equal to
dissimilarities.  {cmd:transform(identity)} is the default.

{phang2}{cmd:transform(power)} specifies that disparities are related to
the dissimilarities by a power function,

            disparity = dissimilarity^alpha, alpha>0

{phang2}{cmd:transform(monotonic)} specifies that the disparities are a
weakly monotonic function of the dissimilarities.  This is also known as
nonmetric MDS.  Tied dissimilarities are handled by the primary method;
that is, ties may be broken but are not necessarily broken.
{cmd:transform(monotonic)} is valid only with {cmd:loss(stress)}.

{phang}{opt normalize(norm)} specifies a normalization method for the
configuration.  Recall that the location and orientation of an MDS
configuration is not defined ("identified"); an isometric transformation
(that is, translation, reflection, or orthonormal rotation) of a configuration
preserves interpoint Euclidean distances.

{phang2}{cmd:normalize(principal)}
performs a principal normalization, in which the configuration columns have
zero mean and correspond to the principal components, with positive
coefficient for the observation with lowest value of {cmd:id()}.  
{cmd:normalize(principal)} is the default.

{phang2}{cmd:normalize(classical)}
normalizes by a distance-preserving Procrustean
transformation of the configuration toward the classical configuration
in principal normalization; see {manhelp procrustes MV}.
{cmd:normalize(classical)} is not valid if {cmd: method(classical)} is
specified.

{phang2}{cmd:normalize(target(}{it:matname}{cmd:)} [{cmd:, copy}]{cmd:)} normalizes by a
distance-preserving Procrustean transformation toward
{it:matname}; see {manhelp procrustes MV}.  {it:matname} should be an {it:n} x
{it:p} matrix, where {it:n} is the number of observations and {it:p} is the
number of dimensions, and the rows of {it:matname} should be ordered with
respect to {cmd:id()}.  The rownames of {it:matname} should be set correctly
but will be ignored if {cmd:copy} is also specified.

{pmore}
Note on {cmd:normalize(classical)} and {cmd:normalize(target())}:
the Procrustes transformation comprises any combination of translation,
reflection, and orthonormal rotation -- these transformations preserve
distance.  Dilation (uniform scaling) would stretch distances and is
not applied.  However, the output reports the dilation factor, and the
reported Procrustes statistic is for the dilated configuration.
