{smcl}
{* *! version 1.1.12  19oct2017}{...}
{viewerdialog labelbook "dialog labelbook"}{...}
{viewerdialog numlabel "dialog numlabel"}{...}
{viewerdialog uselabel "dialog uselabel"}{...}
{vieweralsosee "[D] labelbook" "mansection D labelbook"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] codebook" "help codebook"}{...}
{vieweralsosee "[D] describe" "help describe"}{...}
{vieweralsosee "[D] ds" "help ds"}{...}
{vieweralsosee "[D] encode" "help encode"}{...}
{vieweralsosee "[D] label" "help label"}{...}
{vieweralsosee "[M-3] matalabel" "help matalabel"}{...}
{viewerjumpto "Syntax" "labelbook##syntax"}{...}
{viewerjumpto "Menu" "labelbook##menu"}{...}
{viewerjumpto "Description" "labelbook##description"}{...}
{viewerjumpto "Links to PDF documentation" "labelbook##linkspdf"}{...}
{viewerjumpto "Options for labelbook" "labelbook##options_labelbook"}{...}
{viewerjumpto "Options for numlabel" "labelbook##options_numlabel"}{...}
{viewerjumpto "Options for uselabel" "labelbook##options_uselabel"}{...}
{viewerjumpto "Examples" "labelbook##examples"}{...}
{viewerjumpto "Stored results" "labelbook##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[D] labelbook} {hline 2}}Label utilities{p_end}
{p2col:}({mansection D labelbook:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}Produce a codebook describing value labels

{p 8 19 2}{cmd:labelbook} [{it:lblname-list}]
[{cmd:,} {it:labelbook_options}]


{phang}Prefix numeric values to value labels

{p 8 18 2}{cmd:numlabel} [{it:lblname-list}]{cmd:,}
{{opt a:dd}|{opt r:emove}} [{it:numlabel_options}]


{phang}Make dataset containing value-label information

{p 8 18 2}{cmd:uselabel} [{it:lblname-list}] 
[{cmd:using} {it:{help filename}}] [{cmd:,} {cmd:clear} {opt v:ar}]


{synoptset 19}{...}
{marker labelbook_options}{...}
{synopthdr :labelbook_options}
{synoptline}
{synopt :{opt a:lpha}}alphabetize label mappings{p_end}
{synopt :{opt le:ngth(#)}}check if value labels are unique to length {it:#};
default is {cmd:length(12)}{p_end}
{synopt :{opt li:st(#)}}list maximum of {it:#} mappings; default is
{cmd:list(32000)}{p_end}
{synopt :{opt p:roblems}}describe potential problems in a summary report{p_end}
{synopt :{opt d:etail}}do not suppress detailed report on variables or value
labels {p_end}
{synoptline}
{p2colreset}{...}

{synoptset 19}{...}
{marker numlabel_options}{...}
{synopthdr :numlabel_options}
{synoptline}
{p2coldent:*{opt a:dd}}prefix numeric values to value labels{p_end}
{p2coldent:*{opt r:emove}}remove numeric values from value labels{p_end}
{synopt :{opt m:ask(str)}}mask for formatting numeric labels; default mask is
"{it:#}{cmd:.}"{p_end}
{synopt :{opt force}}force adding or removing of numeric labels{p_end}
{synopt :{opt d:etail}}provide details about value labels, where some labels
are prefixed with numbers and others are not{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* Either {cmd:add} or {cmd:remove} must be specified.


{marker menu}{...}
{title:Menu}

    {title:labelbook}

{phang2}
{bf:Data > Data utilities > Label utilities > Produce codebook of value labels}

    {title:numlabel}

{phang2}
{bf:Data > Data utilities > Label utilities > Prepend values to value labels}

    {title:uselabel}

{phang2}
{bf:Data > Data utilities > Label utilities > Create dataset from value labels}


{marker description}{...}
{title:Description}

{pstd}
{cmd:labelbook} displays information for the value labels specified or, if
no labels are specified, all the labels in the data. 

{pstd}
For multilingual datasets (see {manhelp label_language D:label language}),
{cmd:labelbook} lists the variables to which value labels are attached in all
defined languages.

{pstd}
{cmd:numlabel} prefixes numeric values to value labels.  For example, a value
mapping of {cmd:2} -> "{cmd:catholic}" will be changed to {cmd:2} ->
"{cmd:2. catholic}".  See option {helpb labelbook##mask():mask()} for the
different formats.  Stata commands that display the value labels also show the
associated numeric values.  Prefixes are removed with the {opt remove} option.

{pstd}
{cmd:uselabel} is a programmer's command that reads
the value-label information from the currently loaded dataset or from
an optionally specified filename.

{pstd}
{cmd:uselabel} creates a dataset in memory that contains only that value-label
information.  The new dataset has four variables named {opt label},
{opt lname}, {opt value}, and {opt trunc}; is sorted by {opt lname value};
and has 1 observation per mapping.  Value labels can be longer than
the maximum string length in Stata; see {help limits}.  The new variable
{opt trunc} contains {cmd:1} if the value label is truncated to
fit in a string variable in the dataset created by {cmd:uselabel}.

{pstd}
{cmd:uselabel} complements {cmd:label, save}, which
produces a text file of the value labels in a format that allows
easy editing of the value-label texts.

{pstd}
Specifying no list or {opt _all} is equivalent to specifying all value labels.
Value-label names may not be abbreviated or specified with wildcards.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D labelbookQuickstart:Quick start}

        {mansection D labelbookRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_labelbook}{...}
{title:Options for labelbook}

{phang}
{opt alpha} specifies that the list of value-label mappings be sorted 
alphabetically on label.  The default is to sort the list on value.

{phang}
{opt length(#)} specifies the minimum length that {cmd:labelbook} checks
to determine whether shortened value labels are still unique.  It defaults to 
{opt 12}, the width used by most Stata commands.  {cmd:labelbook} also reports
whether value labels are unique at their full length.

{phang}
{opt list(#)} specifies the maximum number of value-label mappings to be
listed.  If a value label defines more mappings, a random subset of {it:#}
mappings is displayed.  By default, {cmd:labelbook} displays all mappings.
{cmd:list(0)} suppresses the listing of the value-label definitions.

{phang}
{cmd:problems} specifies that a summary report be produced describing
potential problems that were diagnosed:

{p 8 11 2}
1. Value label has gaps in mapped values (for example, values 0 and 2 are
labeled, while 1 is not){p_end}
{p 8 11 2}
2. Value label strings contain leading or trailing blanks{p_end}
{p 8 11 2}
3. Value label contains duplicate labels, that is, there are different values 
that map into the same string.  {p_end}
{p 8 11 2}
4. Value label contains duplicate labels at length 12{p_end}
{p 8 11 2}
5. Value label contains numeric -> numeric mappings{p_end}
{p 8 11 2}
6. Value label contains numeric -> null string mappings{p_end}
{p 8 11 2}
7. Value label is not used by variables{p_end}
 
{p 8 8 2}
See {help labelbook_problems} for a discussion of these problems and
advice on overcoming them.

{phang}
{opt detail} may be specified only with {opt problems}. It specifies
that the detailed report on the variables or value labels not be suppressed.


{marker options_numlabel}{...}
{title:Options for numlabel}

{phang}
{opt add} specifies that numeric values be prefixed to value labels.  Value
labels that are already {opt numlabeled} (using the same mask) are not
modified.

{phang}
{opt remove} specifies that numeric values be removed from the value labels.
If you added numeric values by using a nondefault mask, you must specify the
same mask to remove them.  Value labels that are not {opt numlabeled} or are
{opt numlabeled} using a different mask are not modified.

{marker mask()}{...}
{phang}
{opt mask(str)} specifies a mask for formatting the numeric labels.  In the
mask, {it:#} is replaced by the numeric label.  The default mask is "{it:#.} "
so that numeric value {opt 3} is shown as "{opt 3.} ".  Spaces are
relevant.  For the mask "[{it:#}]", numeric value {opt 3} would be shown as 
"[{opt 3}]".

{phang}
{opt force} specifies that adding or removing numeric labels be performed,
even if some value labels are {opt numlabeled} using the mask and others are
not.  Here only labels that are not {opt numlabeled} will be
modified.

{phang}
{opt detail} specifies that details be provided about the value labels that
are sometimes, but not always, {opt numlabeled} using the mask.


{marker options_uselabel}{...}
{title:Options for uselabel}

{phang}
{opt clear} permits the dataset to be created, even if the dataset already in
memory has changed since it was last saved.

{phang}
{opt var} specifies that the varlists using value label {it:vl} be returned in
{opt r(vl)}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. label define repair 1 "very poor" 2 "poor " 4 "good"}
              {cmd:5 "very good"}

{pstd}Display information for all value labels{p_end}
{phang2}{cmd:. labelbook}

{pstd}Display information for value label {cmd:origin}{p_end}
{phang2}{cmd:. labelbook origin}

{pstd}Produce summary report showing problems with value label
{cmd:origin}{p_end}
{phang2}{cmd:. labelbook origin, problems}

{pstd}Produce summary report showing problems with value label
{cmd:repair}{p_end}
{phang2}{cmd:. labelbook repair, problems}

{pstd}Assign value label {cmd:repair} to variable {cmd:rep78}{p_end}
{phang2}{cmd:. label values rep78 repair}

{pstd}Produce codebook for {cmd:rep78}{p_end}
{phang2}{cmd:. codebook rep78}

{pstd}Modify the {cmd:repair} value label by removing the trailing space after
"poor" and defining the label for "3"{p_end}
{phang2}{cmd:. label define repair 2 "poor" 3 "average", modify}

{pstd}Produce summary report showing problems with value label
{cmd:repair}{p_end}
{phang2}{cmd:. labelbook repair, problems}

{pstd}Report table of frequencies for {cmd:rep78}{p_end}
{phang2}{cmd:. tabulate rep78}

{pstd}Prefix numeric values to value labels{p_end}
{phang2}{cmd:. numlabel, add}

{pstd}Report table of frequencies for {cmd:rep78}{p_end}
{phang2}{cmd:. tabulate rep78}

{pstd}Remove the prefixed numeric value labels from the {cmd:repair} value
label{p_end}
{phang2}{cmd:. numlabel repair, remove}

{pstd}Report table of frequencies for {cmd:rep78}{p_end}
{phang2}{cmd:. tabulate rep78}

{pstd}Prefix numeric values to {cmd:repair} value label using the specified
mask{p_end}
{phang2}{cmd:. numlabel repair, add mask([#])}

{pstd}Report table of frequencies for {cmd:rep78}{p_end}
{phang2}{cmd:. tabulate rep78}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}Create a dataset containing the labels and values for value
labels{p_end}
{phang2}{cmd:. uselabel}

{pstd}Describe the data{p_end}
{phang2}{cmd:. describe}

{pstd}List the data{p_end}
{phang2}{cmd:. list}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:labelbook} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(names)}}{it:lblname-list}{p_end}
{synopt:{cmd:r(gaps)}}gaps in mapped values{p_end}
{synopt:{cmd:r(blanks)}}leading or trailing blanks{p_end}
{synopt:{cmd:r(null)}}name of value label containing null strings{p_end}
{synopt:{cmd:r(nuniq)}}duplicate labels{p_end}
{synopt:{cmd:r(nuniq_sh)}}duplicate labels at length 12{p_end}
{synopt:{cmd:r(ntruniq)}}duplicate labels at maximum string length{p_end}
{synopt:{cmd:r(notused)}}not used by any of the variables{p_end}
{synopt:{cmd:r(numeric)}}name of value label containing mappings to numbers{p_end}
{p2colreset}{...}

{pstd}
{cmd:uselabel} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(}{it:lblname}{cmd:)}}list of variables that use value label
{it:lblname} (only when {cmd:var} option is specified){p_end}
{p2colreset}{...}
