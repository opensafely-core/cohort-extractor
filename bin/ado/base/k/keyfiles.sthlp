{smcl}
{* *! version 1.1.5  15oct2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] search" "help search"}{...}
{viewerjumpto "Description" "keyfiles##description"}{...}
{viewerjumpto "Remarks" "keyfiles##remarks"}{...}
{viewerjumpto "Example" "keyfiles##example"}{...}
{title:Title}

    {hi:[P] keyfiles} {hline 2} Key files used by the {cmd:search} command


{marker description}{...}
{title:Description}

{pstd}
The {cmd:search} command examines a keyword database found in "key" files to
determine matches while doing a "local" search (that is, the {cmd:local} option
of {cmd:search}); see {manhelp search R}.  Below we provide a description of
key files.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help keyfiles##remarks1:Introduction}
        {help keyfiles##remarks2:Key file structure}
        {help keyfiles##remarks3:Help, browser, and net links within key files}
        {help keyfiles##remarks4:Highlighting text}


{marker remarks1}{...}
{title:Introduction}

{pstd}
These key files provide the keywords for official Stata commands, undocumented
help files, NetCourses, Stata Press books, FAQs posted on the Stata website,
selected articles on StataCorp's official blog, selected community-contributed
FAQs and examples, and the articles in the {help sj:Stata Journal} and the
{help stb:Stata Technical Bulletin}.

{pstd}
Updates to Stata's key files are provided on a regular basis.  Use the
{cmd:update} command (see {manhelp update R}) to obtain the latest Stata
updates, or simply {update "from https://www.stata.com":click here}.

{pstd}
Additionally, the key files {cmd:site.key} and {cmd:user.key}, if present, are
also examined by {cmd:search}.  These two key files may be used to store
keywords for additional items of interest to a user.  The results from
searching the {cmd:stata}{it:#}{cmd:.key} files are presented first, followed
by the results from searching {cmd:site.key} (if available), and then 
by the results from searching {cmd:user.key} (if available).

{pstd}
Stata looks along the {cmd:adopath} to find these files; see
{manhelp sysdir P}.  The {cmd:stata}{it:#}{cmd:.key} files are located in the
{cmd:BASE} directory.  The {cmd:site.key} and {cmd:user.key}
files would typically be placed in the {cmd:SITE}, {cmd:PERSONAL}, or
{cmd:PLUS} directories depending upon the source of the files.


{marker remarks2}{...}
{title:Key file structure}

{pstd}
Key files are text files.  Entries in a key file are separated by one or more
blank lines.  Each line of an entry begins with a period ({cmd:.}) followed by
one of the letters: {cmd:c}, {cmd:e}, {cmd:t}, {cmd:o}, {cmd:a}, {cmd:k},
{cmd:z}, or {cmd:x}, followed by one or more spaces, followed by information
appropriate for the particular key file directive.  The following table and
discussion outline what these directives are used for within key files.

{center:{c TLC}{hline 11}{c TT}{hline 31}{c TRC}}
{center:{c |} Directive {c |} Description {space 18}{c |}}
{center:{c LT}{hline 11}{c +}{hline 31}{c RT}}
{center:{c |}    {cmd:.c}     {c |} Class {space 24}{c |}}
{center:{c |}    {cmd:.e}     {c |} Entry name {space 19}{c |}}
{center:{c |}    {cmd:.t}     {c |} Title {space 24}{c |}}
{center:{c |}    {cmd:.o}     {c |} Help {space 25}{c |}}
{center:{c |}    {cmd:.a}     {c |} Author {space 23}{c |}}
{center:{c |}    {cmd:.k}     {c |} Keywords {space 21}{c |}}
{center:{c |}    {cmd:.z}     {c |} Mark as historic {space 13}{c |}}
{center:{c |}    {cmd:.x}     {c |} As is text on following lines {c |}}
{center:{c BLC}{hline 11}{c BT}{hline 31}{c BRC}}


{phang}
{cmd:.c} lines indicate the entry class.  While any word may follow a {cmd:.c}
line, certain words have special meaning to Stata.  {cmd:manual} indicates an
official Stata command; {cmd:faq} indicates a FAQ; {cmd:sj} and {cmd:stb} are
treated as synonyms and indicate Stata Journal and STB; and {cmd:error}
indicates error code.

	    Examples:

		{cmd:.c manual}

		{cmd:.c faq}

		{cmd:.c whatever}

{pmore}
There should be only one {cmd:.c} line in an entry.

{pmore}
The {cmd:faq} option of {cmd:search} limits the search to entries that have a
{cmd:.c faq} line.  The {cmd:manual} option of {cmd:search} limits the search
to entries with a {cmd:.c manual} line.  The {cmd:sj} option of {cmd:search}
limits the search to entries with a {cmd:.c sj} or {cmd:.c stb} line.

{pmore}
{cmd:search} has an undocumented option {cmd:class(}{it:classname}{cmd:)} that
allows you to restrict your search to those entries having {it:classname} as
their class.  For instance

		{cmd:. search} ... {cmd:, class(foo)}

{pmore}
would restrict the search to key-file entries that had

		{cmd:.c foo}

{pmore}
lines.

{phang}
{cmd:.e} lines provide the entry name.  The text that follows the
{cmd:.e} is displayed on the left side of the first line of output.
The first "word" of text following the {cmd:.e} is displayed to the far left
of the output, and the remaining words, if any, are displayed starting at the
first tab stop.

	    Examples:

		{cmd:.e [R] regress}

		{cmd:.e FAQ}

		{cmd:.e SJ-2-4 pr0007}

{pmore}
There should be only one {cmd:.e} line in an entry.

{pmore}
After displaying the {cmd:.e} information, the title (see the {cmd:.t}
directive below) is presented to the far right on the first line, with
repeated periods and spaces between the entry name and the title.

{phang}
{cmd:.t} lines provide a title.  The title is presented on the far right of the
first line displayed; see the discussion of the {cmd:.e} directive above.

	    Examples:

		{cmd:.t Linear regression}

		{cmd:.t Calculating power by simulation}

{pmore}
There should be only one {cmd:.t} line in an entry.

{phang}
{cmd:.o} lines are used to provide links to help files.  When a {cmd:.o} line
is present, the second line of output has "(help " followed by whatever
follows the {cmd:.o} followed by ")" placed at the first tab stop.  A link to
the help file is created if the word is enclosed in {cmd:@}; see the section
titled {hi:Help, browser, and net links within key files} below.

	    Examples:

		{cmd:.o @regress@}

		{cmd:.o @help@, @search@, @viewer@}

		{cmd:.o @clustergram@ if installed}

{pmore}
There should be only one {cmd:.o} line in an entry.

{phang}
{cmd:.a} lines indicate the author or authors.  This information is presented
on the far right of the second line displayed, with repeated periods and
spaces preceding it.  {cmd:.o} (see above) and {cmd:.a} information are both
presented on the same line.  The {cmd:.o} information on the left, and the
{cmd:.a} information on the right.

	    Examples:

		{cmd:.a D. W. Hosmer}

		{cmd:.a N. J. Cox and C. F. Baum}

{pmore}
There should be only one {cmd:.a} line in an entry.

{phang}
{cmd:.k} lines provide the keywords for the entry.  Hyphens indicate the
minimum allowed abbreviations for matching against keywords.  Multiple
{cmd:.k} lines are allowed, and one or more keywords may be specified per
line.

	    Examples:

		{cmd:.k stat-istics mean-s med-ians}

		{cmd:.k data-sets set-s manage-ment}

{pmore}
Certain keywords are used to restrict the context of the search; see
{help searchadvice} for details.

{pmore}
To provide consistent abbreviations, pick your keywords, {cmd:search} for each
keyword, and then examine some of the entries it finds and use the same length
of abbreviation.

{phang}
{cmd:.z} indicates that the entry is only of historic interest, and should not
be presented.  Entries marked with a {cmd:.z} are only presented when the
{cmd:historical} option is specified with {cmd:search}.

{phang}
{cmd:.x} indicates that the lines that follow are to be presented "as is" after
the information displayed by the {cmd:.e}, {cmd:.t}, {cmd:.o}, and {cmd:.a}
directives.


{marker remarks3}{...}
{title:Help, browser, and net links within key files}

{pstd}
The key files currently do not use {help smcl}.  Instead, key files use
{cmd:@} to indicate links.  For example, {cmd:@regress@} creates a link to
{cmd:regress.sthlp}.

{pstd}
{cmd:@browser:https://www.stata.com/!https://www.stata.com/@} creates a link to
the {cmd:https://www.stata.com/} webpage.  The {cmd:!} in the middle is
required.  {cmd:@browser:https://www.stata.com/!click here@} creates the same
link, but the words "click here" will be shown as the link instead of
{cmd:https://www.stata.com/}.

{pstd}
{cmd:@net:sj 2-1 st0005!st0005@} produces a link that executes the {cmd:net}
command.  Here the link points to the {cmd:st0005} entry of
Stata Journal 2-1.  The text that will appear will be "st0005", because it
follows the {cmd:!}.


{marker remarks4}{...}
{title:Highlighting text}

{pstd}
To highlight text, enclose it in {cmd:^}.  For instance, {cmd:^hello^} will
make the word "hello" appear highlighted.


{marker example}{...}
{title:Example}

{pstd}
Here is an example of an entry for a FAQ.

      {cmd}.e FAQ
      .c faq
      .t My FAQ title
      .a S. Body
      .k stat-istics what-ever ever
      .k test-s test-ing
      .x
	  1/03    How do you do whatever?
		  @browser:https://www.z/wever.html!https://www.z/wever.html@{txt}

{pstd}
What the user will see when they type {cmd:search whatever} is

{s6hlp}
    FAQ     . . . . . . . . . . . . . . . . . . . . . . . . . . . My FAQ title
	    . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  S. Body
	    1/03    How do you do whatever?
		    @browser:https://www.z/wever.html!https://www.z/wever.html@
{smcl}
