{smcl}
{* *! version 1.0.1  14feb2020}{...}
{vieweralsosee "[RPT] putpdf pagebreak" "mansection RPT putpdfpagebreak"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] putpdf intro" "help putpdf intro"}{...}
{vieweralsosee "[RPT] putpdf begin" "help putpdf begin"}{...}
{vieweralsosee "[RPT] putpdf paragraph" "help putpdf paragraph"}{...}
{vieweralsosee "[RPT] putpdf table" "help putpdf table"}{...}
{vieweralsosee "[RPT] Appendix for putpdf" "help putpdf appendix"}{...}
{viewerjumpto "Syntax" "putpdf pagebreak##syntax"}{...}
{viewerjumpto "Description" "putpdf pagebreak##description"}{...}
{viewerjumpto "Links to PDF documentation" "putpdf pagebreak##linkspdf"}{...}
{viewerjumpto "Options" "putpdf pagebreak##options"}{...}
{viewerjumpto "Examples" "putpdf pagebreak##examples"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[RPT] putpdf pagebreak} {hline 2}}Add breaks to a PDF file{p_end}
{p2col:}({mansection RPT putpdfpagebreak:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Add page break to document

{p 8 22 2}
{cmd:putpdf pagebreak}


{phang}
Add section break to document

{p 8 22 2}
{cmd:putpdf sectionbreak}
[{cmd:,} {help putpdf_pagebreak##sectionopts:{it:section_options}}]


{marker sectionopts}{...}
{synoptset 28}{...}
{synopthdr:section_options}
{synoptline}
{synopt :{opth page:size(putpdf_pagebreak##section_psize:psize)}}set page size of section{p_end}
{synopt :{opt land:scape}}set section orientation to landscape{p_end}
{synopt :{opth font:(putpdf_pagebreak##fspec:fspec)}}set font, font size, and font color{p_end}
{synopt :{opth halign:(putpdf_pagebreak##section_hvalue:hvalue)}}set horizontal alignment of section{p_end}
{synopt :{cmd:margin(}{help putpdf_pagebreak##section_marg_type:{it:type}}{cmd:,} {it:#}[{help putpdf_pagebreak##unit:{it:unit}}]{cmd:)}}set page margins of section{p_end}
{synopt :{opth bgcolor:(putpdf_pagebreak##color:color)}}set background color{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:putpdf pagebreak} adds a page break to the document, placing subsequent
content on the next page of the document.

{pstd}
{cmd:putpdf} {cmd:sectionbreak} adds a new section to the active document that
starts on the next page.  It lets you vary the page size, orientation, margins,
and other properties of the pages within a single document.  This formatting of
sections is most useful when you want to mix portrait and landscape layouts.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT putpdfpagebreakQuickstart:Quick start}

        {mansection RPT putpdfpagebreakRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{marker section_psize}{...}
{phang}
{opt pagesize(psize)} sets the page size of the section.  {it:psize} may
be {cmd:letter}, {cmd:legal}, {cmd:A3}, {cmd:A4}, {cmd:A5}, {cmd:B4}, or
{cmd:B5}.  The default is {cmd:pagesize(letter)}.

{phang}
{cmd:landscape} changes the section orientation from portrait (the default) to
landscape.

{phang}
{cmd:font(}{it:fontname}
[{cmd:,} {it:size}
[{cmd:,} {it:color}]]{cmd:)}
sets the font, font size, and font color for the document.

{marker fspec}{...}
{phang2}
{it:fontname} may be any supported font installed on the user's computer.  Base
14 fonts, Type 1 fonts, and TrueType fonts with an extension of {cmd:.ttf} and
{cmd:.ttc} are supported.  TrueType fonts that cannot be embedded may not used.
If {it:fontname} includes spaces, then it must be enclosed in double quotes.
The default font is {cmd:Helvetica}.

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
a valid RGB value in the form {it:### ### ###}, for example, {cmd:171 248 103};
or a valid RRGGBB hex value in the form {it:######}, for example, {cmd:ABF867}.

{pmore}
The font size and font color may be specified individually without specifying
{it:fontname}.  Use {cmd:font("",} {it:size}{cmd:)} to specify font size only.
Use {cmd:font("", "",} {it:color}{cmd:)} to specify font color only.  For both
cases, the default font will be used.

{marker section_hvalue}{...}
{phang}
{opt halign(hvalue)} sets the horizontal alignment of the paragraphs, images,
and tables within the section.  {it:hvalue} may be {cmd:left}, {cmd:right}, or
{cmd:center}.  The default is {cmd:halign(left)}.

{marker section_marg_type}{...}
{phang}
{cmd:margin(}{it:type}{cmd:,} {it:#}[{it:unit}]{cmd:)}
sets the page margins of the section.  This option may be specified multiple
times in a single command to account for different margin settings.

{marker type}{...}
{phang2}
{it:type} identifies the location of the margin inside the document.
{it:type} may be {cmd:top}, {cmd:left}, {cmd:bottom}, {cmd:right}, or
{cmd:all}.

{marker unit}{...}
{phang2}
INCLUDE help put_units

{phang}
{opt bgcolor(color)}
sets the background color for the document.  {it:color} may be one of the
colors listed in 
{help putpdf_appendix##Colors:{it:Colors}} of
{helpb putpdf appendix:[RPT] Appendix of putpdf};
a valid RGB value in the form {it:### ### ###}, for example, {cmd:171 248 103};
or a valid RRGGBB hex value in the form {it:######}, for example, {cmd:ABF867}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Create the {cmd:.pdf} document in memory{p_end}
{phang2}{cmd:. putpdf begin}{p_end}

{pstd}Use {cmd:summarize} to obtain summary statistics on {cmd:mpg}{p_end}
{phang2}{cmd:. summarize mpg}{p_end}

{pstd}Add a new paragraph to the active document and append text to it{p_end}
{phang2}{cmd:. putpdf paragraph}{p_end}
{phang2}{cmd:. putpdf text ("In this dataset, there are `r(N)' models of cars.")}{p_end}

{pstd}Begin a new section with one inch margins on the left and right side of
the page{p_end}
	{cmd:. putpdf sectionbreak, margin(left, 1) margin(right, 1)}

{pstd}
Fit a linear regression model of {cmd:mpg} as a function of 
{cmd:weight} and {cmd:foreign}{p_end}
	{cmd:. regress mpg weight foreign}

{pstd}
Export the estimation results to the document as a table with the name {cmd:tbl1}{p_end}
{phang2}{cmd:. putpdf table tbl1 = etable, width(100%)}

{pstd}
Save the document to disk{p_end}
	{cmd:. putpdf save example.pdf}
