{smcl}
{* *! version 1.0.7  16apr2019}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{p 3 3 2}
The following entries are rarely, if ever, used by schemes shipped with
Stata.  Some, however, may be referenced by community-contributed schemes or
if a plot is {help advanced_options:recast} from one type to another.

{p 3 3 2}
Each of the tables below shows the entries for one attribute that is
being controlled, for example, color or size.


{title:Text size entries}
{p2colset 4 37 40 0}
{p 3 3 2}
These entries specify the {help textsizestyle:size} of text.{p_end}

{p2col:Entry} Description{p_end}
{p2line}

{p2col:{cmd:gsize filled_text} {space 1}{it:{help textsizestyle}}}
	default text size for some {help textboxstyle:textboxstyles}{p_end}
{p2col:{cmd:gsize text}      {space 8}{it:{help textsizestyle}}}
	default text size when other size not specified{p_end}
{p2line}


{title:Textboxstyle entries}
{p2colset 4 44 47 0}
{p 3 3 2}
These composite entries specify the {it:{help textboxstyle}} or 
{it:{help textstyle}} of graph text elements and also the boxed
{help textboxstyle:style} of boxed text elements.  See {manhelpi textstyle G-4}
for the distinction between {it:textboxstyle} and {it:textstyle}.  In scheme
files, both styles are {it:textboxstyle}s and the additional attributes of a
{it:textboxstyle} are simply ignored when applied to a graph element that
cannot be boxed.

{p 3 3 2}
As discussed more fully in {manhelpi textboxstyle G-4} and
{manhelpi textstyle G-4},
the {it:textboxstyle} groups several basic style attributes, such as text
color and text size, under one style.

{p2col:Entry} Description{p_end}
{p2line}

{p2col:{cmd:textboxstyle body}        {space 7}{it:{help textboxstyle}}}
	defines standard body text{p_end}
{p2col:{cmd:textboxstyle heading}     {space 4}{it:{help textboxstyle}}}
	defines standard heading text{p_end}
{p2col:{cmd:textboxstyle subheading}  {space 1}{it:{help textboxstyle}}}
	defines standard subheading text{p_end}
{p2col:{cmd:textboxstyle label}       {space 6}{it:{help textboxstyle}}}
	defines a standard label{p_end}
{p2col:{cmd:textboxstyle small_label} {space 0}{it:{help textboxstyle}}}
	defines a standard small label{p_end}
{p2col:{cmd:textboxstyle ilabel}      {space 5}{it:{help textboxstyle}}}
	defines a standard marker label{p_end}
{p2col:{cmd:textboxstyle key_label}   {space 2}{it:{help textboxstyle}}}
	defines a standard key label{p_end}
{p2line}


{title:Text justification}
{p2colset 4 47 50 0}
{p 3 3 2}
These entries specify the horizontal justification of text; see
{manhelpi justificationstyle G-4}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:horizontal heading}    {space 5}{it:{help justificationstyle}}}
	heading justification{p_end}
{p2col:{cmd:horizontal subheading} {space 2}{it:{help justificationstyle}}}
	subheading justification{p_end}
{p2col:{cmd:horizontal body}       {space 8}{it:{help justificationstyle}}}
	body text justification{p_end}
{p2col:{cmd:horizontal axis_title} {space 2}{it:{help justificationstyle}}}
	axis title justification{p_end}
{p2line}


{title:Text alignment}
{p2colset 4 47 50 0}
{p 3 3 2}
These entries specify the vertical alignment of text; see
{manhelpi alignmentstyle G-4}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:vertical_text body}       {space 8}{it:{help alignmentstyle}}}
	body text alignment; default for captions{p_end}
{p2col:{cmd:vertical_text axis_title} {space 2}{it:{help alignmentstyle}}}
	axis title alignment{p_end}
{p2line}


