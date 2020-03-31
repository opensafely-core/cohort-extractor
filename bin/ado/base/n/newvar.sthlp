{smcl}
{* *! version 1.1.2  07apr2017}{...}
{findalias asfrvarnew}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 11 Language syntax" "help language"}{...}
{vieweralsosee "[U] 11.4 varname and varlists" "help varname"}{...}
{viewerjumpto "Description" "newvar##description"}{...}
{viewerjumpto "Examples" "newvar##examples"}{...}
{title:Title}

    {hi:newvar} (from {findalias frvarnew})


{marker description}{...}
{title:Description}

{pstd}
A {it:newvar} is the name of a variable that does not yet exist in the
dataset.  A {it:newvar} is a new {it:{help varname}}, such as

{p 8 34 2}{cmd:x}{p_end}
{p 8 34 2}{cmd:myvar}{p_end}
{p 8 34 2}{cmd:Myvar}{p_end}
{p 8 34 2}{cmd:inc92}{p_end}
{p 8 34 2}{cmd:reciprocal_of_miles_per_gallon}{p_end}
{p 8 34 2}{cmd:_odd}{p_end}
{p 8 34 2}{cmd:_1994}{p_end}

{pstd}
If you are interested in creating a variable list of new variables, see
{help newvarlist}.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. webuse hbp2}{p_end}
{phang}{cmd:. generate not_white = race!=1}{p_end}
{phang}{cmd:. encode sex, generate(gender)}

{phang}{cmd:. webuse hbp3, clear}{p_end}
{phang}{cmd:. decode female, generate(sex)}

{phang}{cmd:. sysuse auto, clear}{p_end}
{phang}{cmd:. lowess mpg weight, generate(mpghat)}{p_end}
{phang}{cmd:. generate weight2 = weight^2}{p_end}
