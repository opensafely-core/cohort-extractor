{smcl}
{* *! version 1.1.14  22may2018}{...}
{vieweralsosee "[P] matrix dissimilarity" "mansection P matrixdissimilarity"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "[MV] measure_option" "help measure_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] cluster" "help cluster"}{...}
{vieweralsosee "[MV] cluster programming utilities" "help cluster_programming"}{...}
{vieweralsosee "[MV] clustermat" "help clustermat"}{...}
{vieweralsosee "[MV] mdsmat" "help mdsmat"}{...}
{vieweralsosee "[MV] parse_dissim" "help parse_dissim"}{...}
{viewerjumpto "Syntax" "matrix_dissimilarity##syntax"}{...}
{viewerjumpto "Description" "matrix_dissimilarity##description"}{...}
{viewerjumpto "Links to PDF documentation" "matrix_dissimilarity##linkspdf"}{...}
{viewerjumpto "Options" "matrix_dissimilarity##options"}{...}
{viewerjumpto "Remarks" "matrix_dissimilarity##remarks"}{...}
{viewerjumpto "Examples" "matrix_dissimilarity##examples"}{...}
{viewerjumpto "References" "matrix_dissimilarity##references"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[P] matrix dissimilarity} {hline 2}}Compute similarity or
dissimilarity measures{p_end}
{p2col:}({mansection P matrixdissimilarity:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 29 2}
{cmdab:mat:rix} {cmdab:dis:similarity}
{it:matname} {cmd:=} [{varlist}]
{ifin}
{bind:[{cmd:,} {it:options}]}

{p2colset 5 23 25 2}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{it:{help measure option:measure}}}similarity or dissimilarity measure;
	default is {cmd:L2} (Euclidean){p_end}
{p2col:{opt obs:ervations}}compute similarity or dissimilarities between
	observations; the default{p_end}
{p2col:{opt var:iables}}compute similarities or dissimilarities between
	variables{p_end}
{p2col:{opth name:s(varname)}}row/column names for {it:matname} (allowed with
	{opt observations}){p_end}
{p2col:{opt allb:inary}}check that all values are 0, 1, or missing{p_end}
{p2col:{opt prop:ortions}}interpret values as proportions of binary
	values{p_end}
{p2col:{cmd:dissim(}{it:method}{cmd:)}}change
	similarity measure to dissimilarity measure{p_end}
{p2line}

{pstd}
where {it:method} transforms similarities to dissimilarities by using

          {opt oneminus}     d_ij = 1 - s_ij
          {opt st:andard}     d_ij = sqrt(s_ii + s_jj - 2*s_ij)


{marker description}{...}
{title:Description}

{pstd}
{cmd:matrix dissimilarity} computes a similarity, dissimilarity, or distance
matrix.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P matrixdissimilarityRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{it:measure} specifies one of the similarity or dissimilarity measures allowed
    by Stata.  The default is {cmd:L2}, Euclidean distance.  Many 
    similarity and dissimilarity measures are provided for continuous data and
    for binary data; see {manhelpi measure_option MV}.

{phang}
{cmd:observations} and {cmd:variables}
    specify whether similarities or dissimilarities are computed between
    observations or variables.  The default is {cmd:observations}.

