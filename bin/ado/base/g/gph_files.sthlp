{smcl}
{* *! version 1.3.1  15may2018}{...}
{vieweralsosee "[G-4] Concept: gph files" "mansection G-4 Conceptgphfiles"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph display" "help graph_display"}{...}
{vieweralsosee "[G-2] graph save" "help graph_save"}{...}
{vieweralsosee "[G-3] saving_option" "help saving_option"}{...}
{vieweralsosee "[P] serset" "help serset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph manipulation" "help graph_manipulation"}{...}
{viewerjumpto "Description" "gph_files##description"}{...}
{viewerjumpto "Links to PDF documentation" "gph_files##linkspdf"}{...}
{viewerjumpto "Remarks" "gph_files##remarks"}{...}
{p2colset 1 29 31 2}{...}
{p2col :{bf:[G-4] Concept: gph files} {hline 2}}Using gph files{p_end}
{p2col:}({mansection G-4 Conceptgphfiles:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:.gph} files contain Stata graphs and, in fact, even include the
original data from which the graph was drawn.  Below we discuss how
to replay graph files and to obtain the data inside them.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 ConceptgphfilesRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help gph_files##remarks1:Background}
	{help gph_files##remarks2:Gph files are machine/operating system independent}
	{help gph_files##remarks3:Gph files come in three forms}
	{help gph_files##remarks4:Advantages of live-format files}
	{help gph_files##remarks5:Advantages of as-is format files}
	{help gph_files##remarks6:Retrieving data from live-format files}


{marker remarks1}{...}
{title:Background}

{pstd}
{cmd:.gph} files are created either by including
the {cmd:saving()} option when you draw a graph,

	{cmd:. graph} ...{cmd:,} ... {cmd:saving(myfile)}

{pstd}
or by using the {cmd:graph} {cmd:save} command afterward:

	{cmd:. graph} ...
	{cmd:. graph save myfile}

{pstd}
Either way, file {cmd:myfile.gph} is created; for details see 
{manhelpi saving_option G-3} and {manhelp graph_save G-2:graph save}.

{pstd}
At some later time, in the same session or in a different session, you can
redisplay what is in the {cmd:.gph} file by typing

	{cmd:. graph use myfile}

{pstd}
See {manhelp graph_use G-2:graph use} for details.


{marker remarks2}{...}
{title:Gph files are machine/operating system independent}

{pstd}
The {cmd:.gph} files created by {cmd:saving()} and {cmd:graph} {cmd:save} are
binary files written in a machine-and-operating-system independent format.
You may send {cmd:.gph} files to other users, and they will be able to read
them, even if you use, say, a Mac and your colleague uses a Unix or
Windows computer.


{marker remarks3}{...}
{title:Gph files come in three forms}

{pstd}
There are three forms of {cmd:graph} files:

{phang2}
1.  an old-format Stata 7 or earlier {cmd:.gph} file

{phang2}
2.  a modern-format graph in as-is format

{phang2}
3.  a modern-format graph in live format

{pstd}
You can find out which type a {cmd:.gph} file is by typing

	{cmd:. graph describe} {it:filename}

{pstd}
See {manhelp graph_describe G-2:graph describe}.

{pstd}
Live-format files contain the data and other information necessary to re-create
the graph.  As-is format files contain a recording of the picture.  When you
save a graph, unless you specify the {cmd:asis} option, it is saved in live
format.


{marker remarks4}{...}
{title:Advantages of live-format files}

{pstd}
A live-format file can be edited later and can be displayed using
different schemes; see {manhelp schemes G-4:Schemes intro}.  Also, the
data used to create the graph can be retrieved from the {cmd:.gph} file.


{marker remarks5}{...}
{title:Advantages of as-is format files}

{pstd}
As-is format files are generally smaller than live-format files.

{pstd}
As-is format files cannot be modified; the rendition is fixed and will appear
on anyone else's computer just as it last appeared on yours.


{marker remarks6}{...}
{title:Retrieving data from live-format files}

{pstd}
First, verify that you have a live-format file by typing

	{cmd:. graph describe} {it:filename}{cmd:.gph}

{pstd}
Then type

	{cmd:. discard}

{pstd}
This will close any open graphs and eliminate anything stored having to do
with previously existing graphs.  Now display the graph of interest,

	{cmd:. graph use} {it:filename}

{pstd}
and then type

	{cmd:. serset dir}

{pstd}
From this point on, you are going to have to do a little detective work,
but usually it is not much.  Sersets are how {cmd:graph} stores the data
corresponding to each plot within the graph.  You can see {manhelp serset P},
but unless you are a programmer curious about how things work,
that will not be necessary.  We will show you below how to load each of
the sersets (often there is just one) and to treat it from then on just as
if it came from a {cmd:.dta} file.

{pstd}
Let us set up an example.  Pretend that previously we have drawn the
graph and saved it by typing

	{cmd:. sysuse lifeexp}

	{cmd:. scatter lexp gnppc, by(region)}
	  {it:({stata "gr_example lifeexp: scatter lexp gnppc, by(region)":click to run})}
{* graph gphfiles1}{...}

	{cmd:. graph save legraph}
	{txt:(file legraph.gph saved)}

{pstd}
Following the instructions, we now type

	{cmd:. graph describe legraph.gph}

	{txt}{title:legraph.gph stored {txt}on disk{txt}}

{p 16 15}
name:
{res}legraph.gph
{p_end}
{txt}{p 14 15}
format:
{res}live
{p_end}
{txt}{p 13 15}
created:
{res}20 Jun 2012 13:04:30
{p_end}
{txt}{p 14 15}
scheme:
{res}s2gmanual
{p_end}
{txt}{p 16 15}
size:
{res}2.392 {it:x} 3.12
{p_end}
{txt}{p 12 15}
dta file:
{res}C:\Program Files\Stata16\ado\base\lifeexp.dta dated 26 Mar 2016 09:40
{p_end}
{txt}{p 13 15}
command:
{res}twoway scatter lexp gnppc, by(region){txt}
{p_end}

	{cmd:. discard}

	{cmd:. graph use legraph}

	{cmd}. serset dir{txt}
	{p 10 14}
	{res}0.  {txt}44{txt} observation{txt}s{txt} on 2 variable{txt}s{break}
	lexp
	gnppc
	{p_end}
	{p 10 14}
	{res}1.  {txt}14{txt} observation{txt}s{txt} on 2 variable{txt}s{break}
	lexp
	gnppc
	{p_end}
	{p 10 14}
	{res}2.  {txt}10{txt} observation{txt}s{txt} on 2 variable{txt}s{break}
	lexp
	gnppc
	{p_end}{txt}

{pstd}
We discover that our graph has three sersets.  Looking at the graph,
that should not surprise us.  Although we might think of

	{cmd:. scatter lexp gnppc, by(region)}

{pstd}
as being one plot, it is in fact three if we were to expand it:

	{cmd:. scatter lexp gnppc if region==1 ||}
	{cmd:  scatter lexp gnppc if region==2 ||}
	{cmd:  scatter lexp gnppc if region==3}

{pstd}
The three sersets numbered 0, 1, and 2 correspond to three pieces of the
graph.  We can look at the individual sersets.  To load a serset, you first
set its number and then you type {cmd:serset} {cmd:use,} {cmd:clear}:

	{cmd:. serset 0}

	{cmd:. serset use, clear}

{pstd}
If we were now to type {cmd:describe}, we would discover that we have a
44-observation dataset containing two variables:  {cmd:lexp} and {cmd:gnppc}.
Here are a few of the data:

	{cmd}. list in 1/5
	{txt}
	     {c TLC}{hline 6}{c -}{hline 7}{c TRC}
	     {c |} {res}lexp   gnppc {txt}{c |}
	     {c LT}{hline 6}{c -}{hline 7}{c RT}
	  1. {c |} {res}  72     810 {txt}{c |}
	  2. {c |} {res}  74     460 {txt}{c |}
	  3. {c |} {res}  79   26830 {txt}{c |}
	  4. {c |} {res}  71     480 {txt}{c |}
	  5. {c |} {res}  68    2180 {txt}{c |}
	     {c BLC}{hline 6}{c -}{hline 7}{c BRC}

{pstd}
These are the data that appeared in the first plot.  We could
similarly obtain the data for the second plot by typing

	{cmd:. serset 1}

	{cmd:. serset use, clear}

{pstd}
If we wanted to put these data back together into one file, we might type

	{cmd:. serset 0}
	{cmd:. serset use, clear}
	{cmd:. generate region=0}
	{cmd:. save region0}

	{cmd:. serset 1}
	{cmd:. serset use, clear }
	{cmd:. generate region=1}
	{cmd:. save region1}

	{cmd:. serset 2}
	{cmd:. serset use, clear }
	{cmd:. generate region=2}
	{cmd:. save region2}

	{cmd:. use region0}
	{cmd:. append using region1}
	{cmd:. append using region2}

	{cmd:. erase region0.dta}
	{cmd:. erase region1.dta}
	{cmd:. erase region2.dta}

{pstd}
In general, it will not be as much work to retrieve the data because in
many graphs, you will find that there is only one serset.  We chose a
complicated {cmd:.gph} file for our demonstration.
{p_end}
