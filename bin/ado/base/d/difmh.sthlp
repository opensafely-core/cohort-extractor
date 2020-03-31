{smcl}
{* *! version 1.0.7  18sep2018}{...}
{viewerdialog irt "dialog irt"}{...}
{vieweralsosee "[IRT] difmh" "mansection IRT difmh"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] diflogistic" "help diflogistic"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] DIF" "help dif"}{...}
{vieweralsosee "[IRT] irt" "help irt"}{...}
{viewerjumpto "Syntax" "difmh##syntax"}{...}
{viewerjumpto "Menu" "difmh##menu_irt"}{...}
{viewerjumpto "Description" "difmh##description"}{...}
{viewerjumpto "Links to PDF documentation" "difmh##linkspdf"}{...}
{viewerjumpto "Options" "difmh##options"}{...}
{viewerjumpto "Examples" "difmh##examples"}{...}
{viewerjumpto "Stored results" "difmh##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[IRT] difmh} {hline 2}}Mantel-Haenszel DIF{p_end}
{p2col:}({mansection IRT difmh:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:difmh} {varlist} 
{ifin}
[{help difmh##weight:{it:weight}}]{cmd:,}
{opth gr:oup(varname)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{p2coldent :* {opth gr:oup(varname)}}specify variable that identifies
groups{p_end}
{synopt :{opth total(varname)}}specify total score variable{p_end}
{synopt :{opth items:(varlist:varlist_i)}}calculate Mantel-Haenszel (MH) statistics for items in {it:varlist_i} only{p_end}
{synopt :{opt noyates}}do not apply Yates's correction for continuity; default is to
apply the continuity correction{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt maxp(#)}}display only items with p-value {ul:<} {it:#}{p_end}
{synopt :{opth sf:ormat(%fmt)}}display format for chi-squared values; default is {cmd:sformat(%9.2f)}{p_end}
{synopt :{opth pf:ormat(%fmt)}}display format for p-values; default is {cmd:pformat(%9.4f)}{p_end}
{synopt :{opth of:ormat(%fmt)}}display format for odds-ratio statistics; default is {cmd:oformat(%9.4f)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt group()} is required.{p_end}
{marker weight}{...}
{p 4 6 2}{opt fweight}s are allowed; see {help weight}.


INCLUDE help menu_irt


{marker description}{...}
{title:Description}

{pstd}
{cmd:difmh} calculates the MH chi-squared and common odds ratio for
dichotomously scored items.  The MH statistics are used to determine whether
an item exhibits uniform differential item functioning (DIF) between two
observed groups, that is, whether an item favors one group relative to the
other for all values of the latent trait.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection IRT difmhQuickstart:Quick start}

        {mansection IRT difmhRemarksandexamples:Remarks and examples}

        {mansection IRT difmhMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth group(varname)}
	specifies the numeric variable that identifies the focal group and
	the reference group.  The groups should be coded 1 and 0,
	respectively.  {cmd:group()} is required.

{phang}
{opth total(varname)}
	specifies the variable to be used as a total score.
	By default, the total score is calculated as the row sum
	of the item variables.
	
{phang}
{opth items:(varlist:varlist_i)}
	requests that MH statistics be calculated
	only for the specified items.  {it:varlist_i} must be a subset
	of {it:varlist}. By default, the statistics are
	calculated for all the items in {it:varlist}.

{phang}
{opt noyates}
	specifies that Yates's correction for continuity not be applied
	when calculating the MH chi-squared statistic. By default, the
	continuity correction is applied. 

{dlgtab:Reporting}

{phang}
{opt level(#)}; see 
{helpb estimation options:[R] Estimation options}.

{phang}
{opt maxp(#)}
	requests that only items with p-value {ul:<} {it:#} be displayed.

{phang}
{opth sformat(%fmt)}
	specifies the display format used for the chi-squared values
        of the output table.  The default is {cmd:sformat(%9.2f)}.

{phang}
{opth pformat(%fmt)}
	specifies the display format used for the p-values
        of the output table.  The default is {cmd:pformat(%9.4f)}.

{phang}
{opth oformat(%fmt)}
	specifies the display format used for the odds-ratio statistics
        of the output table.  The default is {cmd:oformat(%9.4f)}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse masc2}

{pstd}Perform the MH procedure on items {cmd:q1-q9}{p_end}
{phang2}{cmd:. difmh q1-q9, group(female)}

{pstd}Same as above, but request the MH statistics for items {cmd:q1},
{cmd:q5}, and {cmd:q9}{p_end}
{phang2}{cmd:. difmh q1-q9, group(female) items(q1 q5 q9)}

{pstd}Replay the results and show only items significant at the 0.1 level{p_end}
{phang2}{cmd:. difmh, maxp(.1)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:difmh} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(level)}}significance level{p_end}
{synopt:{cmd:r(yates)}}{cmd:1} if Yates's continuity correction is used,
{cmd:0} otherwise{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(cmd)}}{cmd:difmh}{p_end}
{synopt:{cmd:r(cmdline)}}command as typed{p_end}
{synopt:{cmd:r(items)}}names of items{p_end}
{synopt:{cmd:r(wtype)}}weight type{p_end}
{synopt:{cmd:r(wexp)}}weight expression{p_end}
{synopt:{cmd:r(group)}}group variable{p_end}
{synopt:{cmd:r(total)}}name of alternative total score variable, if
specified{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(dif)}}results table{p_end}
{synopt:{cmd:r(sigma2)}}estimated variance of the common odds ratio{p_end}
{synopt:{cmd:r(_N)}}number of observations per item{p_end}
{p2colreset}{...}
