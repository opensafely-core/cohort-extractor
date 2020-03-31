{smcl}
{* *! version 1.4.4  01may2019}{...}
{viewerdialog save "dialog save_dlg"}{...}
{viewerdialog "save with options" "dialog save_option"}{...}
{vieweralsosee "[D] save" "mansection D save"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] compress" "help compress"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{vieweralsosee "[P] File formats .dta" "help dta"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{vieweralsosee "[D] use" "help use"}{...}
{viewerjumpto "Syntax" "save##syntax"}{...}
{viewerjumpto "Menu" "save##menu"}{...}
{viewerjumpto "Description" "save##description"}{...}
{viewerjumpto "Links to PDF documentation" "save##linkspdf"}{...}
{viewerjumpto "Options for save" "save##options_save"}{...}
{viewerjumpto "Options for saveold" "save##options_saveold"}{...}
{viewerjumpto "Examples" "save##examples"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[D] save} {hline 2}}Save Stata dataset{p_end}
{p2col:}({mansection D save:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Save data in memory to file

{p 8 13 2}
{cmdab:sa:ve}
[{it:{help filename}}]
[{cmd:,}
{it:{help save##save_options:save_options}}]


{phang}
Save data in memory to file in Stata 13, 12, or 11 format

{p 8 16 2}
{cmd:saveold}
{it:{help filename}}
[{cmd:,}
{it:{help save##saveold_options:saveold_options}}]


{synoptset 17}{...}
{marker save_options}{...}
{synopthdr :save_options}
{synoptline}
{synopt :{opt nol:abel}}omit value labels from the saved dataset{p_end}
{synopt :{opt replace}}overwrite existing dataset{p_end}
{synopt :{opt all}}save {cmd:e(sample)} with the dataset; programmer's
option{p_end}
{synopt :{opt o:rphans}}save all value labels{p_end}
{synopt :{opt empty:ok}}save dataset even if zero observations and zero
variables{p_end}
{synoptline}

{synoptset 17}{...}
{marker saveold_options}{...}
{synopthdr :saveold_options}
{synoptline}
{synopt :{opt v:ersion(#)}}specify version 11<={it:#}<=15; default is {cmd:version(13)}, meaning Stata 13 format{p_end}
{synopt :{opt nol:abel}}omit value labels from the saved dataset{p_end}
{synopt :{opt replace}}overwrite existing dataset{p_end}
{synopt :{opt all}}save {cmd:e(sample)} with the dataset; programmer's
option{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Save as...}


{marker description}{...}
{title:Description}

{pstd}
{opt save} stores the dataset currently in memory on disk under the name
{it:{help filename}}.  If {it:filename} is not specified, the name under which
the data were last known to Stata ({cmd:c(filename)}) is used.  If
{it:filename} is specified without an extension, {cmd:.dta} is used.  If your
{it:filename} contains embedded spaces, remember to enclose it in double
quotes.

{pstd}
Stata 16, 15, and 14 have the same dataset format so long as the dataset
has 32,767 variables or less.  Stata/MP 16 and 15 support more than 32,767
variables and thus have a slightly different dataset format when there
are that many variables.  If you are using Stata 16 and want to save a
dataset so that it may be read by someone using Stata 15, simply use the
{cmd:save} command; Stata 15 will be able to read it.  If the dataset
has more than 32,767 variables, it can be read by Stata/MP 15.
If you want to save a dataset so that it may be read by someone using
Stata 14, again simply use the {cmd:save} command; Stata 14 will be able
to read it so long as it does not have more than 32,767 variables.
Stata 14 supports at most 32,767 variables.

{pstd}
{opt saveold} saves the dataset currently in memory on disk under the name
{it:filename} in previous {cmd:.dta} formats, namely, those for Stata 13, 12,
or 11.  If you are using Stata 16 and want to save a file so that it may be
read by someone using an older version of Stata, use the {cmd:saveold}
command.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D saveQuickstart:Quick start}

        {mansection D saveRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_save}{...}
{title:Options for save}

{phang}
{opt nolabel} omits value labels from the saved dataset.
The associations between variables and value-label names, however,
are saved along with the dataset label and the variable labels.

{phang}
{opt replace} permits {opt save} to overwrite an existing dataset.

{phang}
{opt all} is for use by programmers.  If specified, {cmd:e(sample)} will
be saved with the dataset.  You could run a regression; {cmd:save mydata, all};
{cmd:drop _all}; {cmd:use mydata}; and {cmd:predict yhat if e(sample)}.

{phang}
{opt orphans} saves all value labels, including those not attached to
any variable.

{phang}
{opt emptyok} is a programmer's option.  It specifies that the
dataset be saved, even if it contains zero observations and zero variables.
If {opt emptyok} is not specified and the dataset is empty, {opt save} responds
with the message "no variables defined".


{marker options_saveold}{...}
{title:Options for saveold}

{phang}
{opt version(#)} specifies which previous {cmd:.dta} file format is to be
used.  {it:#} may be {cmd:15}, {cmd:14}, {cmd:13}, {cmd:12}, or {cmd:11}.
The default is
{cmd:version(13)}, meaning Stata 13 format.  To save datasets in the modern,
Stata 16 format, use the {cmd:save} command, not {cmd:saveold}.  Stata 16
and Stata 14 and 15 share the same format, so you do not have to use
{cmd:saveold} to save a Stata 14 or 15 dataset; simply use {cmd:save}.

{phang}
{opt nolabel} omits value labels from the saved dataset.
The associations between variables and value-label names, however,
are saved along with the dataset label and the variable labels.

{phang}
{opt replace} permits {opt saveold} to overwrite an existing dataset.

{phang}
{opt all} is for use by programmers.  If specified, {cmd:e(sample)} will
be saved with the dataset.  You could run a regression; {cmd:save mydata, all};
{cmd:drop _all}; {cmd:use mydata}; and {cmd:predict yhat if e(sample)}.


{marker examples}{...}
{title:Examples}

    Setup
{phang2}{cmd:. input number odd even}{p_end}

               number        odd       even
          1. {cmd:1 1 2}
          2. {cmd:2 3 4}
          3. {cmd:3 5 6}
          4. {cmd:4 7 8}
          5. {cmd:end}

{pstd}Save data in memory to file{p_end}
{phang2}{cmd:. save myevenodd}{p_end}

    Add another observation
{phang2}{cmd:. input}{p_end}

               number        odd       even
          5. {cmd:5 9 10}
          6. {cmd:end}

{pstd}Resave {cmd:myevenodd} after additional observation has been added{p_end}
{phang2}{cmd:. save myevenodd, replace}{p_end}

{pstd}Equivalent to above command{p_end}
{phang2}{cmd:. save, replace}

{pstd}Save data under name {cmd:myevenodd2} in Stata 13 format{p_end}
{phang2}{cmd:. saveold myevenodd2}{p_end}

{pstd}Save data under name {cmd:myevenodd3} in Stata 12 format{p_end}
{phang2}{cmd:. saveold myevenodd3, version(12)}{p_end}
