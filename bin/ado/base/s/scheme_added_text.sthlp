{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Scheme entries for added text}

{p 3 3 2}
These entries specify the look of text added with the 
{helpb added_text_options:text()} or {helpb added_text_options:ttext()}
options.  They also specify the definition of the {cmd:text_option} 
{help textboxstyle} that can be applied to any textbox.

{p2colset 4 54 57 0}{...}
{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:gsize         {space 8}text_option}      {space 5}{it:{help textsizestyle}}}
	text size{p_end}
{p2col:{cmd:color         {space 8}text_option}      {space 5}{it:{help colorstyle}}}
	text color{p_end}

{p2col:{cmd:yesno         {space 8}text_option}      {space 5}{{cmd:yes}|{cmd:no}}}
	draw box around text{p_end}
{p2col:{cmd:color         {space 8}text_option_fill} {space 0}{it:{help colorstyle}}}
	box fill color{p_end}
{p2col:{cmd:color         {space 8}text_option_line} {space 0}{it:{help colorstyle}}}
	box outline color{p_end}
{p2col:{cmd:linewidth     {space 4}text_option}      {space 5}{it:{help linewidthstyle:linewidth}}}
	box outline thickness{p_end}
{p2col:{cmd:linepattern   {space 2}text_option}      {space 5}{it:{help linepatternstyle}}}
	box outline pattern{p_end}

{p2col:{cmd:horizontal    {space 3}text_option}      {space 5}{it:{help justificationstyle}}}
	text justification{p_end}
{p2col:{cmd:vertical_text {space 0}text_option}      {space 5}{it:{help alignmentstyle}}}
	text alignment{p_end}

{p2col:{cmd:margin        {space 7}text_option}      {space 5}{it:{help marginstyle}}}
	margin around text{p_end}

{p2col:{cmd:compass2dir   {space 2}text_option}      {space 5}{it:{help compassdirstyle}}}
	position of added text, relative to point placed{p_end}

{p2col:{cmd:linestyle     {space 4}text_option}      {space 5}{it:{help linestyle}}}
	overall box outline style (*){p_end}
{p2col:{cmd:textboxstyle  {space 1}text_option}      {space 5}{it:{help textboxstyle}}}
	overall style of textbox (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.  For most official schemes {it:textboxstyle} is
{cmd:text_option}, and the other entries in the table apply to 
{help added text options}.  If a scheme specifies a different composite style
for {it:textboxstyle}, entries associated with that composite style must
be used to change the look of added text.{p_end}
{p2colreset}{...}
