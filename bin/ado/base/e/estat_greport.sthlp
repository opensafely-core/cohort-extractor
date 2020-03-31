{smcl}
{* *! version 1.0.0  11feb2019}{...}
{viewerdialog irt "dialog irt"}{...}
{vieweralsosee "[IRT] estat greport" "mansection IRT estatgreport"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] irt" "help irt"}{...}
{vieweralsosee "[IRT] irt, group()" "help irt_group"}{...}
{vieweralsosee "[IRT] irt 1pl" "help irt 1pl"}{...}
{vieweralsosee "[IRT] irt 2pl" "help irt 2pl"}{...}
{vieweralsosee "[IRT] irt 3pl" "help irt 3pl"}{...}
{vieweralsosee "[IRT] irt grm" "help irt grm"}{...}
{vieweralsosee "[IRT] irt hybrid" "help irt hybrid"}{...}
{vieweralsosee "[IRT] irt nrm" "help irt nrm"}{...}
{vieweralsosee "[IRT] irt pcm" "help irt pcm"}{...}
{vieweralsosee "[IRT] irt rsm" "help irt rsm"}{...}
{viewerjumpto "Syntax" "estat greport##syntax"}{...}
{viewerjumpto "Menu" "estat greport##menu_irt"}{...}
{viewerjumpto "Description" "estat greport##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_greport##linkspdf"}{...}
{viewerjumpto "Options" "estat greport##options"}{...}
{viewerjumpto "Examples" "estat greport##examples"}{...}
{viewerjumpto "Stored results" "estat greport##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[IRT] estat greport} {hline 2}}Report estimated group IRT parameters{p_end}
{p2col:}({mansection IRT estatgreport:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
        {cmd:estat} {cmdab:grep:ort} 
	[{cmd:,} {it:options}]


{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{cmd:sort(}{it:p}[{cmd:,} {opt d:escending}]{cmd:)}}sort items by the
    estimated {it:p} parameters; {it:p} may be {cmd:a}, {cmd:b}, or {cmd:c}
    {p_end}
{synopt :{opt byp:arm}}arrange table rows by parameter rather than by
    item{p_end}

{syntab:Main}
{synopt :{opt alab:el(string)}}specify the {cmd:a} parameter label; the
    default is {cmd:Discrim}{p_end}
{synopt :{opt blab:el(string)}}specify the {cmd:b} parameter label; the
    default is {cmd:Diff}{p_end}
{synopt :{opt clab:el(string)}}specify the {cmd:c} parameter label; the
    default is {cmd:Guess}{p_end}
{synopt :{opt seq:label}}label parameters in sequential order{p_end}
{synopt :{opt post}}post estimated IRT parameters and their VCE as
estimation results{p_end}

{syntab:Reporting}
{synopt :{cmd:b}[{cmd:(}{help format:{bf:%}{it:fmt}}{cmd:)}]}how to format
coefficients, which are always reported{p_end}
{synopt :{cmd:se}[{cmd:(}{help format:{bf:%}{it:fmt}}{cmd:)}]}report standard
errors and use optional format{p_end}
{synopt :{cmd:t}[{cmd:(}{help format:{bf:%}{it:fmt}}{cmd:)}]}report t or z
statistics and use optional format{p_end}
{synopt :{cmd:p}[{cmd:(}{help format:{bf:%}{it:fmt}}{cmd:)}]}report p-values
and use optional format{p_end}
{synopt :{opt parmw:idth(#)}}use {it:#} characters to display variable and
 parameter names{p_end}
{synopt :{opt grw:idth(#)}}use {it:#} characters to display group names
and statistics{p_end}
{synopt :{cmdab:sty:le}{cmd:(oneline)}}display vertical line after variable names; the default{p_end}
{synopt :{cmdab:sty:le}{cmd:(columns)}}display vertical lines separating columns{p_end}
{synopt :{cmdab:sty:le}{cmd:(noline)}}suppress all vertical lines{p_end}
{synopt :{opt grlab:el(string)}}column labels for groups{p_end}
{synopt :{opt ti:tle(string)}}title for table{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_irt


{marker description}{...}
{title:Description}

{pstd}
{opt estat greport} displays the estimated group IRT parameters.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection IRT estatgreportQuickstart:Quick start}

        {mansection IRT estatgreportRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:sort(}{it:p}[{cmd:,} {opt descending}]{cmd:)}
requests that items be sorted according to parameter {it:p},
where {it:p} is one of {cmd:a}, {cmd:b}, or {cmd:c}.

{phang2}
{cmd:sort(a)} specifies that items be sorted according to the estimated
discrimination parameters.

{phang2}
{cmd:sort(b)} specifies that items be sorted according to the estimated
difficulty parameters.

{phang2}
{cmd:sort(c)} specifies that items be sorted according to the estimated
pseudoguessing parameters.  It is relevant only for a 3PL model
when option {cmd:sepguessing} is specified.

{phang2}
{cmd:descending} requests that the sorted items be reported in descending
order.
Sorted items are reported in ascending order by default.

{phang}
{opt byparm}
requests that the table rows be grouped by parameter rather than by
item.

{dlgtab:Main}

{phang}
{opt alabel(string)}
labels the discrimination parameters with {it:string}.
The default label is {cmd:Discrim}.
	
{phang}
{opt blabel(string)}
labels the difficulty parameters with {it:string}.
The default label is {cmd:Diff}.
	
{phang}
{opt clabel(string)}
labels the pseudoguessing parameters with {it:string}.
The default label is {cmd:Guess}.
This option applies only to 3PL models.

{phang}
{opt seqlabel}
labels the estimated difficulty parameters within each categorical item
sequentially, starting from 1.
In NRM, {opt seqlabel} also labels the estimated discrimination
parameters within each item sequentially, starting from 1.
This option applies only to categorical models.

{phang}
{opt post}
causes {opt estat greport} to behave like a Stata estimation (e-class)
command.
{opt estat greport} posts the vector of estimated IRT parameters
along with the corresponding variance-covariance matrix to {opt e()},
so that you can treat the estimated IRT parameters just as you would results
from any other estimation command.
For example, you could use {opt test} to perform simultaneous tests of
hypotheses on the parameters, or you could use {opt lincom} to create
linear combinations.

{dlgtab:Reporting}

{phang}
{cmd:b}{cmd:(}{help format:{bf:%}{it:fmt}}{cmd:)}
specifies how the coefficients are to be displayed.  You might
specify {cmd:b(%9.2f)} to make decimal points line up.  There is also a {cmd:b}
option, which specifies that coefficients be displayed, but that is just
included for consistency with the {cmd:se}, {cmd:t}, and {cmd:p} options.
Coefficients are always displayed.

{phang}
{cmd:se}, {cmd:t}, and {cmd:p} specify that standard errors, t or z statistics,
and p-values be displayed.  The default is not to display them.
{opth se(fmt)}, {opt t(%fmt)}, and {opt p(%fmt)} specify that each be displayed
and specify the display format to be used.

{phang}
{opt parmwidth(#)} specifies the number of character positions used to display
the names of the variables and parameters.  The default is {cmd:parmwidth(12)}.

{phang}
{opt grwidth(#)} specifies the number of character positions used to display
the names of the groups and statistics.  The default is {cmd:grwidth(12)}.

{phang}
{opt style(stylespec)} specifies the style of the coefficient table.

{pmore}
{cmd:style(oneline)} specifies that a vertical line be displayed after the
variables but not between the groups.  This is the default.

{pmore}
{cmd:style(columns)} specifies that vertical lines be displayed after each
column.

{pmore}
{cmd:style(noline)} specifies that no vertical lines be displayed.

{phang}
{opt grlabel(string)} specifies the labels for the group columns.  The
default is to use value labels of the group variable or, if the group variable
has no value labels, a factor-variable indicator for each level of the group
variable.

{phang}
{opt title(string)} specifies the title to appear above the table.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse masc2}{p_end}
{phang2}{cmd:. irt 2pl q1-q5, group(female)}{p_end}

{pstd}Display the estimated difficulty and discrimination parameters 
with a separate column for each group{p_end}
{phang2}{cmd:. estat greport}{p_end}

{pstd}As above, but sort by difficulty in ascending order{p_end}
{phang2}{cmd:. estat greport, sort(b)}{p_end}

{pstd}As above, but sort first by parameter type and then by difficulty{p_end}
{phang2}{cmd:. estat greport, sort(b) byparm}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat greport} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(names)}}labels used for group names{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(b)}}vector of estimated IRT parameters{p_end}
{synopt:{cmd:r(b_pclass)}}parameter class{p_end}
{synopt:{cmd:r(V)}}variance-covariance matrix of the estimated IRT
parameters{p_end}
{p2colreset}{...}


{pstd}
{cmd:estat greport} with the {cmd:post} option also stores the following
in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}vector of estimated IRT parameters{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimated IRT
parameters{p_end}
{p2colreset}{...}
