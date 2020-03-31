{smcl}
{* *! version 1.0.3  18jan2017}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "include_bitmap##syntax"}{...}
{viewerjumpto "Description" "include_bitmap##description"}{...}
{viewerjumpto "Option" "include_bitmap##option"}{...}
{title:Title}

{phang}Set the output behavior when copying an image to the Clipboard
(Mac only)


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
	{cmd:set include_bitmap} {c -(} {cmd:on} | {cmd:off} {c )-} [{cmd:,}
	{opt perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set include_bitmap} sets the output behavior when copying an image to the
Clipboard.  In macOS, the PDF format is the preferred format for images
copied to the Clipboard.  However, many legacy applications, such as Microsoft
Office 2004, do not support PDF images from the Clipboard.  When
{cmd:include_bitmap} is {cmd:on}, Stata copies an image to the Clipboard in
both the PDF format and the TIFF bitmap format.  This allows Stata to provide
the preferred PDF image for modern applications while maintaining
compatibility with legacy applications with a bitmap image.  Bitmap images are
resolution dependent and do not scale or print well.  When possible, use
applications that are compatible with the PDF format for the best possible
output.

{pstd}
Some modern applications, such as PowerPoint from Microsoft Office 2008, will
mistakenly paste in a bitmap image instead of a PDF image from the
Clipboard even if both image formats are available.  Set {cmd:include_bitmap}
to {cmd:off} for Stata to copy only a PDF image to the Clipboard to avoid
this behavior with PowerPoint.  Word from Microsoft Office 2008 does not
exhibit this behavior and will correctly paste in a PDF image if both PDF and
bitmap images are available from the Clipboard.

{pstd}
The default value of {cmd:include_bitmap} is {cmd:on}.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.
