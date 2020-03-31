{smcl}
{* *! version 1.3.13  19oct2017}{...}
{viewerdialog "Variables Manager" "stata varmanage"}{...}
{viewerdialog "list or search" "dialog notes_list"}{...}
{viewerdialog renumber "dialog notes_renumber"}{...}
{vieweralsosee "[D] notes" "mansection D notes"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] codebook" "help codebook"}{...}
{vieweralsosee "[D] describe" "help describe"}{...}
{vieweralsosee "[D] ds" "help ds"}{...}
{vieweralsosee "[P] notes_" "help notes_"}{...}
{vieweralsosee "[D] save" "help save"}{...}
{vieweralsosee "[D] varmanage" "help varmanage"}{...}
{viewerjumpto "Syntax" "notes##syntax"}{...}
{viewerjumpto "Menu" "notes##menu"}{...}
{viewerjumpto "Description" "notes##description"}{...}
{viewerjumpto "Links to PDF documentation" "notes##linkspdf"}{...}
{viewerjumpto "How notes are numbered" "notes##remarks"}{...}
{viewerjumpto "Examples" "notes##examples"}{...}
{viewerjumpto "Video example" "notes##video"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[D] notes} {hline 2}}Place notes in data{p_end}
{p2col:}({mansection D notes:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Attach notes to dataset

{p 8 15 2}
{opt note:s} [{it:{help varname:evarname}}]{cmd::} {it:text}


{phang}
List all notes

{p 8 15 2}
{opt note:s}


{phang}
List specific notes

{p 8 15 2}
{opt note:s} [{opt l:ist}] {it:{help varlist:evarlist}} [{cmd:in} {it:#}[{cmd:/}{it:#}]]


{phang}
Search for a text string across all notes in all variables and _dta

{p 8 15 2}
{opt note:s} {cmd:search} [{it:sometext}] 


{phang}
Replace a note

{p 8 15 2}
{opt note:s} {cmd:replace} {it:{help varname:evarname}} {cmd:in} {it:#} {cmd::} {it:text}


{phang}
Drop notes

{p 8 15 2}
{opt note:s} {cmd:drop} {it:{help varlist:evarlist}} [{cmd:in}
   {it:#}[{cmd:/}{it:#}]]


{phang}
Renumber notes

{p 8 15 2}
{opt note:s} {cmd:renumber} {it:{help varname:evarname}}


{phang}
where {it:evarname} is {cmd:_dta} or a varname, {it:evarlist} is a
varlist that may contain {cmd:_dta}, and {it:#} is a number
or the letter {cmd:l}.

{phang}
If {it:text} includes the letters {cmd:TS} surrounded by blanks, the {cmd:TS}
is removed, and a time stamp is substituted in its place.


{marker menu}{...}
{title:Menu}

    {title:notes (add)}

{phang2}
{bf:Data > Variables Manager}

    {title:notes list and notes search}

{phang2}
{bf:Data > Data utilities > Notes utilities > List or search notes}

    {title:notes replace}

{phang2}
{bf:Data > Variables Manager}

    {title:notes drop}

{phang2}
{bf:Data > Variables Manager}

    {title:notes renumber}

{phang2}
{bf:Data > Data utilities > Notes utilities > Renumber notes}


{marker description}{...}
{title:Description}

{pstd}
{cmd:notes} attaches notes to the dataset in memory.  These notes become a
part of the dataset and are saved when the dataset is saved and retrieved when
the dataset is used; see {manhelp save D} and {manhelp use D}.  {cmd:notes} can
be attached generically to the dataset or specifically to a variable within
the dataset.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D notesQuickstart:Quick start}

        {mansection D notesRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:How notes are numbered}

{p 4 4 2}
Notes are numbered sequentially, with the first note being 1.  
Say variable {cmd:myvar} has four notes numbered 1, 2, 3, and 4.  If you
type {cmd:notes} {cmd:drop} {cmd:myvar} {cmd:in} {cmd:3}, the remaining notes
will be numbered 1, 2, and 4.  If you now add another note, it will be
numbered 5.  That is, notes are not renumbered and new notes are added
immediately after the highest numbered note.  Thus, if you now dropped notes 4
and 5, the next note added would be 3.

{p 4 4 2}
You can renumber notes by using {cmd:notes} {cmd:renumber}.  Going back to when
{cmd:myvar} had notes numbered 1, 2, and 4 after dropping note 3, if you
typed {cmd:notes} {cmd:renumber} {cmd:myvar}, the notes would be renumbered 1,
2, and 3.  If you added a new note after that, it would be numbered 4.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse auto4}

    Add a note to dataset
{phang2}{cmd:. note:  Send copy to Bob once verified.}{p_end}

{pstd}List all notes{p_end}
{phang2}{cmd:. notes}{p_end}
{phang2}_dta:{p_end}
          1.  Send copy to Bob once verified.

{pstd}Add second note to dataset{p_end}
{phang2}{cmd:. note:  Mary wants a copy, too.}{p_end}

{pstd}List all notes{p_end}
{phang2}{cmd:. notes}{p_end}
{phang2}_dta:{p_end}
          1.  Send copy to Bob once verified.
          2.  Mary wants a copy, too.

{pstd}Add third note to dataset and include a time stamp{p_end}
{phang2}{cmd:. note:  TS merged updates from JJ&F}{p_end}

{pstd}List all notes{p_end}
{phang2}{cmd:. notes}{p_end}
{phang2}_dta:{p_end}
          1.  Send copy to Bob once verified.
          2.  Mary wants a copy, too.
          3.  19 Apr 2007 15:38 merged updates from JJ&F

{pstd}Add two notes to {cmd:mpg} variable{p_end}
{phang2}{cmd:. note mpg: is the 41 a mistake?  Ask Bob.}{p_end}
{phang2}{cmd:. note mpg: what about the two missing values?}{p_end}

{pstd}Search for {cmd: Bob} across notes in all variables and _dta{p_end}
{phang2}{cmd:. notes search Bob}{p_end}
{phang2}_dta:{p_end}
          1.  Send copy to Bob once verified.
{phang2}mpg:{p_end}
          1.  is the 41 a mistake?  Ask Bob.

{pstd}List all notes{p_end}
{phang2}{cmd:. notes}{p_end}
{phang2}_dta:{p_end}
          1.  Send copy to Bob once verified.
          2.  Mary wants a copy, too.
          3.  19 Apr 2007 15:38 merged updates from JJ&F
{phang2}mpg:{p_end}
          1.  is the 41 a mistake?  Ask Bob.
          2.  what about the two missing values?

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}

{pstd}Add note to dataset containing a SMCL directive{p_end}
{phang2}{cmd:. note: check reason for missing values in {c -(}cmd:rep78{c )-}}

{pstd}List all notes{p_end}
{phang2}{cmd:. notes}{p_end}
{phang2}_dta:{p_end}
          1.  from Consumer Reports with permission
          2.  check reason for missing values in {cmd:rep78}
    {hline}


{marker video}{...}
{title:Video example}

{phang2}{browse "https://www.youtube.com/watch?v=wMDHD7REHr4":How to add notes to a variable}
{p_end}
