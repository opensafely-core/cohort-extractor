{smcl}
{* *! version 1.3.2  19oct2017}{...}
{vieweralsosee "[G-4] text" "mansection G-4 text"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph set" "help graph_set"}{...}
{vieweralsosee "[G-3] eps_options" "help eps_options"}{...}
{vieweralsosee "[G-3] ps_options" "help ps_options"}{...}
{vieweralsosee "[G-3] svg_options" "help svg_options"}{...}
{vieweralsosee "[P] smcl" "help smcl"}{...}
{viewerjumpto "Description" "graph_text##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_text##linkspdf"}{...}
{viewerjumpto "Remarks" "graph_text##remarks"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[G-4]} {it:text} {hline 2}}Text in graphs{p_end}
{p2col:}({mansection G-4 text:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Text elements in Stata graphs, like text in the rest of Stata, can contain
Unicode characters.  In addition,
all text elements in Stata graphs support the use of certain
SMCL markup directives, or tags, to affect how they appear on the screen.
SMCL, which stands for Stata Markup and Control Language and
is pronounced "smickle", is Stata's output language and is
discussed in detail in {manhelp smcl P}.

{pstd}
All text output in Stata, including text in graphs, can be modified
with SMCL.

{pstd}
For example, you can italicize a word in a graph title:

{phang2}
{cmd:. scatter mpg weight, title("This is {c -(}it:italics{c )-} in a graph title")}{break}
({it:{stata `"gr_example auto: scatter mpg weight, title("This is {it:italics} in a graph title")"':click to run}})

{pstd}
This entry documents the features of SMCL that are unique to graphs.
We recommend that you have a basic understanding of SMCL before reading
this entry; see {manhelp smcl P}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 textRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help graph_text##overview:Overview}
        {help graph_text##appearance1:Bold and italics}
        {help graph_text##appearance2:Superscripts and subscripts}
        {help graph_text##appearance3:Fonts, standard}
        {help graph_text##appearance4:Fonts, advanced}
        {help graph_text##symbols:Greek letters and other symbols}
        {help graph_text##smcl:Full list of SMCL tags useful in graph text}


{marker overview}{...}
{title:Overview}

{pstd}
Assuming you read {manhelp smcl P} before reading this entry, you
know about the four syntaxes that SMCL tags follow.  As a refresher,
the syntaxes are

{center:Syntax 1:  {cmd:{c -(}xyz{c )-}}          }
{center:Syntax 2:  {cmd:{c -(}xyz:}{it:text}{cmd:{c )-}}     }
{center:Syntax 3:  {cmd:{c -(}xyz} {it:args}{cmd:{c )-}}     }
{center:Syntax 4:  {cmd:{c -(}xyz} {it:args}{cmd::}{it:text}{cmd:{c )-}}}

{pstd}
Syntax 1 means "do whatever it is that {cmd:{c -(}xyz{c )-}} does".
Syntax 2 means "do whatever it is that {cmd:{c -(}xyz{c )-}} does, do it on
the text {it:text}, and then stop doing it".  Syntax 3 means "do whatever it
is that {cmd:{c -(}xyz{c )-}} does, as modified by {it:args}".  Finally,
syntax 4 means "do whatever it is that {cmd:{c -(}xyz{c )-}} does, as
modified by {it:args}, do it on the text {it:text}, and then stop doing it".

{pstd}
Most SMCL tags useful in graph text follow syntax 1 and syntax 2,
and one ({cmd:{c -(}fontface{c )-}}) follows syntax 3 and syntax 4.


{marker appearance1}{...}
{title:Bold and italics}

{pstd}
Changing text in graphs to {bf:bold} or {it:italics} is done in exactly
the same way as in the Results window.  Simply use the SMCL
{cmd:{c -(}bf{c )-}} and {cmd:{c -(}it{c )-}} tags:

{phang2}
{cmd}. scatter mpg weight, caption("{c -(}bf:Source{c )-}: {c -(}it:Consumer Reports{c )-}, used with permission")}{break}
{txt}({it:{stata `"gr_example auto: scatter mpg weight, caption("{bf:Source}: {it:Consumer Reports}, used with permission")"':click to run}})

{pstd}
{cmd:{c -(}bf{c )-}} and {cmd:{c -(}it{c )-}} follow syntaxes 1 and 2.


{marker appearance2}{...}
{title:Superscripts and subscripts}

{pstd}
You can include superscripts and subscripts in text in graphs.
This may surprise you, because it is not possible to do so with
text in the Results window.  Because graphs are not constrained to
use fixed-width fonts and fixed-height lines like output in the
Results window, it is possible to allow more features for text in
graphs.

{pstd}
It is simple to use the {cmd:{c -(}superscript{c )-}} and
{cmd:{c -(}subscript{c )-}} tags to cause a piece of text to be
displayed as a superscript or a subscript.  Here we will plot
a function and will change the title of the graph to something
appropriate:

{phang2}
{cmd}. twoway function y = 2*exp(-2*x), range(0 2) ///{break}
title("{c -(}&function{c )-}(x)=2e{c -(}superscript:-2x{c )-}"){break}
{txt}({it:{stata "gr_example2 funcsup1":click to run}})

{pstd}
{cmd:{c -(}superscript{c )-}} and {cmd:{c -(}subscript{c )-}} follow syntaxes 1 and 2.
{cmd:{c -(}sup{c )-}} and {cmd:{c -(}sub{c )-}} may be used as shorthand
for {cmd:{c -(}superscript{c )-}} and {cmd:{c -(}subscript{c )-}}.

{pstd}
The example above also demonstrates the use of a symbol,
{cmd:{c -(}&function{c )-}}; symbols will be discussed in more detail below.


{marker appearance3}{...}
{title:Fonts, standard}

{pstd}
Stata provides four standard font faces for graphs to allow text to
be displayed in a sans-serif font (the default), a serif font,
a monospace (fixed-width) font, or a symbol font.  These fonts
have been chosen to work across operating systems and in graphs
exported to PostScript and Encapsulated PostScript files.  Unicode characters,
such as Chinese characters, which are not available in the Latin1
encoding, are not available in PostScript, because PostScript fonts do not
support them.

{pstd}
The SMCL tags used to mark text to be displayed in any of these
fonts and the fonts that are used on each type of system are shown
below:

           SMCL {c |} {cmd:{c -(}stSans{c )-}}    {cmd:{c -(}stSerif{c )-}}         {cmd:{c -(}stMono{c )-}}      {cmd:{c -(}stSymbol{c )-}}
        {dup 8:{c -}}{c +}{dup 56:{c -}}
        Windows {c |} Arial       Times New Roman   Courier New   Symbol
            Mac {c |} Helvetica   Times             Courier       Symbol
           Unix {c |} Sans        Serif             Monospace     Sans
         PS/EPS {c |} Helvetica   Times             Courier       Symbol

{pstd}
Note: We recommend that you leave in place the mapping from these four
SMCL tags to the fonts we have selected for each operating system.
However, you may override the default fonts if you wish.  See
{manhelp graph_set G-2:graph set} for details.

{pstd}
Changing fonts within text on a graph is easy:

{phang2}
{cmd:. scatter mpg weight, title("Here are {c -(}stSerif:serif{c )-}, {c -(}stSans:sans serif{c )-}, and {c -(}stMono:monospace{c )-}")}{break}
({it:{stata `"gr_example auto: scatter mpg weight, title("Here are {stSerif:serif}, {stSans:sans serif}, and {stMono:monospace}")"':click to run}})

{pstd}
{cmd:{c -(}stSans{c )-}},
{cmd:{c -(}stSerif{c )-}},
{cmd:{c -(}stMono{c )-}}, and
{cmd:{c -(}stSymbol{c )-}}
follow syntaxes 1 and 2.

{pstd}
The {cmd:{c -(}stSymbol{c )-}} tag lets you display hundreds of different
symbols, such as Greek letters and math symbols.  There are so many
possibilities that symbols have their own shorthand notation to help
you type them and have their own section describing how to use them.
See {it:{help graph_text##symbols:Greek letters and other symbols}} below.
Remember that you can also use Unicode characters.


{marker appearance4}{...}
{title:Fonts, advanced}

{pstd}
In addition to the four standard fonts, you may display text in a graph
using any font available on your operating system by using the
{cmd:{c -(}fontface{c )-}} tag.  If the font face you wish to
specify contains spaces in its name, be sure to enclose it in
double quotes within the {cmd:{c -(}fontface{c )-}} tag.  For
example, to display text using a font on your system named
"Century Schoolbook", you would type

{phang2}
{cmd:. scatter mpg weight, title(`"Text in {c -(}fontface "Century Schoolbook":a different font{c )-}"')}{break}
({it:{stata `"gr_example auto: scatter mpg weight, title(`"Text in {fontface "Century Schoolbook":a different font}"')"':click to run}})

{pstd}
If the font face you specify does not exist on your system, the operating
system will substitute another font.

{pstd}
{cmd:{c -(}fontface{c )-}} follows syntaxes 3 and 4.

{pstd}
The four standard fonts may also be specified using the
{cmd:{c -(}fontface{c )-}} tag.  For example, you can specify the
default serif font with {cmd:{c -(}fontface "stSerif"{c )-}}; in
fact, {cmd:{c -(}stSerif{c )-}} is shorthand for exactly that.

{pstd}
If you choose to change fonts in graphs by using the {cmd:{c -(}fontface{c )-}}
tag, keep in mind that if you share your Stata {cmd:.gph} files with other
Stata users, they must have the exact same fonts on their system for the
graphs to display properly.  Also, if you need to export your graphs to
PostScript or Encapsulated PostScript files, Stata will have to try
to convert your operating system's fonts to PostScript fonts and embed
them in the exported file.  It is not always possible to properly
convert and embed all fonts, which is why we recommend using one of
the four standard fonts provided by Stata.

{pstd}
In Stata for Unix, if you use fonts other than the four standard fonts
and you wish to export your graphs to PostScript or Encapsulated PostScript
files, you may need to specify the directory where your system fonts
are located; see {manhelpi ps_options G-3}.


{marker symbols}{...}
{title:Greek letters and other symbols}

{pstd}
Stata provides support for many symbols in text in graphs, including
both capital and lowercase forms of the Greek alphabet and many math
symbols.

{pstd}
You may already be familiar with the {cmd:{c -(}char{c )-}} tag
-- synonym {cmd:{c -(}c{c )-}} -- which follows syntax 3 and allows you
to output any ASCII character.  If not, see 
{it:{help smcl##ascii:Displaying characters using ASCII code}} in
{manhelp smcl P}.  All the features of {cmd:{c -(}char{c )-}},
except for the line-drawing characters, may be used in graph text.

{pstd}
Graph text supports even more symbols than {cmd:{c -(}char{c )-}}.
For the symbols Stata supports, we have chosen to define SMCL tags
with names that parallel HTML character entity references.  HTML
character entity references have wide usage and, for the most part,
have very intuitive names for whatever symbol you wish to display.

{pstd}
In HTML, character entity references are of the form
"{cmd:&}{it:name}{cmd:;}", where {it:name} is supposed to be
an intuitive name for the given character entity.  In SMCL,
the tag for a given character entity is "{cmd:{c -(}&}{it:name}{cmd:{c )-}}".

{pstd}
For example, in HTML, the character reference for a capital
Greek Sigma is {cmd:&Sigma;}.  In SMCL, the tag for a capital
Greek Sigma is
 {cmd:{c -(}&Sigma{c )-}}.

{pstd}
In some cases, the HTML character reference for a particular
symbol has a name that is not so intuitive.  For example, HTML
uses {cmd:&fnof;} for the "function" symbol ({it:f}).  SMCL
provides {cmd:{c -(}&fnof{c )-}} to match the HTML character
reference, as well as the more intuitive {cmd:{c -(}&function{c )-}}.

{pstd}
All SMCL symbol tags follow syntax 1.

{pstd}
See 
{it:{help graph_text##smcl:Full list of SMCL tags useful in graph text}}
for a complete list of symbols supported by SMCL in graphs.

{pstd}
As an example, we will graph a function and give it an appropriate title:

{phang2}
{cmd}. twoway function y = gammaden(1.5,2,0,x), range(0 10) ///{break}
title("{c -(}&chi{c )-}{c -(}sup:2{c )-}(3) distribution"){break}
{txt}({it:{stata "gr_example2 funcsup2":click to run}})

{pstd}
Graphs rendered to the screen or exported to disk will typically 
display Greek letters and other math symbols with Unicode characters using
the current font.
The Postscript format does not support Unicode characters, so
Greek letters and other math symbols are displayed using the
{cmd:{c -(}stSymbol{c )-}} font.  For example,
{cmd:{c -(}&Alpha{c )-}} is equivalent to {cmd:{c -(}stSymbol:A{c )-}}.


{marker smcl}{...}
{title:Full list of SMCL tags useful in graph text}

{pstd}
The SMCL tags that are useful in graph text are the following:

{p2colset 8 30 32 4}{...}
{p2col :SMCL tag}Description{p_end}
{p2line}
{p2col :{cmd:{c -(}bf{c )-}}}Make text bold{p_end}
{p2col :{cmd:{c -(}it{c )-}}}Make text italic{p_end}
{p2col :{cmd:{c -(}superscript{c )-}}}Display text as a superscript{p_end}
{p2col :{cmd:{c -(}sup{c )-}}}Synonym for {cmd:{c -(}superscript{c )-}}{p_end}
{p2col :{cmd:{c -(}subscript{c )-}}}Display text as a subscript{p_end}
{p2col :{cmd:{c -(}sub{c )-}}}Synonym for {cmd:{c -(}subscript{c )-}}{p_end}
{p2col :{cmd:{c -(}stSans{c )-}}}Display text with the default sans serif font{p_end}
{p2col :{cmd:{c -(}stSerif{c )-}}}Display text with the default serif font{p_end}
{p2col :{cmd:{c -(}stMono{c )-}}}Display text with the default monospace (fixed-width) font{p_end}
{p2col :{cmd:{c -(}stSymbol{c )-}}}Display text with the default symbol font{p_end}
{p2col :{cmd:{c -(}fontface "}{it:fontname}{cmd:"{c )-}}}Display text with the specified {it:fontname}{p_end}
{p2col :{cmd:{c -(}char }{it:code}{c )-}}Display ASCII character{p_end}
{p2col :{cmd:{c -(}&}{it:symbolname}{cmd:{c )-}}}Display a Greek letter, math symbol, or other symbol{p_end}
{p2line}

{pstd}
The Greek letters supported by SMCL in graph text are the following:

{p2colset 8 30 32 4}{...}
{p2col :SMCL tag}Description{p_end}
{p2line}
{p2col :{cmd:{c -(}&Alpha{c )-}}}Capital Greek letter Alpha{p_end}
{p2col :{cmd:{c -(}&Beta{c )-}}}Capital Greek letter Beta{p_end}
{p2col :{cmd:{c -(}&Gamma{c )-}}}Capital Greek letter Gamma{p_end}
{p2col :{cmd:{c -(}&Delta{c )-}}}Capital Greek letter Delta{p_end}
{p2col :{cmd:{c -(}&Epsilon{c )-}}}Capital Greek letter Epsilon{p_end}
{p2col :{cmd:{c -(}&Zeta{c )-}}}Capital Greek letter Zeta{p_end}
{p2col :{cmd:{c -(}&Eta{c )-}}}Capital Greek letter Eta{p_end}
{p2col :{cmd:{c -(}&Theta{c )-}}}Capital Greek letter Theta{p_end}
{p2col :{cmd:{c -(}&Iota{c )-}}}Capital Greek letter Iota{p_end}
{p2col :{cmd:{c -(}&Kappa{c )-}}}Capital Greek letter Kappa{p_end}
{p2col :{cmd:{c -(}&Lambda{c )-}}}Capital Greek letter Lambda{p_end}
{p2col :{cmd:{c -(}&Mu{c )-}}}Capital Greek letter Mu{p_end}
{p2col :{cmd:{c -(}&Nu{c )-}}}Capital Greek letter Nu{p_end}
{p2col :{cmd:{c -(}&Xi{c )-}}}Capital Greek letter Xi{p_end}
{p2col :{cmd:{c -(}&Omicron{c )-}}}Capital Greek letter Omicron{p_end}
{p2col :{cmd:{c -(}&Pi{c )-}}}Capital Greek letter Pi{p_end}
{p2col :{cmd:{c -(}&Rho{c )-}}}Capital Greek letter Rho{p_end}
{p2col :{cmd:{c -(}&Sigma{c )-}}}Capital Greek letter Sigma{p_end}
{p2col :{cmd:{c -(}&Tau{c )-}}}Capital Greek letter Tau{p_end}
{p2col :{cmd:{c -(}&Upsilon{c )-}}}Capital Greek letter Upsilon{p_end}
{p2col :{cmd:{c -(}&Phi{c )-}}}Capital Greek letter Phi{p_end}
{p2col :{cmd:{c -(}&Chi{c )-}}}Capital Greek letter Chi{p_end}
{p2col :{cmd:{c -(}&Psi{c )-}}}Capital Greek letter Psi{p_end}
{p2col :{cmd:{c -(}&Omega{c )-}}}Capital Greek letter Omega{p_end}
{p2col :{cmd:{c -(}&alpha{c )-}}}Lowercase Greek letter alpha{p_end}
{p2col :{cmd:{c -(}&beta{c )-}}}Lowercase Greek letter beta{p_end}
{p2col :{cmd:{c -(}&gamma{c )-}}}Lowercase Greek letter gamma{p_end}
{p2col :{cmd:{c -(}&delta{c )-}}}Lowercase Greek letter delta{p_end}
{p2col :{cmd:{c -(}&epsilon{c )-}}}Lowercase Greek letter epsilon{p_end}
{p2col :{cmd:{c -(}&zeta{c )-}}}Lowercase Greek letter zeta{p_end}
{p2col :{cmd:{c -(}&eta{c )-}}}Lowercase Greek letter eta{p_end}
{p2col :{cmd:{c -(}&theta{c )-}}}Lowercase Greek letter theta{p_end}
{p2col :{cmd:{c -(}&thetasym{c )-}}}Greek theta symbol{p_end}
{p2col :{cmd:{c -(}&iota{c )-}}}Lowercase Greek letter iota{p_end}
{p2col :{cmd:{c -(}&kappa{c )-}}}Lowercase Greek letter kappa{p_end}
{p2col :{cmd:{c -(}&lambda{c )-}}}Lowercase Greek letter lambda{p_end}
{p2col :{cmd:{c -(}&mu{c )-}}}Lowercase Greek letter mu{p_end}
{p2col :{cmd:{c -(}&nu{c )-}}}Lowercase Greek letter nu{p_end}
{p2col :{cmd:{c -(}&xi{c )-}}}Lowercase Greek letter xi{p_end}
{p2col :{cmd:{c -(}&omicron{c )-}}}Lowercase Greek letter omicron{p_end}
{p2col :{cmd:{c -(}&pi{c )-}}}Lowercase Greek letter pi{p_end}
{p2col :{cmd:{c -(}&piv{c )-}}}Greek pi symbol{p_end}
{p2col :{cmd:{c -(}&rho{c )-}}}Lowercase Greek letter rho{p_end}
{p2col :{cmd:{c -(}&sigma{c )-}}}Lowercase Greek letter sigma{p_end}
{p2col :{cmd:{c -(}&sigmaf{c )-}}}Greek 'final' sigma symbol{p_end}
{p2col :{cmd:{c -(}&tau{c )-}}}Lowercase Greek letter tau{p_end}
{p2col :{cmd:{c -(}&upsilon{c )-}}}Lowercase Greek letter upsilon{p_end}
{p2col :{cmd:{c -(}&upsih{c )-}}}Greek upsilon with a hook symbol{p_end}
{p2col :{cmd:{c -(}&phi{c )-}}}Lowercase Greek letter phi{p_end}
{p2col :{cmd:{c -(}&chi{c )-}}}Lowercase Greek letter chi{p_end}
{p2col :{cmd:{c -(}&psi{c )-}}}Lowercase Greek letter psi{p_end}
{p2col :{cmd:{c -(}&omega{c )-}}}Lowercase Greek letter omega{p_end}
{p2line}

{pstd}
Math symbols supported by SMCL in graph text are the following:

{p2colset 8 30 32 4}{...}
{p2col :SMCL tag}Description{p_end}
{p2line}
{p2col :{cmd:{c -(}&weierp{c )-}}}Weierstrass p, power set{p_end}
{p2col :{cmd:{c -(}&image{c )-}}}Imaginary part{p_end}
{p2col :{cmd:{c -(}&imaginary{c )-}}}Synonym for {cmd:{c -(}&image{c )-}}{p_end}
{p2col :{cmd:{c -(}&real{c )-}}}Real part{p_end}
{p2col :{cmd:{c -(}&alefsym{c )-}}}Alef, first transfinite cardinal{p_end}
{p2col :{cmd:{c -(}&amp{c )-}}}Ampersand{p_end}
{p2col :{cmd:{c -(}&lt{c )-}}}Less than{p_end}
{p2col :{cmd:{c -(}&gt{c )-}}}Greater than{p_end}
{p2col :{cmd:{c -(}&le{c )-}}}Less than or equal to{p_end}
{p2col :{cmd:{c -(}&ge{c )-}}}Greater than or equal to{p_end}
{p2col :{cmd:{c -(}&ne{c )-}}}Not equal to{p_end}
{p2col :{cmd:{c -(}&fnof{c )-}}}Function{p_end}
{p2col :{cmd:{c -(}&function{c )-}}}Synonym for {cmd:{c -(}&fnof{c )-}}{p_end}
{p2col :{cmd:{c -(}&forall{c )-}}}For all{p_end}
{p2col :{cmd:{c -(}&part{c )-}}}Partial differential{p_end}
{p2col :{cmd:{c -(}&exist{c )-}}}There exists{p_end}
{p2col :{cmd:{c -(}&empty{c )-}}}Empty set, null set, diameter{p_end}
{p2col :{cmd:{c -(}&nabla{c )-}}}Nabla, backward difference{p_end}
{p2col :{cmd:{c -(}&isin{c )-}}}Element of{p_end}
{p2col :{cmd:{c -(}&element{c )-}}}Synonym for {cmd:{c -(}&isin{c )-}}{p_end}
{p2col :{cmd:{c -(}&notin{c )-}}}Not an element of{p_end}
{p2col :{cmd:{c -(}&prod{c )-}}}N-ary product, product sign{p_end}
{p2col :{cmd:{c -(}&sum{c )-}}}N-ary summation{p_end}
{p2col :{cmd:{c -(}&minus{c )-}}}Minus sign{p_end}
{p2col :{cmd:{c -(}&plusmn{c )-}}}Plus-or-minus sign{p_end}
{p2col :{cmd:{c -(}&plusminus{c )-}}}Synonym for {cmd:{c -(}&plusmn{c )-}}{p_end}
{p2col :{cmd:{c -(}&lowast{c )-}}}Asterisk operator{p_end}
{p2col :{cmd:{c -(}&radic{c )-}}}Radical sign, square root{p_end}
{p2col :{cmd:{c -(}&sqrt{c )-}}}Synonym for {cmd:{c -(}&radic{c )-}}{p_end}
{p2col :{cmd:{c -(}&prop{c )-}}}Proportional to{p_end}
{p2col :{cmd:{c -(}&infin{c )-}}}Infinity{p_end}
{p2col :{cmd:{c -(}&infinity{c )-}}}Synonym for {cmd:{c -(}&infin{c )-}}{p_end}
{p2col :{cmd:{c -(}&ang{c )-}}}Angle{p_end}
{p2col :{cmd:{c -(}&angle{c )-}}}Synonym for {cmd:{c -(}&ang{c )-}}{p_end}
{p2col :{cmd:{c -(}&and{c )-}}}Logical and, wedge{p_end}
{p2col :{cmd:{c -(}&or{c )-}}}Logical or, vee{p_end}
{p2col :{cmd:{c -(}&cap{c )-}}}Intersection, cap{p_end}
{p2col :{cmd:{c -(}&intersect{c )-}}}Synonym for {cmd:{c -(}&cap{c )-}}{p_end}
{p2col :{cmd:{c -(}&cup{c )-}}}Union, cup{p_end}
{p2col :{cmd:{c -(}&union{c )-}}}Synonym for {cmd:{c -(}&cup{c )-}}{p_end}
{p2col :{cmd:{c -(}&int{c )-}}}Integral{p_end}
{p2col :{cmd:{c -(}&integral{c )-}}}Synonym for {cmd:{c -(}&int{c )-}}{p_end}
{p2col :{cmd:{c -(}&there4{c )-}}}Therefore{p_end}
{p2col :{cmd:{c -(}&therefore{c )-}}}Synonym for {cmd:{c -(}&there4{c )-}}{p_end}
{p2col :{cmd:{c -(}&sim{c )-}}}Tilde operator, similar to{p_end}
{p2col :{cmd:{c -(}&cong{c )-}}}Approximately equal to{p_end}
{p2col :{cmd:{c -(}&asymp{c )-}}}Almost equal to, asymptotic to{p_end}
{p2col :{cmd:{c -(}&equiv{c )-}}}Identical to{p_end}
{p2col :{cmd:{c -(}&sub{c )-}}}Subset of{p_end}
{p2col :{cmd:{c -(}&subset{c )-}}}Synonym for {cmd:{c -(}&sub{c )-}}{p_end}
{p2col :{cmd:{c -(}&sup{c )-}}}Superset of{p_end}
{p2col :{cmd:{c -(}&superset{c )-}}}Synonym for {cmd:{c -(}&sup{c )-}}{p_end}
{p2col :{cmd:{c -(}&nsub{c )-}}}Not a subset of{p_end}
{p2col :{cmd:{c -(}&nsubset{c )-}}}Synonym for {cmd:{c -(}&nsub{c )-}}{p_end}
{p2col :{cmd:{c -(}&sube{c )-}}}Subset of or equal to{p_end}
{p2col :{cmd:{c -(}&subsete{c )-}}}Synonym for {cmd:{c -(}&sube{c )-}}{p_end}
{p2col :{cmd:{c -(}&supe{c )-}}}Superset of or equal to{p_end}
{p2col :{cmd:{c -(}&supersete{c )-}}}Synonym for {cmd:{c -(}&supe{c )-}}{p_end}
{p2col :{cmd:{c -(}&oplus{c )-}}}Circled plus, direct sum{p_end}
{p2col :{cmd:{c -(}&otimes{c )-}}}Circled times, vector product{p_end}
{p2col :{cmd:{c -(}&perp{c )-}}}Perpendicular, orthogonal to, uptack{p_end}
{p2col :{cmd:{c -(}&orthog{c )-}}}Synonym for {cmd:{c -(}&perp{c )-}}{p_end}
{p2col :{cmd:{c -(}&sdot{c )-}}}Dot operator{p_end}
{p2col :{cmd:{c -(}&dot{c )-}}}Synonym for {cmd:{c -(}&sdot{c )-}}{p_end}
{p2col :{cmd:{c -(}&prime{c )-}}}Prime, minutes, feet{p_end}
{p2col :{cmd:{c -(}&Prime{c )-}}}Double prime, seconds, inches{p_end}
{p2col :{cmd:{c -(}&frasl{c )-}}}Fraction slash{p_end}
{p2col :{cmd:{c -(}&larr{c )-}}}Leftward arrow{p_end}
{p2col :{cmd:{c -(}&uarr{c )-}}}Upward arrow{p_end}
{p2col :{cmd:{c -(}&rarr{c )-}}}Rightward arrow{p_end}
{p2col :{cmd:{c -(}&darr{c )-}}}Downward arrow{p_end}
{p2col :{cmd:{c -(}&harr{c )-}}}Left-right arrow{p_end}
{p2col :{cmd:{c -(}&crarr{c )-}}}Downward arrow with corner leftward, carriage return{p_end}
{p2col :{cmd:{c -(}&lArr{c )-}}}Leftward double arrow, is implied by{p_end}
{p2col :{cmd:{c -(}&uArr{c )-}}}Upward double arrow{p_end}
{p2col :{cmd:{c -(}&rArr{c )-}}}Rightward double arrow, implies{p_end}
{p2col :{cmd:{c -(}&dArr{c )-}}}Downward double arrow{p_end}
{p2col :{cmd:{c -(}&hArr{c )-}}}Left-right double arrow{p_end}
{p2line}

{pstd}
Other symbols supported by SMCL in graph text are the following:

{p2colset 8 30 32 4}{...}
{p2col :SMCL tag}Description{p_end}
{p2line}
{p2col :{cmd:{c -(}&trade{c )-}}}Trademark{p_end}
{p2col :{cmd:{c -(}&trademark{c )-}}}Synonym for {cmd:{c -(}&trade{c )-}}{p_end}
{p2col :{cmd:{c -(}&reg{c )-}}}Registered trademark{p_end}
{p2col :{cmd:{c -(}&copy{c )-}}}Copyright{p_end}
{p2col :{cmd:{c -(}&copyright{c )-}}}Synonym for {cmd:{c -(}&copy{c )-}}{p_end}
{p2col :{cmd:{c -(}&bull{c )-}}}Bullet{p_end}
{p2col :{cmd:{c -(}&bullet{c )-}}}Synonym for {cmd:{c -(}&bull{c )-}}{p_end}
{p2col :{cmd:{c -(}&hellip{c )-}}}Horizontal ellipsis{p_end}
{p2col :{cmd:{c -(}&ellipsis{c )-}}}Synonym for {cmd:{c -(}&hellip{c )-}}{p_end}
{p2col :{cmd:{c -(}&loz{c )-}}}Lozenge, diamond{p_end}
{p2col :{cmd:{c -(}&lozenge{c )-}}}Synonym for {cmd:{c -(}&loz{c )-}}{p_end}
{p2col :{cmd:{c -(}&diamond{c )-}}}Synonym for {cmd:{c -(}&loz{c )-}}{p_end}
{p2col :{cmd:{c -(}&spades{c )-}}}Spades card suit{p_end}
{p2col :{cmd:{c -(}&clubs{c )-}}}Clubs card suit{p_end}
{p2col :{cmd:{c -(}&hearts{c )-}}}Hearts card suit{p_end}
{p2col :{cmd:{c -(}&diams{c )-}}}Diamonds card suit{p_end}
{p2col :{cmd:{c -(}&diamonds{c )-}}}Synonym for {cmd:{c -(}&diams{c )-}}{p_end}
{p2col :{cmd:{c -(}&degree{c )-}}}Degrees{p_end}
{p2line}
