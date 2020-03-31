{smcl}
{* *! version 2.2.18  14may2018}{...}
{viewerdialog "estimates table" "dialog estimates_table"}{...}
{vieweralsosee "[R] estimates table" "mansection R estimatestable"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estimates" "help estimates"}{...}
{viewerjumpto "Syntax" "estimates_table##syntax"}{...}
{viewerjumpto "Menu" "estimates_table##menu"}{...}
{viewerjumpto "Description" "estimates_table##description"}{...}
{viewerjumpto "Links to PDF documentation" "estimates_table##linkspdf"}{...}
{viewerjumpto "Options" "estimates_table##options"}{...}
{viewerjumpto "Examples" "estimates_table##examples"}{...}
{viewerjumpto "Stored results" "estimates_table##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[R] estimates table} {hline 2}}Compare estimation results{p_end}
{p2col:}({mansection R estimatestable:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{opt est:imates} {opt tab:le} 
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
{synopt:{cmd:stats(}{it:{help estimates table##scalarlist:scalarlist}}{cmd:)}}report {it:scalarlist} in table{p_end}
{synopt:{cmd:star}[{cmd:(}{it:{help estimates table##123:#1 #2 #3}}{cmd:)}]}use 
          stars to denote significance{p_end}

{syntab:Options}
{synopt:{cmdab:k:eep(}{it:{help estimates table##coeflist:coeflist}}{cmd:)}}report coefficients in order
            specified{p_end}
{synopt:{cmdab:d:rop(}{it:{help estimates table##coeflist:coeflist}}{cmd:)}}omit specified coefficients from table{p_end}
{synopt:{opt eq:uations}{cmd:(}{it:{help estimates table##matchlist:matchlist}}{cmd:)}}match equations of models
           as specified{p_end}

{syntab:Numerical formats}
{synopt:{cmd:b}[{cmd:(}{help %fmt:{bf:%}{it:fmt}}{cmd:)}]}how to format
           coefficients, which are always reported{p_end}
{synopt:{cmd:se}[{cmd:(}{help %fmt:{bf:%}{it:fmt}}{cmd:)}]}report standard
           errors and use optional format{p_end}
{synopt:{cmd:t}[{cmd:(}{help %fmt:{bf:%}{it:fmt}}{cmd:)}]}report t or z and use
           optional format{p_end}
{synopt:{cmd:p}[{cmd:(}{help %fmt:{bf:%}{it:fmt}}{cmd:)}]}report p-values and
           use optional format{p_end}
{synopt:{opt stf:mt}{cmd:(}{help %fmt:{bf:%}{it:fmt}}{cmd:)}}how to format
           scalar statistics{p_end}

{syntab:General format}
{synopt:{opt var:width}{cmd:(}{it:#}{cmd:)}}use {it:#} characters to display
           variable names and statistics{p_end}
{synopt:{opt model:width}{cmd:(}{it:#}{cmd:)}}use {it:#} characters to display model names

{synopt:{cmd:eform}}display coefficients in exponentiated form{p_end}
{synopt:{opt varl:abel}}display variable labels rather than variable names{p_end}
{synopt:{opt new:panel}}display statistics in separate table from coefficients{p_end}

{synopt:{opt sty:le}{cmd:(oneline)}}put vertical line after variable
          names; the default{p_end}
{synopt:{opt sty:le}{cmd:(columns)}}put vertical line separating every
          column{p_end}
{synopt:{opt sty:le}{cmd:(noline)}}suppress all vertical lines{p_end}

{synopt:{opt cod:ed}}display compact table{p_end}

{syntab:Reporting}
{synopt :{it:{help estimates_table##display_options:display_options}}}control
       row spacing, line width, and display of omitted variables and base and
       empty cells
{p_end}

{synopt:{opt ti:tle}{cmd:(}{it:{help strings:string}}{cmd:)}}title for table{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{cmd:title()} does not appear in the dialog box.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estimates} {cmd:table} 
organizes estimation results from one or more models in a single formatted
table.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R estimatestableQuickstart:Quick start}

        {mansection R estimatestableRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{marker scalarlist}{...}
{phang}
{cmd:stats(}{it:scalarlist}{cmd:)} specifies a list of any of or all the names
of scalars stored in {cmd:e()} to be displayed in the table.  {it:scalarlist}
may also contain the following:

		{cmd:aic}        Akaike's information criterion
		{cmd:bic}        Schwarz's Bayesian information criterion
		{cmd:rank}       rank of {cmd:e(V)} ({it:#} of free parameters in model)

{pmore} 
    The specified statistics do not have to be available for all estimation
    results being displayed.

{pmore} 
    For example, {cmd:stats(N ll chi2 aic)} specifies that 
    {cmd:e(N)}, {cmd:e(ll)}, {cmd:e(chi2)}, and AIC 
    be included.  In Stata, {cmd:e(N)} records the number 
    of observations; {cmd:e(ll)}, the log likelihood; and {cmd:e(chi2)},
    the chi-squared test that all coefficients in the first equation 
    of the model are equal to zero.

{marker 123}{...}
{phang}
{cmd:star} and {cmd:star(}{it:#1 #2 #3}{cmd:)} specify that 
    stars (asterisks) are to be used to mark significance.  The second syntax 
    specifies the significance for one, two, and three stars.  If you
    specify simply {cmd:star}, that is equivalent to specifying {cmd:star(.05}
    {cmd:.01} {cmd:.001}{cmd:)}, which means one star (*) if {it:p} < 0.05, two
    stars (**) if {it:p} < 0.01, and three stars (***) if {it:p} < 0.001.

{pmore}
    The {cmd:star} and {cmd:star()} options may not be combined with the 
    {cmd:se}, {cmd:t}, or {cmd:p} option.

{dlgtab:Options}

{marker coeflist}{...}
{phang}
{cmd:keep(}{it:coeflist}{cmd:)} 
and 
{cmd:drop(}{it:coeflist}{cmd:)} 
    are alternatives; they specify coefficients to be included or omitted from
    the table.  The default is to display all coefficients.

{pmore}
    If {cmd:keep()} is specified, it specifies not only the coefficients 
    to be included but also the order in which they appear.

{pmore}
    A {it:coeflist} is a list of coefficient names, each name of which may be
    simple (for example, {cmd:price}), an equation name followed by a colon
    (for example, {cmd:mean:}), or a full name (for example, {cmd:mean:price}).
    Names are separated from each other by blanks.

{pmore}
    When full names are not specified, all coefficients that match the 
    partial specification are included.  For instance, {cmd:drop(_cons)}
    would omit {cmd:_cons} for all equations.
 
{marker matchlist}{...}
{phang}
{cmd:equations(}{it:matchlist}{cmd:)} specifies how the equations of the
models in {it:namelist} are to be matched.
The default is to match equations by name.  Matching by name usually works 
well when all results were fit by the same estimation command.
When you are comparing results from different estimation commands, however,
specifying {cmd:equations()} may be necessary.

{pmore}
The most common usage is {cmd:equations(1)}, which indicates that all 
first equations are to be matched into one equation named {cmd:#1}.

{pmore} 
{it:matchlist} has the syntax 

		{it:term} [{cmd:,} {it:term} ... ]

{pmore} 
{it:term} is 

		[{it:eqname} {cmd:=}] {it:#}{cmd::}{it:#}...{cmd::}{it:#}{col 50}(syntax 1)

		[{it:eqname} {cmd:=}] {it:#}{col 50}(syntax 2)

{pmore}
In syntax 1, each {it:#} is a number or a period ({cmd:.}).  If a number, it
specifies the position of the equation in the corresponding model;
{cmd:1:3:1} would indicate that equation 1 in the first model matches equation
3 in the second, which matches equation 1 in the third.  A period indicates
that there is no corresponding equation in the model; {cmd:1:.:1} indicates
that equation 1 in the first matches equation 1 in the third.

{pmore} 
In syntax 2, you specify just one number, say, {cmd:1} or {cmd:2}, and that
is shorthand for {cmd:1:1}...{cmd::1} or {cmd:2:2}...{cmd::2}, meaning that
equation 1 matches across all models specified or that equation 2 matches
across all models specified.

{pmore} 
Now that you can specify a {it:term}, you can put that together into a
{it:matchlist} by separating one term from the other by commas.
In what follows, we will assume that three names were specified, 

		. {cmd:estimates table alpha beta gamma,} ...
	
{pmore} 
{cmd:equations(1)} is equivalent to {cmd:equations(1:1:1)}; we would be 
saying that the first equations match across the board.

{pmore} 
{cmd:equations(1:.:1)} would specify that equation 1 matches in models 
{cmd:alpha} and {cmd:gamma} but that there is nothing corresponding in 
model {cmd:beta}.

{pmore} 
{cmd:equations(1,2)} is equivalent to {cmd:equations(1:1:1, 2:2:2)}.
We would be saying that the first equations match across the board
and so do the second equations.

{pmore} 
{cmd:equations(1, 2:.:2)} would specify that the first equations match across 
the board, that the second equations match for models {cmd:alpha} and
{cmd:gamma}, and that there is nothing equivalent to equation 2 in model
{cmd:beta}.

{pmore} 
If {cmd:equations()} is specified, equations not matched by position are 
matched by name.

{dlgtab:Numerical formats}

{phang}
{opth b(%fmt)} specifies how the coefficients are to be 
    displayed.  You might specify {cmd:b(%9.2f)} to make decimal points line
    up.
    There is also a {cmd:b} option, which specifies that coefficients are to 
    be displayed, but that is just included for consistency with the 
    {cmd:se}, {cmd:t}, and {cmd:p} options.  Coefficients are always displayed.

{phang}
{cmd:se}, {cmd:t}, and {cmd:p} specify that standard errors, {it:t} or 
    {it:z} statistics, and p-values are to be displayed.
    The default is not to display them.
    {opth se(%fmt)},
    {opt t(%fmt)}, and 
    {opt p(%fmt)}
    specify that each is to be displayed and specifies the display format 
    to be used to format them.

{phang}
{opth stfmt(%fmt)} 
    specifies the format for displaying the scalar statistics included 
    by the {cmd:stats()} options.

{dlgtab:General format}

{phang}
{cmd:varwidth(}{it:#}{cmd:)}
    specifies the number of character positions used to display the 
    names of the variables and statistics.  The default is 12.

{phang}
{cmd:modelwidth(}{it:#}{cmd:)}
    specifies the number of character positions used to display the 
    names of the models.  The default is 12.

{phang}
{cmd:eform} displays coefficients in exponentiated form.  For each 
    coefficient, exp({it:b}) rather than {it:b} is displayed, 
    and standard errors are transformed appropriately.  Display of 
    the intercept, if any, is suppressed.

{phang}
{cmd:varlabel}
    specifies that variable labels be displayed instead of variable 
    names.

{phang}
{cmd:newpanel} specifies that the statistics be displayed in a table separated
    by a blank line from the table with coefficients rather than in the style
    of another equation in the table of coefficients.

{phang}
{cmd:style(}{it:stylespec}{cmd:)} specifies the style of the coefficient
    table.

{pmore} 
    {cmd:style(oneline)} specifies that a vertical line be displayed 
    after the variables but not between the models.  This is the default.

{pmore}
    {cmd:style(columns)} specifies that vertical lines be displayed after 
    each column.

{pmore} 
    {cmd:style(noline)} specifies that no vertical lines be displayed.

{phang}
{cmd:coded} specifies that a compact table be displayed.  This format 
    is especially useful for comparing variables that are included in a 
    large collection of models.

{dlgtab:Reporting}

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noomit:ted},
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels},
{opt nofvlab:el},
{opt fvwrap(#)}, and
{opt fvwrapon(style)};
    see {helpb estimation options##display_options:[R] Estimation options}.

{phang}
The following option is available with {cmd:estimates table} but is not
shown in the dialog box:

{phang}
{cmd:title(}{it:{help strings:string}}{cmd:)} specifies the title to appear
   above the table.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress mpg gear turn}{p_end}
{phang2}{cmd:. estimates store small}{p_end}
{phang2}{cmd:. regress mpg gear turn length}{p_end}
{phang2}{cmd:. estimates store large}

{pstd}Display a table of coefficients for both {cmd:small} and {cmd:large}
estimation results{p_end}
{phang2}{cmd:. estimates table small large}

{pstd}Same as above, but also display standard errors{p_end}
{phang2}{cmd:. estimates table small large, se}

{pstd}Same as above, but display coefficients and standard errors to 4 decimal
places{p_end}
{phang2}{cmd:. estimates table small large, b(%7.4f) se(%7.4f)}

{pstd}Same as above, but also display sample size and adjusted R-squared
{p_end}
{phang2}{cmd:. estimates table small large, b(%7.4f) se(%7.4f) stats(N r2_a)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estimates table} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(names)}}names of results used{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(coef)}}matrix {it:M}: {it:n} {it:x} 2*{it:m}{p_end}
{synopt:}{it:M}[{it:i}, 2{it:j}-1] = 
{it:i}th parameter estimate for model {it:j}; 
{p_end}
{synopt:}{it:M}[{it:i}, 2{it:j}{bind:  }] = 
variance of {it:M}[{it:i}, 2{it:j}-1];{break}
{it:i} = 1, ..., {it:n}; j = 1, ..., {it:m}
{p_end}

{synopt:{cmd:r(stats)}}matrix {it:S}: {it:k x m}
(if option {cmd:stats()} specified){p_end}
{synopt:}{it:S}[{it:i}, {it:j}] = {it:i}th statistic for model {it:j};{break}
i = 1, ..., {it:k}; {it:j} = 1, ..., {it:m}{p_end}
{p2colreset}{...}
