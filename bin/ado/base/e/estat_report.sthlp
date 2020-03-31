{smcl}
{* *! version 1.0.6  11feb2019}{...}
{viewerdialog irt "dialog irt"}{...}
{vieweralsosee "[IRT] estat report" "mansection IRT estatreport"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] irt" "help irt"}{...}
{vieweralsosee "[IRT] irt 1pl" "help irt 1pl"}{...}
{vieweralsosee "[IRT] irt 2pl" "help irt 2pl"}{...}
{vieweralsosee "[IRT] irt 3pl" "help irt 3pl"}{...}
{vieweralsosee "[IRT] irt grm" "help irt grm"}{...}
{vieweralsosee "[IRT] irt hybrid" "help irt hybrid"}{...}
{vieweralsosee "[IRT] irt nrm" "help irt nrm"}{...}
{vieweralsosee "[IRT] irt pcm" "help irt pcm"}{...}
{vieweralsosee "[IRT] irt rsm" "help irt rsm"}{...}
{viewerjumpto "Syntax" "estat report##syntax"}{...}
{viewerjumpto "Menu" "estat report##menu_irt"}{...}
{viewerjumpto "Description" "estat report##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_report##linkspdf"}{...}
{viewerjumpto "Options" "estat report##options"}{...}
{viewerjumpto "Examples" "estat report##examples"}{...}
{viewerjumpto "Stored results" "estat report##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[IRT] estat report} {hline 2}}Report estimated IRT parameters{p_end}
{p2col:}({mansection IRT estatreport:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
        {cmd:estat} {cmdab:rep:ort} [{varlist}]
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
{synopt :{opt lev:el(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt verbose}}display estimation output in long form{p_end}
{synopt :{help estat_report##display_options:{it:display_options}}}control
   columns and column formats{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}


INCLUDE help menu_irt


{marker description}{...}
{title:Description}

{pstd}
{opt estat report} displays the estimated IRT parameters.
Estimates can be reorganized and sorted by parameter type.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection IRT estatreportQuickstart:Quick start}

        {mansection IRT estatreportRemarksandexamples:Remarks and examples}

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
causes {opt estat report} to behave like a Stata estimation (e-class)
command.
{opt estat report} posts the vector of estimated IRT parameters
along with the corresponding variance-covariance matrix to {opt e()},
so that you can treat the estimated IRT parameters just as you would results
from any other estimation command.
For example, you could use {opt test} to perform simultaneous tests of
hypotheses on the parameters, or you could use {opt lincom} to create
linear combinations.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options:[R] Estimation options}.

{phang}
{opt verbose}
causes a separate discrimination, difficulty, and pseudoguessing parameter
to be displayed for each item, even if the parameters are constrained to be
the same across items.
This option is implied when option {opt post} is specified.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noci},
{opt nopv:alues},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
see {helpb estimation options:[R] Estimation options}.

{pstd}
The following option is available with {cmd:estat report} but is not shown in
the dialog box:

{phang}
{opt coeflegend}; see {helpb estimation options:[R] Estimation options}.
This option is allowed only with the {opt post} option.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse masc1}{p_end}
{phang2}{cmd:. irt 2pl q1-q9}{p_end}

{pstd}Display the estimated IRT parameters, sorting by difficulty in ascending
order{p_end}
{phang2}{cmd:. estat report, sort(b)}{p_end}

{pstd}As above, but sort first by parameter type and then by difficulty{p_end}
{phang2}{cmd:. estat report, sort(b) byparm}{p_end}

{pstd}Display parameter estimates for items {cmd:q3}, {cmd:q5}, and {cmd:q8}
and label the difficulty parameter {cmd:Location}{p_end}
{phang2}{cmd:. estat report q3 q5 q8, sort(b) byparm blabel(Location)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat report} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(level)}}confidence level{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(table)}}matrix containing the parameter estimates with their
standard errors, test statistics, p-values, and confidence intervals{p_end}
{synopt:{cmd:r(b)}}vector of estimated IRT parameters{p_end}
{synopt:{cmd:r(b_pclass)}}parameter class{p_end}
{synopt:{cmd:r(V)}}variance-covariance matrix of the estimated IRT
parameters{p_end}
{p2colreset}{...}


{pstd}
{cmd:estat report} with the {cmd:post} option also stores the following
in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}vector of estimated IRT parameters{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimated IRT
parameters{p_end}
{p2colreset}{...}
