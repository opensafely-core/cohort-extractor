{smcl}
{* *! version 1.2.13  05sep2018}{...}
{vieweralsosee "[P] program" "mansection P program"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] byable" "help byable"}{...}
{vieweralsosee "[D] clear" "help clear"}{...}
{vieweralsosee "[P] discard" "help discard"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{vieweralsosee "[P] sortpreserve" "help sortpreserve"}{...}
{vieweralsosee "[P] trace" "help trace"}{...}
{viewerjumpto "Syntax" "program##syntax"}{...}
{viewerjumpto "Description" "program##description"}{...}
{viewerjumpto "Links to PDF documentation" "program##linkspdf"}{...}
{viewerjumpto "Options" "program##options"}{...}
{viewerjumpto "Useful commands for programmers" "program##useful"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[P] program} {hline 2}}Define and manipulate programs{p_end}
{p2col:}({mansection P program:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Define program

{p 8 16 2}{cmdab:pr:ogram} [{cmdab:de:fine}] {it:pgmname} [{cmd:,}
	[ {cmd:nclass} | {cmd:rclass} | {cmd:eclass} | {cmd:sclass} ]
	{cmdab:by:able:(}{cmdab:r:ecall}[{cmd:,} {cmdab:noh:eader}] |
	{cmdab:o:necall}{cmd:)}
	{opt prop:erties(namelist)}
	{cmdab:sort:preserve} {cmd:plugin}]


    List names of programs stored in memory

	{cmdab:pr:ogram} {cmdab:di:r}


    Eliminate program from memory

{p 8 16 2}{cmdab:pr:ogram} {cmd:drop} {c -(} {it:pgmname} [{it:pgmname} [...]] |
	{cmd:_all} | {cmd:_allado} {c )-}


    List contents of program
{p 8 16 2}{cmdab:pr:ogram} {cmdab:l:ist} [ {it:pgmname} [{it:pgmname} [...]] |
	{cmd:_all}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:program define} defines and manipulates programs.  {cmd:define} is
required if {it:pgmname} are any of the words:  {cmd:define}, {cmd:dir},
{cmd:drop}, {cmd:list}, or {cmd:plugin}.

{pstd}
{cmd:program dir} lists the names of all the programs stored in memory.

{pstd}
{cmd:program list} lists the contents of the named program or programs.
{cmd:program list _all} lists the contents of all programs stored in memory.

{pstd}
{cmd:program drop} eliminates the named program or programs from memory.
{cmd:program drop _all} eliminates all programs stored in memory.
{cmd:program drop _allado} eliminates all programs stored in memory that
were loaded from ado-files.  See {findalias frado} for an explanation
of ado-files.

{pstd}
See {findalias frprograms} for a description of programs.

{pstd}See {manhelp trace P} for information on debugging programs.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P programRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:nclass} states that the program being defined does not return
results in {hi:r()}, {hi:e()}, or {hi:s()} and is the default.

{phang}
{cmd:rclass} states that the program being defined returns results in
{hi:r()}.  This is done using the {cmd:return} command; see {manhelp return P}.
If the program is not explicitly declared to be {cmd:rclass}, then it may not
change or replace results in {hi:r()}.

{phang}
{cmd:eclass} states that the program being defined returns results in
{hi:e()} or modifies already existing results in {hi:e()}.  This is done using
the {cmd:ereturn} command; see {manhelp return P} and {manhelp ereturn P}.  If
the program is not explicitly declared to be {cmd:eclass}, it may not
directly replace or change results in {hi:e()}

{phang}
{cmd:sclass} states that the program being defined returns results in
{hi:s()}.  This is done using the {cmd:sreturn} command; see
{manhelp return P}.  If the program is not explicitly declared to be
{cmd:sclass}, then it may not directly change or replace results in {hi:s()},
but it still may clear {hi:s()} by using {cmd:sreturn clear}.

{phang}
{cmd:byable(recall}[{cmd:,} {cmd:noheader}] | {cmd:onecall)} specifies that the
program allow Stata's {cmd:by} {it:varlist}{cmd::} prefix.  There are
two styles for writing byable programs:  {cmd:byable(recall)} and
{cmd:byable(onecall)}.  The writing of byable programs is discussed in
{manhelp byable P}.

{phang}
{opt properties(namelist)} states that {it:pgmname} has the specified
properties.  {it:namelist} may contain up to 80 characters, 
including separating spaces.  See 
{manhelp program_properties P:program properties}.

{phang}
{cmd:sortpreserve} states that the program changes the sort order of
the data and that Stata is to restore the original order when 
the program concludes; see {manhelp sortpreserve P}.

{phang}
{cmd:plugin} specifies that a plugin (a specially compiled C program) be
dynamically loaded and that the plugin define the new command; see 
{manhelp plugin P}.


{marker useful}{...}
{title:Useful commands for programmers}

{synoptset 37 tabbed}{...}
{syntab:Basics}
{synopt:{findalias frprograms}}{p_end}
{synopt:{findalias frmacros}}{p_end}
{synopt:{findalias fradoprog}}{p_end}
{synopt:{manhelp comments P}} Add comments to programs{p_end}
{synopt:{manhelp fvexpand P}} Expand factor varlists{p_end}
{synopt:{manhelp macro P}} Macro definition and manipulation{p_end}
{synopt:{manhelp program P}} Define and manipulate programs{p_end}
{synopt:{manhelp return P}} Return stored results{p_end}

{syntab:Program control}
{synopt:{findalias frversion}}{p_end}
{synopt:{manhelp capture P}} Capture return code{p_end}
{synopt:{manhelp continue P}} Break out of loops{p_end}
{synopt:{manhelp error P}} Display generic error message and exit{p_end}
{synopt:{manhelp foreach P}} Loop over items{p_end}
{synopt:{manhelp forvalues P}} Loop over consecutive values{p_end}
{synopt:{manhelp ifcmd P:if}} if programming command{p_end}
{synopt:{manhelp version P}} Version control{p_end}
{synopt:{manhelp while P}} Looping{p_end}

{syntab:Parsing and program arguments}
{synopt:{findalias frarguments}}{p_end}
{synopt:{manhelp confirm P}} Argument verification{p_end}
{synopt:{manhelp gettoken P}} Low-level parsing{p_end}
{synopt:{manhelp levelsof P}} Distinct levels of a variable{p_end}
{synopt:{manhelp nlist P:numlist}} Parse numeric lists{p_end}
{synopt:{manhelp syntax P}} Parse Stata syntax{p_end}
{synopt:{manhelp tokenize P}} Divide strings into tokens{p_end}

{syntab:Console output}
{synopt:{manhelp dialog_programming P:Dialog programming}} Dialog programming{p_end}
{synopt:{manhelp display P}} Display strings and values of scalar expressions{p_end}
{synopt:{manhelp smcl P}} Stata Markup and Control Language{p_end}
{synopt:{manhelp tabdisp P}} Display tables{p_end}

{syntab:Commonly used programming commands}
{synopt:{manhelp byable P}} Make programs byable{p_end}
{synopt:{manhelp #delimit P}} Change delimiter{p_end}
{synopt:{manhelp exit P}} Exit from a program or do-file{p_end}
{synopt:{manhelp fvrevar R}} Factor-variables operator programming command{p_end}
{synopt:{manhelp mark P}} Mark observations for inclusion{p_end}
{synopt:{manhelp matrix P}} Introduction to matrix commands{p_end}
{synopt:{manhelp more P}} Pause until key is pressed{p_end}
{synopt:{manhelp nopreserve_option P:nopreserve option}} nopreserve option{p_end}
{synopt:{manhelp preserve P}} Preserve and restore data{p_end}
{synopt:{manhelp quietly P}} Quietly or noisily perform command{p_end}
{synopt:{manhelp scalar P}} Scalar variables{p_end}
{synopt:{manhelp smcl P}} Stata Markup and Control Language{p_end}
{synopt:{manlink P sortpreserve}} Sort within programs{p_end}
{synopt:{manhelp timer P}} Time sections of code by recording and
reporting time spent{p_end}
{synopt:{manhelp tsrevar TS}} Time-series operator programming
command{p_end}

{syntab:Debugging}
{synopt:{manhelp pause P}} Program debugging command{p_end}
{synopt:{manhelp timer P}} Time sections of code by recording and
reporting time spent{p_end}
{synopt:{manhelp trace P}} Debug Stata programs{p_end}

{syntab:Advanced programming commands}
{synopt:{manhelp Automation P}} Automation{p_end}
{synopt:{manhelp break P}} Suppress Break key{p_end}
{synopt:{manhelp char P}} Characteristics{p_end}
{synopt:{manhelp class M-2}} Object-oriented programming (classes){p_end}
{synopt:{manhelp class P}} Class programming{p_end}
{synopt:{manhelp class_exit P:class exit}} Exit class-member program and return result{p_end}
{synopt:{manhelp classutil P:classutil}} Class programming utility{p_end}
{synopt:{manhelp estat_programming P:estat programming}} Controlling estat after community-contributed commands{p_end}
{synopt:{manhelp _estimates P}} Manage estimation result{p_end}
{synopt:{manhelp file P}} Read and write ASCII text and binary files{p_end}
{synopt:{manhelp findfile P}} Find file in path{p_end}
{synopt:{manhelp include P}} Include commands from file{p_end}
{synopt:{manhelp macro P}} Macro definition and manipulation{p_end}
{synopt:{manhelp macro_lists P:macro lists}} Manipulate lists{p_end}
{synopt:{manhelp ml R}} Maximum likelihood estimation{p_end}
{synopt:{manhelp mf_moptimize M-5:moptimize()}} Model optimization{p_end}
{synopt:{manhelp mf_optimize M-5:optimize()}} Function optimization{p_end}
{synopt:{manhelp plugin P}} Load a plugin{p_end}
{synopt:{manhelp postfile P}} Post results in Stata dataset{p_end}
{synopt:{manhelp _predict P}} Obtain predictions, residuals, etc.,
after estimation programming command{p_end}
{synopt:{manhelp program_properties P:program properties}} Properties of user-defined programs{p_end}
{synopt:{manhelp putmata D}} Put Stata variables into Mata and vice versa{p_end}
{synopt:{manhelp _return P}} Preserve stored results{p_end}
{synopt:{manhelp _rmcoll P}} Remove collinear variables{p_end}
{synopt:{manhelp _robust P}} Robust variance estimates{p_end}
{synopt:{manhelp serset P}} Create and manipulate sersets{p_end}
{synopt:{manhelp snapshot D}} Save and restore data snapshots{p_end}
{synopt:{manhelp unab P}} Unabbreviate variable list{p_end}
{synopt:{manhelp unabcmd P}} Unabbreviate command name{p_end}
{synopt:{manhelp varabbrev P}} Control variable abbreviation{p_end}
{synopt:{manhelp viewsource P}} View source code{p_end}

{syntab:Special-interest programming commands}
{synopt:{manhelp bstat R}} Report bootstrap results{p_end}
{synopt:{manhelp cluster_subroutines MV:cluster programming subroutines}} Add
cluster-analysis routines{p_end}
{synopt:{manhelp cluster_programming_utilities MV:cluster programming utilities}} Cluster-analysis programming utilities{p_end}
{synopt:{manhelp fvrevar R}} Factor-variables operator programming command{p_end}
{synopt:{manhelp matrix_dissimilarity P:matrix dissimilarity}} Compute similarity or dissimilarity measures{p_end}
{synopt:{manhelp mi_select MI:mi select}} Programmer's alternative to mi extract{p_end}
{synopt:{manhelp st_is ST}} Survival analysis subroutines for
programmers{p_end}
{synopt:{manhelp svymarkout SVY}} Mark observations for exclusion
on the basis of survey characteristics{p_end}
{synopt:{manhelp mi_technical MI:technical}} Details for programmers{p_end}
{synopt:{manhelp tsrevar TS}} Time-series operator programming
command{p_end}

{syntab:File formats}
{synopt:{manhelp dta P:File formats .dta}} Description of .dta
file format{p_end}

{syntab:Mata}
{synopt:{manhelp mata M:Mata Reference Manual}}{p_end}
