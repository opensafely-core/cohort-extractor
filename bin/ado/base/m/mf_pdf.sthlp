{smcl}
{* *! version 1.0.8  12jun2019}{...}
{vieweralsosee "[M-5] Pdf*()" "mansection M-5 Pdf*()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] _docx*()" "help mf docx"}{...}
{vieweralsosee "[M-5] xl()" "help mf xl"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4 io"}{...}
{vieweralsosee "[RPT] putdocx intro" "help putdocx intro"}{...}
{vieweralsosee "[RPT] putexcel" "help putexcel"}{...}
{vieweralsosee "[RPT] putpdf intro" "help putpdf intro"}{...}
{viewerjumpto "Syntax" "mf_pdf##syntax"}{...}
{viewerjumpto "Description" "mf_pdf##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_pdf##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_pdf##remarks"}{...}
{viewerjumpto "Examples" "mf_pdf##examples"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-5] Pdf*()} {hline 2}}Create a PDF file 
{p_end}
{p2col:}({mansection M-5 Pdf*():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 4 2}
The syntax diagrams describe a set of Mata classes for creating a PDF file.
For help with class programming in Mata, see {manhelp m2_class M-2:class}.

{p 4 4 2}
Syntax is presented under the following headings:

    {help mf_pdf##syn_document:PdfDocument}
    {help mf_pdf##syn_paragraph:PdfParagraph}
    {help mf_pdf##syn_text:PdfText}
    {help mf_pdf##syn_table:PdfTable}


{marker syn_document}{...}
    {title:PdfDocument}

{p 8 8 2}
The {helpb mf_pdf##remarks_document:PdfDocument} class is the foundation for 
creating a PDF file.  Using the {cmd:PdfDocument} class is mandatory, but
the remaining classes are not.

{p 8 25 2}
{help mf_pdf##des_document_new:{bf:PdfDocument()}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_document_save:{bf:save(}}{it:string scalar filename}{help mf_pdf##des_document_save:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_document_close:{bf:close()}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_document_pgsize:{bf:setPageSize(}}{it:string scalar sz}{help mf_pdf##des_document_pgsize:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_document_landscape:{bf:setLandscape(}}{it:real scalar landscape}{help mf_pdf##des_document_landscape:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_document_margins:{bf:setMargins(}}{it:real scalar left}{cmd:,}
{it:real scalar top}{cmd:,}
{it:real scalar right}{cmd:,}
{it:real scalar bottom}{help mf_pdf##des_document_margins:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_document_halign:{bf:setHAlignment(}}{it:string scalar a}{help mf_pdf##des_document_halign:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_document_linesp:{bf:setLineSpace(}}{it:real scalar sz}{help mf_pdf##des_document_linesp:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_document_bgcolor:{bf:setBgColor(}}{it:real scalar r}{cmd:,} 
{it:real scalar g}{cmd:,}
{it:real scalar b}{help mf_pdf##des_document_bgcolor:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_document_color:{bf:setColor(}}{it:real scalar r}{cmd:,} 
{it:real scalar g}{cmd:,} {it:real scalar b}{help mf_pdf##des_document_color:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_document_font:{bf:setFont(}}{it:string scalar fontname}[{cmd:,} 
{it:string scalar style}]{help mf_pdf##des_document_font:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_document_fontsize:{bf:setFontSize(}}{it:real scalar sz}{help mf_pdf##des_document_fontsize:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_document_image:{bf:addImage(}}{it:string scalar filename}[{cmd:,} 
{it:real scalar cx}{cmd:,} {it:real scalar cy}]{help mf_pdf##des_document_image:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_document_para:{bf:addParagraph(}}{it:class}
{helpb mf_pdf##remarks_paragraph:PdfParagraph}
{it:scalar p}{help mf_pdf##des_document_para:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_document_table:{bf:addTable(}}{it:class}
{helpb mf_pdf##remarks_table:PdfTable}
{it:scalar t}{help mf_pdf##des_document_table:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_document_page:{bf:addNewPage()}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_document_line:{bf:addLineBreak()}}


{marker syn_paragraph}{...}
    {title:PdfParagraph}

{p 8 8 2}
The {helpb mf_pdf##remarks_paragraph:PdfParagraph} class can be used to add 
a paragraph to a {helpb mf_pdf##remarks_document:PdfDocument} or 
{helpb mf_pdf##remarks_table:PdfTable}.

{p 8 25 2}
{help mf_pdf##des_paragraph_new:{bf:PdfParagraph()}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_str:{bf:addString(}}{it:string scalar s}{help mf_pdf##des_paragraph_str:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_text:{bf:addText(}}{it:class}
{helpb mf_pdf##remarks_text:PdfText}
{it:scalar t}{help mf_pdf##des_paragraph_text:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_lb:{bf:addLineBreak()}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_clear_content:{bf:clearContent()}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_findent:{bf:setFirstIndent(}}{it:real scalar sz}{help mf_pdf##des_paragraph_findent:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_leftindent:{bf:setLeftIndent(}}{it:real scalar sz}{help mf_pdf##des_paragraph_leftindent:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_rightindent:{bf:setRightIndent(}}{it:real scalar sz}{help mf_pdf##des_paragraph_rightindent:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_ts:{bf:setTopSpacing(}}{it:real scalar sz}{help mf_pdf##des_paragraph_ts:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_bs:{bf:setBottomSpacing(}}{it:real scalar sz}{help mf_pdf##des_paragraph_bs:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_bgcolor:{bf:setBgColor(}}{it:real scalar r}{cmd:,} 
{it:real scalar g}{cmd:,}
{it:real scalar b}{help mf_pdf##des_paragraph_bgcolor:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_color:{bf:setColor(}}{it:real scalar r}{cmd:,} 
{it:real scalar g}{cmd:,}
{it:real scalar b}{help mf_pdf##des_paragraph_color:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_font:{bf:setFont(}}{it:string scalar fontname}[{cmd:,} 
{it:string scalar style}]{help mf_pdf##des_paragraph_font:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_fontsize:{bf:setFontSize(}}{it:real scalar sz}{help mf_pdf##des_paragraph_fontsize:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_underline:{bf:setUnderline()}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_strike:{bf:setStrikethru()}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_halign:{bf:setHAlignment(}}{it:string scalar a}{help mf_pdf##des_paragraph_halign:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_valign:{bf:setVAlignment(}}{it:string scalar a}{help mf_pdf##des_paragraph_valign:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_paragraph_linesp:{bf:setLineSpace(}}{it:real scalar sz}{help mf_pdf##des_paragraph_linesp:{bf:)}}


{marker syn_text}{...}
    {title:PdfText}

{p 8 8 2}
The {helpb mf_pdf##remarks_text:PdfText} class can be used to add customized 
text to a {helpb mf_pdf##remarks_paragraph:PdfParagraph}.

{p 8 25 2}
{help mf_pdf##des_text_new:{bf:PdfText()}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_text_bgcolor:{bf:setBgColor(}}{it:real scalar r}{cmd:,} 
{it:real scalar g}{cmd:,}
{it:real scalar b}{help mf_pdf##des_text_bgcolor:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_text_color:{bf:setColor(}}{it:real scalar r}{cmd:,} 
{it:real scalar g}{cmd:,}
{it:real scalar b}{help mf_pdf##des_text_color:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_text_font:{bf:setFont(}}{it:string scalar fontname}[{cmd:,} 
{it:string scalar style}]{help mf_pdf##des_text_font:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_text_fontsize:{bf:setFontSize(}}{it:real scalar sz}{help mf_pdf##des_text_fontsize:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_text_underline:{bf:setUnderline()}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_text_strike:{bf:setStrikethru()}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_text_superscript:{bf:setSuperscript()}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_text_subscript:{bf:setSubscript()}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_text_str:{bf:addString(}}{it:string scalar s}{help mf_pdf##des_text_str:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_text_clear:{bf:clearContent()}}


{marker syn_table}{...}
    {title:PdfTable}
	
{p 8 8 2}
The {helpb mf_pdf##remarks_table:PdfTable} class can be used
to add a table to a {helpb mf_pdf##remarks_document:PdfDocument}.

{p 8 25 2}
{help mf_pdf##des_table_new:{bf:PdfTable()}}
	
{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_init:{bf:init(}}{it:real scalar rows}{cmd:,}
{it:real scalar cols}{help mf_pdf##des_table_init:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_totalwidth:{bf:setTotalWidth(}}{it:real scalar sz}{help mf_pdf##des_table_totalwidth:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_colwidth:{bf:setColumnWidths(}}{it:real rowvector pct_v}{help mf_pdf##des_table_colwidth:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_widthpct:{bf:setWidthPercent(}}{it:real scalar pct}{help mf_pdf##des_table_widthpct:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_indent:{bf:setIndentation(}}{it:real scalar sz}{help mf_pdf##des_table_indent:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_halign:{bf:setHAlignment(}}{it:string scalar a}{help mf_pdf##des_table_halign:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_bwidth:{bf:setBorderWidth(}}{it:real scalar sz}[{cmd:,} {it:string scalar bordername}]{help mf_pdf##des_table_bwidth:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_bcolor:{bf:setBorderColor(}}{it:real scalar r}{cmd:,}
{it:real scalar g}{cmd:,} 
{it:real scalar b}[{cmd:,} {it:string scalar bordername}]{help mf_pdf##des_table_bcolor:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_topspace:{bf:setTopSpacing(}}{it:real scalar sz}{help mf_pdf##des_table_topspace:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_btmspace:{bf:setBottomSpacing(}}{it:real scalar sz}{help mf_pdf##des_table_btmspace:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_cell_string:{bf:setCellContentString(}}{it:real scalar i}{cmd:,}
{it:real scalar j}{cmd:,} 
{it:string scalar s}{help mf_pdf##des_table_cell_string:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_cell_paragraph:{bf:setCellContentParagraph(}}{it:real scalar i}{cmd:,}
{it:real scalar j}{cmd:,} 
{it:class} {helpb mf_pdf##remarks_paragraph:PdfParagraph}
{it:scalar p}{help mf_pdf##des_table_cell_paragraph:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_cell_image:{bf:setCellContentImage(}}{it:real scalar i}{cmd:,}
{it:real scalar j}{cmd:,} 
{it:string scalar filename}{help mf_pdf##des_table_cell_image:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_cell_table:{bf:setCellContentTable(}}{it:real scalar i}{cmd:,}
{it:real scalar j}{cmd:,} 
{it:class} {helpb mf_pdf##remarks_table:PdfTable}
{it:scalar tbl}{help mf_pdf##des_table_cell_table:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_cell_halign:{bf:setCellHAlignment(}}{it:real scalar i}{cmd:,}
{it:real scalar j}{cmd:,} 
{it:string scalar a}{help mf_pdf##des_table_cell_halign:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_cell_valign:{bf:setCellVAlignment(}}{it:real scalar i}{cmd:,}
{it:real scalar j}{cmd:,} 
{it:string scalar a}{help mf_pdf##des_table_cell_valign:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_cell_bgcolor:{bf:setCellBgColor(}}{it:real scalar i}{cmd:,}
{it:real scalar j}{cmd:,} 
{it:real scalar r}{cmd:,}
{it:real scalar g}{cmd:,}
{it:real scalar b}{help mf_pdf##des_table_cell_bgcolor:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_cell_bwidths:{bf:setCellBorderWidth(}}{it:real scalar i}{cmd:,}
{it:real scalar j}{cmd:,} 
{it:real scalar sz}[{cmd:,} {it:string scalar bordername}]{help mf_pdf##des_table_cell_bwidths:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_cell_bcolor:{bf:setCellBorderColor(}}{it:real scalar i}{cmd:,} 
{it:real scalar j}{cmd:,}
{it:real scalar r}{cmd:,}
{it:real scalar g}{cmd:,}
{it:real scalar b}[{cmd:,} {it:string scalar bordername}]{help mf_pdf##des_table_cell_bcolor:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_cell_margin:{bf:setCellMargin(}}{it:real scalar i}{cmd:,}
{it:real scalar j}{cmd:,}
{it:real scalar sz}[{cmd:,} {it:string scalar marginname}]{help mf_pdf##des_table_cell_margin:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_cell_font:{bf:setCellFont(}}{it:real scalar i}{cmd:,}
{it:real scalar j}{cmd:,} 
{it:string scalar fontname}[{cmd:,}
{it:string scalar style}]{help mf_pdf##des_table_cell_font:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_cell_fontsize:{bf:setCellFontSize(}}{it:real scalar i}{cmd:,}
{it:real scalar j}{cmd:,} 
{it:real scalar size}{help mf_pdf##des_table_cell_fontsize:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_cell_color:{bf:setCellColor(}}{it:real scalar i}{cmd:,}
{it:real scalar j}{cmd:,} 
{it:real scalar r}{cmd:,}
{it:real scalar g}{cmd:,}
{it:real scalar b}{help mf_pdf##des_table_cell_color:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_cell_span:{bf:setCellSpan(}}{it:real scalar i}{cmd:,}
{it:real scalar j}{cmd:,} 
{it:real scalar rowcount}{cmd:,}
{it:real scalar colcount}{help mf_pdf##des_table_cell_span:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_cell_rspan:{bf:setCellRowSpan(}}{it:real scalar i}{cmd:,}
{it:real scalar j}{cmd:,} 
{it:real scalar count}{help mf_pdf##des_table_cell_rspan:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_cell_cspan:{bf:setCellColSpan(}}{it:real scalar i}{cmd:,}
{it:real scalar j}{cmd:,} 
{it:real scalar count}{help mf_pdf##des_table_cell_cspan:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_row_split:{bf:setRowSplit(}}{it:real scalar i}{cmd:,}
{it:real scalar split}{help mf_pdf##des_table_row_split:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_add_row:{bf:addRow(}}{it:real scalar i}{help mf_pdf##des_table_add_row:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_del_row:{bf:delRow(}}{it:real scalar i}{help mf_pdf##des_table_del_row:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_add_col:{bf:addColumn(}}{it:real scalar j}{help mf_pdf##des_table_add_col:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_del_col:{bf:delColumn(}}{it:real scalar j}{help mf_pdf##des_table_del_col:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_matrix:{bf:fillStataMatrix(}}{it:string scalar name}{cmd:,} 
{it:real scalar colnames}{cmd:,}
{it:real scalar rownames}[{cmd:,} {it:string scalar fmt}]{help mf_pdf##des_table_matrix:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_mata:{bf:fillMataMatrix(}}{it:real matrix name}[{cmd:,} 
{it: real scalar i}{cmd:,}
{it:real scalar j}{cmd:,} {it:string scalar fmt}]{help mf_pdf##des_table_mata:{bf:)}}

{p 8 25 2}
{it:void}{bind: }
{help mf_pdf##des_table_data:{bf:fillData(}}{it:real matrix i}{cmd:,}
{it:rowvector j}{cmd:,} 
{it:real scalar vnames}{cmd:,}
{it:real scalar obsno}[{cmd:,} 
{it: scalar selectvar}]{help mf_pdf##des_table_data:{bf:)}}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:Pdf*()} classes are used to programatically create a PDF file.  The
{cmd:PdfDocument} class creates the overall file and is required.  The other
classes are {cmd:PdfParagraph}, which adds a paragraph to a {cmd:PdfDocument};
{cmd:PdfText}, which adds customized text; and {cmd:PdfTable}, which adds a
table.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 Pdf*()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

        {help mf_pdf##remarks_document:PdfDocument}
        {help mf_pdf##remarks_paragraph:PdfParagraph}
        {help mf_pdf##remarks_text:PdfText}
        {help mf_pdf##remarks_table:PdfTable}
        {help mf_pdf##remarks_error:Error codes}
        {help mf_pdf##examples:Examples}


{marker remarks_document}{...}
    {title:PdfDocument}
    
{pstd}
The {cmd:PdfDocument} class is the foundation for creating a PDF file.
Using the {cmd:PdfDocument} class is required to create a PDF file.  Unless
otherwise noted, all sizes are measured in points where 1 point = 1/72 inch.
	
{phang}
{marker des_document_new}{...}
{cmd:PdfDocument()}
is the constructor for the {cmd:PdfDocument} class.

{phang2}
{marker des_document_save}{...}
{cmd:save(}{it:filename}{cmd:)}
performs the final rendering of the PDF file and saves it to disk.

{phang2}
{marker des_document_close}{...}
{cmd:close()}
closes the {cmd:PdfDocument()} and releases associated memory.

{phang2}
{marker des_document_pgsize}{...}
{cmd:setPageSize(}{it:sz}{cmd:)}
sets the page size of the PDF file.  The possible values for {it:size} 
are {cmd:Letter}, {cmd:Legal}, {cmd:A3}, {cmd:A4}, {cmd:A5}, {cmd:B4}, 
and {cmd:B5}.

{phang2}
{marker des_document_landscape}{...}
{opt setLandscape(landscape)}
sets the page orientation of the PDF file to {cmd:landscape} or
{cmd:portrait}.  By default, the orientation is {cmd:portrait}.  If
{it:landscape} is {cmd:1}, the orientation is set to {cmd:landscape}.

{phang2}
{marker des_document_margins}{...}
{cmd:setMargins(}{it:left}{cmd:,} {it:top}{cmd:,} {it:right}{cmd:,} {it:bottom}{cmd:)}
sets the page margins {it:left}, {it:top}, {it:right}, and {it:bottom}.
The margins are used to define the canvas where all text, images, tables, 
etc., are drawn using absolute coordinates from ({it:left}, {it:top}).  The 
canvas height is equal to the {page height - ({it:top} + {it:bottom})}, and
the canvas width is equal to {page width - ({it:left} + {it:right})}.

{phang2}
{marker des_document_halign}{...}
{cmd:setHAlignment(}{it:a}{cmd:)}
sets the horizontal page alignment.  The possible alignment values are 
{cmd:left}, {cmd:right}, {cmd:center}, {cmd:justified}, and {cmd:stretch}.
The default is {cmd:left} alignment.

{phang2}
{marker des_document_linesp}{...}
{cmd:setLineSpace(}{it:sz}{cmd:)}
sets the distance between lines of text for the document.

{phang2}
{marker des_document_bgcolor}{...}
{cmd:setBgColor(}{it:r}{cmd:,} {it:g}{cmd:,} {it:b}{cmd:)}
sets the background color of the document with the specified RGB values
in the range [0,255].  Note that only integer values can be used.

{phang2}
{marker des_document_color}{...}
{cmd:setColor(}{it:r}{cmd:,} {it:g}{cmd:,} {it:b}{cmd:)}
sets the text color of the document using the specified RGB values in the
range [0,255].  Note that only integer values can be used.

{phang2}
{marker des_document_font}{...}
{cmd:setFont(}{it:fontname}[{cmd:,} {it:style}]{cmd:)}
sets the font for the document.  Optionally, the font style may be specified.
The possible values for the {it:style} are {cmd:Regular}, {cmd:Bold},
{cmd:Italic}, and {cmd:Bold Italic}.  If {it:style} is not specified,
{cmd:Regular} is the default.

{phang2}
{marker des_document_fontsize}{...}
{cmd:setFontSize(}{it:sz}{cmd:)}
sets the text size in points for the document.

{phang2}
{marker des_document_image}{...}
{cmd:addImage(}{it:file}[{cmd:,} {it:cx}{cmd:,} {it:cy}]{cmd:)}
adds an image to the document.  The {it:filename} of the image can be
either an absolute path or a relative path from the current working 
directory.  {it:cx} and {it:cy} specify the width and height of the image, 
which are measured in points.

{pmore2}
If {it:cx} is not specified, the width of the image is determined by the image 
information and the canvas width of the document.  If {it:cx} is larger than
the canvas width, the canvas width is used.

{pmore2}
If {it:cy} is not specified, the height of the image is determined by the
width and the aspect ratio of the image.

{pmore2}
The supported image types are {cmd:.jpeg} and {cmd:.png}.

{phang2}
{marker des_document_para}{...}
{cmd:addParagraph(}{it:class}
{helpb mf_pdf##remarks_paragraph:PdfParagraph} {it:p}{cmd:)}
adds a new paragraph to the document.

{phang2}
{marker des_document_table}{...}
{cmd:addTable(}{it:class} 
{helpb mf_pdf##remarks_table:PdfTable} {it:t}{cmd:)}
adds a new table to the document.

{phang2}
{marker des_document_page}{...}
{cmd:addNewPage()}
adds a page break to the document and moves the current position to the
top left corner of the new page.

{phang2}
{marker des_document_line}{...}
{cmd:addLineBreak()}
adds a line break to the document and moves the current position to the
next line.


{marker remarks_paragraph}{...}
    {title:PdfParagraph}

{pstd}
The {cmd:PdfParagraph} class can be used to add 
a paragraph to a {helpb mf_pdf##remarks_document:PdfDocument}.
{cmd:PdfParagraph} inherits basic attributes from {cmd:PdfDocument}
such as the background color, text color, and font.  Unless
otherwise noted, all sizes are measured in points where 1 point = 1/72 inch.

{phang}
{marker des_paragraph_new}{...}
{cmd:PdfParagraph()}
is the constructor for a {cmd:PdfParagraph}.

{phang2}
{marker des_paragraph_str}{...}
{cmd:addString(}{it:s}{cmd:)}
appends a string to the end of the paragraph.

{phang2}
{marker des_paragraph_text}{...}
{cmd:addText(}{it:class}
{helpb mf_pdf##remarks_text:PdfText} {it:t}{cmd:)}
appends a {cmd:PdfText} object to the end of the paragraph.

{phang2}
{marker des_paragraph_lb}{...}
{cmd:addLineBreak()}
adds a line break to the end of the paragraph.  This moves the current
position to the beginning of the next line.

{phang2}
{marker des_paragraph_clear_content}{...}
{cmd:clearContent()}
clears the content from the paragraph.  This is useful if the paragraph object
has already been added to the document and you intend to reuse its attributes
with new content.

{phang2}
{marker des_paragraph_findent}{...}
{cmd:setFirstIndent(}{it:sz}{cmd:)}
sets the indentation for the first line of the paragraph.

{phang2}
{marker des_paragraph_leftindent}{...}
{cmd:setLeftIndent(}{it:sz}{cmd:)}
sets the left indentation of the paragraph, which applies to all
lines.

{phang2}
{marker des_paragraph_rightindent}{...}
{cmd:setRightIndent(}{it:sz}{cmd:)}
sets the right indentation of the paragraph, which applies to all
lines.  If the sum of the left and right indentations is greater than the 
canvas width, the left indentation will dominate, and the right indentation 
will be overridden and set to 0.

{phang2}
{marker des_paragraph_ts}{...}
{cmd:setTopSpacing(}{it:sz}{cmd:)}
sets the space above the paragraph.

{phang2}
{marker des_paragraph_bs}{...}
{cmd:setBottomSpacing(}{it:sz}{cmd:)}
sets the space below the paragraph.

{phang2}
{marker des_paragraph_bgcolor}{...}
{cmd:setBgColor(}{it:r}{cmd:,} {it:g}{cmd:,} {it:b}{cmd:)}
sets the background color of the paragraph with the specified RGB values 
in the range [0,255].  Note that only integer values can be used.

{phang2}
{marker des_paragraph_color}{...}
{cmd:setColor(}{it:r}{cmd:,} {it:g}{cmd:,} {it:b}{cmd:)}
sets the text color of the paragraph with the specified RGB values 
in the range [0,255].  Note that only integer values can be used.

{phang2}
{marker des_paragraph_font}{...}
{cmd:setFont(}{it:fontname}[{cmd:,} {it:style}]{cmd:)}
sets the font for the paragraph.  Optionally, the font style may be specified.
The possible values for the {it:style} are {cmd:Regular}, {cmd:Bold}, 
{cmd:Italic}, and {cmd:Bold Italic}.

{phang2}
{marker des_paragraph_fontsize}{...}
{cmd:setFontSize(}{it:sz}{cmd:)}
sets the text size in points for the paragraph.

{phang2}
{marker des_paragraph_underline}{...}
{cmd:setUnderline()}
underlines the text in the entire paragraph.

{phang2}
{marker des_paragraph_strike}{...}
{cmd:setStrikethru()}
strikes through the text in the entire paragraph.

{phang2}
{marker des_paragraph_halign}{...}
{cmd:setHAlignment(}{it:a}{cmd:)}
sets the horizontal alignment of the paragraph.  The possible alignment values
are {cmd:left}, {cmd:right}, {cmd:center}, {cmd:justified}, and {cmd:stretch}.

{phang2}
{marker des_paragraph_valign}{...}
{cmd:setVAlignment(}{it:a}{cmd:)}
sets the vertical alignment of the paragraph.  The possible alignment values
are {cmd:top}, {cmd:center}, {cmd:baseline}, and {cmd:bottom}.  This setting
has a visible effect only when the paragraph contains characters with varying
fonts.

{phang2}
{marker des_paragraph_linesp}{...}
{cmd:setLineSpace(}{it:sz}{cmd:)}
sets the distance between lines of text for the paragraph.


{marker remarks_text}{...}
    {title:PdfText}

{pstd}
The {cmd:PdfText} class can be used to add customized text to a paragraph.
The {cmd:PdfText} class can set properties such as the background color, text
color, font, etc.  Unless otherwise noted, all sizes are measured in points
where 1 point = 1/72 inch.

{phang}
{marker des_text_new}{...}
{cmd:PdfText()}
is the constructor for a {cmd:PdfText} object.

{phang2}
{marker des_text_bgcolor}{...}
{cmd:setBgColor(}{it:r}{cmd:,} {it:g}{cmd:,} {it:b}{cmd:)}
sets the background color of the text with the specified RGB values 
in the range [0,255].  Note that only integer values can be used.

{phang2}
{marker des_text_color}{...}
{cmd:setColor(}{it:r}{cmd:,} {it:g}{cmd:,} {it:b}{cmd:)}
sets the color of the text with the specified RGB values 
in the range [0,255].  Note that only integer values can be used.

{phang2}
{marker des_text_font}{...}
{cmd:setFont(}{it:fontname}[{cmd:,} {it:style}]{cmd:)}
sets the font for the text.  Optionally, the font style may be specified.
The possible values for the {it:style} are {cmd:Regular}, {cmd:Bold}, 
{cmd:Italic}, and {cmd:Bold Italic}.

{phang2}
{marker des_text_fontsize}{...}
{cmd:setFontSize(}{it:sz}{cmd:)}
sets the text size in points for the text.

{phang2}
{marker des_text_underline}{...}
{cmd:setUnderline()}
underlines the text.

{phang2}
{marker des_text_strike}{...}
{cmd:setStrikethru()}
strikes through the text.

{phang2}
{marker des_text_superscript}{...}
{cmd:setSuperscript()}
sets the text to be a superscript.

{phang2}
{marker des_text_subscript}{...}
{cmd:setSubscript()}
sets the text to be a subscript.

{phang2}
{marker des_text_str}{...}
{cmd:addString(}{it:s}{cmd:)}
adds the string to the text.

{phang2}
{marker des_text_clear}{...}
{cmd:clearContent()}
clears the text content.  This is useful if the text object has already been
added to the paragraph and you intend to reuse its attributes with new
content.


{marker remarks_table}{...}
    {title:PdfTable}
    
{pstd}
The {cmd:PdfTable} class can be used to add 
a table to a {helpb mf_pdf##remarks_document:PdfDocument}.  The 
{cmd:PdfTable} inherits basic attributes from the {cmd:PdfDocument}
such as the background color, text color, and font.  A {cmd:PdfTable}
may contain up to 65,535 rows and up to 50 columns.  Unless otherwise 
noted, all sizes are measured in points where 1 point = 1/72 inch.

{phang}
{marker des_table_new}{...}
{cmd:PdfTable()}
is the constructor for a {cmd:PdfTable}.
	
{phang2}
{marker des_table_init}{...}
{cmd:init(}{it:rows}{cmd:,} {it:cols}{cmd:)}
must be invoked before editing the table or its attributes unless 
{helpb mf_pdf##des_table_matrix:fillStataMatrix()},
{helpb mf_pdf##des_table_mata:fillMataMatrix()},
or {helpb mf_pdf##des_table_data:fillData()} will be used.

{phang2}
{marker des_table_totalwidth}{...}
{cmd:setTotalWidth(}{it:sz}{cmd:)}
sets the total width of the table.  By default, the width of the table is 
equal to the canvas width.

{phang2}
{marker des_table_colwidth}{...}
{cmd:setColumnWidths(}{it:pct_v}{cmd:)}
sets the width of each column for the table.  By default, the width of each
column will be equal.  The column widths are specified as a fraction of the
total table width.  The length of the row vector must equal the number of
columns in the table.  The sum of the fractions must be 1.

{phang2}
{marker des_table_widthpct}{...}
{cmd:setWidthPercent(}{it:pct}{cmd:)}
sets the width as a fraction of the canvas that the table will occupy.  The
value may be a number in the range (0,1].

{phang2}
{marker des_table_indent}{...}
{cmd:setIndentation(}{it:sz}{cmd:)}
sets the table indentation.  Setting the indentation has no visible effect 
if the table width is equal to the canvas width.

{phang2}
{marker des_table_halign}{...}
{cmd:setHAlignment(}{it:a}{cmd:)}
sets the horizontal alignment of the table.  The possible alignment values are 
{cmd:left}, {cmd:right}, and {cmd:center}.  {cmd:left} is the default.
This setting has a visible effect only when the table width is less than
the canvas width.

{phang2}
{marker des_table_bwidth}{...}
{cmd:setBorderWidth(}{it:sz} [{cmd:,} {it:bordername}]{cmd:)}
sets the width of the table border.  The possible values of {it:bordername}
are {cmd:top}, {cmd:left}, {cmd:bottom}, {cmd:right}, {cmd:insideH},
{cmd:insideV}, and {cmd:all}, which identify, respectively, the top border,
the left border, the bottom border, the right border, the inside horizontal
edges border, the inside vertical edges border, and all borders.  If
{it:bordername} is not specified, {cmd:all} is used.

{phang2}
{marker des_table_bcolor}{...}
{cmd:setBorderColor(}{it:r}{cmd:,} {it:g}{cmd:,} {it:b}
[{cmd:,} {it:bordername}]{cmd:)}
sets the color of the table border using the specified RGB values in the range
[0,255].  Note that only integer values can be used.  The possible values of
{it:bordername} are {cmd:top}, {cmd:left}, {cmd:bottom}, {cmd:right},
{cmd:insideH}, {cmd:insideV}, and {cmd:all}, which identify, respectively, the
top border, the left border, the bottom border, the right border, the inside
horizontal edges border, the inside vertical edges border, and all borders.
If {it:bordername} is not specified, {cmd:all} is used.

{phang2}
{marker des_table_topspace}{...}
{cmd:setTopSpacing(}{it:sz}{cmd:)}
sets the space above the table.

{phang2}
{marker des_table_btmspace}{...}
{cmd:setBottomSpacing(}{it:sz}{cmd:)}
sets the space below the table.

{phang2}
{marker des_table_cell_string}{...}
{cmd:setCellContentString(}{it:i}{cmd:,} {it:j}{cmd:,} {it:s}{cmd:)}
sets the cell content of the {it:i}th row and {it:j}th column to be text {it:s}.

{phang2}
{marker des_table_cell_paragraph}{...}
{cmd:setCellContentParagraph(}{it:i}{cmd:,} {it:j}{cmd:,} 
{it:class} {helpb mf_pdf##remarks_paragraph:PdfParagraph} {it:p}{cmd:)}
sets the cell content of the {it:i}th row and {it:j}th column to be a 
{cmd:PdfParagraph}.

{phang2}
{marker des_table_cell_image}{...}
{cmd:setCellContentImage(}{it:i}{cmd:,} {it:j}{cmd:,} {it:filename}{cmd:)}
sets the cell content of the {it:i}th row and {it:j}th column to be the image
specified by {it:filename}.  The width of the image fits the column width,
while the height of the image is determined by the width of the image and its
aspect ratio.

{phang2}
{marker des_table_cell_table}{...}
{cmd:setCellContentTable(}{it:i}{cmd:,} {it:j}{cmd:,} 
{it:class} {helpb mf_pdf##remarks_table:PdfTable} {it:tbl}{cmd:)}
sets the cell content of the {it:i}th row and {it:j}th column to be 
a {cmd:PdfTable}.

{phang2}
{marker des_table_cell_halign}{...}
{cmd:setCellHAlignment(}{it:i}{cmd:,} {it:j}{cmd:,} {it:a}{cmd:)}
sets the horizontal alignment for the cell of the {it:i}th row and {it:j}th 
column.  The possible values for {it:a} are {cmd: left}, {cmd:right},
{cmd:center}, {cmd:justified}, and {cmd:stretch}.
{cmd:left} is the default.

{phang2}
{marker des_table_cell_valign}{...}
{cmd:setCellVAlignment(}{it:i}{cmd:,} {it:j}{cmd:,} {it:a}{cmd:)}
sets the vertical alignment for the cell of the {it:i}th row and {it:j}th 
column.  The possible values for {it:a} are {cmd:top}, {cmd:middle}, 
and {cmd:bottom}.  {cmd:top} is the default.

{phang2}
{marker des_table_cell_bgcolor}{...}
{cmd:setCellBgColor(}{it:i}{cmd:,} {it:j}{cmd:,}
{it:r}{cmd:,} {it:g}{cmd:,} {it:b}{cmd:)}
sets the background color of the cell of the {it:i}th row and {it:j}th column
to be the specified RGB values in the range [0,255].  Note that only integer 
values can be used.

{phang2}
{marker des_table_cell_bwidths}{...}
{cmd:setCellBorderWidth(}{it:i}{cmd:,} {it:j}{cmd:,} {it:sz}
[{cmd:,} {it:bordername}]{cmd:)}
sets the width of the specified border of the cell on the {it:i}th row and
{it:j}th column.  The possible values of {it:bordername} are {cmd:top},
{cmd:left}, {cmd:bottom}, {cmd:right}, and {cmd:all}, which identify,
respectively, the top border, the left border, the bottom border, the right
border, and all the borders.  If {it:sz} equals 0, the border of the cell is
not shown.  If {it:bordername} is not specified, {cmd:all} is the default.

{phang2}
{marker des_table_cell_bcolor}{...}
{cmd:setCellBorderColor(}{it:i}{cmd:,} {it:j}{cmd:,} {it:r}{cmd:,}
{it:g}{cmd:,} {it:b} [{cmd:,} {it:bordername}]{cmd:)}
sets the color of the specified border of the cell on the {it:i}th row and
{it:j}th column to be the specified RGB values in the range [0,255].  The
possible values of {it:bordername} are {cmd:top}, {cmd:left}, {cmd:bottom},
{cmd:right}, and {cmd:all}, which identify, respectively, the top border, the
left border, the bottom border, the right border, and all the borders.  If
{it:bordername} is not specified, {cmd:all} is the default.

{phang2}
{marker des_table_cell_margin}{...}
{cmd:setCellMargin(}{it:i}{cmd:,} {it:j}{cmd:,} {it:sz}
[{cmd:,} {it:marginname}]{cmd:)}
sets the content margin of the cell of the {it:i}th row and {it:j}th column.
The possible values of {it:marginname} are {cmd:top}, {cmd:left},
{cmd:bottom}, {cmd:right}, and {cmd:all}, which identify, respectively, the
top margin, the left margin, the bottom margin, the right margin, and all the
margins.  If {it:marginname} is not specified, {cmd:all} is the default.

{phang2}
{marker des_table_cell_font}{...}
{cmd:setCellFont(}{it:i}{cmd:,} {it:j}{cmd:,} {it:fontname}[{cmd:,}
{it:style}]{cmd:)}
sets the font for the cell of the {it:i}th row and {it:j}th column.
Optionally, the font style may be specified.  The possible
values for the {it:style} are {cmd:Regular}, {cmd:Bold}, 
{cmd:Italic}, and {cmd:Bold Italic}.  If {it:style} is not specified, 
{cmd:Regular} is the default.

{phang2}
{marker des_table_cell_fontsize}{...}
{cmd:setCellFontSize(}{it:i}{cmd:,} {it:j}{cmd:,} {it:size}{cmd:)}
sets the text size in points for the cell of the {it:i}th row
and {it:j}th column.

{phang2}
{marker des_table_cell_color}{...}
{cmd:setCellColor(}{it:i}{cmd:,} {it:j}{cmd:,} {it:r}{cmd:,} {it:g}{cmd:,}
{it:b}{cmd:)}
sets the text color for the cell of the {it:i}th row and {it:j}th column
using the specified RGB values in the range [0,255].  Note that only integer
values can be used.

{phang2}
{marker des_table_cell_span}{...}
{cmd:setCellSpan(}{it:i}{cmd:,} {it:j}{cmd:,} {it:rowcount}{cmd:,}
{it:colcount}{cmd:)}
sets the cell of the {it:j}th column of the {it:i}th row to span {it:rowcount}
cells vertically downward and span {it:colcount} cells horizontally to the
right.  This is equivalent to merging all the cells in the spanning range into
the original cell ({it:i},{it:j}).  Any content in the spanning range other
than the original cell ({it:i},{it:j}) will be discarded.

{phang2}
{marker des_table_cell_rspan}{...}
{cmd:setCellRowSpan(}{it:i}{cmd:,} {it:j}{cmd:,} {it:count}{cmd:)}
sets the cell of the {it:j}th column of the {it:i}th row to span {it:count}
cells vertically downward.  This is equivalent to merging all the cells in the
vertical spanning range into the original cell ({it:i},{it:j}).  Any content
in the spanning range other than the original cell ({it:i},{it:j}) will be
discarded.  This function is equivalent to {cmd:setCellSpan(}{it:i}{cmd:,}
{it:j}{cmd:,} {it:count}{cmd:, 1)}.

{phang2}
{marker des_table_cell_cspan}{...}
{cmd:setCellColSpan(}{it:i}{cmd:,} {it:j}{cmd:,} {it:count}{cmd:)}
sets the cell of the {it:j}th column of the {it:i}th row to span {it:count}
cells horizontally to the right.  This is equivalent to merging all the cells
in the horizontal spanning range into the original cell ({it:i},{it:j}).  Any
content in the spanning range other than the original cell ({it:i},{it:j})
will be discarded.  This function is equivalent to
{cmd:setCellSpan(}{it:i}{cmd:,} {it:j}{cmd:, 1,} {it:count}{cmd:)}.

{phang2}
{marker des_table_row_split}{...}
{cmd:setRowSplit(}{it:i}{cmd:,} {it:split}{cmd:)}
sets the {it:i}th row to split across multiple pages if {it:split} is not
{cmd:0}.  Otherwise, the {it:i}th row will be displayed starting from the top
of the next page.  This setting has no effect if the {it:i}th row can be
displayed completely on one page.

{phang2}
{marker des_table_add_row}{...}
{cmd:addRow(}{it:i}{cmd:)}
adds a row to the table after the {it:i}th row.  The range of {it:i} is from 0
to {it:rows}, where {it:rows} is the number of rows of the table.  If {it:i}
is specified as {cmd:0}, the row will be added before the first row.
Otherwise, the row will be added after the {it:i}th row.

{phang2}
{marker des_table_del_row}{...}
{cmd:delRow(}{it:i}{cmd:)}
deletes the {it:i}th row from the table.  The range of {it:i} is from 1 to
{it:rows}, where {it:rows} is the number of rows of the table.

{phang2}
{marker des_table_add_col}{...}
{cmd:addColumn(}{it:j}{cmd:)}
adds a column to the table on the right of the {it:j}th column.  The range of
{it:j} is from 0 to {it:cols}, where {it:cols} is the number of columns of
the table.  If {it:j} is specified as {cmd:0}, the column will be added to
the left of the first column, which is equivalent to adding a new first
column.  Otherwise, the column will be added to the right of the {it:j}th
column.

{phang2}
{marker des_table_del_col}{...}
{cmd:delColumn(}{it:j}{cmd:)}
deletes the {it:j}th column from the table.  The range of {it:j} is from 1 to
{it:cols}, where {it:cols} is the number of columns of the table.

{phang2}
{marker des_table_matrix}{...}
{cmd:fillStataMatrix(}{it:name}{cmd:,} {it:colnames}{cmd:,}
{it:rownames}[{cmd:,} {it:fmt}]{cmd:)}
fills the table with a {help matrix:Stata matrix}.
If {it:colnames} is not {cmd:0}, the first row of the table is filled with 
{help matrix_rownames:matrix colnames}.  If {it:rownames} is not {cmd:0}, 
the first column of the table is filled with 
{help matrix_rownames:matrix rownames}.  The elements of the matrix are
formatted using {help format:{it:fmt}}, if specified.  Otherwise, {cmd:%12.0g}
is used.  The matrix is identified by {it:name}.  If the matrix does not
exist, an error code will be returned.

{phang2}
{marker des_table_mata}{...}
{cmd:fillMataMatrix(}{it:name}[{cmd:,} {it:i}{cmd:,} {it:j}]{cmd:)}
fills the table with a Mata matrix.  The matrix is identified by {it:name}.
If {it:i} is specified, the matrix fills the table starting from the {it:i}th 
row.  If {it:j} is specified, the matrix fills the table starting from the 
{it:j}th column.  The elements of the Mata matrix are formatted using
{help format:{it:fmt}}, if specified.  Otherwise, {cmd:%12.0g} is used.  If
the matrix does not exist, an error code will be returned.

{phang2}
{marker des_table_data}{...}
{cmd:fillData(}{it:i}{cmd:,} {it:j}{cmd:,} {it:vnames}{cmd:,}
{it:obsno}[{cmd:,} {it:selectvar}]{cmd:)}
fills the table with the current Stata dataset in memory.  If a value
label is attached to the variable, the data are displayed using the value label.
Otherwise, the data are displayed based on the display format.
{it:i}, {it:j}, and {it:selectvar} are specified in the same way as
{helpb mf_st_data:st_data()}.
Factor variables and time-series-operated variables are not allowed.
If {it:vnames} is not {cmd:0}, the first row of the table will be filled with
variable names.  If {it:obsno} is not {cmd:0}, the first column of the table
will be filled with observation numbers.


{marker remarks_error}{...}
    {title:Error codes}

{p 4 4 2}
Functions can abort only if one of the input parameters does not meet the
specification; for example, a string scalar is used when a real scalar is
required.  Functions return a negative error code when there is an error:

	 Code    Meaning
	{hline 67}
	-17100    an error occurred 
	-17101    PDF file not created
	-17102    value is missing
	-17103    attribute failed to set
	-17104    file not saved
	-17105    image not added
	-17106    table not added
	-17107    paragraph not added 
	-17108    failed to add new page
	-17109    failed to add line break
	-17110    PDF file not closed
	
	-17120    table not created
	-17121    table failed to set table dimensions
	-17122    table not initialized 
	-17123    cell index out of range
	-17124    table failed to set cell value
	-17125    table failed to fill Stata matrix
	-17126    table failed to fill Mata matrix
	-17127    table failed to fill data
	
	-17130	  paragraph not created
	-17131	  paragraph failed to add text
	-17132    paragraph failed to clear content
	{hline 67}


{marker examples}{...}
    {title:Examples}
	
{pstd}
Examples are presented under the following headings:

	{help mf_pdf##example_text:Add paragraph}
	{help mf_pdf##example_text2:Add paragraph with customized text}
	{help mf_pdf##example_table_simple:Add table (simple example)}
	{help mf_pdf##example_table_header_footer:Add table (table with header and footer)}
	{help mf_pdf##example_table_graph:Add table (table with graph)}


{marker example_text}{...}
    {title:Add paragraph}

	{cmd}mata:
        pdf = PdfDocument()

        p = PdfParagraph() 
        p.addString("This is our first example of a paragraph. ")
        p.addString("Let's add another sentence. ")
        p.addString("Now we will conclude our first paragraph.")
        pdf.addParagraph(p)

        p = PdfParagraph() 
        p.setFirstIndent(36)
        p.setFontSize(14)
        p.setTopSpacing(10)
        p.addString("This is our second paragraph. ")
        p.addString("The first line of this paragraph has an indentation of ")
        p.addString("36 points or 1/2 inch. The font size of this paragraph ")
        p.addString("is 14.")
        pdf.addParagraph(p)

        p = PdfParagraph() 
        p.setTopSpacing(10)
        p.setFontSize(14)
        p.setHAlignment("justified")
        p.addString("This is our third paragraph. ")
        p.addString("Notice that we have switched back to block mode, which ")
        p.addString("means that there is not any indentation. ")
        p.addString("You should also notice that this paragraph sets the ")
        p.addString("alignment to justified.")
        pdf.addParagraph(p)
 
 	pdf.save("paragraph1.pdf")
 	pdf.close()
 	
 	// clean up
 	mata drop p
	mata drop pdf
	end{txt}


{marker example_text2}{...}
    {title:Add paragraph with customized text}

	{cmd}mata:
	pdf = PdfDocument()
	
	t1 = PdfText()
	t1.setSuperscript()
	t1.addString("This is superscript text.")
	
	t2 = PdfText()
	t2.setSubscript()
	t2.addString("This is subscript text.")

	p = PdfParagraph() 
	p.addString("Hello, this is our paragraph's normal text. ")
	p.addText(t1)
	p.addText(t2)
	p.addString("Here is some more text using the attributes from ")
	p.addString("the paragraph. ")
	
	t = PdfText()
	t.setFont("Courier New")
	t.setFontSize(18) 
	t.setColor(255, 0, 0)
	t.addString("Here is an example of text that uses a large ")
	t.addString("Courier New font.  Its text color is red. ")
	p.addText(t)
	
	
	p.addString("We could insert more text here using the paragraph's ")
	p.addString("normal attributes. ")

	t = PdfText()
	t.setFontSize(30) 
	t.setColor(0, 0, 255)
	t.setStrikethru()
	t.addString("Here is one more example of adding modified text ")
	t.addString("to a paragraph. ")
	p.addText(t)
	
	p.addString("Now we will conclude this paragraph with normal text.")
	pdf.addParagraph(p)
 
	pdf.save("text1.pdf")
	pdf.close()
	
	// clean up
	mata drop t
	mata drop t1
	mata drop t2
	mata drop p
	mata drop pdf
	end{txt}


{marker example_table_simple}{...}
    {title:Add table} (simple example)

        {cmd}mata:
	pdf = PdfDocument()

	t = PdfTable()
	t.init(5, 4)

	A = (0.2,0.5,0.15,0.15)
	t.setColumnWidths(A)

	for(i=1; i<=5; i++) {
		for(j=1; j<=4; j++) {
			result = sprintf("This is cell(%g, %g)", i, j) ;
			t.setCellContentString(i, j, result)
		}
	}

	pdf.addTable(t) 

	pdf.save("table1.pdf")
	pdf.close()

	// clean up
	mata drop t
	mata drop pdf
        end{txt}


{marker example_table_header_footer}{...}
    {title:Add table} (table with header and footer)

        {cmd}mata:
	pdf = PdfDocument()

	t = PdfTable()
	t.init(5, 4)

	A = (0.2,0.5,0.15,0.15)
	t.setColumnWidths(A)

	t.setCellContentString(1, 1, "This is header")
	t.setCellHAlignment(1, 1, "center")
	t.setCellColSpan(1, 1, 4)

	for(i=2; i<=4; i++) {
		for(j=1; j<=4; j++) {
			result = sprintf("This is cell(%g, %g)", i, j) ;
			t.setCellContentString(i, j, result)
		}
	}

	t.setCellContentString(5, 1, "This is footer")
	t.setCellHAlignment(5, 1, "center")
	t.setCellColSpan(5, 1, 4)

	pdf.addTable(t) 

	pdf.save("table2.pdf")
	pdf.close()

	// clean up
	mata drop t
	mata drop pdf
        end{txt}


{marker example_table_graph}{...}
    {title:Add table} (table with graph)
 
	{cmd}sysuse citytemp, clear
	tabulate division, matcell(freq) matrow(vlabel)
	local tabvar division

	histogram `tabvar', discrete frequency addlabel scheme(sj)
	graph export census.png, replace width(2000)

	mata:
	freq = st_matrix("freq")
	vlabel = st_matrix("vlabel")
	svlabel = st_vlmap(st_varvaluelabel(st_local("tabvar")), vlabel)
	colheader = ("Census Division","Freq.","Percent","Cum.")
	
	nrows = rows(freq)+2
	ncols = cols(colheader)
	percent = 0
	cum = 0 
	
	pdf = PdfDocument()
    
    	t1 = PdfTable()
    	t1.init(nrows, ncols)
	
	for(i=1;i<=ncols;i++) {
		t1.setCellContentString(1,i,colheader[1,i])
	}
	
	for(i=1;i<=rows(freq);i++) {
		t1.setCellContentString(i+1,1,svlabel[i,1])
		
		output = sprintf("%9.0g", freq[i,1])
		t1.setCellHAlignment(i+1,2,"right")
		t1.setCellContentString(i+1,2,output)
		
		percent = freq[i,1]/sum(freq)*100
		output = sprintf("%9.2f", percent)
		t1.setCellHAlignment(i+1,3,"right")
		t1.setCellContentString(i+1,3,output)

		cum = cum + percent
		output = sprintf("%9.2f", cum)
		t1.setCellHAlignment(i+1,4,"right")
		t1.setCellContentString(i+1,4,output)		
	}
	
	t1.setCellContentString(nrows,1, "Total")
	output = sprintf("%9.0g", sum(freq))
	t1.setCellHAlignment(nrows,2,"right")
	t1.setCellContentString(nrows,2,output)
	t1.setCellHAlignment(nrows,3,"right")
	t1.setCellContentString(nrows,3,"100.00")
	
	t2 = PdfTable()
	t2.init(1,2)
	
	t2.setCellContentTable(1,1,t1)
	t2.setCellContentImage(1,2,"census.png")
	t2.setCellVAlignment(1,2,"bottom")
	t2.setBorderWidth(0)
	
	pdf.addTable(t2)
	
	pdf.save("table3.pdf")
	pdf.close()
	
	// clean up
	mata drop t1
	mata drop t2
	mata drop pdf
	end{txt}
