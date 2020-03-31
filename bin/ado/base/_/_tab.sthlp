{smcl}
{* *! version 1.2.0  25apr2017}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] class" "help class"}{...}
{vieweralsosee "[P] ereturn" "help ereturn"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _coef_table" "help _coef_table"}{...}
{viewerjumpto "Syntax" "_tab##syntax"}{...}
{viewerjumpto "Description" "_tab##description"}{...}
{viewerjumpto "Options for .new and .reset" "_tab##options_new"}{...}
{viewerjumpto "Options for .width" "_tab##options_width"}{...}
{viewerjumpto "Options for .sep" "_tab##options_sep"}{...}
{viewerjumpto "A note about colors" "_tab##note"}{...}
{viewerjumpto "Examples" "_tab##examples"}{...}
{title:Title}

{p 4 18 2}
{hi:[P] _tab} {hline 2} Generating simple tables


{marker syntax}{...}
{title:Syntax}

{pstd}
Declaring a {cmd:_tab} object:

{p 8 27 2}
{cmd:.}{it:obj} = {cmd:._tab.new} [{cmd:,} {it:options} ]


{pstd}
Setting default parameters:

{p 8 22 2}
{cmd:.}{it:obj}{cmd:.reset} [{cmd:,} {it:options} ]

	{cmd:.}{it:obj}{cmd:.width}{col 26}{...}
{it:width_1} ...   {it:width_k} [{cmd:,} {opt noref:ormat} ]

	{cmd:.}{it:obj}{cmd:.titlefmt}{col 26}{...}
 {it:sfmt_1} ...    {it:sfmt_k}

	{cmd:.}{it:obj}{cmd:.strfmt}{col 26}{...}
 {it:sfmt_1} ...    {it:sfmt_k}

	{cmd:.}{it:obj}{cmd:.numfmt}{col 26}{...}
 {it:nfmt_1} ...    {it:nfmt_k}

	{cmd:.}{it:obj}{cmd:.pad}{col 26}{...}
      {it:#} ...         {it:#}

	{cmd:.}{it:obj}{cmd:.ignore}{col 26}{...}
 {it:item_1} ...    {it:item_k}

	{cmd:.}{it:obj}{cmd:.titlecolor}{col 26}{...}
{it:color_1} ...   {it:color_k}

	{cmd:.}{it:obj}{cmd:.strcolor}{col 26}{...}
{it:color_1} ...   {it:color_k}

	{cmd:.}{it:obj}{cmd:.numcolor}{col 26}{...}
{it:color_1} ...   {it:color_k}


{pstd}
Displaying table elements:

{pmore}
{cmd:.}{it:obj}{cmd:.sep}
	[{cmd:,} {opt t:op} {opt m:iddle} {opt b:ottom} ]

	{cmd:.}{it:obj}{cmd:.titles}{col 24}{...}
  {it:title_1} ...   {it:title_k}

	{cmd:.}{it:obj}{cmd:.row}{col 24}{...}
{it:element_1} ... {it:element_k}


{pstd}
Miscellaneous information:

{pmore}
{cmd:.}{it:obj}{cmd:.width_of_table}


{pstd}
Post table information to {cmd:r()}:

	{cmd:.}{it:obj}{cmd:.post_results}


{p2colset 9 31 35 2}{...}
{p2col :{it:options}}Description{p_end}
{p2line}
{p2col :{opt w:idth(#)}}default column width; default is 12{p_end}
{p2col :{opt col:umns(#)}}number of columns; default is 2{p_end}
{p2col :{opt lm:argin(#)}}left margin; default is 2{p_end}
{p2col :{opt tc:olor(color)}}default
	color for titles; default is {opt text}{p_end}
{p2col :{opt nc:olor(color)}}default
	color for numbers; default is {opt input}{p_end}
{p2col :{opt sc:olor(color)}}default
	color for strings; default is {opt text}{p_end}
{p2col :{opt lc:olor(color)}}color
	of the separator lines; default is {opt text}{p_end}
{p2col :{opt tf:mt(sfmt)}}default title format{p_end}
{p2col :{opt nf:mt(nfmt)}}default numeric format{p_end}
{p2col :{opt sf:mt(sfmt)}}default string format{p_end}
{p2col :{opt nocom:mas}}do
	not use comma in default numeric formats; default behavior{p_end}
{p2col :{opt com:mas}}use comma in default numeric formats{p_end}
{p2col :{opt ig:nore(item)}}ignore
	{it:item} if supplied as an argument to {cmd:.row}{p_end}
{p2col :{opt sep:arator(#)}}automatically
	separate every {it:#} rows; default is 0, no separator{p_end}
{p2col :{opt puttab(name)}}name
	for Mata object used by {cmd:post_results}; default is
	{cmd:_putTab}{p_end}
{p2col :{opt clear(clear_options)}}clear the specified parameters{p_end}
{p2col :{opt clear}}synonym for {cmd:clear(all)}{p_end}
{p2line}

{p2col :{it:clear_options}}Description{p_end}
{p2line}
{p2col :{opt w:idths}}clear the column widths{p_end}
{p2col :{opt tc:olors}}clear the title colors{p_end}
{p2col :{opt nc:olors}}clear the number colors{p_end}
{p2col :{opt sc:olors}}clear the string colors{p_end}
{p2col :{opt tf:mts}}clear the title formats{p_end}
{p2col :{opt nf:mts}}clear the number formats{p_end}
{p2col :{opt sf:mts}}clear the string formats{p_end}
{p2col :{opt p:addings}}clear the column paddings{p_end}
{p2col :{opt v:separators}}remove the vertical separators{p_end}
{p2col :{opt row:s}}reset the row counter to zero{p_end}
{p2col :{opt c:olumns}}reset the column starting positions{p_end}
{p2col :{opt f:mts}}reset the default formats{p_end}
{p2col :{opt all}}shortcut for specifying all the above{p_end}
{p2line}

{p2col :Column arguments}Description{p_end}
{p2line}
{p2col :{it:width_#}}column width{p_end}
{p2col :{it:title_#}}column title{p_end}
{p2col :{it:nfmt_#}}numeric format; see {manhelp format D}{p_end}
{p2col :{it:sfmt_#}}string format; see {manhelp format D}{p_end}
{p2col :{it:color_#}}{opt text} (or {opt txt}),
	{opt err:or}, {opt res:ult}, or {opt inp:ut}{p_end}
{p2col :{it:item_#}}string or value, including a missing value{p_end}
{p2col :{it:element_#}}quoted string or expression{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Note when the column argument is {cmd:.} or {cmd:""}, the default value is
used.  For {it:element_#} in {cmd:.row}, {cmd:""} (the empty string) causes
nothing to be displayed for the specific column, but {cmd:.} is interpreted as
a missing value resulting from an expression.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_tab} is a programmer's tool for generating simple tables.  Generating a
table using an object from class {cmd:_tab} involves several steps:

{phang}
1.  Create an object from class {cmd:_tab}.

{pmore}
{cmd:_tab.new} returns an object from class {cmd:_tab}.  To create a
{cmd:_tab} object, type the following:

{pmore2}
{cmd:.}{it:obj} = {cmd:._tab.new}

{pmore}
where {it:obj} is a name of your choosing.

{phang}
2.  Set the default table parameters (this could also have been done with
{cmd:._tab.new}).

{pmore}
{cmd:.reset} changes the table parameters.  For example,

{pmore2}
{cmd:.}{it:obj}{cmd:.reset, columns(7) lmargin(0)}

{pmore}
changes the number of columns in {cmd:.}{it:obj} to 7 and removes the left
margin.  This matches the number of columns produced by
{helpb ereturn display}.

{phang}
3.  Set the individual column widths.

{pmore}
{cmd:.width} sets the widths for each individual column.
{cmd:.width} requires an argument for each column.
To set column widths that match those produced by
{cmd:ereturn} {cmd:display}, type

{pmore2}
{cmd:.}{it:obj}{cmd:.width 13 |. . 8 8 . .}

{pmore}
The first column is now 13 characters wide, the fourth and fifth columns are
now 8 characters wide, and the other columns remain at 12 characters (the
default width).
Notice the vertical bar ({cmd:|}) specified between the first and second
column widths, this indicates that the first and second columns are to be
separated by a vertical line.

{pmore}
By default, {cmd:.width} will generate a default title, numeric, and string
format for each column; the {opt noreformat} option prevents this.

{phang}
4.  Set the title format for each column.

{pmore}
{cmd:.titlefmt} sets the string format for the title of each
individual column.
{cmd:.titlefmt} requires an argument for each column.
To set title formats that match those of {cmd:ereturn}
{cmd:display}, type 

{pmore2}
{cmd:.}{it:obj}{cmd:.titlefmt . . . %6s . %24s .}

{pmore}
The fourth column title (for the {it:t} or {it:z} statistic) has format %6s,
leaving two extra spaces to the right of the title, the sixth column title
format is stretched to consume the seventh column title, and the other formats
remain as they were set.

{pmore}
Note:  The {cmd:.width} routine will reset the individual title
formats to {cmd:%}{it:w}{cmd:s}, where {it:w} is one less than the column
width; {cmd:.titlefmt} should be used after {cmd:.width}.

{phang}
5.  Set the string format for each column.

{pmore}
{cmd:.strfmt} sets the string format for each individual column.
{cmd:.strfmt} requires an argument for each column.
To set string formats that match those of {cmd:ereturn}
{cmd:display}, type 

{pmore2}
{cmd:.}{it:obj}{cmd:.strfmt . . . . . . .}

{pmore}
Here we did not even have to use {cmd:.strfmt}
because the only string {cmd:ereturn} {cmd:display} prints in the table body
is the name of the coefficient, and the default string format already matches.

{pmore}
Note:  The {cmd:.width} routine will reset the individual string
formats to {cmd:%}{it:w}{cmd:s}, where {it:w} is one less than the column
width; {cmd:.strfmt} should be used after {cmd:.width}.

{phang}
6.  Set the number format for each column.

{pmore}
{cmd:.numfmt} sets the numeric format for each individual column.
{cmd:.numfmt} requires an argument for each column.
To set numeric formats that match those of {cmd:ereturn}
{cmd:display}, type 

{pmore2}
{cmd:.}{it:obj}{cmd:.numfmt . %9.0g %9.0g %7.2f %5.3f %9.0g %9.0g}

{pmore}
Note:  The {cmd:.width} routine will reset the individual numeric
formats to {cmd:%}{it:w}{cmd:.0g}, where {it:w} is one less than the column
width; {cmd:.numfmt} should be used after {cmd:.width}.

{phang}
7.  Set the padding for numeric formats for each column.  The default numeric
formats use up all but the last space of each column.  To keep smaller
numeric formats right justified within a column, the column must have padded
spaces on the left.

{pmore}
{cmd:.pad} sets the padding spaces associated with the numeric format
for each individual column.
{cmd:.pad} requires an argument for each column.
To set paddings that match those of {cmd:ereturn}
{cmd:display}, type 

{pmore2}
{cmd:.}{it:obj}{cmd:.pad . 2 1 . 2 3 3}

{phang}
8.  Set the ignore item for each column.

{pmore}
{cmd:.ignore} sets the item to be ignored for each column.  Typically this
would be one of the missing value codes, but it could be a string such as
"NA".  This setting is most useful when the table elements were built up and
placed into a matrix where one or more values (usually missing) identify
empty cells.

{phang}
9.  Set the title color for each column.

{pmore}
{cmd:.titlecolor} sets the color for the title of each
individual column.
{cmd:.titlecolor} requires an argument for each column.
The default title color is {opt text}, which already matches that of
{cmd:ereturn} {cmd:display}.  To make the title of the first column
{opt result}, type

{pmore2}
{cmd:.}{it:obj}{cmd:.titlecolor result . . . . . .}

{phang}
10. Set the string color for each column.

{pmore}
{cmd:.strcolor} sets the color for strings in each individual column.
{cmd:.strcolor} requires an argument for each column.
The default string color is {opt text}, which already matches that of
{cmd:ereturn} {cmd:display}.  To make the strings in the second column
{opt result}, type

{pmore2}
{cmd:.}{it:obj}{cmd:.strcolor . result . . . . .}

{phang}
11. Set the number color for each column.

{pmore}
{cmd:.numcolor} sets the color of numbers in each individual column.
{cmd:.numcolor} requires an argument for each column.
The default number color is {opt text}, which already matches that of
{cmd:ereturn} {cmd:display}.  To make the numbers in the last two columns
{opt input}, type

{pmore2}
{cmd:.}{it:obj}{cmd:.numcolor . . . . . input input}

{phang}
12. Display the table elements, row by row.

{pmore}
{cmd:.sep} will display a horizontal line.  It respects the vertical
separators specified in {cmd:.width}.

{pmore}
{cmd:.titles} displays the specified titles.
{cmd:.titles} requires an argument for each column.
To display titles that match those of {cmd:ereturn} {cmd:display}, type

{p 12 16 2}
{cmd:.}{it:obj}{cmd:.titles "" "Coef." "Std. Err." "t" "P>|t|" "[95% Conf. Interval]" ""}

{pmore}
{cmd:.row} displays a row in the body of the table.
{cmd:.row} requires an argument for each column.
Strings are expected to be bound in double quotes (or compound double quotes).
Expressions with spaces are expected to be bound in parentheses.

{pmore}
To display the row for variable {cmd:mpg} from a regression fit, type

{p 12 16 2}
{cmd:.}{it:obj}{cmd:.row "mpg" _b[mpg] _se[mpg] (_b[mpg]/_se[mpg])}{break}
{cmd:2*ttail(e(df_r),abs(_b[mpg]/_se[mpg]))}{break}
{cmd:_b[mpg]-_se[mpg]*invttail(e(df_r),.025)}{break}
{cmd:_b[mpg]+_se[mpg]*invttail(e(df_r),.025)}

{phang}
13. Get the width of the table.

{pmore2}
{cmd:local w =} {cmd:`.}{it:obj}{cmd:.width_of_table'}

{phang}
or

{pmore2}
{cmd:.}{it:obj}{cmd:.width_of_table}{break}
{cmd:local w = s(width)}

{phang}
14. Post table information to {cmd:r()}.

{p 12 16 2}
{cmd:.}{it:obj}{cmd:.post_results} [{it:prefix} [{it:suffix}]]


{marker options_new}{...}
{title:Options for .new and .reset}

{phang}
{opt width(#)} specifies the default column width to be {it:#} characters
wide.  Initially the default is 12 characters.

{phang}
{opt columns(#)} specifies the number of columns in the table.  Initially the
default is 2 columns.

{phang}
{opt lmargin(#)} specifies the left margin, which is the number of spaces the
table is indented.  The default left margin is 2 spaces.

{phang}
{opt tcolor(color)} specifies the default title color.  Initially the default
is {opt text}.

{phang}
{opt ncolor(color)} specifies the default color for numbers.  Initially the
default is {opt result}.

{phang}
{opt scolor(color)} specifies the default color for strings.  Initially the
default is {opt text}.

{phang}
{opt lcolor(color)} specifies the default color of the separator lines.
Initially the default is {opt text}.

{phang}
{opt tfmt(sfmt)} specifies the default title format.  Initially the
default is determined from the column width.

{phang}
{opt nfmt(nfmt)} specifies the default numeric format.  Initially the
default is determined from the column width.

{phang}
{opt sfmt(sfmt)} specifies the default string format.  Initially the
default is determined from the column width.

{phang}
{opt nocommas} indicates that commas are not to be used in the default numeric
format.  Initially, this is the default behavior.

{phang}
{opt commas} indicates that commas be used in the default numeric format.

{phang}
{opt ignore(item)} specifies that {it:item} be ignored if supplied to
{cmd:.row}.  By default, only empty strings ({cmd:""}) are ignored by
{cmd:.row}.

{phang}
{opt separator(#)} specifies that a separator be automatically drawn between
every {it:#} rows.  Initially there are no automatic row separators, which
are explicitly set by {cmd:separator(0)}.

{phang}
{opt clear(clear_options)} clears the specified table parameters.

{phang}
{opt clear} is a shortcut for {cmd:clear(all)}.


{marker options_width}{...}
{title:Options for .width}

{phang}
{opt noreformat} prevents {cmd:.width} from resetting the column formats
for titles, strings, and numbers.


{marker options_sep}{...}
{title:Options for .sep}

{phang}
{opt top} causes the display of a horizontal line appropriate for the top of
the table.

{phang}
{opt middle} causes the display of a horizontal line appropriate for the
middle of the table.  This is the default for {cmd:.sep}.

{phang}
{opt bottom} causes the display of a horizontal line appropriate for the
bottom of the table.


{marker note}{...}
{title:A note about colors}

{pstd}
The color identifiers {opt text}, {opt result}, {opt error}, and {opt input}
have the following respective synonyms:
{opt g:reen}, {opt y:ellow}, {opt r:ed}, and {opt w:hite}.


{marker examples}{...}
{title:Examples}

{* BEGIN: _tab_hlp.smcl}{...}
{res}* _my_tab.ado
program _my_tab
        syntax [, level(int `c(level)') ]
        tempname mytab z t p ll ul
        .`mytab' = ._tab.new, col(7) lmargin(0)
        .`mytab'.width    13   |12    12     8     8    12    12
        .`mytab'.titlefmt  .     .     .   %6s     .  %24s     .
        .`mytab'.pad       .     2     1     0     2     3     3
        .`mytab'.numfmt    . %9.0g %9.0g %7.2f %5.3f %9.0g %9.0g
        if "`e(df_r)'" != "" {c -(}
                local stat t
                scalar `z' = invttail(e(df_r),(100-`level')/200)
        {c )-}
        else {c -(}
                local stat z
                scalar `z' = invnorm((100+`level')/200)
        {c )-}
        local namelist : colname e(b)
        local eqlist : coleq e(b)
        local k : word count `namelist'
        .`mytab'.sep, top
        if `:word count `e(depvar)'' == 1 {c -(}
                local depvar "`e(depvar)'"
        {c )-}
        .`mytab'.titles "`depvar'"                      /// 1
                        "Coef."                         /// 2
                        "Std. Err."                     /// 3
                        "`stat'"                        /// 4
                        "P>|`stat'|"                    /// 5
                        "[`level'% Conf. Interval]" ""  //  6 7
        forvalues i = 1/`k' {c -(}
                local name : word `i' of `namelist'
                local eq   : word `i' of `eqlist'
                if "`eq'" != "_" {c -(}
                        if "`eq'" != "`eq0'" {c -(}
                                .`mytab'.sep
                                local eq0 `"`eq'"'
                                .`mytab'.strcolor result  .  .  .  .  .  .
                                .`mytab'.strfmt    %-12s  .  .  .  .  .  .
                                .`mytab'.row      "`eq'" "" "" "" "" "" ""
                                .`mytab'.strcolor   text  .  .  .  .  .  .
                                .`mytab'.strfmt     %12s  .  .  .  .  .  .
                        {c )-}
                        local beq "[`eq']"
                {c )-}
                else if `i' == 1 {c -(}
                        local eq
                        .`mytab'.sep
                {c )-}
                scalar `t' = `beq'_b[`name']/`beq'_se[`name']
                if "`e(df_r)'" != "" {c -(}
                        scalar `p' = 2*ttail(e(df_r),abs(`t'))
                {c )-}
                else    scalar `p' = 2*norm(-abs(`t'))
                scalar `ll' = `beq'_b[`name']-`beq'_se[`name']*`z'
                scalar `ul' = `beq'_b[`name']+`beq'_se[`name']*`z'
                .`mytab'.row    "`name'"                ///
                                `beq'_b[`name']         ///
                                `beq'_se[`name']        ///
                                `t'                     ///
                                `p'                     ///
                                `ll' `ul'
        {c )-}
        .`mytab'.sep, bottom
end
{txt}
{cmd}. sysuse auto, clear
{txt}(1978 Automobile Data)

{cmd}. regress mpg turn trunk displ, noheader
{txt}{hline 13}{c TT}{hline 64}
         mpg {c |}      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
{hline 13}{char +}{hline 64}
        turn {c |}  {res}-.4971904    .165826    -3.00   0.004      -.82792   -.1664608
{txt}       trunk {c |}  {res} -.222583   .1353748    -1.64   0.105    -.4925796    .0474136
{txt}displacement {c |}  {res}-.0196434   .0080013    -2.46   0.017    -.0356016   -.0036853
{txt}       _cons {c |}  {res} 47.94784   5.290301     9.06   0.000     37.39667    58.49902
{txt}{hline 13}{c BT}{hline 64}

{cmd}. _my_tab
{col 1}{text}{hline 13}{c TT}{hline 12}{hline 12}{hline 8}{hline 8}{hline 12}{hline 12}
{col 1}{text}         mpg{col 14}{c |}      Coef.{col 27}  Std. Err.{col 39}     t{col 47}  P>|t|{col 55}    [95% Conf. Interval]
{col 1}{text}{hline 13}{c +}{hline 12}{hline 12}{hline 8}{hline 8}{hline 12}{hline 12}
{col 1}{text}        turn{col 14}{c |}{result}{space 2}-.4971904{col 27}{space 1}  .165826{col 39}  -3.00{col 47}{space 2}0.004{col 55}{space 3}  -.82792{col 67}{space 3}-.1664608
{col 1}{text}       trunk{col 14}{c |}{result}{space 2} -.222583{col 27}{space 1} .1353748{col 39}  -1.64{col 47}{space 2}0.105{col 55}{space 3}-.4925796{col 67}{space 3} .0474136
{col 1}{text}displacement{col 14}{c |}{result}{space 2}-.0196434{col 27}{space 1} .0080013{col 39}  -2.46{col 47}{space 2}0.017{col 55}{space 3}-.0356016{col 67}{space 3}-.0036853
{col 1}{text}       _cons{col 14}{c |}{result}{space 2} 47.94784{col 27}{space 1} 5.290301{col 39}   9.06{col 47}{space 2}0.000{col 55}{space 3} 37.39667{col 67}{space 3} 58.49902
{col 1}{text}{hline 13}{c BT}{hline 12}{hline 12}{hline 8}{hline 8}{hline 12}{hline 12}

{cmd}. sureg (mpg turn trunk) (displ head gear), noheader

{txt}{hline 13}{c TT}{hline 64}
             {c |}      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
{hline 13}{c +}{hline 64}
{res}mpg          {txt}{c |}
        turn {c |}  {res}-.7319231   .1276395    -5.73   0.000     -.982092   -.4817543
       {txt}trunk {c |}  {res}-.3189985   .1312914    -2.43   0.015    -.5763249   -.0616721
       {txt}_cons {c |}  {res} 54.70544   4.254873    12.86   0.000     46.36605    63.04484
{txt}{hline 13}{c +}{hline 64}
{res}displacement {txt}{c |}
    headroom {c |}  {res} 20.63565   7.225785     2.86   0.004     6.473372    34.79793
  {txt}gear_ratio {c |}  {res}-150.6982   13.39898   -11.25   0.000    -176.9597   -124.4367
       {txt}_cons {c |}  {res} 589.8645   52.81358    11.17   0.000     486.3518    693.3772
{txt}{hline 13}{c BT}{hline 64}

{cmd}. _my_tab
{col 1}{text}{hline 13}{c TT}{hline 12}{hline 12}{hline 8}{hline 8}{hline 12}{hline 12}
{col 14}{text}{c |}      Coef.{col 27}  Std. Err.{col 39}     z{col 47}  P>|z|{col 55}    [95% Conf. Interval]
{col 1}{text}{hline 13}{c +}{hline 12}{hline 12}{hline 8}{hline 8}{hline 12}{hline 12}
{col 1}{result}mpg         {col 14}{text}{c |}           
{col 1}{text}        turn{col 14}{c |}{result}{space 2}-.7319231{col 27}{space 1} .1276395{col 39}  -5.73{col 47}{space 2}0.000{col 55}{space 3} -.982092{col 67}{space 3}-.4817543
{col 1}{text}       trunk{col 14}{c |}{result}{space 2}-.3189985{col 27}{space 1} .1312914{col 39}  -2.43{col 47}{space 2}0.015{col 55}{space 3}-.5763249{col 67}{space 3}-.0616721
{col 1}{text}       _cons{col 14}{c |}{result}{space 2} 54.70544{col 27}{space 1} 4.254873{col 39}  12.86{col 47}{space 2}0.000{col 55}{space 3} 46.36605{col 67}{space 3} 63.04484
{col 1}{text}{hline 13}{c +}{hline 12}{hline 12}{hline 8}{hline 8}{hline 12}{hline 12}
{col 1}{result}displacement{col 14}{text}{c |}           
{col 1}{text}    headroom{col 14}{c |}{result}{space 2} 20.63565{col 27}{space 1} 7.225785{col 39}   2.86{col 47}{space 2}0.004{col 55}{space 3} 6.473372{col 67}{space 3} 34.79793
{col 1}{text}  gear_ratio{col 14}{c |}{result}{space 2}-150.6982{col 27}{space 1} 13.39898{col 39} -11.25{col 47}{space 2}0.000{col 55}{space 3}-176.9597{col 67}{space 3}-124.4367
{col 1}{text}       _cons{col 14}{c |}{result}{space 2} 589.8645{col 27}{space 1} 52.81358{col 39}  11.17{col 47}{space 2}0.000{col 55}{space 3} 486.3518{col 67}{space 3} 693.3772
{col 1}{text}{hline 13}{c BT}{hline 12}{hline 12}{hline 8}{hline 8}{hline 12}{hline 12}
{reset}{...}
{* END: _tab_hlp.smcl}{...}
