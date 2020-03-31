{smcl}
{* *! version 1.1.11  20dec2018}{...}
{viewerdialog "irf describe" "dialog irf_describe"}{...}
{vieweralsosee "[TS] irf describe" "mansection TS irfdescribe"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] irf" "help irf"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] vec intro" "help vec_intro"}{...}
{viewerjumpto "Syntax" "irf_describe##syntax"}{...}
{viewerjumpto "Menu" "irf_describe##menu"}{...}
{viewerjumpto "Description" "irf_describe##description"}{...}
{viewerjumpto "Links to PDF documentation" "irf_describe##linkspdf"}{...}
{viewerjumpto "Options" "irf_describe##options"}{...}
{viewerjumpto "Examples" "irf_describe##examples"}{...}
{viewerjumpto "Stored results" "irf_describe##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[TS] irf describe} {hline 2}}Describe an IRF file{p_end}
{p2col:}({mansection TS irfdescribe:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 21 2}
{cmd:irf}
{opt d:escribe}
[{it:irf_resultslist}]
[{cmd:,}
{it:options}]

{synoptset 21}{...}
{synopthdr}
{synoptline}
{synopt:{opth set(filename)}}make {it:filename} active{p_end}
{synopt:{opt using(irf_filename)}}describe {it:irf_filename} without making active{p_end}
{synopt:{opt d:etail}}show additional details of IRF results{p_end}
{synopt:{opt v:ariables}}show underlying structure of the IRF dataset{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > Manage IRF results and files >}
     {bf:Describe IRF file}


{marker description}{...}
{title:Description}

{pstd}
{cmd:irf describe} describes the specification of the estimation command
and the specification of the IRF used to create the IRF results that are saved
in an IRF file.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS irfdescribeQuickstart:Quick start}

        {mansection TS irfdescribeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth set(filename)} specifies the IRF file to be described and set; see
   {manhelp irf_set TS:irf set}.  If {it:filename} is specified without an
   extension, {opt .irf} is assumed.

{phang}
{opt using(irf_filename)} specifies the IRF file to be described.  The active
   IRF file, if any, remains unchanged.  If {it:irf_filename} is specified
   without an extension, {opt .irf} is assumed.

{phang}
{opt detail} specifies that {opt irf describe} display detailed information
   about each set of IRF results.  {opt detail} is implied when
   {it:irf_resultslist} is specified.

{phang}
{opt variables} is a programmer's option; additionally displays the output
   produced by the {opt describe} command.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}

{pstd}Fit a VAR model{p_end}
{phang2}{cmd:. var dln_inv dln_inc dln_consump if qtr<=tq(1978q4), lags(1/2)}
           {cmd:dfk}

{pstd}Create IRF results {cmd:order1}, {cmd:order2}, and {cmd:order3} using
various orderings of the endogenous variables{p_end}
{phang2}{cmd:. irf create order1, set(myirfs, replace)}{p_end}
{phang2}{cmd:. irf create order2, order(dln_inc dln_inv dln_consump)}{p_end}
{phang2}{cmd:. irf create order3, order(dln_inc dln_consump dln_inv)}

{pstd}Display short summary of IRF results{p_end}
{phang2}{cmd:. irf describe}

{pstd}Display summary of model and IRF specification for {cmd:order1}{p_end}
{phang2}{cmd:. irf describe order1}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:irf describe} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations in the IRF file{p_end}
{synopt:{cmd:r(k)}}number of variables in the IRF file{p_end}
{synopt:{cmd:r(width)}}width of dataset in the IRF file{p_end}
{synopt:{cmd:r(changed)}}flag indicating that data have changed since last
saved{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(_version)}}version of IRF results file{p_end}
{synopt:{cmd:r(irfnames)}}names of IRF results in the IRF file{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_model)}}{cmd:var}, {cmd:sr var}, {cmd:lr var}, or
{cmd:vec}{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_order)}}Cholesky order assumed in IRF
estimates{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_exog)}}exogenous variables, and their lags,
   in VAR or underlying VAR{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_exogvars)}}exogenous variables in VAR or
   underlying VAR{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_constant)}}{cmd:constant} or
{cmd:noconstant}{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_lags)}}lags in model{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_exlags)}}lags of exogenous variables in model{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_tmin)}}minimum value of timevar in the estimation
sample{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_tmax)}}maximum value of timevar in the estimation
sample{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_timevar)}}name of {cmd:tsset} timevar{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_tsfmt)}}format of timevar in the estimation sample{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_varcns)}}{cmd:unconstrained} or colon-separated
list of constraints placed on VAR coefficients{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_svarcns)}}{cmd:"."} or colon-separated list of
constraints placed on SVAR coefficients{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_step)}}maximum step in IRF estimates{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_stderror)}}{cmd:asymptotic}, {cmd:bs}, {cmd:bsp},
or {cmd:none}, depending on type of standard errors specified to {cmd:irf create}{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_reps)}}{cmd:"."} or number of bootstrap replications
performed{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_version)}}version of IRF file that originally held
{it:irfname} IRF results{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_rank)}}{cmd:"."} or number of cointegrating
equations{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_trend)}}{cmd:"."} or {cmd:trend()} specified in
{cmd:vec}{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_veccns)}}{cmd:"."} or constraints placed on VECM
parameters{p_end}
{synopt:{cmd:r(}{it:irfname}{cmd:_sind)}}{cmd:"."} or normalized seasonal indicators
included in {cmd:vec}{p_end}
{p2colreset}{...}
