{smcl}
{* *! version 1.2.0  23may2018}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] memory" "help memory"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "matsize##syntax"}{...}
{viewerjumpto "Description" "matsize##description"}{...}
{viewerjumpto "Option" "matsize##option"}{...}
{viewerjumpto "Remarks" "matsize##remarks"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] matsize} {hline 2}}Set the maximum number of variables in a model{p_end}
{p2col:}({browse "http://www.stata.com/manuals15/rmatsize.pdf":View complete PDF manual entry}){p_end}
{p2colreset}{...}

{pstd}
As of Stata 16, the maximum number of variables in a model is fixed;
see {help limits}.
{cmd:set matsize} only has an effect if used under version control.
This is the original help file, which we will no longer update, so some links
may no longer work.


{marker syntax}{...}
{title:Syntax}

{p 8 20 2}{cmd:set} {cmdab:mat:size} {it:#} [{cmd:,} {cmdab:perm:anently}]

{phang}
    where {cmd:10} {ul:<} {it:#} {ul:<} {cmd:11000} for Stata/MP and Stata/SE
        and where {cmd:10} {ul:<} {it:#} {ul:<} {cmd:800} for Stata/IC.


{marker description}{...}
{title:Description}

{pstd}
{cmd:set matsize} sets the maximum matrix size, which influences the number of
variables that can be included in any of Stata's estimation commands.
For {help statamp:Stata/MP}, {help SpecialEdition:Stata/SE}, and
{help stataic:Stata/IC}, the default value is 400, but it may be increased or
decreased.

{pstd}
Changing {cmd:matsize} has no effect on Mata.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the {cmd:matsize} setting be remembered and become the default setting when
you invoke Stata.


{marker remarks}{...}
{title:Remarks}

{pstd}
We wish to fit a model of {cmd:y} on the variables {cmd:x1} through
{cmd:x400}.  Without thinking, we type

    {cmd:. regress y x1-x400}
    {err}matsize too small
{p 8 8}
You have attempted to create a matrix with more than 400
rows or columns or to fit a model with more than 400
variables plus ancillary parameters.  You need to increase matsize by using the
{cmd:set matsize} command; see help {help matsize}.
{p_end}
    {txt}{search r(908):r(908);}

{pstd}
We realize that we need to increase matsize, so we type

    {cmd:. set matsize 450}

    {cmd:. regress y x1-x400}
      (output appears)

{pstd}
Programmers should note that the current setting of matsize is stored as the
c-class value {cmd:c(matsize)}; see {manhelp creturn P}.


{title:Setting matsize}

{pstd}
Increasing {cmd:matsize} increases Stata's memory consumption:

          matsize           memory use
	  {hline 28}
             400               1.254M 
             800               4.950M
           1,600              19.666M
           3,200              78.394M
           6,400             313.037M
          11,000             924.080M
	  {hline 28}

{pstd}
The table above understates the amount of memory Stata will use. 
The table was derived under the assumption of one matrix and eleven 
vectors.  If two matrices are required, the numbers above would be nearly 
doubled.  

{pstd}
If you use a 32-bit computer, you likely will be unable to set {cmd:matsize} to
11,000.  A value of 11,000 would require nearly 1 gigabyte per matrix.  The
total memory consumption most 32-bit operating systems will grant to Stata is
2 gigabytes, so if you had two matrices, there would be no memory left for
data or for Stata's code!

{pstd}
You should not {cmd:set matsize} larger than is necessary.  Doing so will at
best waste memory and at worst slow Stata down or prevent Stata from having
enough memory for other tasks.  If you receive the error message "matsize too
small", increase {cmd:matsize} only as much as is necessary to eliminate the
error message.


{title:Error codes related to matsize}

{phang}146. {cmd:too many variables or values} 
            {cmd:(matsize too small)}{break}
{cmd:You can increase matsize using the set matsize command;}
{cmd:see help matsize.}{p_end}
{pmore2}Your {cmd:anova} model resulted in a specification containing more than
{cmd:matsize} - 2 explanatory variables; see {manhelp matsize R}.

{phang}908. {cmd:matsize too small}{p_end}
{pmore2}You have attempted to create a matrix with too many rows or columns or
attempted to fit a model with too many variables.  You need to increase
{cmd:matsize}.  Use {cmd:set matsize}; see {manhelp matsize R}.

{pmore2}
If you are using factor variables and included an interaction that has
lots of missing cells, either increase {cmd:matsize} or {cmd:set emptycells}
{cmd:drop} to reduce the required matrix size; see
{manhelp set_emptycells R:set emptycells}.

{pmore2}
If you are using factor variables, you might have accidentally treated a
continuous variable as a categorical, resulting in lots of categories.  Use the
{cmd:c.} operator on such variables.
{p_end}
