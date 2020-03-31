{smcl}
{* *! version 1.0.3  11feb2011}{...}
{* this hlp file called by testmanova.dlg}{...}
{vieweralsosee "[MV] manova" "help manova"}{...}
{vieweralsosee "[MV] manova postestimation" "help manova_postestimation"}{...}
{title:Examples of using matrices to test linear expressions after help manova}

    After

	{cmd:. manova y1 y2 = a}

{pstd}
where {cmd:a} has four levels, you test if the coefficients for the first and
second levels of {cmd:a} are equal for dependent variable {cmd:y2} by defining
a matrix using the command

	{cmd:. matrix c = (0,0,0,0,0,0,1,-1,0,0)}

{pstd}
and then supplying the matrix name, {cmd:c} in this example, as an argument to
the {cmd:test()} option of {cmd:test}.

{pstd}
Notice that the matrix has ten columns.  The first five are related to
{cmd:y1} and the last five are related to {cmd:y2}.  Each has five instead of
four columns because a constant is automatically included in the model for
each dependent variable.  If in doubt of the number or order of columns, use
the {bind:{cmd:test , showorder}} command, obtainable by selecting
"{cmd:Show order of columns in the design matrix}" in the dialog box, to
examine the order and definitions of the columns.

{pstd}
The matrix

	{cmd:. matrix x = (0,3,-1,-1,-1,0,3,-1,-1,-1)}

{pstd}
could be used to test if {cmd:a} at level 1 is equal to the average of {cmd:a}
at levels 2, 3, and 4 for {cmd:y1} and {cmd:y2} combined into one single
degree-of-freedom test.

{pstd}
The matrix

{phang2}
{cmd:. matrix z = (0,3,-1,-1,-1,0,0,0,0,0 \ 0,0,0,0,0,0,3,-1,-1,-1)}

{pstd}
could be used to test if {cmd:a} at level 1 is equal to the average of {cmd:a}
at levels 2, 3, and 4 for {cmd:y1} jointly with {cmd:a} at level 1 equal to
the average of {cmd:a} at levels 2, 3, and 4 for {cmd:y2} -- a two
degrees-of-freedom test.
{p_end}
