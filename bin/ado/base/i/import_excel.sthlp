{smcl}
{* *! version 1.2.3  20apr2019}{...}
{viewerdialog "import excel" "dialog import_excel_dlg"}{...}
{viewerdialog "export excel" "dialog export_excel"}{...}
{vieweralsosee "[D] import excel" "mansection D importexcel"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] Datetime" "help datetime"}{...}
{vieweralsosee "[M-5] _docx*()" "help mf_docx"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{vieweralsosee "[RPT] putexcel" "help putexcel"}{...}
{vieweralsosee "[M-5] xl()" "help mf_xl"}{...}
{viewerjumpto "Syntax" "import_excel##syntax"}{...}
{viewerjumpto "Menu" "import_excel##menu"}{...}
{viewerjumpto "Description" "import_excel##description"}{...}
{viewerjumpto "Links to PDF documentation" "import_excel##linkspdf"}{...}
{viewerjumpto "Options for import excel" "import_excel##importoptions"}{...}
{viewerjumpto "Options for export excel" "import_excel##exportoptions"}{...}
{viewerjumpto "Remarks/Examples" "import_excel##remarks"}{...}
{viewerjumpto "Video example" "import_excel##video"}{...}
{viewerjumpto "Technical notes" "import_excel##technote1"}{...}
{viewerjumpto "Stored results" "import_excel##results"}{...}
{p2colset 1 21 18 2}{...}
{p2col:{bf:[D] import excel} {hline 2}}Import and export Excel files{p_end}
{p2col:}({mansection D importexcel:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Load an Excel file

{p 8 32 2}
{cmd:import} {cmdab:exc:el} [{cmd:using}] {it:{help filename}}
   [{cmd:,} {it:{help import_excel##import_excel_options:import_excel_options}}]


{phang}
Load subset of variables from an Excel file

{p 8 32 2}
{cmd:import} {cmdab:exc:el} {it:{help import_excel##extvarlist:extvarlist}}
    {cmd:using} {it:{help filename}}
  [{cmd:,} {it:{help import_excel##import_excel_options:import_excel_options}}]


{phang}
Describe contents of an Excel file

{p 8 32 2}
{cmd:import} {cmdab:exc:el} [{cmd:using}] {it:{help filename}},
     {cmdab:desc:ribe}


{phang}
Save data in memory to an Excel file

{p 8 32 2}
{cmd:export} {cmdab:exc:el} [{cmd:using}] {it:{help filename}} {ifin}
   [{cmd:,} {it:{help import_excel##export_excel_options:export_excel_options}}]


{phang}
Save subset of variables in memory to an Excel file

{p 8 32 2}
{cmd:export} {cmdab:exc:el} [{varlist}] {cmd:using} {it:{help filename}} {ifin}
    [{cmd:,}
      {it:{help import_excel##export_excel_options:export_excel_options}}]


{synoptset 37}{...}
{marker import_excel_options}{...}
{synopthdr :import_excel_options}
{synoptline}
{synopt :{opt sh:eet("sheetname")}}Excel worksheet to load{p_end}
{synopt :{opt cellra:nge([start][:end])}}Excel cell range to load{p_end}
{synopt :{opt first:row}}treat first row of Excel data as variable names{p_end}
{synopt :{cmd:case(}{cmdab:pre:serve}|{cmdab:l:ower}|{cmdab:u:pper}{cmd:)}}preserve the case (the
	default) or read variable names as lowercase or uppercase when using
	{opt firstrow}{p_end}
{synopt :{opt all:string}[{cmd:("}{it:{help format:format}}{cmd:")}]}import all Excel data as strings; optionally, specify the numeric display format{p_end}
{synopt :{opt clear}}replace data in memory{p_end}

{synopt :{opt locale("locale")}}specify the locale used by the workbook; has
no effect on Microsoft Windows{p_end}
{synoptline}
{p 4 6 2}{cmd:allstring("}{it:format}{cmd:")} and {opt locale()} do not
appear in the dialog box.{p_end}
{p2colreset}{...}


{synoptset 37 tabbed}{...}
{marker export_excel_options}{...}
{synopthdr :export_excel_options}
{synoptline}
{syntab :Main}
{synopt :{cmdab:sh:eet("}{it:sheetname}{cmd:"}[{cmd:, modify}|{cmd:replace}]{cmd:)}}save to Excel worksheet{p_end}
{synopt :{opt cell(start)}}start (upper-left) cell in Excel to begin saving to{p_end}
{synopt :{cmdab:first:row(}{cmdab:var:iables}|{cmdab:varl:abels}{cmd:)}}save variable names or variable labels to first row{p_end}
{synopt :{cmdab:nol:abel}}export values instead of value labels{p_end}
{synopt :{cmd:keepcellfmt}}when writing data, preserve the cell style and format of existing worksheet{p_end}
{synopt :{opt replace}}overwrite Excel file{p_end}

{syntab :Advanced}
{synopt :{cmdab:date:string("}{it:{help datetime_display_formats:datetime_format}}{cmd:")}}save dates as strings with a {it:datetime_format}{p_end}
{synopt :{cmdab:miss:ing("}{it:repval}{cmd:")}}save missing values as {it:repval}{p_end}

{synopt :{opt locale("locale")}}specify the locale used by the workbook; has
no effect on Microsoft Windows{p_end}
{synoptline}
{p 4 6 2}{opt locale()} does not appear in the dialog box.{p_end}
{p2colreset}{...}


{marker extvarlist}{...}
{p 4 4 2}
{it:extvarlist} specifies variable names of imported columns.  
An {it:extvarlist} is one or more of any of the following:

            {it:varname}
            {it:varname}{cmd:=}{it:columnname}

{marker extvarlist_examples}{...}
{p 8 8 2}
Example:  {cmd:import excel make mpg weight price using auto.xlsx, clear}
{p_end}
{p 12 12 2}
	imports columns A, B, C, and D from the Excel file {cmd:auto.xlsx}.

{p 8 8 2}
Example:  {cmd:import excel make=A mpg=B price=D using auto.xlsx, clear}
{p_end}
{p 12 12 2}
	imports columns A, B, and D from the Excel file {cmd:auto.xlsx}. 
	Column C and any columns after D are skipped.


{marker menu}{...}
{title:Menu}

    {title:import excel}

{phang2}
{bf:File > Import > Excel spreadsheet (*.xls;*.xlsx)}

    {title:export excel}

{phang2}
{bf:File > Export > Data to Excel spreadsheet (*.xls;*.xlsx)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:import excel} loads an Excel file, also known as a workbook, into Stata. 
{cmd:import excel} {it:filename}{cmd:, describe} lists available sheets and
ranges of an Excel file.  {cmd:export excel} saves data in memory to an Excel
file.  Excel 1997/2003 ({cmd:.xls}) files and Excel 2007/2010 ({cmd:.xlsx})
files can be imported, exported, and described using {cmd:import excel},
{cmd:export excel}, and {cmd:import excel, describe}. 

{pstd}
{cmd:import excel} and {cmd:export excel} are supported on Windows, Mac, and
Linux.

{pstd}
{cmd:import excel} and {cmd:export excel} look at the file extension,
{cmd:.xls} or {cmd:.xlsx}, to determine which Excel format to read or write.

{pstd}
For performance, {cmd:import excel} imposes a size limit of 
40 MB for Excel 2007/2010 ({cmd:.xlsx}) files.  Be warned that 
importing large {cmd:.xlsx} files can severely affect your machine's 
performance. 

{pstd}
{cmd:import excel auto} first looks for {cmd:auto.xls} and then looks for
{cmd:auto.xlsx} if {cmd:auto.xls} is not found in the current directory. 

{pstd}
The default file extension for {cmd:export excel} is {cmd:.xls} if
a file extension is not specified. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D importexcelQuickstart:Quick start}

        {mansection D importexcelRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker importoptions}{...}
{title:Options for import excel}

{phang}
{cmd:sheet("}{it:sheetname}{cmd:")} imports the worksheet named
{it:sheetname} in the workbook.  The default is to import the first
worksheet.

{phang}
{opt "cellrange([start][:end])"} specifies a range of cells within 
the worksheet to load.  {it:start} and {it:end} are specified using
standard Excel cell notation, for example, {cmd:A1}, {cmd:BC2000}, and
{cmd:C23}.

{phang}
{cmd:firstrow} specifies that the first row of data in the Excel worksheet
consists of variable names.  This option cannot be used with {it:extvarlist}.
{cmd:firstrow} uses the first row of the cell range for variable
names if {cmd:cellrange()} is specified.  {cmd:import excel} translates the
names in the first row to valid Stata variable names.  The original names in
the first row are stored unmodified as variable labels.

{phang}
{cmd:case(}{cmd:preserve}|{cmd:lower}|{cmd:upper)}  specifies the case of the
variable names read when using the {opt firstrow} option.  The default
is {cmd:case(preserve)}, meaning to preserve the variable name case.  Only
the ASCII letters in names are changed to lowercase or uppercase.
Unicode characters beyond ASCII range are not changed.

{phang}
{cmd:allstring}[{cmd:("}{it:format}{cmd:")}] forces {cmd:import excel} to
import all Excel data as string data.  You can specify the numeric display
format used to convert the numeric data to string using the optional argument
{it:format}.  See {helpb format:[D] format}.

{phang}
{cmd:clear} clears data in memory before loading data from the Excel workbook.

{pstd}
The following option is available with {cmd:import excel} but is not shown in
the dialog box:

{phang}
{opt locale("locale")} specifies the locale used by the workbook.  You might
need this option when working with extended ASCII character sets.
This option has no effect on Microsoft Windows.  The default locale is UTF-8.


{marker exportoptions}{...}
{title:Options for export excel}

{dlgtab:Main}

{phang}
{cmd:sheet("}{it:sheetname}{cmd:"}[{cmd:, modify}|{cmd:replace}]{cmd:)} saves
to the worksheet named {it:sheetname}.  If there is no worksheet named
{it:sheetname} in the workbook, a new sheet named {it:sheetname} is created.
If this option is not specified, the first worksheet of the workbook is used.
If {it:sheetname} does exist in the workbook, you can either {cmd:modify} or
{cmd:replace} the worksheet.

{phang2}
{cmd:modify} exports data to the worksheet without changing the
cells outside the exported range. This option cannot be
specified with {cmd:replace}, nor when overwriting
the Excel workbook.

{phang2}
{cmd:replace} clears the worksheet before the data are exported to it.
{cmd:replace} cannot be specified with {cmd:modify}, nor when overwriting
the Excel workbook.

{phang}
{opt cell(start)} specifies the start (upper-left) cell in the Excel
worksheet to begin saving to.  By default, {cmd:export excel} saves starting in
the first row and first column of the worksheet.  

{phang}
{cmd:firstrow(}{cmd:variables}|{cmd:varlabels)} specifies 
that the variable names or the variable labels be saved in the first 
row in the Excel worksheet.  The variable name is used if there is no variable
label for a given variable.

{phang}
{opt nolabel} exports the underlying numeric values instead of the 
value labels. 

{phang}
{opt keepcellfmt} specifies that, when writing data, {cmd:export excel} should
preserve the existing worksheet's cell style and format.  By default, 
{cmd:export excel} does not preserve a cell's style or format.

{phang}
{opt replace} overwrites an existing Excel workbook.  {opt replace} 
cannot be specified when modifying or replacing a given worksheet:
{cmd:export excel} ...{cmd:, sheet("", modify)} or
{cmd:export excel} ...{cmd:sheet("", replace)}.

{dlgtab:Advanced}

{phang}
{cmd:datestring("}{it:datetime_format}{cmd:")}
exports all datetime variables as strings formatted by {it:datetime_format}. 
See {helpb datetime_display_formats:[D] Datetime display formats}.

{phang}
{cmd:missing("}{it:repval}{cmd:")} exports missing values as {it:repval}.  
{it:repval} can be either string or numeric.  Without specifying this option, 
{cmd:export excel} exports the missing values as empty cells. 

{pstd}
The following option is available with {cmd:export excel} but is not shown in
the dialog box:

{phang}
{opt locale("locale")} specifies the locale used by the workbook.  You might
need this option when working with extended ASCII character sets.  The default
locale is UTF-8.


{marker remarks}{...}
{title:Remarks/Examples}

{pstd}
To demonstrate the use of {cmd:import excel} and {cmd:export excel},
we will first load {cmd:auto.dta} and export it as an Excel
file named {cmd:auto.xls}:

        {cmd}. webuse auto
        {res}{txt}(1978 Automobile Data)

        {cmd}. export excel auto, firstrow(variables){txt}
        {res}{txt}file auto.xls saved

{pstd}Now we can import from the {cmd:auto.xls} file we just created,
telling Stata to clear the current data from memory and to
treat the first row of the worksheet in the Excel file as
variable names:

        {com}. import excel auto.xls, firstrow clear
        {res}
        {com}. describe

        {txt}Contains data
          obs:{res}            74                          
        {txt} vars:{res}            12                          
        {txt} size:{res}         3,922                          
        {txt}{hline}
                      storage  display     value
        variable name   type   format      label      variable label
        {hline}
        {res}{bind:make           }{txt}{bind: str17  }{bind:{txt}%17s       }{space 1}{bind:         }{bind:  }{res}{res}make
        {bind:price          }{txt}{bind: int    }{bind:{txt}%10.0g     }{space 1}{bind:         }{bind:  }{res}{res}price
        {bind:mpg            }{txt}{bind: byte   }{bind:{txt}%10.0g     }{space 1}{bind:         }{bind:  }{res}{res}mpg
        {bind:rep78          }{txt}{bind: byte   }{bind:{txt}%10.0g     }{space 1}{bind:         }{bind:  }{res}{res}rep78
        {bind:headroom       }{txt}{bind: double }{bind:{txt}%10.0g     }{space 1}{bind:         }{bind:  }{res}{res}headroom
        {bind:trunk          }{txt}{bind: byte   }{bind:{txt}%10.0g     }{space 1}{bind:         }{bind:  }{res}{res}trunk
        {bind:weight         }{txt}{bind: int    }{bind:{txt}%10.0g     }{space 1}{bind:         }{bind:  }{res}{res}weight
        {bind:length         }{txt}{bind: int    }{bind:{txt}%10.0g     }{space 1}{bind:         }{bind:  }{res}{res}length
        {bind:turn           }{txt}{bind: byte   }{bind:{txt}%10.0g     }{space 1}{bind:         }{bind:  }{res}{res}turn
        {bind:displacement   }{txt}{bind: int    }{bind:{txt}%10.0g     }{space 1}{bind:         }{bind:  }{res}{res}displacemen
        {bind:gear_ratio     }{txt}{bind: double }{bind:{txt}%10.0g     }{space 1}{bind:         }{bind:  }{res}{res}gear_ratio
        {bind:foreign        }{txt}{bind: str8   }{bind:{txt}%9s        }{space 1}{bind:         }{bind:  }{res}{res}foreign
        {txt}{hline}
        Sorted by: 
        {res}     Note: Dataset has changed since last saved.{txt}

{pstd}We can also import a subrange of the cells in the Excel file:

        {com}. import excel auto.xls, cellrange(:D70) firstrow clear
        {res}
        {com}. describe

        {txt}Contains data
          obs:{res}            69                          
        {txt} vars:{res}             4                          
        {txt} size:{res}         1,449                          
        {txt}{hline}
                      storage  display     value
        variable name   type   format      label      variable label
        {hline}
        {res}{bind:make           }{txt}{bind: str17  }{bind:{txt}%17s       }{space 1}{bind:         }{bind:  }{res}{res}make
        {bind:price          }{txt}{bind: int    }{bind:{txt}%10.0g     }{space 1}{bind:         }{bind:  }{res}{res}price
        {bind:mpg            }{txt}{bind: byte   }{bind:{txt}%10.0g     }{space 1}{bind:         }{bind:  }{res}{res}mpg
        {bind:rep78          }{txt}{bind: byte   }{bind:{txt}%10.0g     }{space 1}{bind:         }{bind:  }{res}{res}rep78
        {txt}{hline}
        Sorted by: 
        {res}     Note: Dataset has changed since last saved.{txt}

{pstd}Both {cmd:.xls} and {cmd:.xlsx} files are supported by {cmd:import excel}
and {cmd:export excel}.  If a file extension is not specified with
{cmd:export excel}, {cmd:.xls} is assumed, because this format is
more common and is compatible with more applications that also can read
from Excel files.  To save the data in memory as a {cmd:.xlsx} file,
specify the extension:

        {com}. webuse auto, clear
        {txt}(1978 Automobile Data)

        {com}. export excel auto.xlsx{txt}
        {res}{txt}file auto.xlsx saved

{pstd}To export a subset of variables and overwrite the
existing {cmd:auto.xls} Excel file, specify a variable list and the
{cmd:replace} option:

        {com}. export excel make mpg weight using auto, replace{txt}
        {res}{txt}file auto.xls saved


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=N5ZFgzN2_7c":Import Excel data into Stata}


{marker technote1}{...}
{title:Technical note:  Excel data size limits}

{pstd}
For an Excel {cmd:.xls}-type workbook, the worksheet size limits 
are 65,536 rows by 256 columns.  The string size limit is 255 characters.

{pstd}
For an Excel {cmd:.xlsx}-type workbook, the worksheet size limits are 1,048,576
rows by 16,384 columns.  The string size limit is 32,767 characters.


{marker technote2}{...}
{title:Technical note:  Dates and times}

{pstd}
Excel has two different date systems, the "1900 Date System" and the 
"1904 Date System".  Excel stores a date and time as an integer 
representing the number of days since a start date plus a fraction 
of a 24-hour day. 

{pstd}
In the 1900 Date System, the start date is 00Jan1900; in the 1904
Date System, the start date is 01Jan1904.  In the 1900 Date System,
there is another artificial date, 29feb1900, besides 00Jan1900.  
{cmd: import excel} translates 29feb1900 to 28feb1900 and 00Jan1900 to
31dec1899.

{pstd}
See {it:{help datetime##s11:Using dates and times from other software}}
in {helpb datetime:[D] Datetime} for a discussion of the 
relationship between Stata datetimes and Excel datetimes.


{marker technote3}{...}
{title:Technical note:  Mixed data types}

{pstd}
Because Excel's data type is cell based, {cmd:import excel} may encounter
a column of cells with mixed data types.  In such a case, the following 
rules are used to determine the variable type in Stata of the imported column. 

{p 8 8 2}If the column contains at least one cell with nonnumerical 
	text, the entire column is imported as a string variable. 
	
{p 8 8 2}If an all-numerical column contains at least one cell formatted as 
	a date or time, the entire column is imported as a Stata date or
	datetime variable.  {cmd:import excel} imports the column as a Stata
	date if all date cells in Excel are dates only; otherwise, a datetime
        is used. 


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:import excel} {it:filename}{cmd:, describe} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N_worksheet)}}number of worksheets in the Excel workbook{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(worksheet_}{it:#}{cmd:)}}name of worksheet {it:#} in the Excel workbook{p_end}
{synopt:{cmd:r(range_}{it:#}{cmd:)}}available cell range for worksheet {it:#} in the Excel workbook{p_end}
