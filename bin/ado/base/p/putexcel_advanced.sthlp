{smcl}
{* *! version 1.1.3  30may2019}{...}
{viewerdialog "putexcel" "dialog putexcel"}{...}
{vieweralsosee "[RPT] putexcel advanced" "mansection RPT putexceladvanced"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] putexcel" "help putexcel"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{vieweralsosee "[P] postfile" "help postfile"}{...}
{vieweralsosee "[RPT] putdocx intro" "help putdocx intro"}{...}
{vieweralsosee "[RPT] putpdf intro" "help putpdf intro"}{...}
{vieweralsosee "[P] return" "help return"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] _docx*()" "help mf__docx"}{...}
{vieweralsosee "[M-5] xl()" "help mf_xl"}{...}
{viewerjumpto "Syntax" "putexcel advanced##syntax"}{...}
{viewerjumpto "Menu" "putexcel advanced##menu"}{...}
{viewerjumpto "Description" "putexcel advanced##description"}{...}
{viewerjumpto "Links to PDF documentation" "putexcel_advanced##linkspdf"}{...}
{viewerjumpto "Options" "putexcel advanced##options"}{...}
{viewerjumpto "Examples" "putexcel advanced##examples"}{...}
{viewerjumpto "Technical note" "putexcel advanced##technote1"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[RPT] putexcel advanced} {hline 2}}Export results to an Excel
file using advanced syntax{p_end}
{p2col:}({mansection RPT putexceladvanced:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Set workbook for export

{p 8 32 2}
{cmd:putexcel set}
{help filename:{it:filename}}
[{cmd:,} {help putexcel advanced##setopts:{it:set_options}}]


{phang}
Specify formatting and output

{p 8 32 2}
{cmd:putexcel} {help putexcel advanced##spec:{it:spec}}_1
[{it:spec_2} [...]]
[{cmd:,}
{help putexcel advanced##exptopts:{it:export_options}}
{help putexcel advanced##fmtopts:{it:format_options}}]


{phang}
Close and save current Excel file

{p 8 32 2}
{cmd:putexcel save}


{phang}
Describe current export settings

{p 8 32 2}
{cmd:putexcel describe}


{phang}
Clear current export settings

{p 8 32 2}
{cmd:putexcel clear}


{marker spec}{...}
{marker cellrange}{...}
{phang}
{it:spec} may be 
    {it:ul_cell} or {it:cellrange} of the form
    {it:ul_cell}{cmd::}{it:lr_cell}
if no output is to be written or may be one of the following 
{help putexcel advanced##output:output types}:

            {it:ul_cell} {cmd:=} {it:exp} 

            {it:ul_cell}{cmd::}{it:lr_cell} {cmd:=} {it:exp}

            {it:ul_cell} {cmd:=} {opt ma:trix(matname)}

            {it:ul_cell} {cmd:=} {opth image(filename)}

            {it:ul_cell} {cmd:=} {it:returnset}

            {it:ul_cell} {cmd:=} {opt formula(formula)}

            {it:ul_cell} {cmd:=} {cmd:etable}[{cmd:(}{it:#}1 {it:#}2 ... {it:#}{it:n}{cmd:)}]

{marker ulcell}{...}
{phang}
{it:ul_cell} is a valid Excel upper-left cell specified using standard
Excel notation, and {it:lr_cell} is a valid Excel lower-right cell.  
If you specify {it:ul_cell} as the output location multiple times, the
rightmost specification is the one written to the Excel file. 

{marker setopts}{...}
{synoptset 42}{...}
{synopthdr:set_options}
{synoptline}
INCLUDE help putexcel_setopts_list.ihlp
{synoptline}

{marker exptopts}{...}
{synoptset 42 tabbed}{...}
{synopthdr:export_options}
{synoptline}
{syntab:Main}
INCLUDE help putexcel_exptopts_list.ihlp
{synoptline}

{marker fmtopts}{...}
{synoptset 42 tabbed}{...}
{synopthdr:format_options}
{synoptline}
{syntab:Number}
{synopt :{opth nfor:mat(putexcel_advanced##nformat:excelnfmt)}}specify format for numbers{p_end}

{syntab:Alignment}
INCLUDE help putexcel_alignopts_list.ihlp

{syntab:Font}
{synopt :{cmd:font(}{help putexcel_advanced##font:{it:fontname}} [{cmd:,} {help putexcel_advanced##font:{it:size}} [{cmd:,} {help putexcel_advanced##font:{it:color}}]]{cmd:)}}specify font, font size, and font color{p_end}
INCLUDE help putexcel_textopts_list.ihlp

{syntab:Border}
INCLUDE help putexcel_bordopts_list.ihlp

{syntab:Fill}
INCLUDE help putexcel_fillopt_list.ihlp
{synoptline}
 

{marker output}{...}
    {bf:Output types}

INCLUDE help putexcela_output_types.ihlp


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Export > Results to Excel spreadsheet (*.xls;*.xlsx)}


{marker description}{...}
{title:Description}

{pstd}
{opt putexcel} with the advanced syntax may be used to simultaneously write
Stata {help expressions:expressions}, {help matrix:matrices}, images, and
{help return:stored results} to an Excel file. It may also be used to format
existing contents of cells in a worksheet. This syntax is intended for use by
programmers of commands that call {cmd:putexcel} in the background and by
other advanced users.  Excel 1997/2003 ({cmd:.xls}) files and Excel 2007/2010
and newer ({cmd:.xlsx}) files are supported.  A simplified version of the
syntax is documented in {manhelp putexcel RPT}.

{pstd}
{opt putexcel} {opt set} sets the Excel file to create, modify, or replace in
subsequent {opt putexcel} commands.  You must set the destination file before
using any other {opt putexcel} commands.  {cmd:putexcel save}
closes a file opened using the command {cmd:putexcel set} ...{cmd:, open} and
saves the file in memory to disk.  {opt putexcel clear} clears the file
information set by {opt putexcel set}.  {opt putexcel describe} displays the
file information set by {opt putexcel set}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT putexceladvancedQuickstart:Quick start}

        {mansection RPT putexceladvancedRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Set}

INCLUDE help putexcel_set_opts.ihlp

{dlgtab:Main}

INCLUDE help putexcela_expt_opts.ihlp

{dlgtab:Number}

INCLUDE help putexcel_num_opt.ihlp

{dlgtab:Alignment}

INCLUDE help putexcela_align_opts.ihlp

{dlgtab:Font}

INCLUDE help putexcela_text_opts.ihlp

{dlgtab:Border}

INCLUDE help putexcela_bord_opts.ihlp

{dlgtab:Fill}

INCLUDE help putexcela_fill_opt.ihlp


{marker examples}{...}
{title:Examples}

{pstd}
Declare first sheet of {cmd:results.xlsx} as the destination for subsequent
{cmd:putexcel} commands{p_end}
{phang2}{cmd:. putexcel set results}

{pstd}
Write the text "Variable", "Mean", and "Std. Dev." to cells A1, B1, and C1 and
add a thin border under the cells{p_end}
{phang2}{cmd:. putexcel A1 = "Variable" B1 = "Mean" C1 = "Std. Dev.", border(bottom)}

{pstd}
Summarize the {cmd:mpg} variable from {cmd:auto.dta}{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. summarize mpg}

{pstd}
Obtain the names of the returned results for the mean and the
standard deviation, {cmd:r(mean)} and {cmd:r(sd)}{p_end}
{phang2}{cmd:. return list}

{pstd}
Write the variable name, mean, and standard deviation in cells A2, B2, and C2.
Specify a format with two decimal places for the mean and standard deviation
{p_end}
{phang2}{cmd:. putexcel A2 = "mpg" B2 = `r(mean)' C2 = `r(sd)', nformat(number_d2)}


{marker technote1}{...}
{title:Technical note:  Excel data size limits and dates and times}

{pstd}
You can read about Excel data size limits and the two different Excel date
systems in {helpb import_excel##technote1:help import excel}.
{p_end}
