{smcl}
{* *! version 1.0.1  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem"}{...}
{vieweralsosee "[SEM] sem path examples" "help sempath_examples"}{...}
{viewerjumpto "Syntax" "webgetsem##syntax"}{...}
{viewerjumpto "Description" "webgetsem##description"}{...}
{viewerjumpto "Examples" "webgetsem##examples"}{...}
{title:Title}

{p2colset 5 24 26 2}{...}
{p2col :{hi:[SEM] webgetsem} {hline 2}}Open SEM example path diagram{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:webgetsem} {it:diagram_name} [{it:dataset_name}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:webgetsem} opens the specified example {it:path_diagram} from
{help sem examples:{bf:sem} examples} in a new window of the
{help sem_gui:SEM Builder}.  It optionally opens an associated dataset for the
example if {it:dataset_name} is specified.

{pstd}
Example path diagrams can also be opened from the 
{help sempath_examples:SEM path examples help page}.


{marker examples}{...}
{title:Examples}

    {cmd:. webgetsem sem_sm2}
    {cmd:. webgetsem sem_mimic1 sem_mimic1}

