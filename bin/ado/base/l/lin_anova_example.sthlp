{smcl}
{* *! version 1.0.4  11feb2011}{...}
{* this hlp file called by testanova.dlg}{...}
{vieweralsosee "[R] anova" "help anova"}{...}
{vieweralsosee "[R] anova postestimation" "help anova_postestimation"}{...}
{title:Examples of linear expressions to test after anova}

    After

{phang2}{cmd:. anova y x1 x2 c.x3 x1#x2 x1#c.x3 x2#c.x3 x1#x2#c.x3}

{pstd}
you test if the coefficients for the first and second levels of x1
are equal using the linear expression

	{cmd:_b[1.x1] = _b[2.x1]}

{pstd}
or equivalently as

	{cmd:1.x1 = 2.x1}

{pstd}
You test if the coefficient for the interaction of level 2 of x1 and level 1
of x2 is equal to the average of the coefficients for the interaction of
levels 1 and 3 of x1 and level 1 of x2 using

{phang2}{cmd:_b[2.x1#1.x2] = (_b[1.x1#1.x2] + _b[3.x1#1.x2])/2}

{pstd}
or equivalently as

{phang2}{cmd:2.x1#1.x2 = (1.x1#1.x2 + 3.x1#1.x2)/2}

{pstd}
You test if the coefficient for the interaction of the continuous variable x3
with level 1 of x1 and level 2 of x2 is equal to the coefficient for the
interaction of x3 with level 2 of x1 and level 1 of x2 using

{phang2}{cmd:_b[1.x1#2.x2#c.x3] = _b[2.x1#1.x2#c.x3]}

{pstd}
or equivalently as

{phang2}{cmd:1.x1#2.x2#c.x3 = 2.x1#1.x2#c.x3}


{pstd}
{cmd:_coef} may be used in the place of {cmd:_b}.
{p_end}
