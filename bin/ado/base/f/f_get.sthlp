{smcl}
{* *! version 1.1.4  19oct2017}{...}
{vieweralsosee "[P] matrix get" "mansection P matrixget"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] mat_put_rr" "help mat_put_rr"}{...}
{viewerjumpto "Syntax" "f_get##syntax"}{...}
{viewerjumpto "Description" "f_get##description"}{...}
{viewerjumpto "Links to PDF documentation" "f_get##linkspdf"}{...}
{viewerjumpto "Remarks" "f_get##remarks"}{...}
{viewerjumpto "Examples" "f_get##examples"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[P] matrix get} {hline 2}}Access system matrices{p_end}
{p2col:}({mansection P matrixget:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}{cmdab:mat:rix} [{cmdab:def:ine}] {it:matname} {cmd:=}
		{cmd:get(}{it:systemname}{cmd:)}

{pstd}
where {it:systemname} is

{p 8 17 2}{cmd:_b} {space 3} coefficients after any estimation command{p_end}
{p 8 17 2}{cmd:VCE} {space 2} covariance matrix of estimators after any
                               estimation command{p_end}
{p 8 17 2}{cmd:Rr} {space 3} constraint matrix after {helpb test}{p_end}
{p 8 17 2}{cmd:Cns} {space 2} constraint matrix after any estimation
                               command{p_end}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:get()} matrix function obtains a copy of an internal Stata system
matrix.  Some system matrices can also be obtained more easily by directly
referring to the returned result after a command.  In particular, the
coefficient vector can be referred to as {hi:e(b)}, the variance-covariance
matrix of estimators as {hi:e(V)}, and the constraints matrix as
{hi:e(Cns)} after an estimation command.

{pstd}
See {helpb mat_put_rr} for a programmer's command to directly post
{it:matname} as the internal {hi:Rr} matrix.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P matrixgetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:get()} obtains copies of matrices containing coefficients and the
covariance matrix of the estimators after estimation commands (such as
{cmd:regress} and {cmd:probit}) and obtains copies of matrices left behind
by other Stata commands.  The other side of {cmd:get()} is {cmd:ereturn post},
which allows ado-file estimation commands to post results to Stata's internal
areas; see {manhelp ereturn P}.


{marker examples}{...}
{title:Examples}

    {cmd:. sysuse auto}
    {cmd:. regress price weight mpg}
    {cmd:. matrix list e(b)}
    {cmd:. matrix list e(V)}

    {cmd:. matrix b = get(_b)}
    {cmd:. matrix V = get(VCE)}
    {cmd:. matrix list b}
    {cmd:. matrix list V}

    {cmd:. test weight=1, notest}
    {cmd:. test mpg=40, accum}
    {cmd:. matrix rxtr=get(Rr)}
    {cmd:. matrix list rxtr}
