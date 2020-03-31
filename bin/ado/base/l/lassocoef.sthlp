{smcl}
{* *! version 1.0.0  24jun2019}{...}
{viewerdialog lassocoef "dialog lassocoef"}{...}
{vieweralsosee "[LASSO] lassocoef" "mansection lasso lassocoef"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] lasso postestimation" "help lasso postestimation"}{...}
{vieweralsosee "[LASSO] lasso inference postestimation" "help lasso inference postestimation"}{...}
{vieweralsosee "[LASSO] lassoinfo" "help lassoinfo"}{...}
{viewerjumpto "Syntax" "lassocoef##syntax"}{...}
{viewerjumpto "Menu" "lassocoef##menu"}{...}
{viewerjumpto "Description" "lassocoef##description"}{...}
{viewerjumpto "Links to PDF documentation" "lassocoef##linkspdf"}{...}
{viewerjumpto "Options" "lassocoef##options"}{...}
{viewerjumpto "Examples" "lassocoef##examples"}{...}
{viewerjumpto "Stored results" "lassocoef##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[LASSO] lassocoef} {hline 2}}Display coefficients after lasso estimation results{p_end}
{p2col:}({mansection LASSO lassocoef:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
For current estimation results

{phang2}
After {cmd:lasso}, {cmd:sqrtlasso}, or {cmd:elasticnet}

{p 16 25 2}
{cmd:lassocoef}
[{cmd:,} {help lassocoef##options:{it:options}}]

{phang2}
After {cmd:ds} or {cmd:po}

{p 16 25 2}
{cmd:lassocoef} {cmd:(.,} {opt for(varspec))}
[{cmd:,} {help lassocoef##options:{it:options}}]

{phang2}
After {cmd:xpo} without {cmd:resample}

{p 16 25 2}
{cmd:lassocoef} {cmd:(.,} {opt for(varspec)} {opt xfold(#)}{cmd:)}
[{cmd:,} {help lassocoef##options:{it:options}}]

{phang2}
After {cmd:xpo} with {cmd:resample}

{p 16 25 2}
{cmd:lassocoef} {cmd:(.,} {opt for(varspec)} {opt xfold(#)}
{opt resample(#)}{cmd:)}
[{cmd:,} {help lassocoef##options:{it:options}}]


{pstd}
For multiple stored estimation results

{p 8 17 2}
{cmd:lassocoef}
[{it:estspec1} [{it:estspec2} ...]]
[{cmd:,} {help lassocoef##options:{it:options}}]

{phang2}
{it:estspec} for {cmd:lasso}, {cmd:sqrtlasso}, and {cmd:elasticnet} is

{pmore2}
{it:name}

{phang2}
{it:estspec} for {cmd:ds} and {cmd:po} models is 

{pmore2}
{cmd:(}{it:name}{cmd:,} {opt for(varspec)}{cmd:)}

{phang2}
{it:estspec} for {cmd:xpo} without {cmd:resample} is

{pmore2}
{cmd:(}{it:name}{cmd:,} {opt for(varspec)} {opt xfold(#)}{cmd:)}

{phang2}
{it:estspec} for {cmd:xpo} with {cmd:resample} is

{pmore2}
{cmd:(}{it:name}{cmd:,} {opt for(varspec)} {opt xfold(#)} {opt resample(#)}{cmd:)}


{phang2}
{it:name} is the name of a {help estimates_store:stored estimation result}.
Either nothing or a period ({cmd:.}) can be used to specify the current
estimation result.  {cmd:_all} or {cmd:*} can be used to specify all stored
estimation results when all stored results are {cmd:lasso}, {cmd:sqrtlasso},
or {cmd:elasticnet}.

{phang2}
{it:varspec} is a {varname}, except after {cmd:poivregress} and
{cmd:xpoivregress}, when it is either {it:varname} or
{mansection LASSO lassoinfoRemarksandexamplespred_varname:{bf:pred(}{it:varname}{bf:)}}.


{synoptset 35 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Options}
{synopt :{cmdab:di:splay(x)}}indicate selected variables with an {cmd:x}; the default{p_end}
{synopt :{cmdab:di:splay(u)}}same as {cmd:display(x)}, except variables unavailable to be selected indicated with a {cmd:u}{p_end}
{synopt :{cmdab:di:splay(coef} [{cmd:,} {it:coef_di_opts}]{cmd:)}}display coefficient values{p_end}
{synopt :{cmd:sort(none)}}order of variables as originally specified; the default{p_end}
{synopt :{cmd:sort(names)}}order by the names of the variables{p_end}
{synopt :{cmd:sort(coef} [{cmd:,} {it:coef_sort_opts}]{cmd:)}}order by the absolute values of the coefficients in descending order{p_end}

{synopt :{cmdab:nofvlab:el}}display factor-variable level values rather than value labels{p_end}
{synopt :{cmdab:noleg:end}}report or suppress table legend{p_end}
{synopt :{cmd:nolstretch}}do not stretch the width of the table to accommodate long variable names{p_end}
{synoptline}
{p 4 6 2}
{cmd:nofvlabel}, {cmd:nolegend}, and {cmd:nolstretch} do not 
appear in the dialog box.


{synoptset 35}{...}
{synopthdr:coef_di_opts}
{synoptline}
{synopt :{cmdab:stand:ardized}}display penalized coefficients of standardized variables; the default{p_end}
{synopt :{cmdab:pen:alized}}display penalized coefficients of unstandardized variables{p_end}
{synopt :{cmdab:post:selection}}display postselection coefficients of unstandardized variables{p_end}
{synopt :{cmd:eform}}display exp(b) rather than the coefficient b{p_end}
{synopt :{opth f:ormat(%fmt)}}use numerical format {cmd:%}{it:fmt} for the coefficient values{p_end}
{synoptline}


{synoptset 35}{...}
{synopthdr:coef_sort_opts}
{synoptline}
{synopt :{opt stand:ardized}}sort by penalized coefficients of standardized variables{p_end}
{synopt :{opt pen:alized}}sort by penalized coefficients of unstandardized variables{p_end}
{synopt :{opt post:selection}}sort by postselection coefficients of unstandardized variables{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:lassocoef} displays a table showing the selected variables after one or
more lasso estimation results.
It can also display the values of the coefficient estimates.
When used with stored results from two or more lassos, it can be used to
view the overlap between sets of selected variables.

{pstd}
After {cmd:ds}, {cmd:po}, and {cmd:xpo} commands,
{cmd:lassocoef} can be used to view coefficients for a single lasso
or for multiple lassos displayed side by side.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO lassocoefQuickstart:Quick start}

        {mansection LASSO lassocoefRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Options}

{phang}
{opt display(displayspec)} specifies what to display in the table.  The
default is {cmd:display(x)}.

{pmore}
Blank cells in the table indicate that the corresponding variable was not
selected by the lasso or was not specified in the model.

{pmore}
For some variables without fitted values, a code that indicates the reason for
omission is reported in the table.

{pmore}
Empty levels of factors and interactions are coded with the letter {cmd:e}.

{pmore}
Base levels of factors and interactions are coded with the letter {cmd:b}.
Base levels can be set on {it:alwaysvars} (variables always included in the
lasso) but not on {it:othervars} (the set of variables from which lasso
selects).

{pmore}
Variables omitted because of collinearity are coded with the letter {cmd:o}.
Lasso does not label as omitted any {it:othervars} because of collinearity.
Collinear variables are simply not selected.  Variables in {it:alwaysvars} 
can be omitted because of collinearity.
See {mansection LASSO CollinearcovariatesRemarksandexamplesalways_collinear:{it:Remarks and examples}} in
{bf:[LASSO] Collinear covariates}.

{phang2}
{cmd:display(x)} displays an {cmd:x} in the table when the variable has been 
selected by the lasso; that is, it has a nonzero coefficient.

{phang2}
{cmd:display(u)}
is the same as {cmd:display(x)}, except that when a variable was not specified 
in the model, {cmd:u} (for unavailable) is displayed instead of a blank cell.

{phang2}
{cmd:display(coef} [{cmd:, standardized penalized postselection eform}
{opth format(%fmt)}]{cmd:)} specifies that coefficient values be displayed in
the table.

{phang3}
{cmd:standardized} specifies that the penalized coefficients of the
standardized variables be displayed.  This is the default when
{cmd:display(coef)} is specified without options.  Penalized coefficients of
the standardized variables are the coefficient values used in the estimation of
the lasso penalty.  See 
{mansection LASSO lassoMethodsandformulas:{it:Methods and formulas}} in
{bf:[LASSO] lasso}.

{phang3}
{cmd:penalized} specifies that the penalized coefficients of the unstandardized
variables be displayed.  Penalized coefficients of the unstandardized variables
are the penalized coefficients of the standardized variables with the
standardization removed.

{phang3}
{cmd:postselection} specifies that the postselection coefficients of the
unstandardized variables be displayed.  Postselection coefficients of the
unstandardized variables are obtained by fitting an ordinary model
({cmd:regress} for {cmd:lasso} {cmd:linear}, {cmd:logit} for {cmd:lasso}
{cmd:logit}, {cmd:probit} for {cmd:lasso} {cmd:probit}, and {cmd:poisson} for
{cmd:lasso} {cmd:poisson}) using the selected variables.  See
{mansection LASSO lassoMethodsandformulas:{it:Methods and formulas}} in
{bf:[LASSO] lasso}.
 
{phang3} {cmd:eform} displays coefficients in exponentiated form.  For each
coefficient, exp(b) rather than b is displayed.  This option can be used to
display odds ratios or incidence-rate ratios after the appropriate estimation
command.

{phang3}
{opth format(%fmt)} specifies the display format for the coefficients in the
table.  The default is {cmd:format(%9.0g)}.
 
{phang} {opt sort(sortspec)} specifies that the rows of the table be ordered by
specification given by {it:sortspec}.

{phang2}
{cmd:sort(none)}
specifies that the rows of the table be ordered by the order the variables
were specified in the model specification.  This is the default.

{phang2}
{cmd:sort(names)} orders rows alphabetically by the variable names of the
covariates.  In the case of factor variables, main effects and nonfactor
variables are displayed first in alphabetical order.  Then, all two-way
interactions are displayed in alphabetical order, then, all three-way
interactions, and so on.

{phang2}
{cmd:sort(coef} [{cmd:, standardized penalized postselection}]{cmd:)} orders
rows in descending order by the absolute values of the coefficients.  When
results from two or more estimation results are displayed, results are sorted
first by the ordering for the first estimation result with rows representing
coefficients not in the first estimation result last.  Within the rows
representing coefficients not in the first estimation result, the rows are
sorted by the ordering for the second estimation result with rows representing
coefficients not in the first or second estimation results last.  And so on.

{phang3}
{cmd:standardized} orders rows in descending order by the absolute values of
the penalized coefficients of the standardized variables.  This is the default
when {cmd:sort(coef)} is specified without options.

{phang3}
{cmd:penalized} orders rows in descending order by the absolute values of the
penalized coefficients of the unstandardized variables.

{phang3}
{cmd:postselection} orders rows in descending order by the absolute values of
the postselection coefficients of the unstandardized variables.

{phang}
{cmd:nofvlabel} displays factor-variable level numerical values rather than 
attached value labels.  This option overrides the {cmd:fvlabel} setting.  See
{manhelp set_showbaselevels R:set showbaselevels}.

{phang}
{cmd:nolegend}
specifies that the legend at the bottom of the table not be displayed.
By default, it is shown.

{phang}
{cmd:nolstretch} specifies that the width of the table not be automatically
widened to accommodate long variable names.  When {cmd:nolstretch} is
specified, names are abbreviated to make the table width no more than 79
characters.  The default, {cmd:lstretch}, is to automatically widen the table
up to the width of the Results window.  To change the default, use
{helpb set:set lstretch off}.

{phang}
Required options for {it:estspec} after {cmd:ds}, {cmd:po}, and {cmd:xpo}:

{phang2}
{opt for(varspec)} specifies a particular lasso after a {cmd:ds}, a {cmd:po},
or an {cmd:xpo} estimation command fit using the option {cmd:selection(cv)} or
{cmd:selection(adaptive)}.  For all commands except {cmd:poivregress} and
{cmd:xpoivregress}, {it:varspec} is always a {varname}; it is either
{it:depvar}, the dependent variable, or one of {it:varsofinterest} for which
inference is done.

{pmore2} 
For {cmd:poivregress} and {cmd:xpoivregress}, {it:varspec} is either
{it:varname} or {opt pred(varname)}.  The lasso for {it:depvar} is specified
with its {it:varname}.  Each of the endogenous variables have two lassos,
specified by {it:varname} and {opt pred(varname)}.  The exogenous variables of
interest each have only one lasso, and it is specified by {opt pred(varname)}.

{pmore2} 
This option is required after {cmd:ds}, {cmd:po}, and {cmd:xpo} commands.

{phang2}
{opt xfold(#)} specifies a particular lasso after an {cmd:xpo} estimation
command.  For each variable to be fit with a lasso, K lassos are done, one for
each cross-fit fold, where K is the number of folds.  This option specifies
which fold, where {it:#} = 1, 2, ..., K.  It is required after an {cmd:xpo}
command.

{phang2}
{opt resample(#)} specifies a particular lasso after an {cmd:xpo} estimation
command fit using the option {opt resample(#)}.  For each variable to be fit
with a lasso, R x K lassos are done, where R is the number of resamples
and K is the number of cross-fitting folds.  This option specifies which
resample, where {it:#} = 1, 2, ..., R.  This option, along with {opt xfold(#)},
is required after an {cmd:xpo} command with resampling.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. set seed 1234}{p_end}
{phang2}{cmd:. lasso linear mpg i.foreign i.rep78 headroom weight turn}
      {cmd:gear_ratio price trunk length displacement}

{pstd}Display the selected variables{p_end}
{phang2}{cmd:. lassocoef}

{pstd}Display the values of the postselection coefficients{p_end}
{phang2}{cmd:. lassocoef, display(coef, postselection)}

{pstd}Display the penalized coefficients of the standardized variables sorted
by their absolute values in descending order{p_end}
{phang2}{cmd:. lassocoef, display(coef, standardized) sort(coef, standardized)}

{pstd}Setup{p_end}
{phang2}{cmd:. lasso linear mpg i.foreign i.rep78 headroom weight turn}
   {cmd:gear_ratio price trunk length displacement, rseed(1234)}{p_end}
{phang2}{cmd:. estimates store lassocv}{p_end}
{phang2}{cmd:. lasso linear mpg i.foreign i.rep78 headroom weight turn}
   {cmd:gear_ratio price trunk length displacement, selection(adaptive)}
   {cmd:rseed(1234)}{p_end}
{phang2}{cmd:. estimates store lassoadapt}

{pstd}Compare selected coefficients{p_end}
{phang2}{cmd:. lassocoef lassocv lassoadapt}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse breathe, clear}{p_end}
{phang2}{cmd:. xporegress react no2_class no2_home,}
    {cmd:controls(i.(meducation overweight msmoke sex) noise sev* age)}

{pstd}Compare the variables selected by the lassos for {cmd:no2_class} in the 
first two cross-fit folds{p_end}
{phang2}{cmd:. lassocoef (., for(no2_class) xfold(1)) (., for(no2_class) xfold(2))}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:lassocoef} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(names)}}names of results used{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(coef)}}matrix M: n x m{break}
M[i, j] = ith coefficient estimate for model
j; i = 1, ..., n;
j = 1, ..., m{p_end}
