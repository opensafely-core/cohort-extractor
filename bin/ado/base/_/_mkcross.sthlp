{smcl}
{* *! version 1.0.6  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] egen" "help egen"}{...}
{viewerjumpto "Syntax" "_mkcross##syntax"}{...}
{viewerjumpto "Description" "_mkcross##description"}{...}
{viewerjumpto "Options" "_mkcross##options"}{...}
{viewerjumpto "Examples" "_mkcross##examples"}{...}
{title:Title}

{p2colset 5 21 23 2}{...}
{p2col:{hi:[D] _mkcross} {hline 2}}Cross variables with automatic short value labels{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:_mkcross} {varlist} {ifin}, {it:options}

{synoptset 20}
{synopthdr}
{synoptline}
{synopt:{opt gen:erate(newvar)}}required; name of the
value-labeled "crossed" variable identifying combinations of
{it:varlist}{p_end}
{synopt:{opt lab:elname(name)}}name of value label for {it:newvar};
default is {it:newvar}{p_end}
{synopt:{opt miss:ing}}treat missing values in crossing variables as ordinary values
{p_end}
{synopt:{opt key:word}}code missing values with keywords{p_end}
{synopt:{opt strok}}string variables are allowed{p_end}
{synopt:{opt cod:ing(matname)}}returns a coding matrix{p_end}
{synopt:{opt len:gth(#)}}truncate codes of crossing variables at length {it:#}{p_end}
{synopt:{cmdab:len:gth:(}{cmdab:m:inimal)}}generate minimal length unique codes for crossing
variables{p_end}
{synopt:{opt sep(str)}}separator between codes of crossing variables;
default {cmd:sep("_")}{p_end}
{synopt:{opt max:length(#)}}maximum crossed code length;
default is {cmd:maxlength(12)}{p_end}
{synopt:{opt start(#)}}starting index for group values{p_end}

{synopt:{cmdab:ed:it:(}{cmdab:s:pace:)}}drop spaces from coding strings{p_end}
{synopt:{cmdab:ed:it:(}{cmdab:f:irst:)}}derive codes from first word in coding string{p_end}
{synopt:{cmdab:ed:it:(}{cmdab:v:owel:)}}drop vowels and spaces from coding string{p_end}

{synopt:{cmdab:case(}{cmdab:l:ower)}}convert coding strings to lower case{p_end}
{synopt:{cmdab:case(}{cmdab:u:pper)}}convert coding strings to upper case{p_end}
{synopt:{cmdab:case(}{cmdab:f:irst)}}capitalize each word in coding strings{p_end}
{synoptline}
{synopt:{cmdab:rep:ort:(}{cmdab:v:ariables)}}display the coding for the nonnumeric crossing variables{p_end}
{synopt:{cmdab:rep:ort:(}{cmdab:c:rossed)}}display the codes (value labels) for the crossed variable{p_end}
{synopt:{cmdab:rep:ort:(}{cmdab:a:ll)}}display the coding of the crossing and crossed variables{p_end}

{synopt:{opt trun:cate(#)}}maximum length for descriptions in crossed variable report table{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_mkcross} creates one "crossed" variable taking on values 1, 2, ...
for the groups formed by a varlist of up to six "crossing" variables.
The order of the groups is that of the sort order of varlist, and is identical
to that produced by the {cmd:group()} function of {helpb egen}.

{pstd}
By default, the crossing variables are coded at equal length; the number of
characters for coding a variable depends on the number of crossing variables,
on {cmd:maxlength()}, and on the length of the separator string.  For
instance, with two variables, the default {cmd:maxlength(12)}, and the
default separator ("_"), each of the variables is coded at length 5, and
the value labels of the crossed variable are of length (at most) 11.
With three variables, each is coded at  length 3 etc.  A warning is displayed
if the coding strings are not unique. For instance, length 4 codes for
"Australia" and "Austria" are not unique.

{pstd}
{cmd:_mkcross()} allows extensive control of how value labels of the crossed
variable are defined from the codes (string values, value labels, numeric
values) of the crossing variables.


{marker options}{...}
{title:Options}

{phang}
{opt generate(newvar)} is not optional and specifies the name of the
value-labeled "crossed" variable identifying combinations of the {it:varlist}.

{phang}
{opt labelname(lname)} specifies the name to be given to the value label
created to hold the labels for {it:newvar}.  The default value label name
is {it:lname}.  {it:lname} should not exist as a value label.

{phang}
{opt missing} indicates that missing values in varlist (either {cmd:.},
{cmd: .a}, etc., for numeric variables or the empty string {cmd:""} for string
variables) are to be treated like any other value when assigning groups,
instead of as missing values being assigned to the group missing.

{phang}
{opt keyword} codes missing values by keywords: {cmd:.} by {cmd:dot},
{cmd:.a} by {cmd:dota}, {cmd:.b} by {cmd:dotb}, etc.

{phang}
{opt strok} specifies that crossing variables may be string variables.

{phang}
{opt coding(matname)} specifies that a ncat x nvar coding matrix is
returned in {it:matname}. Here ncat is the number of distinct values
in the crossed variable {it:newvar}, and nvar is the number of
crossing variables.  The rownames of {it:matname} are the coding
values 1, 2, ... unless the {cmd:start()} option is specified.  The 
{opt coding()} option is not allowed with string variables.

{phang}{opt length(#)}
truncates the codes of crossing variables at length {it:#}.  Numeric
non-value-labeled variables are encoded at equal length, padded with
zeros.

{phang2}{cmd:length(minimal)}
produces unique codes of minimal length.

{pmore2}
For value-labeled numeric and string variables, the coding uses the
left-most characters.  Examples:

{pmore3}"male", "female"  {hline 2}>  "m", "f"
{p_end}
{pmore3}"Netherlands", "Nigeria", "Norway"  {hline 2}>  "Ne", "Ni", "No"
{p_end}

{pmore2}
Minimal unique codes for numeric variables are determined right
to left.  Examples:

{pmore3}2000, 2001, 2002, 2004  {hline 2}>  0, 1, 2, 3
{p_end}
{pmore3}1999, 2000, 2001, 2002  {hline 2}>  9, 0, 1, 2
{p_end}

{phang}
{opt sep(str)} specifies a separator string {it:str} between the codes
for crossing variables.  The default is {cmd:sep("_")}.

{phang}
{opt maxlength(#)} specifies the maximal length for the value labels (codes)
in the crossed variable {it:newname}.  The default is {cmd:maxlength(12)}.

{phang}
{opt start(#)}
specifies the starting index for the group values.  The
default, {cmd:start(1)}, creates group values 1, 2, ....  {cmd:start(0)}
creates values 0, 1, 2, ....

{phang}
{opt edit(opt)} performs various code manipulations.  Editing occurs
{hi:before} extracting subcodes or determining minimal unique subcodes
(see option {cmd:length(minimal)}).

{phang2}
{cmd:edit(space)} drops all spaces from codes.

{phang2}
{cmd:edit(first}} selects the first word of codes.

{phang2}
{cmd:edit(vowel)} drops vowels and spaces from codes.

{phang}
{opt case(opt)} modifies the case of the codes of the crossing variables.
Case modification occurs {hi:before} extracting subcodes or determining
minimal unique subcodes (see option {cmd:length(minimal)}).

{phang2}
{cmd:case(lower)} converts codes to lowercase.

{phang2}
{cmd:case(upper)} converts codes to uppercase.

{phang2}
{cmd:case(first)} converts codes to lowercase except for the first
character of each word which is converted to uppercase.

{phang}
{opt report(opt)} displays a report of the construction of the
coding.

{phang2}
{cmd:report(variables)} displays a coding table for the crossing
variables in {it:varlist}.

{phang2}
{cmd:report(crossed)} displays a coding table (value labels) for the
crossed variable {it:newvar}.

{phang2}
{cmd:report(all)} displays the coding tables of the crossing and
crossed variables.

{phang}
{opt truncate(#)} truncates full descriptions in the report table
of crossed variables to {it:#} characters.  The default is
{cmd:truncate(24)}.  The maximum allowable is {cmd:truncate(32)}.
{cmd:truncate()} does not affect the value labels that are
actually formed, only how the codes are reported.


{marker examples}{...}
{title:Examples}

{p 4 8 2}
You have two value-labeled variables

        relig  1 none               party   1 democratic party
               2 protestant                 2 republican party
               3 catholic                   3 independent
               4 islam
               5 other

{pstd}
To form the crossed variable {cmd:relpa} with all combinations of the
two variables {cmd:party} and {cmd:relig},

{p 12 16 2}
{cmd:. _mkcross relig party, gen(relpa)}

{pstd}
{cmd:relpa} has 15 values (unless some combinations do not occur in the
data) with value labels of length up to 11 characters; for instance,
(relig=2, party=1) has group value 2, and value label "prote_democ".

{p 12 16 2}
{cmd:. _mkcross relig party, gen(relpa) length(3)}

{pstd}
produces the same grouping variable relpa, but shorter value labels. Now
(relig=2, party=1) has value label "pro_dem".  Minimal coding is,
here one character for both {cmd:relig} and {cmd:party}, and

{p 12 16 2}
{cmd:. _mkcross relig party, gen(relpa) length(min)}

{pstd}
generates a value label for (relig=2, party=1) that is just "p_d".  You
may have to get used to these value labels, but they are quite useful,
especially in plots with many value-labeled plotpoints.
{p_end}
