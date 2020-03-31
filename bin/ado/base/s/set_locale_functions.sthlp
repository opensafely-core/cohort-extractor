{smcl}
{* *! version 1.0.7  19oct2017}{...}
{vieweralsosee "[P] set locale_functions" "mansection P setlocale_functions"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] creturn" "help creturn"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{viewerjumpto "Syntax" "set_locale_functions##syntax"}{...}
{viewerjumpto "Description" "set_locale_functions##description"}{...}
{viewerjumpto "Option" "set_locale_functions##option"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[P] set locale_functions} {hline 2}}Specify default locale for functions
{p_end}
{p2col:}({mansection P setlocale_functions:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{pstd}
Use the system locale for Unicode functions

{p 8 16 2}
{cmd:set}
{cmd:locale_functions}
{cmd:default}
[{cmd:,} {cmdab:perm:anently}]


{pstd}
Specify a locale for Unicode functions

{p 8 16 2}
{cmd:set}
{cmd:locale_functions}
{it:locale}
[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set locale_functions} sets the locale to be used by functions that take
{it:locale} as an optional argument: {helpb ustrupper()}, {helpb ustrlower()},
{helpb ustrtitle()}, {helpb ustrword()}, {helpb ustrwordcount()},
{helpb ustrcompare()}, and {helpb ustrsortkey()} and their Mata
equivalents.  When the argument is not
specified, the {cmd:locale_functions} setting is used.  If
{cmd:locale_functions} is not set, the default ICU locale is used.

{pstd}
For example, if your operating system is Microsoft Windows English version,
the system locale may be {cmd:"en"}.  If you chose the specific country to be
the United States during installation of your OS, then the system locale is
most likely {cmd:"en_US"}.  If {cmd:locale_functions} is not set or is set to
default, then calling {cmd:ustrupper("istanbul")} is equivalent to calling
{cmd:ustrupper("istanbul", "en_US")}, which returns {cmd:ISTANBUL}.  However,
if {cmd:locale_functions} is set to {cmd:"tr"} for Turkish, then calling
{cmd:ustrupper("istanbul")} is equivalent to calling
{cmd:ustrupper("istanbul", "tr")}, which returns {cmd:İSTANBUL}.  For further
discussion of locales, see {findalias frlocales}.

{pstd}
Note that although ICU does not validate locales, Stata validates the language
subtag of the {cmd:locale_functions} setting. It must be a valid ISO-639-2
language code.  See the ISO-639-2 list at
{browse "http://www.loc.gov/standards/iso639-2/"}.

{pstd}
The current {cmd:locale_functions} setting is stored in
{cmd:c(locale_functions)}.  {cmd:c(locale_functions)} is reset to its original
value when a program or do-file exits.


{marker option}{...}
{title:Option}

{phang}
{opt permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke
Stata.
{p_end}
