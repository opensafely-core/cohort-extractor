{smcl}
{* *! version 1.2.6  19oct2017}{...}
{vieweralsosee "[P] matlist" "mansection P matlist"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "[P] matrix utility" "help matrix_utility"}{...}
{viewerjumpto "Syntax" "matlist##syntax"}{...}
{viewerjumpto "Description" "matlist##description"}{...}
{viewerjumpto "Links to PDF documentation" "matlist##linkspdf"}{...}
{viewerjumpto "Style options" "matlist##options_style"}{...}
{viewerjumpto "General options" "matlist##options_general"}{...}
{viewerjumpto "Required options for the second syntax" "matlist##required"}{...}
{viewerjumpto "Examples" "matlist##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[P] matlist} {hline 2}}Display a matrix and control its format{p_end}
{p2col:}({mansection P matlist:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    One common display format for every column

{p 8 16 2}{cmd:matlist} {it:matrix_exp}
[{cmd:,} {it:{help matlist##style_options_table:style_options}}
{it:{help matlist##general_options_table:general_options}}]


    Each column with its own display format

{p 8 16 2}{cmd:matlist} {it:matrix_exp} {cmd:,}
{opth csp:ec(matlist##cspec:cspec)}
{opth rsp:ec(matlist##rspec:rspec)}
[{it:{help matlist##general_options_table:general_options}}]


{p2colset 5 28 30 2}{...}
{p2col:{marker style_options_table}{it:style_options}}Description{p_end}
{p2line}
{p2col:{opth lin:es(matlist##lstyle:lstyle)}}lines style; default between
	headers/labels and data{p_end}
{p2col:{opth bor:der(matlist##bspec:bspec)}}border style; default none{p_end}
{p2col:{opt bor:der}}same as {cmd:border(all)}{p_end}
{p2col:{opth for:mat(%fmt)}}display format; default is {cmd:format(%9.0g)}{p_end}
{p2col:{opt tw:idth(#)}}row-label width; default is {cmd:twidth(12)}{p_end}
{p2col:{opt left(#)}}left indent for tables; default is {cmd:left(0)}{p_end}
{p2col:{opt right(#)}}right indent for tables; default is {cmd:right(0)}{p_end}
{p2line}

{p2col:{marker lstyle}{it:lstyle}}Lines are drawn ...{p_end}
{p2line}
{p2col:{opt o:neline}}between headers/labels and data; default with no
	equations{p_end}
{p2col:{opt eq}}between equations; default when equations are present{p_end}
{p2col:{opt rowt:otal}}same as {cmd:oneline} plus line before last row{p_end}
{p2col:{opt colt:otal}}same as {cmd:oneline} plus line before last column{p_end}
{p2col:{opt rct:otal}}same as {cmd:oneline} plus line before last row and column{p_end}
{p2col:{opt r:ows}}between all rows; between row labels and data{p_end}
{p2col:{opt co:lumns}}between all columns; between column header and data{p_end}
{p2col:{opt ce:lls}}between all rows and columns{p_end}
{p2col:{opt n:one}}suppress all lines{p_end}
{p2line}

{p2col:{marker bspec}{it:bspec}}Border lines are drawn ...{p_end}
{p2line}
{p2col:{opt n:one}}no border lines are drawn; the default{p_end}
{p2col:{opt all}}around all four sides{p_end}
{p2col:{opt row:s}}at the top and bottom{p_end}
{p2col:{opt col:umns}}at the left and right{p_end}
{p2col:{opt l:eft}}at the left{p_end}
{p2col:{opt r:ight}}at the right{p_end}
{p2col:{opt t:op}}at the top{p_end}
{p2col:{opt b:ottom}}at the bottom{p_end}
{p2line}

{p2col:{marker general_options_table}{it:general_options}}Description{p_end}
{p2line}
{p2col:{opth tit:le(strings:string)}}title displayed above table{p_end}
{p2col:{opt tind:ent(#)}}indent title {it:#} spaces{p_end}
{p2col:{opth row:title(strings:string)}}title to display above row names{p_end}
{p2col:{cmdab:nam:es:(}{cmdab:r:ows}{cmd:)}}display row names{p_end}
{p2col:{cmdab:nam:es:(}{cmdab:c:olumns}{cmd:)}}display column names{p_end}
{p2col:{cmdab:nam:es:(}{cmdab:a:ll}{cmd:)}}display row and column names; the
	default{p_end}
{p2col:{cmdab:nam:es:(}{cmdab:n:one}{cmd:)}}suppress row and column names{p_end}
{p2col:{opt nonam:es}}same as {cmd:names(none)}{p_end}
{p2col:{opth showcoleq:(matlist##ceq:ceq)}}specify how column equation names
	are displayed{p_end}
{p2col:{opt roweqonly}}display only row equation names{p_end}
{p2col:{opt coleqonly}}display only column equation names{p_end}
{p2col:{cmd:colorcoleq(}{cmdab:t:xt}|{cmdab:r:es}{cmd:)}}display mode (color)
	for column equation names; default is {cmd:txt}{p_end}
{p2col:{cmd:keepcoleq}}keep columns of the same equation together{p_end}
{p2col:{cmd:aligncolnames(}{cmdab:r:align}{cmd:)}}right-align column names{p_end}
{p2col:{cmd:aligncolnames(}{cmdab:l:align}{cmd:)}}left-align column names{p_end}
{p2col:{cmd:aligncolnames(}{cmdab:c:enter}{cmd:)}}center column names{p_end}
{p2col:{opt nob:lank}}suppress blank line before tables{p_end}
{p2col:{opt noha:lf}}display full matrix even if symmetric{p_end}
{p2col:{opt nodotz}}display missing value {cmd:.z} as blank{p_end}
{p2col:{opt under:score}}display underscores as blanks in row and column names{p_end}
{p2col:{opt linesize(#)}}overrule {cmd:linesize} setting{p_end}
{p2line}

{p2col:{marker ceq}{it:ceq}}Equation names are displayed{p_end}
{p2line}
{p2col:{opt f:irst}}over the first column only; the default{p_end}
{p2col:{opt e:ach}}over each column{p_end}
{p2col:{opt c:ombined}}centered over all associated columns{p_end}
{p2col:{opt l:combined}}left-aligned over all associated columns{p_end}
{p2col:{opt r:combined}}right-aligned over all associated columns{p_end}
{p2line}


{marker description}{...}
{title:Description}

{pstd}
{cmd:matlist} displays a matrix, allowing you to control the display format.
Row and column names are used as the row and column headers.  Equation names
are displayed in a manner similar to estimation results.

{pstd}
Columns may have different formats, and lines may be shown between each 
column.  You cannot format rows of the matrix differently.

{pstd}
{cmd:matlist} is an extension of the {cmd:matrix list} command
(see {helpb matrix utility:[P] matrix utility}).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P matlistRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_style}{...}
{title:Style options}

{phang}
{opt lines(lstyle)}
specifies where lines are drawn in the display of {it:matrix_exp}.  The
following values of {it:lstyle} are allowed:

{phang2}{opt oneline}
draws lines separating the row and column headers from the numerical entries.
This is the default if the {it:matrix_exp} has no equation names.

{phang2}{opt eq}
draws horizontal and vertical lines between equations.
This is the default if the {it:matrix_exp} has row or column equation names.

{phang2}{opt rowtotal}
is the same as {cmd:oneline} and has a line separating the last
row (the totals) from the rest.

{phang2}{opt coltotal}
is the same as {cmd:oneline} and has a line separating the last
column (the totals) from the rest.

{phang2}{opt rctotal}
is the same as {cmd:oneline} and has lines separating the last
row and column (the totals) from the rest.

{phang2}{opt rows}
draws horizontal lines between all rows and one vertical line between the
row-label column and the first column with numerical entries.

{phang2}{opt columns}
draws vertical lines between all columns and one horizontal line between the
headers and the first numeric row.

{phang2}{opt cells}
draws horizontal and vertical lines between all rows and columns.

{phang2}{opt none} suppresses all horizontal and vertical lines.

{phang}{cmd:border}[{cmd:(}{it:bspec}{cmd:)}]
specifies the type of border drawn around the table.  {it:bspec} is any
combination of the following values:

{space 12}{opt none} {space 4} draws no outside border lines; the default
{space 12}{opt all} {space 5} draws all four outside border lines
{space 12}{opt rows} {space 4} draws horizontal lines in the top and bottom margins
{space 12}{opt columns} {space 1} draws vertical lines in the left and right margins
{space 12}{opt left} {space 4} draws a line in the left margin
{space 12}{opt right} {space 3} draws a line in the right margin
{space 12}{opt top} {space 5} draws a line in the top margin
{space 12}{opt bottom} {space 2} draws a line in the bottom margin

{pmore}
{cmd:border} without an argument is equivalent to {cmd:border(all)}, or,
equivalently, {cmd:border(left right top bottom)}.

{phang}{opth format(%fmt)}
specifies the format for displaying the individual elements of the
matrix.  The default is {cmd:format(%9.0g)}.

{phang}{opt twidth(#)}
specifies the width of the row-label column (first column).  The default is
{cmd:twidth(12)}.

{phang}{opt left(#)}
specifies that the table be indented {it:#} spaces; the default is
{cmd:left(0)}.  To indent the title, see the
{helpb matlist##tindent():tindent()} option.

{phang}{opt right(#)}
specifies that the right margin of the table be {it:#} spaces in
from the page margin.  The default is {cmd:right(0)}.  The right margin
affects the number of columns that are displayed before wrapping.


{marker options_general}{...}
{title:General options}

{phang}{opth title:(strings:string)}
adds {it:string} as the title displayed before the matrix.
{cmd:matlist} has no default title or header.

{marker tindent()}{...}
{phang}{opt tindent(#)}
specifies the indentation for the title; the default is {cmd:tindent(0)}.

{phang}{opth rowtitle:(strings:string)}
specifies that {it:string} be used as a column header for the row labels.
This option is allowed only when both row and column labels are displayed.

{marker names()}{...}
{phang}{cmd:names(}{cmd:rows}|{cmd:columns}|{cmd:all}|{cmd:none}{cmd:)}
specifies whether the row and column names are displayed; the default is
{cmd:names(all)}, which displays both.

{phang}{opt nonames}
suppresses row and column names and is a synonym for {cmd:names(none)}.

{phang}{opt showcoleq(ceq)} 
specifies how column equation names are displayed.  The following {it:ceq} are
allowed:

{phang2}{opt f:irst} displays an equation name over the first column 
associated with the name; this is the default. 

{phang2}{opt e:ach} displays an equation name over each column. 

{phang2}{opt c:ombined} displays an equation name centered over all 
columns associated with that name. 

{phang2}{opt l:combined} displays an equation name left-aligned over all 
columns associated with that name.

{phang2}{opt r:combined} displays an equation name right-aligned over all 
columns associated with that name. 

{pmore}
If necessary, equation names are truncated to the width of the field in 
which the names are displayed.  With {opt combined}, {opt lcombined}, and 
{opt rcombined}, the field comprises all columns and the associated 
separators for the equation. 

{phang}{opt roweqonly} specifies that only row equation names be displayed
in the output.  This option may not be combined with {cmd:names(columns)}, 
{cmd:names(none)}, or {opt nonames}.

{phang}{opt coleqonly} specifies that only column equation names be displayed
in the output.  This option may not be combined with {cmd:names(rows)}, 
{cmd:names(none)}, or {opt nonames}.

{phang}{cmd:colorcoleq(}{cmd:txt}|{cmd:res}{cmd:)}
specifies the mode (color) used for the column equation names that appear
in the first displayed row.  Specifying {cmd:txt} (the default) displays the
equation name in the same color used to display text.  Specifying {cmd:res}
displays the name in the same color used to display results.

{phang}{cmd:keepcoleq}
specifies that columns of the same equation should be kept together if
possible.

{phang}{cmd:aligncolnames(}{cmd:ralign}|{cmd:lalign}|{cmd:center}{cmd:)} 
specifies the alignment for the column names.  {cmd:ralign} indicates
alignment to the right, {cmd:lalign} indicates alignment to the left, and
{cmd:center} indicates centering.  {cmd:aligncolnames(ralign)} is the default.

{phang}{opt noblank}
suppresses printing a blank line before the matrix.  This is useful
in programs.

{phang}{opt nohalf}
specifies that, even if the matrix is symmetric, the full matrix be
printed.  The default is to print only the lower triangle in such cases.

{phang}{opt nodotz}
specifies that {cmd:.z} {help missing} values should be listed as a field of
blanks rather than as {cmd:.z}.

{phang}{opt underscore}
converts underscores to blanks in row and column names.

{phang}{opt linesize(#)}
specifies the width of the page for formatting the table.
Specifying a value of {cmd:linesize()} wider than your screen width can produce
truly ugly output on the screen, but that output can nevertheless be useful
if you are logging output and later plan to print the log on a wide printer.


{marker required}{...}
{title:Required options for the second syntax}

{phang}{marker cspec}{opt cspec(cspec)}
specifies the formatting of the columns and the separators of the columns,

{pmore}
where {it:cspec} is {space 4} [{it:sep} [{it:qual}] {cmd:%}{it:#}{cmd:s}]
{it:sep} {it:nspec} [{it:nspec} [...]]

{pmore}
and where {it:sep} is {space 6} [{cmd:o}{it:#}] {cmd:&}|{cmd:|} [{cmd:o}{it:#}]

{col 23}{c TLC}{hline 23}{c TRC}
{col 9}{it:qual} is{...}
{col 23}{c |}{it:qual}     Description   {c |}
{col 23}{c LT}{hline 23}{c RT}
{col 23}{c |} {cmd:s}       standard font {c |}
{col 23}{c |} {cmd:b}       boldface font {c |}
{col 23}{c |} {cmd:i}       italic font   {c |}
{col 23}{c |} {cmd:t}       text mode     {c |}
{col 23}{c |} {cmd:e}       error mode    {c |}
{col 23}{c |} {cmd:c}       command mode  {c |}
{col 23}{c |} {cmd:L}       left-aligned  {c |}
{col 23}{c |} {cmd:R}       right-aligned {c |}
{col 23}{c |} {cmd:C}       centered      {c |}
{col 23}{c |} {cmd:w}{it:#}      field width {it:#} {c |}
{col 23}{c BLC}{hline 23}{c BRC}

{pmore}
{it:nspec} is {space 4} [{it:qual}] {it:nfmt sep}

{pmore}
and {it:nfmt} is {space 1} {cmd:%}{it:#}{cmd:.}{it:#}{{cmd:f}|{cmd:g}}

{pmore}
The first (optional) part, [{it:spec} [{it:qual}] {cmd:%}{it:#s}], of
{it:cspec} specifies the formatting for the column containing row names.  It
is required if the row names are part of the display; see the 
{helpb matlist##names():names()} option.  The number of {it:nspec}s should
equal the number of columns of {it:matname}.

{pmore}
In a separator specification, {it:sep}, {cmd:|} specifies that a vertical line
be drawn.  {cmd:&} specifies that no line be drawn.  The number of
spaces before and after the separator may be specified with {cmd:o}{it:#};
these default to one space, except that by default no spaces are included before
the first column and after the last column.

{pmore}Here are examples for a matrix with two columns (three columns when you
count the column containing the row labels):

{phang3}
{cmd:cspec(& %16s & %9.2f & %7.4f &)}
{break}
specifies that the first column, containing
row labels, be displayed using 16 characters; the second column,
with format {cmd:%9.2f}; and the third column, with format {cmd:%7.4f}.
No vertical lines are drawn.  The number of spaces before and after the
table is 0.  Columns are separated with two spaces.

{phang3}
{cmd:cspec(&o2 %16s o2&o2 %9.2f o2&02 %7.4f o2&)}
{break}
specifies more white around the columns (two spaces everywhere, for a total
of four spaces between columns).

{phang3}
{cmd:cspec(|%16s|%9.2f|%7.4f|)}
{break}
displays the columns in the same way as the first example but
draws vertical lines before and after each column.

{phang3}
{bind:{cmd:cspec(| b %16s | %9.2f & %7.4f |)}}
{break}
specifies that vertical lines
be drawn before and after all columns, except between the two columns with
numeric entries.  The first column is displayed in the boldface font.

{phang}{marker rspec}{opt rspec(rspec)}
specifies where horizontal lines be drawn.  {it:rspec} consists of a
sequence of characters, optionally separated by white space.  {cmd:-} (or
synonym {cmd:|}) specifies that a line be drawn.  {cmd:&} indicates that no
line be drawn.  When {it:matname} has r rows, r+2 characters are
required if column headers are displayed, and r+1 characters are required
otherwise.  The first character specifies whether a line is to be drawn before
the first row of the table; the second, whether a line is to be drawn between
the first and second row, etc.; and the last character, whether a line is to be
drawn after the last row of the table.

{pmore}
You cannot add blank lines before or after the horizontal lines.

{pmore}For example, in a table with column headers and three numeric rows,

{phang3}
{cmd:rspec(||&&|)} {space 2} or equivalently {space 2} {cmd:rspec(--&&-)}
{break}
specifies that horizontal lines be drawn before the first
and second rows and after the last row, but not elsewhere.


{marker examples}{...}
{title:Examples}

    All numeric columns formatted the same

{p 8 16 2}
{cmd:. matrix A = (1, 2 \ 3, 4 \ 5, 6)}

{p 8 16 2}
{cmd:. matrix list A}

{p 8 16 2}
{cmd:. matlist A}

{p 8 16 2}
{cmd:. matlist A, border(rows) rowtitle(rows) left(4)}

{p 8 16 2}
{cmd:. matlist 2*A, border(all) lines(none) format(%6.1f) names(rows)}
          {cmd:twidth(8) left(4) title(Guess what, a title)}

    All numeric columns formatted differently
    
        {cmd:. matrix Htest = (  12.30,  2,  .00044642  \ }
                             {cmd:2.17,  1,  .35332874  \ }                   
			     {cmd:8.81,  3,  .04022625  \ }
			    {cmd:20.05,  6,  .00106763  )}

{p 8 16 2}
{cmd:. matrix rownames Htest = trunk length weight overall}

{p 8 16 2}
{cmd:. matrix colnames Htest = chi2 df p}

{p 8 16 2}
{cmd:. matrix list Htest}

{p 8 16 2}
{cmd:. matlist Htest}

{p 8 16 2}
{cmd:. matlist Htest, rowtitle(Variables) title(Test results)}
       {bind:{cmd:cspec(o4& %12s | %8.0g & %5.0f & %8.4f o2&)}}
       {bind:{cmd:rspec(&-&&--)}}

    With extended missing values

{p 8 16 2}
{cmd:. matrix Z = ( .z, 1 \ .c, .z )}

{p 8 16 2}
{cmd:. matrix rownames Z = row_1 row_2}

{p 8 16 2}
{cmd:. matrix colnames Z = col1 col2}

{p 8 16 2}
{cmd:. matlist Z}

{p 8 16 2}
{cmd:. matlist Z, nodotz underscore}
{p_end}
