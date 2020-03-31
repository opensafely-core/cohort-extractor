{smcl}
{* *! version 1.2.0  13apr2018}{...}
{viewerdialog "Variables Manager" "stata varmanage"}{...}
{viewerdialog copy "dialog label_copy"}{...}
{viewerdialog data "dialog label_data"}{...}
{viewerdialog list "dialog label_list"}{...}
{viewerdialog save "dialog label_save"}{...}
{vieweralsosee "[D] label" "mansection D label"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] label language" "help label_language"}{...}
{vieweralsosee "[D] labelbook" "help labelbook"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] encode" "help encode"}{...}
{vieweralsosee "[D] varmanage" "help varmanage"}{...}
{viewerjumpto "Syntax" "label##syntax"}{...}
{viewerjumpto "Menu" "label##menu"}{...}
{viewerjumpto "Description" "label##description"}{...}
{viewerjumpto "Links to PDF documentation" "label##linkspdf"}{...}
{viewerjumpto "Options" "label##options"}{...}
{viewerjumpto "Technical note" "label##technote"}{...}
{viewerjumpto "Examples" "label##examples"}{...}
{viewerjumpto "Video examples" "label##video"}{...}
{viewerjumpto "Stored results" "label##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[D] label} {hline 2}}Manipulate labels{p_end}
{p2col:}({mansection D label:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}Label dataset

{p 8 15 2}
{opt la:bel} {opt da:ta} [{cmd:"}{it:label}{cmd:"}]


{phang}Label variable

{p 8 15 2}
{opt la:bel} {opt var:iable} {varname} [{cmd:"}{it:label}{cmd:"}]


{phang}Define value label

{p 8 15 2}
{opt la:bel} {opt de:fine} {it:lblname #}
{cmd:"}{it:label}{cmd:"} [{it:#} {cmd:"}{it:label}{cmd:"} {it:...}]
[{cmd:,} {opt a:dd} {opt modify} {opt replace} {opt nofix}]


{phang}Assign value label to variables

{p 8 15 2}
{opt la:bel} {opt val:ues} {varlist} {it:lblname} [{cmd:,} {cmd:nofix}]


{phang}Remove value labels

{p 8 15 2}
{opt la:bel} {opt val:ues} {varlist} [{cmd:.}]


{phang}List names of value labels

{p 8 15 2}
{opt la:bel} {opt di:r}


{phang}List names and contents of value labels

{p 8 15 2}
{opt la:bel} {opt l:ist} [{it:lblname} [{it:lblname ...}]]


{phang}Copy value label

{p 8 15 2}
{opt la:bel} {opt copy} {it:lblname} {it:lblname} [{cmd:,} {opt replace}]


{phang}Drop value labels

{p 8 15 2}
{opt la:bel} {opt drop} {c -(}{it:lblname} [{it:lblname ...}] | {cmd:_all}{c )-}


{phang}Save value labels in do-file

{p 8 15 2}
{opt la:bel} {opt save} [{it:lblname} [{it:lblname...}]]
{cmd:using} {it:{help filename}} [{cmd:,} {opt replace}]


{phang}Labels for variables and values in multiple languages

        {opt la:bel} {opt lang:uage} ... {right:(see {manhelp label_language D:label language})  }


{phang}
where {it:#} is an integer or an extended missing value 
({cmd:.a}, {cmd:.b}, ..., {cmd:.z}).


{marker menu}{...}
{title:Menu}

    {title:label data} 

{phang2}
{bf:Data > Data utilities > Label utilities > Label dataset}

    {title:label variable}

{phang2}
{bf:Data > Variables Manager}

    {title:label define}

{phang2}
{bf:Data > Variables Manager}

    {title:label values}

{phang2}
{bf:Data > Variables Manager}

    {title:label list}

{phang2}
{bf:Data > Data utilities > Label utilities > List value labels}

    {title:label copy}

{phang2}
{bf:Data > Data utilities > Label utilities > Copy value labels}

    {title:label drop}

{phang2}
{bf:Data > Variables Manager}

    {title:label save}

{phang2}
{bf:Data > Data utilities > Label utilities > Save value labels as do-file}


{marker description}{...}
{title:Description}

{pstd}
{cmd:label data} attaches a label (up to 80 characters) to the dataset in
memory.  Dataset labels are displayed when you {cmd:use} the dataset and when
you {cmd:describe} it.  If no label is specified, any existing label is
removed.

{pstd}
{cmd:label variable} attaches a label (up to 80 characters) to a variable.
If no label is specified, any existing variable label is removed.

{pstd}
{cmd:label define}  creates a value label named {it:lblname}, which is a set
of individual numeric values and their corresponding labels. {it:lblname} can
contain up to 65,536 individual labels; each individual label can be up to
32,000 characters long.

{pstd}
{cmd:label values} attaches a value label to {varlist}.  If {cmd:.} is
specified instead of {it:lblname}, any existing value label is detached from
that {it:varlist}.  The value label, however, is not deleted.  The syntax
{cmd:label values} {varname} (that is, nothing following the {it:varname})
acts the same as specifying the {cmd:.}.

{pstd}
{cmd:label dir} lists the names of value labels stored in memory.

{pstd}
{cmd:label list} lists the names and contents of value labels stored in
memory.

{pstd}
{cmd:label copy} makes a copy of an existing value label.

{pstd}
{cmd:label drop} eliminates value labels.

{pstd}
{cmd:label save} saves value label definitions in a do-file.  This is
particularly useful for value labels that are not attached to a variable
because these labels are not saved with the data.  By default, {cmd:.do} is
the filename extension used.

{pstd}
See {manhelp label_language D:label language} for information on the
{cmd:label language} command.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D labelQuickstart:Quick start}

        {mansection D labelRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt add} allows you to add {it:#} to {it:label} correspondences to
{it:lblname}.  If {cmd:add} is not specified, you may create only new
{it:lblname}s.  If {cmd:add} is specified, you may create new {it:lblname}s or
add new entries to existing {it:lblname}s.

{phang}
{opt modify} allows you to modify or delete existing {it:#} to {it:label}
correspondences and add new correspondences.  Specifying {opt modify} implies
{opt add}, even if you do not type the {opt add} option.

{phang}
{opt replace}, with {opt label define}, allows an existing value label to be
redefined.  
{opt replace}, with {opt label copy}, allows an existing value label to
be copied over. 
{opt replace}, with {opt label save}, allows {it:{help filename}} to be
replaced.

{phang}
{opt nofix} prevents display formats from being widened according to the
maximum length of the value label.  Consider 
{opt label values myvar mylab},  and say that {opt myvar} has a 
{opt %9.0g} display format right now.  Say that the maximum length of the
strings in {opt mylab} is 12 characters.  {opt label values} would change the
format of {opt myvar} from {opt %9.0g} to {opt %12.0g}.  {opt nofix} prevents
this.

{pmore}
{opt nofix} is also allowed with {opt label define}, but it is relevant only
when you are modifying an existing value label.  Without the {opt nofix}
option, {opt label define} finds all the variables that use this value label
and considers widening their display formats.  {opt nofix} prevents this.


{marker technote}{...}
{title:Technical note}

{pstd}
Although we tend to show examples defining value labels using one command,
such as

{phang2}{cmd:. label define answ 1 yes 2 no}

{pstd}
remember that value labels may include many associations and typing them
all on one line can be ungainly or impossible.  For instance, if perhaps we
have an encoding of 1,000 places, we could imagine typing

{phang2}{cmd:. label define fips 10060 "Anniston, AL" 10110 "Auburn, AL"}
	{cmd:10175 "Bessemer, AL"} {it:...} {cmd:560050 "Cheyenne, WY"}

{pstd}
Even in an editor, we would be unlikely to type the line correctly.

{pstd}
The easy way to enter long value labels is to enter the codings one at a
time:

{phang2}{cmd:. label define fips 10060 "Anniston, AL"}{p_end}
{phang2}{cmd:. label define fips 10175 "Bessemer, AL", add}{p_end}
	{it:...}
{phang2}{cmd:. label define fips 560050 "Cheyenne, WY", add}

{pstd}
And, of course, we could abbreviate:

{phang2}{cmd:. lab def fips 10060 "Anniston, AL"}{p_end}
{phang2}{cmd:. lab def fips 10175 "Bessemer, AL", add}

{pstd}
Up to 65,536 associations are allowed. 


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse hbp4}

{pstd}Describe the dataset{p_end}
{phang2}{cmd:. describe}

{pstd}Label the dataset{p_end}
{phang2}{cmd:. label data "fictional blood pressure data"}

{pstd}Describe the dataset{p_end}
{phang2}{cmd:. describe}

{pstd}Label the {cmd:hbp} variable{p_end}
{phang2}{cmd:. label variable hbp "high blood pressure"}

{pstd}Define the value label {cmd:yesno}{p_end}
{phang2}{cmd:. label define yesno 0 "no" 1 "yes"}

{pstd}List the names and contents of all value labels{p_end}
{phang2}{cmd:. label list}

{pstd}List the name and contents of only the value label {cmd:yesno}{p_end}
{phang2}{cmd:. label list yesno}

{pstd}List names of value labels{p_end}
{phang2}{cmd:. label dir}

{pstd}Make a copy of the value label {cmd:yesno}{p_end}
{phang2}{cmd:. label copy yesno yesnomaybe}{p_end}

{pstd}Add another value and label to the value label {cmd:yesnomaybe}{p_end}
{phang2}{cmd:. label define yesnomaybe 2 "maybe", add}

{pstd}List the name and contents of value label {cmd:yesnomaybe}{p_end}
{phang2}{cmd:. label list yesnomaybe}

{pstd}Modify the label for the value 2 in value label {cmd:yesnomaybe}{p_end}
{phang2}{cmd:. label define yesnomaybe 2 "don't know", modify}

{pstd}List the name and contents of value label {cmd:yesnomaybe}{p_end}
{phang2}{cmd:. label list yesnomaybe}

{pstd}List the first 4 observations in the dataset{p_end}
{phang2}{cmd:. list in 1/4}

{pstd}Attach the value label {cmd:yesnomaybe} to the variable {cmd:hbp}{p_end}
{phang2}{cmd:. label values hbp yesnomaybe}

{pstd}List the first 4 observations in the dataset{p_end}
{phang2}{cmd:. list in 1/4}

{pstd}Save the value label {cmd:sexlbl} to {cmd:mylabel.do}{p_end}
{phang2}{cmd:. label save sexlbl using mylabel}

{pstd}List the contents of the file {cmd:mlabel.do}{p_end}
{phang2}{cmd:. type mylabel.do}

{pstd}Drop the value label {cmd:sexlbl} from the dataset{p_end}
{phang2}{cmd:. label drop sexlbl}

{pstd}List the names of value labels{p_end}
{phang2}{cmd:. label dir}

{pstd}Run {cmd:mylabel.do} to retrieve the value label {cmd:sexlbl}{p_end}
{phang2}{cmd:. do mylabel}

{pstd}List the names of value labels{p_end}
{phang2}{cmd:. label dir}


{marker video}{...}
{title:Video examples}

{phang2}{browse "https://www.youtube.com/watch?v=l5QM2RzU3VM":How to label variables}

{phang2}{browse "https://www.youtube.com/watch?v=CiSIeQVWxW0":How to label the values of categorical variables}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:label list} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(k)}}number of mapped values, including missing{p_end}
{synopt:{cmd:r(min)}}minimum nonmissing value label{p_end}
{synopt:{cmd:r(max)}}maximum nonmissing value label{p_end}
{synopt:{cmd:r(hasemiss)}}{cmd:1} if extended missing values labeled, {cmd:0}
                 otherwise{p_end}
{p2colreset}{...}

{pstd}
{cmd:label dir} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(names)}}names of value labels{p_end}
{p2colreset}{...}
