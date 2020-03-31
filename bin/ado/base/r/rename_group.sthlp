{smcl}
{* *! version 1.0.12  17may2019}{...}
{viewerdialog "Variables Manager" "stata varmanage"}{...}
{viewerdialog rename "dialog rename"}{...}
{vieweralsosee "[D] rename group" "mansection D renamegroup"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] rename" "help rename"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] generate" "help generate"}{...}
{vieweralsosee "[D] varmanage" "help varmanage"}{...}
{viewerjumpto "Syntax" "rename_group##syntax"}{...}
{viewerjumpto "Menu" "rename_group##menu"}{...}
{viewerjumpto "Description" "rename_group##description"}{...}
{viewerjumpto "Links to PDF documentation" "rename_group##linkspdf"}{...}
{viewerjumpto "Options for renaming variables" "rename_group##options_rename"}{...}
{viewerjumpto "Options for changing the case" "rename_group##options_case"}{...}
{viewerjumpto "Technical note" "rename_group##technote"}{...}
{viewerjumpto "Stored results" "rename_group##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[D] rename group} {hline 2}}Rename groups of variables{p_end}
{p2col:}({mansection D renamegroup:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}Rename a single variable

{p 8 20 2}
{opt ren:ame} {it:old} {it:new} [{cmd:,} {it:{help rename group##options1:options1}}]


{pstd}Rename groups of variables

{p 8 20 2}
{opt ren:ame} {cmd:(}{it:old1 old2} ...{cmd:)} {cmd:(}{it:new1 new2} ...{bf:)}{...}
[{cmd:,} {it:{help rename group##options1:options1}}]


{pstd}Change the case of groups of variable names

{p 8 20 2}
{opt ren:ame}  {it:old1 old2} ...{cmd:,}
   {c -(}{opt u:pper}|{opt l:ower}|{opt p:roper}{c )-} {...}
[{it:{help rename group##options2:options2}}]


{p 4 4 2}
where {it:old} and {it:new} specify the existing and the new variable names.
The rules for specifying them are

{marker item1}{...}
{p 8 11 2}
    1. {bf:rename stat status}:
	Renames {bf:stat} to {bf:status}.

{p 15 15 2}
            Rule 1: This is the same {cmd:rename} command documented in 
	    {bf:{help rename:[D] rename}}, with which you are familiar.

{p 8 11 2}
    2. {bf:rename (stat inc) (status income)}: Renames {bf:stat} to
       {bf:status} and {bf:inc} to {bf:income}.

{p 15 15 2}
           Rule 2: Use parentheses to specify multiple variables for
           {it:old} and {it:new}.

{p 8 11 2}
    3. {bf:rename (v1 v2) (v2 v1)}: Swaps {bf:v1} and {bf:v2}.

{p 15 15 2}
           Rule 3: Variable names may be interchanged.

{p 8 11 2}
    4. {bf:rename (a b c) (b c a)}: Swaps names. Renames {bf:a} to {bf:b},
    {bf:b} to {bf:c}, and {bf:c} to {bf:a}.

{p 15 15 2}
            Rule 4: There is no limit to how many names may be
            interchanged.

{p 8 11 2}
    5. {bf:rename (a b c) (c b a)}: Renames {bf:a} to {bf:c} and {bf:c} to
    {bf:a}, but leaves {bf:b} as is.

{p 15 15 2}
           Rule 5: Renaming variables to themselves is allowed.

{p 8 11 2}
    6. {bf:rename jan* *1}: Renames all variables starting with {bf:jan} to
    instead end with {bf:1}, for example, {bf:janstat} to {bf:stat1},
    {bf:janinc} to {bf:inc1}, etc.

{p 15 15 2}
           Rule 6.1: {bf:*} in {it:old} selects the variables to be
           renamed.  {bf:*} means that zero or more characters go here.

{p 15 15 2}
           Rule 6.2: {bf:*} in {it:new} corresponds with {bf:*} in
           {it:old} and stands for the text that {bf:*} in {it:old} matched.

{p 11 11 2}
        {bf:*} in {it:new} or {it:old} is called a wildcard character, or just
        a wildcard.

{p 11 11 2}
        {bf:rename jan* *}: Removes prefix {bf:jan}.

{p 11 11 2}
        {bf:rename *jan *}: Removes suffix {bf:jan}.


{p 8 11 2}
    7. {bf:rename jan? ?1}: Renames all variables starting with {bf:jan} and
    ending in one character by removing {bf:jan} and adding {bf:1} to the end;
    for example, {bf:jans} is renamed to {bf:s1}, but {bf:janstat} remains
    unchanged.
    {bf:?} means that exactly one character goes here, just as {bf:*} means that zero
    or more characters go here.

{p 15 15 2}
            Rule 7: {bf:?} means exactly one character, {bf:??} means exactly two
            characters, etc.

{p 8 11 2}
    8. {bf:rename *jan* **}: Removes prefix, midfix, and suffix {bf:jan},
	for example, {bf:janstat} to {bf:stat}, {bf:injanstat} to {bf:instat},
        and {bf:subjan} to {bf:sub}.

{p 15 15 2}
           Rule 8: You may specify more than one wildcard in {it:old} and
           in {it:new}.  They correspond in the order given.

{p 11 11 2}
        {bf:rename jan*s* *s*1}: Renames all variables that start with
        {bf:jan} and contain {bf:s} to instead end in {bf:1}, dropping the
	{bf:jan}, for example, {bf:janstat} to {bf:stat1} and {bf:janest} to
        {bf:est1}, but not {bf:janinc} to {bf:inc1}.

{p 8 11 2}
    9. {bf:rename *jan* *}: Removes {bf:jan} and whatever follows from
    variable names, thereby renaming {bf:statjan} to {bf:stat}, {bf:incjan71} to
    {bf:inc}, ....

{p 15 15 2}
            Rule 9: You may specify more wildcards in {it:old} than in
            {it:new}.

{p 7 11 2}
   10. {bf:rename *jan* .*}: Removes {bf:jan} and whatever precedes it from
    variable names, thereby renaming {bf:midjaninc} to {bf:inc}, ....

{p 15 15 2}
           Rule 10: Wildcard {bf:.} (dot) in {it:new} skips over
           the corresponding wildcard in {it:old}.

{p 7 11 2}
   11. {bf:rename *pop jan=}: Adds prefix {bf:jan} to all variables ending 
       in {cmd:pop}, for example, {cmd:age1pop} to {cmd:janage1pop}, .... 
       
{p 11 11 2}
       {bf:rename (status bp time) admit=}: Renames {bf:status} to 
       {bf:admitstatus}, {bf:bp} to {bf:admitbp}, and {bf:time} 
       to {bf:admittime}.

{p 11 11 2}
       {bf:rename} {it:whatever} {bf:pre=}: Adds prefix {cmd:pre} to all
       variables selected by {it:whatever}, however {it:whatever} is
       specified.

{p 15 15 2}
           Rule 11: Wildcard {bf:=} in {it:new} specifies the original
           variable name.

{p 11 11 2}
        {bf:rename} {it:whatever} {bf:=jan}: Adds suffix {bf:jan} to all
        variables selected by {it:whatever}.

{p 11 11 2}
        {bf:rename} {it:whatever} {bf:pre=fix}: Adds prefix {bf:pre} and suffix
        {bf:fix} to all variables selected by {it:whatever}.

{p 7 11 2}
   12. {bf:rename v# stat#}: Renames {bf:v1} to {bf:stat1,} {bf:v2 }to
   {bf:stat2}, ..., {bf:v10} to {bf:stat10}, ....

{p 15 15 2}
           Rule 12.1: {bf:#} is like {bf:*} but for digits.  {bf:#} in
           {it:old} selects one or more digits.

{p 15 15 2}
           Rule 12.2: {bf:#} in {it:new} copies the digits just as they
           appear in the corresponding {it:old}.

{p 7 11 2}
   13. {bf:rename v(#) stat(#)}: Renames {bf:v1} to {bf:stat1}, {bf:v2} to
   {bf:stat2}, ..., but does not rename {bf:v10}, ....

{p 15 15 2}
           Rule 13.1: {bf:(#)} in {it:old} selects exactly one digit.
           Similarly, {bf:(##)} selects exactly two digits, and so on, up to ten {bf:#}
           symbols.

{p 15 15 2}
           Rule 13.2:  {bf:(#)} in {it:new} means reformat to one or more
           digits.  Similarly, {bf:(##)} reformats to two or more digits, and
           so on, up to ten {bf:#} symbols.

{p 11 11 2}
        {bf:rename v(##) stat(##)}: Renames {bf:v01} to {bf:stat01}, {bf:v02}
        to {bf:stat02}, ..., {bf:v10} to {bf:stat10}, ..., but does not rename
        {bf:v0}, {bf:v1}, {bf:v2}, ..., {bf:v9}, {bf:v100}, ....

{p 7 11 2}
   14. {bf:rename v# v(##)}: Renames {bf:v1} to {bf:v01}, {bf:v2} to {bf:v02},
   ..., {bf:v10} to {bf:v10}, {bf:v11} to {bf:v11}, ..., {bf:v100} to
   {bf:v100}, {bf:v101} to {bf:v101}, ....

{p 15 15 2}
           Rule 14: You may combine {bf:#}, {bf:(#)}, {bf:(##)}, ... in
           {it:old} with any of {bf:#}, {bf:(#)}, {bf:(##)}, ... in {it:new}.

{p 11 11 2}
        {bf:rename v(##) v(#)}: Renames {bf:v01} to {bf:v1}, {bf:v02} to
        {bf:v2}, ..., {bf:v10} to {bf:v10}, ..., but does not rename
        {bf:v001}, etc.

{p 11 11 2}
        {bf:rename stat(##) stat_20(##)}: Renames {bf:stat10} to
        {bf:stat_2010}, {bf:stat11} to {bf:stat_2011}, ..., but does not
        rename {bf:stat1}, {bf:stat2}, ....

{p 11 11 2}
        {bf:rename stat(#) to stat_200(#)}:
	Renames {bf:stat1} to {bf:stat_2001}, {bf:stat2} to {bf:stat_2002}, ...,
	but does not rename {bf:stat10} or {bf:stat_2010}.

{marker item15}{...}
{p 7 11 2}
   15. {bf:rename v# (a b c)}: Renames {bf:v1} to {bf:a}, {bf:v10} to {bf:b},
   and {bf:v2} to {bf:c} if variables {bf:v1}, {bf:v10}, {bf:v2} appear in
   that order in the data.  Because three variables were specified in
   {it:new}, {bf:v#} in {it:old} must select three variables or {bf:rename}
   will issue an error.

{p 15 15 2}
           Rule 15.1: You may mix syntaxes.  Note that the explicit and
           implied numbers of variables must agree.

{p 11 11 2}
        {bf:rename v# (a b c), sort}: Renames (for instance) {bf:v1} to
        {bf:a}, {bf:v2} to {bf:b}, and {bf:v10} to {bf:c}.

{marker rule15.2}{...}
{p 15 15 2}
            Rule 15.2: The {bf:sort} option places the variables selected by
            {it:old} in order and does so smartly.  In the case where {bf:#},
            {bf:(#)}, {bf:(##)}, ... appear in {it:old}, {bf:sort} places
            the variables in numeric order.

{p 11 11 2}
        {bf:rename v* (a b c), sort}: Renames (for instance) {bf:valpha} to
        {bf:a}, {bf:vbeta} to {bf:b}, and {bf:vgamma to c} regardless of the
        order of the variables in the data.

{marker rule15.3}{...}
{p 15 15 2}
            Rule 15.3: In the case where {bf:*} or {bf:?} appears in
            {it:old}, {bf:sort} places the variables in alphabetical order.

{marker item16}{...}
{p 7 11 2}
   16. {bf:rename v# v#, renumber}: Renames (for instance) {bf:v9} to
   {bf:v1}, {bf:v10} to {bf:v2}, {bf:v8} to {bf:v3}, ..., assuming that
   variables
   {bf:v9}, {bf:v10}, {bf:v8}, ... appear in that order in the data.

{p 15 15 2}
	    Rule 16.1: The {bf:renumber} option resequences the numbers.

{p 11 11 2}
        {bf:rename v# v#, renumber sort}: Renames (for instance) {bf:v8} to
        {bf:v1}, {bf:v9} to {bf:v2}, {bf:v10} to {bf:v3}, ....  Concerning
        option {bf:sort}, see {help rename group##rule15.2:rule 15.2} above.

{p 11 11 2}
        {bf:rename v# v#, renumber(10) sort}: Renames (for instance) {bf:v8}
        to {bf:v10}, {bf:v9} to {bf:v11}, {bf:v10} to {bf:v12}, ....

{p 15 15 2}
            Rule 16.2: The {opt renumber(#)} option allows you to
            specify the starting value.

{p 7 11 2}
   17. {bf:rename v* v#, renumber}: Renames (for instance) {bf:valpha} to
   {bf:v1}, {bf:vgamma} to {bf:v2}, {bf:vbeta} to {bf:v3}, ..., assuming
   variables {bf:valpha}, {bf:vgamma}, {bf:vbeta}, ... appear in that order
   in the data.

{p 15 15 2}
            Rule 17: {bf:#} in {it:new} may correspond to {bf:*},
            {bf:?}, {bf:#}, {bf:(#)}, {bf:(##)}, ... in {it:old}.

{p 11 11 2}
        {bf:rename v* v#, renumber sort}: Renames (for instance) {bf:valpha}
        to {bf:v1}, {bf:vbeta} to {bf:v2}, {bf:vgamma} to {bf:v3}, ....  Also
        see {help rename group##rule15.3:rule 15.3} above concerning the
        {bf:sort} option.

{p 11 11 2}
        {bf:rename *stat stat#, renumber}: Renames, for instance, {bf:janstat}
        to {bf:stat1}, {bf:febstat} to {bf:stat2}, ....  Note that {bf:#} in
        {it:new} corresponds to {bf:*} in {it:old}, just as in the previous
        example.

{p 11 11 2}
        {bf:rename *stat stat(##), renumber}: Renames, for instance,
        {bf:janstat} to {bf:stat01}, {bf:febstat} to {bf:stat02}, ....

{p 11 11 2}
        {bf:rename *stat stat#, renumber(0)}: Renames, for instance,
        {bf:janstat} to {bf:stat0}, {bf:febstat} to {bf:stat1}, ....

{p 11 11 2}
        {bf:rename *stat stat#, renumber sort}: Renames, for instance,
        {bf:aprstat} to {bf:stat1}, {bf:augstat} to {bf:stat2}, ....

{marker item18}{...}
{p 7 11 2}
   18. {bf:rename (a b c) v#, addnumber}: Renames {bf:a} to {bf:v1}, {bf:b} to
   {bf:v2}, and {bf:c} to {bf:v3}.

{p 15 15 2}
           Rule 18: The {bf:addnumber} option allows you to add numbering.
           More formally, if you specify {bf:addnumber}, you may specify one
           more wildcard in {it:new} than is specified in {it:old}, and
           that extra wildcard must be {bf:#}, {bf:(#)}, {bf:(##)}, ....

{p 7 11 2}
   19. {bf:rename a(#)(#) a(#)[2](#)[1]}: Renames {bf:a12} to {bf:a21},
       {bf:a13} to {bf:a31}, {bf:a14} to {bf:a41}, ..., {bf:a21} to
       {bf:a12}, ....

{p 15 15 2}
           Rule 19.1: You may specify explicit subscripts with wildcards 
           in {it:new} to make explicit its matching wildcard in {it:old}.
           Subscripts are specified in square brackets after 
           a wildcard in {it:new}.  The number refers to the number of 
           the wildcard in {it:old}.

{p 11 11 2}
        {bf:rename *stat* *[2]stat*[1]}: Swaps prefixes and suffixes; it 
        renames {bf:bpstata} to {bf:astatbp}, {bf:rstater} to {bf:erstatr}, 
	etc.

{p 11 11 2}
        {bf:rename *stat* *[2]stat*}: Does the same as above; it swaps prefixes
        and suffixes.

{p 15 15 2}
           Rule 19.2: After specifying a subscripted wildcard, subsequent
           unsubscripted wildcards correspond to the same wildcards in
           {it:old} as they would if you had removed the subscripted wildcards
           altogether.

{p 11 11 2}
        {bf:rename v#a# v#_#[1]_a#[2]}: Renames {bf:v1a1} to {bf:v1_1_a1},
        {bf:v1a2} to {bf:v1_1_a2}, ..., {bf:v2a1} to {bf:v2_2_a1}, ....

{p 15 15 2}
           Rule 19.3: Using subscripts, you may refer to the same 
           wildcard in {it:old} more than once.

{p 11 11 2}
      Subscripts are commonly used to interchange suffixes at the ends of
      variable names.  For instance, you have districts and schools within
      them, and many of the variable names in your data match {bf:*_#_#}.  The
      first number records district and the second records school within 
      district.  To reverse the ordering, you type {bf:rename} {bf:*_#_#}
      {bf:*_#[3]_#[2]}.  When specifying subscripts, you refer to them
      by the position number in the original name. For example, our original 
      name was {cmd:*_#_#} so {cmd:[1]} refers to {cmd:*}, {cmd:[2]} refers
      to the first {cmd:#}, and {cmd:[3]} refers to the last {cmd:#}.


{col 9}Specifier{col 22}Meaning in {it:old}
{col 9}{hline 67}
{...}
{col 9}{bf:*}{...}
{col 22}0 or more characters
{...}
{col 9}{bf:?}{...}
{col 22}1 character exactly
{...}
{col 9}{bf:#}{...}
{col 22}1 or more digits
{...}
{col 9}{bf:(#)}{...}
{col 22}1 digit exactly
{...}
{col 9}{bf:(##)}{...}
{col 22}2 digits exactly
{...}
{col 9}{bf:(###)}{...}
{col 22}3 digits exactly
{...}
{col 9}...
{...}
{col 9}{bf:(##########)}{...}
{col 22}10 digits exactly
{col 9}{hline 67}

{col 22}May correspond
{col 9}Specifier{col 22}in {it:old} with{col 44}Meaning in {it:new}
{col 9}{hline 67}
{...}
{col 9}{bf:*}{...}
{col 22}{bf:*}, {bf:?}, {bf:#}, {bf:(#)}, ...{...}
{col 44}copies matched text
{...}
{col 9}{bf:?}{...}
{col 22}{bf:?}{...}
{col 44}copies a character
{...}
{col 9}{bf:#}{...}
{col 22}{bf:#}, {bf:(#)}, ...{...}
{col 44}copies a number as is
{...}
{col 9}{bf:(#)}{...}
{col 22}{bf:#}, {bf:(#)}, ...{...}
{col 44}reformats to 1 or more digits
{...}
{col 9}{bf:(##)}{...}
{col 22}{bf:#}, {bf:(#)}, ...{...}
{col 44}reformats to 2 or more digits
{...}
{col 9}...
{...}
{col 9}{bf:(##########)}{...}
{col 22}{bf:#}, {bf:(#)}, ...{...}
{col 44}reformats to 10 digits
{col 9}{bf:.}{...}
{col 22}{bf:*}, {bf:?}, {bf:#}, {bf:(#)}, ...{...}
{col 44}skip
{col 9}{bf:=}{...}
{col 22}{it:nothing}{...}
{col 44}copies entire variable name
{col 9}{hline 67}
{p 8 8 2}
Specifier {bf:#} in any of its guises may also
correspond with {bf:*} or {bf:?} if the 
{bf:renumber} option is specified.


{marker options1}{...}
{synoptset}{...}
{p2colset 9 30 32 2}{...}
{synopthdr:options1}
{p2line}
{p2col :{opt addnum:ber}}add sequential numbering to end{p_end}
{p2col :{opt addnum:ber(#)}}{cmd:addnumber}, starting at {it:#}{p_end}
{p2col :{opt renum:ber}}renumber sequentially{p_end}
{p2col :{opt renum:ber(#)}}{cmd:renumber}, starting at {it:#}{p_end}
{p2col :{opt s:ort}}sort before numbering{p_end}

{p2col :{opt d:ryrun}}do not rename, but instead produce a report{p_end}
{p2col :{opt r}}store variable names in {cmd:r()} for programming use{p_end}
{p2line}
{p 8 8 2}
These options correspond to the first and second syntaxes.

{marker options2}{...}
{synopthdr:options2}
{p2line}
{p2col :{opt u:pper}}uppercase ASCII letters in variable names (UPPERCASE){p_end}
{p2col :{opt l:ower}}lowercase ASCII letters in variable names (lowercase){p_end}
{p2col :{opt p:roper}}propercase ASCII letters in variable names (Propercase){p_end}

{p2col :{opt d:ryrun}}do not rename, but instead produce a report{p_end}
{p2col :{opt r}}store variable names in {cmd:r()} for programming use{p_end}
{p2line}
{p 8 8 2}
These options correspond to the third syntax.
One of {opt upper}, {opt lower}, or {opt proper} must be specified.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Data utilities > Rename groups of variables}


{marker description}{...}
{title:Description}

{pstd}
{cmd:rename} changes the names of existing variables to the new names specified.
See {bf:{help rename:[D] rename}} for the base {cmd:rename} syntax.
Documented here is the advanced syntax for renaming groups of variables.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D renamegroupQuickstart:Quick start}

        {mansection D renamegroupRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_rename}{...}
{title:Options for renaming variables}

{p 4 8 2}
{cmd:addnumber} and {cmd:addnumber(}{it:#}{cmd:)}
    specify to add a sequence number to the variable names.  See
    {help rename group##item18:item 18} of {it:Syntax}.
    If {it:#} is not specified, the sequence number begins with 1.

{p 4 8 2}
{cmd:renumber} and {cmd:renumber(}{it:#}{cmd:)}
    specify to replace existing numbers or text in a set of
    variable names with a sequence number.  See 
    {help rename group##item16:items 16 and 17} of {it:Syntax}.
    If {it:#} is not specified, the sequence number begins with 1.

{p 4 8 2}
{cmd:sort}
    specifies that the existing names be placed in order before the 
    renaming is performed.  See {help rename group##item15:item 15} 
    of {it:Syntax} for details. 
    This ordering matters only when {cmd:addnumber}
    or {cmd:renumber} is also specified or when specifying a list of 
    variable names for {it:old} or {it:new}.

{marker dryrun}{...}
{p 4 8 2}
{cmd:dryrun}
    specifies that the requested renaming not be performed but instead
    that a table be displayed showing the old and new variable names. 
    It is often a good idea to specify this option before actually 
    renaming the variables.

{p 4 8 2}
{cmd:r}
    is a programmer's option that requests that old and new variable names 
    be stored in {cmd:r()}.  This option may be specified with or without 
    {cmd:dryrun}.


{marker options_case}{...}
{title:Options for changing the case of groups of variable names}

{p 4 8 2}
{cmd:upper}, {cmd:lower}, and {cmd:proper}
    specify how the variables are to be renamed.
    {cmd:upper} specifies that ASCII letters in variable names be changed to
    uppercase; {cmd:lower}, to lowercase; and {cmd:proper}, to having the
    first ASCII letter capitalized and the remaining ASCII letters in
    lowercase.  One of these three options must be specified.  Note that these
    options do not handle Unicode characters beyond the 
    {help u_glossary##plainascii:plain ASCII} range.  To
    change Unicode characters in the variable names to uppercase, lowercase,
    or titlecase, use functions {helpb f_ustrupper:ustrupper()},
    {helpb f_ustrlower:ustrlower()}, and {helpb f_ustrtitle:ustrtitle()}.
    See the {help rename_group##technote:technical note} below.

{p 4 8 2}
{cmd:dryrun} and {cmd:r}
    are the same options as 
    documented directly {help rename group##dryrun:above}.


{marker technote}{...}
{title:Technical note}

{pstd}
You cannot directly use functions
{helpb f_ustrupper:ustrupper()},
{helpb f_ustrlower:ustrlower()}, and
{helpb f_ustrtitle:ustrtitle()}
in your {cmd:rename} command.  You must first create a local macro with the
new variable name and then use that macro in your {cmd:rename} command.  For
example,

{phang2}{cmd:. local new = ustrlower(Ubicación)}{p_end}
{phang2}{cmd:. rename Ubicación `new'}{p_end}

{pstd}
You can use multiple local macros in a varlist.  For example,

{phang2}{cmd:. local new1 = ustrlower(Ubicación1)}{p_end}
{phang2}{cmd:. local new2 = ustrlower(Ubicación2)}{p_end}
{phang2}{cmd:. rename (Ubicación1 Ubicación2) (`new1' `new2')}{p_end}

{pstd}
For more information about local macros, see {findalias frlocal}.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:rename} stores nothing in {cmd:r()} by default.  If the {cmd:r} option
is specified, then {cmd:rename} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(n)}}number of variables to be renamed{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(oldnames)}}original variable names{p_end}
{synopt:{cmd:r(newnames)}}new  variable names{p_end}
{p2colreset}{...}

{pstd}
Variables that are renamed to themselves are omitted from the recorded lists.
{p_end}
