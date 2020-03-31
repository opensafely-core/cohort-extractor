{smcl}
{* *! version 1.1.16  12jun2019}{...}
{vieweralsosee "[M-5] xl()" "mansection M-5 xl()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] _docx*()" "help mf__docx"}{...}
{vieweralsosee "[M-5] Pdf*()" "help mf pdf"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4_io"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] import excel" "help import excel"}{...}
{vieweralsosee "[RPT] putdocx intro" "help putdocx intro"}{...}
{vieweralsosee "[RPT] putexcel" "help putexcel"}{...}
{vieweralsosee "[RPT] putpdf intro" "help putpdf intro"}{...}
{viewerjumpto "Syntax" "mf_xl##syntax"}{...}
{viewerjumpto "Description" "mf_xl##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_xl##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_xl##remarks"}{...}
{viewerjumpto "Appendix" "mf_xl##appendix"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[M-5] xl()} {hline 2}}Excel file I/O class
{p_end}
{p2col:}({mansection M-5 xl():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
If you are reading this entry for the first time, skip to 
{help mf_xl##description:Description}.  If you are trying to import or 
export an Excel file to or from Stata, see
{manhelp import_excel D:import excel}.
If you are trying to export a table created by Stata to Excel, see
{manhelp putexcel RPT}.

{pstd}
The syntax diagrams below describe a Mata class.  For
help with class programming in Mata, see {manhelp m2_class M-2:class}.

{p 4 4 2}
Syntax is presented under the following headings:

	{help mf_xl##syn_step1:Step 1:  Initialization}
	{help mf_xl##syn_step2:Step 2:  Creating and opening an Excel workbook}
	{help mf_xl##syn_step3:Step 3:  Setting the Excel worksheet}
	{help mf_xl##syn_step4:Step 4:  Reading and writing data from and to an Excel worksheet}
	{help mf_xl##syn_step5:Step 5:  Formatting cells in an Excel worksheet}
	{help mf_xl##syn_step6:Step 6:  Formatting text in an Excel worksheet}
	{help mf_xl##syn_step7:Step 7:  Formatting cell ranges in an Excel worksheet}
	{help mf_xl##syn_utility:Utility functions for use in all steps}


{marker syn_step1}{...}
    {title:Step 1: Initialization}

{p 8 25 1}
{bind:               }
{it:{help mf_xl##def_B:B}}
{cmd:=}
{cmd:xl()}


{marker syn_step2}{...}
    {title:Step 2: Creating and opening an Excel workbook}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##create_book:{it:B}{bf:.create_book(}{bf:"}{it:filename}{bf:",} {bf:"}{it:sheetname}{bf:"} [{bf:,} {c -(}{bf:"xls"} | {bf:"xlsx"}{c )-}{bf:, "}{it:locale}{bf:"}]{bf:)}}

{p 8 25 1}
{it:(void)}{bind:           }
{help mf_xl##load_book:{it:B}{bf:.load_book(}{bf:"}{it:filename}{bf:"} [{bf:, "}{it:locale}{bf:"}]{bf:)}}

{p 8 25 1}
{it:(void)}{bind:           }
{help mf_xl##clear_book:{it:B}{bf:.clear_book(}{bf:"}{it:filename}{bf:"}{bf:)}}

{p 8 25 1}
{it:(void)}{bind:           }
{help mf_xl##set_mode:{it:B}{bf:.set_mode(}{bf:"open"}|{bf:"closed"}{bf:)}}

{p 8 25 1}
{it:(void)}{bind:           }
{help mf_xl##close_book:{it:B}{bf:.close_book()}}


{marker syn_step3}{...}
    {title:Step 3: Setting the Excel worksheet}

{p 8 25 1}
{it:(void)}{bind:           }
{help mf_xl##add_sheet:{it:B}{bf:.add_sheet(}{bf:"}{it:sheetname}{bf:"}{bf:)}}

{p 8 25 1}
{it:(void)}{bind:           }
{help mf_xl##set_sheet:{it:B}{bf:.set_sheet(}{bf:"}{it:sheetname}{bf:"}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_sheet_gridlines:{it:B}{bf:.set_sheet_gridlines(}{bf:"}{it:sheetname}{bf:"}{bf:,} {c -(}{bf:"on"}|{bf:"off"}{c )-}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_sheet_merge:{it:B}{bf:.set_sheet_merge(}{bf:"}{it:sheetname}{bf:"}{bf:,} {it:real vector row}{bf:,} {it:real vector col}{bf:)}}

{p 8 25 1}
{it:(void)}{bind:           }
{help mf_xl##clear_sheet:{it:B}{bf:.clear_sheet(}{bf:"}{it:sheetname}{bf:"}{bf:)}}

{p 8 25 1}
{it:(void)}{bind:           }
{help mf_xl##delete_sheet:{it:B}{bf:.delete_sheet(}{bf:"}{it:sheetname}{bf:"}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##delete_sheet_merge:{it:B}{bf:.delete_sheet_merge(}{bf:"}{it:sheetname}{bf:"}{bf:,} {it:real scalar row}{bf:,} {it:real scalar col}{bf:)}}

{p 8 25 1}
{it:string colvector}{bind: }
{help mf_xl##get_sheets:{it:B}{bf:.get_sheets()}}


{marker syn_step4}{...}
    {title:Step 4: Reading and writing data from and to an Excel worksheet}

{p 8 45 2}
{it:string matrix}{bind:    }
{help mf_xl##get_string:{it:B}{bf:.get_string(}{it:real vector row}{bf:,} }{it:real vector col}{bf:)}}

{p 8 45 2}
{it:real matrix}{bind:      }
{help mf_xl##get_number:{it:B}{bf:.get_number(}{it:real vector row}{bf:,} {it:real vector col} [{bf:,} {c -(}{bf:"asdate"} | {bf:"asdatetime"}{c )-}]{bf:)}}

{p 8 45 2}
{it:string matrix}{bind:    }
{help mf_xl##get_cell_type:{it:B}{bf:.get_cell_type(}{it:real vector row}{bf:,} {it:real vector col}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##put_string:{it:B}{bf:.put_string(}{it:real scalar row}{bf:,} {it:real scalar col}{bf:,} {it:string matrix s}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##put_number:{it:B}{bf:.put_number(}{it:real scalar row}{bf:,} {it:real scalar col}{bf:,} {it:real matrix r} [{bf:,} {c -(}{bf:"asdate"} | {bf:"asdatetime"} | {bf:"asdatenum"} | {bf:"asdatetimenum"}{c )-}]{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##put_formula:{it:B}{bf:.put_formula(}{it:real scalar row}{bf:,} {it:real scalar col}{bf:,} {it:string matrix s}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##put_picture:{it:B}{bf:.put_picture(}{it:real scalar row}{bf:,} {it:real scalar col}{bf:,} {bf:"}{it:filename}{bf:"}{bf:)}}

{p 8 45 1}
{it:(void)}{bind:           }
{help mf_xl##set_missing:{it:B}{bf:.set_missing(}[{it:real scalar num}|{it:string scalar val}]{bf:)}}


{marker syn_step5}{...}
    {title:Step 5: Formatting cells in an Excel worksheet}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_number_format:{it:B}{bf:.set_number_format(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {bf:"}{it:format}{bf:"}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_vertical_align:{it:B}{bf:.set_vertical_align(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {bf:"}{it:align}{bf:"}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_horizontal_align:{it:B}{bf:.set_horizontal_align(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {bf:"}{it:align}{bf:"}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_border:{it:B}{bf:.set_border(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {bf:"}{it:style}{bf:"} [{bf:,} {bf:"}{it:color}{bf:"}]{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_left_border:{it:B}{bf:.set_left_border(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {bf:"}{it:style}{bf:"} [{bf:,} {bf:"}{it:color}{bf:"}]{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_right_border:{it:B}{bf:.set_right_border(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {bf:"}{it:style}{bf:"} [{bf:,} {bf:"}{it:color}{bf:"}]{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_top_border:{it:B}{bf:.set_top_border(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {bf:"}{it:style}{bf:"} [{bf:,} {bf:"}{it:color}{bf:"}]{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_bottom_border:{it:B}{bf:.set_bottom_border(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {bf:"}{it:style}{bf:"} [{bf:,} {bf:"}{it:color}{bf:"}]{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_diagonal_border:{it:B}{bf:.set_diagonal_border(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {bf:"}{it:direction}{bf:"}{bf:,} {bf:"}{it:style}{bf:"} [{bf:,} {bf:"}{it:color}{bf:"}]{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_fill_pattern:{it:B}{bf:.set_fill_pattern(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {bf:"}{it:pattern}{bf:"}{bf:,} {bf:"}{it:fgcolor}{bf:"} [{bf:,} {bf:"}{it:bgcolor}{bf:"}]{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_column_width:{it:B}{bf:.set_column_width(}{it:real scalar col1}{bf:,} {it:real scalar col2}{bf:,} {it:real scalar width}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_row_height:{it:B}{bf:.set_row_height(}{it:real scalar row1}{bf:,} {it:real scalar row2}{bf:,} {it:real scalar height}{bf:)}}


{marker syn_step6}{...}
    {title:Step 6: Formatting text in an Excel worksheet}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_font:{it:B}{bf:.set_font(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {bf:"}{it:fontname}{bf:"}{bf:,} {it:real scalar size} [{bf:,} {bf:"}{it:color}{bf:"}]{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_font_bold:{it:B}{bf:.set_font_bold(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {c -(}{bf:"on"}|{bf:"off"}{c )-}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_font_italic:{it:B}{bf:.set_font_italic(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {c -(}{bf:"on"}|{bf:"off"}{c )-}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_font_strikeout:{it:B}{bf:.set_font_strikeout(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {c -(}{bf:"on"}|{bf:"off"}{c )-}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_font_underline:{it:B}{bf:.set_font_underline(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {c -(}{bf:"on"}|{bf:"off"}{c )-}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_font_script:{it:B}{bf:.set_font_script(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {c -(}{bf:"sub"}|{bf:"super"}|{bf:"normal"}{c )-}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_text_wrap:{it:B}{bf:.set_text_wrap(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {c -(}{bf:"on"}|{bf:"off"}{c )-}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_shrink_to_fit:{it:B}{bf:.set_shrink_to_fit(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {c -(}{bf:"on"}|{bf:"off"}{c )-}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_text_rotate:{it:B}{bf:.set_text_rotate(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {it:real scalar rotation}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_text_indent:{it:B}{bf:.set_text_indent(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {it:real scalar indent}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_format_lock:{it:B}{bf:.set_format_lock(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {c -(}{bf:"on"}|{bf:"off"}{c )-}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_format_hidden:{it:B}{bf:.set_format_hidden(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {c -(}{bf:"on"}|{bf:"off"}{c )-}{bf:)}}


{marker syn_step7}{...}
    {title:Step 7: Formatting cell ranges in an Excel worksheet}

{p 8 45 2}
{it:real scalar}{bind:      }
{help mf_xl##add_fmtid:{it:B}{bf:.add_fmtid()}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##set_fmtid:{it:B}{bf:.set_fmtid(}{it:real vector row}{bf:,} {it:real vector col}{bf:,} {it:real scalar fmtid}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_number_format:{it:B}{bf:.fmtid_set_number_format(}{it:real scalar fmtid}{bf:,} {bf:"}{it:format}{bf:")}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_vertical_align:{it:B}{bf:.fmtid_set_vertical_align(}{it:real scalar fmtid}{bf:,} {bf:"}{it:align}{bf:")}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_horizontal_align:{it:B}{bf:.fmtid_set_horizontal_align(}{it:real scalar fmtid}{bf:,} {bf:"}{it:align}{bf:")}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_border:{it:B}{bf:.fmtid_set_border(}{it:real scalar fmtid}{bf:,} {bf:"}{it:style}{bf:"} [{bf:,} {bf:"}{it:color}{bf:"}]{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_left_border:{it:B}{bf:.fmtid_set_left_border(}{it:real scalar fmtid}{bf:,} {bf:"}{it:style}{bf:"} [{bf:,} {bf:"}{it:color}{bf:"}]{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_right_border:{it:B}{bf:.fmtid_set_right_border(}{it:real scalar fmtid}{bf:,} {bf:"}{it:style}{bf:"} [{bf:,} {bf:"}{it:color}{bf:"}]{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_top_border:{it:B}{bf:.fmtid_set_top_border(}{it:real scalar fmtid}{bf:,} {bf:"}{it:style}{bf:"} [{bf:,} {bf:"}{it:color}{bf:"}]{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_bottom_border:{it:B}{bf:.fmtid_set_bottom_border(}{it:real scalar fmtid}{bf:,} {bf:"}{it:style}{bf:"} [{bf:,} {bf:"}{it:color}{bf:"}]{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_diagonal_border:{it:B}{bf:.fmtid_set_diagonal_border(}{it:real scalar fmtid}{bf:,} {bf:"}{it:direction}{bf:",} {bf:"}{it:style}{bf:"} [{bf:,} {bf:"}{it:color}{bf:"}]{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_fill_pattern:{it:B}{bf:.fmtid_set_fill_pattern(}{it:real scalar fmtid}{bf:,} {bf:"}{it:pattern}{bf:",} {bf:"}{it:fgcolor}{bf:"} [{bf:,} {bf:"}{it:bgcolor}{bf:"}]{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_column_width:{it:B}{bf:.fmtid_set_column_width(}{it:real scalar fmtid}{bf:,} {it:real scalar col1}{bf:,} {it:real scalar col2}{bf:,} {it:real scalar width}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_row_height:{it:B}{bf:.fmtid_set_row_height(}{it:real scalar fmtid}{bf:,} {it:real scalar row1}{bf:,} {it:real scalar row2}{bf:,} {it:real scalar height}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_text_wrap:{it:B}{bf:.fmtid_set_text_wrap(}{it:real scalar fmtid}{bf:,} {c -(}{bf:"on"}{c |}{bf:"off"}{c )-}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_shrink_to_fit:{it:B}{bf:.fmtid_set_shrink_to_fit(}{it:real scalar fmtid}{bf:,} {c -(}{bf:"on"}{c |}{bf:"off"}{c )-}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_text_rotate:{it:B}{bf:.fmtid_set_text_rotate(}{it:real scalar fmtid}{bf:,} {it:real scalar rotation}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_text_indent:{it:B}{bf:.fmtid_set_text_indent(}{it:real scalar fmtid}{bf:,} {it:real scalar indent}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_format_lock:{it:B}{bf:.fmtid_set_format_lock(}{it:real scalar fmtid}{bf:,} {c -(}{bf:"on"}{c |}{bf:"off"}{c )-}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_format_hidden:{it:B}{bf:.fmtid_set_format_hidden(}{it:real scalar fmtid}{bf:,} {c -(}{bf:"on"}{c |}{bf:"off"}{c )-}{bf:)}}

{p 8 45 2}
{it:real scalar}{bind:      }
{help mf_xl##add_fontid:{it:B}{bf:.add_fontid()}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fmtid_set_fontid:{it:B}{bf:.fmtid_set_fontid(}{it:real scalar fmtid}{bf:,} {it:real scalar fontid}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fontid_set_font:{it:B}{bf:.fontid_set_font(}{it:real scalar fontid}{bf:,} {bf:"}{it:fontname}{bf:",} {it:real scalar size} [{bf:,} {bf:"}{it:color}{bf:"}]{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fontid_set_font_bold:{it:B}{bf:.fontid_set_font_bold(}{it:real scalar fontid}{bf:,} {c -(}{bf:"on"}{c |}{bf:"off"}{c )-}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fontid_set_font_italic:{it:B}{bf:.fontid_set_font_italic(}{it:real scalar fontid}{bf:,} {c -(}{bf:"on"}{c |}{bf:"off"}{c )-}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fontid_set_font_strikeout:{it:B}{bf:.fontid_set_font_strikeout(}{it:real scalar fontid}{bf:,} {c -(}{bf:"on"}{c |}{bf:"off"}{c )-}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fontid_set_font_underline:{it:B}{bf:.fontid_set_font_underline(}{it:real scalar fontid}{bf:,} {c -(}{bf:"on"}{c |}{bf:"off"}{c )-}{bf:)}}

{p 8 45 2}
{it:(void)}{bind:           }
{help mf_xl##fontid_set_font_script:{it:B}{bf:.fontid_set_font_script(}{it:real scalar fontid}{bf:,} {c -(}{bf:"sub"}{c |}{bf:"super"}{c |}{bf:"normal"}{c )-}{bf:)}}


{marker syn_utility}{...}
    {title:Utility functions for use in all steps}

{p 8 25 1}
{it:(varies)}{bind:         }
{help mf_xl##query:{it:B}{bf:.query(}[{bf:"}{it:item}{bf:"}]{bf:)}}

{p 8 25 1}
{it:real vector}{bind:      }
{help mf_xl##get_colnum:{it:B}{bf:.get_colnum(}{it:string vector}{bf:)}}

{p 8 25 1}
{it:string vector}{bind:    }
{help mf_xl##get_colletter:{it:B}{bf:.get_colletter(}{it:real vector}{bf:)}}

{p 8 25 1}
{it:(void)}{bind:           }
{help mf_xl##set_keep_cell_format:{it:B}{bf:.set_keep_cell_format(}{bf:"on"}|{bf:"off"}{bf:)}}

{p 8 25 1}
{it:(void)}{bind:           }
{help mf_xl##set_error_mode:{it:B}{bf:.set_error_mode(}{bf:"on"}|{bf:"off"}{bf:)}}

{p 8 25 1}
{it:real scalar}{bind:      }
{help mf_xl##get_last_error:{it:B}{bf:.get_last_error()}}

{p 8 25 1}
{it:string scalar}{bind:    }
{help mf_xl##get_last_error_message:{it:B}{bf:.get_last_error_message()}}


{p 8 8 2}
where {it:item} can be

		{cmd:filename}
		{cmd:mode}
		{cmd:filetype}
		{cmd:sheetname}
		{cmd:missing}


{marker description}{...}
{title:Description}

{p 4 4 2}
The {cmd:xl()} class allows you to create Excel 1997/2003 ({cmd:.xls})
files and Excel 2007/2013 ({cmd:.xlsx}) files and load them from and to Mata
matrices.  The two Excel file types have different data size limits that you
can read about in
{it:{help import_excel##technote1:Technical note: Excel data size limits}} of
{cmd:import excel}.  The {cmd:xl()} class is supported on Windows, Mac, and
Linux.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 xl()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_xl##syn_B:Definition of B}
	{help mf_xl##syn_book_funcs:Specifying the Excel workbook}
	{help mf_xl##syn_sheet_funcs:Specifying the Excel worksheet}
	{help mf_xl##syn_get_funcs:Reading data from Excel}
	{help mf_xl##syn_put_funcs:Writing data to Excel}
	{help mf_xl##syn_miss_func:Dealing with missing values}
	{help mf_xl##syn_dates:Dealing with dates}
	{help mf_xl##syn_format_funcs:Formatting functions}
	  {help mf_xl##syn_format_numeric:Numeric formatting}
	  {help mf_xl##syn_format_align:Text alignment}
	  {help mf_xl##syn_format_border:Cell borders}
	  {help mf_xl##syn_format_fonts:Fonts}
	  {help mf_xl##syn_format_other:Other}
	  {help mf_xl##syn_format_examples:Formatting examples}
	{help mf_xl##syn_range:Range formatting functions}
	  {help mf_xl##syn_range_addfmtid:Adding format IDs}
	  {help mf_xl##syn_range_setfmtid:Setting formats by ID}
	  {help mf_xl##syn_range_cellfmt:Cell formatting functions}
	  {help mf_xl##syn_range_addfontid:Adding font IDs}
	  {help mf_xl##syn_range_setfontid:Setting font IDs for format IDs}
	  {help mf_xl##syn_range_fontfmt:Font formatting functions}
	  {help mf_xl##syn_range_formatex:Range formatting examples}
	{help mf_xl##syn_util_funcs:Utility functions}
	{help mf_xl##syn_util_error:Handling errors}
	{help mf_xl##syn_error_codes:Error codes}


{marker syn_B}{...}
{marker def_B}{...}
{marker init}{...}
    {title:Definition of B}

{p 4 4 2}
A variable of type {cmd:xl} is called an
{help m6_glossary##instance:instance} of the {cmd:xl()}
class.  {it:B} is an instance of {cmd:xl()}.  You can use the class
interactively:

		{cmd}b = xl()
		b.create_book("results", "Sheet1")
		...{txt}

{p 4 4 2}
In a function, you would declare one instance of the {cmd:xl()} class {it:B}
as a {cmd:scalar}.

		{cmd}void myfunc()
		{
			class xl scalar   b

			b = xl()
			b.create_book("results", "Sheet1")
			...
		}{txt}

{p 4 4 2}
When using the class inside other functions, you do not need to create the
instance explicitly as long as you declare the member-instance variable to be a
{cmd:scalar}:


		{cmd}void myfunc()
		{
			class xl scalar   b

			b.create_book("results", "Sheet1")
			...
		}{txt}


{marker syn_book_funcs}{...}
    {title:Specifying the Excel workbook}

{p 4 4 2}
To read from or write to an existing Excel workbook, you need to tell the
{cmd:xl()} class about that workbook.  To create a new workbook to write to,
you need to tell the {cmd:xl()} class what to name that workbook and what type
of Excel file that workbook should be.   Excel 1997/2003 ({cmd:.xls}) files
and Excel 2007/2010 ({cmd:.xlsx}) files can be created.  You must either load
or create a workbook before you can use any sheet or read or write
{it:{help m2_class##def_member:member functions}} of the {cmd:xl()} class.

{marker create_book}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.create_book(}{cmd:"}{it:filename}{cmd:"}{cmd:,}
{cmd:"}{it:sheetname}{cmd:"}
[{cmd:,} {c -(}{cmd:"xls"} | {cmd:"xlsx"}{c )-}{cmd:, "}{it:locale}{cmd:"}]{cmd:)}
     creates an Excel workbook named {it:filename} with the sheet
     {it:sheetname}.  By default, an {cmd:.xlsx}
     file is created.  If you use the optional {cmd:xls} argument, then an
     {cmd:.xls} file is created.  {it:locale} specifies the locale used by the
     workbook.  You might need this option when working with extended ASCII
     character sets.  This option has no effect on Microsoft Windows.
     The default locale is UTF-8.

{marker load_book}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.load_book(}{cmd:"}{it:filename}{cmd:"} [{cmd:, "}{it:locale}{cmd:"}]{cmd:)}
     loads an existing Excel workbook.  Once it is loaded, you can read from
     or write to the workbook.  {it:locale} specifies the locale used by the
     workbook.  You might need this option when working with extended ASCII
     character sets.  This option has no effect on Microsoft Windows.
     The default locale is UTF-8.

{marker clear_book}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.clear_book(}{cmd:"}{it:filename}{cmd:"}{cmd:)}
     removes all worksheets from an existing Excel workbook.

{pstd}
To create an {cmd:.xlsx} workbook, code

		{cmd}b = xl()
		b.create_book("results", "Sheet1", "xlsx"){txt}

{pstd}
To load an {cmd:.xls} workbook, code

		{cmd}b = xl()
		b.load_book("Budgets.xls"){txt}

{pstd}
The {cmd:xl()} class will open and close the workbook for each member
function you use that reads from or writes to the workbook.  This is done by
default, so you do not have to worry about opening and closing a file handle.
This can be slow if you are reading or writing data at the cell level.  In
these cases, you should leave the workbook open, deal with your data, and then
close the workbook.  The following member functions allow you to control how
the class handles file I/O.

{marker set_mode}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_mode(}{cmd:"open"}|{cmd:"closed"}{cmd:)}
     sets whether the workbook file is left open for reading or writing data.
     {cmd:set_mode("closed")}, the default, means that the workbook is
     opened and closed after every sheet or read or write member function.

{marker close_book}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.close_book()}
     closes a workbook file if the file has been left open using {cmd:set_mode("open")}.

{pstd}
Below is an example of how to speed up file I/O when writing data.

		{cmd}b = xl()
		b.create_book("results", "year1")

		b.set_mode("open")
		for(i=1;i<10000;i++) {
			b.put_number(i,1,i)
			...
		}
		b.close_book(){txt}


{marker syn_sheet_funcs}{...}
    {title:Specifying the Excel worksheet}

{p 4 4 2}
The following member functions are used to set the active worksheet the
{cmd:xl()} class will use to read data from or write data to.  By default, if
you do not specify a worksheet, the {cmd:xl()} class will use the first
worksheet in the workbook.

{marker add_sheet}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.add_sheet(}{cmd:"}{it:sheetname}{cmd:"}{cmd:)}
      adds a new worksheet named {it:sheetname} to the workbook and sets
      the active worksheet to that sheet.

{p 8 12 2}
{marker set_sheet}{...}
{it:{help mf_xl##def_B:B}}{cmd:.set_sheet(}{cmd:"}{it:sheetname}{cmd:"}{cmd:)}
      sets the active worksheet to {it:sheetname} in the {cmd:xl()} class.

{p 4 4 2}
The following member functions are sheet utilities:

{p 8 12 2}
{marker set_sheet_gridlines}{...}
{it:{help mf_xl##def_B:B}}{cmd:.set_sheet_gridlines(}{cmd:"}{it:sheetname}{cmd:"}{cmd:,} {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)}
      sets whether gridlines are displayed for {it:sheetname}.  The default
      is {cmd:on}.

{p 8 12 2}
{marker set_sheet_merge}{...}
{it:{help mf_xl##def_B:B}}{cmd:.set_sheet_merge(}{cmd:"}{it:sheetname}{cmd:"}{cmd:,} {it:row}{cmd:,} {it:col}{cmd:)}
     merges the cells in {it:sheetname} for each Excel cell in the Excel cell
     range specified in {it:row} and {it:col}.   Both {it:row} and {it:col}
     can be a 1x2 {cmd:real} {cmd:vector}.  The first value in the vectors
     must be the starting (upper-left) cell in the Excel worksheet to which
     you want to merge.  The second value must be the ending (lower-right) cell
     in the Excel worksheet to which you want to merge.

{marker clear_sheet}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.clear_sheet(}{cmd:"}{it:sheetname}{cmd:"}{cmd:)}
      clears all cell values for {it:sheetname}.

{marker delete_sheet}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.delete_sheet(}{cmd:"}{it:sheetname}{cmd:"}{cmd:)}
      deletes {it:sheetname} from the workbook.

{p 8 12 2}
{marker delete_sheet_merge}{...}
{it:{help mf_xl##def_B:B}}{cmd:.delete_sheet_merge(}{cmd:"}{it:sheetname}{cmd:"}{cmd:,} {it:row}{cmd:,} {it:col}{cmd:)}
     deletes the merged cells in {it:sheetname} for any Excel cells
     merged with the cell specified by {it:row} and {it:col}.   

{marker get_sheets}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.get_sheets()} returns a {cmd:string colvector}
of all the sheetnames in the current workbook.

{p 4 4 2}
You may need to make a change to all the sheets in a workbook.
{cmd:get_sheets()} can help you do this.

		{cmd}void myfunc()
		{
			class xl scalar   b
			string colvector  sheets
			real scalar	  i

			b.load_book("results")
			sheets = b.get_sheets()

			for(i=1;i<=rows(sheets);i++) {
				b.set_sheet(sheets[i])
				b.clear_sheet(sheets[i])
				...
			}
		}{txt}

{p 4 4 2}
To create a new workbook with multiple new sheets, code

		{cmd}b.create_book("Budgets", "Budget 2009")

		for(i=10;i<=13;i++) {
			sheet = "Budget 20" + strofreal(i)
			b.add_sheet(sheet)
		}{txt}


{marker syn_get_funcs}{...}
    {title:Reading data from Excel}

{p 4 4 2}
The following member functions of the
{cmd:xl()} class are used to read data.  Both {it:row} and {it:col} can be a
{cmd:real} {cmd:scalar} or a 1x2 {cmd:real} {cmd:vector}.

{marker get_string}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.get_string(}{it:row}{cmd:,} {it:col}{cmd:)}
     returns a string matrix containing values in a cell range depending
     on the range specified in {it:row} and {it:col}.

{marker get_number}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.get_number(}{it:row}{cmd:,} {it:col}
[{cmd:,} {c -(}{cmd:"asdate"} | {cmd:"asdatetime"}{c )-}]{cmd:)}
     returns a {cmd:real matrix} containing values in an Excel cell range
     depending on the range specified in {it:row} and {it:col}.

{marker get_cell_type}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.get_cell_type(}{it:row}{cmd:,} {it:col}{cmd:)}
     returns a {cmd:string matrix} containing the string values
     {cmd:numeric}, {cmd:string}, {cmd:date}, {cmd:datetime}, or {cmd:blank}
     for each Excel cell in the Excel cell range specified in {it:row} and
     {it:col}.

{p 4 4 2}
To get the value in cell {cmd:A1} from Excel into a {cmd:string scalar}, code

		{cmd}string scalar val

		val = b.get_string(1,1){txt}

{p 4 4 2}
If {cmd:A1} contained the value {cmd:"Yes"}, then {cmd:val} would contain
{cmd:"Yes"}.  If {cmd:A1} contained the numeric value {cmd:1}, then {cmd:val}
would contain {cmd:"1"}.  {cmd:get_string()} will convert numeric values
to strings.

{p 4 4 2}
To get the value in cell {cmd:A1} from Excel into a {cmd:real scalar}, code

		{cmd}real scalar val

		val = b.get_number(1,1){txt}

{p 4 4 2}
If {cmd:A1} contained the value {cmd:"Yes"}, then {cmd:val} would contain a
missing value.  {cmd:get_number} will return a missing value for a string value.
If {cmd:A1} contained the numeric value {cmd:1}, then {cmd:val} would contain
the value {cmd:1}.

{p 4 4 2}
To read a range of data into Mata, you must specify the cell range by using a
1x2 {cmd:rowvector}. To read row {cmd:1}, columns {cmd:B} through {cmd:F} of a
worksheet, code

		{cmd}string rowvector cells
		real rowvector cols

		cols = (2,6)
		cells = b.get_string(1,cols){txt}

{p 4 4 2}
To read rows {cmd:1} through {cmd:3} and columns {cmd:B} through {cmd:D} of a
worksheet, code

		{cmd}real matrix cells
		real rowvector rows, cols

		rows = (1,3)
		cols = (2,4)
		cells = b.get_number(rows,cols){txt}


{marker syn_put_funcs}{...}
    {title:Writing data to Excel}

{p 4 4 2}
The following member functions of the {cmd:xl()} class are used to write data.
{it:row} and {it:col} are {cmd:real} {cmd:scalars}.  When you write a matrix or
vector, {it:row} and {it:col} are the starting (upper-left) cell in the Excel
worksheet to which you want to begin saving.

{marker put_string}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.put_string(}{it:row}{cmd:,} {it:col}{cmd:,}
{it:s}{cmd:)}
    writes a {cmd:string} {cmd:scalar}, {cmd:vector}, or {cmd:matrix} to an
    Excel worksheet.

{marker put_number}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.put_number(}{it:row}{cmd:,} {it:col}{cmd:,}
{it:r}[{cmd:,} {c -(}{cmd:"asdate"} | {cmd:"asdatetime"} | {cmd:"asdatenum"} |
 {cmd:"asdatetimenum"} {c )-}]{cmd:)}
    writes a {cmd:real} {cmd:scalar}, {cmd:vector}, or {cmd:matrix} to an
    Excel worksheet.

{marker put_formula}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.put_formula(}{it:row}{cmd:,} {it:col}{cmd:,}
{it:s}{cmd:)}
    writes a {cmd:string} {cmd:scalar}, {cmd:vector}, or {cmd:matrix}
    containing valid Excel formulas to an Excel worksheet.

{marker put_picture}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.put_picture(}{it:row}{cmd:,} {it:col}{cmd:,}
{it:filename}{cmd:)}
    writes a portable network graphics ({cmd:.png}),
    JPEG ({cmd:.jpg}), Windows metafile ({cmd:.wmf}),
    device-independent bitmap ({cmd:.dib}), enhanced metafile ({cmd:.emf}), or
    tagged image file format ({cmd:.tiff}) file to an Excel worksheet.

{p 4 4 2}
To write the string {cmd:"Auto Dataset"} in cell {cmd:A1} of a worksheet, code

		{cmd:b.put_string(1, 1, "Auto Dataset")}

{p 4 4 2}
To write {cmd:"mpg"}, {cmd:"rep78"}, and {cmd:"headroom"} to cells {cmd:B1}
through {cmd:D1} in a worksheet, code

		{cmd}names = ("mpg", "rep78", "headroom")
		b.put_string(1, 2, names){txt}

{p 4 4 2}
To write values {cmd:22}, {cmd:17}, {cmd:22}, {cmd:20}, and {cmd:15} to cells
{cmd:B2} through {cmd:B6} in a worksheet, code

		{cmd}mpg_vals = (22\17\22\20\15)
		b.put_number(2, 2, mpg_vals){txt}

{p 4 4 2}
To sum the cells {cmd:A1} through {cmd:A4} in  cell {cmd:A6} in a worksheet,
code

		{cmd}b.put_formula(1, 6, "SUM(A1:A4)"){txt}

{p 4 4 2}
To write the file {cmd:mygraph.png} to starting cell
{cmd:D15} in a worksheet, code

		{cmd}b.put_picture(4, 15, "mygraph.png"){txt}


{marker syn_miss_func}{...}
    {title:Dealing with missing values}

{marker set_missing}{...}
{p 4 4 2}
{cmd:set_missing(}{cmd:)} sets how Mata missing values are to be treated when
writing data to a worksheet.  Here are the three syntaxes:

{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_missing(}{cmd:)} specifies that missing
values be written as blank cells.  This is the default.

{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_missing(}{it:num}{cmd:)} specifies that
missing values be written as the {cmd:real scalar} {it:num}.

{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_missing(}{it:val}{cmd:)} specifies that
missing values be written as the {cmd:string scalar} {it:val}.

{p 4 4 2}
Let's look at an example.

		{cmd}my_mat = J(1,3,.)

		b.load_book("results")
		b.set_sheet("Budget 2012")

		b.set_missing(-99)
		b.put_number(1, 1, my_mat)
		b.set_missing("no data")
		b.put_number(2, 1, my_mat)
		b.set_missing()
		b.put_number(3, 1, my_mat){txt}

{p 4 4 2}
This code would write the numeric value {cmd:-99} in cells {cmd:A1} through
{cmd:C1} and {cmd:"no data"} in cells  {cmd:A2} through {cmd:C2}; cells
{cmd:A3} through {cmd:C3} would be blank.


{marker syn_dates}{...}
    {title:Dealing with dates}

{p 4 4 2}
Say that cell {cmd:A1} contained the date value {cmd:1/1/1960}. If
you coded

		{cmd}mydate = b.get_number(1,1)
		mydate
		21916{txt}

{p 4 4 2}
the value displayed, {cmd:21916}, is the number of days since 31dec1899.
This is how Excel stores its dates.  If we
used the optional {cmd:get_number()} argument {cmd:"asdate"} or
{cmd:"asdatetime"}, {cmd:mydate} would contain {cmd:0} because the date
{cmd:1/1/1960} is {cmd:0} for both {it:{help mf_date##td:td}} and
{it:{help mf_date##tc:tc}} dates.  To store {cmd:1/1/1960} in Mata, code

		{cmd}mysdate = b.get_string(1,1)
		mysdate
		1/1/1960{txt}

{p 4 4 2}
To write dates to Excel, you must tell the {cmd:xl()} class how to convert the
date to Excel's date or datetime format.  To write the date
{cmd:1/1/1960 12:00:00} to Excel, code

		{cmd}b.put_number(1,1,0, "asdatetime"){txt}

{p 4 4 2}
To write the dates {cmd:1/1/1960}, {cmd:1/2/1960}, and {cmd:1/3/1960} to Excel
column {cmd:A}, rows {cmd:1} through {cmd:3}, code

		{cmd}date_vals = (0\1\2)
		b.put_number(1, 1, date_vals, "asdate"){txt}

{p 4 4 2}
{cmd:"asdate"} and {cmd:"asdatetime"} apply an Excel date format to the
transformed date value when written.  Use {cmd:"asdatenum"} or
{cmd:"asdatetimenum"} to write the transformed Excel date number and preserve
the cell's format.

{pstd}
Note: Excel has two different date systems; see 
{it:{help import_excel##technote2:Technical note: Dates and times}} in
{cmd:import excel}.


{marker syn_format_funcs}{...}
    {title:Formatting functions}

{p 4 4 2}
The following member functions of the {cmd:xl()} class are used to format
cells of the active worksheet.  Both {it:row} and {it:col} can be a {cmd:real}
{cmd:scalar} or a 1x2 {cmd:real} {cmd:vector}.  The first value in the vectors
must be the starting (upper-left) cell in the Excel worksheet to which you
want to format.  The second value must be the ending (lower-right) cell in the
Excel worksheet to which you want to format.


{marker syn_format_numeric}{...}
    {title:Numeric formatting}

{marker set_number_format}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_number_format(}{it:row}{cmd:,}
     {it:col}{cmd:,} {cmd:"}{help mf_xl##nformat:{it:format}}{cmd:"}{cmd:)}
     sets the numeric format for each Excel cell in the Excel cell range
     specified in {it:row} and {it:col}.


{marker syn_format_align}{...}
    {title:Text alignment}

{marker set_vertical_align}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_vertical_align(}{it:row}{cmd:,}
     {it:col}{cmd:,} {cmd:"}{it:align}{cmd:"}{cmd:)}
     sets the text to vertical alignment for each Excel cell in the Excel cell
     range specified in {it:row} and {it:col}.
     {it:align} may be {cmd:"top"}, {cmd:"center"}, {cmd:"bottom"},
     {cmd:"justify"}, or {cmd:"distributed"}.

{marker set_horizontal_align}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_horizontal_align(}{it:row}{cmd:,}
     {it:col}{cmd:,} {cmd:"}{it:align}{cmd:"}{cmd:)}
     sets the text to horizontal alignment for each Excel cell in the Excel cell
     range specified in {it:row} and {it:col}.
     {it:align} can be {cmd:"left"}, {cmd:"center"}, {cmd:"right"},
     {cmd:"fill"}, {cmd:"justify"}, {cmd:"merge"}, or {cmd:"distributed"}.


{marker syn_format_border}{...}
    {title:Cell borders}

{marker set_border}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_border(}{it:row}{cmd:,}
     {it:col}{cmd:,} {cmd:"}{help mf_xl##style:{it:style}}{cmd:"}[{cmd:,} 
     {cmd:"}{help mf_xl##syn_format_colors:{it:color}}{cmd:"}]{cmd:)}
     sets the top, left, right, and bottom border style and color for each
     Excel cell in the Excel cell range specified in {it:row} and {it:col}.

{marker set_left_border}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_left_border(}{it:row}{cmd:,}
     {it:col}{cmd:,} {cmd:"}{help mf_xl##style:{it:style}}{cmd:"}[{cmd:,} 
     {cmd:"}{help mf_xl##syn_format_colors:{it:color}}{cmd:"}]{cmd:)}
     sets the left border style and color for each Excel cell in the Excel 
     cell range specified in {it:row} and {it:col}.

{marker set_right_border}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_right_border(}{it:row}{cmd:,}
     {it:col}{cmd:,} {cmd:"}{help mf_xl##style:{it:style}}{cmd:"}[{cmd:,} 
     {cmd:"}{help mf_xl##syn_format_colors:{it:color}}{cmd:"}]{cmd:)}
     sets the right border style and color for each Excel cell in the Excel 
     cell range specified in {it:row} and {it:col}.

{marker set_top_border}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_top_border(}{it:row}{cmd:,}
     {it:col}{cmd:,} {cmd:"}{help mf_xl##style:{it:style}}{cmd:"}[{cmd:,} 
     {cmd:"}{help mf_xl##syn_format_colors:{it:color}}{cmd:"}]{cmd:)}
     sets the top border style and color for each Excel cell in the Excel 
     cell range specified in {it:row} and {it:col}.

{marker set_bottom_border}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_bottom_border(}{it:row}{cmd:,}
     {it:col}{cmd:,} {cmd:"}{help mf_xl##style:{it:style}}{cmd:"}[{cmd:,} 
     {cmd:"}{help mf_xl##syn_format_colors:{it:color}}{cmd:"}]{cmd:)}
     sets the bottom border style and color for each Excel cell in the Excel 
     cell range specified in {it:row} and {it:col}.

{marker set_diagonal_border}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_diagonal_border(}{it:row}{cmd:,}
     {it:col}{cmd:,} {cmd:"}{it:direction}{cmd:"}{cmd:,}
     {cmd:"}{help mf_xl##style:{it:style}}{cmd:"}{cmd:,} [{cmd:,} 
     {cmd:"}{help mf_xl##syn_format_colors:{it:color}}{cmd:"}]{cmd:)}
     sets the diagonal border direction, style, and color for each Excel cell
     in the Excel cell range specified in {it:row} and {it:col}.
     {it:direction} may be {cmd:"none"}, {cmd:"down"}, {cmd:"up"}, or
     {cmd:"both"}.

{marker set_fill_pattern}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_fill_pattern(}{it:row}{cmd:,}
     {it:col}{cmd:,} {cmd:"}{help mf_xl##pattern:{it:pattern}}{cmd:"}{cmd:,}
     {cmd:"}{help mf_xl##fgcolor:{it:fgcolor}}{cmd:"} [{cmd:,}
     {cmd:"}{help mf_xl##bgcolor:{it:bgcolor}}{cmd:"}]{cmd:)}
     sets the fill color for each Excel cell in the Excel 
     cell range specified in {it:row} and {it:col}.

{marker set_column_width}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_column_width(}{it:col1}{cmd:,}
     {it:col2}{cmd:,} {it:width}{cmd:)}
     sets the column width for each Excel cell in the Excel cell
     column range specified in {it:col1} through {it:col2}.  Column width is
     measured as the number of characters (0-255) rendered in Excel's
     default style's font.

{marker set_row_height}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_row_height(}{it:row1}{cmd:,}
     {it:row2}{cmd:,} {it:height}{cmd:)}
     sets the row height for each Excel cell in the Excel cell
     row range specified in {it:row1} through {it:row2}. {it:height} is
     measured in point size.


{marker syn_format_fonts}{...}
    {title:Fonts}

{p 4 4 2}
The following member functions of the {cmd:xl()} class are used to format text
of a given cell in the active worksheet.  Both {it:row} and {it:col} can be a
{cmd:real} {cmd:scalar} or a 1x2 {cmd:real} {cmd:vector}.  The first value in
the vectors must be the starting (upper-left) cell in the Excel worksheet 
that you want to format.  The second value must be the ending (lower-right)
cell in the Excel worksheet that you want to format.

{marker set_font}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_font(}{it:row}{cmd:,}
     {it:col}{cmd:,} {cmd:"}{it:fontname}{cmd:"}{cmd:,} {it:size}
     [{cmd:,} {cmd:"}{help mf_xl##syn_format_colors:{it:color}}{cmd:"}]{cmd:)}
     sets the font, font size, and font color for each Excel cell in the Excel 
     cell range specified in {it:row} and {it:col}.

{marker set_font_bold}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_font_bold(}{it:row}{cmd:,}
     {it:col}{cmd:,} {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)}
     bolds or unbolds text for each Excel cell in the Excel 
     cell range specified in {it:row} and {it:col}.

{marker set_font_italic}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_font_italic(}{it:row}{cmd:,}
     {it:col}{cmd:,} {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)}
     italicizes or unitalicizes text for each Excel cell in the Excel 
     cell range specified in {it:row} and {it:col}.

{marker set_font_strikeout}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_font_strikeout(}{it:row}{cmd:,}
     {it:col}{cmd:,} {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)}
     strikesout or unstrikesout text for each Excel cell in the Excel 
     cell range specified in {it:row} and {it:col}.

{marker set_font_underline}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_font_underline(}{it:row}{cmd:,}
     {it:col}{cmd:,} {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)}
     underlines or ununderlines text for each Excel cell in the Excel 
     cell range specified in {it:row} and {it:col}.

{marker set_font_script}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_font_script(}{it:row}{cmd:,}
     {it:col}{cmd:,} {c -(}{cmd:"sub"}|{cmd:"super"}|{cmd:"normal"}{c )-}{cmd:)}
     sets the script type for each Excel cell in the Excel
     cell range specified in {it:row} and {it:col}.


{marker syn_format_other}{...}
    {title:Other}

{p 4 4 2}
The following member functions of the {cmd:xl()} class control other various
cell formatting for a given cell in the active worksheet.  Both {it:row} and
{it:col} can be a {cmd:real} {cmd:scalar} or a 1x2 {cmd:real} {cmd:vector}.
The first value in the vectors must be the starting (upper-left) cell in the
Excel worksheet to which you want to format.  The second value must be the
ending (lower-right) cell in the Excel worksheet to which you want to format.

{marker set_text_wrap}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_text_wrap(}{it:row}{cmd:,}
     {it:col}{cmd:,} {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)}
     sets whether text is wrapped for each Excel cell in the Excel 
     cell range specified in {it:row} and {it:col}.

{marker set_shrink_to_fit}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_shrink_to_fit(}{it:row}{cmd:,}
     {it:col}{cmd:,} {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)}
     sets whether text is shrunk-to-fit the cell width for each Excel cell in
     the Excel cell range specified in {it:row} and {it:col}.

{marker set_text_rotate}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_text_rotate(}{it:row}{cmd:,}
     {it:col}{cmd:,} {help mf_xl##rotation:{it:rotation}}{cmd:)}
     sets the text rotation for each Excel cell in the Excel cell range
     specified in {it:row} and {it:col}.

{marker set_text_indent}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_text_indent(}{it:row}{cmd:,}
     {it:col}{cmd:,} {it:indent}{cmd:)}
     sets the text indention for each Excel cell in the Excel cell range
     specified in {it:row} and {it:col}.  {it:indent} must be an integer less
     than or equal to 15.

{marker set_format_lock}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_format_lock(}{it:row}{cmd:,}
     {it:col}{cmd:,} {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)}
     sets the locked protection property for each Excel cell in the Excel 
     cell range specified in {it:row} and {it:col}.

{marker set_format_hidden}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_format_hidden(}{it:row}{cmd:,}
     {it:col}{cmd:,} {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)}
     sets the hidden protection property for each Excel cell in the Excel 
     cell range specified in {it:row} and {it:col}.


{marker syn_format_examples}{...}
    {title:Formatting examples}

{p 4 4 2}
To change a cell's numeric format so that a number has commas and two decimal
points and places all negative numbers in braces ({cmd:number_sep_d2_negbra})
for rows {cmd:2} through {cmd:7} and columns {cmd:2} through {cmd:4} for a
worksheet, code

		{cmd}real rowvector rows, cols

		b = xl()
		...
		rows = (2,7)
		cols = (2,4)
		b.set_number_format(rows, cols, "number_sep_d2_negbra"){txt}

{p 4 4 2}
To add a medium-thick border to all cell sides for the same cell range, code

		{cmd}b.set_border(rows, cols, "medium"){txt}

{p 4 4 2}
To change the font and font color for rows {cmd:1} through {cmd:7}, column
{cmd:1}, code 

		{cmd}rows = (1,7)
		b.set_font(rows, 1, "Arial", 12, "white"){txt}

{p 4 4 2}
and to change the background fill color of the same cells, code
		
		{cmd}b.set_fill_pattern(rows, 1, "solid", "white", "lightblue"){txt}

{p 4 4 2}
To bold the text in cell B1 through C3, code 

		{cmd}rows = (1,3)
		cols = (2,3)
		b.set_font_bold(rows, cols, "on"){txt}


{marker syn_range}{...}
    {title:Range formatting functions}

{pstd}
By default, the {cmd:xl()} class creates a new format ID for each font
and cell format change you make in a workbook using the standard {cmd:xl()}
class formatting functions.  Depending on how many format changes you make to a
workbook, the number of format IDs can cause the Excel workbook to
become so large that it will open slowly in Excel.  To prevent this,
you can create a format ID with specific font and format settings and
apply that format ID across a cell range.  Once a format ID has
been attached to a cell range, any changes to the format ID are
automatically applied to the cells.

{pstd}
Font formatting also has its own ID system, but you must attach a font
ID to a format ID for the font ID to apply to the cell
range.  You can use one font ID with multiple format IDs.  There
is a limit of 512 font IDs per workbook.


{marker syn_range_addfmtid}{...}
    {title:Adding format IDs}

{marker add_fmtid}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.add_fmtid()}
     returns a new format ID and adds it to the current workbook.


{marker syn_range_setfmtid}{...}
    {title:Setting formats by ID}

{marker set_fmtid}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_fmtid(}{it:row}{cmd:,} {it:col}{cmd:,} {it:fmtid}{cmd:)}
	sets the format ID for each cell in the Excel cell range 
        specified in {it:row} and {it:col}.


{marker syn_range_cellfmt}{...}
    {title:Cell formatting functions}

{pstd}
The cell formatting functions below are used when formatting cells using a
format ID.

{marker fmtid_set_number_format}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_number_format(}{it:fmtid}{cmd:,}
	{cmd:"}{help mf_xl##nformat:{it:format}}{cmd:")}
    sets the numeric format for the specified format ID.

{marker fmtid_set_vertical_align}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_vertical_align(}{it:fmtid}{cmd:,}
        {cmd:"}{it:align}{cmd:")}
	sets the vertical alignment of the text for the specified format ID.
        {it:align} may be {cmd:"top"}, {cmd:"center"}, {cmd:"bottom"},
        {cmd:"justify"}, or {cmd:"distributed"}.

{marker fmtid_set_horizontal_align}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_horizontal_align(}{it:fmtid}{cmd:,}
        {cmd:"}{it:align}{cmd:")}
	sets the horizontal alignment of the text for the specified format ID.
        {it:align} may be {cmd:"left"}, {cmd:"center"}, {cmd:"right"},
         {cmd:"fill"}, {cmd:"justify"}, {cmd:"merge"}, or
	 {cmd:"distributed"}.

{marker fmtid_set_border}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_border(}{it:fmtid}{cmd:,}
	{cmd:"}{help mf_xl##style:{it:style}}{cmd:"} [{cmd:,}
	{cmd:"}{help mf_xl##syn_format_colors:{it:color}}{cmd:"}]{cmd:)}
	sets the top, left, right, and bottom border style and color 
	for the specified format ID.

{marker fmtid_set_left_border}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_left_border(}{it:fmtid}{cmd:,}
       {cmd:"}{help mf_xl##style:{it:style}}{cmd:"} [{cmd:,}
       {cmd:"}{help mf_xl##syn_format_colors:{it:color}}{cmd:"}]{cmd:)}
	sets the left border style and color for the specified format ID.

{marker fmtid_set_right_border}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_right_border(}{it:fmtid}{cmd:,}
       {cmd:"}{help mf_xl##style:{it:style}}{cmd:"} [{cmd:,}
       {cmd:"}{help mf_xl##syn_format_colors:{it:color}}{cmd:"}]{cmd:)}
	sets the right border style and color for the specified format ID.

{marker fmtid_set_top_border}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_top_border(}{it:fmtid}{cmd:,}
       {cmd:"}{help mf_xl##style:{it:style}}{cmd:"} [{cmd:,} 
       {cmd:"}{help mf_xl##syn_format_colors:{it:color}}{cmd:"}]{cmd:)}
	sets the top border style and color for the specified format ID.

{marker fmtid_set_bottom_border}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_bottom_border(}{it:fmtid}{cmd:,}
       {cmd:"}{help mf_xl##style:{it:style}}{cmd:"} [{cmd:,}
       {cmd:"}{help mf_xl##syn_format_colors:{it:color}}{cmd:"}]{cmd:)}
	sets the bottom border style and color for the specified format ID.

{marker fmtid_set_diagonal_border}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_diagonal_border(}{it:fmtid}{cmd:,}
       {cmd:"}{it:direction}{cmd:",}
       {cmd:"}{help mf_xl##style:{it:style}}{cmd:"} [{cmd:,}
       {cmd:"}{help mf_xl##syn_format_colors:{it:color}}{cmd:"}]{cmd:)}
        sets the diagonal border direction, style, and color for the 
        specified format ID.  {it:direction} may be {cmd:"none"}, 
        {cmd:"down"}, {cmd:"up"}, or {cmd:"both"}.

{marker fmtid_set_fill_pattern}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_fill_pattern(}{it:fmtid}{cmd:,}
	{cmd:"}{help mf_xl##pattern:{it:pattern}}{cmd:",}
	{cmd:"}{help mf_xl##fgcolor:{it:fgcolor}}{cmd:"} [{cmd:,}
	{cmd:"}{help mf_xl##bgcolor:{it:bgcolor}}{cmd:"}]{cmd:)}
	sets the fill color for the specified format ID.

{marker fmtid_set_column_width}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_column_width(}{it:fmtid}{cmd:,}
        {it:col1}{cmd:,} {it:col2}{cmd:,} {it:width}{cmd:)}
	sets the column width for the specified format ID in the Excel 
        column range specified in {it:col1} through {it:col2}.  Column 
        width is measured as the number of characters (0-255) rendered in 
        Excel's default style's font.

{marker fmtid_set_row_height}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_row_height(}{it:fmtid}{cmd:,}
        {it:row1}{cmd:,} {it:row2}{cmd:,} {it:height}{cmd:)}
	sets the row height for the specified format ID in the Excel row range
	specified in {it:row1} through {it:row2}.  {it:height} is measured in
	point size.

{marker fmtid_set_text_wrap}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_text_wrap(}{it:fmtid}{cmd:,}
       {c -(}{cmd:"on"}{c |}{cmd:"off"}{c )-}{cmd:)}
	sets whether text is wrapped for the specified format ID.

{marker fmtid_set_shrink_to_fit}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_shrink_to_fit(}{it:fmtid}{cmd:,}
        {c -(}{cmd:"on"}{c |}{cmd:"off"}{c )-}{cmd:)}
	sets whether text is shrunk to fit the cell width  for the specified 
        format ID.

{marker fmtid_set_text_rotate}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_text_rotate(}{it:fmtid}{cmd:,}
        {help mf_xl##rotation:{it:rotation}}{cmd:)}
	sets the text rotation for the specified format ID.

{marker fmtid_set_text_indent}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_text_indent(}{it:fmtid}{cmd:,}
        {it:indent}{cmd:)}
	sets the text indention for the specified format ID. 
        {it:indent} must be an integer less than or equal to 15.

{marker fmtid_set_format_lock}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_format_lock(}{it:fmtid}{cmd:,}
        {c -(}{cmd:"on"}{c |}{cmd:"off"}{c )-}{cmd:)}
	sets the locked protection property for the specified format ID.

{marker fmtid_set_format_hidden}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_format_hidden(}{it:fmtid}{cmd:,}
        {c -(}{cmd:"on"}{c |}{cmd:"off"}{c )-}{cmd:)}
	sets the hidden protection property for the specified format ID.


{marker syn_range_addfontid}{...}
    {title:Adding font IDs}

{marker add_fontid}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.add_fontid()}
	returns a new font ID and adds it to the current workbook.


{marker syn_range_setfontid}{...}
    {title:Setting font IDs for format IDs}

{marker fmtid_set_fontid}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fmtid_set_fontid(}{it:fmtid}{cmd:,}
        {it:fontid}{cmd:)}
	sets the font ID for the specified format ID.

{marker syn_range_fontfmt}{...}
    {title:Font formatting functions}

{pstd}
The font formatting functions below are used when formatting fonts using a
font ID.

{marker fontid_set_font}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fontid_set_font(}{it:fontid}{cmd:,}
       {cmd:"}{it:fontname}{cmd:",} {it:size} [{cmd:,}
       {cmd:"}{help mf_xl##syn_format_colors:{it:color}}{cmd:"}]{cmd:)}
	sets the font, font size, and font color for the specified font ID.

{marker fontid_set_font_bold}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fontid_set_font_bold(}{it:fontid}{cmd:,}
        {c -(}{cmd:"on"}{c |}{cmd:"off"}{c )-}{cmd:)}
	bolds or unbolds text for the specified font ID.

{marker fontid_set_font_italic}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fontid_set_font_italic(}{it:fontid}{cmd:,}
        {c -(}{cmd:"on"}{c |}{cmd:"off"}{c )-}{cmd:)}
	italicizes or unitalicizes text for the specified font ID.

{marker fontid_set_font_strikeout}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fontid_set_font_strikeout(}{it:fontid}{cmd:,}
        {c -(}{cmd:"on"}{c |}{cmd:"off"}{c )-}{cmd:)}
	strikesout or unstrikesout text for the specified font ID.

{marker fontid_set_font_underline}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fontid_set_font_underline(}{it:fontid}{cmd:,}
        {c -(}{cmd:"on"}{c |}{cmd:"off"}{c )-}{cmd:)}
	underlines or ununderlines text for the specified font ID.

{marker fontid_set_font_script}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.fontid_set_font_script(}{it:fontid}{cmd:,}
        {c -(}{cmd:"sub"}{c |}{cmd:"super"}{c |}{cmd:"normal"}{c )-}{cmd:)}
	sets the script type for the specified font ID.


{marker syn_range_formatex}{...}
    {title:Range formatting examples}

{pstd}
To create a format ID with a numeric format that places all negative numbers in
braces, uses commas for thousands separators, and
specifies two digits after the decimal, ({cmd:number_sep_d2_negbra}), code 

                {cmd}b = xl()
                ...
                fmt_id1 = b.add_fmtid()
                b.fmtid_set_number_format(fmt_id1, "number_sep_d2_negbra"){txt}

{pstd}
To also change the format ID to have a medium-thick border for all cell sides,
code

                {cmd:b.fmtid_set_border(fmt_id1, "medium")}

{pstd}
To apply these format changes for rows {cmd:2} through {cmd:7} and
columns {cmd:2} through {cmd:4} for a worksheet, code

               {cmd}rows = (2,7)
               cols = (2,4)
               b.set_fmtid(rows, cols, fmt_id1){txt}

{pstd}
To create a font ID with an {cmd:Arial} font and a font color of {cmd:blue},
code

               {cmd}font_id1 = b.add_fontid()
               b.fontid_set_font(font_id1, "Arial", 12, "blue"){txt}

{pstd}
To apply these font changes to the format ID {cmd:fmt_id1}

               {cmd:b.fmtid_set_fontid(fmt_id1, font_id1)}

{pstd}
To create a new format ID that sets the background fill color to
{cmd:lightblue}, code

               {cmd}fmt_id2 = b.add_fmtid()
               b.fmtid_set_fill_pattern(fmt_id2, "solid", "white", "lightblue"){txt}

{pstd}
To apply these format changes to cell {cmd:A1} for a worksheet, code

               {cmd:b.set_fmtid(1, 1, fmt_id2)}

{pstd}
To also apply the  {cmd:font_id1} font changes to row {cmd:1} column 
{cmd:1}, type

               {cmd:b.fmtid_set_fontid(fmt_id2, font_id1)}

{pstd}
By adding the font settings in  {cmd:font_id1} to {cmd:fmt_id2}, the font
formatting is automatically applied to row {cmd:1} column {cmd:1}.  


{marker syn_util_funcs}{...}
    {title:Utility functions}

{p 4 4 2}
The following functions can be used whenever you have an instance of
the {cmd:xl()} class.

{marker query}{...}
{p 4 4 2}
{cmd:query()} returns information about an {cmd:xl()} class.
Here are the syntaxes for {cmd:query()}:

	{it:void} 			{it:{help mf_xl##def_B:B}}{cmd:.query(}{cmd:)}
	{it:string scalar}		{it:{help mf_xl##def_B:B}}{cmd:.query(}{cmd:"filename"}{cmd:)}
	{it:real scalar}		{it:{help mf_xl##def_B:B}}{cmd:.query(}{cmd:"mode"}{cmd:)}
	{it:real scalar}		{it:{help mf_xl##def_B:B}}{cmd:.query(}{cmd:"filetype"}{cmd:)}
	{it:string scalar}		{it:{help mf_xl##def_B:B}}{cmd:.query(}{cmd:"sheetname"}{cmd:)}
	{it:transmorphic scalar}	{it:{help mf_xl##def_B:B}}{cmd:.query(}{cmd:"missing"}{cmd:)}


{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.query(}{cmd:)}
	lists the current values and settings of the class.

{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.query(}{cmd:"filename"}{cmd:)}
	returns the filename of the current workbook.

{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.query(}{cmd:"mode"}{cmd:)}
	returns {cmd:0} if the workbook is always closed by member functions
        or returns {cmd:1} if the current workbook is open.

{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.query(}{cmd:"filetype"}{cmd:)}
	returns {cmd:0} if the workbook is of type {cmd:.xls} or returns
	{cmd:1} if the workbook is of type {cmd:.xlsx}.

{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.query(}{cmd:"sheetname"}{cmd:)}
	returns the active sheetname in a string scalar.

{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.query(}{cmd:"missing"}{cmd:)}
	returns {cmd:J(1,0,.)} (if set to {cmd:blanks}), a {cmd:string scalar},
        or a {cmd:real scalar} depending on what was set with
        {helpb mf_xl##set_missing:set_missing()}.

{p 4 4 2}
When working with different Excel file types, you need to know the type of
Excel file you are using because the two file types have different column and
row limits.  You can use {cmd:xl.query("filetype")} to obtain that information.

	{cmd}...
	if (xl.query("filetype")) {
		...
	}
	else {
		...
	}{txt}

{marker get_colnum}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.get_colnum()} returns a vector of
    column numbers based on the Excel column labels in the string vector
    argument.

{p 4 4 2}
To get the column number for Excel columns {cmd:AA} and {cmd:AD}, code

	: {cmd:mycol = ("AA","AD")}
	: {cmd:col = b.get_colnum(mycol)}
	: {cmd:col}
	{txt}       {txt} 1    2
	    {c TLC}{hline 11}{c TRC}
	  1 {c |}  {res}27   30{txt}  {c |}
	    {c BLC}{hline 11}{c BRC}

{marker get_colletter}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.get_colletter()}
    returns a vector of column letters based on the column numbers in 
    the real vector argument.

{pstd}
To get the column letter for Excel columns {cmd:1} and {cmd:29}, code

	: {cmd:mycol = (1, 29)}
	: {cmd:col = b.get_colletter(mycol)}
	: {cmd:col}
	{txt}       {txt} 1    2
	    {c TLC}{hline 11}{c TRC}
	  1 {c |}  {res} A   AC{txt}  {c |}
	    {c BLC}{hline 11}{c BRC}

{p 4 4 2}
The following function is used for cell formats and styles.

{marker set_keep_cell_format}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_keep_cell_format(}{cmd:"on"}|{cmd:"off"}{cmd:)}
     sets whether the {cmd:put_number()} class member function preserves a
     cell's style and format when writing a value.  By default, preserving a 
     cell's style and format is {cmd:off}.

{p 4 4 2}
The following functions are used for error handling with an instance of class
{cmd:xl}.

{marker set_error_mode}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.set_error_mode(}{cmd:"on"}|{cmd:"off"}{cmd:)}
     sets whether {cmd:xl()} class member functions issue errors.
     By default, errors are turned {cmd:on}.

{marker get_last_error}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.get_last_error(}{cmd:)}
     returns the last error code issued by the {cmd:xl()} class if
     {cmd:set_error_mode()} is set {cmd:off}.

{marker get_last_error_message}{...}
{p 8 12 2}
{it:{help mf_xl##def_B:B}}{cmd:.get_last_error_message(}{cmd:)}
     returns the last error message issued by the {cmd:xl()} class if
     {cmd:set_error_mode()} is set {cmd:off}.


{marker syn_util_error}{...}
    {title:Handling errors}

{p 4 4 2}
Turning errors off for an instance of the {cmd:xl()} class is useful when
using the class in an {help m1_ado:ado-file}.  You should issue a Stata error
code in the ado-file instead of a Mata error code.  For example, in Mata, when
trying to load a file that does not exist within an instance, you will receive
the error code {cmd:r(16103)}:

	{cmd:: b = xl()}
	{cmd:: b.load_book("zzz")}
	file zzz.xls could not be loaded
	r(16103);

{p 4 4 2}
The correct Stata error code for this type of error is {cmd:603}, not
{cmd:16103}.  To issue the correct error, code

	{cmd}b = xl()
	b.set_error_mode("off")
	b.load_book("zzz")
	if (b.get_last_error()==16103) {
		error(603)
	}{txt}

{p 4 4 2}
You should also turn off errors if you
{helpb mf_xl##set_mode:set_mode("open")} because you need to close your Excel
file before exiting your ado-file.  You should code

	{cmd}b = xl()
	b.set_mode("open")
	b.set_error_mode("off")
	b.load_book("zzz")
	...
	b.put_string(1,300, "test")
	if (b.get_last_error()==16116) {
		b.close_book()
		error(603)
	}{txt}

{p 4 4 2}
If {cmd:set_mode("closed")} is used, you do not have to worry about closing the
Excel file because it is done automatically.


{marker syn_error_codes}{...}
    {title:Error codes}

{p 4 4 2}
The error codes specific to the {cmd:xl()} class are the following:

	 Code    Meaning
	{hline 67}
	 16101    file not found
	 16102    file already exists
	 16103    file could not be opened
	 16104    file could not be closed
	 16105    file is too big
	 16106    file could not be saved
	 16111    worksheet not found
	 16112    worksheet already exists
	 16113    could not clear worksheet
	 16114    could not add worksheet
	 16115    could not read from worksheet 
	 16116    could not write to worksheet
	 16121    invalid syntax
	 16122    invalid range
         16130    could not read cell format
         16131    could not write cell format
         16132    invalid column format
         16133    invalid column width
         16134    invalid row format
         16135    invalid row height
         16136    invalid color
         16140    invalid number format
         16141    invalid alignment format
         16142    invalid border style format
         16143    invalid border direction format
         16144    invalid fill pattern style format
         16145    invalid font format
         16146    invalid font size format
         16147    invalid font name format
         16148    invalid cell format
	{hline 67}


{marker appendix}{...}
{title:Appendix}

{marker nformat}{...}
    {title:Codes for numeric formats}

	     {it:format}                      Example
 	     {hline 35}
	     {cmd:number}                         1000
	     {cmd:number_d2}                   1000.00
	     {cmd:number_sep}                  100,000
	     {cmd:number_sep_d2}            100,000.00
	     {cmd:number_sep_negbra}           (1,000)
	     {cmd:number_sep_negbrared}        {err:(1,000)}
	     {cmd:number_d2_sep_negbra}     (1,000.00)
	     {cmd:number_d2_sep_negbrared}  {err:(1,000.00)}
	     {cmd:currency_negbra}             ($4000)
	     {cmd:currency_negbrared}          {err:($4000)}
	     {cmd:currency_d2_negbra}       ($4000.00)
	     {cmd:currency_d2_negbrared}    {err:($4000.00)}
	     {cmd:account}                       5,000
	     {cmd:accountcur}              $     5,000
	     {cmd:account_d2}                 5,000.00
	     {cmd:account_d2_cur}          $  5,000.00
	     {cmd:percent}                         75%
	     {cmd:percent_d2}                   75.00%
	     {cmd:scientific_d2}              10.00E+1
	     {cmd:fraction_onedig}              10 1/2
	     {cmd:fraction_twodig}            10 23/95
	     {cmd:date}                      3/18/2007
	     {cmd:date_d_mon_yy}             18-Mar-07
	     {cmd:date_d_mon}                   18-Mar
	     {cmd:date_mon_yy}                  Mar-07
	     {cmd:time_hmm_AM}                 8:30 AM
	     {cmd:time_HMMSS_AM}            8:30:00 AM
	     {cmd:time_HMM}                       8:30
	     {cmd:time_HMMSS}                  8:30:00
	     {cmd:time_MMSS}                     30:55
	     {cmd:time_H0MMSS}                20:30:55
	     {cmd:time_MMSS0}                  30:55.0
	     {cmd:date_time}            3/18/2007 8:30
	     {cmd:text}                   this is text
 	     {hline 35}


{marker syn_format_custom}{...}
    {title:Custom formatting}

{p 4 4 2}
{it:format} also can be a custom code string formed by sections. Up to four
sections of format codes can be specified. The format codes, separated by
semicolons, define the formats for positive numbers, negative numbers, zero
values, and text, in that order. If only two sections are specified, the first
is used for positive numbers and zeros, and the second is used for negative
numbers. If only one section is specified, it is used for all numbers.  The
following is a four section example:

{phang2}
{cmd:#,###.00_);[Red](#,###.00);0.00;"sales "@}

{p 4 4 2}
The following table describes the different symbols that are available for use
in custom number formats:

                                                   Cell      Fmt      Cell
     Symbol        Description                    value     code  displays
     {hline 70}
     {cmd:0}             Digit placeholder (add zeros)    8.9     {cmd:#.00}      8.90
     {cmd:#}             Digit placeholder (no zeros)     8.9     {cmd:#.##}       8.9
     {cmd:?}             Digit placeholder (add space)    8.9     {cmd:0.0?}      8.9 
     {cmd:.}             Decimal point
     {cmd:%}             Percentage                        .1        {cmd:%}       10%
     {cmd:,}             Thousands separator
     {cmd:E- E+ e- e+}   Scientific format           12200000  {cmd:0.00E+00} 1.22E+07
     {cmd:$-+/():space}  Display the symbol                12     {cmd:(000)}    (012)
     {cmd:\}             Escape character                   3       {cmd:0\!}       3!
     {cmd:*}             Repeat character                   3        {cmd:3*}   3xxxxx
                     (fill in cell width)                           
     {cmd:_}             Skip width of next character    -1.2      {cmd:_0.0}      1.2
     {cmd:"text"}        Display text in quotes          1.23  {cmd:0.00 "a"}   1.23 a
     {cmd:@}             Text placeholder                    b   {cmd:"a"@"c"}      abc
     {hline 70}

{p 4 4 2}
The following table describes the different codes that are available for
custom datetime formats:

     Fmt                          Cell
     code          Description    displays
     {hline 46}
     {cmd:m}             Months         1-12
     {cmd:mm}            Months         01-12
     {cmd:mmm}           Months         Jan-Dec        
     {cmd:mmmm}          Months         January-December       
     {cmd:mmmmm}         Months         J-D   
     {cmd:d}             Days           1-31
     {cmd:dd}            Days           01-31
     {cmd:ddd}           Days           Sun-Sat
     {cmd:dddd}          Days           Sunday-Saturday
     {cmd:yy}            Years          00-99
     {cmd:yyyy}          Years          1909-9999
     {cmd:h}             Hours          0-23
     {cmd:hh}            Hours          00-23
     {cmd:m}             Minutes        0-59
     {cmd:mm}            Minutes        00-59
     {cmd:s}             Seconds        0-59
     {cmd:ss}            Seconds        00-59
     {cmd:h AM/PM}       Time           5 AM
     {cmd:h:mm AM/PM}    Time           5:36 PM
     {cmd:h:mm:ss A/P}   Time           5:36:03 P
     {cmd:h:mm:ss.00}    Time           5:34:03.75
     [{cmd:h}]{cmd::mm}        Elapsed time   1:22
     [{cmd:mm}]{cmd::ss}       Elapsed time   64:16
     [{cmd:ss}]{cmd:.00}       Elapsed time   3733.71
     {hline 46}


{marker syn_format_text_color}{...}
    {title:Custom formatting: Text color}

{p 4 4 2}
To set the text color for a section of the format, type the name of one of the
colors listed in the table under
{help mf_xl##syn_format_colors:{it:Format colors}}
in square brackets in the section.  The color must be the first item in the
section.


{marker syn_format_cond}{...}
    {title:Custom formatting: Conditional formatting}

{p 4 4 2}
To set number formats that will be applied only if a number meets a specified
condition, enclose the condition in square brackets. The condition consists of
a comparison operator and a value. Comparison operators include the following:

	 Code          Description             
	 {hline 40}
	 {cmd:=}             Equal to                 
	 {cmd:>}             Greater than
	 {cmd:<}             Less than
	 {cmd:>=}            Greater than or equal to
	 {cmd:<=}            Less than or equal to
	 {cmd:<>}            Not equal to
	 {hline 40}

{p 4 4 2}
For example, the following format displays numbers that are less than or equal
to 100 in a red font and numbers that are greater than 100 in a blue font: 

	[Red][<=100];[Blue][>100]

{p 4 4 2}
If the cell value does not meet any of the criteria, then pound signs
({cmd:#}) are displayed across the width of the cell. 

{marker style}{...}
    {title:Codes for border styles}

	     {it:style}
	     {hline 22} 
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
 	     {hline 22}


{marker pattern}{...}
    {title:Codes for fill pattern styles}

	     {it:pattern}
	     {hline 25} 
	     {cmd:none}
	     {cmd:solid}
	     {cmd:gray50}
	     {cmd:gray75}
	     {cmd:gray25}
	     {cmd:horstripe}
	     {cmd:verstripe}
	     {cmd:revdiagstripe}
	     {cmd:diagstripe}
	     {cmd:diagcrosshatch}
	     {cmd:thickdiagcrosshatch}
	     {cmd:thinhorstripe}
	     {cmd:thinverstripe}
	     {cmd:thinrevdiagstripe}
	     {cmd:thindiagstripe}
	     {cmd:thinhorcrosshatch}
	     {cmd:thindiagcrosshatch}
	     {cmd:gray12p5}
	     {cmd:gray6p25}
	     {hline 25}


{marker rotation}{...}
    {title:Codes for text rotation}

  	      Rotation     Meaning 
    	      {hline 58} 
	      {cmd:0}-{cmd:90}         text rotated counterclockwise 0 to 90 degrees
	      {cmd:91}-{cmd:180}       text rotated clockwise 1 to 90 degrees
	      {cmd:255}          vertical text        
	      {hline 58}


{marker syn_format_colors}{...}
    {title:Format colors}

{p 4 4 2}
{it:color} may be any of the color names listed below or an RGB (red,
green, blue) value specified in double quotes ({cmd:"255 255 255"}).

	{it:color}
        {hline 25} 
	{cmd:aliceblue}
	{cmd:antiquewhite}
	{cmd:aqua}
	{cmd:aquamarine}
	{cmd:azure}
	{cmd:beige}
	{cmd:bisque}
	{cmd:black}
	{cmd:blanchedalmond}
	{cmd:blue}
	{cmd:blueviolet}
	{cmd:brown}
	{cmd:burlywood}
	{cmd:cadetblue}
	{cmd:chartreuse}
	{cmd:chocolate}
	{cmd:coral}
	{cmd:cornflowerblue}
	{cmd:cornsilk}
	{cmd:crimson}
	{cmd:cyan}
	{cmd:darkblue}
	{cmd:darkcyan}
	{cmd:darkgoldenrod}
	{cmd:darkgray}
	{cmd:darkgreen}
	{cmd:darkkhaki}
	{cmd:darkmagenta}
	{cmd:darkolivegreen}
	{cmd:darkorange}
	{cmd:darkorchid}
	{cmd:darkred}
	{cmd:darksalmon}
	{cmd:darkseagreen}
	{cmd:darkslateblue}
	{cmd:darkslategray}
	{cmd:darkturquoise}
	{cmd:darkviolet}
	{cmd:deeppink}
	{cmd:deepskyblue}
	{cmd:dimgray}
	{cmd:dodgerblue}
	{cmd:firebrick}
	{cmd:floralwhite}
	{cmd:forestgreen}
	{cmd:fuchsia}
	{cmd:gainsboro}
	{cmd:ghostwhite}
	{cmd:gold}
	{cmd:goldenrod}
	{cmd:gray}
	{cmd:green}
	{cmd:greenyellow}
	{cmd:honeydew}
	{cmd:hotpink}
	{cmd:indianred }
	{cmd:indigo }
	{cmd:ivory}
	{cmd:khaki}
	{cmd:lavender}
	{cmd:lavenderblush}
	{cmd:lawngreen}
	{cmd:lemonchiffon}
	{cmd:lightblue}
	{cmd:lightcoral}
	{cmd:lightcyan}
	{cmd:lightgoldenrodyellow}
	{cmd:lightgray}
	{cmd:lightgreen}
	{cmd:lightpink}
	{cmd:lightsalmon}
	{cmd:lightseagreen}
	{cmd:lightskyblue}
	{cmd:lightslategray}
	{cmd:lightsteelblue}
	{cmd:lightyellow}
	{cmd:lime}
	{cmd:limegreen}
	{cmd:linen}
	{cmd:magenta}
	{cmd:maroon}
	{cmd:mediumaquamarine}
	{cmd:mediumblue}
	{cmd:mediumorchid}
	{cmd:mediumpurple}
	{cmd:mediumseagreen}
	{cmd:mediumslateblue}
	{cmd:mediumspringgreen}
	{cmd:mediumturquoise}
	{cmd:mediumvioletred}
	{cmd:midnightblue}
	{cmd:mintcream}
	{cmd:mistyrose}
	{cmd:moccasin}
	{cmd:navajowhite}
	{cmd:navy}
	{cmd:oldlace}
	{cmd:olive}
	{cmd:olivedrab}
	{cmd:orange}
	{cmd:orangered}
	{cmd:orchid}
	{cmd:palegoldenrod}
	{cmd:palegreen}
	{cmd:paleturquoise}
	{cmd:palevioletred}
	{cmd:papayawhip}
	{cmd:peachpuff}
	{cmd:peru}
	{cmd:pink}
	{cmd:plum}
	{cmd:powderblue}
	{cmd:purple}
	{cmd:red}
	{cmd:rosybrown}
	{cmd:royalblue}
	{cmd:saddlebrown}
	{cmd:salmon}
	{cmd:sandybrown}
	{cmd:seagreen}
	{cmd:seashell}
	{cmd:sienna}
	{cmd:silver}
	{cmd:skyblue}
	{cmd:slateblue}
	{cmd:slategray}
	{cmd:snow}
	{cmd:springgreen}
	{cmd:steelblue}
	{cmd:tan}
	{cmd:teal}
	{cmd:thistle}
	{cmd:tomato}
	{cmd:turquoise}
	{cmd:violet}
	{cmd:wheat}
	{cmd:white}
	{cmd:whitesmoke}
	{cmd:yellow}
	{cmd:yellowgreen}
        {hline 25} 

{p 4 4 2}
Note: {cmd:.xls} files can only contain 56 unique colors.

{marker fgcolor}{...}
{pstd}
{it:fgcolor} may be any color name specified in
{help mf_xl##syn_format_colors:{it:color}} or an RGB (red,
green, blue) value specified in double quotes ({cmd:"255 255 255"}).

{marker bgcolor}{...}
{pstd}
{it:bgcolor} may be any color name specified in
{help mf_xl##syn_format_colors:{it:color}} or an RGB (red,
green, blue) value specified in double quotes ({cmd:"255 255 255"}).
{p_end}
