{smcl}
{* *! version 1.1.7  19oct2017}{...}
{viewerdialog list "dialog matrix_list"}{...}
{viewerdialog rename "dialog matrix_rename"}{...}
{viewerdialog drop "dialog matrix_drop"}{...}
{vieweralsosee "[P] matrix utility" "mansection P matrixutility"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matlist" "help matlist"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{viewerjumpto "Syntax" "matrix_utility##syntax"}{...}
{viewerjumpto "Menu" "matrix_utility##menu"}{...}
{viewerjumpto "Description" "matrix_utility##description"}{...}
{viewerjumpto "Links to PDF documentation" "matrix_utility##linkspdf"}{...}
{viewerjumpto "Options" "matrix_utility##options"}{...}
{viewerjumpto "Examples" "matrix_utility##examples"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[P] matrix utility} {hline 2}}List, rename, and drop matrices{p_end}
{p2col:}({mansection P matrixutility:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    List matrix names

	{cmdab:mat:rix} {cmdab:d:ir}


    List contents of matrix

{p 8 20 2}{cmdab:mat:rix} {cmdab:l:ist} {it:mname} [{cmd:,} {cmdab:nob:lank}
{cmdab:noha:lf} {cmdab:noh:eader} {cmdab:non:ames}
{opth f:ormat(%fmt)} {cmdab:t:itle:(}{it:{help strings:string}}{cmd:)}
{cmd:nodotz}]


    Rename matrix

{p 8 15 2}{cmdab:mat:rix} {cmdab:ren:ame} {it:oldname} {it:newname}


    Drop matrix

{p 8 15 2}{cmdab:mat:rix} {cmd:drop} {c -(} {cmd:_all} | {it:mnames} {c )-}


{marker menu}{...}
{title:Menu}

    {title:matrix list}

{phang2}
{bf:Data > Matrices, ado language > List contents of matrix}

    {title:matrix rename}

{phang2}
{bf:Data > Matrices, ado language > Rename matrix}

    {title:matrix drop}

{phang2}
{bf:Data > Matrices, ado language > Drop matrices}


{marker description}{...}
{title:Description}

{pstd}
{cmd:matrix dir} lists the names of currently existing matrices.
{cmd:matrix list} lists the contents of a matrix.  {cmd:matrix rename} changes
the name of a matrix.  {cmd:matrix} {cmd:drop} eliminates a matrix.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P matrixutilityRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:noblank} suppresses printing a blank line before printing the
matrix.  This is useful in programs.

{phang}
{cmd:nohalf} specifies that, even if the matrix is symmetric, the full
matrix be printed.  The default is to print only the lower triangle in
such cases.

{phang}
{cmd:noheader} suppresses the display of the matrix name and dimension
before the matrix itself.  This is useful in programs.

{phang}
{cmd:nonames} suppresses the display of the bordering names around the
matrix.

{phang}
{opth format:(%fmt)} specifies the format to be used to
display the individual elements of the matrix.  The default is
{cmd:format(%10.0g)}.

{phang}
{cmd:title(}{it:{help strings:string}}{cmd:)} adds the specified title
{it:string} to the header displayed before the matrix itself.  If
{cmd:noheader} is specified, {cmd:title()} does nothing because displaying the
header is suppressed.

{phang}
{cmd:nodotz} specifies that {cmd:.z} missing values be displayed as blanks.


{marker examples}{...}
{title:Examples}

    {cmd:. mat b = (2, 5, 4\ 5, 8, 6\ 4, 6, 3)}
    {cmd:. mat a = (1, 2 \ 2, 4)}
    {cmd:. matrix dir}
    {cmd:. matrix rename a z}
    {cmd:. matrix dir}
    {cmd:. matrix list b}
    {cmd:. matrix list b, nohalf}
    {cmd:. matrix drop b}
    {cmd:. matrix dir}
    {cmd:. matrix drop _all}
    {cmd:. matrix dir}
