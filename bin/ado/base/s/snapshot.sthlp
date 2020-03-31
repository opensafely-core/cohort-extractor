{smcl}
{* *! version 1.0.6  19oct2017}{...}
{viewerdialog "Data Editor (Edit)" "stata edit"}{...}
{vieweralsosee "[D] snapshot" "mansection D snapshot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] edit" "help edit"}{...}
{vieweralsosee "[P] preserve" "help preserve"}{...}
{viewerjumpto "Syntax" "snapshot##syntax"}{...}
{viewerjumpto "Menu" "snapshot##menu"}{...}
{viewerjumpto "Description" "snapshot##description"}{...}
{viewerjumpto "Links to PDF documentation" "snapshot##linkspdf"}{...}
{viewerjumpto "Option" "snapshot##option"}{...}
{viewerjumpto "Examples" "snapshot##examples"}{...}
{viewerjumpto "Stored results" "snapshot##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[D] snapshot} {hline 2}}Save and restore data snapshots{p_end}
{p2col:}({mansection D snapshot:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}Save snapshot

{p 8 15 2}
{cmd:snapshot} {cmd:save}
[{cmd:,} {opt label("label")}]


{phang}Change snapshot label

{p 8 15 2}
{cmd:snapshot} {cmd:label} {it:snapshot#} {cmd:"}{it:label}{cmd:"}


{phang}Restore snapshot

{p 8 15 2}
{cmd:snapshot} {cmd:restore} {it:snapshot#}


{phang}List snapshots

{p 8 15 2}
{cmd:snapshot} {cmd:list} [{cmd:_all} | {it:{help numlist}}]


{phang}Erase snapshots

{p 8 15 2}
{cmd:snapshot} {cmd:erase} {cmd:_all} | {it:{help numlist}}


{marker menu}{...}
{title:Menu}

{phang2}
{bf:Data > Data Editor > Data Editor (Edit)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:snapshot} saves to disk and restores from disk copies of the data in
memory.  {cmd:snapshot}'s main purpose is to allow the {help edit:Data Editor}
to save and restore data snapshots during an interactive editing session.  A
more popular alternative for programmers is {helpb preserve}.

{pstd}
Snapshots are referred to by a {it:snapshot#}.  If no snapshots currently
exist, the next snapshot saved will receive a {it:snapshot#} of 1.
If snapshots do exist, the next snapshot saved will receive a {it:snapshot#}
one greater than the highest existing {it:snapshot#}.

{pstd}
{cmd:snapshot save} creates a temporary file containing a copy of
the data currently in memory and attaches an optional label (up to
80 characters) to the saved snapshot.  Up to 1,000 snapshots may be saved.

{pstd}
{cmd:snapshot label} changes the label on the specified snapshot.

{pstd}
{cmd:snapshot restore} replaces the data in memory with the data from
the specified snapshot.

{pstd}
{cmd:snapshot list} lists specified snapshots.

{pstd}
{cmd:snapshot erase} erases specified snapshots.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D snapshotQuickstart:Quick start}

        {mansection D snapshotRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt label("label")} is for use with {cmd:snapshot save} and allows you
to label a snapshot when saving it.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse auto}

{pstd}Describe the dataset{p_end}
{phang2}{cmd:. describe}

{pstd}Save a snapshot of the dataset{p_end}
{phang2}{cmd:. snapshot save, label("before changes")}

{pstd}Change the dataset{p_end}
{phang2}{cmd:. generate gpm = 1/mpg}{p_end}
{phang2}{cmd:. label variable gpm "gallons per mile"}{p_end}

{pstd}Save a snapshot of the changed dataset{p_end}
{phang2}{cmd:. snapshot save, label("after changes")}

{pstd}Make an unwanted change to the dataset{p_end}
{phang2}{cmd:. drop gpm}{p_end}

{pstd}List available snapshots{p_end}
{phang2}{cmd:. snapshot list}

{pstd}Restore a snapshot{p_end}
{phang2}{cmd:. snapshot restore 2}

{pstd}Describe the dataset{p_end}
{phang2}{cmd:. describe}

{pstd}Relabel a snapshot and erase an unneeded snapshot{p_end}
{phang2}{cmd:. snapshot label 2 "good changes"}{p_end}
{phang2}{cmd:. snapshot erase 1}

{pstd}List available snapshots{p_end}
{phang2}{cmd:. snapshot list}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:snapshot save} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(snapshot)}}sequence number of snapshot saved{p_end}
{p2colreset}{...}
