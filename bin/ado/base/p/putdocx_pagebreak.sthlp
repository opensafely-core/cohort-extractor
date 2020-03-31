{smcl}
{* *! version 1.0.2  14feb2020}{...}
{vieweralsosee "[RPT] putdocx pagebreak" "mansection RPT putdocxpagebreak"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] putdocx intro" "help putdocx intro"}{...}
{vieweralsosee "[RPT] putdocx begin" "help putdocx begin"}{...}
{vieweralsosee "[RPT] putdocx paragraph" "help putdocx paragraph"}{...}
{vieweralsosee "[RPT] putdocx table" "help putdocx table"}{...}
{vieweralsosee "[RPT] Appendix for putdocx" "help putdocx_appendix"}{...}
{viewerjumpto "Syntax" "putdocx pagebreak##syntax"}{...}
{viewerjumpto "Description" "putdocx pagebreak##description"}{...}
{viewerjumpto "Links to PDF documentation" "putdocx pagebreak##linkspdf"}{...}
{viewerjumpto "Options" "putdocx pagebreak##options"}{...}
{viewerjumpto "Examples" "putdocx pagebreak##examples"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[RPT] putdocx pagebreak} {hline 2}}Add breaks to an Office Open XML
(.docx) file{p_end}
{p2col:}({mansection RPT putdocxpagebreak:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Add page break to document

{p 8 22 2}
{cmd:putdocx pagebreak}


{phang}
Add section break to document

{p 8 22 2}
{cmd:putdocx sectionbreak}
[{cmd:,} {help putdocx_pagebreak##opts:{it:options}}]


{marker opts}{...}
{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt :{opth page:size(putdocx_pagebreak##psize:psize)}}set page size of the
section{p_end}
{synopt :{opt land:scape}}use a landscape orientation for the section{p_end}
{synopt :{opth pagenum:(putdocx_pagebreak##pnspec:pnspec)}}set page number
format{p_end}
{synopt :{opth header:(putdocx_pagebreak##hname:hname)}}add a header{p_end}
{synopt :{opth footer:(putdocx_pagebreak##fname:fname)}}add a footer{p_end}
{synopt :{cmd:margin(}{help putdocx_pagebreak##section_marg_type:{it:type}}{cmd:,} {it:#}[{help putdocx_pagebreak##unit:{it:unit}}]{cmd:)}}set page margins of section{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:putdocx pagebreak} adds a page break to the document, placing subsequent
content on the next page of the document.

{pstd}
{cmd:putdocx} {cmd:sectionbreak} adds a new section to the document and begins
the section on the next page. It lets you vary the formatting of the pages
within a single document. This command is most useful when you want to mix
portrait and landscape layouts or apply different headers and footers across
sections of your document.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT putdocxpagebreakQuickstart:Quick start}

        {mansection RPT putdocxpagebreakRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.



{marker options}{...}
{title:Options}

{marker psize}{...}
{phang}
{opt pagesize(psize)} sets the page size of the section. {it:psize} may
be {cmd:letter}, {cmd:legal}, {cmd:A3}, {cmd:A4}, or {cmd:B4JIS}. The default
is {cmd:pagesize(letter)}.

{phang}
{cmd:landscape} changes the section orientation from portrait (the default) to
landscape.

{marker pnspec}{...}
{phang}
{cmd:pagenum(}{it:pnformat} [{cmd:,} {it:start} [{cmd:,} {it:chapStyle}
[{cmd:,} {it:chapSep}]]]{cmd:)} specifies the format and starting page
for page numbers. 

{phang2}
{it:pnformat}
specifies the page number format, such as decimals enclosed in parentheses or
uppercase Roman numerals.  The default is {cmd:decimal}.  For a complete list,
see {help putdocx appendix##Page_number_formats:{it:Page number formats}} of
{helpb putdocx appendix:[RPT] Appendix for putdocx}.

{phang2}
{it:start}
specifies the starting page number and must be an integer greater than or equal
to 0.  The default is to continue page numbering from the previous section.

{marker chapstyle}{...}
{phang2}
{it:chapStyle}
indicates the style used for chapter headings. 
For a complete list of chapter styles, see
{help putdocx appendix##Chapter_styles:{it:Chapter styles}} of
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
When specifying {it:chapStyle} and {it:chapSep}, chapter numbers will also be
reported along with the page numbers. To activate these options, you must
specify a multilevel list style in Word that includes headings.

{marker hname}{...}
{phang}
{opt header(hname)} adds the header {it:hname} to the section.
The content of {it:hname}, including page numbers, can be defined with either 
{cmd:putdocx paragraph} or {cmd:putdocx table}. {it:hname} must be a valid name
according to Stata's naming conventions; see {findalias frnames}.

{marker fname}{...}
{phang}
{opt footer(fname)} adds the footer {it:fname} to the section.
The content of {it:fname}, including page numbers, can be defined with either 
{cmd:putdocx paragraph} or {cmd:putdocx table}. {it:fname} must be a valid name
according to Stata's naming conventions; see {findalias frnames}.

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


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Create a {cmd:.docx} document in memory{p_end}
{phang2}{cmd:. putdocx begin}{p_end}

{pstd}Use {cmd:summarize} to obtain summary statistics on {cmd:mpg}{p_end}
{phang2}{cmd:. summarize mpg}{p_end}

{pstd}Add a new paragraph to the active document and append text to it{p_end}
{phang2}{cmd:. putdocx paragraph}{p_end}
{phang2}{cmd:. putdocx text ("In this dataset, there are `r(N)' models of cars.")}{p_end}

{pstd}Begin a section with the header "Estimation results"{p_end}
{phang2}{cmd:. putdocx sectionbreak, header(estimates)}{p_end}
{phang2}{cmd:. putdocx paragraph, toheader(estimates)}{p_end}
{phang2}{cmd:. putdocx text ("Estimation results")}{p_end}

{pstd}
Fit a linear regression model of {cmd:mpg} as a function of 
{cmd:weight} and {cmd:foreign}{p_end}
	{cmd:. regress mpg weight foreign}

{pstd}
Export the estimation results to the document as a table with the name {cmd:tbl1}{p_end}
{phang2}{cmd:. putdocx table tbl1 = etable, width(100%)}

{pstd}Begin a section with no header{p_end}
{phang2}{cmd:. putdocx sectionbreak, header(none)}{p_end}
{phang2}{cmd:. putdocx paragraph, toheader(none)}{p_end}
{phang2}{cmd:. putdocx text (" ")}{p_end}

{pstd}Add a new paragraph to the active document and append text to it{p_end}
{phang2}{cmd:. putdocx paragraph}{p_end}
{phang2}{cmd:. putdocx text (" Above we fit a linear regression. ")}{p_end}

{pstd}
Save the document to disk{p_end}
	{cmd:. putdocx save example.docx}
