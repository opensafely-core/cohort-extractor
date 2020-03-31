{smcl}
{* *! version 1.0.2  21jan2016}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "charset##syntax"}{...}
{viewerjumpto "Description" "charset##description"}{...}
{viewerjumpto "Option" "charset##option"}{...}
{viewerjumpto "Remarks" "charset##remarks"}{...}
{pstd}
{cmd:set charset} continues to work but, as of Stata 14, is no longer an
official part of Stata.  This is the original help file, which we will no
longer update, so some links may no longer work.

{pstd}
See {helpb unicode} for an updated command.


{title:Title}

{phang}
Set the character set used by Stata for ASCII text (Mac only)


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
	{cmd:set charset} {c -(} {cmd:mac} | {cmd:latin1} {c )-}
	[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set charset} sets the character set used by Stata for Mac for rendering
ASCII text.  Because the number of characters in natural languages far
exceeds the number of printable character codes in ASCII, character sets allow
more characters to be represented in ASCII to accommodate different languages.
Windows and Unix use the ISO-8859-1 (Latin1) encoding, which can be set by
typing {cmd:set charset latin1}.  Mac uses the Mac OS Roman encoding and
can be set by typing {cmd:set charset mac}.

{pstd}
Typing {cmd: set charset} without an argument will display the current
setting.

{pstd}
The default value of {cmd:charset} for the Mac is {cmd:mac}.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.
{p_end}


{marker remarks}{...}
{title:Remarks}

{pstd}
The purpose of changing the character set is to display data that contain
accented characters on a platform that uses a different character set than the
platform the data were created on (that is, displaying data that were created
in Windows on a Mac).  It is necessary to identify which set is being used for
text to be interpreted correctly.

{pstd}
For example, when you use the {cmd:{c -(}char{c )-}} directive to display ASCII
characters, {cmd:{c -(}c e'{c )-}} will render the {c e'}
character regardless of the {cmd:charset} setting.  

{center:{cmd:{c -(}c e'{c )-}}      {c e'} (All platforms)                  }

{pstd}
However, the ASCII character code {cmd:{c -(}c 0xe9{c )-}} is equivalent to
{cmd:{c -(}c e'{c )-}} in a Latin1 encoding, and the ASCII character code
{cmd:{c -(}c 0x8e{c )-}} is equivalent to
{cmd:{c -(}c e'{c )-}} in a Mac Roman encoding. 
When displaying the ASCII
character code {cmd:{c -(}c 0xe9{c )-}}, SMCL will render a different character
depending on the platform and the {cmd:charset} setting.

{center:{cmd:{c -(}c 0xe9{c )-}}    {c e'} (Windows and Unix)               }
{center:{cmd:{c -(}c 0x8e{c )-}}    {c e'} (Mac with {cmd:charset} set to {cmd:mac})   }
{center:{cmd:{c -(}c 0xe9{c )-}}    {c E'g} (Mac with {cmd:charset} set to {cmd:mac})   }

{pstd}
Setting the {cmd:charset} to {cmd:latin1} on the Mac will render the ASCII
character code {cmd:{c -(}c 0xe9{c )-}} just as it appears in Windows and Unix.

{center:{cmd:{c -(}c 0xe9{c )-}}    {c e'} (Mac with {cmd:charset} set to {cmd:latin1})}
