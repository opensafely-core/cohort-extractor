{smcl}
{* *! version 1.1.25  31jul2019}{...}
{vieweralsosee "[P] smcl" "mansection P smcl"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] display" "help display"}{...}
{vieweralsosee "[RPT] dyndoc" "help dyndoc"}{...}
{vieweralsosee "[R] log" "help log"}{...}
{vieweralsosee "[RPT] markdown" "help markdown"}{...}
{vieweralsosee "viewer" "help viewer"}{...}
{vieweralsosee "[U] 18.11.6 Writing system help" "help examplehelpfile"}{...}
{viewerjumpto "Description" "smcl##description"}{...}
{viewerjumpto "Links to PDF documentation" "smcl##linkspdf"}{...}
{viewerjumpto "Remarks" "smcl##remarks"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[P] smcl} {hline 2}}Stata Markup and Control Language{p_end}
{p2col:}({mansection P smcl:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
SMCL, which stands for Stata Markup and Control Language and is
pronounced "smickle", is Stata's output language.  SMCL directives, such
as "{cmd:{c -(}it:...{c )-}}" in

{pin2}
You can output {c -(}it:italics{c )-} using SMCL

{pstd}
affect how output appears:

{pin2}
You can output {it:italics} using SMCL

{pstd}
All Stata output is processed by SMCL: help files, statistical results, and
even the output of {helpb display} in the programs you write.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P smclRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help smcl##modes:SMCL modes}
        {help smcl##general_syntax:Command summary -- general syntax}
        {help smcl##repeated_material:Help file preprocessor directive for substituting repeated material}
        {help smcl##line_paragraph_mode:Formatting directives for use in line and paragraph modes}
        {help smcl##link_mode:Link directives for use in line and paragraph modes}
        {help smcl##line_mode:Formatting directives for use in line mode}
        {help smcl##paragraph_mode:Formatting directives for use in paragraph mode}
        {help smcl##class:Inserting values from constant and current-value class}
        {help smcl##ascii:Displaying characters using ASCII and extended ASCII codes}


{marker modes}{...}
{title:SMCL modes}

{pstd}
SMCL is always in one of three modes:

{center:1.  SMCL line mode     }
{center:2.  SMCL paragraph mode}
{center:3.  As-is mode         }

{pstd}
Modes 1 and 2 are nearly alike -- in these two modes, SMCL directives are
understood, and the modes differ only in how they treat blanks and
carriage returns.  In paragraph mode -- so called because it is useful for
formatting text into paragraphs -- SMCL joins one line to the next and
splits lines to form output with lines that are of nearly equal length.  In
line mode, SMCL shows the line much as you entered it.  For instance,
in line mode, the input text

        Variable name        mean        standard error

{pstd}
(which might appear in a help file) would be spaced in the output exactly as
you entered it.  In paragraph mode, the above would be output as "Variable
name mean standard error", meaning that it would all run together.  On the
other hand, the text

{pin}
The two main uses of SMCL are in the programs you compose and in the help files you write to document them, although SMCL may be used in any context.
Everything Stata displays on the screen is processed by SMCL.

{pstd}
would display as a nicely formatted paragraph in paragraph mode.

{pstd}
In mode 3, as-is mode, SMCL directives are not interpreted; text is displayed
just as it was entered.  There is seldom need for this mode. 

{pstd}
The directive {cmd:{c -(}smcl{c )-}} followed by a carriage return signals
the beginning of the line and paragraph SMCL modes.  The default SMCL mode is
line mode.  Paragraph mode is entered using the {cmd:{c -(}p{c )-}} directive.
SMCL paragraph mode ends, and SMCL line mode is reestablished, when a blank
line is encountered or the {cmd:{c -(}p_end{c )-}} directive is given.

{pstd}
It is only from line mode that you can get to the other modes.  In addition to
the {cmd:{c -(}p{c )-}} directive for SMCL paragraph mode, there is the
{cmd:{c -(}asis{c )-}} directive that activates the as-is mode.  To return to
SMCL mode from these two modes, you must use the {cmd:{c -(}smcl{c )-}}
directive.


{marker general_syntax}{...}
{title:Command summary -- general syntax}

{pstd}
Pretend that {cmd:{c -(}xyz{c )-}} is a SMCL directive, although it is not.
{cmd:{c -(}xyz{c )-}} might have any of the following syntaxes:

{marker syntax}{...}
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
Not every SMCL directive has all four syntaxes, and which syntaxes are
allowed is made clear in the descriptions below.

{pstd}
In syntaxes 3 and 4, {it:text} may contain other SMCL directives.  However,
the braces must not only match but also match on the same physical (input)
line.


{marker repeated_material}{...}
{title:Help file preprocessor directive for substituting repeated material}

    {cmd:INCLUDE help} {it:arg} follows {help smcl##syntax:syntax 3}.
{pin}{cmd:INCLUDE} specifies that SMCL substitute the contents of a file named
{it:arg}{cmd:.ihlp}.  This is useful when you need to include the same text
multiple times.


{marker line_paragraph_mode}{...}
{title:Formatting directives for use in line and paragraph modes}

    {cmd:{c -(}sf{c )-}}, {cmd:{c -(}it{c )-}}, and {cmd:{c -(}bf{c )-}} follow {help smcl##syntax:syntaxes 1 and 2}.
{pin}These directives specify how the font is to appear.
{cmd:{c -(}sf{c )-}} indicates standard face, {cmd:{c -(}it{c )-}}
italic face, and {cmd:{c -(}bf{c )-}} boldface.

{pin}Used in {help smcl##syntax:syntax 1}, these directives switch to the font
face specified, and that rendition will continue to be used until another one
of the directives is given.

{pin}Used in {help smcl##syntax:syntax 2}, they display {it:text} in the
specified way and then switch the font face back to whatever it was previously.

    {cmd:{c -(}input{c )-}}, {cmd:{c -(}error{c )-}}, {cmd:{c -(}result{c )-}}, and {cmd:{c -(}text{c )-}} follow {help smcl##syntax:syntaxes 1 and 2}.
{pin}These directives specify how the text should be rendered: in the style
that indicates user input, an error, a calculated result, or the text around
calculated results.

{pin}These styles are often rendered as color.  In the Results window, on a
white background, Stata by default shows input in black and bold, error
messages in red, calculated results in black and bold, and text in black.
However, the relationship between the real colors and
{cmd:{c -(}input{c )-}}, {cmd:{c -(}error{c )-}}, {cmd:{c -(}result{c )-}},
and {cmd:{c -(}text{c )-}} may not be the default (the user could reset it).

    {cmd:{c -(}inp{c )-}}, {cmd:{c -(}err{c )-}}, {cmd:{c -(}res{c )-}}, and {cmd:{c -(}txt{c )-}} follow {help smcl##syntax:syntaxes 1 and 2}.
{pin}These four commands are synonyms for {cmd:{c -(}input{c )-}},
{cmd:{c -(}error{c )-}}, {cmd:{c -(}result{c )-}}, and {cmd:{c -(}text{c )-}}.

    {cmd:{c -(}cmd{c )-}} follows {help smcl##syntax:syntaxes 1 and 2}.
{pin}{cmd:{c -(}cmd{c )-}} is similar to the "color" styles and is the
recommended way to show Stata commands in help files.  Do not confuse
{cmd:{c -(}cmd{c )-}} with {cmd:{c -(}inp{c )-}}.  {cmd:{c -(}inp{c )-}} is
the way commands actually typed are shown, and {cmd:{c -(}cmd{c )-}} is the
recommended way you show commands you might type.  We recommend that 
you present help files in terms of {cmd:{c -(}txt{c )-}} and use
{cmd:{c -(}cmd{c )-}} to show commands; use any of {cmd:{c -(}sf{c )-}},
{cmd:{c -(}it{c )-}}, or {cmd:{c -(}bf{c )-}} in a help file, but we recommend
that you not use any of the "colors" {cmd:{c -(}inp{c )-}},
{cmd:{c -(}err{c )-}}, or {cmd:{c -(}res{c )-}}, except where you
are showing actual Stata output.

{pstd}{cmd:{c -(}cmdab:}{it:text1}{cmd::}{it:text2}{cmd:{c )-}} follows a variation on {help smcl##syntax:syntax 2} (note the double colons).{p_end}
{pin}{cmd:{c -(}cmdab{c )-}} is the recommended way to show minimum
abbreviations for Stata commands and options in help files;  {it:text1}
represents the minimum abbreviation, and {it:text2} represents the rest of the
text.  When the entire command or option name is the minimum abbreviation,
you may omit {it:text2} along with the extra colon. 
{cmd:{c -(}cmdab:}{it:text}{cmd:{c )-}} is then equivalent to
{cmd:{c -(}cmd:}{it:text}{cmd:{c )-}}.

{pstd}{cmd:{c -(}opt} {it:option}{cmd:{c )-}},
    {cmd:{c -(}opt} {it:option}{cmd:(}{it:arg}{cmd:){c )-}},
    {cmd:{c -(}opt} {it:option}{cmd:(}{it:a}{cmd:,}{it:b}{cmd:){c )-}}, and
    {cmd:{c -(}opt} {it:option}{cmd:(}{it:a}{cmd:|}{it:b}{cmd:){c )-}}
    follow {help smcl##syntax:syntax 3}; alternatives to using {cmd:{c -(}cmd{c )-}}.{p_end}
{pstd}{cmd:{c -(}opt} {it:option1}{cmd::}{it:option2}{cmd:{c )-}},
    {cmd:{c -(}opt} {it:option1}{cmd::}{it:option2}{cmd:(}{it:arg}{cmd:){c )-}},
    {cmd:{c -(}opt} {it:option1}{cmd::}{it:option2}{cmd:(}{it:a}{cmd:,}{it:b}{cmd:){c )-}}, and
    {cmd:{c -(}opt} {it:option1}{cmd::}{it:option2}{cmd:(}{it:a}{cmd:|}{it:b}{cmd:){c )-}} follow {help smcl##syntax:syntaxes 3 and 4}; alternatives to using
    {cmd:{c -(}cmdab{c )-}}.{p_end}
{pin}{cmd:{c -(}opt{c )-}} is the recommended way to show options. 
     {cmd:{c -(}opt{c )-}} allows you to easily include arguments.

  SMCL directive ...{col 30}is equivalent to typing ...
  {hline 76}
  {cmd:{c -(}opt} {it:option}{cmd:{c )-}}{col 30}{cmd:{c -(}cmd:}{it:option}{cmd:{c )-}}
  {cmd:{c -(}opt} {it:option}{cmd:(}{it:arg}{cmd:)}{cmd:{c )-}}{col 30}{cmd:{c -(}cmd:}{it:option}{cmd:({c )-}{c -(}it:}{it:args}{cmd:{c )-}{c -(}cmd:){c )-}}
  {cmd:{c -(}opt} {it:option}{cmd:(}{it:a}{cmd:,}{it:b}{cmd:)}{cmd:{c )-}}{col 30}{cmd:{c -(}cmd:}{it:option}{cmd:({c )-}{c -(}it:}{it:a}{cmd:{c )-}{c -(}cmd:,{c )-}{c -(}it:}{it:b}{cmd:{c )-}{c -(}cmd:){c )-}}
  {cmd:{c -(}opt} {it:option}{cmd:(}{it:a}{cmd:|}{it:b}{cmd:)}{cmd:{c )-}}{col 30}{cmd:{c -(}cmd:}{it:option}{cmd:({c )-}{c -(}it:}{it:a}{cmd:{c )-}|{c -(}it:}{it:b}{cmd:{c )-}{c -(}cmd:){c )-}}

  {cmd:{c -(}opt} {it:option1}{cmd::}{it:option2}{cmd:{c )-}}{col 30}{cmd:{c -(}cmd:}{it:option1}{cmd::}{it:option2}{cmd:{c )-}}
  {cmd:{c -(}opt} {it:option1}{cmd::}{it:option2}{cmd:(}{it:arg}{cmd:)}{cmd:{c )-}}{col 30}{cmd:{c -(}cmd:}{it:option1}{cmd::}{it:option2}{cmd:({c )-}{c -(}it:}{it:arg}{cmd:{c )-}{c -(}cmd:){c )-}}
  {cmd:{c -(}opt} {it:option1}{cmd::}{it:option2}{cmd:(}{it:a}{cmd:,}{it:b}{cmd:)}{cmd:{c )-}}{...}
 {col 30}{cmd:{c -(}cmd:}{it:option1}{cmd::}{it:option2}{cmd:({c )-}{c -(}it:}{it:a}{cmd:{c )-}{c -(}cmd:,{c )-}{c -(}it:}{it:b}{cmd:{c )-}{c -(}cmd:){c )-}}
  {cmd:{c -(}opt} {it:option1}{cmd::}{it:option2}{cmd:(}{it:a}{cmd:|}{it:b}{cmd:)}{cmd:{c )-}}{col 30}{cmd:{c -(}cmd:}{it:option1}{cmd::}{it:option2}{cmd:({c )-}{c -(}it:}{it:a}{cmd:{c )-}|{c -(}it:}{it:b}{cmd:{c )-}{c -(}cmd:){c )-}}
  {hline 76}

{pin}{it:option1} represents the minimum abbreviation, and {it:option2}
represents the rest of the text.

{pin}{it:a}{cmd:,}{it:b} and {it:a}{cmd:|}{it:b} may have any number of
elements.  Available elements that are displayed in {cmd:{c -(}cmd{c )-}}
style are {cmd:,}, {cmd:=}, {cmd::}, {cmd:*}, {cmd:%}, and {cmd:()}.  Several
elements are displayed in plain text style: {c |}, {c -(}{c )-}, and [].

{pin}Also {cmd:{c -(}opth} {it:option}{cmd:(}{it:arg}{cmd:){c )-}}
is equivalent to {cmd:{c -(}opt{c )-}}, except that {it:arg} is displayed as
a link to {cmd:help}; see
{it:{help smcl##link_mode:Link directives for use in line and paragraph modes}}
for more details.


    {cmd:{c -(}hilite{c )-}} and {cmd:{c -(}hi{c )-}} follow {help smcl##syntax:syntaxes 1 and 2}.
{pin}{cmd:{c -(}hilite{c )-}} and {cmd:{c -(}hi{c )-}} are synonyms.
{cmd:{c -(}hilite{c )-}} is the recommended way to highlight (draw attention
to) something in help files.  You might highlight, for example, a reference
to a manual, the Stata Journal, or a book.

    {cmd:{c -(}ul{c )-}} follows {help smcl##syntax:syntaxes 2 and 3}.
{pin}{cmd:{c -(}ul on{c )-}} starts underlining mode.
{cmd:{c -(}ul off{c )-}} ends it.  {cmd:{c -(}ul:}{it:text}{cmd:{c )-}}
underlines {it:text}.

    {cmd:{c -(}*{c )-}} follows {help smcl##syntax:syntaxes 2 and 4}.
{pin}{cmd:{c -(}*{c )-}} indicates a comment.  What follows it (inside
the braces) is ignored.

    {cmd:{c -(}hline{c )-}} follows {help smcl##syntax:syntaxes 1 and 3}.
{pin}{cmd:{c -(}hline{c )-}} ({help smcl##syntax:syntax 1}) draws a horizontal line the rest of
the way across the page. {cmd:{c -(}hline} {it:#}{cmd:{c )-}} ({help smcl##syntax:syntax 3}) draws
a horizontal line of {it:#} characters.  {cmd:{c -(}hline{c )-}} (either
syntax) is generally used in line mode.

    {cmd:{c -(}.-{c )-}} follows {help smcl##syntax:syntax 1}.
{pin}{cmd:{c -(}.-{c )-}} is a synonym for {cmd:{c -(}hline{c )-}} ({help smcl##syntax:syntax 1}).

    {cmd:{c -(}dup} {it:#}{cmd::}{it:text}{cmd:{c )-}} follows {help smcl##syntax:syntax 4}.
{pin}{cmd:{c -(}dup{c )-}} repeats {it:text} {it:#} times.

    {cmd:{c -(}char} {it:code}{cmd:{c )-}} and {cmd:{c -(}c} {it:code}{cmd:{c )-}} are synonyms and follow {help smcl##syntax:syntax 3}.
{pin}
These directives display the specified characters which
otherwise might be difficult to type on your keyboard.  See
{it:{help smcl##ascii:Displaying characters using ASCII and extended ASCII codes}} below.

    {cmd:{c -(}reset{c )-}} follows {help smcl##syntax:syntax 1}.
{pin}{cmd:{c -(}reset{c )-}} is equivalent to coding
{cmd:{c -(}txt{c )-}{c -(}sf{c )-}}.


{marker link_mode}{...}
{title:Link directives for use in line and paragraph modes}

{pstd}
All the link commands share the feature that when {help smcl##syntax:syntax 4} is allowed,

{center:Syntax 4:  {cmd:{c -(}xyz} {it:args}{cmd::}{it:text}{cmd:{c )-}}}

{pstd}
then {help smcl##syntax:syntax 3} is also allowed,

{center:Syntax 3:  {cmd:{c -(}xyz} {it:args}{cmd:{c )-}}     }

{pstd}
and if you specify {help smcl##syntax:syntax 3}, Stata treats it as if you
specified {help smcl##syntax:syntax 4}, inserting a colon and then repeating
the argument.

{pstd}
The link directives, which may be used in either line mode or paragraph
mode, are the following:

    {cmd:{c -(}help} {it:args}[{cmd::}{it:text}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 3 and 4}.
{pin}{cmd:{c -(}help{c )-}} displays {it:args} as a link to {cmd:help}
{it:args}; see {manhelp help R}.  If you also specify the optional
{cmd::}{it:text}, {it:text} is displayed instead of {it:args}, but you are
still directed to the help file for {it:args}.

    {cmd:{c -(}helpb} {it:args}[{cmd::}{it:text}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 3 and 4}.
{pin}{cmd:{c -(}helpb{c )-}} is equivalent to {cmd:{c -(}help{c )-}},
except that {it:args} or {it:text} is displayed in boldface.

    {cmd:{c -(}manhelp} {it:args1 args2}[{cmd::}{it:text}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 3 and 4}.
{pin}{cmd:{c -(}manhelp{c )-}} displays {cmd:[}{it:args2}{cmd:]} {it:args1} as 
a link to {cmd:help} {it:args1}; thus
{cmd:{c -(}manhelp summarize R{c )-}} would display
{manhelp summarize R}.  Specifying the optional {cmd::}{it:text} displays
{it:text} instead of {it:args1}, but you are still directed to the help
file for {it:args1}.

    {cmd:{c -(}manhelpi} {it:args1 args2}[{cmd::}{it:text}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 3 and 4}.
{pin}{cmd:{c -(}manhelpi{c )-}} is equivalent to {cmd:{c -(}manhelp{c )-}},
except that {it:args} or {it:text} is displayed in italics.

{marker markername}{...}
{pstd}{cmd:{c -(}help} {it:args}{cmd:##}{it:markername}[{cmd:|}{it:viewername}][{cmd::}{it:text}]{cmd:{c )-}} and {cmd:{c -(}marker} {it:markername}{cmd:{c )-}} follow {help smcl##syntax:syntax 3}.{p_end}
{pin}They let the user jump to a specific location within a
file, not just to the top of the file.  {cmd:{c -(}help}
{it:args}{cmd:##}{it:markername}{cmd:{c )-}} displays
{it:args}{cmd:##}{it:markername} as a link that will jump to the location
marked by {cmd:{c -(}marker} {it:markername}{cmd:{c )-}}.  Specifying the
optional {cmd:|}{it:viewername} will display the results of
{cmd:{c -(}marker} {it:markername}{cmd:{c )-}} in a new Viewer window named
{it:viewername}; {cmd:_new} is a valid {it:viewername} that assigns a unique
name for the new Viewer.  Specifying the optional {cmd::}{it:text} displays
{it:text} instead of {it:args}{cmd:##}{it:markername}.  {it:args} represents
the name of the file where the {cmd:{c -(}marker{c )-}} is located.  If
{it:args} contains spaces, be sure to specify it within quotes.

{pin}
We document the directive as {cmd:{c -(}help} ...{cmd:{c )-}}; however, 
{cmd:view}, {cmd:net}, {cmd:ado}, and {cmd:update} may be used in
place of {cmd:help}, although you would probably want to use only {cmd:help}
or {cmd:view}.

    {cmd:{c -(}help_d:}{it:text}{cmd:{c )-}} follows {help smcl##syntax:syntax 2}.
{pin}{cmd:{c -(}help_d{c )-}} displays {it:text} as a link that will display
a help dialog box from which the user may obtain interactive help on any Stata
command.

    {cmd:{c -(}newvar}[{cmd::}{it:args}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 1 and 2}.
{pin}{cmd:{c -(}newvar{c )-}} displays {it:newvar} as a link to
{cmd:help newvar}.  If you also specify the optional {cmd::}{it:args}, Stata
concatenates {it:args} to {it:newvar} to display {it:newvar<args>}.

    {cmd:{c -(}var}[{cmd::}{it:args}]{cmd:{c )-}} and {cmd:{c -(}varname}[{cmd::}{it:args}]{cmd:{c )-}} follow {help smcl##syntax:syntaxes 1 and 2}.
{pin}{cmd:{c -(}var{c )-}} and {cmd:{c -(}varname{c )-}} display {it:varname}
as a link to {cmd:help varname}.  If you also specify the optional
{cmd::}{it:args}, Stata concatenates {it:args} to {it:varname} to display
{it:varname<args>}.

    {cmd:{c -(}vars}[{cmd::}{it:args}]{cmd:{c )-}} and {cmd:{c -(}varlist}[{cmd::}{it:args}]{cmd:{c )-}} follow {help smcl##syntax:syntaxes 1 and 2}.
{pin}{cmd:{c -(}vars{c )-}} and {cmd:{c -(}varlist{c )-}} display {it:varlist}
as a link to {cmd:help varlist}.  If you also specify the optional
{cmd::}{it:args}, Stata concatenates {it:args} to {it:varlist} to display
{it:varlist<args>}.

    {cmd:{c -(}depvar}[{cmd::}{it:args}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 1 and 2}.
{pin}{cmd:{c -(}depvar{c )-}} displays {it:depvar} as a link to
{cmd:help depvar}.  If you also specify the 
optional {cmd::}{it:args}, Stata concatenates {it:args} to {it:depvar}
to display {it:depvar<args>}.

    {cmd:{c -(}depvars}[{cmd::}{it:args}]{cmd:{c )-}} and {cmd:{c -(}depvarlist}[{cmd::}{it:args}]{cmd:{c )-}} follow {help smcl##syntax:syntaxes 1 and 2}.
{pin}{cmd:{c -(}depvars{c )-}} and {cmd:{c -(}depvarlist{c )-}} display
{it:depvarlist} as a link to {cmd:help depvarlist}.  If you also specify the
optional {cmd::}{it:args}, Stata concatenates {it:args} to {it:depvarlist} to
display {it:depvarlist<args>}.

    {cmd:{c -(}indepvars}[{cmd::}{it:args}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 1 and 2}.
{pin}{cmd:{c -(}indepvars{c )-}} displays {it:indepvars} as a link to
{cmd:help varlist}.  If you also specify the optional {cmd::}{it:args}, Stata
concatenates {it:args} to {it:indepvars} to display {it:indepvars<args>}.

    {cmd:{c -(}ifin{c )-}} follows {help smcl##syntax:syntax 1}.
{pin}{cmd:{c -(}ifin{c )-}} displays [{it:if}] and [{it:in}], where {it:if}
is a link to the {cmd:help} for the {cmd:if} qualifier and {it:in} is a link 
to the {cmd:help} for the {cmd:in} qualifier.

    {cmd:{c -(}weight{c )-}} follows {help smcl##syntax:syntax 1}.
{pin}{cmd:{c -(}weight{c )-}} displays [{it:weight}], where {it:weight}
is a link to the {cmd:help} for the {it:weight} specification.

    {cmd:{c -(}dtype{c )-}} follows {help smcl##syntax:syntax 1}.
{pin}{cmd:{c -(}dtype{c )-}} displays [{it:type}], where {it:type} is a link
to {cmd:help data types}.

    {cmd:{c -(}search} {it:args}[{cmd::}{it:text}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 3 and 4}.
{pin}{cmd:{c -(}search{c )-}} displays {it:text} as a link that will display
the results of {cmd:search} on {it:args}; see {manhelp search R}.

    {cmd:{c -(}search_d:}{it:text}{cmd:{c )-}} follows {help smcl##syntax:syntax 2}.
{pin}{cmd:{c -(}search_d{c )-}} displays {it:text} as a link that will display
a {hi:Keyword Search} dialog box from which the user can obtain interactive
help by entering keywords of choice.

    {cmd:{c -(}dialog} {it:args}[{cmd::}{it:text}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 3 and 4}.
{pin}{cmd:{c -(}dialog{c )-}} displays {it:text} as a link that will launch
the dialog box for {it:args}.  {it:args} must contain the name of the dialog
box and may optionally contain {bind:{cmd:, message(}{it:string}{cmd:)}},
where {it:string} is the message to be passed to the dialog box.

    {cmd:{c -(}browse} {it:args}[{cmd::}{it:text}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 3 and 4}.
{pin}{cmd:{c -(}browse{c )-}} displays {it:text} as a link that will launch
the user's browser pointing at {it:args}.  Because {it:args} is typically a URL
containing a colon, {it:args} usually must be specified within quotes.

    {cmd:{c -(}view} {it:args}[{cmd::}{it:text}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 3 and 4}.
{pin}{cmd:{c -(}view{c )-}} displays {it:text} as a link that will present
in the Viewer the filename {it:args}. If {it:args} is a URL, be sure to specify
it in quotes.  {cmd:{c -(}view{c )-}} is seldom used in a SMCL file
(such as a help file) because you would seldom know of a fixed location for
the file unless it is a URL.  {cmd:{c -(}view{c )-}} is sometimes used from
programs because the program knows the location of the file it created.

{pin}{cmd:{c -(}view{c )-}} can also be used with {cmd:{c -(}marker{c )-}};
   see {help smcl##markername:above}.

    {cmd:{c -(}view_d:}{it:text}{cmd:{c )-}} follows {help smcl##syntax:syntax 2}.
{pin}{cmd:{c -(}view_d{c )-}} displays {it:text} as a link that will display
the {hi:Choose File to View} dialog box in which the user may
type the name of a file or a URL to be displayed in the Viewer.

    {cmd:{c -(}manpage} {it:args}[{cmd::}{it:text}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 3 and 4}.
{pin}{cmd:{c -(}manpage{c )-}} displays {it:text} as a link that will launch
the user's PDF viewer pointing at {it:args}.  {it:args} are a Stata manual
(such as {cmd:R} or {cmd:SVY}) and a page number.  The page number is
optional.  If the page number is not specified, the PDF viewer will open to the
first page of the file.

    {cmd:{c -(}mansection} {it:args}[{cmd::}{it:text}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 3 and 4}.
{pin}{cmd:{c -(}mansection{c )-}} displays {it:text} as a link that will launch
the user's PDF viewer pointing at {it:args}.  {it:args} are a Stata manual
(such as {cmd:R} or {cmd:SVY}) and a named destination within that manual
(such as {cmd:predict} or {cmd:regresspostestimation}).  The named
destination is optional. If specified, it should consist of no spaces.  If the
named destination is not specified, the PDF viewer will open to the first page
of the file.

    {cmd:{c -(}manlink} {it:man} {it:entry}{cmd:{c )-}} and {cmd:{c -(}manlinki} {it:man} {it:entry}{cmd:{c )-}} follow {help smcl##syntax:syntax 3}.
{pin}{cmd:{c -(}manlink{c )-}} and {cmd:{c -(}manlinki{c )-}} display
{it:man} and {it:entry} using the {cmd:{c -(}mansection{c )-}} directive
as a link that will launch the user's PDF viewer pointing at that manual
entry.  {it:man} is a Stata manual (such as {cmd:R} or {cmd:SVY}) and
{it:entry} is the name of an entry within that manual (such as {cmd:predict}
or {cmd:regress postestimation}).  The named destination should be
written as it appears in the title of the manual entry.

        SMCL directive ...{col 31}is equivalent to typing ...
        {hline 69}
        {cmd:{c -(}manlink} {it:man} {it:entry}{cmd:{c )-}}{col 31}{cmd:{c -(}bf:{c -(}mansection} {it:man} {it:entry_ns}{cmd::[}{it:man}{cmd:]} {it:entry}{cmd:{c )-}{c )-}}
        {cmd:{c -(}manlinki} {it:man} {it:entry}{cmd:{c )-}}{col 31}{cmd:{c -(}bf:{c -(}mansection} {it:man} {it:entry_ns}{cmd::[}{it:man}{cmd:]} {cmd:{c -(}it:}{it:entry}{cmd:{c )-}{c )-}{c )-}}
        {hline 69}

{pin}{it:entry_ns} is {it:entry} with the following characters removed:
space, left and right quotes ({cmd:`} and {cmd:'}), {cmd:#}, {cmd:$}, {cmd:~},
{cmd:{c -(}}, {cmd:{c )-}}, {cmd:[}, and {cmd:]}.

    {cmd:{c -(}net} {it:args}[{cmd::}{it:text}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 3 and 4}.
{pin}{cmd:{c -(}net{c )-}} displays {it:args} as a link that will display in
the Viewer the results of {cmd:net} {it:args}; see {manhelp net R}.  Specifying
the optional {cmd::}{it:text}, display {it:text} instead of {it:args}.  For
security reasons, {cmd:net get} and {cmd:net install} cannot be executed in
this way.  Instead use {cmd:{c -(}net describe} {it:...}{cmd:{c )-}} to show
the page, and from there, the user can click on the appropriate links to install
the materials.  Whenever {it:args} contains a colon, as it does when {it:args}
is a URL, be sure to enclose {it:args} in quotes.

{pin}{cmd:{c -(}net cd .:}{it:text}{cmd:{c )-}} displays {it:text} as a link
that will display the contents of the current {cmd:net} location.

{pin}{cmd:{c -(}net{c )-}} can also be used with {cmd:{c -(}marker{c )-}};
   see {help smcl##markername:above}.

    {cmd:{c -(}net_d:}{it:text}{cmd:{c )-}} follows {help smcl##syntax:syntax 2}.
{pin}{cmd:{c -(}net_d{c )-}} displays {it:text} as a link that will display a
{hi:Keyword Search} dialog box from which the user can search the Internet
for additions to Stata.

    {cmd:{c -(}netfrom_d:}{it:text}{cmd:{c )-}} follows {help smcl##syntax:syntax 2}.
{pin}{cmd:{c -(}netfrom_d{c )-}} displays {it:text} as a link that will display
a {hi:Choose Download Site} dialog box into which the user may enter
a URL and then see the contents of the site.  This directive is seldom used.

    {cmd:{c -(}ado} {it:args}[{cmd::}{it:text}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 3 and 4}.
{pin}{cmd:{c -(}ado{c )-}} displays {it:text} as a link that will display
in the Viewer the results of {cmd:ado} {it:args}; see {manhelp net R}.  For
security reasons, {cmd:ado uninstall} cannot be executed in this way.  Instead
use {cmd:{c -(}ado describe} {it:...}{cmd:{c )-}} to show the package, and
from there, the user can click to uninstall (delete) the material.

{pin}{cmd:{c -(}ado{c )-}} can also be used with {cmd:{c -(}marker{c )-}};
   see {help smcl##markername:above}.

    {cmd:{c -(}ado_d:}{it:text}{cmd:{c )-}} follows {help smcl##syntax:syntax 2}.
{pin}{cmd:{c -(}ado_d{c )-}} displays {it:text} as a link that will display a
{hi:Search Installed Programs} dialog box from which the user can search for
community-contributed routines previously installed (and uninstall them if
desired).

    {cmd:{c -(}update} {it:args}[{cmd::}{it:text}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 3 and 4}.
{pin}{cmd:{c -(}update{c )-}} displays {it:text} as a link that will display
in the Viewer the results of {cmd:update} {it:args}; see {manhelp update R}.
If {it:args} contains a URL, be careful to place the {it:args} in quotes.

{pin}{it:args} can be omitted because the {cmd:update} command is valid
without arguments.  {cmd:{c -(}update:}{it:text}{cmd:{c )-}} is really the
best way to use the {cmd:{c -(}update{c )-}} directive because it allows the
user to chose whether and from where to update their Stata.

{pin}{cmd:{c -(}update{c )-}} can also be used with {cmd:{c -(}marker{c )-}};
see {help smcl##markername:above}.

    {cmd:{c -(}update_d:}{it:text}{cmd:{c )-}} follows {help smcl##syntax:syntax 2}.
{pin}{cmd:{c -(}update_d{c )-}} displays {it:text} as a link that will display
a {hi:Choose Official Update Site} dialog box into which the user may type
a source (typically https://www.stata.com, but perhaps a local CD
drive) from which to install official updates to Stata.

    {cmd:{c -(}back:}{it:text}{cmd:{c )-}} follows {help smcl##syntax:syntax 2}.
{pin}{cmd:{c -(}back{c )-}} displays {it:text} as a link that will take an
action equivalent to pressing the Viewer's {hi:Back} button.

    {cmd:{c -(}clearmore:}{it:text}{cmd:{c )-}} follows {help smcl##syntax:syntax 2}.
{pin}{cmd:{c -(}clearmore{c )-}} displays {it:text} as a link that will take an
action equivalent to pressing Stata's {hi:Clear -more- Condition} button.
{cmd:{c -(}clearmore{c )-}} is of little use to anyone but the developers of
Stata.

    {cmd:{c -(}stata} {it:args}[{cmd::}{it:text}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 3 and 4}.
{pin}{cmd:{c -(}stata{c )-}} displays {it:text} as a link that will execute
the Stata command {it:args} in the Results window.  Stata will first ask
before executing the command that is displayed in a web browser.  If {it:args}
(the Stata command) contains a colon, remember to enclose the command in
quotes.

    {cmd:{c -(}matacmd} {it:args}[{cmd::}{it:text}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 3 and 4}.
{pin}{cmd:{c -(}matacmd{c )-}} works the same as {cmd:{c -(}stata{c )-}},
except that it submits a command to Mata.  If Mata is not already active, the
command will be prefixed with {cmd:mata} to allow Stata to execute it.

{marker line_mode}{...}
{title:Formatting directives for use in line mode}

    {cmd:{c -(}title:}{it:text}{cmd:{c )-}}(carriage return) follows {help smcl##syntax:syntax 2}.
{pin}{cmd:{c -(}title:}{it:text}{cmd:{c )-}} displays {it:text} as a title.

    {cmd:{c -(}center:}{it:text}{cmd:{c )-}} and {cmd:{c -(}centre:}{it:text}{cmd:{c )-}} follow {help smcl##syntax:syntax 2}.
    {cmd:{c -(}center} {it:#}{cmd::}{it:text}{cmd:{c )-}} and {cmd:{c -(}centre} {it:#}{cmd::}{it:text}{cmd:{c )-}} follow {help smcl##syntax:syntax 4}.
{pin}{cmd:{c -(}center:}{it:text}{cmd:{c )-}} and
{cmd:{c -(}centre:}{it:text}{cmd:{c )-}} are synonyms; they center the text on
the line. {cmd:{c -(}center:}{it:text}{cmd:{c )-}} should usually be followed
by a carriage return; otherwise, any text that follows it will appear on the
same line. With {help smcl##syntax:syntax 4}, they center the text in a field
of width {it:#}.

    {cmd:{c -(}rcenter:}{it:text}{cmd:{c )-}} and {cmd:{c -(}rcentre:}{it:text}{cmd:{c )-}} follow {help smcl##syntax:syntax 2}.
    {cmd:{c -(}rcenter} {it:#}{cmd::}{it:text}{cmd:{c )-}} and {cmd:{c -(}rcentre} {it:#}{cmd::}{it:text}{cmd:{c )-}} follow {help smcl##syntax:syntax 4}.
{pin}{cmd:{c -(}rcenter:}{it:text}{cmd:{c )-}} and
{cmd:{c -(}rcentre:}{it:text}{cmd:{c )-}} are synonyms. 
{cmd:{c -(}rcenter{c )-}} is equivalent to {cmd:{c -(}center{c )-}}, except
that {it:text} is displayed one space to the right when there are unequal
spaces left and right.
{cmd:{c -(}rcenter:}{it:text}{cmd:{c )-}} should be followed
by a carriage return; otherwise, any text that follows it will appear on the
same line. With {help smcl##syntax:syntax 4}, they center the text in a field
of width {it:#}.

    {cmd:{c -(}right:}{it:text}{cmd:{c )-}} follows {help smcl##syntax:syntax 2}.
{pin}{cmd:{c -(}right:}{it:text}{cmd:{c )-}} displays {it:text} with its
last character aligned on the right margin.
    {cmd:{c -(}right:}{it:text}{cmd:{c )-}} should be followed by a carriage
    return.

    {cmd:{c -(}lalign} {it:#}{cmd::}{it:text}{cmd:{c )-}} and {cmd:{c -(}ralign} {it:#}{cmd::}{it:text}{cmd:{c )-}} follow {help smcl##syntax:syntax 4}.
{pin}{cmd:{c -(}lalign{c )-}} left-aligns {it:text} in a field {it:#}
characters wide, and {cmd:{c -(}ralign{c )-}} right-aligns {it:text} in a
field {it:#} characters wide.

    {cmd:{c -(}dlgtab} [{it:#} [{it:#}]]{cmd::}{it:text}{cmd:{c )-}} follows {help smcl##syntax:syntaxes 2 and 4}.
{pin}{cmd:{c -(}dlgtab{c )-}} displays {it:text} as a dialog tab.  The first
{it:#} specifies how many characters to indent the dialog tab from the
left-hand side, and the second {it:#} specifies how much to indent from the
right-hand side.  The default is {cmd:{c -(}dlgtab 4 2:}{it:text}{cmd:{c )-}}.

    {cmd:{c -(}...{c )-}} follows {help smcl##syntax:syntax 1}.
{pin}{cmd:{c -(}...{c )-}} specifies that the next carriage return be
treated as a blank.

    {cmd:{c -(}col} {it:#}{cmd:{c )-}} follows {help smcl##syntax:syntax 3}.
{pin}{cmd:{c -(}col} {it:#}{cmd:{c )-}} skips forward to column {it:#}.
If you are already at or beyond that column in the output, then
{cmd:{c -(}col} {it:#}{cmd:{c )-}} does nothing.

    {cmd:{c -(}space} {it:#}{cmd:{c )-}} follows {help smcl##syntax:syntax 3}.
{pin}{cmd:{c -(}space} {it:#}{cmd:{c )-}} is equivalent to typing {it:#}
blank characters.

    {cmd:{c -(}tab{c )-}} follows {help smcl##syntax:syntax 1}.
{pin}{cmd:{c -(}tab{c )-}} has the same effect as typing a tab character.
Tab stops are set every eight spaces.

{pin}Note:  SMCL also understands tab characters and treats them the same
as the {cmd:{c -(}tab{c )-}} command, so you may include tabs in your files.


{marker paragraph_mode}{...}
{title:Formatting directives for use in paragraph mode}

    {cmd:{c -(}p{c )-}} follows {help smcl##syntax:syntax 3}.  The full syntax is {cmd:{c -(}p} {it:# # # #}{cmd:{c )-}}.
{pin}{cmd:{c -(}p} {it:# # # #}{cmd:{c )-}} enters paragraph mode.  The first
{it:#} specifies how many characters to indent the first line; the second
{it:#}, how much to indent the second and subsequent lines; the third {it:#},
how much to bring in the right margin on all lines; and the fourth {it:#} is
the total width for the paragraph.  Numbers, if not specified, default to
zero, so typing {cmd:{c -(}p{c )-}} without numbers is equivalent to typing
{cmd:{c -(}p 0 0 0 0{c )-}}, {cmd:{c -(}p} {it:#}{cmd:{c )-}} is equivalent to
{cmd:{c -(}p} {it:#} {cmd:0 0 0{c )-}}, and so on.  A zero for the fourth
{it:#} means use the default paragraph width; see {help linesize}.
{cmd:{c -(}p{c )-}} (with or without numbers) may be followed by a carriage
return or not; it makes no difference.

{pin}Paragraph mode ends when a blank line is encountered, the
{cmd:{c -(}p_end{c )-}} directive is encountered, or
{cmd:{c -(}smcl{c )-}}(carriage return) is encountered.

{pin}Several shortcut directives have also been added for commonly used
paragraph mode settings:

{p2colset 15 36 38 16}{...}
{p2col :SMCL directive ...}is equivalent to typing ...{p_end}
{p2line}
{p2col :{cmd:{c -(}pstd{c )-}}}{cmd:{c -(}p 4 4 2{c )-}}{p_end}
{p2col :{cmd:{c -(}psee{c )-}}}{cmd:{c -(}p 4 13 2{c )-}}{p_end}
{p2col :{cmd:{c -(}phang{c )-}}}{cmd:{c -(}p 4 8 2{c )-}}{p_end}
{p2col :{cmd:{c -(}pmore{c )-}}}{cmd:{c -(}p 8 8 2{c )-}}{p_end}
{p2col :{cmd:{c -(}pin{c )-}}}{cmd:{c -(}p 8 8 2{c )-}}{p_end}
{p2col :{cmd:{c -(}phang2{c )-}}}{cmd:{c -(}p 8 12 2{c )-}}{p_end}
{p2col :{cmd:{c -(}pmore2{c )-}}}{cmd:{c -(}p 12 12 2{c )-}}{p_end}
{p2col :{cmd:{c -(}pin2{c )-}}}{cmd:{c -(}p 12 12 2{c )-}}{p_end}
{p2col :{cmd:{c -(}phang3{c )-}}}{cmd:{c -(}p 12 16 2{c )-}}{p_end}
{p2col :{cmd:{c -(}pmore3{c )-}}}{cmd:{c -(}p 16 16 2{c )-}}{p_end}
{p2col :{cmd:{c -(}pin3{c )-}}}{cmd:{c -(}p 16 16 2{c )-}}{p_end}
{p2colreset}{...}

    {cmd:{c -(}p_end{c )-}} follows {help smcl##syntax:syntax 1}.
{pin}{cmd:{c -(}p_end{c )-}} is a way of ending a paragraph without having
a blank line between paragraphs.  {cmd:{c -(}p_end{c )-}} may be followed by a
carriage return or not; it will make no difference in the output.

    {cmd:{c -(}p2colset} {it:# # # #}{cmd:{c )-}} follows {help smcl##syntax:syntax 3}.
{pin}{cmd:{c -(}p2colset{c )-}} sets column spacing for a two-column table.
The first {it:#} specifies the beginning position of the first column, the
second {it:#} specifies the placement of the second column, the third {it:#}
specifies the placement for subsequent lines of the second column, and the
last {it:#} specifies the number to indent from the right-hand side for the
second column.

{pstd}{cmd:{c -(}p2col} [{it:# # # #}]{cmd::}[{it:first_column_text}]{cmd:{c )-}} [{it:second_column_text}] follows {help smcl##syntax:syntaxes 2 and 4}.{p_end}
{pin}{cmd:{c -(}p2col{c )-}} specifies the rows that make up the two-column
table.  Specifying the optional numbers redefines the numbers specified in
{cmd:{c -(}p2colset{c )-}} for this row only.  If the {it:first_column_text}
or the {it:second_column_text} is not specified, the respective column is left
blank.

    {cmd:{c -(}p2line} [{it:# #}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 1 and 3}.
{pin}{cmd:{c -(}p2line{c )-}} draws a dashed line for use with a two-column
table.  The first {it:#} specifies the left indentation, and the second {it:#}
specifies the right indentation.  If no numbers are specified, the defaults
are based on the numbers provided in {cmd:{c -(}p2colset{c )-}}.

    {cmd:{c -(}p2colreset{c )-}} follows {help smcl##syntax:syntax 1}.
{pin}{cmd:{c -(}p2colreset{c )-}} restores the {cmd:{c -(}p2col{c )-}} default
values.

    {cmd:{c -(}synoptset} [{it:#}] [{cmd:tabbed}|{cmd:notes}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 1 and 3}.
{pin}{cmd:{c -(}synoptset{c )-}} sets
standard column spacing for the two-column tables used to document options in
syntax diagrams.  {it:#} specifies the width of the first column; the width
defaults to 20 if {it:#} is not specified.  The optional argument {cmd:tabbed}
specifies that the table will contain headings or "tabs" for sets of options.
The optional argument {cmd:notes} specifies that some of the table entries
will have footnotes and results in a larger indentation of the first column
than the {cmd:tabbed} argument implies.

    {cmd:{c -(}synopthdr}[{cmd::}{it:first_column_header}]{cmd:{c )-}} follows {help smcl##syntax:syntaxes 1 and 2}.
{pin}{cmd:{c -(}synopthdr}{it:...}{cmd:{c )-}} outputs a standard header
for a syntax-diagram-option table.  {it:first_column_header} is used to title
the first column in the header; if {it:first_column_header} is not specified
then the first column is titled "{it:options}".  The second column is always
titled "Description".

    {cmd:{c -(}syntab}{cmd::}{it:text}{cmd:{c )-}} follows {help smcl##syntax:syntax 2}.
{pin}{cmd:{c -(}syntab}{cmd::}{it:text}{cmd:{c )-}} outputs {it:text}
positioned as a subheading or "tab" in a syntax-diagram-option table.

    {cmd:{c -(}synopt}{cmd::}[{it:first_column_text}]{cmd:{c )-}}[{it:second_column_text}] follows {help smcl##syntax:syntax 2}.
{pin}{cmd:{c -(}synopt{c )-}} specifies the rows that make up the two-column
table; it is equivalent to {cmd:{c -(}p2col{c )-}} (see above).

    {cmd:{c -(}p2coldent}{cmd::}[{it:first_column_text}]{cmd:{c )-}}[{it:second_column_text}] follows {help smcl##syntax:syntax 2}.
{pin}{cmd:{c -(}p2coldent}{it:...}{cmd:{c )-}} is the same as 
{cmd:{c -(}synopt{c )-}}, except the {it:first_column_text} is displayed with
the standard indentation (which may be negative).  The {it:second_column_text}
is displayed in paragraph mode and ends when a blank line, 
{cmd:{c -(}p_end{c )-}}, or a carriage return is encountered.  The location of
the columns is determined by a prior {cmd:{c -(}synoptset{c )-}} or
{cmd:{c -(}p2colset{c )-}} directive.

    {cmd:{c -(}synoptline{c )-}} follows {help smcl##syntax:syntax 1}.
{pin}{cmd:{c -(}synoptline{c )-}} draws a horizontal line that extends to
the boundaries of the previous {cmd:{c -(}synoptset{c )-}} or, less 
often, {cmd:{c -(}p2colset{c )-}} directive.

    {cmd:{c -(}bind:}{it:text}{cmd:{c )-}} follows {help smcl##syntax:syntax 2}.
{pin}{cmd:{c -(}bind:}{it:text}{cmd:{c )-}} keeps {it:text} together on a
line, even if that makes one line of the paragraph short.
{cmd:{c -(}bind:}{it:text}{cmd:{c )-}} can also be used to insert one or
more real spaces into the paragraph if you specify {it:text} as one or more
spaces.

    {cmd:{c -(}break{c )-}} follows {help smcl##syntax:syntax 1}.
{pin}{cmd:{c -(}break{c )-}} forces a line break without ending
the paragraph.

{marker class}{...}
{title:Inserting values from constant and current-value class}

{pstd}
The {cmd:{c -(}ccl{c )-}} directive outputs the value contained in a constant
and current-value class ({cmd:c()}) object.  For instance,
{cmd:{c -(}ccl pi{c )-}} provides the value of the constant pi (3.14159...)
contained in {cmd:c(pi)}.  See {manhelp creturn P} for a list of all the
available {cmd:c()} objects.


{marker ascii}{...}
{title:Displaying characters using ASCII and extended ASCII codes}

{pstd}
The {cmd:{c -(}char{c )-}} directive -- synonym
{cmd:{c -(}c{c )-}} --  allows you to output any ASCII or extended ASCII
character in Latin1 encoding.  Extended ASCII characters in Latin1 encoding
are converted to the equivalent Unicode characters in the UTF-8 encoding.  For
instance, {cmd:{c -(}c 232{c )-}} is equivalent to typing the letter {hi:è}
because extended ASCII code 232 in Latin1 is defined as the letter "e" with
a grave accent.  You may also type the Unicode character {hi:è} (code point
{bf:\u00e8}) directly.

{pstd}
You can get to all the ASCII and extended ASCII characters in Latin1 encoding
by typing {cmd:{c -(}c} {it:#}{cmd:{c )-}}, where {it:#} is between 1 and 255.
Or, if you prefer, you can type {cmd:{c -(}c 0x}{it:#}{cmd:{c )-}}, where
{it:#} is a hexadecimal number between 1 and ff.  Thus
{cmd:{c -(}c 0x6a{c )-}} is also {hi:j} because the hexadecimal number 6a is
equal to the decimal number 106.

{pstd}
Also, so that you do not have to remember the numbers,
{cmd:{c -(}c{c )-}} provides special codes for characters that are, for one
reason or another, difficult to type.  These include

{center:{cmd:{c -(}c S|{c )-}}    $ (dollar sign)      }
{center:{cmd:{c -(}c 'g{c )-}}    ` (open single quote)}
{center:{cmd:{c -(}c -({c )-}}    {c -(} (left curly brace) }
{center:{cmd:{c -(}c )-{c )-}}    {c )-} (right curly brace)}

{pstd}
{cmd:{c -(}c S|{c )-}} and {cmd:{c -(}c 'g{c )-}} are included not because
they are difficult to type or cause SMCL any problems but because in Stata
{cmd:display} statements, they can be difficult to display, since they
are Stata's macro substitution characters and tend to be interpreted by Stata.

{pstd}
{cmd:{c -(}c -({c )-}} and {cmd:{c -(}c )-{c )-}} are included because
{cmd:{c -(}} and {cmd:{c )-}} are used to enclose SMCL directives.  Although
{cmd:{c -(}} and {cmd:{c )-}} have special meaning to SMCL, SMCL usually
displays the two characters correctly when they do not have a special
meaning.  SMCL follows the rule that, when it does not understand what it
thinks ought to be a directive, it shows what it did not understand in
unmodified form.

{pstd}
SMCL also provides the following line-drawing characters:

{center:{cmd:{c -(}c -{c )-}}      {c -}, a wide dash character         }

{center:{cmd:{c -(}c |{c )-}}      {c |}, a tall |                      }

{center:{cmd:{c -(}c +{c )-}}      {c +}, a wide dash on top of a tall |}

{center:{cmd:{c -(}c TT{c )-}}     {c TT}, a top T                       }

{center:{cmd:{c -(}c BT{c )-}}     {c BT}, a bottom T                    }

{center:{cmd:{c -(}c LT{c )-}}     {c LT}, a left T                      }

{center:{cmd:{c -(}c RT{c )-}}     {c RT}, a right T                     }

{center:{cmd:{c -(}c TLC{c )-}}    {c TLC}, a top-left corner             }

{center:{cmd:{c -(}c TRC{c )-}}    {c TRC}, a top-right corner            }

{center:{cmd:{c -(}c BRC{c )-}}    {c BRC}, a bottom-right corner         }

{center:{cmd:{c -(}c BLC{c )-}}    {c BLC}, a bottom-left corner          }

{pstd}
The above are not really ASCII; they are instructions to SMCL to draw
lines.  The "characters" are, however, one character wide and one character
tall, so you can use them as characters in your output.

{pstd}
Finally, SMCL provides the following Western European characters:

{center:{cmd:{c -(}c a'{c )-}}   {c a'}      {cmd:{c -(}c A'{c )-}}   {c A'}}
{center:{cmd:{c -(}c e'{c )-}}   {c e'}      {cmd:{c -(}c E'{c )-}}   {c E'}}
{center:{cmd:{c -(}c i'{c )-}}   {c i'}      {cmd:{c -(}c I'{c )-}}   {c I'}}
{center:{cmd:{c -(}c o'{c )-}}   {c o'}      {cmd:{c -(}c O'{c )-}}   {c O'}}
{center:{cmd:{c -(}c u'{c )-}}   {c u'}      {cmd:{c -(}c U'{c )-}}   {c U'}}

{center:{cmd:{c -(}c a'g{c )-}}  {c a'g}      {cmd:{c -(}c A'g{c )-}}  {c A'g}}
{center:{cmd:{c -(}c e'g{c )-}}  {c e'g}      {cmd:{c -(}c E'g{c )-}}  {c E'g}}
{center:{cmd:{c -(}c i'g{c )-}}  {c i'g}      {cmd:{c -(}c I'g{c )-}}  {c I'g}}
{center:{cmd:{c -(}c o'g{c )-}}  {c o'g}      {cmd:{c -(}c O'g{c )-}}  {c O'g}}
{center:{cmd:{c -(}c u'g{c )-}}  {c u'g}      {cmd:{c -(}c U'g{c )-}}  {c U'g}}

{center:{cmd:{c -(}c a^{c )-}}   {c a^}      {cmd:{c -(}c A^{c )-}}   {c A^}}
{center:{cmd:{c -(}c e^{c )-}}   {c e^}      {cmd:{c -(}c E^{c )-}}   {c E^}}
{center:{cmd:{c -(}c i^{c )-}}   {c i^}      {cmd:{c -(}c I^{c )-}}   {c I^}}
{center:{cmd:{c -(}c o^{c )-}}   {c o^}      {cmd:{c -(}c O^{c )-}}   {c O^}}
{center:{cmd:{c -(}c u^{c )-}}   {c u^}      {cmd:{c -(}c U^{c )-}}   {c U^}}

{center:{cmd:{c -(}c a~{c )-}}   {c a~}      {cmd:{c -(}c A~{c )-}}   {c A~}}
{center:{cmd:{c -(}c o~{c )-}}   {c o~}      {cmd:{c -(}c O~{c )-}}   {c O~}}

{center:{cmd:{c -(}c a:{c )-}}   {c a:}      {cmd:{c -(}c A:{c )-}}   {c A:}}
{center:{cmd:{c -(}c e:{c )-}}   {c e:}      {cmd:{c -(}c E:{c )-}}   {c E:}}
{center:{cmd:{c -(}c i:{c )-}}   {c i:}      {cmd:{c -(}c I:{c )-}}   {c I:}}
{center:{cmd:{c -(}c o:{c )-}}   {c o:}      {cmd:{c -(}c O:{c )-}}   {c O:}}
{center:{cmd:{c -(}c u:{c )-}}   {c u:}      {cmd:{c -(}c U:{c )-}}   {c U:}}

{center:{cmd:{c -(}c ae{c )-}}   {c ae}      {cmd:{c -(}c AE{c )-}}   {c AE}}
{center:{cmd:{c -(}c c,{c )-}}   {c c,}      {cmd:{c -(}c C,{c )-}}   {c C,}}
{center:{cmd:{c -(}c n~{c )-}}   {c n~}      {cmd:{c -(}c N~{c )-}}   {c N~}}
{center:{cmd:{c -(}c o/{c )-}}   {c o/}      {cmd:{c -(}c O/{c )-}}   {c O/}}
{center:{cmd:{c -(}c y'{c )-}}   {c y'}      {cmd:{c -(}c Y'{c )-}}   {c Y'}}

{center:{cmd:{c -(}c y:{c )-}}   {c y:}      {cmd:{c -(}c ss{c )-}}   {c ss}}
{center:{cmd:{c -(}c r?{c )-}}   {c r?}      {cmd:{c -(}c r!{c )-}}   {c r!}}
{center:{cmd:{c -(}c L-{c )-}}   {c L-}      {cmd:{c -(}c Y={c )-}}   {c Y=}}

{pstd}
SMCL uses UTF-8 to render the above characters.  For
example, {cmd:{c -(}c e'{c )-}} is equivalent to
{cmd:{c -(}c 0xe9{c )-}}, if you care to look it up.
{p_end}
