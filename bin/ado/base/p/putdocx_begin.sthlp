{smcl}
{* *! version 1.0.2  14feb2020}{...}
{vieweralsosee "[RPT] putdocx begin" "mansection RPT putdocxbegin"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] putdocx intro" "help putdocx intro"}{...}
{vieweralsosee "[RPT] putdocx pagebreak" "help putdocx pagebreak"}{...}
{vieweralsosee "[RPT] putdocx paragraph" "help putdocx paragraph"}{...}
{vieweralsosee "[RPT] putdocx table" "help putdocx table"}{...}
{vieweralsosee "[RPT] Appendix for putdocx" "help putdocx_appendix"}{...}
{viewerjumpto "Syntax" "putdocx begin##syntax"}{...}
{viewerjumpto "Description" "putdocx begin##description"}{...}
{viewerjumpto "Links to PDF documentation" "putdocx begin##linkspdf"}{...}
{viewerjumpto "Options" "putdocx begin##options"}{...}
{viewerjumpto "Examples" "putdocx begin##examples"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[RPT] putdocx begin} {hline 2}}Create an Office Open XML (.docx) file{p_end}
{p2col:}({mansection RPT putdocxbegin:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Create document for export

{p 8 22 2}
{cmd:putdocx begin}
[{cmd:,}
{help putdocx begin##beginopts:{it:begin_options}}]


{phang}
Describe active document

{p 8 22 2}
{cmd:putdocx describe}


{phang}
Save and close document

{p 8 22 2}
{cmd:putdocx save} {it:{help filename}}
[{cmd:,}
{help putdocx begin##saveopts:{it:save_options}}]


{phang}
Close without saving

{p 8 22 2}
{cmd:putdocx clear}


{phang}
Append contents of documents

{p 8 22 2}
{cmd:putdocx append} {it:{help filename}}_1
{it:filename}_2 [{it:filename}_3 [...]]
[{cmd:,}
{help putdocx begin##appendopts:{it:append_options}}]


{marker beginopts}{...}
{synoptset 28}{...}
{synopthdr:begin_options}
{synoptline}
{synopt :{opth page:size(putdocx_begin##doc_psize:psize)}}set document page
size{p_end}
{synopt :{opt land:scape}}change document orientation to landscape{p_end}
{synopt :{opth font:(putdocx_begin##font:fspec)}}set font, font size, and font
color for the document{p_end}
{synopt :{opth pagenum:(putdocx_begin##pnspec:pnspec)}}set page number
format{p_end}
{synopt :{opth header:(putdocx_begin##hname:hname)}}add a header{p_end}
{synopt :{opth footer:(putdocx_begin##fname:fname)}}add a footer{p_end}
{synopt :{cmd:margin(}{help putdocx_begin##type:{it:type}}{cmd:,} {it:#}[{help putdocx_begin##unit:{it:unit}}]{cmd:)}}set page margins for the document{p_end}
{synoptline}

{marker saveopts}{...}
{synopthdr:save_options}
{synoptline}
{synopt :{opt replace}}replace {it:filename} with the active document{p_end}
{synopt :{opt append}}append the active document to the end of
{it:filename}{p_end}
{synopt :{opth append:(putdocx_begin##apopts:ap_opts)}}append active document to
{it:filename} and change page break, header, and footer settings{p_end}
{synopt :{opt nomsg}}suppress message with a link to {it:filename}{p_end}
{synoptline}
{p 4 6 2}
Only one of {cmd:replace}, {cmd:append}, or 
{opt append(ap_opts)} may be specified.

{marker appendopts}{...}
{synopthdr:append_options}
{synoptline}
{synopt :{cmdab:sav:ing(}{it:filename} [{cmd:, replace}]{cmd:)}}save the
document to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}
{synopt :{opt pagebreak}}begin each appended file on a new page{p_end}
{synopt :{cmd:headsrc(first{c |}last{c |}own)}}specify the document from which headers
and footers are to be used; default is {cmd:headsrc(first)}{p_end}
{synopt :{opt pgnumrestart}}restart page numbering on the first page of each
appended document{p_end}
{synopt :{opt nomsg}}suppress message with a link to resulting document{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:putdocx} {cmd:begin} creates an Office Open XML ({cmd:.docx}) file.
This is the active document that the remaining {cmd:putdocx} commands modify.

{pstd}
{cmd:putdocx} {cmd:describe} describes the active
{cmd:.docx} file.

{pstd}
{cmd:putdocx} {cmd:save} saves and closes the {cmd:.docx} file.

{pstd}
{cmd:putdocx} {cmd:clear} closes the {cmd:.docx} file without saving.

{pstd}
{cmd:putdocx} {cmd:append} appends the contents of one or more {cmd:.docx}
files to another {cmd:.docx} file.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT putdocxbeginQuickstart:Quick start}

        {mansection RPT putdocxbeginRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}
Options are presented under the following headings:

        {help putdocx_begin##opts_putdocx_begin:Options for putdocx begin}
        {help putdocx_begin##opts_putdocx_save:Options for putdocx save}
        {help putdocx_begin##opts_putdocx_append:Options for putdocx append}


{marker opts_putdocx_begin}{...}
{title:Options for putdocx begin}

{marker doc_psize}{...}
{phang}
{opt pagesize(psize)} sets the page size of the document. {it:psize}
may be {cmd:letter}, {cmd:legal}, {cmd:A3}, {cmd:A4}, or {cmd:B4JIS}. The
default is {cmd:pagesize(letter)}.

{phang}
{opt landscape} changes the document orientation from portrait (the default)
to landscape.

{marker font}{...}
{phang}
{cmd:font(}{it:fontname} [{cmd:,} {it:size} [{cmd:,}
{it:color}]]{cmd:)} sets the font, font size, and font color for the document.  

{phang2}
{it:fontname} may be any valid font installed on the user's computer.  If
{it:fontname} includes spaces, then it must be enclosed in double quotes.
If {it:fontname} is not specified, the computer's default font will be
used.

{marker size}{...}
{phang2}
{it:size} is a numeric value that represents font size measured in points.
The default is {cmd:11}.

{marker color}{...}
{phang2}
{it:color} sets the text color.
{it:color} may be one of the colors listed in
{help putdocx_appendix##Colors:{it:Colors}} of
{helpb putdocx_appendix:[RPT] Appendix for putdocx}; a valid RGB value in the
form {it:### ### ###}, for example, {cmd:171 248 103}; or a valid
RRGGBB hex value in the form {it:######}, for example, {cmd:ABF867}.

{pmore}
The font size and font color may be specified individually without specifying 
{it:fontname}. Use {cmd:font("",} {it:size}{cmd:)} to specify the font size
only.  Use {cmd:font("", "",} {it:color}{cmd:)} to specify the font color only.

{marker pnspec}{...}
{phang}
{cmd:pagenum(}{it:pnformat} [{cmd:,} {it:start} [{cmd:,} {it:chapStyle}
[{cmd:,} {it:chapSep}]]]{cmd:)} specifies the format and starting page
for page numbers. 

{phang2}
{it:pnformat} 
specifies the page number format, such as decimals enclosed in parentheses or
uppercase Roman numerals.  The default is {cmd:decimal}.
For a complete list of page number formats, see
{help putdocx_appendix##Page_number_formats:{it:Page number formats}} of
{helpb putdocx appendix:[RPT] Appendix for putdocx}.

{phang2}
{it:start}
specifies the starting page number and must be an integer greater than or
equal to 0. The default is 1.

{marker chapstyle}{...}
{phang2}
{it:chapStyle}
specifies the style used for chapter headings.
For a complete list of chapter styles, see
{help putdocx_appendix##Chapter_styles:{it:Chapter styles}} of
{helpb putdocx appendix:[RPT] Appendix for putdocx}.

{marker chapsep}{...}
{phang2}
{it:chapSep} 
specifies the symbol used to separate chapter numbers and page numbers.
{it:chapSep} may be {cmd:colon}, {cmd:hyphen}, {cmd:em_dash}, {cmd:en_dash},
or {cmd:period}. The default is {cmd:hyphen}.

{pmore}
This option is not required for including page numbers in your
document, unless you want to include chapter numbers as well. To include chapter
numbers, specify the style used to indicate chapters ({it:chapStyle}),
and optionally, the symbol used to separate chapter and page numbers.

{pmore}
When specifying {it:chapStyle} and {it:chapSep}, chapter numbers will be
reported along with the page numbers. To activate these options, you must
specify a multilevel list style in Word that includes headings.

{marker hname}{...}
{phang}
{opt header(hname)} adds the header named {it:hname} to the document.  The
content of {it:hname}, including page numbers, can be defined with either
{cmd:putdocx paragraph} or {cmd:putdocx table}. {it:hname} must be a valid
name according to Stata's naming conventions; see {findalias frnames}.

{marker fname}{...}
{phang}
{opt footer(fname)} adds the footer named {it:fname} to the document. 
The content of {it:fname}, including page numbers, can be defined with either
{cmd:putdocx paragraph} or {cmd:putdocx table}. {it:fname} must be a valid
name according to Stata's naming conventions; see {findalias frnames}.

{phang}
{cmd:margin(}{it:type}{cmd:,} {it:#}[{it:unit}]{cmd:)} sets the page margins
of the document.  This option may be specified multiple times in a single
command to account for different margin settings.

{marker type}{...}
{pmore}
{it:type} identifies the location of the margin inside the document.
{it:type} may be {cmd:top}, {cmd:left}, {cmd:bottom}, {cmd:right}, or
{cmd:all}.

{marker unit}{...}
{pmore}
INCLUDE help put_units


{marker opts_putdocx_save}{...}
{title:Options for putdocx save}

{phang}
{cmd:replace} specifies to overwrite {it:filename}, if it exists,
with the contents of the document in memory.

{phang}
{cmd:append} specifies to append the contents of the document in memory
to the end of {it:filename}.

{marker apopts}{...}
{phang}
{opt append(ap_opts)} specifies to append the contents of the document in
memory to {it:filename} and indicates whether new content will be added on a
new page, which header and footer to use, and whether to restart page
numbering for each document. {it:ap_opts} are {cmd:pagebreak},
{cmd:headsrc()}, and {cmd:pgnumrestart}.

{phang2}
    {cmd:pagebreak} appends the active document beginning on a new page. 

{phang2}
    {cmd:headsrc(file{c |}active{c |}own)} specifies the file
    whose header and footer will be used in the document. 

{phang3}
    {cmd:headsrc(file)} is the default; it applies the header and footer 
    from {it:filename} throughout the document. 

{phang3}
    {cmd:headsrc(active)} applies the header and footer from the active 
    document throughout the document.

{phang3}
    {cmd:headsrc(own)} specifies that each document, {it:filename} and
    the active document, use its own header and footer. If the active
    document does not have a header or footer, it will inherit the
    header or footer from {it:filename}.
    
{phang2}
    {cmd:pgnumrestart} restarts page numbering in each document; {cmd:pagebreak}
    must be specified with {cmd:pgnumrestart}.

{phang}
{cmd:nomsg} suppresses the message that contains a link to {it:filename}.


{marker opts_putdocx_append}{...}
{title:Options for putdocx append}

{phang}
{cmd:saving(}{it:{help filename}} [{cmd:, replace}]{cmd:)} specifies to append
the contents of the existing document {it:filename}_2 to the end of
{it:filename}_1 and then write the result to the new document {it:filename}.
If {it:filename} already exists, it can be overwritten by specifying
{cmd:replace}. By default, {it:filename}_1 is overwritten with the document
created by appending content from {it:filename}_2.

{pmore}
If more than two files are specified, the contents are appended in the order in
which the files are listed. For example, {it:filename}_2 is appended to
{it:filename}_1, {it:filename}_3 is appended to the result of the first
append, and so forth.

{phang}
{cmd:pagebreak} begins each appended file on a new page.

{phang}
{cmd:headsrc(first{c |}last{c |}own)} specifies the document from which 
headers and footers are to be used. 

{phang2}
{cmd:headsrc(first)}, the default, specifies that the header and footer from
the first document being appended, {it:filename}_1, be applied throughout the
document. 

{phang2}
{cmd:headsrc(last)} specifies that the header and footer from the last
document be applied throughout the document. {cmd:headsrc(last)} may not be
specified with {cmd:pgnumrestart}. 

{phang2}
{cmd:headsrc(own)} specifies that each file being appended use its own header
and footer.  If any file does not have a header or footer, it will inherit the
header or footer from the previous document.

{phang}
{cmd:pgnumrestart} restarts page numbering on the first page of each appended
document. The {cmd:pagebreak} option must be specified with
{cmd:pgnumrestart}.  This option may not be specified with
{cmd:headsrc(last)}.

{phang}
{cmd:nomsg} suppresses the message that contains a link to the resulting
document.


{marker examples}{...}
{title:Examples}

    {hline}

{pstd}Create a {cmd:.docx} document in memory{p_end}
{phang2}{cmd:. putdocx begin}{p_end}

{pstd}Add a new paragraph to the active document and append text to it{p_end}
{phang2}{cmd:. putdocx paragraph}{p_end}
{phang2}{cmd:. putdocx text ("Fall report")}{p_end}

{pstd}
Describe active document{p_end}
	{cmd:. putdocx describe}

{pstd}
Save the document to disk{p_end}
	{cmd:. putdocx save report1.docx}

    {hline}

{pstd}Create a {cmd:.docx} document in memory with the header {cmd:header1}{p_end}
{phang2}{cmd:. putdocx begin, header(header1)}{p_end}

{pstd}Add content to the header {cmd:header1}{p_end}
{phang2}{cmd:. putdocx paragraph, toheader(header1)}{p_end}
{phang2}{cmd:. putdocx text ("Winter report")}{p_end}

{pstd}
Save the document to disk{p_end}
	{cmd:. putdocx save report2.docx}

{pstd}Append the content in file report2.docx to the end of the contents in report1.docx{p_end}
{phang2}{cmd:. putdocx append report1.docx report2.docx}{p_end}

    {hline}

{pstd}Create a {cmd:.docx} document in memory with a landscape layout{p_end}
{phang2}{cmd:. putdocx begin, landscape}{p_end}

{pstd}Close the document without saving{p_end}
{phang2}{cmd:. putdocx clear}{p_end}

    {hline}

