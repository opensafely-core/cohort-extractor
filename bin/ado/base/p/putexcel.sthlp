{smcl}
{* *! version 3.1.2  30may2019}{...}
{viewerdialog "putexcel" "dialog putexcel"}{...}
{vieweralsosee "[RPT] putexcel" "mansection RPT putexcel"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] putexcel advanced" "help putexcel advanced"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] import excel" "help import excel"}{...}
{vieweralsosee "[RPT] putdocx intro" "help putdocx intro"}{...}
{vieweralsosee "[RPT] putpdf intro" "help putpdf intro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] _docx*()" "help mf__docx"}{...}
{vieweralsosee "[M-5] Pdf*()" "help mf pdf"}{...}
{vieweralsosee "[M-5] xl()" "help mf_xl"}{...}
{viewerjumpto "Syntax" "putexcel##syntax"}{...}
{viewerjumpto "Menu" "putexcel##menu"}{...}
{viewerjumpto "Description" "putexcel##description"}{...}
{viewerjumpto "Links to PDF documentation" "putexcel##linkspdf"}{...}
{viewerjumpto "Options" "putexcel##options"}{...}
{viewerjumpto "Examples" "putexcel##examples"}{...}
{viewerjumpto "Technical note" "putexcel##technote1"}{...}
{viewerjumpto "Appendix" "putexcel##appendix"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[RPT] putexcel} {hline 2}}Export results to an Excel file{p_end}
{p2col:}({mansection RPT putexcel:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Set workbook for export

{p 8 32 2}
{cmd:putexcel} {cmd:set} {it:{help filename}}
[{cmd:,} {help putexcel##setopts:{it:set_options}}]


{phang}
Write expression to Excel

{p 8 32 2}
{cmd:putexcel} {help putexcel##ulcell:{it:ul_cell}}
    {cmd:=} {help putexcel##expr:{it:exp}}
[{cmd:,} {help putexcel##expopts:{it:expression_options}}
{help putexcel##fmtopts:{it:format_options}}]


{phang}
Export Stata matrix to Excel

{p 8 32 2}
{cmd:putexcel} {help putexcel##ulcell:{it:ul_cell}}
    {cmd:=} {help putexcel##matrix:{bf:{ul:ma}trix(}{it:matname}{bf:)}}
[{cmd:,} {help putexcel##matopts:{it:matrix_options}}
{help putexcel##fmtopts:{it:format_options}}]


{phang}
Export Stata graph, path diagram, or other image to Excel

{p 8 32 2}
{cmd:putexcel} {help putexcel##ulcell:{it:ul_cell}}
    {cmd:=} {help putexcel##picture:{bf:image(}{it:filename}{bf:)}}


{phang}
Export returned results to Excel

{p 8 32 2}
{cmd:putexcel} {help putexcel##ulcell:{it:ul_cell}}
    {cmd:=} {help putexcel##returnset:{it:returnset}}
[{cmd:,} {opt colw:ise} {opt overwr:itefmt}]


{phang}
Write formula to Excel

{p 8 32 2}
{cmd:putexcel} {help putexcel##ulcell:{it:ul_cell}}
    {cmd:=} {help putexcel##formula:{bf:formula(}{it:formula}{bf:)}}
[{cmd:,} {opt overwr:itefmt}]


{phang}
Format cells

{p 8 32 2}
{cmd:putexcel} {help putexcel##cellrange:{it:cellrange}}{cmd:,}
{opt overwr:itefmt}
{help putexcel##fmtopts:{it:format_options}}


{phang}
Add the coefficient table from the last estimation command to Excel file

{p 8 32 2}
{cmd:putexcel} {help putexcel##ulcell:{it:ul_cell}}
{cmd:=} {help putexcel##etable:{bf:etable}}[{cmd:(}{it:#}1 {it:#}2 ... {it:#}{it:n}{cmd:)}]


{phang}
Close and save Excel file

{p 8 32 2}
{cmd:putexcel save}


{phang}
Describe current export settings

{p 8 32 2}
{cmd:putexcel} {cmd:describe}


{phang}
Clear current export settings

{p 8 32 2}
{cmd:putexcel} {cmd:clear}


{marker ulcell}{...}
{phang}
{it:ul_cell} is a valid Excel upper-left cell specified using standard
Excel notation, for example, {cmd:A1} or {cmd:D4}.  

{marker cellrange}{...}
{phang}
{it:cellrange} is {it:ul_cell} or {it:ul_cell}{cmd::}{it:lr_cell},
where {it:lr_cell} is a valid Excel lower-right cell, for example, {cmd:A1},
{cmd:A1:D1}, {cmd:A1:A4}, or {cmd:A1:D4}.  


{marker setopts}{...}
{synoptset 42}{...}
{synopthdr:set_options}
{synoptline}
INCLUDE help putexcel_setopts_list.ihlp
{synoptline}

{marker expopts}{...}
{synoptset 42 tabbed}{...}
{synopthdr:expression_options}
{synoptline}
{syntab:Main}
{synopt :{opt overwr:itefmt}}overwrite existing cell formatting when
exporting new content{p_end}
{synopt :{opt asdate}}convert Stata date ({cmd:%td}-formatted) {it:exp} to an
Excel date{p_end}
{synopt :{opt asdatetime}}convert Stata datetime ({cmd:%tc}-formatted)
{it:exp} to an Excel datetime{p_end}
{synopt :{opt asdatenum}}convert Stata date
{it:exp} to an Excel date number, preserving the cell's format{p_end}
{synopt :{opt asdatetimenum}}convert Stata datetime
{it:exp} to an Excel datetime number, preserving the cell's format{p_end}
{synoptline}

{marker matopts}{...}
{synoptset 42 tabbed}{...}
{synopthdr:matrix_options}
{synoptline}
{syntab:Main}
{synopt :{opt overwr:itefmt}}overwrite existing cell formatting when
exporting new content{p_end}
{synopt :{opt names}}also write row names and column names for matrix {it:matname}; may 
not be combined with {cmd:rownames} or {cmd:colnames}{p_end}
{synopt :{opt rownames}}also write matrix row names for matrix {it:matname}; 
may not be combined with {cmd:names} or {cmd:colnames}{p_end}
{synopt :{opt colnames}}also write matrix column names for matrix {it:matname}; 
may not be combined with {cmd:names} or {cmd:rownames}{p_end}
{synoptline}

{marker fmtopts}{...}
{synoptset 42 tabbed}{...}
{synopthdr:format_options}
{synoptline}
{syntab:Number}
{synopt :{opth nfor:mat(putexcel##nformat:excelnfmt)}}specify format for numbers{p_end}

{syntab:Alignment}
INCLUDE help putexcel_alignopts_list.ihlp

{syntab:Font}
{synopt :{cmd:font(}{help putexcel##font:{it:fontname}} [{cmd:,} {help putexcel##font:{it:size}} [{cmd:,} {help putexcel##font:{it:color}}]]{cmd:)}}specify font, font size, and font color{p_end}
INCLUDE help putexcel_textopts_list.ihlp


{syntab:Border}
INCLUDE help putexcel_bordopts_list.ihlp

{syntab:Fill}
INCLUDE help putexcel_fillopt_list.ihlp
{synoptline}


    {bf:Output types}

INCLUDE help putexcel_output_types.ihlp


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Export > Results to Excel spreadsheet (*.xls;*.xlsx)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:putexcel} writes Stata {help expressions:expressions},
{help matrix:matrices}, images, and {help return:returned results} to an Excel
file.  It may also be used to format cells in an Excel worksheet.  This allows
you to automate exporting and formatting of, for example, Stata estimation
results.  Excel 1997/2003 ({cmd:.xls}) files and Excel 2007/2010 and newer
({cmd:.xlsx}) files are supported.  

{pstd}
{cmd:putexcel} {cmd:set} sets the Excel file to create, modify, or replace in
subsequent {cmd:putexcel} commands.  You must set the destination file before
using any other {cmd:putexcel} commands.  {cmd:putexcel save} closes a file
opened using the command {cmd:putexcel set} ...{cmd:, open} and saves the file
in memory to disk.  {cmd:putexcel clear} clears the file information set by
{cmd:putexcel set}.  {cmd:putexcel describe} displays the file information set
by {cmd:putexcel set}.

{pstd}
For an advanced syntax to simultaneously write multiple output
types, see {manhelp putexcel_advanced RPT:putexcel advanced}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT putexcelQuickstart:Quick start}

        {mansection RPT putexcelRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Set}

INCLUDE help putexcel_set_opts.ihlp

{dlgtab:Main}

INCLUDE help putexcel_expt_opts.ihlp

{dlgtab:Number}

INCLUDE help putexcel_num_opt.ihlp

{dlgtab:Alignment}

INCLUDE help putexcel_align_opts.ihlp

{dlgtab:Font}

INCLUDE help putexcel_text_opts.ihlp

{dlgtab:Border}

INCLUDE help putexcel_bord_opts.ihlp

{dlgtab:Fill}

INCLUDE help putexcel_fill_opt.ihlp


{marker examples}{...}
{title:Examples}

{pstd}
Declare first sheet of results.xlsx as the destination for subsequent
{cmd:putexcel} commands{p_end}
{phang2}{cmd:. putexcel set results}

{pstd}
Write the text "Variable", "Mean", and "Std. Dev." to cells A1, B1, and
C1{p_end}
{phang2}{cmd:. putexcel A1 = "Variable"}{p_end}
{phang2}{cmd:. putexcel B1 = "Mean"}{p_end}
{phang2}{cmd:. putexcel C1 = "Std. Dev."}

{pstd}
Summarize the {cmd:mpg} variable{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. summarize mpg}

{pstd}
Obtain the names of the returned results for the mean and the
standard deviation, {cmd:r(mean)} and {cmd:r(sd)}{p_end}
{phang2}{cmd:. return list}

{pstd}
Write the variable name, mean, and standard deviation in cells A2, B2, and C2;
specify a format with two decimal places for the mean and standard
deviation{p_end}
{phang2}{cmd:. putexcel A2 = "mpg"}{p_end}
{phang2}{cmd: 	. putexcel B2 = `r(mean)', nformat(number_d2)}{p_end}
{phang2}{cmd:	. putexcel C2 = `r(sd)', nformat(number_d2)}{p_end}

{pstd}
Fit a regression of {cmd:mpg} on weight and displacement{p_end}
{phang2}{cmd:. regress mpg weight displacement}

{pstd}
Write the text "Coef."  to cell B5{p_end}
{phang2}{cmd:. putexcel B5 = "Coef."}

{pstd}
Write the matrix of coefficients and their labels contained in the matrix row
names from the transposed {cmd:e(b)} matrix; specify that this matrix is
written with the upper left entry in cell A6{p_end}
{phang2}{cmd:. matrix b = e(b)'}{p_end}
{phang2}{cmd:. putexcel A6 = matrix(b), rownames}


{marker technote1}{...}
{title:Technical note:  Excel data size limits and dates and times}

{pstd}
You can read about Excel data size limits and the two different Excel date
systems in {helpb import_excel##technote1:help import excel}.
{p_end}


{marker appendix}{...}
{title:Appendix}

{marker formats}{...}
{marker nformat}{...}
    {title:Codes for numeric formats}

	 Code                           Example
	{hline 40}
	 {cmd:number}                            1000
	 {cmd:number_d2}                      1000.00
	 {cmd:number_sep}                     100,000
	 {cmd:number_sep_d2}               100,000.00
	 {cmd:number_sep_negbra}              (1,000)
	 {cmd:number_sep_negbrared}           {error}(1,000){txt}
	 {cmd:number_d2_sep_negbra}        (1,000.00)
	 {cmd:number_d2_sep_negbrared}     {error}(1,000.00){txt}
	 {cmd:currency_negbra}                ($4000)
	 {cmd:currency_negbrared}             {error}($4000){txt}
	 {cmd:currency_d2_negbra}          ($4000.00)
	 {cmd:currency_d2_negbrared}       {error}($4000.00){txt}
	 {cmd:account}                          5,000
	 {cmd:accountcur}      	           $    5,000
	 {cmd:account_d2}                    5,000.00
	 {cmd:account_d2_cur}              $ 5,000.00
	 {cmd:percent}                            75%
	 {cmd:percent_d2}                      75.00%
	 {cmd:scientific_d2}                 10.00E+1
	 {cmd:fraction_onedig}                 10 1/2
	 {cmd:fraction_twodig}               10 23/95
	 {cmd:date}                         3/18/2007
	 {cmd:date_d_mon_yy}                18-Mar-07
	 {cmd:date_d_mon}                      18-Mar
	 {cmd:date_mon_yy}                     Mar-07
	 {cmd:time_hmm_AM}                    8:30 AM
	 {cmd:time_HMMSS_AM}               8:30:00 AM
	 {cmd:time_HMM}                          8:30
	 {cmd:time_HMMSS}                     8:30:00
	 {cmd:time_MMSS}                        30:55
	 {cmd:time_H0MMSS}                   20:30:55
	 {cmd:time_MMSS0}                     30:55.0
	 {cmd:date_time}               3/18/2007 8:30
	 {cmd:text}                      this is text
	{hline 40}


{marker Colors}{...}
    {title:Colors}

         {it:color}
        {hline 52}
	 {cmd}aliceblue       ghostwhite            navajowhite
	 antiquewhite    gold                  navy
	 aqua            goldenrod             oldlace
	 aquamarine      gray                  olive
	 azure           green                 olivedrab
	 beige           greenyellow           orange
	 bisque          honeydew              orangered
	 black           hotpink               orchid
	 blanchedalmond  indianred             palegoldenrod
	 blue            indigo                palegreen
	 blueviolet      ivory                 paleturquoise
	 brown           khaki                 palevioletred
	 burlywood       lavender              papayawhip
	 cadetblue       lavenderblush         peachpuff
	 chartreuse      lawngreen             peru
	 chocolate       lemonchiffon          pink
	 coral           lightblue             plum
	 cornflowerblue  lightcoral            powderblue
	 cornsilk        lightcyan             purple
	 crimson         lightgoldenrodyellow  red
	 cyan            lightgray             rosybrown
	 darkblue        lightgreen            royalblue
	 darkcyan        lightpink             saddlebrown
	 darkgoldenrod   lightsalmon           salmon
	 darkgray        lightseagreen         sandybrown
	 darkgreen       lightskyblue          seagreen
	 darkkhaki       lightslategray        seashell
	 darkmagenta     lightsteelblue        sienna
	 darkolivegreen  lightyellow           silver
	 darkorange      lime                  skyblue
	 darkorchid      limegreen             slateblue
	 darkred         linen                 slategray
	 darksalmon      magenta               snow
	 darkseagreen    maroon                springgreen
	 darkslateblue   mediumaquamarine      steelblue
	 darkslategray   mediumblue            tan
	 darkturquoise   mediumorchid          teal
	 darkviolet      mediumpurple          thistle
	 deeppink        mediumseagreen        tomato
	 deepskyblue     mediumslateblue       turquoise
	 dimgray         mediumspringgreen     violet
	 dodgerblue      mediumturquoise       wheat
	 firebrick       mediumvioletred       white
	 floralwhite     midnightblue          whitesmoke
	 forestgreen     mintcream             yellow
	 fuchsia         mistyrose             yellowgreen
	 gainsboro       moccasin{txt}
        {hline 52}


{marker style}{...}
    {title:Border styles}

         {it:style}
	{hline 25}
	 {cmd:none}
	 {cmd:thin}
	 {cmd:medium}
	 {cmd:dashed}
	 {cmd:dotted}
	 {cmd:thick}
	 {cmd:double}
	 {cmd:hair}
	 {cmd:medium_dashed}
	 {cmd:dash_dot}
	 {cmd:medium_dash_dot}
	 {cmd:dash_dot_dot}
	 {cmd:medium_dash_dot_dot}
	 {cmd:slant_dash_dot}
	{hline 25}


{marker pattern}{...}
    {title:Background patterns}

         {it:pattern} 
	{hline 25}
	 {cmd:none}
	 {cmd:solid}
	 {cmd:gray50}
	 {cmd:gray75}
	 {cmd:gray25}
	 {cmd:horstripe}
	 {cmd:verstripe}
	 {cmd:diagstripe}
	 {cmd:revdiagstripe}
	 {cmd:diagcrosshatch}
	 {cmd:thinhorstripe}
	 {cmd:thinverstripe}
	 {cmd:thindiagstripe}
	 {cmd:thinrevdiagstripe}
	 {cmd:thinhorcrosshatch}
	 {cmd:thindiagcrosshatch}
	 {cmd:thickdiagcrosshatch}
	 {cmd:gray12p5}
	 {cmd:gray6p25}
        {hline 25}
