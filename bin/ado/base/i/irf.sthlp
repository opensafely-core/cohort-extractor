{smcl}
{* *! version 1.1.11  25feb2019}{...}
{vieweralsosee "[TS] irf" "mansection TS irf"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arfima" "help arfima"}{...}
{vieweralsosee "[TS] arima" "help arima"}{...}
{vieweralsosee "[TS] var" "help var"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] var svar" "help svar"}{...}
{vieweralsosee "[TS] varbasic" "help varbasic"}{...}
{vieweralsosee "[TS] vec" "help vec"}{...}
{vieweralsosee "[TS] vec intro" "help vec_intro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[DSGE] dsge" "help dsge"}{...}
{vieweralsosee "[DSGE] dsgenl" "help dsgenl"}{...}
{viewerjumpto "Syntax" "irf##syntax"}{...}
{viewerjumpto "Description" "irf##description"}{...}
{viewerjumpto "Links to PDF documentation" "irf##linkspdf"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[TS] irf} {hline 2}}Create and analyze IRFs, dynamic-multiplier
functions, and FEVDs{p_end}
{p2col:}({mansection TS irf:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:irf} {it:subcommand ...} [{cmd:,} {it:...}]

{synoptset 12}{...}
{synopthdr:subcommand}
{synoptline}
{synopt:{helpb irf_create:create}}create IRF file containing IRFs,
	dynamic-multiplier functions, and FEVDs{p_end}
{synopt:{helpb irf_set:set}}set the active IRF file{p_end}

{synopt:{helpb irf_graph:graph}}graph results from active file{p_end}
{synopt:{helpb irf_cgraph:cgraph}}combine graphs of IRFs,
	dynamic-multiplier functions, and FEVDs{p_end}
{synopt:{helpb irf_ograph:ograph}}graph overlaid IRFs,
	dynamic-multiplier functions, and FEVDs{p_end}
{synopt:{helpb irf_table:table}}create tables of IRFs, dynamic-multiplier
	functions, and FEVDs from active file{p_end}
{synopt:{helpb irf_ctable:ctable}}combine tables of IRFs,
	dynamic-multiplier functions, and FEVDs{p_end}

{synopt:{helpb irf_describe:describe}}describe contents of active file{p_end}
{synopt:{helpb irf_add:add}}add results from an IRF file to the active IRF file{p_end}
{synopt:{helpb irf_drop:drop}}drop IRF results from active file{p_end}
{synopt:{helpb irf_rename:rename}}rename IRF results within a file{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
IRF stands for impulse-response function; FEVD stands for forecast-error 
variance decomposition.
{p_end}
{p 4 6 2}
{opt irf} can be used only after
{opt var}, {opt svar}, {opt vec}, {opt arima}, {opt arfima}, {opt dsge}, or
{opt dsgenl}; see
{helpb var:[TS] var}, {helpb svar:[TS] var svar}, {helpb vec:[TS] vec},
{helpb arima:[TS] arima}, {helpb arfima:[TS] arfima},
{helpb dsge:[DSGE] dsge}, or {helpb dsgenl:[DSGE] dsgenl}.


{marker description}{...}
{title:Description}

{pstd}
{opt irf} creates and manipulates IRF files that contain estimates of the
impulse-response functions (IRFs), dynamic-multiplier functions, and
forecast-error variance decompositions (FEVDs) created after estimation by
{helpb var}, {helpb svar}, or {helpb vec}.

{pstd}
{opt irf} creates and manipulates IRF files that contain estimates of the
IRFs created after estimation by {helpb arima}, {helpb arfima},
{helpb dsge}, or {helpb dsgenl}.

{pstd}
See {manlink TS irf} and {manlink TS irf create} (PDF documentation) for more
about interpreting and analyzing IRFs and FEVDs.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS irfQuickstart:Quick start}

        {mansection TS irfRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


