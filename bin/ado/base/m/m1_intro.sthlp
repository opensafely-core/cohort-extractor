{smcl}
{* *! version 1.1.11  11may2018}{...}
{vieweralsosee "[M-1] Intro" "mansection M-1 Intro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-0] Intro" "help mata"}{...}
{vieweralsosee "[D] putmata" "help putmata"}{...}
{viewerjumpto "Contents" "m1_intro##contents"}{...}
{viewerjumpto "Description" "m1_intro##description"}{...}
{viewerjumpto "Links to PDF documentation" "m1_intro##linkspdf"}{...}
{viewerjumpto "Remarks" "m1_intro##remarks"}{...}
{viewerjumpto "References" "m1_intro##references"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-1] Intro} {hline 2}}Introduction and advice
{p_end}
{p2col:}({mansection M-1 Intro:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker contents}{...}
{title:Contents}

{col 8}[M-1] Entry{col 28}Description
{col 8}{hline 64}

{col 8}   {c TLC}{hline 23}{c TRC}
{col 8}{hline 3}{c RT}{it: Introductory material }{c LT}{hline}
{col 8}   {c BLC}{hline 23}{c BRC}

{col 8}{bf:{help m1_first:First}}{...}
{col 28}{bf:Introduction and first session}

{col 8}{bf:{help m1_interactive:interactive}}{...}
{col 28}{bf:Using Mata interactively}

{col 8}{bf:{help m1_ado:Ado}}{...}
{col 28}{bf:Using Mata with ado-files}

{col 8}{bf:{help m1_help:help}}{...}
{col 28}{bf:Obtaining help in Stata}

{col 8}   {c TLC}{hline 35}{c TRC}
{col 8}{hline 3}{c RT}{it: How Mata works & finding examples }{c LT}{hline}
{col 8}   {c BLC}{hline 35}{c BRC}

{col 8}{bf:{help m1_how:How}}{...}
{col 28}{bf:How Mata works}

{col 8}{bf:{help m1_source:Source}}{...}
{col 28}{bf:Viewing the source code}

{col 8}   {c TLC}{hline 16}{c TRC}
{col 8}{hline 3}{c RT}{it: Special topics }{c LT}{hline}
{col 8}   {c BLC}{hline 16}{c BRC}

{col 8}{bf:{help m1_returnedargs:Returned args}}{...}
{col 28}{bf:Function arguments used to return results}

{col 8}{bf:{help m1_naming:Naming}}{...}
{col 28}{bf:Advice on naming functions and variables}

{col 8}{bf:{help m1_limits:Limits}}{...}
{col 28}{bf:Limits and memory utilization}

{col 8}{bf:{help m1_tolerance:Tolerance}}{...}
{col 28}{bf:Use and specification of tolerances}

{col 8}{bf:{help m1_permutation:Permutation}}{...}
{col 28}{bf:An aside on permutation matrices and vectors}

{col 8}{bf:{help m1_lapack:LAPACK}}{...}
{col 28}{bf:The LAPACK linear-algebra routines}
{col 8}{hline 64}


{marker description}{...}
{title:Description}

{p 4 4 2}
This section provides an introduction to Mata along with reference 
material common to all sections.

{pstd}
In addition, we should mention two helpful books.

{pstd}
{browse "http://www.stata-press.com/books/introduction-stata-programming/":{it:An Introduction to Stata Programming}}
(412 pages) by Christopher Baum introduces Mata more gently than this manual.
It assumes that you are familiar with Stata but new to programming.

{pstd}
{browse "http://www.stata-press.com/books/mata-book/":{it:The Mata Book}}
(428 pages) by William Gould assumes familiarity with programming in some
language, but it does not assume a lot of experience.  It goes further and
deeper into Mata and also covers programming, numerical accuracy, workflow,
verifications, and certification.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-1 IntroRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The most important entry in this section is
{bf:{help m1_first:[M-1] First}}.
Also see 
{bf:{help m6_glossary:[M-6] Glossary}}.

{p 4 4 2}
The Stata commands 
{cmd:putmata} and {cmd:getmata} are useful 
for moving data from Stata to Mata and back again; 
see 
{bf:{help putmata:[D] putmata}}.

{pstd}
Those looking for a textbook-like introduction to Mata may want to 
consider {help m1_intro##B2016:Baum (2016)}, particularly chapters 13 and 14.


{marker references}{...}
{title:References}

{marker B2016}{...}
{phang}
Baum, C. F. 2016.
{browse "http://www.stata-press.com/books/introduction-stata-programming/":{it:An Introduction to Stata Programming}}.
2nd ed.  College Station, TX: Stata Press.

{phang}
Gould, W. W. 2018.
{browse "http://www.stata-press.com/books/mata-book/":{it:The Mata Book: A Book for Serious Programmers and Those Who Want to Be}}.
College Station, TX: Stata Press.
{p_end}
