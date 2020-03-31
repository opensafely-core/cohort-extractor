{smcl}
{* *! version 1.1.11  11may2018}{...}
{viewerdialog corr2data "dialog corr2data"}{...}
{vieweralsosee "[D] corr2data" "mansection D corr2data"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] Data types" "help data_types"}{...}
{vieweralsosee "[D] drawnorm" "help drawnorm"}{...}
{viewerjumpto "Syntax" "corr2data##syntax"}{...}
{viewerjumpto "Menu" "corr2data##menu"}{...}
{viewerjumpto "Description" "corr2data##description"}{...}
{viewerjumpto "Links to PDF documentation" "corr2data##linkspdf"}{...}
{viewerjumpto "Options" "corr2data##options"}{...}
{viewerjumpto "Examples" "corr2data##examples"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[D] corr2data} {hline 2}}Create dataset with specified
correlation structure{p_end}
{p2col:}({mansection D corr2data:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:corr2data}
{it:{help varlist:newvarlist}}
[{cmd:,}
{it:options}]

{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt clear}}replace the current dataset{p_end}
{synopt :{opt d:ouble}}generate variable type as {opt double}; default is
{opt float}{p_end}
{synopt :{opt n(#)}}generate {it:#} observations; default is current
number{p_end}
{synopt :{opt sd:s(vector)}}standard deviations of generated variables{p_end}
{synopt :{opt corr(matrix|vector)}}correlation matrix{p_end}
{synopt :{opt cov(matrix|vector)}}covariance matrix{p_end}
{synopt :{cmdab:cs:torage(}{cmdab:f:ull)}}store correlation/covariance
structure as a symmetric k*k matrix{p_end}
{synopt :{cmdab:cs:torage(}{cmdab:l:ower)}}store correlation/covariance
structure as a lower triangular matrix{p_end}
{synopt :{cmdab:cs:torage(}{cmdab:u:pper)}}store correlation/covariance
structure as an upper triangular matrix{p_end}
{synopt :{opt forcepsd}}force the covariance/correlation matrix to be 
positive semidefinite{p_end}
{synopt :{opt m:eans(vector)}}means of generated variables; default is
{cmd:means(0)}{p_end}

{syntab :Options}
{synopt :{opt seed(#)}}seed for random-number generator{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Other variable-creation commands >}
     {bf:Create dataset with specified correlation}


{marker description}{...}
{title:Description}

{pstd}
{opt corr2data} adds new variables with specified covariance (correlation) 
structure to the existing dataset or creates a new dataset with a specified 
covariance (correlation) structure.  Singular covariance (correlation) 
structures are permitted.  The purpose of this is to allow you to perform 
analyses from summary statistics (correlations/covariances and maybe 
the means) when these summary statistics are all you know and summary 
statistics are sufficient to obtain results.  For example, these summary 
statistics are sufficient for performing analysis of t tests, variance,
principal components, regression, and factor analysis. The
recommended process is

      {cmd:. clear}                             (clear memory)
      {cmd:. corr2data} ...{cmd:,} {opt n(#)} {opt cov(...)} ...  (create artificial data)
      {cmd:. regress} ...                       (use artificial data appropriately)

{pstd}
However, for factor analyses and principal components, the commands
{cmd:factormat} and {cmd:pcamat} allow you to skip the step of using
{cmd:corr2data}; see {manhelp factor MV} and {manhelp pca MV}.

{pstd}
The data created by {cmd:corr2data} are artificial; they are not the original
data, and it is not a sample from an underlying population with the summary
statistics specified.  See {manhelp drawnorm D} if you want to generate a
random sample.  In a sample, the summary statistics will differ from the
population values and will differ from one sample to the next.

{pstd}
The dataset {cmd:corr2data} creates is suitable for one purpose only:
performing analyses when all that is known are summary statistics and those
summary statistics are sufficient for the analysis at hand.  The artificial
data tricks the analysis command into producing the desired result.  The
analysis command, being by assumption only a function of the summary
statistics, extracts from the artificial data the summary statistics, which
are the same summary statistics you specified, and then makes its calculation
based on those statistics.

{pstd}
If you doubt whether the analysis depends only on the specified summary 
statistics, you can generate different artificial datasets by using different 
seeds of the random-number generator (see the
{helpb corr2data##seed():seed()} option below) and 
compare the results, which should be the same within rounding error.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D corr2dataQuickstart:Quick start}

        {mansection D corr2dataRemarksandexamples:Remarks and examples}

        {mansection D corr2dataMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt clear} specifies that it is okay to replace the dataset in memory,
even though the current dataset has not been saved on disk.

{phang}
{opt double} specifies that the new variables be stored as Stata
{opt double}s, meaning 8-byte reals.  If {opt double} is not specified,
variables are stored as {opt float}s, meaning 4-byte reals.  See 
{manhelp data_types D:Data types}.

{phang}
{opt n(#)} specifies the number of observations to be
generated; the default
is the current number of observations.  If {opt n(#)} is not specified or
is the same as the current number of observations, {opt corr2data}
adds the new variables to the existing dataset; otherwise, {opt corr2data}
replaces the dataset in memory.

{phang}{opt sds(vector)} specifies the standard deviations of the
generated variables.  {opt sds()} may not be specified with {opt cov()}.

{phang}
{opt corr(matrix|vector)}
specifies the correlation matrix.
If neither {opt corr()} nor {opt cov()} is specified,
the default is orthogonal data.

{phang}
{opt cov(matrix|vector)} specifies the covariance matrix.
If neither {opt corr()} nor {opt cov()} is specified,
the default is orthogonal data.

{phang}
{cmd:cstorage(full}|{cmd:lower}|{cmd:upper)}
specifies the storage mode for the correlation or covariance structure in
{opt corr()} or {opt cov()}.  The following storage modes are supported:

{pmore}
{opt full} specifies that the correlation or covariance structure
is stored (recorded) as a symmetric k*k matrix.

{pmore}
{opt lower} specifies that the correlation or covariance structure is recorded
as a lower triangular matrix.  With k variables, the
matrix should have k(k+1)/2 elements in the following order:

{p 16 20 2}
C(11) C(21) C(22) C(31) C(32) C(33) ... C(k1) C(k2) ... C(kk)

{pmore}
{opt upper} specifies that the correlation or covariance structure is recorded
as an upper triangular matrix.  With k variables, the
matrix should have k(k+1)/2 elements in the following order:

{p 16 20 2}
C(11) C(12) (C13) ... C(1k) C(22) C(23) ... C(2k) ...
C(k-1k-1) C(k-1k) C(kk)

{pmore}
Specifying {cmd:cstorage(full)} is optional if the matrix is square.
{cmd:cstorage(lower)} or {cmd:cstorage(upper)} is required for the vectorized
storage methods.  See {help storage modes} for examples.

{phang}
{opt forcepsd} modifies the matrix C to be positive semidefinite (psd) and 
to thus be a proper covariance matrix.  If C is not positive semidefinite,
it will have negative eigenvalues.  By setting the negative eigenvalues
to 0 and reconstructing, we obtain the least-squares positive-semidefinite
approximation to C.  This approximation is a singular covariance matrix.

{phang}
{opt means(vector)} specifies the means of the generated variables.
The default is {cmd:means(0)}.

{dlgtab:Options}

{marker seed()}{...}
{phang}
{opt seed(#)}
specifies the seed of the random-number generator used to generate
data.  {it:#} defaults to 0.  The random numbers generated inside
{opt corr2data} do not affect the seed of the standard random-number generator.


{marker examples}{...}
{title:Examples}

{pstd}Create new dataset with 2000 observations having mean and standard
deviation for {cmd:x} of 2 and .5 and for {cmd:y} of 3 and 2{p_end}
{phang2}{cmd:. corr2data x y, n(2000) means(2 3) sds(.5 2)}{p_end}

{pstd}Display summary statistics{p_end}
{phang2}{cmd:. summarize}{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. clear}{p_end}
{phang2}{cmd:. matrix C = (1, .5 \ .5, 1)}{p_end}

{pstd}Create new dataset with 2000 observations with variables {cmd:x} and
{cmd:y} correlated as defined by matrix {cmd:C}{p_end}
{phang2}{cmd:. corr2data x y, n(2000) corr(C)}{p_end}

{pstd}Display correlation matrix{p_end}
{phang2}{cmd:. correlate x y}{p_end}
