{smcl}
{* *! version 1.2.1  15jun2012}{...}
{cmd:help adjust} {right:dialog:  {dialog adjust}}
{hline}
{pstd}
{cmd:adjust} has been superseded by {cmd:margins}.
Except for {cmd:adjust}'s {opt generate()} and {opt stdf} options, the
{cmd:margins} command can do everything that {cmd:adjust} did and more.
{cmd:margins} syntax differs from {cmd:adjust}; see {helpb margins}.
{cmd:adjust} continues to work but does not support factor variables and will
often fail if you do not run your estimation command under
{help version:version control}, with the version set to less than 11.  This
help file remains to assist those who encounter an {cmd:adjust} command in old
do-files and programs.


{title:Title}

{p2colset 5 19 21 2}{...}
{p2col :{bf:[R] adjust} {hline 2}}Tables of adjusted means and proportions{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 15 2} 
{cmd:adjust} 
[{it:var}[{opt =} {it:#}] {it:...}] 
{ifin}
[{cmd:,} {it:options}]

{p2colset 5 36 38 2}{...}
{p2col :{it:options}}Description{p_end}
{p2line}
{p2col 3 36 38 2:Main}{p_end}
{p2col :{opth by(varlist)}}compute and display predictions for each level of variables{p_end}

{p2col 3 36 38 2:Options}{p_end}
{p2col :{opt xb}}linear prediction; the default{p_end}
{p2col :{opt p:r}}predicted probabilities{p_end}
{p2col :{opt exp}}exponentiated linear prediction{p_end}
{p2col :{opt se}}display standard error of the prediction; default is none{p_end}
{p2col :{opt stdf}}display standard error of the forecast; default is none{p_end}
{p2col :{opt ci}}display confidence or prediction intervals{p_end}
{p2col :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{p2col :{opt vert:ical}}stack confidence intervals{p_end}
{p2col :{opt eq:uation(eqno)}}use {it:eqno} equation in a multiple-equation system{p_end}
{p2col :{opt nooff:set}}ignore {opt offset} or {opt exposure} variable (if any) when making predictions{p_end}
{p2col :{opth g:enerate(newvar:newvar1 [newvar2])}}generate prediction variable, error variable{p_end}

{p2col 3 36 38 2:More options}{p_end}
{p2col :{opt replace}}replace data in memory with table{p_end}
{p2col :{opt lab:el(text)}}prediction label{p_end}
{p2col :{opt selab:el(text)}}error-term label{p_end}
{p2col :{opt cilab:el(text)}}confidence interval label{p_end}
{p2col :{opth f:ormat(%fmt)}}display format for numbers in table{p_end}
{p2col :{opt nokey}}suppress table key{p_end}
{p2col :{opt nohead:er}}suppress table header{p_end}
{p2col :{opt cen:ter}}center numbers in cells; default is to right-align{p_end}
{p2col :{opt l:eft}}left-align column labels; default is to right-align{p_end}
{p2col :{opt cellw:idth(#)}}cell width{p_end}
{p2col :{opt csep:width(#)}}column separation{p_end}
{p2col :{opt scsep:width(#)}}supercolumn separation{p_end}
{p2col :{opt stubw:idth(#)}}left stub width{p_end}
{p2line}
{p2colreset}{...}


{title:Menu}

{phang}
{bf:Statistics > Postestimation > Adjusted means and proportions}


{title:Description}

{pstd}
After an estimation command (see
{manhelp estimation_commands I:estimation commands}), {cmd:adjust}
provides adjusted predictions of xb (the means in a linear-regression
setting), probabilities (available after some estimation commands), or
exponentiated linear predictions.  The estimate is computed for each level of
the {opt by()} variables, setting the variables specified in
[{it:var}[{opt =} {it:#}] {it:...}] to their mean or to the specified number
if the {opt =} {it:#} part is specified.  If {opt by()} is not specified,
{cmd:adjust} produces results as if {opt by()} defined one group.
Variables used in the estimation command
but not included in either the {opt by()} variable list or the {cmd:adjust}
variable list are left at their current values, observation by observation.
Here {cmd:adjust} displays the average estimated prediction (or the
corresponding probability or exponentiated prediction), substituting the mean
of these unspecified variables within each group defined by the variables in
the {opt by()} option.


{title:Options}

{dlgtab:Main}

{phang}
{opth by(varlist)} specifies the variables whose
levels determine the subsets of the data for which adjusted predictions are to
be computed.  The variables in {opt by()} need not have been
involved in the original estimation command.  A maximum of seven variables may
be specified in the {opt by()} option.  If {opt by()} is not specified, the
results are computed treating all the data as one group.

{dlgtab:Options}

{phang}
{opt xb}, the default, specifies that the linear prediction from the estimation
command be displayed.  This produces a predicted value (a mean in the
linear-regression setting) and is equivalent to the {opt xb} option of
{helpb predict}.  Depending on the estimation command, the {opt xb}
value may not be in the original units of the dependent variable.

{phang}
{opt pr} is an alternative to {opt xb} that specifies that the predicted
probability be displayed.  The {opt pr} option is not available after
all commands.

{phang}
{opt exp} is an alternative to {opt xb} that specifies that
exponentiated linear prediction, exp(xb), be displayed.  Depending
on the estimation command, the resulting quantity might be called an
"incidence rates", a "hazard ratios", etc.

{phang}
{opt se} specifies that the standard error of the linear prediction be
displayed.  This is equivalent to the {opt stdp} option of {helpb predict}.

{phang}
{opt stdf} specifies that the standard error of the forecast of the
linear prediction be displayed.  This is equivalent to the {opt stdf}
option of {helpb predict} and is available only after estimation commands
that support the {opt stdf predict} option.

{phang}
{opt ci} specifies that a confidence interval be displayed.  The
confidence interval is for the displayed estimate as determined by the
{opt xb}, {opt pr}, or {opt exp} option -- producing an interval for
the adjusted linear prediction, probability, or exponentiated linear
prediction.  When {opt stdf} is specified, a prediction interval is produced,
which is, by definition, wider than the corresponding confidence intervals.

{phang}
{opt level(#)} specifies the confidence level, as a percentage,
for confidence or prediction intervals.  The default is
{cmd:level(95)} or as set by {helpb set level}.

{phang}
{opt vertical} requests that the endpoints of confidence or prediction
intervals be stacked vertically on display.
You must specify more than two variables in the {cmd:by()} option for 
{cmd:vertical} results to be produced.

{phang}
{opt equation(eqno)} specifies the equation in a
multiple-equation system that is to be used in the {cmd:adjust} command.  This
option is allowed only after multiple-equation estimation commands.

{phang}
{opt nooffset} is relevant only if you specified
{opt offset(varname)} or
{opt exposure(varname)} when you fit your model.  It
modifies the calculations made by {cmd:adjust} so that they ignore the offset
or exposure variable.

{phang}
{opth "generate(newvar:newvar1 [newvar2])"} generates one or two
new variables.  If one variable is specified, the adjusted linear prediction
for each observation is generated in {it:newvar1} (holding the appropriate
variables to their means or to other specified values).  If {opt pr} is
specified, the adjusted linear prediction is transformed to a probability.
If {opt exp} is specified, the exponentiated prediction is returned.  If
{it:newvar2} is specified, the standard error from either the {opt se} option
or the {opt stdf} option is placed in the second variable.

{dlgtab:More options}

{phang}
{opt replace} specifies that the data in memory be replaced with
data containing 1 observation per cell corresponding to the table produced
by the {cmd:adjust} command.

{phang}
{opt label(text)}, {opt selabel(text)}, and {opt cilabel(text)} allow you to
change the labels for the displayed predictions (from the {opt xb}, {opt pr},
or {opt exp} option), error terms (from the {opt se} or {opt stdf} option),
and confidence intervals (from the {opt ci} option). {opt label()} and
{opt selabel()} also change the variable labels for the variables created by
the {opt generate()} option.

{phang}
{opth format(%fmt)} specifies the display format for presenting the numbers in
the table; see {findalias frformats}.
{cmd:format(%8.0g)} is the default.  Standard errors and confidence intervals
are further formatted for output by automatic enclosure within parentheses or
square brackets.

{phang}
{opt nokey} and {opt noheader} suppress the display of the table key
and header information.

{phang}
{opt center} specifies that results be centered in the table's cells.  The
default is to right-align the results.  For centering to work well, specify a
display format, too, such as {cmd:format(%9.2f)}.

{phang}
{opt left} specifies that column labels be left-aligned.  The default is to
right-align them to distinguish them from supercolumn labels, which are
left-aligned.

{phang}
{opt cellwidth(#)} specifies the width of the cell in units of
digit widths; 10 means the space occupied by 10 digits, which is 0123456789.
The default is not a fixed number but a number chosen to spread the table out
while presenting a reasonable number of columns across the page.

{phang}
{opt csepwidth(#)} specifies the separation between columns in units of digit
widths.  The default is not a fixed number but a number chosen according to
what Stata thinks looks best.

{phang}
{opt scsepwidth(#)} specifies the separation between supercolumns in units of
digit widths.  The default is not a fixed number but a number chosen according
to what Stata thinks looks best.

{phang}
{opt stubwidth(#)} specifies the width of the left stub of the table in units
of digit widths.  The default is not a fixed number but a number chosen
according to what Stata thinks looks best.


{title:Remarks}

{pstd}
{cmd:adjust} is a postestimation command; see {help postest}.
{cmd:adjust} is really just a front-end process for {helpb predict}.  It
sets up the values at which predictions are desired and then displays the
predictions in tabular form; the data remain unchanged.  {cmd:adjust}'s
options control the labeling of the predictions, errors, and confidence
intervals.  {helpb tabdisp} is used to produce the final table.  

{pstd}
If you have restricted your estimation command to a portion of the data
by using {opt if} or {opt in}, then you will generally want to use the same
conditions with {cmd:adjust}.  This task is easily done by including 
{cmd:if e(sample)} with the {cmd:adjust} command.  However, there may be
legitimate reasons for using different data to perform the estimation and to
obtain adjusted predictions (that is, out-of-sample adjusted predictions).


{title:Examples}

{pstd}{title:{helpb regress}}

{phang2}Setup{p_end}
{phang3}{cmd:. sysuse auto}{p_end}
{phang3}{cmd:. regress price mpg weight turn foreign}{p_end}
{phang3}{cmd:. adjust mpg weight turn, by(foreign)}{p_end}
{phang3}{cmd:. adjust mpg weight turn, by(foreign) se ci}{p_end}
{phang3}{cmd:. adjust mpg weight turn, by(foreign) stdf ci}

{phang2}Setting some variables to specific values instead of their mean{p_end}
{phang3}{cmd:. adjust mpg=25 weight turn=35.2, by(foreign)}

{phang2}Generating variables containing the predictions and errors{p_end}
{phang3}{cmd:. adjust mpg weight, by(foreign) gen(pred err) se}

{phang2}Using multiple {opt by()} variables, which need not have
been used in the estimation command{p_end}
{phang3}{cmd:. adjust mpg weight, by(foreign rep78) se ci}

{phang2}Setting a variable and using it as a {opt by()} variable{p_end}
{phang3}{cmd:. sysuse auto, clear}{p_end}
{phang3}{cmd:. regress price mpg weight turn foreign}{p_end}
{phang3}{cmd:. adjust weight foreign=0, by(foreign) se}

{phang2}Compare this with{p_end}
{phang3}{cmd:. adjust weight, by(foreign) se}

{phang2}and this{p_end}
{phang3}{cmd:. adjust weight foreign=1, by(foreign) se}

{pstd}{title:{helpb logit}}

{phang2}Setup{p_end}
{phang3}{cmd:. sysuse auto}{p_end}
{phang3}{cmd:. logit foreign weight mpg}{p_end}

{phang2}Obtain predicted probabilities for each level of {cmd:rep78}, setting
{cmd:mpg} to its mean{p_end}
{phang3}{cmd:. adjust mpg, by(rep78) pr}{p_end}

{pstd}{title:{helpb anova}}

{phang2}Setup{p_end}
{phang3}{cmd:. webuse sysage, clear}{p_end}
{phang3}{cmd:. anova systolic drug disease drug*disease age, continuous(age)}{p_end}

{phang2}Obtain adjusted means and standard errors by {cmd:disease} and
{cmd:drug}{p_end}
{phang3}{cmd:. adjust age, by(disease drug) se}

{pstd}{title:{helpb mvreg}}

{phang2}Setup{p_end}
{phang3}{cmd:. sysuse auto}{p_end}
{phang3}{cmd:. mvreg weight length turn = displ foreign}{p_end}

{phang2}Obtain statistics from various equations after fitting a multivariate
model{p_end}
{phang3}{cmd:. adjust displ, by(foreign) equation(length) se ci}{p_end}
{phang3}{cmd:. adjust displ, by(foreign) equation(#3) se ci}


{title:Also see}

{psee}
Manual:  {bf:[R] adjust}

{psee}
{space 2}Help:  {manhelp table R}
{p_end}
