{smcl}
{* *! version 1.1.5  19oct2017}{...}
{vieweralsosee "[P] matrix score" "mansection P matrixscore"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{viewerjumpto "Syntax" "matrix_score##syntax"}{...}
{viewerjumpto "Description" "matrix_score##description"}{...}
{viewerjumpto "Links to PDF documentation" "matrix_score##linkspdf"}{...}
{viewerjumpto "Options" "matrix_score##options"}{...}
{viewerjumpto "Example" "matrix_score##example"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[P] matrix score} {hline 2}}Score data from coefficient vectors{p_end}
{p2col:}({mansection P matrixscore:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}{cmdab:mat:rix} {cmdab:sco:re} {dtype} {newvar} {cmd:=} {it:b}
		{ifin} [{cmd:,}
		{cmdab:eq:uation:(}{cmd:#}{it:#}|{it:eqname}{cmd:)}
		{cmdab:m:issval:(}{it:#}{cmd:)} {cmd:replace} {cmd:forcezero}]

{pstd}
where {it:b} is a 1 x p matrix.


{marker description}{...}
{title:Description}

{pstd}
{cmd:matrix score} creates {newvar} = {it:x_j}{it:b}' ({it:b} being a row
vector), where {it:x_j} is the row vector of values of the variables specified
by the column names of {it:b}.  The name {hi:_cons} is treated as a variable
equal to 1.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P matrixscoreRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:equation(}{cmd:#}{it:#}|{it:eqname}{cmd:)} specifies the
equation -- by either number or name -- for selecting coefficients
from {it:b} to use in scoring. See
{manhelp matrix_rownames P:matrix rownames} for
more on equation labels with matrices.

{phang}
{cmd:missval(}{it:#}{cmd:)} specifies the value to be assumed if any
values are missing from the variables referred to by the coefficient vector.
By default, this value is taken to be missing (.), and any missing value among
the variables produces a missing score.

{phang}
{cmd:replace} specifies that {newvar} already exists. Here 
observations not included by {cmd:if} {it:exp} and {cmd:in} {it:range} are
left unchanged; that is, they are not changed to missing.  Be warned that
{cmd:replace} does not promote the storage type of the existing variable; if
the variable was stored as an {cmd:int}, the calculated scores would be truncated to
integers when stored.

{phang}
{cmd:forcezero} specifies that, should a variable described by the column
  names of {it:b} not exist, the calculation treat the missing variable
  as if it did exist and was equal to zero for all observations.  
  It contributes nothing to the summation.  By default, a missing
  variable would produce an error message.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress price weight mpg}

{pstd}Define matrix {cmd:coefs} equal to {cmd:e(b)}, the coefficient vector
{p_end}
{phang2}{cmd:. matrix coefs = e(b)}

{pstd}List the contents of {cmd:coefs}{p_end}
{phang2}{cmd:. mat list coefs}

{pstd}Create variable {cmd:lc} containing the linear predictions{p_end}
{phang2}{cmd:. matrix score lc = coefs}

{pstd}Summarize {cmd:lc}{p_end}
{phang2}{cmd:. summarize lc}

{pstd}Setup{p_end}
{phang2}{cmd:. sureg (price weight mpg) (displacement weight)}

{pstd}Define matrix {cmd:coefs} equal to {cmd:e(b)}, the coefficient
vector{p_end}
{phang2}{cmd:. matrix coefs = e(b)}

{pstd}List the contents of {cmd:coefs}{p_end}
{phang2}{cmd:. mat list coefs}

{pstd}Create variable {cmd:lca} containing the linear predictions for equation 
{cmd:price}{p_end}
{phang2}{cmd:. matrix score lca = coefs, eq(price)}

{pstd}Same as above command{p_end}
{phang2}{cmd:. matrix score lc1 = coefs, eq(#1)}

{pstd}Same as above command{p_end}
{phang2}{cmd:. matrix score lcnoeq = coefs}

{pstd}Create variable {cmd:lcb} containing the linear predictions for equation 
{cmd:displacement}{p_end}
{phang2}{cmd:. matrix score lcb = coefs, eq(displacement)}

{pstd}Same as above command{p_end}
{phang2}{cmd:. matrix score lc2 = coefs, eq(#2)}

{pstd}Summarize newly created variables{p_end}
{phang2}{cmd:. summarize lc*}{p_end}
