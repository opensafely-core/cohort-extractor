{smcl}
{* *! version 1.0.10  15may2018}{...}
{vieweralsosee "[M-5] ustrcompare()" "mansection M-5 ustrcompare()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] sort()" "help mf_sort"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf_ustrcompare##syntax"}{...}
{viewerjumpto "Description" "mf_ustrcompare##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_ustrcompare##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_ustrcompare##remarks"}{...}
{viewerjumpto "Conformability" "mf_ustrcompare##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ustrcompare##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ustrcompare##source"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[M-5] ustrcompare()} {hline 2}}Compare or sort Unicode strings
{p_end}
{p2col:}({mansection M-5 ustrcompare():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 36 2}
{it:real matrix}{space 5}{cmd:ustrcompare(}{it:string matrix s1}{cmd:,} {it:string matrix s2}{break}
 [{cmd:,} {it:string scalar loc}]{cmd:)}

{p 8 36 2}
{it:string matrix}{space 3}{cmd:ustrsortkey(}{it:string matrix s} [{cmd:,} {it:string scalar loc}]{cmd:)}

{p 8 36 2}
{it:real matrix}{space 3}{cmd:ustrcompareex(}{it:string matrix s1}{cmd:,} 
{it:s2}{cmd:,} 
{it:string scalar loc}{cmd:,} 
{it:real scalar st}{cmd:,} 
{it:case}{cmd:,} 
{it:cslv}{cmd:,} 
{it:norm}{cmd:,} 
{it:num}{cmd:,} 
{it:alt}{cmd:,} 
{it:fr}{cmd:)}

{p 8 36 2}
{it:string matrix} {cmd:ustrsortkeyex(}{it:string matrix s}{cmd:,} 
{it:string scalar loc}{cmd:,} 
{it:real scalar st}{cmd:,} 
{it:case}{cmd:,} 
{it:cslv}{cmd:,} 
{it:norm}{cmd:,} 
{it:num}{cmd:,} 
{it:alt}{cmd:,} 
{it:fr}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:ustrcompare(}{it:s1}{cmd:,} {it:s2} [{cmd:,} {it:loc}]{cmd:)} compares two 
Unicode strings.  The function returns -1, 1, or 0 if {it:s1} is less than, 
greater than, or equal to {it:s2}, respectively.
If {it:loc} is not specified, the
{helpb set locale_functions:locale_functions} setting is used.

{p 4 4 2}
{cmd:ustrsortkey(}{it:s}{cmd:,} {it:loc} [{cmd:,} {it:loc}]{cmd:)} generates a 
null-terminated byte array.  The {cmd:sort} command on the sort keys of two 
Unicode strings {it:s1} and {it:s2} produces the same order from 
{opt ustrcompare(s1, s2, loc)}.  If {it:loc} is not specified, the
{helpb set locale_functions:locale_functions} setting is used.
The result is also diacritic and case sensitive.  If you need 
different behavior, you should use the extended function {cmd:ustrsortkeyex()}. 

{p 4 4 2}
{cmd:ustrcompareex(}{it:s1}{cmd:,} {it:s2}{cmd:,} {it:loc}{cmd:,} {it:st}{cmd:,} {it:case}{cmd:,} {it:cslv}{cmd:,} {it:norm}{cmd:,} {it:num}{cmd:,} {it:alt}{cmd:,} {it:fr}{cmd:)}
is an extended version of {cmd:ustrcompare()}.  It provides more options for
the comparison behaviors. 

{p 4 4 2}
{cmd:ustrsortkeyex(}{it:s}{cmd:,} {it:loc}{cmd:,} {it:st}{cmd:,} {it:case}{cmd:,} {it:cslv}{cmd:,} {it:norm}{cmd:,} {it:num}{cmd:,} {it:alt}{cmd:,} {it:fr}{cmd:)}
is an extended version of {cmd:ustrsortkey()}.  It provides more options for
the comparison behaviors. 

{pstd}
The additional options are as follows:

{phang2}
{it:st} controls the strength of the comparison:

{p2colset 16 20 22 2}{...}
{p2col 15 20 22 2:{bf:-1}}default value for the locale{p_end}

{synopt:{bf:1}}primary; base-letter differences,
               such as "a" and "b"{p_end}

{synopt:{bf:2}}secondary; diacritical differences of the same
	base letter, such as "a" and "ä"{p_end}

{synopt:{bf:3}}tertiary; case differences of
	the same base letter, such as "a" and "A"{p_end}

{synopt:{bf:4}}quaternary; used to distinguish between
	Katakana and Hiragana for JIS 4061 collation standard{p_end}

{synopt:{bf:5}}identical; code-point order of the string;
	rarely useful{p_end}

{pmore2}
	 Numbers other than those listed above are treated as tertiary. 

{phang2}
{it:case} controls the uppercase and lowercase letter order.  Possible 
	values are {bf:1} (uppercase first), {bf:2} (lowercase first),
	or {bf:0} (use tertiary strength; advanced option).  {bf:-1} means the
	default value for the locale should be used.  Any other values are
	treated as {bf:0}.

{phang2}	
{it:cslv} controls whether an extra case level between the secondary level 
	and the tertiary level is generated.  Possible values are {bf:0} (off)
	or {bf:1} (on). {bf:-1} means the default value for the locale should
	be used.  Any other values are treated as {bf:0}.  Combining this
	setting to be "on" and the strength setting to be primary can achieve
	the effect of ignoring the diacritical differences but preserving the
	case differences.  If the setting is "on", the result is also affected
	by the {it:case} setting.

{phang2}	
{it:norm} controls whether the normalization check and normalizations are 
        performed.  Possible values are {bf:0} (off) or {bf:1} (on).  {bf:-1} 
	means the default value for the locale should be used.  Any other
	values are treated as {bf:0}.  Most languages do not require
	normalization for comparison.  Normalization is needed in languages
	that use multiple combining characters, such as Arabic, ancient Greek,
	or Hebrew.  For more information about normalization, see
	{helpb mf_ustrnormalize:[M-5] ustrnormalize()}. 

{phang2}	
{it:num} controls how contiguous digit substrings are sorted.  Possible 
        values are {bf:0} (off) or {bf:1} (on).  {bf:-1} means the 
	default value for the locale should be used.  Any other values are
	treated as {bf:0}.  If the setting is "on", substrings consisting of
	digits are sorted based on the numeric value.  For example, "100" is
	after "20" instead of before it.  Note that digit substrings are
	limited to 254 digits and that plus or minus signs, decimals, and exponents
	are not supported. 

{phang2}		
{it:alt} controls how spaces and punctuation characters are handled.  Possible 
	values are {bf:0} (use primary weights) or {bf:1} (alternative
	handling).  Any other values are treated as {bf:0}.  If the setting is
	{bf:1} (alternative handling), "onsite", "on-site", and
	"on site" are considered the same. 

{phang2}			
{it:fr} controls the direction of secondary strength.  Possible values are 
       {bf:0} (off) or {bf:1} (on).  {bf:-1} means the default value 
       for the locale should be used.  All other values are treated as "off".
       If the setting is "on", the diacritical letters are sorted backward.
       Note that the setting is "on" by default only for Canadian French
       locale ({bf:fr_CA}). 

{p 4 4 2}
When {it:s1} and {it:s2} are not scalar, these functions return
element-by-element results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 ustrcompare()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{mansection U 12.4.2.4LocalesinUnicode:Unicode string comparison} is locale
dependent.  For example, z < ö in Swedish but ö < z in German.  The comparison
is diacritic and case sensitive.  If you need different behavior, such as
case-insensitive comparison, you should use the extended comparison function
{cmd:ustrcompareex()}.  Unicode string comparison is language sensitive, which
is different from the byte value comparison used by {cmd:sort}.  For example,
capital letter "Z" (byte value 90) comes before lowercase "a" (byte value 97)
in terms of byte value but comes after "a" in any English dictionary.
		
{p 4 4 2} An invalid UTF-8 sequence is replaced with the Unicode replacement
character {bf:\ufffd}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:ustrcompare(}{it:s1}{cmd:,} {it:s2} [{cmd:,} {it:loc}]{cmd:)}:
{p_end}
	       {it:s1}:  {it:r x c} 
	       {it:s2}:  {it:r x c}
	      {it:loc}:  1 {it:x} 1
	   {it:result}:  {it:r x c}

