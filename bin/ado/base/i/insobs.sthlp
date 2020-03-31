{smcl}
{* *! version 1.0.6  20sep2018}{...}
{viewerdialog insobs "dialog insobs"}{...}
{vieweralsosee "[D] insobs" "mansection D insobs"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] edit" "help edit"}{...}
{vieweralsosee "[D] obs" "help obs"}{...}
{viewerjumpto "Syntax" "insobs##syntax"}{...}
{viewerjumpto "Menu" "insobs##menu"}{...}
{viewerjumpto "Description" "insobs##description"}{...}
{viewerjumpto "Links to PDF documentation" "insobs##linkspdf"}{...}
{viewerjumpto "Options" "insobs##options"}{...}
{viewerjumpto "Examples" "insobs##examples"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] insobs} {hline 2}}Add or insert observations{p_end}
{p2col:}({mansection D insobs:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Add new observations at the end of the dataset

{p 8 17 2}
{cmd:insobs}
{it:obs}


{phang}
Insert new observations into the middle of the dataset

{p 8 17 2}
{cmd:insobs} {it:obs}{cmd:,} {opt b:efore(inspos)} | {opt a:fter(inspos)}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Add or insert observations}


{marker description}{...}
{title:Description}

{pstd}
{opt insobs} inserts new observations into the dataset.  The number of new  
observations to insert is specified by {it:obs}.  This command is primarily
used by the Data Editor and is of limited use in other contexts.  A more
popular alternative for programmers is {helpb set obs}.

{pstd}
If option {opt before(inspos)} or {opt after(inspos)} is specified,
the new observations are inserted into the middle of the dataset, and the
insert position is controlled by {it:inspos}.
Note that {it:inspos} must be a positive integer between 1 and the 
total number of observations {helpb _N}.  If the dataset is empty, 
{opt before()} and {opt after()} may not be specified.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D insobsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt before(inspos)} and {opt after(inspos)} inserts new observations before 
and after, respectively, {it:inspos} into the dataset.  These options are
primarily used by the Data Editor and are of limited use in other contexts.  A
more popular alternative for most users is {helpb order}.



{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. clear}

{pstd}Create a dataset containing 100 observations {p_end}
{phang2}{cmd:. insobs 100}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}

{pstd}Add 10 new observations to the end of the dataset{p_end}
{phang2}{cmd:. insobs 10}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}

{pstd}Insert 5 new observations before observation 20{p_end}
{phang2}{cmd:. insobs 5, before(20)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}

{pstd}Insert 3 new observations after observation 15{p_end}
{phang2}{cmd:. insobs 3, after(15)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}

{pstd}Insert 5 new observations before the last observation{p_end}
{phang2}{cmd:. insobs 5, before(_N)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}

{pstd}Insert 3 new observations after the last observation{p_end}
{phang2}{cmd:. insobs 3, after(_N)}{p_end}
    {hline}
