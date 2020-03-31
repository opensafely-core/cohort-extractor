{smcl}
{* *! version 1.1.7  19oct2017}{...}
{viewerdialog "irf rename" "dialog irf_rename"}{...}
{vieweralsosee "[TS] irf rename" "mansection TS irfrename"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] irf" "help irf"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] vec intro" "help vec_intro"}{...}
{viewerjumpto "Syntax" "irf_rename##syntax"}{...}
{viewerjumpto "Menu" "irf_rename##menu"}{...}
{viewerjumpto "Description" "irf_rename##description"}{...}
{viewerjumpto "Links to PDF documentation" "irf_rename##linkspdf"}{...}
{viewerjumpto "Option" "irf_rename##option"}{...}
{viewerjumpto "Examples" "irf_rename##examples"}{...}
{viewerjumpto "Stored results" "irf_rename##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[TS] irf rename} {hline 2}}Rename an IRF result in an IRF file{p_end}
{p2col:}({mansection TS irfrename:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
{cmd:irf} {opt ren:ame}
	{it:oldname} {it:newname}
	[{cmd:,} {opth set(filename)}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > Manage IRF results and files >}
   {bf:Rename IRF results}


{marker description}{...}
{title:Description}

{pstd}
{opt irf rename} changes the name of a set of IRF results saved in the
active IRF file.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS irfrenameQuickstart:Quick start}

        {mansection TS irfrenameRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opth set(filename)} specifies the file to be made active; 
see {manhelp irf_set TS:irf set}.  If {opt set()} is not specified, the active
file is used.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}

{pstd}Fit a VAR model{p_end}
{phang2}{cmd:. var dln_inv dln_inc dln_consump if qtr<=tq(1978q4), lags(1/2)}
          {cmd:dfk}

{pstd}Create IRF results {cmd:original}, {cmd:order2}, and {cmd:order3} by using
various orderings of the endogenous variables{p_end}
{phang2}{cmd:. irf create original, set(myirfs, replace)}{p_end}
{phang2}{cmd:. irf create order2, order(dln_inc dln_inv dln_consump)}{p_end}
{phang2}{cmd:. irf create order3, order(dln_inc dln_consump dln_inv)}{p_end}

{pstd}Display short summary of IRF results{p_end}
{phang2}{cmd:. irf describe}

{pstd}Rename IRF result {cmd:original} to {cmd:order1}{p_end}
{phang2}{cmd:. irf rename original order1}

{pstd}Display summary of IRF results{p_end}
{phang2}{cmd:. irf describe}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:irf rename} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(irfnames)}}{it:irfnames} after rename{p_end}
{synopt:{cmd:r(oldnew)}}{it:oldname} {it:newname}{p_end}
{p2colreset}{...}
