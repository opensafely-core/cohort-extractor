{smcl}
{* *! version 1.0.4  16apr2009}{...}
{cmd:help hadimvo}{right:{help prdocumented:previously documented}}
{hline}
{pstd}
{cmd:hadimvo} continues to work but, as of Stata 8, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.


{title:Title}

{p 4 21 2}
{hi:[R] hadimvo} {hline 2} Identify multivariate outliers


{title:Syntax}

{p 4 12 2}{cmd:hadimvo} {varlist} {ifin}{cmd:,} {cmdab:g:enerate:(}{it:newvar1} [{it:newvar2}]{cmd:)}
[{opt p(#)}]


{title:Description}

{pstd}
{cmd:hadimvo} identifies multiple outliers in multivariate data using the
method of Hadi (1992, 1994), creating {it:newvar1} equal to 1 if an
observation is an "outlier" and 0 otherwise.  Optionally, {it:newvar2} can
also be created containing the distances from the basic subset.


{title:Options}

{phang}{cmd:generate(}{it:newvar1} [{it:newvar2}]{cmd:)} is not optional; it
identifies the new variable(s) to be created.  Whether you specify two
variables or one, however, is optional.  {it:newvar2}, if specified, will
contain the distances (not the distances squared) from the basic subset.  That
is, specifying {cmd:gen(odd)} creates the variable {hi:odd} containing 1 if the
observation is an outlier in the Hadi sense and 0 otherwise.  Specifying
{cmd:gen(odd dist)} also creates variable {hi:dist} containing the Hadi
distances.

{phang}{cmd:p(}{it:#}{cmd:)} specifies the significance level for outlier
cutoff; 0 < {it:#} < 1.  The default is {cmd:p(.05)}.  Larger numbers identify
a larger proportion of the sample as outliers.  If {it:#} is specified greater
than 1, it is interpreted as a percent.  Thus, {cmd:p(5)} is the same as
{cmd:p(.05)}.


{title:Examples}

    {cmd:. hadimvo price weight, gen(odd)}
    {cmd:. list if odd}{right:/* list the outliers            */  }
    {cmd:. summ price weight if ~odd}{right:/* summary stats for clean data */  }

    {cmd:. drop odd}
    {cmd:. hadimvo price weight, gen(odd D)}
    {cmd:. summarize D, detail}
    {cmd:. sort D}
    {cmd:. list make price weight D odd}

    {cmd:. hadimvo price weight mpg, gen(odd2 D2) p(.01)}
    {cmd:. regress} {it:...} {cmd:if ~odd2}


{title:Also see}

{psee}
Manual:  {help prdocumented:previously documented}

{psee}
{space 2}Help:  {manhelp mvreg R}, {manhelp regress R},
{manhelp regress_postestimation R:regress postestimation}, {manhelp sureg R}
{p_end}
