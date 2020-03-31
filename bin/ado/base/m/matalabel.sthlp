{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] codebook" "help codebook"}{...}
{vieweralsosee "[D] describe" "help describe"}{...}
{vieweralsosee "[D] encode" "help encode"}{...}
{vieweralsosee "[D] label" "help label"}{...}
{vieweralsosee "[D] labelbook" "help labelbook"}{...}
{viewerjumpto "Syntax" "matalabel##syntax"}{...}
{viewerjumpto "Description" "matalabel##description"}{...}
{viewerjumpto "Options" "matalabel##options"}{...}
{title:Title}

{p2colset 5 24 26 2}{...}
{p2col :{hi:[M-3] matalabel} {hline 2}}Create column vectors in Mata containing value labels{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}{cmd:matalabel} [{it:lblname-list}] 
[{cmd:using} {it:filename}] {cmd:,} {opt gen:erate(namevec valuevec labelvec)}
	[{opt v:ar}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:matalabel} is a programmer's command that reads the value-label
information from the currently loaded dataset or from an optionally
specified filename.

{pstd}
{cmd:matalabel} creates three column vectors in {help mata:Mata} containing
the label name, numeric values, and labeled values.  The names of
the vectors are specified in the {opt generate()} option, which is
required.  Each vector has one row per mapping.  The labeled values
in the {it:labelvec} vector will be the full length of the label, even
if they are longer than the maximum string length in Stata.

{pstd}
{cmd:matalabel} complements {cmd:label, save}, which produces an ASCII
file of the variable labels in a format that allows easy editing of the
value-label texts.

{pstd}
Specifying no list or {opt _all} is equivalent to specifying all value labels.
Value label names may not be abbreviated or specified with wildcards.


{marker options}{...}
{title:Options}

{phang}
{opt generate(namevec valuevec labelvec)} specifies the names of the three
vectors that are to be created in Mata containing the label names, numeric
values, and labeled values.  {opt generate()} is required.

{phang}
{opt var} specifies that the varlists using value label {it:vl} be returned in
{opt r(vl)}.
{p_end}
