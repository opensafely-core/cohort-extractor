{smcl}
{* *! version 1.1.13  08jun2019}{...}
{viewerdialog "label language" "dialog label_language"}{...}
{vieweralsosee "[D] label language" "mansection D labellanguage"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] label" "help label"}{...}
{vieweralsosee "[D] labelbook" "help labelbook"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] codebook" "help codebook"}{...}
{viewerjumpto "Syntax" "label_language##syntax"}{...}
{viewerjumpto "Menu" "label_language##menu"}{...}
{viewerjumpto "Description" "label_language##description"}{...}
{viewerjumpto "Links to PDF documentation" "label_language##linkspdf"}{...}
{viewerjumpto "Option" "label_language##option"}{...}
{viewerjumpto "Examples" "label_language##examples"}{...}
{viewerjumpto "Stored results" "label_language##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[D] label language} {hline 2}}Labels for variables and values in
multiple languages{p_end}
{p2col:}({mansection D labellanguage:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}List defined languages

{p 8 15 2}
{opt la:bel} {opt lang:uage}


{phang}Change labels to specified language name

{p 8 15 2}
{opt la:bel} {opt lang:uage} {it:languagename}


{phang}Create new set of labels with specified language name

{p 8 15 2}
{opt la:bel} {opt lang:uage} {it:languagename}{cmd:,} {...}
{cmd:new} [{cmd:copy}]


{phang}Rename current label set

{p 8 15 2}
{opt la:bel} {opt lang:uage} {it:languagename}{cmd:,} {opt ren:ame}


{phang}Delete specified label set

{p 8 15 2}
{opt la:bel} {opt lang:uage} {it:languagename}{cmd:,} {cmd:delete}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Data utilities > Label utilities > Set label language}


{marker description}{...}
{title:Description}

{pstd}
{cmd:label} {cmd:language} lets you create and use datasets that contain
different sets of data, variable, and value labels.  A dataset might contain
one set in English, another in German, and a third in Spanish.  A dataset may
contain up to 100 sets of labels.

{pstd}
We will write about the different sets as if they reflect different spoken
languages, but you need not use the multiple sets in this way.  You could
create a dataset with one set of long labels and another set of shorter ones.

{pstd}
One set of labels is in use at any instant, but a dataset may contain
multiple sets.  You can choose among the sets by typing

{phang2}. {cmd:label language} {it:languagename}

{pstd}
When other Stata commands produce output (such as {cmd:describe} and
{cmd:tabulate}), they use the currently set language.  When you
define or modify the labels by using the other {cmd:label} commands (see 
{manhelp label D}), you modify the current set.

{phang2}
{cmd:label} {cmd:language} (without arguments){break}
    lists the available languages and the name of the current one.  The
    current language refers to the labels you will see if you used, say,
    {cmd:describe} or {cmd:tabulate}.  The available languages refer to the
    names of the other sets of previously created labels.  For instance, you
    might currently be using the labels in {cmd:en} (English), but labels in
    {cmd:de} (German) and {cmd:es} (Spanish) may also be available.

{phang2}
{cmd:label} {cmd:language} {it:languagename}{break}
     changes the labels to those of the specified language.  For instance, if
     {cmd:label} {cmd:language} revealed that {cmd:en}, {cmd:de}, and {cmd:es}
     were available, typing {cmd:label language de} would change the current
     language to German.

{phang2}
{cmd:label} {cmd:language} {it:languagename}{cmd:,} {cmd:new}{break}
     allows you to create a new set of labels and collectively name them
     {it:languagename}.  You may name the set as you please, as long as the
     name does not exceed 24 characters.  If the labels correspond to spoken
     languages, we recommend that you use the language's ISO 639-1 two-letter
     code, such as {cmd:en} for English, {cmd:de} for German, and {cmd:es} for
     Spanish.  For a complete list of codes, see
     {browse "https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes"}.

{phang2}
{cmd:label} {cmd:language} {it:languagename}{cmd:,} {cmd:rename}{break}
    changes the name of the label set currently in use.  If the label set in
    use were named {cmd:default} and you now wanted to change that to
    {cmd:en}, you could type {cmd:label} {cmd:language} {cmd:en,}
    {cmd:rename}.

{pmore2}
    Our choice of the name {cmd:default} in the example was not accidental.
    If you have not yet used {cmd:label} {cmd:language} to create a new
    language, the dataset will have one language, named {cmd:default}.

{phang2}
{cmd:label} {cmd:language} {it:languagename}{cmd:,} {cmd:delete}{break}
    deletes the specified label set.  If {it:languagename} is also the current
    language, one of the other available languages becomes the current
    language.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D labellanguageQuickstart:Quick start}

        {mansection D labellanguageRemarksandexamples:Remarks and examples}

        {mansection D labellanguageMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt copy} is used with {cmd:label language, new} and copies the labels from
the current language to the new language.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse autom}

{pstd}List defined languages{p_end}
{phang2}{cmd:. label language}

{pstd}Change labels to {cmd:es}{p_end}
{phang2}{cmd:. label language es}

{pstd}Describe data{p_end}
{phang2}{cmd:. describe}

{pstd}Rename current label set to Spanish{p_end}
{phang2}{cmd:. label language Spanish, rename}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:label language} without arguments stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(k)}}number of languages defined{p_end}


{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(languages)}}list of languages, listed one after the other{p_end}
{synopt:{cmd:r(language)}}name of current language{p_end}
{p2colreset}{...}
