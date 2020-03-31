{* *! version 1.0.8  07apr2011}{...}
{dlgtab:Main}

{phang}
{opt shape(shape)}
specifies the storage mode of {it:matname}, the matrix of dissimilarities.
{cmd:shape(full)} is the default.  The following {it:shape}s are allowed:

{phang2}
    {opt full}
    specifies that {it:matname} is an {it:n} x {it:n} symmetric matrix.

{phang2}
    {opt lower}
    specifies that {it:matname} is a row or column vector of length
    {it:n}({it:n}+1)/2, with the rowwise lower triangle of the dissimilarity
    matrix including the diagonal of zeros.

{pin3}
	D(11)
	D(21) D(22)
	D(31) D(32) D(33) ... D({it:n}1) D({it:n}2) ... D({it:n}{it:n})

{phang2}
    {opt llower}
    specifies that {it:matname} is a row or column vector of length
    {it:n}({it:n}-1)/2, with the rowwise lower triangle of the dissimilarity
    matrix excluding the diagonal.

{pin3}
	D(21)
	D(31) D(32)
	D(41) D(42) D(43) ... D({it:n}1) D({it:n}2) ... D({it:n},{it:n}-1)

{phang2}
    {opt upper}
    specifies that {it:matname} is a row or column vector of length
    {it:n}({it:n}+1)/2, with the rowwise upper triangle of the dissimilarity
    matrix including the diagonal of zeros.

{pin3}
	D(11) D(12) ... D(1{it:n})
	D(22) D(23) ... D(2{it:n})
	D(33) D(34) ... D(3{it:n}) ... D({it:n}{it:n})

{phang2}
    {opt uupper}
    specifies that {it:matname} is a row or column vector of length
    {it:n}({it:n}-1)/2, with the rowwise upper triangle of the dissimilarity
    matrix excluding the diagonal.

{pin3}
	D(12) D(13) ... D(1{it:n})
	D(23) D(24) ... D(2{it:n})
	D(34) D(35) ... D(3{it:n}) ... D({it:n}-1{it:n})

{phang}
{opt add}
specifies that {cmd:clustermat}'s results be added to the dataset
currently in memory.  The number of observations (selected observations based
on the {cmd:if} and {cmd:in} qualifiers) must equal the number of rows and
columns of {it:matname}.  Either {cmd:clear} or {cmd:add} is required if a
dataset is currently in memory.

{phang}
{opt clear}
drops all the variables and cluster solutions in the current dataset in memory
(even if that dataset has changed since the data were last saved)
before generating {cmd:clustermat}'s results.  Either {cmd:clear} or {cmd:add}
is required if a dataset is currently in memory.

{phang}
{opth labelvar(varname)}
specifies the name of a new variable to be created containing the row names
of matrix {it:matname}.

{phang}
{opt name(clname)}
specifies the name to attach to the resulting cluster analysis.  If
{cmd:name()} is not specified, Stata finds an available cluster name, displays
it for your reference, and attaches the name to your cluster analysis.

{dlgtab:Advanced}

{phang}
{opt force}
allows computations to continue when {it:matname} is nonsymmetric or has
nonzeros on the diagonal.  By default, {cmd:clustermat} will complain and exit
when it encounters these conditions.  {cmd:force} specifies that
{cmd:clustermat} operate on the symmetric matrix
({it:matname}*{it:matname}')/2, with any nonzero diagonal entries treated as
if they were zero.

{phang}
{opt generate(stub)}
provides a prefix for the variable names created by {cmd:clustermat}.  By
default, the variable name prefix is the name specified in {cmd:name()}.
Three variables are created and attached to the cluster-analysis results with
the suffixes {hi:_id}, {hi:_ord}, and {hi:_hgt}.  Users generally will not
need to access these variables directly.

{pmore}
Centroid linkage and median linkage can produce reversals or
crossovers; see {manlink MV cluster} for details.  When reversals happen,
{cmd:clustermat centroidlinkage} and {cmd:clustermat medianlinkage} also
create a fourth variable with the suffix {hi:_pht}.  This is a pseudoheight
variable that is used by some of the postclustering commands to properly
interpret the {hi:_hgt} variable.
{p_end}