{marker names()}{...}
{phang}
{opth names(varname)}
    provides row and column names for {it:matname}.  {it:varname} must be a
    string variable with a length of {ccl namelen} or less in bytes.  You will
    want to pick a {it:varname} that yields unique values for the row and
    column names.  Uniqueness of values is not checked by {cmd:matrix}
    {cmd:dissimilarity}.  {cmd:names()} is not allowed with the {cmd:variables}
    option.  The default row and column names when the similarities or
    dissimilarities are computed between observations is {cmd:obs}{it:#},
    where {it:#} is the observation number corresponding to that row or
    column.

{phang}
{cmd:allbinary}
    checks that all values are 0, 1, or {help missing}.  Stata treats nonzero
    values as one (excluding missing values) when dealing with what are
    supposed to be binary data (including binary similarity {it:measure}s).
    {cmd:allbinary} causes {cmd:matrix dissimilarity} to exit with an error
    message if the values are not truly binary.  {cmd:allbinary} is not
    allowed with {cmd:proportions} or the {cmd:Gower} {it:measure}.

{phang}
{cmd:proportions}
    is for use with binary similarity {it:measure}s.  It specifies that values
    be interpreted as proportions of binary values.  The default action
    treats all nonzero values as one (excluding missing values).  With
    {cmd:proportions}, the values are confirmed to be between zero and one,
    inclusive.  See {manhelpi measure_option MV} for a discussion of the use of
    proportions with binary {it:measure}s.  {cmd:proportions} is not allowed
    with {cmd:allbinary} or the {cmd:Gower} {it:measure}.

{phang}
{marker method}{...}
{opt dissim(method)}
    specifies that similarity measures be transformed into
    dissimilarity measures.  {it:method} may be {cmd:oneminus} or
    {cmd:standard}.  {cmd:oneminus} transforms similarities to dissimilarities
    by using d_ij = 1-s_ij
    ({help matrix dissimilarity##KR1990:Kaufman and Rousseeuw 1990, 21}).
    {cmd:standard} uses d_ij = sqrt(s_ii+s_jj-2*s_ij)
    ({help matrix dissimilarity##MKB1979:Mardia, Kent, and Bibby 1979, 402}).
    {cmd:dissim()} does nothing when the {it:measure} is already a
    dissimilarity or distance.  See {manhelpi measure_option MV} to see which
    {it:measure}s are similarities.


{marker remarks}{...}
{title:Remarks}

{pstd}
The similarity or dissimilarity between each observation (or variable
if the {cmd:variables} option is specified) and the others is placed in
{it:matname}.  The element in the {it:i}th row and {it:j}th column gives
either the similarity or dissimilarity between the {it:i}th and {it:j}th
observation (or variable).  Whether you get a similarity or a dissimilarity
depends upon the requested {it:measure}; see {manhelpi measure_option MV}.

{pstd}
If the number of observations (or variables) is so large that storing the
results in a matrix is not practical, you may wish to consider using the
{cmd:cluster measures} command, which stores similarities or dissimilarities
in variables; see
{manhelp cluster_programming MV:cluster programming utilities}.

{pstd}
When computing similarities or dissimilarities between observations, the
default row and column names of {it:matname} are set to {cmd:obs}{it:#},
where {it:#} is the observation number.  The 
{helpb matrix dissimilarity##names():names()} option allows you
to override this default.  For similarities or dissimilarities between
variables, the row and column names of {it:matname} are set to the appropriate
variable names.

{pstd}
The order of the rows and columns corresponds with the order of your
observations when you are computing similarities or dissimilarities between
observations.  Warning: If you reorder your data (for example, using
{cmd:sort} or {cmd:gsort}) after running {cmd:matrix dissimilarity}, the
row and column ordering will no longer match your data.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse labtech}

{pstd}Create matrix {cmd:De} holding the Euclidean distance between all the
observations for variables {cmd:x1}, {cmd:x2}, and {cmd:x3}{p_end}
{phang2}{cmd:. matrix dissimilarity De = x1 x2 x3}

{pstd}List the result{p_end}
{phang2}{cmd:. mat list De}

{pstd}Create matrix {cmd:Dc} holding the Canberra distance between all the
observations for variables {cmd:x1}, {cmd:x2}, and {cmd:x3}{p_end}
{phang2}{cmd:. matrix dis Dc = x1 x2 x3, Canberra}

{pstd}List the result{p_end}
{phang2}{cmd:. mat list Dc}

{pstd}Create matrix {cmd:Dcvars} holding the Canberra distance between all the
variables{p_end}
{phang2}{cmd:. mat dis Dcvars = , Canberra variables}

{pstd}List the result{p_end}
{phang2}{cmd:. mat list Dcvars}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse homework}

{pstd}Create matrix {cmd:M} holding the matching coefficient similarity
measure between the last five observations for variables {cmd:a1} through
{cmd:a5}{p_end}
{phang2}{cmd:. mat dis M = a1-a5 in -5/L, matching}

{pstd}List the result{p_end}
{phang2}{cmd:. mat list M}

{pstd}Drop matrix M{p_end}
{phang2}{cmd:. mat drop M}

{pstd}Same as above {cmd:matrix dissimilarity} command, but also verify that
the data are binary{p_end}
{phang2}{cmd:. mat dis M = a1-a5 in -5/L, matching allbinary}{p_end}
    {hline}


{marker references}{...}
{title:References}

{marker KR1990}{...}
{phang}
Kaufman, L., and P. J. Rousseeuw. 1990.
{it:Finding Groups in Data: An Introduction to Cluster Analysis}.
New York: Wiley.

{marker MKB1979}{...}
{phang}
Mardia, K. V., J. T. Kent, and J. M. Bibby. 1979.
{it:Multivariate Analysis}.  New York: Academic Press.
{p_end}
