{smcl}
{* *! version 1.1.12  19oct2017}{...}
{viewerdialog codebook "dialog codebook"}{...}
{vieweralsosee "[D] codebook" "mansection D codebook"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "codebook problems" "help codebook problems"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] describe" "help describe"}{...}
{vieweralsosee "[D] ds" "help ds"}{...}
{vieweralsosee "[D] inspect" "help inspect"}{...}
{vieweralsosee "[D] labelbook" "help labelbook"}{...}
{vieweralsosee "[D] notes" "help notes"}{...}
{vieweralsosee "[D] split" "help split"}{...}
{viewerjumpto "Syntax" "codebook##syntax"}{...}
{viewerjumpto "Menu" "codebook##menu"}{...}
{viewerjumpto "Description" "codebook##description"}{...}
{viewerjumpto "Links to PDF documentation" "codebook##linkspdf"}{...}
{viewerjumpto "Options" "codebook##options"}{...}
{viewerjumpto "Examples" "codebook##examples"}{...}
{viewerjumpto "Stored results" "codebook##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[D] codebook} {hline 2}}Describe data contents{p_end}
{p2col:}({mansection D codebook:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:codebook}
[{varlist}]
{ifin}
[{cmd:,} {it:options}]

{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Options}
{synopt :{opt a:ll}}print complete report without missing values{p_end}
{synopt :{opt h:eader}}print dataset name and last saved date{p_end}
{synopt :{opt n:otes}}print any notes attached to variables{p_end}
{synopt :{opt m:v}}report pattern of missing values{p_end}
{synopt :{opt t:abulate(#)}}set tables/summary statistics threshold; default
is {cmd:tabulate(9)}{p_end}
{synopt :{opt p:roblems}}report potential problems in dataset{p_end}
{synopt :{opt d:etail}}display detailed report on the variables; only with
{opt problems}{p_end}
{synopt :{opt c:ompact}}display compact report on the variables{p_end}
{synopt :{opt dots}}display a dot for each variable processed; only with 
{opt compact}{p_end}

{syntab :Languages}
{synopt :{opt lang:uages}[{cmd:(}{it:namelist}{cmd:)}]}use with multilingual
datasets; see {manhelp label_language D: label language} for details{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Describe data > Describe data contents (codebook)}


{marker description}{...}
{title:Description}

{pstd}
{opt codebook} examines the variable names, labels, and data to produce a
codebook describing the dataset.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D codebookQuickstart:Quick start}

        {mansection D codebookRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Options}

{phang}
{opt all}
is equivalent to specifying the {opt header} and {opt notes} options.  It
provides a complete report, which excludes only performing {opt mv}.

{phang}
{opt header}
adds to the top of the output a header that lists the dataset name,
the date that the dataset was last saved, etc.

{phang}
{opt notes}
lists any notes attached to the variables; see {manhelp notes D}.

{phang}
{opt mv}
specifies that {opt codebook} search the data to determine the pattern of
missing values.  This is a CPU-intensive task.

{phang}
{opt tabulate(#)}
specifies the number of unique values of the variables to use to determine
whether a variable is categorical or continuous.  Missing values are not
included in this count.  The default is 9; when there are more than nine unique
values, the variable is classified as continuous.  Extended missing values
will be included in the tabulation.

{phang}
{opt problems}
specifies that a summary report is produced describing potential problems
that have been diagnosed:

{phang2}- Variables that are labeled with an undefined value label{p_end}
{phang2}- Incompletely value-labeled variables{p_end}
{phang2}- Variables that are constant, including always missing{p_end}
{phang2}- Leading, trailing, and embedded spaces in string variables{p_end}
{phang2}- Embedded binary 0 (\0) in string variables{p_end}
{phang2}- Noninteger-valued date variables{p_end}

{pmore}
See {help codebook problems} for a discussion of these problems and advice on
overcoming them.

{phang}
{opt detail}
may be specified only with the {opt problems} option.
It specifies that the detailed report on the variables not be suppressed.

{phang}
{opt compact}
specifies that a compact report on the variables be displayed.
{opt compact} may not be specified with any options other than {opt dots}.

{phang}
{opt dots}
specifies that a dot be displayed for every variable processed.  {opt dots} may
be specified only with {opt compact}.

{dlgtab:Languages}

{phang}
{cmd:languages}[{cmd:(}{it:namelist}{cmd:)}]
is for use with multilingual datasets; see
{manhelp label_language D:label language}.  It
indicates that the codebook pertains to the languages in {it:namelist}
or to all defined languages if no such list is specified as an argument to
{opt languages()}.  The output of {opt codebook} lists the data label and
variable labels in these languages and which value labels are attached to
variables in these languages.

{pmore}
Problems are diagnosed in all of these languages, as well.  The problem report
does not provide details in which language problems occur.  We advise you to
rerun {opt codebook} for problematic variables; specify {opt detail} to
produce the problem report again.

{pmore}
If you have a multilingual dataset but do not specify {opt languages()},
all output, including the problem report, is shown in the "active" language.


{marker examples}{...}
{title:Examples}

{pstd}With standard (monolingual) datasets,{p_end}

        {hline}
{pmore}Setup{p_end}
{phang3}{cmd:. sysuse auto}{p_end}
{phang3}{cmd:. note rep78: "investigate missing values"}{p_end}
{phang3}{cmd:. label values rep78 repairlbl}

{pmore}Display codebook for all variables in dataset{p_end}
{phang3}{cmd:. codebook}{p_end}

{pmore}Same as above command{p_end}
{phang3}{cmd:. codebook _all}{p_end}

{pmore}Same as above command, but print dataset name, date last saved, dataset
label, number of variables and of observations, and dataset size{p_end}
{phang3}{cmd:. codebook, header}{p_end}

{pmore}Display codebook for {cmd:rep78} variable{p_end}
{phang3}{cmd:. codebook rep78}{p_end}

{pmore}Display codebook for {cmd:rep78} variable, including notes attached to
{cmd:rep78}{p_end}
{phang3}{cmd:. codebook rep78, notes}{p_end}

{pmore}Report potential problems with dataset{p_end}
{phang3}{cmd:. codebook, problems}{p_end}

{pmore}Display compact report for all variables in dataset{p_end}
{phang3}{cmd:. codebook, compact}{p_end}

        {hline}
{pmore}Setup{p_end}
{phang3}{cmd:. webuse citytemp}

{pmore}Display codebook for {cmd:cooldd}, {cmd:heatdd}, {cmd:tempjan}, and
{cmd:tempjuly}, and report pattern of missing values{p_end}
{phang3}{cmd:. codebook cooldd heatdd tempjan tempjuly, mv}{p_end}
        {hline}


{pstd}
With multilingual datasets, with languages {opt en}
and {opt es}, and with active language {opt en},{p_end}

{pmore}Setup{p_end}
{phang3}{cmd:. webuse autom}

{pmore}Display codebook for {cmd:foreign} in language {cmd:en}{p_end}
{phang3}{cmd:. codebook foreign}

{pmore}Display codebook for {cmd:foreign} in language {cmd:es}{p_end}
{phang3}{cmd:. codebook foreign, language(es)}

{pmore}Display codebook for {cmd:foreign} in both {cmd:en} and {cmd:es}{p_end}
{phang3}{cmd:. codebook foreign, languages}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:codebook} stores the following lists of variables with
potential problems in {cmd:r()}:

{synoptset 24 tabbed}{...}
{p2col 5 24 28 2: Macros}{p_end}
{synopt:{cmd:r(cons)}}constant (or missing){p_end}
{synopt:{cmd:r(labelnotfound)}}undefined value labeled{p_end}
{synopt:{cmd:r(notlabeled)}}value labeled but with unlabeled categories{p_end}
{synopt:{cmd:r(str_type)}}compressible{p_end}
{synopt:{cmd:r(str_leading)}}leading blanks{p_end}
{synopt:{cmd:r(str_trailing)}}trailing blanks{p_end}
{synopt:{cmd:r(str_embedded)}}embedded blanks{p_end}
{synopt:{cmd:r(str_embedded0)}}embedded binary 0 (\0){p_end}
{synopt:{cmd:r(realdate)}}noninteger dates{p_end}
{p2colreset}{...}
