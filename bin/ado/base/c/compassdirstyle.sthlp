{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[G-4] compassdirstyle" "mansection G-4 compassdirstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] textbox_options" "help textbox_options"}{...}
{viewerjumpto "Syntax" "compassdirstyle##syntax"}{...}
{viewerjumpto "Description" "compassdirstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "compassdirstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "compassdirstyle##remarks"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[G-4]} {it:compassdirstyle} {hline 2}}Choices for location{p_end}
{p2col:}({mansection G-4 compassdirstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

			    {hline 10} Synonyms {hline 10}
	{it:compassdirstyle}     First  Second  Third    Fourth
	{hline 51}
	{cmd:north}                 {cmd:n}      {cmd:12}              {cmdab:t:op}
	{cmd:neast}                 {cmd:ne}     {cmd: 1}      {cmd: 2}
	{cmd:east}                  {cmd:e}      {cmd: 3}              {cmdab:r:ight}
	{cmd:seast}                 {cmd:se}     {cmd: 4}      {cmd: 5}
	{cmd:south}                 {cmd:s}      {cmd: 6}              {cmdab:b:ottom}
	{cmd:swest}                 {cmd:sw}     {cmd: 7}      {cmd: 8}
	{cmd:west}                  {cmd:w}      {cmd: 9}              {cmdab:l:eft}
	{cmd:nwest}                 {cmd:nw}     {cmd:10}      {cmd:11}
	{cmd:center}                {cmd:c}      {cmd: 0}
	{hline 51}

{pstd}
	Other {it:compassdirstyles} may be available; type

	    {cmd:.} {bf:{stata graph query compassdirstyle}}

{pstd}
to obtain the complete list of {it:compassdirstyle}s installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
{it:compassdirstyle} specifies a direction.

{pstd}
{it:compassdirstyle} is specified inside options such as the
{cmd:placement()} textbox suboption of {cmd:title()} (see
{manhelpi title_options G-3} and {manhelpi textbox_options G-3}):

{p 8 16 2}
{cmd:. graph}
...{cmd:, title(}...{cmd:, placement(}{it:compassdirstyle}{cmd:))} ...

{pstd}
Sometimes you may see that a {it:compassdirstylelist} is allowed:
a {it:compassdirstylelist} is a sequence of {it:compassdirstyles} separated by
spaces.  Shorthands are allowed to make specifying the list easier;
see {manhelpi stylelists G-4}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 compassdirstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Two methods are used for specifying directions -- the compass and the
clock.  Some options use the compass and some use the clock.  For
instance, the textbox option {cmd:position()} uses the compass (see 
{manhelpi textbox_options G-3}), but the title option {cmd:position()} uses the
clock (see {manhelpi title_options G-3}).  The reason for the difference is that
some options need only the eight directions specified by the compass, whereas
others need more.  In any case, synonyms are provided so that you can use the
clock notation in all cases.
{p_end}