{p 4 4 2}
{cmd:ustrsortkey(}{it:s} [{cmd:,} {it:loc}]{cmd:)}:
{p_end}
		{it:s}:  {it:r x c} 
	      {it:loc}:  1 {it:x} 1
	   {it:result}:  {it:r x c}

{p 4 4 2}
{cmd:ustrcompareex(}{it:s1}{cmd:,} {it:s2}{cmd:,} {it:loc}{cmd:,} {it:st}{cmd:,} {it:case}{cmd:,} {it:cslv}{cmd:,} {it:norm}{cmd:,} {it:num}{cmd:,} {it:alt}{cmd:,} {it:fr}{cmd:)}:
{p_end}
	       {it:s1}:  {it:r x c} 
	       {it:s2}:  {it:r x c} 
	      {it:loc}:  1 {it:x} 1
	       {it:st}:  1 {it:x} 1
	     {it:case}:  1 {it:x} 1
	     {it:cslv}:  1 {it:x} 1
	     {it:norm}:  1 {it:x} 1
	      {it:num}:  1 {it:x} 1
	      {it:alt}:  1 {it:x} 1
	       {it:fr}:  1 {it:x} 1
	   {it:result}:  {it:r x c}

{p 4 4 2}
{cmd:ustrsortkeyex(}{it:s}{cmd:,} {it:loc}{cmd:,} {it:st}{cmd:,} {it:case}{cmd:,} {it:cslv}{cmd:,} {it:norm}{cmd:,} {it:num}{cmd:,} {it:alt}{cmd:,} {it:fr}{cmd:)}:
{p_end}
		{it:s}:  {it:r x c} 
	      {it:loc}:  1 {it:x} 1
	       {it:st}:  1 {it:x} 1
	     {it:case}:  1 {it:x} 1
	     {it:cslv}:  1 {it:x} 1
	     {it:norm}:  1 {it:x} 1
	      {it:num}:  1 {it:x} 1
	      {it:alt}:  1 {it:x} 1
	       {it:fr}:  1 {it:x} 1
	   {it:result}:  {it:r x c}

	   
{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:ustrcompare()} and {cmd:ustrcompareex()} return a negative number other
than -1 if an error occurs.

{p 4 4 2}
{cmd:ustrsortkey()} and {cmd:ustrsortkeyex()} return an empty string if an
error occurs.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
