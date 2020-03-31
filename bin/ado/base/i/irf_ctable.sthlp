{smcl}
{* *! version 1.2.2  19oct2017}{...}
{viewerdialog "irf ctable" "dialog irf_ctable"}{...}
{vieweralsosee "[TS] irf ctable" "mansection TS irfctable"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] irf" "help irf"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] vec intro" "help vec_intro"}{...}
{viewerjumpto "Syntax" "irf_ctable##syntax"}{...}
{viewerjumpto "Menu" "irf_ctable##menu"}{...}
{viewerjumpto "Description" "irf_ctable##description"}{...}
{viewerjumpto "Links to PDF documentation" "irf_ctable##linkspdf"}{...}
{viewerjumpto "Options" "irf_ctable##options"}{...}
{viewerjumpto "Examples" "irf_ctable##examples"}{...}
{viewerjumpto "Stored results" "irf_ctable##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[TS] irf ctable} {hline 2}}Combined tables of IRFs, 
dynamic-multiplier functions, and FEVDs
{p_end}
{p2col:}({mansection TS irfctable:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:irf}
{opt ct:able}
{opt (spec_1)}
[{opt (spec_2)}
...
[{cmd:(}{it:spec_N}{cmd:)}]]
[{cmd:,}
{it:{help irf_cgraph##options_table:options}}]

{pstd}
where {opt (spec_k)} is

{p 8 12 2}
{cmd:(}{it:irfname} {it:impulsevar}
{it:responsevar}
{it:{help irf_ctable##stat:stat}}
[{cmd:,}
{it:{help irf_ctable##spec_options:spec_options}}]{cmd:)}

{pstd}
{it:irfname} is the name of a set of IRF results in the active IRF file.
{it:impulsevar} should be specified as an endogenous variable for all
statistics except {cmd:dm} and {cmd:cdm}; for those, specify as an exogenous
variable.
{it:responsevar} is an endogenous variable name. 
{it:stat} is one or more statistics from the list below:


{marker stat}{...}
INCLUDE help _irf_stats

{marker options_table}{...}
{synoptset 19}{...}
{synopthdr:options}
{synoptline}
{synopt:{opth set(filename)}}make {it:filename} active{p_end}
{synopt:{opt noci}}do not report confidence intervals{p_end}
{synopt:{opt std:error}}include standard errors for each statistic{p_end}
{synopt:{opt in:dividual}}make an individual table for each combination{p_end}
{synopt:{cmdab:ti:tle("}{it:text}{cmd:")}}use {it:text} as overall table
title{p_end}
{synopt:{opt st:ep(#)}}set common maximum set{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p2colreset}{...}

{marker spec_options}{...}
{synoptset 19}{...}
{synopthdr:spec_options}
{synoptline}
{synopt:{opt noci}}do not report confidence intervals{p_end}
{synopt:{opt std:error}}include standard errors for each statistic{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{cmdab:iti:tle("}{it:text}{cmd:")}}use {it:text} as individual
subtitle for specific table{p_end}
{synoptline}
{p 4 6 2}
{it:spec_options} may be specified within a table specification, globally, or
in both.  When specified in a table specification, the {it:spec_options} affect
only the specification in which they are used.  When supplied globally, the
{it:spec_options} affect all table specifications.  When supplied in both
places, options for the table specification take precedence.  {p_end}
{p 4 6 2}
{cmd:ititle()} does not appear in the dialog box.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > IRF and FEVD analysis >}
    {bf:Combined tables}


{marker description}{...}
{title:Description}

{pstd}
{cmd:irf ctable} makes a table or a combined table of IRF results.  A
table is made for specified combinations of named IRF results, impulse
variables, response variables, and statistics.  {cmd:irf ctable} combines
these tables into one table, unless separate tables are requested.

{pstd}
{cmd:irf ctable} operates on the active IRF file; see
{manhelp irf_set TS:irf set}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS irfctableQuickstart:Quick start}

        {mansection TS irfctableRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth set(filename)} specifies the file to be made active; see 
    {manhelp irf_set TS:irf set}.  If {opt set()} is not specified, the active
    file is used.

{phang}
{opt noci} suppresses reporting of the confidence intervals for each
    statistic.  {opt noci} is assumed when the model was fit by
    {helpb vec} because no confidence intervals were estimated.

{phang}
{opt stderror} specifies that standard errors for each statistic also be
    included in the table.

{phang}
{opt individual} places each block, or ({it:spec_k}), in its own table.
    By default, {opt irf ctable} combines all the blocks into one table.

{phang}
{cmd:title("}{it:text}{cmd:")} specifies a title for the table or the set of
    tables.

{phang}
{opt step(#)} specifies the maximum number of steps to use for all
  tables.  By default, each table is constructed using all steps available.

{phang}
{opt level(#)} specifies the default confidence level, as a
    percentage, for confidence intervals, when they are reported.  The default
    is {cmd:level(95)} or as set by {helpb set level}.

{pstd}
The following option is available with {opt irf ctable} but is not shown in the
dialog box:

{phang}
{cmd:ititle("}{it:text}{cmd:")} specifies an individual subtitle for a specific
    table.  {opt ititle()} may be specified only when the {opt individual}
    option is also specified.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}{p_end}
{phang2}{cmd:. var dln_inv dln_inc dln_consump}{p_end}
{phang2}{cmd:. irf set results4}{p_end}
{phang2}{cmd:. irf create ordera, step(8)}{p_end}
{phang2}{cmd:. irf create orderb, order(dln_inv dln_inc dln_consump) step(8)}
{p_end}

{pstd}Create table of orthogonalized impulse-response functions and Cholesky
FEVDs for models {cmd:ordera} and {cmd:orderb}{p_end}
{phang2}{cmd:. irf ctable (ordera dln_inc dln_consump oirf fevd)}
          {cmd:(orderb dln_inc dln_consump oirf fevd)}{p_end}

{pstd}Same as above, but include standard errors instead of CIs{p_end}
{phang2}{cmd:. irf ctable (ordera dln_inc dln_consump oirf fevd)}
          {cmd:(orderb dln_inc dln_consump oirf fevd), noci stderror}{p_end}

{pstd}Create separate tables for Cholesky FEVDs for models {cmd:ordera} and
{cmd:orderb}{p_end}
{phang2}{cmd:. irf ctable (ordera dln_inc dln_consump fevd)}
          {cmd:(orderb dln_inc dln_consump fevd), individual}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:irf ctable} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(ncols)}}number of columns in all tables{p_end}
{synopt:{cmd:r(k_umax)}}number of distinct keys{p_end}
{synopt:{cmd:r(k)}}number of specific table commands{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(key}{it:#}{cmd:)}}{it:#}th key{p_end}
{synopt:{cmd:r(tnotes)}}list of keys applied to each column{p_end}
{p2colreset}{...}
