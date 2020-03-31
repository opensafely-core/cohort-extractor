{smcl}
{* *! version 1.2.3  19oct2017}{...}
{viewerdialog "irf set" "dialog irf_set"}{...}
{vieweralsosee "[TS] irf set" "mansection TS irfset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] irf" "help irf"}{...}
{vieweralsosee "[TS] irf describe" "help irf describe"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] vec intro" "help vec_intro"}{...}
{viewerjumpto "Syntax" "irf_set##syntax"}{...}
{viewerjumpto "Menu" "irf_set##menu"}{...}
{viewerjumpto "Description" "irf_set##description"}{...}
{viewerjumpto "Links to PDF documentation" "irf_set##linkspdf"}{...}
{viewerjumpto "Options" "irf_set##options"}{...}
{viewerjumpto "Examples" "irf_set##examples"}{...}
{viewerjumpto "Stored results" "irf_set##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[TS] irf set} {hline 2}}Set the active IRF file{p_end}
{p2col:}({mansection TS irfset:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}Report identity of active file

{p 8 24 2}
{cmd:irf} {opt set}


{pstd}Set, and if necessary create, active file

{p 8 24 2}
{cmd:irf} {opt set} {it:irf_filename} [{cmd:, replace}]


{pstd}Clear any active IRF file

{p 8 24 2}
{cmd:irf} {opt set}{cmd:,} {opt clear}


{phang}
If {it:irf_filename} is specified without an extension, {cmd:.irf} is assumed.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > Manage IRF results and files >}
    {bf:Set active IRF file}


{marker description}{...}
{title:Description}

{pstd}
{cmd:irf} {cmd:set} without arguments reports the identity of the
active IRF file, if there is one.
{cmd:irf} {cmd:set} with a filename specifies
that the file be created and set as the active file.
{cmd:irf} {cmd:set,} {cmd:clear} specifies
that, if any IRF file is set, it be unset and that there be no active
IRF file.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS irfsetQuickstart:Quick start}

        {mansection TS irfsetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt replace} specifies that if {it:irf_filename} already exists, the file is
to be erased and a new, empty IRF file is to be created in its place.  If it
does not already exist, a new, empty file is created.

{phang}
{opt clear} unsets the active IRF file.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}{p_end}

{pstd}Fit vector autoregressive model{p_end}
{phang2}{cmd:. var dln_inc dln_consump, exog(l.dln_inv)}

{pstd}Create {cmd:results2.irf} and make it the active IRF file{p_end}
{phang2}{cmd:. irf set results2}{p_end}

{pstd}Identify name of active file{p_end}
{phang2}{cmd:. irf set}

{pstd}Save estimated IRFs and FEVDs under {cmd:order1} in {cmd:results2.irf}
{p_end}
{phang2}{cmd:. irf create order1}{p_end}

{pstd}Erase existing {cmd:results2.irf} file and create a new, empty
{cmd:results2.irf} file{p_end}
{phang2}{cmd:. irf set results2, replace}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:irf set} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(irffile)}}name of active IRF file, if there is an active
IRF{p_end}
{p2colreset}{...}
