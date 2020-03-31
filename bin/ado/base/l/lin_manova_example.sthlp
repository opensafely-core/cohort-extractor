{smcl}
{* *! version 1.0.4  11feb2011}{...}
{* this hlp file called by testmanova.dlg}{...}
{vieweralsosee "[R] manova" "help manova"}{...}
{vieweralsosee "[R] manova postestimation" "help manova_postestimation"}{...}
{title:Examples of linear expressions to test after manova}

{pstd}
After

{phang2}
{cmd:. manova y1 y2 = x1 x2 c.x3 x1#x2 x1#c.x3 x2#c.x3 x1#x2#c.x3}

{pstd}
you test if the coefficients for the first and second levels of x1 for
equation y2 are equal using the linear expression

{phang2}
{cmd:[y2]_b[1.x1] = [y2]_b[2.x1]}

{pstd}
or equivalently as

{phang2}
{cmd:[y2]1.x1 = [y2]2.x1}

{pstd}
For equation y1,
you test if the coefficient for the interaction of level 2 of x1 and level 1
of x2 is equal to the average of the coefficients for the interaction of
levels 1 and 3 of x1 and level 1 of x2 using

{phang2}
{cmd:[y1]_b[2.x1#1.x2] = ([y1]_b[1.x1#1.x2] + [y1]_b[3.x1#1.x2])/2}

{pstd}
or equivalently as

{phang2}
{cmd:[y1]2.x1#1.x2 = ([y1]1.x1#1.x2 + [y1]3.x1#1.x2)/2}

{pstd}
For equation y2,
you test if the coefficient for the interaction of the continuous variable x3
with level 1 of x1 and level 2 of x2 is equal to the coefficient for the
interaction of x3 with level 2 of x1 and level 1 of x2 using

{phang2}{cmd:[y2]_b[1.x1#2.x2#c.x3] = [y2]_b[2.x1#1.x2#c.x3]}

{pstd}
or equivalently as

{phang2}{cmd:[y2]1.x1#2.x2#c.x3 = [y2]2.x1#1.x2#c.x3}


{pstd}
{cmd:_coef} may be used in the place of {cmd:_b}.
{p_end}
