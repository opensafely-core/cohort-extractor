{smcl}
{* *! version 1.1.9  20sep2018}{...}
{vieweralsosee "[ST] st_is" "mansection ST st_is"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{vieweralsosee "[ST] sttoct" "help sttoct"}{...}
{vieweralsosee "[ST] Survival analysis" "help survival_analysis"}{...}
{viewerjumpto "Syntax" "st_is##syntax"}{...}
{viewerjumpto "Description" "st_is##description"}{...}
{viewerjumpto "Links to PDF documentation" "st_is##linkspdf"}{...}
{viewerjumpto "Remarks" "st_is##remarks"}{...}
{viewerjumpto "Characteristics of st datasets" "st_is##char"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[ST] st_is} {hline 2}}Survival analysis subroutines for programmers{p_end}
{p2col:}({mansection ST st_is:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{phang}
Verify that data in memory are survival-time data

{p 8 15 2}
{cmd:st_is 2} {c -(} {opt full} | {opt analysis} {c )-}


{phang}
Display or do not display summary of survival-time variables

{p 8 15 2}
{cmd:st_show} [{opt noshow}]


{phang}
Risk-group summaries

{p 8 15 2}
{cmd:st_ct "}[{it:byvars}]{cmd:" ->} {it:newtvar} {it:newpopvar}
	{it:newfailvar} [{it:newcensvar} [{it:newentvar}]]


{pstd}
You must have {cmd:stset} your data before using {cmd:st_is}, {cmd:st_show},
and {cmd:st_ct}; see {manhelp stset ST}.


{marker description}{...}
{title:Description}

{pstd}
These commands are provided for programmers wishing to write new st commands.

{pstd}
{cmd:st_is} verifies that the data in memory are survival-time (st) data.
If not, it issues the error message "{err:data not st}",
{search rc 119:r(119)}.

{pstd}
st is currently "release 2", meaning that this is the second design of the
system.  Programs written for the previous release continue to work.
(The previous release of st corresponds to Stata 5.)

{pstd}
Modern programs code {cmd:st_is 2 full} or {cmd:st_is 2 analysis}. 
{cmd:st_is 2} verifies that the dataset in memory is in release 2
format; if it is in the earlier format, it is converted to release 2 format.
(Older programs simply code {cmd:st_is}.  This verifies that no new
features are {helpb stset} about the data that would cause the old program to
break.)

{pstd}
The {opt full} and {opt analysis} parts indicate whether the dataset may include
past, future, or past and future data.  Code {cmd:st_is 2 full} if the command 
is suitable for running on the analysis sample and past and future data (many
data management commands fall into this category).  Code {cmd:st_is 2 analysis}
if the command is suitable for use only with the analysis sample (most 
statistical commands fall into this category).  See {manhelp stset ST} for the
definitions of past and future.

{pstd}
{cmd:st_show} displays the summary of the survival-time variables or does
nothing, depending on what you specify when {cmd:stset}ing the data.
{cmd:noshow} requests that {cmd:st_show} display nothing.

{pstd}
{cmd:st_ct} is a low-level utility that provides risk-group summaries from
survival-time data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST st_isRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {manlink ST st_is} for more information on these commands.  All st
datasets have the following four variables:

{p 8 20 2}{hi:_t0} {space 3} time of entry (in t units) into risk pool{p_end}
{p 8 20 2}{hi:_t} {space 4} time of exit  (in t units) from risk pool{p_end}
{p 8 20 2}{hi:_d} {space 4} contains 1 if failure, 0 if censoring{p_end}
{p 8 20 2}{hi:_st} {space 3} contains 1 if observation is to be used and 0
	otherwise

{pstd}
Some st datasets also contain the variables

{p 8 20 2}{hi:_origin} contains evaluated value of {cmd:origin()}{p_end}
{p 8 20 2}{hi:_scale}{space 2}contains evaluated value of {cmd:scale()}

{pstd}
Do not forget that all calculations and actions are to be restricted, at
the least, to observations for which {hi:_st}!=0.  Observations with
{hi:_st}==0 are to be ignored.


{marker char}{...}
{title:Characteristics of st datasets}

{pstd}
The characteristics used by the st system are

    {hline}
{p 4 24 2}{hi:char _dta[_dta]} {space 3} "{hi:st}" {space 2} (marks that the
	data are st){p_end}
{p 4 24 2}{hi:char _dta[st_ver]} {space 1} "{hi:2}" {space 3} (version
	number){p_end}

{p 4 24 2}{hi:char _dta[st_id]} {space 2} {it:varname} or nothing; {cmd:id()}
	variable{p_end}
{p 4 24 2}{hi:char _dta[st_bt0]} {space 1} {it:varname} or nothing; {cmd:t0()}
	variable{p_end}
{p 4 24 2}{hi:char _dta[st_bt]} {space 2} {it:varname}; t variable from
	"{cmd:stset t ,} {it:...}"{p_end}
{p 4 24 2}{hi:char _dta[st_bd]} {space 2} {it:varname} or nothing;
	{cmd:failure()} variable{p_end}

{p 4 24 2}{hi:char _dta[st_ev]} {space 2} list of numbers or nothing;
	{it:numlist} from
	{cmd:failure(}{it:varname}[{cmd:==}{it:numlist}]{cmd:)}{p_end}
{p 4 24 2}{hi:char _dta[st_enter]} contents of {cmd:enter()} or nothing;
	{it:numlist} expanded{p_end}
{p 4 24 2}{hi:char _dta[st_exit]}{space 2}contents of {cmd:exit()} or nothing;
	{it:numlist} expanded{p_end}
{p 4 24 2}{hi:char _dta[st_orig]}{space 2}contents of {cmd:origin()} or nothing;
	{it:numlist} expanded{p_end}
{p 4 24 2}{hi:char _dta[st_bs]} {space 2} {it:#} or "{hi:1}"; {cmd:scale()}
	value{p_end}

{p 4 24 2}{hi:char _dta[st_o]} {space 3} "{hi:_origin}" or {it:#}{p_end}
{p 4 24 2}{hi:char _dta[st_s]} {space 3} "{hi:_scale}" or {it:#}{p_end}

{p 4 24 2}{hi:char _dta[st_ifexp]} {it:exp} or nothing; from
	"{cmd:stset} {it:...} {cmd:if} {it:exp} {it:...}"{p_end}
{p 4 24 2}{hi:char _dta[st_if]} {space 2} {it:exp} or nothing; contents of
	{cmd:if()}{p_end}
{p 4 24 2}{hi:char _dta[st_ever]}{space 2}{it:exp} or nothing; contents of
	{cmd:ever()}{p_end}
{p 4 24 2}{hi:char _dta[st_never]} {it:exp} or nothing; contents of
	{cmd:never()}{p_end}
{p 4 24 2}{hi:char _dta[st_after]} {it:exp} or nothing; contents of
	{cmd:after()}{p_end}
{p 4 24 2}{hi:char _dta[st_befor]} {it:exp} or nothing; contents of
	{cmd:before()}{p_end}

{p 4 24 2}{hi:char _dta[st_wt]} {space 2} weight type or nothing;
	user-specified weight{p_end}
{p 4 24 2}{hi:char _dta[st_wv]} {space 2} {it:varname} or nothing;
	user-specified weighting var.{p_end}
{p 4 24 2}{hi:char _dta[st_w]} {space 3} "{hi:[}{it:weighttype}{hi:=}{it:weightvar}{hi:]}" or nothing{p_end}

{p 4 24 2}{hi:char _dta[st_show]}{space 2}"{hi:noshow}" or nothing{p_end}

{p 4 24 2}{hi:char _dta[st_t]} {space 3} {hi:_t}  (for compatibility with
	rel. 1){p_end}
{p 4 24 2}{hi:char _dta[st_t0]} {space 2} {hi:_t0} (for compatibility with
	rel. 1){p_end}
{p 4 24 2}{hi:char _dta[st_d]} {space 3} {hi:_d}  (for compatibility with
	rel. 1){p_end}

{p 4 24 2}{hi:char _dta[st_n0]} {space 2} {it:#} or nothing; number of
	st notes{p_end}
{p 4 24 2}{hi:char _dta[st_n1]} {space 2} text of first note or nothing{p_end}
{p 4 24 2}{hi:char _dta[st_n2]} {space 2} text of second note or nothing{p_end}
    ...

{p 4 24 2}{hi:char _dta[st_set]} {space 1} text or nothing.  If filled in,
	{helpb streset} will refuse to execute and present this text as the
	reason.{p_end}
    {hline}

{pstd}
See {manlink ST st_is} for more information on these commands.
{p_end}
