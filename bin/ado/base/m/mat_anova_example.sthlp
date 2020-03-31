{smcl}
{* *! version 1.0.4  11feb2011}{...}
{* this hlp file called by testanova.dlg}{...}
{vieweralsosee "[R] anova" "help anova"}{...}
{vieweralsosee "[R] anova postestimation" "help anova_postestimation"}{...}
{vieweralsosee "[P] matrix define" "help matrix_define"}{...}
{title:Examples of using matrices to test linear expressions after anova}

    After

	{cmd:. anova y a}

{pstd}
where {cmd:a} has four levels, you test if the coefficients for the first and
second levels of {cmd:a} are equal by defining a matrix using the command

	{cmd:. matrix c = (1,-1,0,0,0)}

{pstd}
or using the {dialog matrix_input:matrix input dialog} and then supplying the
matrix name, {cmd:c} in this example, as an argument to the {cmd:test()}
option of {cmd:test}.

{pstd}
Notice that the matrix has five columns instead of four.  The last column is
for the constant, the first four columns are for the four levels of
{cmd:a}.  If in doubt of the number or order of columns, use the
{bind:{cmd:test, showorder}} command, obtainable by selecting
"{cmd:Show order of columns in the design matrix}" in the dialog box, to
examine the order and definitions of the columns.

    The matrix

	{cmd:. matrix x = (3,-1,-1,-1,0)}

{pstd}
could be used to test if {cmd:a} at level 1 is equal to the average of {cmd:a}
at levels 2, 3, and 4.

    The matrix

	{cmd:. matrix z = (1,-1,0,0,0 \ 0,0,1,-1,0)}

{pstd}
could be used to jointly test that level 1 and 2 of {cmd:a} are equal and
that level 3 and 4 of {cmd:a} are equal.
{p_end}
