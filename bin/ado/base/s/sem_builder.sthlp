{smcl}
{* *! version 1.0.4  15may2018}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] Builder" "mansection SEM Builder"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem introduction" "help sem_intro"}{...}
{vieweralsosee "[SEM] sem examples" "help sem_examples"}{...}
{viewerjumpto "Menu" "sem_builder##menu"}{...}
{viewerjumpto "Description" "sem_builder##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_builder##linkspdf"}{...}
{viewerjumpto "Remarks" "sem_builder##remarks"}{...}
{viewerjumpto "Video example" "sem_builder##video"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[SEM] Builder} {hline 2}}SEM Builder{p_end}
{p2col:}({mansection SEM Builder:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Model building and estimation}


{marker description}{...}
{title:Description}

{pstd}
The SEM Builder lets you create path diagrams for SEMs, fit those models, and
show results on the path diagram.  Here we discuss standard linear 
SEMs; see {helpb gsem_builder:[SEM] Builder, generalized} for information on
using the Builder to create models with generalized responses and multilevel
structure.

{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM BuilderRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {manlink SEM Builder}.

{pstd}
{cmd:sem} also provides a command language interface.  This interface is
similar to path diagrams and is typable.  See
{helpb sem_and gsem path_notation:[SEM] sem and gsem path notation}.
{p_end}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=Xj0gBlqwYHI":SEM Builder in Stata}
{p_end}
