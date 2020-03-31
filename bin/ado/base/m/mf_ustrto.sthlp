{smcl}
{* *! version 1.0.8  15may2018}{...}
{vieweralsosee "[M-5] ustrto()" "mansection M-5 ustrto()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] ustrfix()" "help mf_ustrfix"}{...}
{vieweralsosee "[M-5] ustrunescape()" "help mf_ustrunescape"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{findalias asfrencodings}{...}
{viewerjumpto "Syntax" "mf_ustrto##syntax"}{...}
{viewerjumpto "Description" "mf_ustrto##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_ustrto##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_ustrto##remarks"}{...}
{viewerjumpto "Conformability" "mf_ustrto##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ustrto##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ustrto##source"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] ustrto()} {hline 2}}Convert a Unicode string to or from a string
in a specified encoding
{p_end}
{p2col:}({mansection M-5 ustrto():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 31 2}
{it:string matrix}{space 3}{cmd:ustrto(}{it:string matrix s}{cmd:,} {it:string scalar enc}{cmd:,}{break} 
{it:real scalar mode}{cmd:)}

{p 8 31 2}
{it:string matrix} {cmd:ustrfrom(}{it:string matrix s}{cmd:,} {it:string scalar enc}{cmd:,}{break} 
{it:real scalar mode}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:ustrto(}{it:s}{cmd:,} {it:enc}{cmd:,} {it:mode}{cmd:)}
converts the Unicode string {it:s} to a string encoded in {it:enc}.  Any
invalid UTF-8 sequence in {it:s} is replaced with a Unicode replacement
character {bf:\ufffd}.  {it:mode} controls how unsupported Unicode characters
in the encoding {it:enc} are handled.  The possible values for {it:mode} are
{bf:1}, which substitutes any unsupported characters with the {it:enc}'s
substitution string; {bf:2}, which skips any unsupported characters; {bf:3},
which stops at the first unsupported character and returns an empty string; or
{bf:4}, which replaces any unsupported character with an escaped hex digit
sequence {bf:\uhhhh} or {bf:\Uhhhhhhhh}.  The hex digit sequence contains
either four or eight hex digits depending on the Unicode character's
code-point value.  Any other values are treated as {bf:1}.  

{p 4 4 2}
{cmd:ustrfrom(}{it:s}{cmd:,} {it:enc}{cmd:,} {it:mode}{cmd:)}
converts a string {it:s} in encoding {it:enc} to a UTF-8 
encoded Unicode string.  {it:mode} controls how invalid byte sequences 
in {it:s} are handled.  The possible values for {it:mode} are {bf:1}, which
substitutes an invalid byte sequence with a Unicode replacement character
{bf:\ufffd}; {bf:2}, which skips any invalid byte sequences; {bf:3}, which
stops at the first invalid byte sequence and returns an empty string; or
{bf:4}, which replaces any byte in an invalid sequence with an escaped hex
digit sequence {bf:%Xhh}.  Any other values are treated as {bf:1}. 

{pstd}
When arguments are not scalar, {cmd:ustrto()} returns element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 ustrto()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Type {cmd:unicode encoding list} to list available encodings.
See {findalias frencodings} and see the {cmd:unicode encoding}
command in {helpb unicode} for details.
  
{p 4 4 2}
The substitution character for both ASCII and Latin-1 encoding 
is {cmd:char(26)}

{p 4 4 2}
A good use of {cmd:mode=4} ({it:escape}) is to check what invalid bytes a
Unicode string {cmd:ust} contains by examining the result of
{cmd:ustrfrom(ust, "utf-8", 4)}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:ustrto(}{it:s}{cmd:,} {it:enc}{cmd:,} {it:mode}{cmd:)},
{cmd:ustrfrom(}{it:s}{cmd:,} {it:enc}{cmd:,} {it:mode}{cmd:)}:
{p_end}

            {it:s}:  {it:r x c}
          {it:enc}:  1 {it:x} 1
         {it:mode}:  1 {it:x} 1
       {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{pstd}
{cmd:ustrto(}{it:s}{cmd:,} {it:enc}{cmd:,} {it:mode}{cmd:)} and
{cmd:ustrfrom(}{it:s}{cmd:,} {it:enc}{cmd:,} {it:mode}{cmd:)}
return an empty string if an error occurs.


{marker source}{...}
{title:Source code}

{pstd}
Functions are built in.
{p_end}
