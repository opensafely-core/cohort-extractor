{smcl}
{* *! version 1.0.4  19oct2017}{...}
{vieweralsosee "[D] unicode collator" "mansection D unicodecollator"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] unicode" "help unicode"}{...}
{vieweralsosee "[D] unicode locale" "help unicode locale"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}
{findalias asfrunicodesort}
{viewerjumpto "Syntax" "unicode_collator##syntax"}{...}
{viewerjumpto "Description" "unicode_collator##description"}{...}
{viewerjumpto "Links to PDF documentation" "unicode_collator##linkspdf"}{...}
{viewerjumpto "Remarks" "unicode_collator##remarks"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[D] unicode collator} {hline 2}}Language-specific Unicode collators{p_end}
{p2col:}({mansection D unicodecollator:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:unicode}
{opt coll:ator}
{cmd:list}
[{it:pattern}]

{phang}
{it:pattern} is one of {cmd:_all}, {cmd:*}, {cmd:*}{it:name}{cmd:*},
{cmd:*}{it:name}, or {it:name}{cmd:*}.  If you specify nothing, {cmd:_all}, or
{cmd:*}, then all results will be listed.  {cmd:*}{it:name}{cmd:*} lists all
results containing {it:name}; {cmd:*}{it:name} lists all results ending with
{it:name}; and {it:name}{cmd:*} lists all results starting with {it:name}.     


{marker description}{...}
{title:Description}

{pstd}
{cmd:unicode collator list} lists the subset of locales that have
language-specific collators for the Unicode string comparison functions:
{cmd:ustrcompare()}, {cmd:ustrcompareex()}, {cmd:ustrsortkey()}, and
{cmd:ustrsortkeyex()}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D unicodecollatorRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings: 

        {help unicode_collator##remarks1:Overview of collation}
        {help unicode_collator##remarks2:The role of locales in collation}
        {help unicode_collator##remarks3:Further controlling collation}


{marker remarks1}{...}
{title:Overview of collation}

{pstd}
Collation is the process of comparing and sorting Unicode character strings
as a human might logically order them.  We call this ordering strings in a
language-sensitive manner.  To do this, Stata uses a Unicode tool known as
the Unicode collation algorithm, or UCA.

{pstd} 
To perform language-sensitive string sorts, you must combine 
{helpb ustrsortkey()} or {helpb ustrsortkeyex()} with {helpb sort}.  It is a
complicated process and there are several issues about which you need to be
aware.  For details, see {findalias frunicodesort}.  To perform
language-sensitive string comparisons, you can use {helpb ustrcompare()}
or {helpb ustrcompareex()}.

{pstd} 
For details about the UCA, see {browse "http://www.unicode.org/reports/tr10/"}.


{marker remarks2}{...}
{title:The role of locales in collation}

{pstd}
During collation, Stata can use the default collator or it can perform
language-sensitive string comparisons or sorts that require knowledge of a
locale.

{pstd}
A locale identifies a community with a certain set of preferences for how
their language should be written; see {findalias frlocales}.  For example, in
English, the uppercase letter of the Latin small letter "i" is the Latin
capital letter "I".  However, in Turkish, the uppercase letter is "I" with
a dot above it (Unicode {bf:\u0130}); hence, the case mapping is
locale-sensitive. 

{pstd}
Collation in Stata involves the locale-sensitive functions {cmd:ustrcompare()},
{cmd:ustrcompareex()}, {cmd:ustrsortkey()}, and {cmd:ustrsortkeyex()}. If you
specify a locale with one of these functions or if you have set the locale
globally (see {helpb set locale_functions}), then collation may be
performed using a language-specific collator.

{pstd}
Because a locale is simply an identifier to locate the resources for
specific services, there is no validation of the locale.  For example,
specifying "klingon" is as valid as specifying "en" when calling
{cmd:ustrcompare()} or the other functions discussed here. If the collation
data for the "klingon" locale is found, then the locale is populated;
otherwise, fallback rules are followed. For more information, see 
{help unicode_locale##remarks2:{it:Default locale and locale fallback}} in 
{bf:[D] unicode locale}.

{pstd}
Stata supports hundreds of locales, but only about 100 have a
language-specific collator.  {cmd:unicode collator list} lets you determine
whether your locale (or language) has its own collator.  For example, Stata
supports two locales for the Zulu language:  {cmd:zu} is a general locale and
{cmd:zu_ZA} is Zulu specific to South Africa. Only {cmd:zu} has a
language-specific collator.


{marker remarks3}{...}
{title:Further controlling collation}

{pstd}
{cmd:ustrcompare()} and {cmd:ustrsort()} use the default collation algorithm for
the locale.  However, you can exercise finer control over the collation
algorithm if you use {cmd:ustrcompareex()} or {cmd:ustrsortkeyex()}.

{pstd}
An International Components for Unicode (ICU) locale may contain up to five
subtags in the following order:  language, script, country, variant, and
keywords.  Stata usually uses only the language and country tags.  However,
collation keywords may be used in the {cmd:ustrcompareex()} and
{cmd:ustrsortkeyex()} functions.

{pstd}
The collation keyword specifies the string sort order of the locale. For
example, "pinyin" and "stroke" for Chinese language produce different string
sort orders.  In most cases, it is not necessary to specify a collation
keyword; the default collator (either for Stata or for the language) provides
sufficient control.  However, some programmers may wish to specify a specific
value.  If you do not know the value of the collation keyword, you can obtain
a list of valid collation values and their meanings in XML format at
{browse "http://unicode.org/repos/cldr/trunk/common/bcp47/collation.xml"}.

{pstd}
If you are comparing or sorting Unicode strings that have come from different
data sources, then you may need to normalize the strings before ordering them.
See {helpb ustrnormalize()} for details on normalization, and note the
{it:norm} parameter in {helpb ustrcompareex()} and {helpb ustrsortkeyex()}.
{p_end}
