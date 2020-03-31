{smcl}
{* *! version 1.0.2  14feb2020}{...}
{vieweralsosee "[RPT] putpdf begin" "mansection RPT putpdfbegin"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] putpdf intro" "help putpdf intro"}{...}
{vieweralsosee "[RPT] putpdf pagebreak" "help putpdf pagebreak"}{...}
{vieweralsosee "[RPT] putpdf paragraph" "help putpdf paragraph"}{...}
{vieweralsosee "[RPT] putpdf table" "help putpdf table"}{...}
{vieweralsosee "[RPT] Appendix for putpdf" "help putpdf appendix"}{...}
{viewerjumpto "Syntax" "putpdf begin##syntax"}{...}
{viewerjumpto "Description" "putpdf begin##description"}{...}
{viewerjumpto "Links to PDF documentation" "putpdf begin##linkspdf"}{...}
{viewerjumpto "Options" "putpdf begin##options"}{...}
{viewerjumpto "Examples" "putpdf begin##examples"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[RPT] putpdf begin} {hline 2}}Create a PDF file{p_end}
{p2col:}({mansection RPT putpdfbegin:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Create document for export

{p 8 22 2}
{cmd:putpdf begin}
[{cmd:,} {help putpdf_begin##beginopts:{it:begin_options}}]


{phang}
Describe active document

{p 8 22 2}
{cmd:putpdf describe}


{phang}
Save and close document

{p 8 22 2}
{cmd:putpdf save} {help filename:{it:filename}}
[{cmd:, replace nomsg}]


{phang}
Close without saving

{p 8 22 2}
{cmd:putpdf clear}


{marker beginopts}{...}
{synoptset 28}{...}
{synopthdr:begin_options}
{synoptline}
{synopt :{opth page:size(putpdf_begin##psize:psize)}}set document page size{p_end}
{synopt :{opt land:scape}}change document orientation to landscape{p_end}
{synopt :{opth font:(putpdf_begin##fspec:fspec)}}set font, font size, and font color for the document{p_end}
{synopt :{opth halign:(putpdf_begin##hvalue:hvalue)}}set horizontal alignment for the document{p_end}
{synopt :{cmd:margin(}{help putpdf_begin##type:{it:type}}{cmd:,} {it:#}[{help putpdf_begin##unit:{it:unit}}]{cmd:)}}set page margins for the document{p_end}
{synopt :{opth bgcolor:(putpdf_begin##color:color)}}set background color{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:putpdf begin} creates a PDF file.  This is the active document that
the remaining {cmd:putpdf} commands modify.

{pstd}
{cmd:putpdf} {cmd:describe} describes the active PDF file.

{pstd}
{cmd:putpdf} {cmd:save} saves and closes the PDF file.

{pstd}
{cmd:putpdf} {cmd:clear} closes the PDF file without saving.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT putpdfbeginQuickstart:Quick start}

        {mansection RPT putpdfbeginRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}
Options are presented under the following headings:

        {help putpdf_begin##opts_putpdf_begin:Options for putpdf begin}
        {help putpdf_begin##opts_putpdf_save:Options for putpdf save}


{marker opts_putpdf_begin}{...}
{title:Options for putpdf begin}

{marker psize}{...}
{phang}
{opt pagesize(psize)} sets the page size of the document.  {it:psize}
may be {cmd:letter}, {cmd:legal}, {cmd:A3}, {cmd:A4}, {cmd:A5}, {cmd:B4}, or
{cmd:B5}.  The default is {cmd:pagesize(letter)}.

{phang}
{cmd:landscape} changes the document orientation from portrait (the default)
to landscape.

{phang}
{cmd:font(}{it:fontname}
[{cmd:,} {it:size}
[{cmd:,} {it:color}]]{cmd:)}
sets the font, font size, and font color for the document.

{marker fspec}{...}
{phang2}
{it:fontname} may be any supported font installed on the user's computer.
Base 14 fonts, Type 1 fonts, and TrueType fonts with an extension of
{cmd:.ttf} and {cmd:.ttc} are supported.  TrueType fonts that cannot be
embedded may not used.  If {it:fontname} includes spaces, then it must be
enclosed in double quotes.  The default font is {cmd:Helvetica}.

{marker size}{...}
{phang2}
{it:size} is a numeric value that represents font size measured in points.
The default is {cmd:11}.

{marker color}{...}
{phang2}
{it:color} sets the text color.  {it:color} may be one of the
colors listed in
{help putpdf_appendix##Colors:{it:Colors}} of
{helpb putpdf appendix:[RPT] Appendix of putpdf};
a valid RGB value in the form {it:### ### ###}, for example,
{cmd:171 248 103}; or a valid RRGGBB hex value in the form {it:######},
for example, {cmd:ABF867}.

{pmore}
The font size and font color may be specified individually without specifying
{it:fontname}.  Use {cmd:font("",} {it:size}{cmd:)} to specify font size only.
Use {cmd:font("", "",} {it:color}{cmd:)} to specify font color only.  For both
cases, the default font will be used.

{marker hvalue}{...}
{phang}
{opt halign(hvalue)} sets the horizontal alignment of the document within the
paragraphs, images, and tables . {it:hvalue} may be {cmd:left}, {cmd:right},
or {cmd:center}.  The default is {cmd:halign(left)}.

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

{phang}
{opt bgcolor(color)}
sets the background color for the document.  {it:color} may be one of the
colors listed in
{help putpdf_appendix##Colors:{it:Colors}} of
{helpb putpdf appendix:[RPT] Appendix of putpdf};
a valid RGB value in the form {it:### ### ###}, for example, {cmd:171 248 103};
or a valid RRGGBB hex value in the form {it:######}, for example, {cmd:ABF867}.


{marker opts_putpdf_save}{...}
{title:Options for putpdf save}

{phang}
{opt replace} specifies to overwrite {it:filename}, if it exists,
with the contents of the document in memory.

{phang}
{opt nomsg} suppresses the message that contains a link to {it:filename}.


{marker examples}{...}
{title:Examples}


    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Create the {cmd:.pdf} document in memory{p_end}
{phang2}{cmd:. putpdf begin}{p_end}

{pstd}
Fit a linear regression model of {cmd:mpg} as a function of 
{cmd:weight} and {cmd:foreign}{p_end}
	{cmd:. regress mpg weight foreign}

{pstd}
Export the estimation results to the document as a table with the name {cmd:tbl1}{p_end}
{phang2}{cmd:. putpdf table tbl1 = etable, width(100%)}

{pstd}
Describe active document{p_end}
	{cmd:. putpdf describe}

{pstd}
Save the document to disk{p_end}
	{cmd:. putpdf save example.pdf}

    {hline}
{pstd}Create the {cmd:.pdf} document in memory, using a landscape layout{p_end}
{phang2}{cmd:. putpdf begin, landscape}{p_end}

{pstd}Close the document without saving it{p_end}
{phang2}{cmd:. putpdf clear}

    {hline}
