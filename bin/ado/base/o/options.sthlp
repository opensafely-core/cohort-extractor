{smcl}
{* *! version 1.1.2  11feb2011}{...}
{findalias asfrsyntaxop}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 11 Language syntax" "help language"}{...}
{viewerjumpto "Description" "options##description"}{...}
{viewerjumpto "Examples" "options##examples"}{...}
{title:Title}

{pstd}
{findalias frsyntaxop}


{marker description}{...}
{title:Description}

{pstd}
Options are specified by placing a comma at the end of the command and then
listing the options one after another with intervening spaces:

{phang2}{cmd:. tabulate region agecat, chi2 row col}

{pstd}
In this example:

          {cmd:tabulate}            is   the command,
          {cmd:region} and {cmd:agecat}   are  the variable names, and
          {cmd:chi2}, {cmd:row}, and {cmd:col}  are  the options.

{pstd}
No commas are placed between the options.

{pstd}
Most options are toggles -- they indicate that something either is or is
not to be done.  The example above has three options, all of which are toggles.

{pstd}
Some options take arguments.  Depending on the option, it may ask for a
number, string, or variable, or several variables (a {varlist}) or
several numbers (a {it:{help numlist}}).


{marker examples}{...}
{title:Examples}

{phang}{cmd:. webuse citytemp2}{p_end}
{phang}{cmd:. tabulate region agecat, chi2 row col}

{phang}{cmd:. webuse hanley}{p_end}
{phang}{cmd:. roctab disease rating, table detail}

{phang}{cmd:. webuse regsmpl}{p_end}
{phang}{cmd:. regress ln_wage age c.age#c.age tenure, vce(cluster id) level(90)}

{phang}{cmd:. sysuse uslifeexp}{p_end}
{phang}{cmd:. line le_wm year, ylabel(0 20(10)80)}

{phang}{cmd:. webuse hbp3}{p_end}
{phang}{cmd:. decode female, generate(sex)}{p_end}
