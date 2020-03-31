{smcl}
{* *! version 2.0.1  15may2018}{...}
{viewerdialog xmlsave "dialog xmlsave"}{...}
{viewerdialog xmluse "dialog xmluse"}{...}
{vieweralsosee prdocumented "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] compress" "help compress"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{vieweralsosee "[D] File formats .dta" "help dta"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{viewerjumpto "Syntax" "xmlsave##syntax"}{...}
{viewerjumpto "Description" "xmlsave##description"}{...}
{viewerjumpto "Options for xmlsave" "xmlsave##options_xmlsave"}{...}
{viewerjumpto "Options for xmluse" "xmlsave##options_xmluse"}{...}
{viewerjumpto "Examples" "xmlsave##examples"}{...}
{pstd}
{cmd:xmlsave} continues to work but, as of Stata 15, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.


{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :{hi:[D] xmlsave} {hline 2}}Export or import dataset in XML format{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Export dataset in memory to XML format

{p 8 32 2}
{cmdab:xmlsav:e} {it:{help filename}} {ifin} [{cmd:,} 
{it:{help xmlsave##xmlsave_options:xmlsave_options}}]


{phang}
Export subset of dataset in memory to XML format

{p 8 32 2}
{cmdab:xmlsav:e} {varlist} {cmd:using} {it:{help filename}} {ifin}
[{cmd:,} {it:{help xmlsave##xmlsave_options:xmlsave_options}}]


{phang}
Import XML-format dataset

{p 8 31 2}
{cmd:xmluse} {it:{help filename}} [{cmd:,} 
{it:{help xmlsave##xmluse_options:xmluse_options}}]


{synoptset 31 tabbed}{...}
{marker xmlsave_options}{...}
{synopthdr :xmlsave_options}
{synoptline}
{syntab :Main}
{synopt :{cmdab:doc:type(dta)}}save XML file by using Stata's {cmd:.dta} format{p_end}
{synopt :{cmdab:doc:type(excel)}}save XML file by using Excel XML format{p_end}
{synopt :{opt dtd}}include Stata DTD in XML file{p_end}
{synopt :{opt leg:ible}}format XML to be more legible{p_end}
{synopt :{opt replace}}overwrite existing {it:{help filename}}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 31}{...}
{marker xmluse_options}{...}
{synopthdr :xmluse_options}
{synoptline}
{synopt :{cmdab:doc:type(dta)}}load XML file by using Stata's {cmd:.dta} format{p_end}
{synopt :{cmdab:doc:type(excel)}}load XML file by using Excel XML format{p_end}
{synopt :{cmd:sheet("}{it:sheetname}{cmd:")}}Excel worksheet to load{p_end}
{synopt :{opt cell:s(upper-left:lower-right)}}Excel cell range to load{p_end}
{synopt :{opt date:string}}import Excel dates as strings{p_end}
{synopt :{opt all:string}}import all Excel data as strings{p_end}
{synopt :{opt first:row}}treat first row of Excel data as variable names{p_end}
{synopt :{opt miss:ing}}treat inconsistent Excel types as missing{p_end}
{synopt :{opt nocomp:ress}}do not compress Excel data{p_end}
{synopt :{opt clear}}replace data in memory{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xmlsave} and {cmd:xmluse} allow datasets to be exported or imported in XML
file formats for Stata's {cmd:.dta} and Microsoft Excel's SpreadsheetML format.
XML files are advantageous because they are structured text files that are
highly portable between applications that understand XML.

{pstd}
Stata can directly import files in Microsoft Excel {cmd:.xls} or {cmd:.xlsx}
format.  If you have files in that format or you wish to export files to
that format, see {helpb import excel:[D] import excel}.

{pstd}
{cmd:xmlsave} exports the data in memory in the {cmd:dta} XML format by
default.  To export the data, type

{phang}{cmd:. xmlsave} {it:filename}

{pstd}
although sometimes you will want to explicitly specify which document type 
definition (DTD) to use by typing

{phang}{cmd:. xmlsave} {it:filename}{cmd:, doctype(}{cmd:dta}{cmd:)}

{pstd}
{cmd:xmluse} can read either an Excel-format XML or a Stata-format XML
file into Stata.  You type

{phang}{cmd:. xmluse} {it:filename}

{pstd}
Stata will read into memory the XML file {it:{help filename}}{cmd:.xml},
containing the data after determining whether the file is of document type
{cmd:dta} or {cmd:excel}. As with the {cmd:xmlsave} command, the document type
can also be explicitly specified with the {opt doctype()} option.

{phang}{cmd:. xmluse} {it:filename}{cmd:, doctype(}{cmd:dta}{cmd:)}

{pstd}
It never hurts to specify the document type; it is actually recommended because 
there is no guarantee that Stata will be able to determine the document type
from the content of the XML file.  Whenever the {opt doctype()} option is
omitted, a note will be displayed that identifies the document type Stata used
to load the dataset.

{pstd}
If {it:filename} is specified without an extension, {cmd:.xml} is assumed.

{pstd}
{cmd:xmlsave} cannot save {helpb data types:strL}s.


{marker options_xmlsave}{...}
{title:Options for xmlsave}

{dlgtab:Main}

{phang}
{cmd:doctype(dta}{c |}{cmd:excel)} specifies the DTD to use when exporting the
dataset.

{pmore}
{cmd:doctype(dta)}, the default, specifies that an XML file will be exported
using Stata's {cmd:.dta} format (see {manhelp dta P:File formats .dta}).  This
is analogous to Stata's binary {cmd:dta} format for datasets.  All data that
can normally be represented in a normal {cmd:dta} file will be represented by
this document type.

{pmore}
{cmd:doctype(excel)} specifies that an XML file will be exported using
Microsoft's SpreadsheetML DTD.  SpreadsheetML is the term
given by Microsoft to the Excel XML format.  Specifying this document type
produces a generic spreadsheet with variable names as the first row, followed
by data.  It can be imported by any version of Microsoft Excel that supports
Microsoft's SpreadsheetML format.

{phang}
{opt dtd} when combined with {cmd:doctype(dta)} embeds the necessary
DTD into the XML file so that a validating parser of another
application can verify the {cmd:dta} XML format.  This option is rarely used,
however, because it increases file size with information that is purely
optional.

{phang}
{opt legible} adds indents and other optional formatting to the XML file,
making it more legible for a person to read.  This extra formatting, however,
is unnecessary and in larger datasets can significantly increase the file
size.

{phang}
{opt replace} permits {cmd:xmlsave} to overwrite existing
{it:{help filename}}{cmd:.xml}.


{marker options_xmluse}{...}
{title:Options for xmluse}

{phang}
{cmd:doctype(dta}{c |}{cmd:excel)} specifies the 
DTD to use when loading data from {it:{help filename}}{cmd:.xml}.  Although
it is optional, use of {opt doctype()} is encouraged. If this option is
omitted with {cmd:xmluse}, the document type of {it:filename}{cmd:.xml} will
be determined automatically.  When this occurs, a note will display the
document type used to translate {it:filename}{cmd:.xml}.  This automatic
determination of document type is not guaranteed, and the use of this option
is encouraged to prevent ambiguity between various XML formats.  Specifying
the document type explicitly also improves speed, as the data are only passed
over once to load, instead of twice to determine the document type. In larger
datasets, this advantage can be noticeable.

{pmore}
{cmd:doctype(dta)} specifies that an XML file will be loaded using Stata's
{cmd:dta} format.  This document type follows closely Stata's binary
{cmd:.dta} format (see {manhelp dta P:File formats .dta}).

{pmore}
{cmd:doctype(excel)} specifies that an XML file will be loaded using
Microsoft's SpreadsheetML DTD.  SpreadsheetML is the term
given by Microsoft to the Excel XML format.

{phang}
{cmd:sheet("}{it:sheetname}{cmd:")} imports the worksheet named
{it:sheetname}. Excel files can contain multiple worksheets within one 
document, so using the {opt sheet()} option specifies which of these to load.
The default is to import the first worksheet to occur within
{it:{help filename}}{cmd:.xml}.

{phang}
{opt "cells(upper-left:lower-right)"} specifies a cell range within an Excel
worksheet to load.  The default range is the entire range of the worksheet,
even if portions are empty.  Often times the use of {opt cells()} is necessary
because data are offset within a spreadsheet, or only some of the data
need to be loaded.  Cell-range notation follows the letter-for-column and
number-for-row convention that is popular within all spreadsheet applications.
The following are valid examples:

{phang2}{cmd:. xmluse} {it:filename}{cmd:, doctype(excel) cells(A1:D100)}

{phang2}{cmd:. xmluse} {it:filename}{cmd:, doctype(excel) cells(C23:AA100)}

{phang}
{cmd:datestring} forces all Excel SpreadsheetML date formats to be imported as
strings to retain time information that would otherwise be lost if
automatically converted to Stata's date format.  With this option, time
information can be parsed from the string after loading it.

{phang}
{cmd:allstring} forces Stata to import all Excel SpreadsheetML data as string
data.  Although data type information is dictated by SpreadsheetML, there are no
constraints to keep types consistent within columns.  When such inconsistent
use of data types occurs in SpreadsheetML, the only way to resolve
inconsistencies is to import data as string data.

{phang}
{cmd:firstrow} specifies that the first row of data in an Excel worksheet
consist of variable names. The default behavior is to generate generic names.
If any name is not a valid Stata variable name, a generic name will be
substituted in its place.

{phang}
{cmd:missing} forces any inconsistent data types within SpreadsheetML columns
to be imported as missing data.  This can be necessary for various reasons but
often will occur when a formula for a particular cell results in an error,
thus inserting a cell of type {cmd:ERROR} into a column that was predominantly
of a {cmd:NUMERIC} type.

{phang}
{cmd:nocompress} specifies that data not be compressed after loading from an
Excel SpreadsheetML file.  Because data type information in SpreadsheetML can
be ambiguous, Stata initially imports with broad data types and, after all
data are loaded, performs a {helpb compress} to reduce data
types to a more appropriate size.  The following table shows the data type
conversion used before compression and the data types that would result from
using {opt nocompress}:

	  SpreadsheetML type     Initial Stata type 
	 {hline 43}
          String                 {cmd:str2045}
          Number                 {cmd:double}
          Boolean                {cmd:double}
          DateTime               {cmd:double}
          Error                  {cmd:str2045}
	 {hline 43}

{phang}
{cmd:clear} clears data in memory before loading from
{it:{help filename}}{cmd:.xml}.


{marker examples}{...}
{title:Examples saving XML files}

{pstd}
To export the current Stata dataset to a file, {cmd:auto.xml} type

{phang2}{cmd:. xmlsave auto} 

{pstd}
To overwrite an existing XML dataset with a new file containing the
variables {cmd:make}, {cmd:mpg}, and {cmd:weight}, type

{phang2}{cmd:. xmlsave make mpg weight using auto, replace}

{pstd}
To export the dataset to an XML file for use with Microsoft Excel, type

{phang2}{cmd:. xmlsave auto, doctype(excel) replace}


{title:Examples using XML files}

{pstd}
Assuming that we have a file named {cmd:auto.xml} that was exported using the 
{cmd:doctype(dta)} option of {cmd:xmlsave}, we can read in this dataset with 
the command

{phang2}{cmd:. xmluse auto, doctype(dta) clear}	

{pstd}
If the file was exported from Microsoft Excel to a file called {cmd:auto.xml}
that contained the worksheet {cmd:Rollover Data}, with the first row
representing column headers (or variable names), we could import the worksheet
by typing

{phang2}{cmd:. xmluse auto, doctype(excel) sheet("Rollover Data") firstrow clear}

{pstd}
Continuing with the previous example, if we wanted just the first column of
data in that worksheet, and we knew there were only 75 rows, including one for 
the variable name, we could have typed

{phang2}{cmd:. xmluse auto, doc(excel) sheet("Rollover Data") cells(A1:A75) first clear}
{p_end}