{title:Areastyle entries}
{p2colset 4 42 45 0}
{p 3 3 2}
These composite entries specify the collection of attributes that make up the
shading and outline of a filled area; see {manhelpi areastyle G-4}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:areastyle p}{it:#}          {space 14}{it:{help areastyle}}}
	default {it:areastyle} for the #th plot{p_end}

{p2col:{cmd:areastyle plotregion}       {space 6}{it:{help areastyle}}}
	general overall plot region {it:areastyle}; rarely used{p_end}
{p2col:{cmd:areastyle inner_plotregion} {space 0}{it:{help areastyle}}}
	general inner plot region {it:areastyle}; rarely used{p_end}

{p2col:{cmd:areastyle foreground}       {space 6}{it:{help areastyle}}}
	fill {it:areastyle} for foreground {bind:areas}{p_end}
{p2col:{cmd:areastyle background}       {space 6}{it:{help areastyle}}}
	fill {it:areastyle} for background {bind:areas}{p_end}
{p2line}


{title:Linestyle entries}
{p2colset 4 37 40 0}
{p 3 3 2}
These composite entries specify the collection of attributes that make up the
look of lines, including lines drawn for plots, lines drawn around boxes,
axis lines, etc.; see {manhelpi linestyle G-4}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:linestyle p}                  {space 7}{it:{help linestyle}}}
	default {it:linestyle} for all graph families, plottypes, and 
	plots{p_end}
{p2col:{cmd:linestyle p}{it:#}            {space 6}{it:{help linestyle}}}
	override default {it:linestyle} for the #th plot{p_end}
{p2col:{cmd:linestyle p}{it:#}{cmd:other} {space 1}{it:{help linestyle}}}
	override {it:linestyle} for the #th plot of other areas; rarely 
	used{p_end}
{p2line}


{title:Shadestyle entries}
{p2colset 4 35 38 0}
{p 3 3 2}
These composite entries specify the collection of attributes that make up the
color and color intensity of a filled area; see {manhelpi shadestyle G-4}.
Shadestyles appear only in scheme files and are rarely changed.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:shadestyle p}        {space 3}{it:{help shadestyle}}}
	default {it:shadestyle} for all graph families, plottypes, and 
	plots{p_end}
{p2col:{cmd:shadestyle p}{it:#}  {space 2}{it:{help shadestyle}}}
	override {it:shadestyle} for the #th plot{p_end}
{p2line}


{title:Margin entries}
{p2colset 4 37 40 0}
{p 3 3 2}
These entries specify the {help marginstyle:margins} placed around
textboxes, plot regions, graph regions, and other graph elements.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:margin text}         {space 8}{it:{help marginstyle}}}
	default margin around text, if not otherwise specified{p_end}
{p2line}


{title:Line pattern symbol entries}
{p2colset 4 44 47 0}
{p 3 3 2}
These entries specify the {help linepatternstyle:patterns} used for 
lines and outlines.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:linepattern p}{it:#}{cmd:other} {space 3}{it:{help linepatternstyle}}}
	override pattern for the #th other area plotted; rarely used{p_end}
{p2line}


{title:Marker size entries}
{p2colset 4 41 44 0}
{p 3 3 2}
These entries specify the {help markersizestyle:size} of markers.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:symbolsize symbol} {space 3}{it:{help markersizestyle}}}
	default size of markers when not otherwise specified{p_end}
{p2line}


{title:Length entries}
{p2colset 4 37 40 0}
{p 3 3 2}
These entries specify the size of gaps, lengths, and other distances.  Note
that either {it:{help textsizestyle:textsizestyles}} or 
{it:{help size:sizes}} may be used for these entries.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:gsize gap}       {space 7}{it:{help textsizestyle}}}
	default length of gaps; rarely used{p_end}
{p2line}


{title:Color entries}
{p2colset 4 37 40 0}
{p 3 3 2}
These entries specify the {help colorstyle:color} of graph elements.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color filled_text} {space 0}{it:{help colorstyle}}}
	text color for some filled textboxes{p_end}
{p2col:{cmd:color filled}      {space 5}{it:{help colorstyle}}}
	background color for some filled textboxes{p_end}
{p2col:{cmd:color box}         {space 8}{it:{help colorstyle}}}
	box background color for boxes not otherwise specified{p_end}

{p2col:{cmd:color p}           {space 10}{it:{help colorstyle}}}
	default color for plots; rarely used{p_end}
{p2col:{cmd:color p}{it:#}{cmd:other}     {space 4}{it:{help colorstyle}}}
	override fill color for the #th plot of other areas; rarely used{p_end}
{p2col:{cmd:color p}{it:#}{cmd:otherline} {space 0}{it:{help colorstyle}}}
	override line color for the #th plot of other areas; rarely used{p_end}
{p2line}
