{smcl}
{* *! version 1.2.2  19oct2017}{...}
{viewerdialog "irf table" "dialog irf_table"}{...}
{vieweralsosee "[TS] irf table" "mansection TS irftable"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] irf" "help irf"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] vec intro" "help vec_intro"}{...}
{viewerjumpto "Syntax" "irf_table##syntax"}{...}
{viewerjumpto "Menu" "irf_table##menu"}{...}
{viewerjumpto "Description" "irf_table##description"}{...}
{viewerjumpto "Links to PDF documentation" "irf_table##linkspdf"}{...}
{viewerjumpto "Options" "irf_table##options"}{...}
{viewerjumpto "Examples" "irf_table##examples"}{...}
{viewerjumpto "Stored results" "irf_table##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[TS] irf table} {hline 2}}Tables of IRFs,
dynamic-multiplier functions, and FEVDs{p_end}
{p2col:}({mansection TS irftable:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:irf} {opt t:able}
[{it:{help irf table##stat:stat}}]
[{cmd:,} {it:{help irf_table##options_table:options}}]

{marker stat}{...}
INCLUDE help _irf_stats
{p 4 6 2}If {it:stat} is not specified, all statistics are included,
unless option {cmd:nostructural} is also specified, in which case {cmd:sirf}
and {cmd:sfevd} are excluded. You may specify more than one {it:stat}.{p_end}

{marker options_table}{...}
{synoptset 29 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opth s:et(filename)}}make {it:filename} active{p_end}
{synopt:{opt ir:f(irfnames)}}use {it:irfnames} IRF result sets{p_end}
{synopt:{opt i:mpulse(impulsevar)}}use {it:impulsevar} as impulse variables{p_end}
{synopt:{opt r:esponse(endogvars)}}use endogenous variables as response
variables{p_end}
{synopt:{opt in:dividual}}make an individual table for each result set{p_end}
{synopt:{cmdab:ti:tle("}{it:text}{cmd:")}}use {it:text} for overall table
title {p_end}

{syntab:Options}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt noci}}suppress confidence intervals{p_end}
{synopt:{opt std:error}}include standard errors in the tables{p_end}
{synopt:{opt nostr:uctural}}suppress {opt sirf} and {opt sfevd} from the
default list of statistics {p_end}
{synopt:{opt st:ep(#)}}use common maximum step horizon {it:#} for all tables{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > IRF and FEVD analysis >}
   {bf:Tables by impulse or response}


{marker description}{...}
{title:Description}

{pstd}
{opt irf table} makes a table of the values of the requested statistics at
each time since impulse.  Each column represents a combination of an impulse
variable and a response variable for each statistic from the named IRF
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS irftableQuickstart:Quick start}

        {mansection TS irftableRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth set(filename)} specifies the file to be made active; see 
   {manhelp irf_set TS:irf set}.  If {opt set()} is not specified, the active
   file is used.

{pmore}
    All results are obtained from one IRF file.
    If you have results in different files that you want in one 
    table, use {cmd:irf add} to copy results into one file; see
    {helpb irf add:[TS] irf add}.

{phang}
{cmd:irf(}{it:irfnames}{cmd:)} specifies the IRF result sets
    to be used.  If {opt irf()} is not specified, all the results in the
    active IRF file are used.  (Files often contain just one set of IRF
    results, saved under one {it:irfname}; in that case, those results
    are used.  When there are multiple IRF results, you may also wish to
    specify the {opt individual} option.)

{phang}
{opt impulse(impulsevar)} specifies the impulse 
    variables for which the statistics are to be reported. If {opt impulse()}
    is not specified, each model variable, in turn, is used.  {it:impulsevar}
    should be specified as an endogenous variable for all statistics except 
    {cmd:dm} or {cmd:cdm}; for those, specify as an exogenous variable.

{phang}
{opt response(endogvars)} specifies the response
    variables for which the statistics are to be reported.
    If {opt response()} is not specified, each endogenous variable, in turn,
    is used.

{phang}
{opt individual} specifies that each set of IRF results be placed in
    its own table, with its own title and footer.  By default, {opt irf table}
    places all the IRF results in one table with one title and
    one footer.  {opt individual} may not be combined with {opt title()}.

{phang}
{cmd:title("}{it:text}{cmd:")} specifies a title for the overall table.

{dlgtab:Options}

{phang}
{opt level(#)} specifies the default confidence level, as a
    percentage, for confidence intervals, when they are reported.  The default
    is {cmd:level(95)} or as set by {helpb set level}.

{phang}
{opt noci} suppresses reporting of the confidence intervals for each statistic.
    {opt noci} is assumed when the model was fit by {cmd:vec}
    because no confidence intervals were estimated.

{phang}
{opt stderror} specifies that standard errors for each statistic also be
    included in the table.

{phang}
{opt nostructural} specifies that {it:stat}, when not specified,
   exclude {opt sirf} and {opt sfevd}.

{phang}
{opt step(#)} specifies the maximum step horizon for all
    tables.  If {opt step()} is not specified, each table is constructed
    using all steps available.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}{p_end}
{phang2}{cmd:. var dln_inv dln_inc dln_consump}{p_end}
{phang2}{cmd:. irf set results4}{p_end}
{phang2}{cmd:. irf create ordera, step(8)}{p_end}
{phang2}{cmd:. irf create orderb, order(dln_inc dln_inv dln_consump) step(8)}
{p_end}

{pstd}Create table of orthogonalized impulse-response functions and Cholesky
FEVDs for models {cmd:ordera} and {cmd:orderb} using {cmd:dln_inc} as the
impulse variable and {cmd:dln_consump} as the response variable{p_end}
{phang2}{cmd:. irf table oirf fevd, impulse(dln_inc) response(dln_consump)}
{p_end}

{pstd}Same as above, but do not show CIs and do show standard errors{p_end}
{phang2}{cmd:. irf table oirf fevd, impulse(dln_inc) response(dln_consump)}
              {cmd:noci stderror}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
If the {cmd:individual} option is not specified, {cmd:irf table} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(ncols)}}number of columns in table{p_end}
{synopt:{cmd:r(k_umax)}}number of distinct keys{p_end}
{synopt:{cmd:r(k)}}number of specific table commands{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(key}{it:#}{cmd:)}}{it:#}th key{p_end}
{synopt:{cmd:r(tnotes)}}list of keys applied to each column{p_end}

{pstd}
If the {cmd:individual} option is specified, then for each {it:irfname},
{cmd:irf table} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_ncols)}}number of columns in table for
{it:irfname}{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_k_umax)}}number of distinct keys in table for
{it:irfname}{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_k)}}number of specific table commands used to
create table for {it:irfname}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_key}{it:#}{cmd:)}}{it:#}th key for
{it:irfname} table{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_tnotes)}}list of keys applied to each column in
table for  {it:irfname}{p_end}
{p2colreset}{...}
