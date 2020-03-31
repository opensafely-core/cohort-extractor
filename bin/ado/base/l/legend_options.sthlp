{smcl}
{* *! version 1.2.9  24apr2019}{...}
{vieweralsosee "[G-3] legend_options" "mansection G-3 legend_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] title_options" "help title_options"}{...}
{viewerjumpto "Syntax" "legend_options##syntax"}{...}
{viewerjumpto "Description" "legend_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "legend_options##linkspdf"}{...}
{viewerjumpto "Options" "legend_options##options"}{...}
{viewerjumpto "Content suboptions for use with legend() and plegend()" "legend_options##content_subopts"}{...}
{viewerjumpto "Suboptions for use with legend(region())" "legend_options##subopts"}{...}
{viewerjumpto "Location suboptions for use with legend()" "legend_options##location_subopts"}{...}
{viewerjumpto "Remarks" "legend_options##remarks"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[G-3]} {it:legend_options} {hline 2}}Options for specifying legends{p_end}
{p2col:}({mansection G-3 legend_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 30}{...}
{p2col:{it:legend_options}}Description{p_end}
{p2line}
{p2col:{cmdab:leg:end:(}[{it:{help legend_options##contents:contents}}] [{it:{help legend_options##location:location}}]{cmd:)}}standard
	legend, contents and location{p_end}
{p2col:{cmdab:pleg:end:(}[{it:{help legend_options##contents:contents}}] [{it:{help legend_options##location:location}}]{cmd:)}}{helpb twoway contourline:contourline} 
	legend, contents and location{p_end}
{p2col:{cmdab:cleg:end:(}[{it:suboptions}])}{helpb twoway contour:contour} 
	plot legend; see {manhelpi clegend_option G-3}{p_end}
{p2line}
{p 4 6 2}
{cmd:legend()}, {cmd:plegend()}, and {cmd:clegend()} are {it:merged-implicit};
see {help repeated options}.

{pstd}
where {it:contents} and {it:location} specify the contents
and the location of the legends.

{marker contents}{...}
{p2col:{it:contents}}Description{p_end}
{p2line}
{p2col:{cmd:order(}{it:{help legend_options##orderinfo:orderinfo}}{cmd:)}}which
     keys appear and their order{p_end}
{p2col:{cmdab:lab:el:(}{it:{help legend_options##labelinfo:labelinfo}}{cmd:)}}override text for a key{p_end}
{p2col:{cmdab:hol:es:(}{it:{help numlist}}{cmd:)}}positions in legend to leave
     blank{p_end}
{p2col:{cmd:all}}generate keys for all symbols{p_end}

{p2col:{cmdab:sty:le:(}{it:{help legendstyle}}{cmd:)}}overall style of legend
     {p_end}
{p2col:{cmdab:c:ols:(}{it:#}{cmd:)}}{it:#} of keys per line{p_end}
{p2col:{cmdab:r:ows:(}{it:#}{cmd:)}}or {it:#} of rows{p_end}
{p2col:[{cmdab:no:}]{cmdab:colf:irst}}"1, 2, 3" in row 1 or in column 1?{p_end}
{p2col:[{cmdab:no:}]{cmdab:textf:irst}}symbol-text or text-symbol?{p_end}
{p2col:{cmdab:stac:k}}symbol/text vertically stacked{p_end}
{p2col:{cmdab:rowg:ap:(}{it:{help size}}{cmd:)}}gap between lines{p_end}
{p2col:{cmdab:colg:ap:(}{it:{help size}}{cmd:)}}gap between columns
     {p_end}
{p2col:{cmdab:symp:lacement:(}{it:{help compassdirstyle}}{cmd:)}}alignment/justification of key's symbol{p_end}
{p2col:{cmdab:keyg:ap:(}{it:{help size}}{cmd:)}}gap between symbol-text
     {p_end}
{p2col:{cmdab:symy:size:(}{it:{help size}}{cmd:)}}height for key's
     symbol{p_end}
{p2col:{cmdab:symx:size:(}{it:{help size}}{cmd:)}}width for key's
      symbol{p_end}
{p2col:{cmdab:textw:idth:(}{it:{help size}}{cmd:)}}width for key's
      descriptive text{p_end}
{p2col:{cmdab:forces:ize}}always respect {cmd:symysize()}, {cmd:symxsize()},
      and {cmd:textwidth()}{p_end}
{p2col:{cmdab:bm:argin:(}{it:{help marginstyle}}{cmd:)}}outer margin around
      legend{p_end}
{p2col:{it:{help textbox_options}}}appearance of key's descriptive text{p_end}
{p2col:{it:{help title_options}}}titles, subtitles, notes, captions{p_end}
{p2col:{cmdab:r:egion:(}{it:{help legend_options##roptions:roptions}}{cmd:)}}borders and background shading{p_end}
{p2line}
{p 4 6 2}{cmd:order()}, {cmd:labels()}, {cmd:holes()}, and {cmd:all} have no
effect on {cmd:plegend()}.

{marker location}{...}
{p2col:{it:location}}Description{p_end}
{p2line}
{p2col:{cmd:off} or {cmd:on}}suppress or force display of legend{p_end}
{p2col:{cmdab:pos:ition:(}{it:{help clockposstyle}}{cmd:)}}where legend
      appears{p_end}
{p2col:{cmd:ring(}{it:{help ringposstyle}}{cmd:)}}where legend appears
      (detail){p_end}
{p2col:{cmdab:bplace:ment:(}{it:{help compassdirstyle}}{cmd:)}}placement 
	of legend when positioned in the plotregion{p_end}
{p2col:{cmd:span}}"centering" of legend{p_end}
{p2col:{cmd:at(}{it:#}{cmd:)}}allowed with {cmd:by()} only{p_end}
{p2line}
{p 4 6 2}
See
{it:{help legend_options##remarks3:Where legends appear}} under {it:Remarks}
below, and see {help title_options##remarks3:Positioning of titles} in
{manhelpi title_options G-3} for definitions of {it:clockposstyle} and
{it:ringposstyle}.


{marker orderinfo}{...}
{pstd}
{it:orderinfo}, the argument allowed by {cmd:legend(order())}, is
defined as

{phang2}
	{c -(}{it:#}|{cmd:-}{c )-} [{cmd:"}{it:text}{cmd:"} {...}
[{cmd:"}{it:text}{cmd:"} ...]]

{marker labelinfo}{...}
{pstd}
{it:labelinfo}, the argument allowed by {cmd:legend(label())}, is
defined as

{phang2}
	{it:#} {cmd:"}{it:text}{cmd:"} [{cmd:"}{it:text}{cmd:"} ...]

{marker roptions}{...}
{pstd}
{it:roptions}, the arguments allowed by {cmd:legend(region())},
include

{p2col:{it:roptions}}Description{p_end}
{p2line}
{p2col:{cmdab:sty:le:(}{it:{help areastyle}}{cmd:)}}overall style of
       region{p_end}
{p2col:{cmdab:c:olor:(}{it:{help colorstyle}}{cmd:)}}line + fill color and
	opacity of region{p_end}
{p2col:{cmdab:fc:olor:(}{it:{help colorstyle}}{cmd:)}}fill color and opacity of
       region{p_end}
{p2col:{cmdab:ls:tyle:(}{it:{help linestyle}}{cmd:)}}overall style of
       border{p_end}
{p2col:{cmdab:lc:olor:(}{it:{help colorstyle}}{cmd:)}}color and opacity of border{p_end}
{p2col:{cmdab:lw:idth:(}{it:{help linewidthstyle}}{cmd:)}}thickness of
       border{p_end}
{p2col:{cmdab:lp:attern:(}{it:{help linepatternstyle}}{cmd:)}}border pattern
       (solid, dashed, etc.){p_end}
{p2col : {cmdab:la:lign:(}{it:{help linealignmentstyle}}{cmd:)}}border
	alignment (inside, outside, center){p_end}
{p2col:{cmdab:m:argin:(}{it:{help marginstyle}}{cmd:)}}margin between border
       and contents of legend{p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:legend()} option allows you to control the look, contents, and
placement of
the legend.  A sample legend is

		{c TLC}{hline 21}{c TRC}
		{c |}  o   Observed       {c |}
		{c |} {hline 3}  Linear fit     {c |}
		{c |} ---  Quadratic fit  {c |}
		{c BLC}{hline 21}{c BRC}

{pstd}
The above legend has three {it:keys}.  Each key is composed of a {it:symbol}
and {it:descriptive text} describing the symbol (whatever the symbol might be,
be it a marker, a line, or a color swatch).

{pstd}
{cmd:contourline} and {cmd:contour} plots have their own legends
and do not place keys in the standard legend -- {cmd:legend()}; see
{helpb twoway contourline:[G-2] graph twoway contourline} and
{helpb twoway contour:[G-2] graph twoway contour}.  {cmd:contourline} plots
place their keys in the {cmd:plegend()} and
{cmd:contour} plots place their keys in the {cmd:clegend()}.  The
{cmd:plegend()} is similar to the {cmd:legend()} and is documented here.  The
{cmd:clegend()} is documented in {manhelpi clegend_option G-3}.

{pstd}
The legend options (more correctly suboptions) are discussed using the
{cmd:legend()} option, but most apply equally to the {cmd:plegend()} option.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 legend_optionsQuickstart:Quick start}

        {mansection G-3 legend_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:legend(}{it:{help legend_options##contents:contents}}{cmd:,}
    {it:{help legend_options##location:location}}{cmd:)}
    defines the contents of the standard legend, along with how it is to look,
    and whether and where it is to be displayed.

{phang}
{cmd:plegend(}{it:{help legend_options##contents:contents}}{cmd:,}
    {it:{help legend_options##location:location}}{cmd:)}
    defines the contents of the {cmd:contourline} plot legend,
    along with how it is to look, and whether and where it is to be displayed.


{marker content_subopts}{...}
{title:Content suboptions for use with legend() and plegend()}

{phang}
{cmd:order(}{it:orderinfo}{cmd:)}
    specifies which keys are to appear in the legend and the order in which
    they are to appear.

{pmore}
    {cmd:order(}{it:#} {it:#} ...{cmd:)} is the usual syntax.
    {cmd:order(1 2 3)} would specify that key 1 is to appear first in the
    legend, followed by key 2, followed by key 3.  {cmd:order(1 2 3)} is the
    default if there are three keys.  If there were four keys,
    {cmd:order(1 2 3 4)} would be the default, and so on.  If there were four
    keys and you specified {cmd:order(1 2 3)}, the fourth key would not
    appear in the legend.  If you specified {cmd:order(2 1 3)}, first key 2
    would appear, followed by key 1, followed by key 3.

{pmore}
    A dash specifies that text be inserted into the legend.
    For instance, {cmd:order(1 2 - "}{it:text}{cmd:"} {cmd:3)} specifies
    key 1 appear first, followed by key 2,
    followed by the text {it:text}, followed by key 3.
    Imagine that the default key were

		{c TLC}{hline 19}{c TRC}
		{c |}  o   Observed     {c |}
		{c |} {hline 3}  Linear       {c |}
		{c |} ---  Quadratic    {c |}
		{c BLC}{hline 19}{c BRC}

{pmore}
    Specifying {cmd:order(1 - "Predicted:" 2 3)} would produce

		{c TLC}{hline 19}{c TRC}
		{c |}  o   Observed     {c |}
		{c |}      Predicted:   {c |}
		{c |} {hline 3}  Linear       {c |}
		{c |} ---  Quadratic    {c |}
		{c BLC}{hline 19}{c BRC}

{pmore}
    and specifying {cmd:order(1 - " " "Predicted:" 2 3)} would produce

		{c TLC}{hline 19}{c TRC}
		{c |}  o   Observed     {c |}
		{c |}                   {c |}
		{c |}      Predicted:   {c |}
		{c |} {hline 3}  Linear       {c |}
		{c |} ---  Quadratic    {c |}
		{c BLC}{hline 19}{c BRC}

{pmore}
    Note carefully the specification of a blank for the first line
    of the text insertion; we typed {cmd:" "} and not {cmd:""}.
    Typing {cmd:""} would insert nothing.

{pmore}
    You may also specify quoted text after {it:#} to override the descriptive
    text associated with a symbol.  Specifying
    {cmd:order(1 "Observed 1992" - " " "Predicted" 2 3)}
    would change "Observed" in the above to "Observed 1992".
    It is considered better style, however, to use the {cmd:label()}
    suboption to relabel symbols.

{pmore}
    {cmd:order()} has no effect on {cmd:plegend()}.

{phang}
{cmd:label(}{it:#} {cmd:"}{it:text}{cmd:"} [{cmd:"}{it:text}{cmd:"} ...]{cmd:)}
    specifies the descriptive text to be displayed next to the {it:#}th key.
    Multiline text is allowed.  Specifying
    {cmd:label(1 "Observed 1992")} would change the descriptive text
    associated with the first key to be "Observed 1992".  Specifying
    {cmd:label(1 "Observed" "1992-1993")} would change the descriptive text
    to contain two lines, "Observed" followed by "1992-1993".

{pmore}
    The descriptive text of only one key may be changed
    per {cmd:label()} suboption.  Specify multiple {cmd:label()} suboptions
    when you wish to change the text of multiple keys.

{pmore}
    {cmd:label()} has no effect on {cmd:plegend()}.

{phang}
{cmd:holes(}{it:{help numlist}}{cmd:)}
    specifies where gaps appear in the presentation of the keys.
    {cmd:holes()} has an effect only if the keys are being presented in more
    than one row and more than one column.

{pmore}
    Consider a case in which the default key is

	    {c TLC}{hline 47}{c TRC}
	    {c |}  o   Observed               {hline 3}  Linear fit   {c |}
	    {c |} ---  Quadratic fit                            {c |}
	    {c BLC}{hline 47}{c BRC}

{pmore}
    Specifying {cmd:holes(2)} would result in

	    {c TLC}{hline 47}{c TRC}
	    {c |}  o   Observed                                 {c |}
	    {c |} {hline 3}  Linear fit           ---  Quadratic fit  {c |}
	    {c BLC}{hline 47}{c BRC}

{pmore}
    Here {cmd:holes(2)} would have the same effect as specifying
    {cmd:order(1 - " " 2 3)}, and as a matter of fact, there is always
    an {cmd:order()} command that will achieve the same result as
    {cmd:holes()}.  {cmd:order()} has the added advantage of working in
    all cases.

{pmore}
    {cmd:holes()} has no effect on {cmd:plegend()}.

{phang}
{cmd:all}
    specifies that keys be generated for all the plots of the graph,
    even when the same symbol is repeated.  The default is to generate keys
    only when the symbols are different, which is determined by the overall
    style.  For example, in

	    {cmd:. scatter ylow yhigh x, pstyle(p1 p1) || ...}

{pmore}
    there would be only one key generated for the variables {cmd:ylow} and
    {cmd:yhigh} because they share the style {cmd:p1}.  That single key's
    descriptive text would indicate that the symbol corresponded to both
    variables.  If, on the other hand, you typed

{phang3}
	    {cmd:. scatter ylow yhigh x, pstyle(p1 p1) legend(all) || ...}

{pmore}
    then separate keys would be generated for {cmd:ylow} and {cmd:yhigh}.

{pmore}
    In the above example, do not confuse our use of {cmd:scatter}'s option
    {helpb scatter##pstyle():pstyle()} with {cmd:legend()}'s suboption
    {cmd:legend(style())}.  The {cmd:pstyle()} option sets the
     overall style for the rendition of the points.  {cmd:legend()}'s
     {cmd:style()} suboption is documented directly below.

{pmore}
    {cmd:all} has no effect on {cmd:plegend()}.

{phang}
{cmd:style(}{it:legendstyle}{cmd:)}
     specifies the overall look of the legend -- whether it is presented
     horizontally or vertically, how many keys appear across the legend if
     it is presented horizontally, etc.  The options listed below allow you to
     change each attribute of the legend, but {cmd:style()} is the starting
     point.

{pmore}
     You need not specify {cmd:style()} just because there is something
     you want to change.  You specify {cmd:style()} when another style
     exists that is exactly what you desire or when another style
     would allow you to specify fewer changes to obtain what you want.

{pmore}
     See {manhelpi legendstyle G-4} for a list of available legend styles.

{phang}
{cmd:cols(}{it:#}{cmd:)} and {cmd:rows(}{it:#}{cmd:)}
     are alternatives; they specify in how many columns or rows (lines) the
     keys are to be presented.  The usual default is {cmd:cols(2)}, which
     means that legends are to take two columns:

	    {c TLC}{hline 47}{c TRC}
	    {c |}  o   Observed               {hline 3}  Linear fit   {c |}
	    {c |} ---  Quadratic fit                            {c |}
	    {c BLC}{hline 47}{c BRC}

{pmore}
     {cmd:cols(1)} would force a vertical arrangement,

	    {c TLC}{hline 22}{c TRC}
	    {c |}  o    Observed       {c |}
	    {c |} {hline 3}   Linear fit     {c |}
	    {c |} ---   Quadratic fit  {c |}
	    {c BLC}{hline 22}{c BRC}

{pmore}
    and {cmd:rows(1)} would force a horizontal arrangement:

	    {c TLC}{hline 63}{c TRC}
	    {c |}  o   Observed       {hline 3}   Linear fit     ---    Quadratic fit {c |}
	    {c BLC}{hline 63}{c BRC}

{phang}
{cmd:colfirst} and {cmd:nocolfirst}
    determine whether, when the keys are presented in multiple columns,
    keys are to read down or to read across, resulting in this

	    {c TLC}{hline 50}{c TRC}
	    {c |}  o    Observed               ---   Quadratic fit {c |}
	    {c |} {hline 3}   Linear fit                                 {c |}
	    {c BLC}{hline 50}{c BRC}

{pmore}
or this

	    {c TLC}{hline 50}{c TRC}
	    {c |}  o    Observed               {hline 3}   Linear fit    {c |}
	    {c |} ---   Quadratic fit                              {c |}
	    {c BLC}{hline 50}{c BRC}

{pmore}
The usual default is {cmd:nocolfirst}, so {cmd:colfirst} is the option.

{phang}
{cmd:textfirst} and {cmd:notextfirst}
     specify whether the keys are to be presented as descriptive text followed
     by the symbol or the symbol followed by descriptive text.  The usual
     default is {cmd:notextfirst}, so {cmd:textfirst} is the option.
     {cmd:textfirst} produces keys that look like this

	    {c TLC}{hline 50}{c TRC}
	    {c |}              Observed   o      Linear fit  {hline 3}   {c |}
	    {c |}         Quadratic fit  ---                       {c |}
	    {c BLC}{hline 50}{c BRC}

{pmore}
and {cmd:textfirst} {cmd:cols(1)} produces

	    {c TLC}{hline 21}{c TRC}
	    {c |}       Observed   o  {c |}
	    {c |}     Linear fit  {hline 3} {c |}
	    {c |}  Quadratic fit  --- {c |}
	    {c BLC}{hline 21}{c BRC}

{phang}
{cmd:stack}
    specifies that the symbol-text be presented vertically with
    the symbol on top (or with the descriptive text on top if {cmd:textfirst}
    is also specified).
    {cmd:legend(stack)} would produce

	    {c TLC}{hline 47}{c TRC}
	    {c |}        o                    {hline 16}  {c |}
	    {c |}  Observed                   Linear fit        {c |}
	    {c |}  -----------------                            {c |}
	    {c |}  Quadratic fit                                {c |}
	    {c BLC}{hline 47}{c BRC}

{pmore}
    {cmd:legend(stack} {cmd:symplacement(left)} {cmd:symxsize(13)}
    {cmd:forcesize} {cmd:rowgap(4))} would produce

	    {c TLC}{hline 47}{c TRC}
	    {c |}  o                          {hline 3}{space 13}  {c |}
	    {c |}  Observed                   Linear fit        {c |}
	    {c |}                                               {c |}
	    {c |}  ---                                          {c |}
	    {c |}  Quadratic fit                                {c |}
	    {c BLC}{hline 47}{c BRC}

{pmore}
    {cmd:stack} tends to be used to produce single-column keys.
    {cmd:legend(cols(1)} {cmd:stack} {cmd:symplacement(left)} {cmd:symxsize(13)}
    {cmd:forcesize} {cmd:rowgap(4))}
    produces

	    {c TLC}{hline 17}{c TRC}
	    {c |}  o{space 14}{c |}
	    {c |}  Observed       {c |}
	    {c |}{space 17}{c |}
	    {c |}  {hline 3}{space 12}{c |}
	    {c |}  Linear fit     {c |}
	    {c |}{space 17}{c |}
	    {c |}  ---{space 12}{c |}
	    {c |}  Quadratic fit  {c |}
	    {c BLC}{hline 17}{c BRC}

{pmore}
    This is the real use of {cmd:stack}:  to produce narrow, vertical keys.

{phang}
{cmd:rowgap(}{it:size}{cmd:)}
and
{cmd:colgap(}{it:size}{cmd:)}
    specify the distance between lines and the distance between columns.
    The defaults are {cmd:rowgap(1.4)} and {cmd:colgap(4.9)}.
    See {manhelpi size G-4}.

{phang}
{cmd:symplacement(}{it:compassdirstyle}{cmd:)}
    specifies how symbols are justified in the key.  The default is
    {cmd:symplacement(center)}, meaning that they are vertically and
    horizontally centered.  The two most commonly specified alternatives are
    {cmd:symplacement(right)} (right alignment) and {cmd:symplacement(left)}
    (left alignment).  See {manhelpi compassdirstyle G-4} for other
    alignment choices.

{phang}
{cmd:keygap(}{it:size}{cmd:)},
{cmd:symysize(}{it:size}{cmd:)},
{cmd:symxsize(}{it:size}{cmd:)},
and
{cmd:textwidth(}{it:size}{cmd:)}
    specify the height and width to be allocated for the key and the
    key's symbols and descriptive text:

		      {cmd:keygap()}
		       {c LT}{hline 3}{c RT}

	    {c TLC}{hline 10}{c TT}{hline 3}{c TT}{hline 20}{c TRC}   {c -}{c TT}{c -}
	    {c |}  {it:symbol}  {c |}   {c |}  {it:descriptive text}  {c |}    {c |}   {cmd:symysize()}
	    {c BLC}{hline 10}{c BT}{hline 3}{c BT}{hline 20}{c BRC}   {c -}{c BT}{c -}

	    {c LT}{hline 10}{c RT}   {c LT}{hline 20}{c RT}
	     {cmd:symxsize()}          {cmd:textwidth()}

{pmore}
    The defaults are

	    {hline 58}
	    {cmd:symxsize()}     13
	    {cmd:keygap()}        2
	    {cmd:textwidth()}    according to longest descriptive text line
	    {cmd:symysize()}     according to height of font (*)
	    {hline 58}
	    (*) The size of the font is set by the {it:textbox_option}
		{cmd:size(}{it:size}{cmd:)}; see {it:{help legend_options##textbox_options:textbox_options}} below.

{pmore}
    Markers are placed in the symbol area, centered according to
    {cmd:symplacement()}.

{pmore}
    Lines are placed in the symbol area vertically according to
    {cmd:symplacement()} and horizontally are drawn to length
    {cmd:symxsize()}.

{pmore}
    Color swatches fill the {cmd:symysize()} {it:x} {cmd:symxsize()} area.

{pmore}
    See {manhelpi size G-4} for information on specifying sizes.

{phang}
{cmd:forcesize}
    causes the sizes specified by {cmd:symysize()} and {cmd:symxsize()} to be
    respected.  If {cmd:forcesize} is not specified, once all the symbols have
    been placed for all the keys, the symbol area is compressed (or expanded)
    to be no larger than necessary to contain the symbols.

{phang}
{cmd:bmargin(}{it:marginstyle}{cmd:)}
     specifies the outer margin around the legend.  That is, it specifies
     how close other things appearing near to the legend can get.  Also see
     suboption {cmd:margin()} under
     {it:{help legend_options##subopts:Suboptions for use with legend(region())}}
     below for specifying the
     inner margin between the border and contents.  See 
     {manhelpi marginstyle G-4} for a list of margin choices.

{marker textbox_options}{...}
{phang}
{it:textbox_options}
     affect the rendition of the descriptive text associated with the keys.
     These are described in
     {manhelpi textbox_options G-3}.
     One of the most commonly specified {it:textbox_options} is
     {cmd:size(}{it:size}{cmd:)}, which specifies the size of font to
     be used for the descriptive text.

{phang}
{it:title_options}
     allow placing titles, subtitles, notes, and captions on legends.
     For instance, {cmd:legend(col(1) subtitle("Legend"))} produces

	    {c TLC}{hline 21}{c TRC}
	    {c |}        {bf:Legend}       {c |}
	    {c |}                     {c |}
	    {c |}  o   Observed       {c |}
	    {c |} {hline 3}  Linear fit     {c |}
	    {c |} ---  Quadratic fit  {c |}
	    {c BLC}{hline 21}{c BRC}

{pmore}
     Note our use of {cmd:subtitle()} and not {cmd:title()}; {cmd:title()}s
     are nearly always too big.
     See {manhelpi title_options G-3}.

{phang}
{cmd:region(}{it:roptions}{cmd:)}
     specifies the border and shading of the legend.
     You could remove the border around the legend by specifying
     {cmd:legend(region(lstyle(none)))} (thus doing away with the line)
     or
     {cmd:legend(region(lcolor(none)))} (thus making the line invisible).
     You could also give the legend a gray background tint
     by specifying
     {cmd:legend(region(fcolor(gs5)))}.
     See {it:{help legend_options##subopts:Suboptions for use with legend(region())}} below.


{marker subopts}{...}
{title:Suboptions for use with legend(region())}

{phang}
{cmd:style(}{it:areastyle}{cmd:)}
     specifies the overall style of the region in which the
     legend appears.  The other suboptions allow you to change
     the region's attributes individually, but {cmd:style()} provides
     the starting point.  See 
     {manhelpi areastyle G-4} for a list of choices.

{phang}
{cmd:color(}{it:colorstyle}{cmd:)}
    specifies the color and opacity of the background of the legend and the line
    used to outline it.  See {manhelpi colorstyle G-4} for a list of color
    choices.

{phang}
{cmd:fcolor(}{it:colorstyle}{cmd:)}
    specifies the background (fill) color and opacity for the legend.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:lstyle(}{it:linestyle}{cmd:)}
    specifies the overall style of the line used to outline the legend,
    which includes its pattern (solid, dashed, etc.), its thickness, and
    its color.  The other suboptions listed below allow you to
    change the line's attributes individually,
    but {cmd:lstyle()} is the starting point.
    See {manhelpi linestyle G-4} for a list of choices.

{phang}
{cmd:lcolor(}{it:colorstyle}{cmd:)}
    specifies the color and opacity of the line used to outline the legend.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:lwidth(}{it:linewidthstyle}{cmd:)}
    specifies the thickness of the line used to outline the legend.
    See {manhelpi linewidthstyle G-4} for a list of choices.

{phang}
{cmd:lpattern(}{it:linepatternstyle}{cmd:)}
    specifies whether the line used to outline the legend is solid, dashed,
    etc.
    See {manhelpi linepatternstyle G-4} for a list of choices.

{phang}
{cmd:lalign(}{it:linealignmentstyle}{cmd:)}
    specifies whether the line used to outline the area is inside, outside,
    or centered.
    See {manhelpi linealignmentstyle G-4} for a list of alignment choices.

{phang}
{cmd:margin(}{it:marginstyle}{cmd:)}
    specifies the inner margin between the border and the contents of the
    legend.  Also see
    {cmd:bmargin()} under
    {it:{help legend_options##content_subopts:Content suboptions for use with legend() and plegend()}}
    above for specifying the outer margin around the legend.
    See {manhelpi marginstyle G-4} for a list of margin choices.


{marker location_subopts}{...}
{title:Location suboptions for use with legend()}

{phang}
{cmd:off} and {cmd:on}
    determine whether the legend appears.
    The default is {cmd:on} when more than one
    symbol (meaning marker, line style, or color swatch) appears in
    the legend.  In those cases, {cmd:legend(off)} will suppress the
    display of the legend.

{phang}
{cmd:position(}{it:clockposstyle}{cmd:)},
{cmd:ring(}{it:ringposstyle}{cmd:)}, and
{cmd:bplacement(}{it:compassdirstyle}{cmd:)}
    override the default location of the legend, which is usually centered
    below the plot region.  {cmd:position()} specifies a direction [{it:sic}]
    according to the hours on the dial of a 12-hour clock, and {cmd:ring()}
    specifies the distance from the plot region.

{pmore}
    {cmd:ring(0)} is defined as being inside the plot region itself and allows you
    to place the legend inside the plot.  {cmd:ring(}{it:k}{cmd:)}, {it:k}>0,
    specifies positions outside the plot region; the larger the {cmd:ring()}
    value, the farther away from the plot region the legend is.  {cmd:ring()}
    values may be integers or nonintegers and are treated ordinally.
    
{pmore}
    When {cmd:ring(0)} is specified, {cmd:bplacement()} further specifies
    where in the plot region the legend is placed.  {cmd:bplacement(seast)}
    places the legend in the southeast (lower-right) corner of the plot
    region.

{pmore}
    {cmd:position(12)} puts the legend directly above the plot region
    (assuming {cmd:ring()}>0), {cmd:position(3)} directly to the right
    of the plot region, and so on.

{pmore}
    See
    {it:{help legend_options##remarks3:Where legends appear}} under
    {it:Remarks} below and
    {it:{help title_options##remarks3:Positioning of titles}} in
    {manhelpi title_options G-3} for more information on
    the {cmd:position()} and {cmd:ring()} suboptions.

{phang}
{cmd:span} specifies that the legend be placed in an area spanning the
    entire width (or height) of the graph rather than an area spanning the
    plot region.
    This affects whether the legend is centered with respect to the plot
    region or the entire graph.
    See {it:{help title_options##remarks5:Spanning}} in
    {manhelpi title_options G-3} for more information on {cmd:span}.

{phang}
{cmd:at(}{it:#}{cmd:)}
    is for use only when the {it:twoway_option} {cmd:by()} is also
    specified.  It specifies that the legend appear in the
    {it:#}th position of the
    {it:RxC} array of plots, using the same coding as
    {cmd:by(}...{cmd:,} {cmd:holes())}.  See
    {it:{help legend_options##remarks5:Use of legends with by()}} under
    {it:Remarks} below, and see {manhelpi by_option G-3}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help legend_options##remarks1:When legends appear}
	{help legend_options##remarks2:The contents of legends}
	{help legend_options##remarks3:Where legends appear}
	{help legend_options##remarks4:Putting titles on legends}
	{help legend_options##remarks5:Use of legends with by()}
	{help legend_options##remarks6:Problems arising with or because of legends}


{marker remarks1}{...}
{title:When legends appear}

{pstd}
Standard legends appear on the graph whenever more than one symbol is used, where
symbol is broadly defined to include markers, lines, and color swatches
(such as those used to fill bars).  When you draw a graph with only one
symbol on it, such as

	{cmd:. sysuse uslifeexp}

	{cmd:. line le year}
	  {it:({stata "gr_example uslifeexp: line le year":click to run})}
{* graph legend1}{...}

{pstd}
no legend appears.  When there is more than one symbol, a legend is added:

	{cmd:. line le_m le_f year}
	  {it:({stata "gr_example uslifeexp: line le_male le_female year":click to run})}
{* graph legend2}{...}

{pstd}
Even when there is only one symbol, a legend is constructed.  It is merely
not displayed.  Specifying {cmd:legend(on)} forces the display of the
legend:

	{cmd:. line le year, legend(on)}
	  {it:({stata "gr_example uslifeexp: line le year, legend(on)":click to run})}
{* graph legend3}{...}

{pstd}
Similarly, when there is more than one symbol and you do not want the
legend, you can specify {cmd:legend(off)} to suppress it:

	{cmd:. line le_m le_f year, legend(off)}
	  {it:({stata "gr_example uslifeexp: line le_male le_female year, legend(off)":click to run})}

{pstd}
A {cmd:plegend()} appears on any graph that includes a
{helpb twoway contourline:contourline} plot.


{marker remarks2}{...}
{title:The contents of legends}

{pstd}
By default, the descriptive text for legends is obtained from the
variable's variable label; see {manhelp label D}.  If the variable has no
variable label, the variable's name is used.  In

	{cmd:. line le_m le_f year}

{pstd}
the variable le_m had previously been labeled "Life expectancy, males", and the
variable le_f had been labeled "Life expectancy, females".  In the legend of
this graph, repeating "life expectancy" is unnecessary.  The graph would
be improved if we changed the labels on the variables:

	{cmd:. label var le_m "Males"}

	{cmd:. label var le_f "Females"}

	{cmd:. line le_m le_f year}

{pstd}
We can also specify the {cmd:label()} suboption to change the
descriptive text.  We obtain the same visual result without relabeling our
variables:

{phang2}
	{cmd:. line le_m le_f year, legend(label(1 "Males") label(2 "Females"))}
{p_end}
	  {it:({stata `"gr_example uslifeexp: line le_male le_female year, legend(label(1 "Males") label(2 "Females"))"':click to run})}
{* graph legend5}{...}

{pstd}
The descriptive text for {cmd:contourline} legends is the values for the contour
lines of the {it:z} variable.


{marker remarks3}{...}
{title:Where legends appear}

{pstd}
By default, standard legends appear beneath the plot, centered, at what is
technically referred to as {cmd:position(6)} {cmd:ring(3)}.  By default,
{cmd:plegends()} appear to the right of the plot region at {cmd:position(3)}
{cmd:ring(4)}.  Suboptions {cmd:position()} and {cmd:ring()} specify the
location of the legend.  {cmd:position()} specifies on which side of the plot
region the legend appears -- {cmd:position(6)} means 6 o'clock -- and
{cmd:ring()} specifies the distance from the plot region -- {cmd:ring(3)}
means farther out than the {it:title_option} {cmd:b2title()} but inside the
{it:title_option} {cmd:note()}; see {manhelpi title_options G-3}.

{pstd}
If we specify {cmd:legend(position(3))}, the legend will be moved to the
3 o'clock position:

	{cmd:. line le_m le_f year, legend(pos(3))}
	  {it:({stata "gr_example uslifeexp: line le_male le_female year, legend(pos(3))":click to run})}
{* graph legend6}{...}

{pstd}
This may not be what we desired, but it is what we asked for.  The legend was
moved to the right of the graph and, given the size of the legend, the graph was
squeezed to fit.  When you move legends to the side, you invariably also want
to specify the {cmd:col(1)} option:

	{cmd:. line le_m le_f year, legend(pos(3) col(1))}
	  {it:({stata "gr_example uslifeexp: line le_male le_female year, legend(pos(3) col(1))":click to run})}
{* graph legend7}{...}

{pstd}
As a matter of syntax, we could have typed the above command with two
{cmd:legend()} options

{phang2}
	{cmd:. line le_m le_f year, legend(pos(3)) legend(col(1))}

{pstd}
instead of one combined:  {cmd:legend(pos(3) col(1))}.
We would obtain the same results either way.

{pstd}
If we ignore the syntax, the above graph would look better with less-descriptive
text,

	{cmd:. line le_m le_f year, legend(pos(3) col(1)}
				       {cmd:lab(1 "Males") lab(2 "Females"))}
	  {it:({stata `"gr_example uslifeexp: line le_m le_f year, legend(pos(3) col(1) lab(1 "Males") lab(2 "Females"))"':click to run})}
{* graph legend8}{...}

{pstd}
and we can further reduce the width required by the legend by specifying
the {cmd:stack} suboption:

	{cmd:. line le_m le_f year, legend(pos(3) col(1)}
				       {cmd:lab(1 "Males") lab(2 "Females") stack)}
	  {it:({stata `"gr_example uslifeexp: line le_m le_f year, legend(pos(3) col(1) lab(1 "Males") lab(2 "Females") stack)"':click to run})}
{* graph legend9}{...}

{pstd}
We can make this look better by placing a blank line between the first and
second keys:

	{cmd:. line le_m le_f year, legend(pos(3) col(1)}
				       {cmd:lab(1 "Males") lab(2 "Females") stack}
				       {cmd:order(1 - " " 2))}
	  {it:({stata `"gr_example uslifeexp: line le_m le_f year, legend(pos(3) col(1) lab(1 "Males") lab(2 "Females") stack order(1 - " " 2))"':click to run})}
{* graph legend10}{...}

{pstd}
{cmd:ring()} -- the suboption that specifies the distance from the plot
region -- is seldom specified, but, when it is specified, {cmd:ring(0)} is
the most useful.  {cmd:ring(0)} specifies that the legend be moved inside the
plot region:

	{cmd:. line le_m le_f year, legend(pos(5) ring(0) col(1)}
				       {cmd:lab(1 "Males") lab(2 "Females"))}
	  {it:({stata `"gr_example uslifeexp: line le_m le_f year, legend(pos(5) ring(0) col(1) lab(1 "Males") lab(2 "Females"))"':click to run})}
{* graph legend11}{...}

{pstd}
Our use of {cmd:position(5) ring(0)} put the legend inside the plot region,
at 5 o'clock, meaning in the bottom right corner.  Had we specified
{cmd:position(2) ring(0)}, the legend would have appeared in the top left
corner.

{pstd}
We might now add some background color to the legend:

	{cmd:. line le_m le_f year, legend(pos(5) ring(0) col(1)}
				       {cmd:lab(1 "Males") lab(2 "Females")}
				       {cmd:region(fcolor(gs15)))}
	  {it:({stata `"gr_example uslifeexp: line le_m le_f year, legend(pos(5) ring(0) col(1) lab(1 "Males") lab(2 "Females") region(fcolor(gs15)))"':click to run})}
{* graph legend12}{...}


{marker remarks4}{...}
{title:Putting titles on legends}

{pstd}
Legends may include titles:

	{cmd:. line le_m le_f year, legend(pos(5) ring(0) col(1)}
				       {cmd:lab(1 "Males") lab(2 "Females")}
				       {cmd:region(fcolor(gs15)))}
			       {cmd:legend(subtitle("Legend"))}
	  {it:({stata `"gr_example uslifeexp: line le_m le_f year, legend(pos(5) ring(0) col(1) lab(1 "Males") lab(2 "Females") region(fcolor(gs15))) legend(subtitle("Legend"))"':click to run})}
{* graph legend13}{...}


{pstd}
Above we specified {cmd:subtitle()} rather than {cmd:title()} because, when
we tried {cmd:title()}, it seemed too big.

{pstd}
Legends may also contain {cmd:notes()} and {cmd:captions()}; see 
{manhelpi title_options G-3}.


{* legends, use with by() tt}{...}
{* index by() tt, use of legends with}{...}
{marker use_of_legends_with_by}{...}
{marker remarks5}{...}
{title:Use of legends with by()}

{pstd}
If you want the legend to be located in the default location, no special
action need be taken when you use {cmd:by()}:

	{cmd:. sysuse auto, clear}

{phang2}
	{cmd:. scatter mpg weight || lfit mpg weight ||, by(foreign, total row(1))}
{p_end}
	  {it:({stata "gr_example auto: scatter mpg weight || lfit mpg weight ||, by(foreign, total row(1))":click to run})}
{* graph legend14}{...}

{pstd}
If, however, you wish to move the legend, you must distinguish between
{cmd:legend(}{it:contents}{cmd:)} and {cmd:legend(}{it:location}{cmd:)}.
The former must appear outside the {cmd:by()}.  The latter appears
inside the {cmd:by()}:

	{cmd:. scatter mpg weight || lfit mpg weight ||,}
		  {cmd:legend(cols(1))}
		  {cmd:by(foreign, total legend(pos(4)))}
	  {it:({stata "gr_example auto: scatter mpg weight || lfit mpg weight ||, legend(cols(1)) by(foreign, total legend(pos(4)))":click to run})}
{* graph legend15}{...}

{pstd}
{cmd:legend(col(1))} was placed in the command just where we
would place it had we not specified {cmd:by()} but that
{cmd:legend(pos(4))} was moved to be inside the {cmd:by()} option.
We did that because the {cmd:cols()} suboption is documented under
{it:contents} in the syntax diagram, whereas {cmd:position()} is documented
under {it:location}.  The logic is that, at the time the individual plots are
constructed, they must know what style of key they are producing.  The
placement of the key, however, is something that happens when the overall
graph is assembled, so you must indicate to {cmd:by()} where the key is to be
placed.  Were we to forget this distinction and simply to type

	{cmd:. scatter mpg weight || lfit mpg weight ||,}
		  {cmd:legend(cols(1) pos(4))}
		  {cmd:by(foreign, total)}

{pstd}
the {cmd:cols(1)} suboption would have been ignored.

{pstd}
Another {it:location} suboption is provided for use with 
{cmd:by()}:  {cmd:at(}{it:#}{cmd:)}.  You specify this option to tell
{cmd:by()} to place the legend inside the {it:RxC} array it creates:

	{cmd:. scatter mpg weight || lfit mpg weight ||,}
		  {cmd:legend(cols(1))}
		  {cmd:by(foreign, total legend(at(4) pos(0)))}
	  {it:({stata "gr_example auto: scatter mpg weight || lfit mpg weight ||, legend(cols(1)) by(foreign, total legend(at(4) pos(0)))":click to run})}
{* graph legend16}{...}

{pstd}
In the above, we specified {cmd:at(4)} to mean that the key was to appear
in the fourth position of the 2{it:x}2 array, and we specified
{cmd:pos(0)} to move the key to the middle (0 o'clock) position within
the cell.

{pstd}
If you wish to suppress the legend, you must specify the
{cmd:legend(off)} inside
the {cmd:by()} option:

	{cmd:. scatter mpg weight || lfit mpg weight ||,}
		  {cmd:by(foreign, total legend(off))}


{* index legends, problems}{...}
{marker remarks6}{...}
{title:Problems arising with or because of legends}

{pstd}
There are two potential problems associated with legends:

{phang2}
    1.  Text may flow outside the border of the legend box.

{phang2}
    2.  The presence of the legend may cause the title of the {it:y} axis
	to run into the values labeled on the axis.

{pstd}
The first problem arises because Stata uses an approximation to obtain the
width of a text line.   One solution is to specify
{cmd:region(margin())} to add margin space around
the legend:

{phang2}
	{cmd:. graph} ...{cmd:,} ... {cmd:legend(region(margin(}{it:marginstyle}{cmd:)))}

{pstd}
Other solutions are available, such as {cmd:rows()} and {cmd:cols()}; see
{help legend_options##syntax:{it:Syntax}}.

{pstd}
The second problem arises when the key is in its default {cmd:position(6)}
(6 o'clock) location and the descriptive text for one or more of the keys is
long.  In {cmd:position(6)}, the borders of the key are supposed to line
up with the borders of the plot region.  Usually the plot region is wider than
the key, so the key is expanded to fit below it.  When the key is wider
than the plot region, however, it is the plot region that is widened.  As the
plot region expands, it will eat away at whatever is at it sides, namely, the
{it:y} axis labels and title.  Margins will disappear.  In extreme cases, the
title will be printed on top of the labels, and the labels themselves may end
up on top of the axis!

{pstd}
The solution to this problem is to shorten the descriptive text, either
by using fewer words or by breaking the long description into multiple
lines.  Use
the {cmd:legend(label(}{it:#} {cmd:"}{it:text}{cmd:"))} option to modify
the longest line of the descriptive text.
{p_end}
