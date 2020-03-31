{smcl}
{* *! version 1.0.9  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] factor" "help factor"}{...}
{vieweralsosee "[MV] pca" "help pca"}{...}
{viewerjumpto "Syntax" "_getcovcorr##syntax"}{...}
{viewerjumpto "Description" "_getcovcorr##description"}{...}
{viewerjumpto "Options" "_getcovcorr##options"}{...}
{viewerjumpto "Remarks" "_getcovcorr##remarks"}{...}
{viewerjumpto "Stored results" "_getcovcorr##results"}{...}
{title:Title}

{p2colset 5 24 26 2}{...}
{p2col:{hi:[P] _getcovcorr} {hline 2}}Programmer's utility for parsing
correlation and covariance matrix options{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 20 2}
{cmd:_getcovcorr} {it:matname} [ {cmd:,} {it:options} ]

{p2colset 5 26 28 2}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{opt cor:relation}}return a correlation matrix{p_end}
{p2col:{opt cov:ariance}}return a covariance matrix{p_end}
{p2col:{opt sh:ape(shape)}}shape (storage method) of {it:matname}{p_end}
{p2col:{opt nam:es(namelist)}}namelist; required with vectorized input{p_end}
{p2col:{opt sds(vector)}}vector of standard deviations{p_end}
{p2col:{opt me:ans(vector)}}vector of means{p_end}
{p2col:{opt force}}fixes input problems in names (see below){p_end}
{p2col:{opt check(pd)}}checks that {it:matname} is positive definite{p_end}
{p2col:{opt check(psd)}}checks that {it:matname} is positive semidefinite{p_end}
{p2col:{opt forcepsd}}modifies {it:matname} to be positive semidefinite{p_end}
{p2col:{opt tol(#)}}tolerance for checking eigenvalues (see below){p_end}
{p2line}

{p2col:{it:shape}}{it:matname} is stored as a{p_end}
{p2line}
{p2col:{opt f:ull}}square symmetric matrix{p_end}
{p2col:{opt l:ower}}vector of rowwise lower triangle (with diagonal){p_end}
{p2col:{opt u:pper}}vector of rowwise lower triangle (with diagonal){p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_getcovcorr} processes the options related to correlation or covariance
matrices, checks for errors, and returns the information in standard form in
{cmd:r()}.  The options processed by {cmd:_getcovcorr} allow users to specify
the correlation or covariance matrix {it:matname} in several ways.  It can be
a square symmetric matrix, or a vector representing the lower or upper triangle
of the matrix.


{marker options}{...}
{title:Options}

{phang}
{opt correlation} and {opt covariance}
    declare that a correlation or covariance matrix is to be returned in
    {cmd:r(C)} and that {cmd:r(Ctype)} is to be set to "{cmd:correlation}" or
    "{cmd:covariance}", respectively.

{pmore}
    By default, if {it:matname} represents a correlation matrix, a correlation
    matrix will be returned.  Likewise, if {it:matname} represents a
    covariance matrix, a covariance matrix will be returned.
    {cmd:correlation} and {cmd:covariance} may be used to override the
    default.

{pmore}
    If {it:matname} represents a correlation matrix, and you specify the
    {cmd:covariance} option, then you must also provide the standard
    deviations with the {cmd:sds()} option.

{phang}
{opt shape(mode)}
    specifies the shape or storage method for the covariance or correlation
    matrix {it:matname}.  The following storage methods are supported:

{phang2}
    {opt full}
    specifies that {it:matname} is stored as a symmetric {it:k}x{it:k} matrix.

{phang2}
    {opt lower}
    specifies that {it:matname} is stored in a vector in rowwise
    lower-triangle order.  The vector is verified to have {it:k}({it:k}+1)/2
    elements (representing {it:k} variables), and are placed in the following
    order:

{pin3}
	C(11) C(21) C(22) C(31) C(32) C(33) ... C({it:k}1)
	C({it:k}2) ... C({it:k}{it:k})

{phang2}
{opt upper}
    specifies that {it:matname} is recorded in a vector in rowwise
    upper-triangle order.  The vector is verified to have {it:k}({it:k}+1)/2
    elements (representing {it:k} variables), and are placed in the following
    order:

{pin3}
	C(11) C(12) C(13) ... C(1{it:k})
	C(22) C(23) ... C(2{it:k}) ... C({it:k}-1{it:k}-1)
	C({it:k}-1{it:k}) C({it:k}{it:k})

{pmore}
    Specifying {cmd:shape(full)} is optional if {it:matname} is square.
    Specifying either {cmd:shape(lower)} or {cmd:shape(upper)} is required 
    for the vectorized storage methods.  See {help storage modes} for examples.

{phang}
{opt names(namelist)}
    specifies a list of {it:k} different names for the row and column names of
    {cmd:r(C)}.  {cmd:names()} is required with {cmd:cstorage(lower)} or
    {cmd:cstorage(upper)}.  {opt names()} implies {opt force}.

{phang}
{opt sds(vector)},
    a row or column vector with {it:k} positive elements, specifies the
    standard deviations, and is allowed only when {it:matname} is represented
    as a correlation matrix.  The standard deviations are returned in the row
    vector {cmd:r(sds)}.

{phang}
{opt means(vector)},
    a row or column vector with {it:k} elements, specifies the means
    corresponding with the correlation or covariance matrix.  This is not used
    in the construction of {cmd:r(C)}, but is checked for conformability.
    The means are returned in the row vector {cmd:r(means)}.

{phang}
{opt force} suppresses the check that matrix name stripes match.  The option
    {opt names()} automatically implies {opt force}.
    
{phang}
{opt check(opt)} specifies a check to be performed on {it:matname}.
    
{phang2}    
    {opt pd} verifies that {it:matname} is positive definite; that is, all 
    eigenvalues are "really positive" (see option {opt tol()}).
    
{phang2}
    {opt psd} verifies that {it:matname} is positive semidefinite; that is, 
    none of the eigenvalues of {it:matname} are "really negative"
    (see option {opt tol()}).

{phang}    
    {opt forcepsd} makes sure that {it:matname} is positive semidefinite by 
    replacing negative eigenvalues with 0.  The number of "really negative" 
    eigenvalues is reported.
    
{phang}
{opt tol(tol)} specifies a tolerance for classifying the sign of an eigenvalue
{it:ev} as 

	    really positive         {it:ev} > {it:etol}
	    really negative         {it:ev} < -{it:etol} 
    	    possibly 0             -{it:etol} <= {it:ev} <= {it:etol} 
    	
{phang2}
where {it:etol} = {it:tol}*{it:mev}, with {it:mev} the maximum absolute 
eigenvalue of {it:matname}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:_getcovcorr} does the following.

{phang}
1.  If {it:matname} is a vector, the corresponding full symmetric matrix is
    constructed.  This matrix may represent either a covariance or correlation
    matrix.

{phang}
2.  From the input covariance or correlation matrix one of the following is
    constructed.

{phang2}
    A.  A correlation matrix (if {cmd:correlation} was specified).

{phang2}
    B.  A covariance matrix (if {cmd:covariance} was specified).  If
        {it:matname} represents a correlation matrix, then a covariance is
        constructed from {it:matname} using the standard deviations provided
        by {cmd:sds()}.

{pmore}
    The resulting matrix is checked for symmetry and that diagonal elements
    are strictly positive (1 if {cmd:correlation}).

{phang}
3.  An error message is produced if {it:matname}, {cmd:sds()}, or
    {cmd:means()} contain {help missing:missing values} or are not
    conformable.  Unless {cmd:force} or {cmd:names()} are specified, an error
    is also produced if the name stripes do not agree.

{phang}
4.  {cmd:r(means)} and {cmd:r(sds)} are returned as row vectors if
    {cmd:means()} and {cmd:sds()} are specified.


{marker results}{...}
{title:Stored results}

    {cmd:_getcovcorr} stores in {cmd:r()}:

	Macro
	    {cmd:r(Ctype)}	{cmd:correlation} or {cmd:covariance}

	Matrices
	    {cmd:r(C)}		the correlation or covariance matrix
	    {cmd:r(sds)}	vector of std deviations (if {cmd:sds()} specified)
	    {cmd:r(means)}	vector of means (if {cmd:means()} specified)

	Scalars
	    {cmd:r(npos)}       number of positive eigenvalues of C
