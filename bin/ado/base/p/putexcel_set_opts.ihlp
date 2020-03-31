{* *! version 1.0.3  08may2019}{...}
{* *! This help file is called by both putexcel & putexcel advanced.}{...}
{phang}
{opt open} permits {opt putexcel set} to open the Excel file in memory for
modification.  The Excel file is written to disk when {opt putexcel close}
is issued.

{phang} 
{opt modify} permits {opt putexcel set} to modify an Excel file.

{phang} 
{opt replace} permits {opt putexcel set} to overwrite an existing Excel
workbook.  The workbook is overwritten when the first {cmd:putexcel} command
is issued unless the {cmd:open} option is used.

{phang}
{cmd:sheet(}{it:sheetname} [{cmd:, replace}]{cmd:)} saves to the worksheet
named {it:sheetname}.  If there is no worksheet named {it:sheetname} in the
workbook, then a new sheet named {it:sheetname} is created.  If this option is
not specified, {cmd:Sheet1} is used.

{pmore}
{opt replace} permits {opt putexcel set} to overwrite {it:sheetname} if it
exists in the specified {it:filename}.
{p_end}
