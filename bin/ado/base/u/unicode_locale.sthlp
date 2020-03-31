{smcl}
{* *! version 1.0.8  01mar2018}{...}
{vieweralsosee "[D] unicode locale" "mansection D unicodelocale"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] unicode" "help unicode"}{...}
{vieweralsosee "[P] set locale_functions" "help set locale_functions"}{...}
{vieweralsosee "[P] set locale_ui" "help set locale_ui"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}
{findalias asfrlocales}
{viewerjumpto "Syntax" "unicode_locale##syntax"}{...}
{viewerjumpto "Description" "unicode_locale##description"}{...}
{viewerjumpto "Links to PDF documentation" "unicode_locale##linkspdf"}{...}
{viewerjumpto "Remarks" "unicode_locale##remarks"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[D] unicode locale} {hline 2}}Unicode locale utilities{p_end}
{p2col:}({mansection D unicodelocale:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
List locales 

{p 8 16 2}
{cmd:unicode}
{opt loc:ale}
{cmd:list}
[{it:pattern}]


{phang}
List user interface (UI) localization packages 

{p 8 16 2}
{cmd:unicode}
{opt ui:package}
{cmd:list}


{phang}
{it:pattern} is one of {cmd:_all}, {cmd:*}, {cmd:*}{it:name}{cmd:*},
{cmd:*}{it:name}, or {it:name}{cmd:*}.  If you specify nothing, {cmd:_all}, or
{cmd:*}, then all results will be listed.  {cmd:*}{it:name}{cmd:*} lists all
results containing {it:name}; {cmd:*}{it:name} lists all results ending with
{it:name}; and {it:name}{cmd:*} lists all results starting with {it:name}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:unicode locale list} lists all available locales or those locales that
meet the specified criteria.  Any of these locale codes may be specified in
Stata or Mata functions that accept a locale as an argument, such as 
{helpb ustrcompare()} and {helpb ustrupper()}, or in the
{helpb set locale_functions:set locale_functions} setting.

{pstd}
{cmd:unicode uipackage list} lists all localization packages that are
available for the graphics user interface (GUI).  Any of the listed
locales may be specified in the {helpb set locale_ui:set locale_ui}
setting to change the language of the text that is displayed in GUI
elements such as the menus and dialog boxes.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D unicodelocaleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help unicode_locale##remarks1:Overview}
        {help unicode_locale##remarks2:Default locale and locale fallback}

	
{marker remarks1}{...}
{title:Overview}

{pstd}
A locale identifies a user community with a certain preference for how their
language should be written; see {findalias frlocales}.
A locale can be as general as a certain language (for example, "en" for
English) or can be more specific to a country or region (for example, "en_US"
for U.S. English or "en_HK" for Hong Kong English. Stata uses International
Components for Unicode's (ICU's) locale format.  See 
{browse "http://userguide.icu-project.org/locale"} for full information about
ICU.  Note that ICU differs from the POSIX locale identifiers used by Linux
systems.

{pstd}
Locales use tags to define how specific they are to language variants.
An ICU locale may contain up to five subtags in the following order: language, 
script, country, variant, and keywords.  Typically, the language
is required and the other tags are optional.  In most cases, Stata uses
only the language and country tags.  For example, "en_US" specifies
the language as English and the country as the USA.

{pstd}
Many language-specific operations require the locale to perform their task.
This kind of operation is called locale-sensitive.  For example, in English,
the uppercase letter of the Latin small letter "i" is the Latin capital letter
"I".  However, in Turkish, the uppercase letter is "İ" with a dot above it
(Unicode {bf:\u0130}); hence, the case mapping is locale-sensitive. 

{pstd}
The following 
functions are locale-sensitive: {cmd:ustrupper()}, {cmd:ustrlower()}, 
{cmd:ustrtitle()}, {cmd:ustrword()}, {cmd:ustrwordcount()},
{cmd:ustrcompare()}, {cmd:ustrcompareex()}, {cmd:ustrsortkey()}, and
{cmd:ustrsortkeyex()}. 

{pstd}
Although Stata usually uses only the language and country tags, collation
keywords may also be used in functions {cmd:ustrcompare()} and
{cmd:ustrsortkey()} to affect ordering of Unicode strings.  The collation
keyword affects the string sort order of the locale.  For example, "pinyin"
and "stroke" for Chinese language produce different string sort orders.  In
most cases, it is not necessary to specify a collation keyword; the default
collator (either for Stata or for the language) provides sufficient control.
However, some programmers may wish to specify a specific value.  If you do not
know the value of the collation keyword, you can obtain a list of valid
collation values and their meanings in XML format at 
{browse "http://unicode.org/repos/cldr/trunk/common/bcp47/collation.xml"}.


{marker remarks2}{...}
{title:Default locale and locale fallback}

{pstd}
Because a locale is simply an identifier to locate the resources for specific
services, there is no validation of the locale.  For example, specifying
"klingon" is as valid as specifying "en" when calling {cmd:ustrcompare()} or
the other functions discussed here.  If the collation data for the "klingon"
locale is found, then the locale is populated; otherwise, a fallback search
process starts. 

{pstd}
The fallback process proceeds as follows:

{p 8 12 2}1. The variant is removed if there is one.{p_end}
{p 8 12 2}2. The country is removed if there is one.{p_end}
{p 8 12 2}3. The script is removed if there is one.{p_end}
{p 8 12 2}4. Steps 1-3 are repeated on the default locale.{p_end}
{p 8 12 2}5. If a locale cannot be found after following the previous steps,
the ICU "Root", or built-in fallback, locale is used.{p_end}

{pstd}
The process stops at any point if the desired information is found. The ICU
default locale is usually the system locale on the machine, which you can
change.  Note that on macOS, the ICU default locale is usually
"en_US_posix", which does not change even if you change the system locale from
the operating system's "Language" setting.  To see the ICU default locale, you
can type

{phang2}
{cmd:. display c(locale_icudflt)}

{pstd}
You can also find it under the {cmd:Unicode settings} in the output of
{cmd:creturn list} along with two other locale-related settings:
{cmd:locale_ui} and {cmd:locale_functions}. See
{helpb set locale_ui:set locale_ui} and
{helpb set locale_functions:set locale_functions} for details.

{pstd}
{cmd:set locale_functions} affects the functions {cmd:ustrupper()},
{cmd:ustrlower()}, {cmd:ustrtitle()}, {cmd:ustrword()}, {cmd:ustrwordcount()},
{cmd:ustrcompare()}, {cmd:ustrcompareex()}, {cmd:ustrsortkey()}, and
{cmd:ustrsortkeyex()} when no locale is specified.  If
{cmd:locale_functions} is not set, the default ICU locale
{cmd:c(locale_icudflt)} is used.

{pstd}
For example, if your operating system is Microsoft Windows English version,
the system locale is most likely "en".  It is "en_US" if you chose the country
to be USA during installation of the operating system.  If
{cmd:locale_functions} is not set or is set to {cmd:default}, then
{cmd:ustrupper("istanbul")} is equivalent to 
{cmd:ustrupper("istanbul", "en_US")}, which returns {bf:ISTANBUL}. 

{pstd}
However, if {cmd:locale_functions} is set to {bf:tr} for Turkish, then
{cmd:ustrupper("istanbul")} is equivalent to
{cmd:ustrupper("istanbul", "tr")}, which returns {bf:İSTANBUL}
with a dot over the capital I.  Although ICU does not validate locales, Stata validates that
the language subtag of the {cmd:locale_functions} setting is a valid
ISO-639-2 language code.  (See the ISO-639-2 list at
{browse "http://www.loc.gov/standards/iso639-2/"}.) Hence,
{cmd:set locale_functions klingon} will produce an error.

{pstd}
With the fallback rules, the effective locale can be very different from the
locale you specified, depending on the operation being performed.  Currently,
{cmd:ustrword()} and {cmd:ustrwordcount()}, which use ICU's word break iterator
service, and {cmd:ustrcompare()}, {cmd:ustrcompareex()}, {cmd:ustrsortkey()}, and
{cmd:ustrsortkeyex()}, which use ICU's collation service, are affected by this.
You may use the functions {helpb wordbreaklocale():wordbreaklocale()} and
{helpb collatorlocale():collatorlocale()} to find the effective locale from the
requested locale.  
{p_end}
