{smcl}
{* *! version 1.1.6  19oct2017}{...}
{viewerdialog "irf add" "dialog irf_add"}{...}
{vieweralsosee "[TS] irf add" "mansection TS irfadd"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] irf" "help irf"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] vec intro" "help vec_intro"}{...}
{viewerjumpto "Syntax" "irf_add##syntax"}{...}
{viewerjumpto "Menu" "irf_add##menu"}{...}
{viewerjumpto "Description" "irf_add##description"}{...}
{viewerjumpto "Links to PDF documentation" "irf_add##linkspdf"}{...}
{viewerjumpto "Option" "irf_add##option"}{...}
{viewerjumpto "Examples" "irf_add##examples"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[TS] irf add} {hline 2}}Add results from an IRF file to the active IRF file{p_end}
{p2col:}({mansection TS irfadd:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:irf} {opt a:dd}
{c -(}
{opt _all}|[{it:newname}{cmd:=}]{it:oldname ...}{c )-}
{cmd:,}
{opt using(irf_filename)}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > Manage IRF results and files >}
     {bf:Add IRF results}


{marker description}{...}
{title:Description}

{pstd}
{opt irf add} copies results from an existing IRF file on disk to the active
IRF file, set by {helpb irf set}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS irfaddQuickstart:Quick start}

        {mansection TS irfaddRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt using(irf_filename)} specifies the file from which the results are to be
   obtained and is required.  If {it:irf_filename} is specified without an
   extension, {opt .irf} is assumed.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}

{pstd}Fit a VAR model{p_end}
{phang2}{cmd:. var dln_inv dln_inc dln_consump if qtr<=tq(1978q4), lags(1/2)}
           {cmd:dfk}

{pstd}Create IRF results {cmd:original}, {cmd:order2} and save them in IRF
files {cmd:irf1} and {cmd:irf2}, respectively{p_end}
{phang2}{cmd:. irf create original, set(irf1, replace)}{p_end}
{phang2}{cmd:. irf create order2, order(dln_inc dln_inv dln_consump)}
             {cmd:set(irf2, replace)}{p_end}

{pstd}Copy IRF results {cmd:original} to the active file giving them the name
{cmd:order1}{p_end}
{phang2}{cmd:. irf add order1 = original, using(irf1)}

{pstd}Create new IRF results and save them in the new file {cmd:irf3}{p_end}
{phang2}{cmd:. irf create order3, order(dln_inc dln_consump dln_inv)}
            {cmd:set(irf3, replace)}

{pstd}Copy all IRF results in file {cmd:irf2} into the active file{p_end}
{phang2}{cmd:. irf add _all, using(irf2)}{p_end}
