{smcl}
{* *! version 1.2.13  19oct2017}{...}
{viewerdialog "Data Editor (Edit)" "stata edit"}{...}
{viewerdialog "Data Editor (Browse)" "stata browse"}{...}
{vieweralsosee "[D] edit" "mansection D edit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[GSM] 6 Using the Data Editor" "mansection GSM 6UsingtheDataEditor"}{...}
{vieweralsosee "[GSU] 6 Using the Data Editor" "mansection GSU 6UsingtheDataEditor"}{...}
{vieweralsosee "[GSW] 6 Using the Data Editor" "mansection GSW 6UsingtheDataEditor"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{vieweralsosee "[D] input" "help input"}{...}
{vieweralsosee "[D] list" "help list"}{...}
{vieweralsosee "[D] save" "help save"}{...}
{viewerjumpto "Syntax" "edit##syntax"}{...}
{viewerjumpto "Menu" "edit##menu"}{...}
{viewerjumpto "Description" "edit##description"}{...}
{viewerjumpto "Links to PDF documentation" "edit##linkspdf"}{...}
{viewerjumpto "Option" "edit##option"}{...}
{viewerjumpto "Remarks" "edit##remarks"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[D] edit} {hline 2}}Browse or edit data with Data Editor{p_end}
{p2col:}({mansection D edit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}Edit using Data Editor

{p 8 14 2}
{opt ed:it} [{varlist}] {ifin} [{cmd:,} {opt nol:abel}]


{phang}Browse using Data Editor

{p 8 16 2}
{opt br:owse} [{varlist}] {ifin} [{cmd:,} {opt nol:abel}]


{marker menu}{...}
{title:Menu}

    {title:edit} 

{phang2}
{bf:Data > Data Editor > Data Editor (Edit)}

    {title:browse}

{phang2}
{bf:Data > Data Editor > Data Editor (Browse)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:edit} brings up a spreadsheet-style data editor for entering new data
and editing existing data.  {cmd:edit} is a better alternative to {cmd:input};
see {manhelp input D}.

{pstd}
{cmd:browse} is similar to {cmd:edit}, except that modifications to the 
data by editing in the grid are not permitted.
{cmd:browse} is a convenient alternative to {cmd:list}; see 
{manhelp list D}.

{pstd}
See [GS] 6 Using the Data Editor
   ({mansection GSM 6UsingtheDataEditor:GSM},
    {mansection GSU 6UsingtheDataEditor:GSU}, or
    {mansection GSW 6UsingtheDataEditor:GSW})
for a tutorial discussion of the Data Editor.  This entry provides
the technical details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D editQuickstart:Quick start}

        {mansection D editRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:nolabel} causes the underlying numeric values, rather than the label
values (equivalent strings), to be displayed for variables with value labels;
see {manhelp label D}.


{marker remarks}{...}
{title:Remarks}

{pstd}
A tutorial discussion of {cmd:edit} and {cmd:browse} is found in the 
{bf:Getting Started with Stata} manual.  Technical details can be found in
{manlink D edit}.

{pstd}
{cmd:edit}, typed by itself, opens the Data Editor with all observations on
all variables displayed.  If you specify a {it:varlist}, only the specified
variables are displayed in the Editor.  If you specify one or both of
{cmd:in} {it:range} and {cmd:if} {it:exp}, only the observations specified are
displayed.
{p_end}
