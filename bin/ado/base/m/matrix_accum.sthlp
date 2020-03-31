{smcl}
{* *! version 1.1.16  15may2018}{...}
{vieweralsosee "[P] matrix accum" "mansection P matrixaccum"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "[R] ml" "help ml"}{...}
{vieweralsosee "[M-4] Statistical" "help m4_statistical"}{...}
{viewerjumpto "Syntax" "matrix_accum##syntax"}{...}
{viewerjumpto "Description" "matrix_accum##description"}{...}
{viewerjumpto "Links to PDF documentation" "matrix_accum##linkspdf"}{...}
{viewerjumpto "Options" "matrix_accum##options"}{...}
{viewerjumpto "Examples" "matrix_accum##examples"}{...}
{viewerjumpto "Stored results" "matrix_accum##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[P] matrix accum} {hline 2}}Form cross-product matrices{p_end}
{p2col:}({mansection P matrixaccum:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Accumulate cross-product matrices to form X'X

{p 8 25 2}{cmdab:mat:rix} {cmdab:ac:cum} {it:A} {cmd:=} {varlist}
	{ifin}
        [{it:{help matrix accum##weight:weight}}]
	[{cmd:,} {cmdab:nocons:tant} {cmdab:d:eviations}
	{cmdab:m:eans:(}{it:M}{cmd:)} {opth abs:orb(varname)}]


    Accumulate cross-product matrices to form X'BX

{p 8 25 2}{cmdab:mat:rix} {cmdab:glsa:ccum} {it:A} {cmd:=} {varlist}
	{ifin}
        [{it:{help matrix accum##weight:weight}}]{cmd:,}
	{cmdab:gr:oup:(}{it:{help varlist:groupvar}}{cmd:)}
	{cmdab:gl:smat:(}{it:W}|{it:stringvar}{cmd:)}
	{cmdab:r:ow:(}{it:rowvar}{cmd:)} [{cmdab:nocons:tant}]


    Accumulate cross-product matrices to form sum[(X_i)'e_i(e_i)'X_i]

{p 8 25 2}{cmdab:mat:rix} {cmd:opaccum} {it:A} {cmd:=} {varlist}
	{ifin} {cmd:,} {cmdab:gr:oup:(}{it:{help varlist:groupvar}}{cmd:)}
	{cmdab:op:var:(}{it:opvar}{cmd:)} [{cmdab:nocons:tant}]


    Accumulate first variable against remaining variables

{p 8 25 2}{cmdab:mat:rix} {cmdab:veca:ccum} {it:a} {cmd:=} {varlist}
	{ifin}
        [{it:{help matrix accum##weight:weight}}]
        [{cmd:,} {cmdab:nocons:tant}]


{phang}
{it:varlist} in {cmd:matrix accum} and in {cmd:matrix vecaccum} may contain
factor variables (except for the first variable in {cmd:matrix vecaccum}
{it:varlist}); see {help fvvarlist}.{p_end}
{phang}
{it:varlist} may contain time-series operators; see {help tsvarlist}.{p_end}
{marker weight}{...}
{phang}
{cmd:aweight}s, {cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are
allowed; see {help weight}.{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:matrix accum} accumulates cross-product matrices from the data to form
{it:A} = X'X.

{pstd}
{cmd:matrix glsaccum} accumulates cross-product matrices from the data
by using a specified inner weight matrix to form {it:A} = X'{it:B}X, where
{it:B} is a block diagonal matrix.

{pstd}
{cmd:matrix opaccum} accumulates cross-product matrices from the data by using
an inner weight matrix formed from the outer product of a variable in the
data to form

{center:A = X1'e1e1'X1 + X2'e2e2'X2 + ... + X{it:k}'e{it:k}e{it:k}'X{it:k}}

{pstd}
where X{it:i} is a matrix of observations from the {it:i}th group of the
{varlist} variables and e{it:i} is a vector formed from the observations
in the {it:i}th group of the {it:opvar} variable.

{pstd}
{cmd:matrix vecaccum} accumulates the first variable against the remaining
variables in {it:varlist} to form a row vector of accumulated inner products to
form {it:a} = x1'X, where X = (x2, x3,...).

{pstd}
Also see {bf:{help mf_cross:[M-5] cross()}} for other routines for forming
cross-product matrices.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P matrixaccumRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:noconstant} suppresses the addition of a "constant" to the X
matrix.  If {cmd:noconstant} is not specified, it is as if a column of 1s is
added to X before the accumulation begins.

{phang}
{cmd:deviations}, allowed only with {cmd:matrix accum}, causes the
accumulation to be performed in terms of deviations from the mean.  If
{cmd:noconstant} is not specified, the accumulation of X is done in terms of
deviations, but the added row and column of sums are not in deviation format
(in which case they would be zeros).  With {cmd:noconstant} specified, the
resulting matrix divided through by N-1, where N is the number of
observations, is a covariance matrix.

{phang}
{cmd:means(}{it:M}{cmd:)}, allowed only with {cmd:matrix accum}, creates
matrix {it:M}:  1 x (p+1) or 1 x p (depending on whether {cmd:noconstant} is
also specified) containing the means of X.

{phang}
{opth absorb:(varname)}, allowed only with {cmd:matrix accum}, specifies that
{cmd:matrix accum} compute the accumulations in terms of deviations from
the mean within the absorption groups identified by {it:varname}.

{phang}
{cmd:group(}{it:{help varlist:groupvar}}{cmd:)} is required with
{cmd:matrix glsaccum} and {cmd:matrix opaccum} and is not allowed otherwise.
In the two cases where it is required, it specifies the name of a variable
that identifies groups of observations.  The data must be sorted by
{it:groupvar}.

{pmore}
In {cmd:matrix glsaccum}, {it:groupvar} identifies the observations to be
individually weighted by {cmd:glsmat()}.

{pmore}
In {cmd:matrix opaccum}, {it:groupvar} identifies the observations to be
weighted by the outer product of {cmd:opvar()}.

{phang}
{cmd:glsmat(}{it:W}|{it:stringvar}{cmd:)}, required with
{cmd:matrix glsaccum} and not allowed otherwise, specifies the name of the
matrix or the name of a string variable in the dataset that contains the name
of the matrix that is to be used to weight the observations in {cmd:group()}.
{it:stringvar} must be {cmd:str8} or less.

{phang}
{cmd:row(}{it:rowvar}{cmd:)}, required with {cmd:matrix glsaccum} and not
allowed otherwise, specifies the name of a numeric variable containing the row
numbers that specify the row and column of the {cmd:glsmat()} matrix to use in
the inner-product calculation.

{phang}
{cmd:opvar(}{it:opvar}{cmd:)}, required with {cmd:matrix opaccum}, specifies
the variable used to form the vector whose outer product forms the weighting
matrix.


{marker examples}{...}
{title:Examples}

    {cmd:. sysuse auto}
    {cmd:. matrix accum A = price weight mpg}
    {cmd:. matrix list A}
    {cmd:. matrix accum Cov = price weight mpg, deviations noconstant}
    {cmd:. matrix Cov = Cov/(r(N)-1)}
    {cmd:. matrix list Cov}

    {cmd:. webuse maccumxmpl}
    {cmd:. xtdescribe, patterns(11)}
    {cmd:. sort id t}
    {cmd:. matrix opaccum B = x1 x2, group(id) opvar(e)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:matrix accum}, {cmd:matrix glsaccum}, {cmd:matrix opaccum}, and
{cmd:matrix vecaccum} store the number of observations in {cmd:r(N)}.
{cmd:matrix accum} stores the number of absorption groups in {cmd:r(k_absorb)}.
{cmd:matrix glsaccum} (with {cmd:aweight}s) and
{cmd:matrix vecaccum} also store the sum of the weight in {cmd:r(sum_w)}, but
{cmd:matrix accum} does not.
{p_end}
