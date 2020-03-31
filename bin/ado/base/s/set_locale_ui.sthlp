{smcl}
{* *! version 1.0.9  03may2019}{...}
{vieweralsosee "[P] set locale_ui" "mansection P setlocale_ui"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] creturn" "help creturn"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{viewerjumpto "Syntax" "set_locale_ui##syntax"}{...}
{viewerjumpto "Description" "set_locale_ui##description"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[P] set locale_ui} {hline 2}}Specify a localization package for the user interface
{p_end}
{p2col:}({mansection P setlocale_ui:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{pstd}
Specify a locale for user interface localization

{p 8 16 2}
{cmd:set}
{cmd:locale_ui}
{it:locale}


{pstd}
Use the system locale for user interface localization 

{p 8 16 2}
{cmd:set}
{cmd:locale_ui}
{cmd:default}


            {it:locale}       Supported localization packages
           {hline 46}
            {opt default}      System default
            {opt en}           English
            {opt zh_CN}        Chinese (simplified)
            {opt ja}           Japanese
            {opt ko}           Korean
            {opt es}           Spanish
            {opt sv}           Swedish
           {hline 46}


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:locale_ui} {it:locale} sets the locale that Stata uses for the
user interface (UI).  For example, the command {cmd:set locale_ui ja} causes
Stata to display menus and various other UI text in Japanese.  If a
localization package can be matched to the specified {it:locale}, the language
contained in that package will be used to display various UI elements (menus,
dialogs, message boxes, etc.).  The setting takes effect the next time Stata
starts.  If a locale specified in {cmd:set} {cmd:locale_ui} cannot be matched,
the UI will be displayed using English.

{pstd}
{cmd:set} {cmd:locale_ui} {cmd:default} sets the locale that Stata uses
to the system default.  With this default setting, Stata will attempt to match
the locale set in your computer's operating system. If the system default can
be matched to one of Stata's installed localization packages, the UI elements
will be displayed in the corresponding language.  If Stata does not provide a
localization package that can be matched to your operating system's locale,
then English will be used.

{pstd}
For further discussion of locales, see {findalias frlocales}.

{pstd}
The current UI setting is stored in {cmd:c(locale_ui)}.
{p_end}
