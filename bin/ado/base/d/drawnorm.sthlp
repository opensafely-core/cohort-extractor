{smcl}
{* *! version 1.1.13  11may2018}{...}
{viewerdialog drawnorm "dialog drawnorm"}{...}
{vieweralsosee "[D] drawnorm" "mansection D drawnorm"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] corr2data" "help corr2data"}{...}
{vieweralsosee "[R] set seed" "help set_seed"}{...}
{viewerjumpto "Syntax" "drawnorm##syntax"}{...}
{viewerjumpto "Menu" "drawnorm##menu"}{...}
{viewerjumpto "Description" "drawnorm##description"}{...}
{viewerjumpto "Links to PDF documentation" "drawnorm##linkspdf"}{...}
{viewerjumpto "Options" "drawnorm##options"}{...}
{viewerjumpto "Examples" "drawnorm##examples"}{...}
{p2colset 1 17 20 2}{...}
{p2col:{bf:[D] drawnorm} {hline 2}}Draw sample from multivariate normal distribution{p_end}
{p2col:}({mansection D drawnorm:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}{cmd:drawnorm} {it:{help newvarlist}}
[{cmd:,} {it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt clear}}replace the current dataset{p_end}
{synopt :{opt d:ouble}}generate variable type as {opt double}; default is {opt float}{p_end}
{synopt :{opt n(#)}}generate {it:#} observations; default is current number{p_end}
{synopt :{opt sd:s(vector)}}standard deviations of generated variables{p_end}
{synopt :{opt corr(matrix|vector)}}correlation matrix{p_end}
{synopt :{opt cov(matrix|vector)}}covariance matrix{p_end}
{synopt :{cmdab:cs:torage:(}{cmdab:f:ull)}}store correlation/covariance structure as a symmetric k*k matrix{p_end}
{synopt :{cmdab:cs:torage:(}{cmdab:l:ower)}}store correlation/covariance structure as a lower triangular matrix{p_end}
{synopt :{cmdab:cs:torage:(}{cmdab:u:pper}{cmd:)}}store correlation/covariance structure as an upper triangular matrix{p_end}
{synopt :{opt forcepsd}}force the covariance/correlation matrix to be positive semidefinite{p_end}
{synopt :{opt m:eans(vector)}}means of generated variables; default is {cmd:means(0)}{p_end}

{syntab :Options}
{synopt :{opt seed(#)}}seed for random-number generator{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Other variable-creation commands >}
         {bf:Draw sample from normal distribution}


{marker description}{...}
{title:Description}

{pstd}
{cmd:drawnorm} draws a sample from a multivariate normal distribution with
desired means and covariance matrix.  The default is orthogonal data with mean
0 and variance 1.  The covariance matrix may be singular.  The values generated 
are a function of the current random-number seed or the number specified with 
{cmd:set seed()}; see {manhelp set_seed R:set seed}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D drawnormQuickstart:Quick start}

        {mansection D drawnormRemarksandexamples:Remarks and examples}

        {mansection D drawnormMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt clear} specifies that the dataset in memory be replaced, even though the
current dataset has not been saved on disk.

{phang}
{opt double} specifies that the new variables be stored as Stata
{opt double}s, meaning 8-byte reals. If {opt double} is not specified,
variables are stored as {opt float}s, meaning 4-byte reals. See 
{manhelp data_types D:Data types}.

{phang}
{opt n(#)} specifies the number of observations to be
generated.  The default is the current number of observations.  If {opt n(#)}
is not specified or is the same as the current number of observations,
{opt drawnorm} adds the new variables to the existing dataset; otherwise,
{opt drawnorm} replaces the data in memory.

{phang}
{opt sds(vector)} specifies
the standard deviations of the generated variables.  {opt sds()} may not be
specified with {opt cov()}.

{phang}
{opt corr(matrix|vector)} specifies the correlation matrix.
If neither {opt corr()} nor {opt cov()} is
specified, the default is orthogonal data.

{phang}
{opt cov(matrix|vector)} specifies the covariance matrix.
If neither {opt cov()} nor {opt corr()} is
specified, the default is orthogonal data.

{phang}
{cmd:cstorage(full}|{cmd:lower}|{cmd:upper)}
specifies the storage mode for the correlation or covariance structure in
{opt corr()} or {opt cov()}.  The following storage modes are supported:

{phang2}
{opt full} specifies that the correlation or covariance structure
is stored (recorded) as a symmetric k*k matrix.

{phang2}
{opt lower} specifies that the correlation or covariance structure is recorded
as a lower triangular matrix.  With k variables, the matrix
should have k(k+1)/2 elements in the following order:

{p 16 20 2}
C(11) C(21) C(22) C(31) C(32) C(33) ... C(k1) C(k2) ... C(kk)

{phang2}
{opt upper} specifies that the correlation or covariance structure is recorded
as an upper triangular matrix.  With k variables, the
matrix should have k(k+1)/2 elements in the following order:

{p 16 20 2}
C(11) C(12) C(13) ... C(1k) C(22) C(23) ... C(2k) ...
C(k-1k-1) C(k-1k) C(kk)

{pmore}
Specifying {cmd:cstorage(full)} is optional if the matrix is square.
{cmd:cstorage(lower)} or {cmd:cstorage(upper)} is required for the vectorized
storage methods.   See {help storage modes} for examples.

{phang}
{opt forcepsd} modifies the matrix C to be positive semidefinite (psd), and 
so be a proper covariance matrix.  If C is not positive semidefinite, it
will have negative eigenvalues.  By setting negative eigenvalues to 0
and reconstructing, we obtain the least-squares positive-semidefinite
approximation to C.  This approximation is a singular covariance matrix.

{phang}
{opt means(vector)} specifies the means of the generated variables.  The
default is {cmd:means(0)}.

{dlgtab:Options}

{phang}
{opt seed(#)} specifies the initial value of the
random-number seed used by the {opt runiform()} function.  The default is the
current random-number seed.  Specifying {opt seed(#)} is the same
as typing {cmd:set seed} {it:#} before issuing the {cmd:drawnorm} command.
{p_end}


{marker examples}{...}
{title:Examples}

{pstd}
Generate 2,000 independent observations ({cmd:x},{cmd:y});
{cmd:x} with mean 2 and standard deviation .5;
{cmd:y} with mean 3 and standard deviation 2

{phang2}{cmd:. matrix m = (2,3)}{p_end}
{phang2}{cmd:. matrix sd = (.5,2)}{p_end}
{phang2}{cmd:. drawnorm x y, n(2000) means(m) sds(sd)}{p_end}
{phang2}{cmd:. summarize}

{pstd}
Draw a sample of 1,000 observations from a bivariate standard normal
distribution, with correlation 0.5

{phang2}{cmd:. clear}{p_end}
{phang2}{cmd:. matrix C = (1, .5 \ .5, 1)}{p_end}
{phang2}{cmd:. drawnorm x y, n(1000) corr(C)}{p_end}
{phang2}{cmd:. summarize}{p_end}

{pstd}
Equivalently,

{phang2}{cmd:. clear}{p_end}
{phang2}{cmd:. matrix C = (1, .5, 1)}{p_end}
{phang2}{cmd:. drawnorm x y, n(1000) corr(C) cstorage(lower)}{p_end}
{phang2}{cmd:. summarize}{p_end}
