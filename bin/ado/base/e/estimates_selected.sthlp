{smcl}
{* *! version 1.0.0  19jun2019}{...}
{viewerdialog "estimates selected" "dialog estimates_selected"}{...}
{vieweralsosee "[R] estimates selected" "mansection R estimatesselected"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estimates" "help estimates"}{...}
{vieweralsosee "[LASSO] lassocoef" "help lassocoef"}{...}
{viewerjumpto "Syntax" "estimates_selected##syntax"}{...}
{viewerjumpto "Menu" "estimates_selected##menu"}{...}
{viewerjumpto "Description" "estimates_selected##description"}{...}
{viewerjumpto "Links to PDF documentation" "estimates_selected##linkspdf"}{...}
{viewerjumpto "Options" "estimates_selected##options"}{...}
{viewerjumpto "Examples" "estimates_selected##examples"}{...}
{viewerjumpto "Stored results" "estimates_selected##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[R] estimates selected} {hline 2}}Show selected coefficients{p_end}
{p2col:}({mansection R estimatesselected:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{opt est:imates} {opt sel:ected} 
[{it:namelist}]
[{cmd:,}
{it:options}]

{phang}
{it:namelist} is the name given to previously stored estimation results,
a list of names, {cmd:_all}, or {cmd:*}.  A name may be {cmd:.}, meaning
the current (active) estimates.  {cmd:_all} and {cmd:*} mean the same
thing.

{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{cmdab:di:splay(}{it:{help estimates selected##display:info}}{cmd:)}}display
	{it:info}; default is {cmd:display(x)}
{p_end}
{synopt:{cmd:sort(}{it:{help estimates selected##sort:on}}{cmd:)}}sort
	rows in order of {it:on}
{p_end}

{syntab:Reporting}
{synopt :{opt noabbrev}}do not abbreviate variable names
{p_end}
{synopt :{it:{help estimates_selected##display_options:display_options}}}control
       row spacing, line width, and display of omitted variables and base and
       empty cells
{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estimates} {cmd:selected} reports on coefficients from one or more
estimation results.  It creates a table that indicates which coefficients were
estimated in each model and, if requested, reports the value of those
coefficients.  The results may be sorted based on the values of the estimated
coefficients or based on variable names.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R estimatesselectedQuickstart:Quick start}

        {mansection R estimatesselectedRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{marker display}{...}
{phang}
{opt display(info)} specifies what to display in the table.
The default is {cmd:display(x)}.

{pmore}
Blank cells in the table indicate that the corresponding
covariate does not have a fitted value.  For some covariates without
fitted values, a code that indicates the reason for omission is reported in
the table.
Base levels of factors and interactions are coded with the letter {bf:b}.
Empty levels of factors and interactions are coded with the letter {bf:e}.
Covariates omitted because of collinearity are coded with the letter
{bf:o}.

{phang2}
{cmd:display(x)} displays an {cmd:x} in the cell of the table where a
covariate has a fitted value. This is the default.

{phang2}
{cmd:display(u)} is the same as {cmd:display(x)}, except that when a covariate 
was not specified in the model, {cmd:u} (for unavailable) is displayed 
instead of a blank cell.

{phang2}
{cmd:display(}{cmd:coef} [{cmd:,} {cmd:eform} {opth f:ormat(%fmt)}]{cmd:)}
specifies that coefficient values be displayed in the table.

{phang3}
{cmd:eform} displays coefficients in exponentiated form.  
For each coefficient, exp(b) rather than b is displayed.
This option can be used to display 
odds ratios,
incidence-rate ratios,
relative-risk ratios,
hazard ratios, and 
subhazard ratios
after the appropriate estimation command.

{phang3}
{cmd:format(}{cmd:%}{it:{help format:fmt}}{cmd:)}
specifies the display format for the coefficients in the table.
The default is {cmd:format(%9.0g)}.

{marker sort}{...}
{phang}
{opt sort(on)} specifies how to sort the rows of the table.
By default, coefficients are displayed in the order in which they appear in 
the estimation results.

{phang2}
{cmd:sort(none)} specifies that the rows are not sorted.
This is the default.
The order of the coefficients is taken from their order in {cmd:e(b)}.

{phang2}
{cmd:sort(names)} orders rows 
alphabetically by the variable names of the covariates. 
In the case of factor variables, main effects and nonfactor variables 
are displayed first in alphabetical order; then all two-way interactions
are displayed in alphabetical order, then all three-way interactions, and so
on.

{phang2}
{cmd:sort(coef)}
orders rows in descending order by the absolute values of the coefficients.
When results from two or more estimation results are 
displayed, results are sorted first by the ordering for the first estimation 
result with rows representing coefficients not in the first estimation result
last.  Within the rows representing coefficients not in the first estimation 
result, the rows are sorted by the ordering for the second estimation result
with rows representing coefficients not in the first or second estimation
results last. And so on.

{dlgtab:Reporting}

{phang}
{cmd:noabbrev} prevents variable names from being abbreviated in the
row titles of the table.  Long variable names are split onto multiple
lines if they do not fit.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt vsquish},
{opt fvwrap(#)},
{opt fvwrapon(style)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress mpg gear turn}{p_end}
{phang2}{cmd:. estimates store small}{p_end}
{phang2}{cmd:. regress mpg gear turn length}{p_end}
{phang2}{cmd:. estimates store large}

{pstd}Show which covariates were fit in the {cmd:small} and {cmd:large}
estimation results{p_end}
{phang2}{cmd:. estimates selected small large}

{pstd}Same as above, but sort on the covariate names{p_end}
{phang2}{cmd:. estimates selected small large, sort(names)}

{pstd}Same as above, but display coefficient values{p_end}
{phang2}{cmd:. estimates selected small large, sort(names) display(coef)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estimates selected} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(names)}}names of results used{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(coef)}}matrix {it:M}: {it:n} {it:x} {it:m}{p_end}
{synopt:}{it:M}[{it:i}, {it:j}] = 
{it:i}th coefficient estimate for model {it:j};{break}
{it:i} = 1, ..., {it:n}; j = 1, ..., {it:m}
{p_end}
{p2colreset}{...}
