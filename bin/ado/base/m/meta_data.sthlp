{smcl}
{* *! version 1.0.0  17jun2019}{...}
{vieweralsosee "[META] meta data" "mansection META metadata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta esize" "help meta esize"}{...}
{vieweralsosee "[META] meta set" "help meta set"}{...}
{vieweralsosee "[META] meta update" "help meta update"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta" "help meta"}{...}
{vieweralsosee "[META] Glossary" "help meta glossary"}{...}
{vieweralsosee "[META] Intro" "mansection META Intro"}{...}
{viewerjumpto "Description" "meta_data##description"}{...}
{viewerjumpto "Links to PDF documentation" "meta_data##linkspdf"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[META] meta data} {hline 2}}Declare meta-analysis data{p_end}
{p2col:}({mansection META metadata:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This entry describes how to prepare your data for meta-analysis using the
{cmd:meta} commands.

{pstd}
In a nutshell, do the following:

{phang}
1. If you have access to {help meta_glossary##summary_data:summary data}, use
{helpb meta esize} to compute and declare effect sizes such as an odds ratio
or a Hedges's g.

{phang}
2. Alternatively, if you have only precomputed (generic) effect sizes, use
{helpb meta set}.

{phang}
3. To update some of your meta-analysis settings after the declaration, use
{helpb meta update}.

{phang}
4. To check whether your data are already meta set or to see the current meta
settings, use {helpb meta query}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection META metaesizeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.
{p_end}
