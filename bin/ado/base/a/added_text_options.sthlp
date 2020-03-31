{smcl}
{* *! version 1.1.10  16apr2019}{...}
{vieweralsosee "[G-3] added_text_options" "mansection G-3 added_text_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] textbox_options" "help textbox_options"}{...}
{viewerjumpto "Syntax" "added_text_options##syntax"}{...}
{viewerjumpto "Description" "added_text_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "added_text_options##linkspdf"}{...}
{viewerjumpto "Options" "added_text_options##options"}{...}
{viewerjumpto "Suboptions" "added_text_options##suboptions"}{...}
{viewerjumpto "Remarks" "added_text_options##remarks"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[G-3]} {it:added_text_options} {hline 2}}Options for adding text to twoway graphs{p_end}
{p2col:}({mansection G-3 added_text_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 22}{...}
{p2col : {it:added_text_options}}
	Description{p_end}
{p2line}
{p2col : {cmd:text(}{it:text_arg}{cmd:)}}
	add text at specified {it:y} {it:x}{p_end}
{p2col : {cmd:ttext(}{it:text_arg}{cmd:)}}
	add text at specified {it:y} {it:t}{p_end}
{p2line}
{p 4 6 2}
The above options are {it:merged-implicit}; see {help repeated options}.

{pstd}
where {it:text_arg} is

	{it:loc_and_text} [{it:loc_and_text} ...] [{cmd:,} {it:textoptions}]

{pstd}
and where {it:loc_and_text} is

	{it:#_y} {it:#_x} {cmd:"}{it:text}{cmd:"} [{cmd:"}{it:text}{cmd:"} ...]

{pmore}
{it:text} may contain Unicode characters and SMCL tags to render mathematical
symbols, italics, etc.; see {manhelpi graph_text G-4:text}.

{p2col : {it:textoptions}}
	Description{p_end}
{p2line}
{p2col : {cmdab:yax:is:(}{it:#}{cmd:)}}
	how to interpret {it:#_y}{p_end}
{p2col : {cmdab:xax:is:(}{it:#}{cmd:)}}
	how to interpret {it:#_x}{p_end}
{p2col : {cmdab:place:ment:(}{it:{help compassdirstyle}}{cmd:)}}
	where to locate relative to {it:#_y} {it:#_x}{p_end}
{p2col : {it:{help textbox_options}}}
	look of text{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
{cmd:placement()} is also a textbox option, but ignore the
description of {cmd:placement()} found there in favor of the one below.


{marker description}{...}
{title:Description}

{pstd}
{cmd:text()} adds the specified text to the specified location in the plot
region.

{pstd}
{cmd:ttext()} is an extension to {cmd:text()}, accepting a date in place of
{it:#_x} when the time axis has a time format; see {help datelist}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 added_text_optionsQuickstart:Quick start}

        {mansection G-3 added_text_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt text(text_arg)} and {opt ttext(text_arg)}
    specify the location and text to be displayed.


{marker suboptions}{...}
{title:Suboptions}

{phang}
{cmd:yaxis(}{it:#}{cmd:)}
and
{cmd:xaxis(}{it:#}{cmd:)}
    specify how {it:#_y} and {it:#_x} are to be interpreted when
    there are multiple {it:y}, {it:x}, or {it:t} axis scales; see
    {manhelpi axis_choice_options G-3}.

{pmore}
    In the usual case, there is one {it:y} axis and one {it:x} axis,
    so options {cmd:yaxis()} and {cmd:xaxis()} are not specified.
    {it:#_y} is specified in units of the {it:y} scale and {it:#_x} in
    units of the {it:x} scale.

{pmore}
    In the multiple-axis case, specify {cmd:yaxis(}{it:#}{cmd:)} and/or
    {cmd:xaxis(}{it:#}{cmd:)} to specify which units you wish to use.
    {cmd:yaxis(1)} and {cmd:xaxis(1)} are the defaults.

{phang}
{cmd:placement(}{it:compassdirstyle}{cmd:)} specifies where the textbox
    is to be displayed relative to {it:#_y} {it:#_x}.
    The default is usually {cmd:placement(center)}.  The default is
    controlled both by the scheme and by the {it:textbox_option}
    {cmd:tstyle(}{it:textboxstyle}{cmd:)}; see
    {manhelp schemes G-4:Schemes intro} and
    {manhelpi textbox_options G-3}.
    The available choices are

{p2colset 12 30 32 2}{...}
{p2col:{it:compassdirstyle}}Location of text{p_end}
{p2line}
{p2col 18 30 32 2:{cmd:c}}centered on the point, vertically and horizontally{p_end}
{p2col 18 30 32 2:{cmd:n}}above the point, centered{p_end}
{p2col 18 30 32 2:{cmd:ne}}above and to the right of the point{p_end}
{p2col 18 30 32 2:{cmd:e}}right of the point, vertically centered{p_end}
{p2col 18 30 32 2:{cmd:se}}below and to the right of the point{p_end}
{p2col 18 30 32 2:{cmd:s}}below point, centered{p_end}
{p2col 18 30 32 2:{cmd:sw}}below and to the left of the point{p_end}
{p2col 18 30 32 2:{cmd:w}}left of the point, vertically centered{p_end}
{p2col 18 30 32 2:{cmd:nw}}above and to the left of the point{p_end}
{p2line}
{p2colreset}{...}

                      {it:north            northwest northeast}
		  {it:west}  X  {it:east}                 X
                      {it:south            southwest southeast}

{pmore}
    You can see {manhelpi compassdirstyle G-4}, but that will just give
    you synonyms for {cmd:c}, {cmd:n}, {cmd:ne}, ..., {cmd:nw}.

{phang}
{it:textbox_options}
    specifies the look of the text; see {manhelpi textbox_options G-3}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help added_text_options##remarks1:Typical use}
	{help added_text_options##remarks2:Advanced use}
	{help added_text_options##remarks3:Use of the textbox option width()}


{marker remarks1}{...}
{title:Typical use}

{pstd}
{cmd:text()} is used for placing annotations on graphs.  One example is the
labeling of outliers.  For instance, type

	{cmd:. sysuse auto}

	{cmd:. twoway qfitci mpg weight, stdf || scatter mpg weight}
	{it:(graph omitted)}

{pstd}
There are four outliers.  First, we find the outliers by typing

	{cmd:. quietly regress mpg weight}

	{cmd:. predict hat}

	{cmd:. predict s, stdf}

	{cmd:. generate upper = hat + 1.96*s}

	{cmd:. list make mpg weight if mpg>upper}
	{txt}
             {c TLC}{hline 13}{c -}{hline 5}{c -}{hline 8}{c TRC}
             {c |} {res}make          mpg   weight {txt}{c |}
             {c LT}{hline 13}{c -}{hline 5}{c -}{hline 8}{c RT}
         13. {c |} {res}Cad. Seville   21    4,290 {txt}{c |}
         42. {c |} {res}Plym. Arrow    28    3,260 {txt}{c |}
         57. {c |} {res}Datsun 210     35    2,020 {txt}{c |}
         66. {c |} {res}Subaru         35    2,050 {txt}{c |}
         71. {c |} {res}VW Diesel      41    2,040 {txt}{c |}
             {c BLC}{hline 13}{c -}{hline 5}{c -}{hline 8}{c BRC}{txt}

{pstd}
Now we can remake the graph and label the outliers:

	{cmd}. twoway qfitci  mpg weight, stdf ||
		 scatter mpg weight, ms(O)
			text(41 2040 "VW Diesel", place(e))
			text(28 3260 "Plymouth Arrow", place(e))
			text(35 2050 "Datsun 210 and Subaru", place(e)){txt}
	  {it:({stata `"gr_example auto: twoway qfitci mpg weight, stdf || scatter mpg weight, ms(O) text(41 2040 "VW Diesel", place(e)) text(28 3260 "Plymouth Arrow", place(e)) text(35 2050 "Datsun 210 and Subaru", place(e))"':click to run})}
{* graph atofig1}{...}


{marker remarks2}{...}
{title:Advanced use}

{pstd}
Another common use of {it:text} is to add an explanatory box of text inside
the graph:

	{cmd}. sysuse uslifeexp, clear

        . twoway line  le year ||
		 fpfit le year ||
	  , ytitle("Life Expectancy, years")
	    xlabel(1900 1918 1940(20)2000)
	    title("Life Expectancy at Birth")
	    subtitle("U.S., 1900-1999")
	    note("Source:  National Vital Statistics Report, Vol. 50 No. 6")
	    legend(off)
	    text( 48.5 1923
		 "The 1918 Influenza Pandemic was the worst epidemic"
		 "known in the U.S."
		 "More citizens died than in all combat deaths of the"
		 "20th century."
		 , place(se) box just(left) margin(l+4 t+1 b+1) width(85) ){txt}
	  {it:({stata "gr_example2 textop1":click to run})}
{* graph textop1}{...}

{pstd}
The only thing to note in the above command is the {cmd:text()} option:

	    {cmd}text( 48.5 1923
		 "The 1918 Influenza Pandemic was the worst epidemic"
		 "known in the U.S."
		 "More citizens died than in all combat deaths of the"
		 "20th century."
		 , place(se) box just(left) margin(l+4 t+1 b+1) width(85) ){txt}

{pstd}
and, in particular, we want to draw your eye to the location of the text
and the suboptions:

	    {cmd}text( 48.5 1923
		 {txt}...{cmd}
		 , place(se) box just(left) margin(l+4 t+1 b+1) width(85) ){txt}

{pstd}
We placed the text at {it:y}=48.5, {it:x}=1923, {cmd:place(se)}, meaning the
box will be placed below and to the right of {it:y}=48.5, {it:x}=1923.

{pstd}
The other suboptions, {cmd:box} {cmd:just(left)} {cmd:margin(l+4} {cmd:t+1}
{cmd:b+1)} {cmd:width(85)}, are {it:textbox_options}.  We specified {cmd:box}
to draw a border around the textbox, and we specified
{cmd:just(left)} -- an abbreviation for
{cmd:justification(left)} -- so that the text was left-justified inside
the box.  {cmd:margin(l+4} {cmd:t+1} {cmd:b+1)} made the text in the box look
better.  On the left we added 4%, and on the top and bottom we added 1%; see
{manhelpi textbox_options G-3} and {manhelpi size G-4}.
{cmd:width(85)} was specified to solve the problem described below.


{* index width() tt textbox option}{...}
{* index height() tt textbox option}{...}
{* index borders, misplacement of}{...}
{* index text, running outside of borders}{...}
{marker remarks3}{...}
{title:Use of the textbox option width()}

{pstd}
Let us look at the results of the above command, omitting the {cmd:width()}
suboption.  What you would see on your screen -- or in a
printout -- might look virtually identical to the version we just drew,
or it might look like this

	  {it:({stata "gr_example2 textop2":click to run})}
{* graph textop2}{...}

{pstd}
or like this:

	  {it:({stata "gr_example2 textop3":click to run})}
{* graph textop3}{...}

{pstd}
That is, Stata might make the textbox too narrow or too wide.  In the above
illustrations, we have exaggerated the extent of the problem, but it is
common for the box to run a little narrow or a little wide.  Moreover, with
respect to this one problem, how the graph appears on your screen is no
guarantee of how it will appear when printed.

{pstd}
This problem arises because Stata uses an approximation formula to determine
the width of the text.  This approximation is good for some fonts and poorer
for others.

{pstd}
When the problem arises, use
the {it:textbox_option}
{cmd:width(}{it:size}{cmd:)} to work
around it.  {cmd:width()} overrides Stata's
calculation.  In fact, we drew the two examples above by purposely misstating
the {cmd:width()}.  In the first case, we specified {cmd:width(40)}, and in the
second, {cmd:width(95)}.

{pstd}
Getting the {cmd:width()} right is a matter of trial and error.  The correct
width will nearly always be between 0 and 100.

{pstd}
Corresponding to {cmd:width(}{it:size}{cmd:)}, there is also the
{it:textbox_option} {cmd:height(}{it:size}{cmd:)}, but Stata never
gets the height incorrect.
{p_end}
