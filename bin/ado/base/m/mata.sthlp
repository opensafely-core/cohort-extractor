{smcl}
{* *! version 1.1.8  11may2018}{...}
{vieweralsosee "[M-0] Intro" "mansection M-0 Intro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] First" "help m1_first"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-6] Glossary" "help m6_glossary"}{...}
{viewerjumpto "Contents" "mata##contents"}{...}
{viewerjumpto "Description" "mata##description"}{...}
{viewerjumpto "Links to PDF documentation" "mata##linkspdf"}{...}
{viewerjumpto "Remarks" "mata##remarks"}{...}
{viewerjumpto "References" "mata##references"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-0] Intro} {hline 2}}Introduction to the Mata manual
{p_end}
{p2col:}({mansection M-0 Intro:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker contents}{...}
{title:Contents}

{col 14}Section{col 31}Description
{col 14}{hline 53}
{col 14}{bf:{help m1_intro:[M-1]}}{...}
{col 31}{bf:Introduction and advice}

{col 14}{bf:{help m2_intro:[M-2]}}{...}
{col 31}{bf:Language definition}

{col 14}{bf:{help m3_intro:[M-3]}}{...}
{col 31}{bf:Commands for controlling Mata}

{col 14}{bf:{help m4_intro:[M-4]}}{...}
{col 31}{bf:Categorical guide to Mata functions}

{col 14}{bf:{help m5_intro:[M-5]}}{...}
{col 31}{bf:Alphabetical index to Mata functions}

{col 14}{bf:{help m6_glossary:[M-6]}}{...}
{col 31}{bf:Mata glossary of common terms}
{col 14}{hline 53}


{marker description}{...}
{title:Description}

{p 4 4 2}
Mata is a matrix programming language that can be used by those who want to
perform matrix calculations interactively and by those who
want to add new features to Stata.

{pstd}
The {it:Mata Reference Manual} is comprehensive.  If it seems overly
comprehensive and too short on explanation as to why things
work the way they do and how they could be used, we have a suggestion.  See
{browse "http://www.stata-press.com/books/mata-book/":{it:The Mata Book}}
by William Gould (428 pages) or
{browse "http://www.stata-press.com/books/introduction-stata-programming/":{it:An Introduction to Stata Programming}}
by Christopher Baum (412 pages).  Baum's book assumes that you are familiar
with Stata but new to programming.  Gould's book assumes that you have some
familiarity with programming and goes on from there.  The books go well
together.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-0 IntroRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
This manual is divided into six sections.  Each section is organized
alphabetically, but there is an introduction in front that will help you get
around.

{p 4 4 2}
If you are new to Mata, here is a helpful reading list:
start by reading 

{col 9}{hline 61}
{col 9}{...}
{bf:{help m1_first:[M-1] First}}{...}
{col 31}{...}
Introduction and first session
{col 9}{...}
{bf:{help m1_interactive:[M-1] Interactive}}{...}
{col 31}{...}
Using Mata interactively
{col 9}{...}
{bf:{help m1_how:[M-1] How}}{...}
{col 31}{...}
How Mata works
{col 9}{hline 61}

{p 4 4 2}
You may find other things in section {bf:[M-1]} that interest you.  
For a table of contents, see 

{col 9}{hline 61}
{col 9}{...}
{bf:{help m1_intro:[M-1] Intro}}{...}
{col 31}{...}
Introduction and advice
{col 9}{hline 61}

{p 4 4 2}
Whenever you see a term that you are unfamiliar with, see

{col 9}{hline 61}
{col 9}{...}
{bf:{help m6_glossary:[M-6] Glossary}}{...}
{col 31}{...}
Mata glossary of common terms
{col 9}{hline 61}

{p 4 4 2}
Now that you know the basics, if you are interested, you can look deeper into
Mata's programming features:

{col 9}{hline 61}
{col 9}{...}
{bf:{help m2_syntax:[M-2] Syntax}}{...}
{col 31}{...}
Mata language grammar and syntax
{col 9}{hline 61}

{p 4 4 2}
{bf:[M-2] Syntax} is pretty dense reading, but it summarizes nearly
everything.  The other entries in [M-2] repeat what is said there but with
more explanation; see

{col 9}{hline 61}
{col 9}{...}
{bf:{help m2_intro:[M-2] Intro}}{...}
{col 31}{...}
Language definition
{col 9}{hline 61}

{p 4 4 2}
because other entries in [M-2] will interest you.  If you are
interested in object-oriented programming, be sure to see 
{bf:{help m2_class:[M-2] class}}.

{p 4 4 2}
Along the way, you will eventually be guided to sections [M-4] and [M-5].
[M-5] documents Mata's functions; the alphabetical order 
makes it easy to find a function if you know its name but makes learning 
what functions there are hopeless.  That is the purpose of [M-4] -- to
present the functions in logical order.  See

{col 9}{hline 61}
{col 11}{...}
{bf:{help m4_intro:[M-4] Intro}}{...}
{col 31}{...}
Categorical guide to Mata functions

{col 9}{...}
Mathematical
{col 11}{...}
{bf:{help m4_matrix:[M-4] Matrix}}{...}
{col 31}{...}
Matrix functions{...}

{col 11}{...}
{bf:{help m4_solvers:[M-4] Solvers}}{...}
{col 31}{...}
Matrix solvers and inverters{...}

{col 11}{...}
{bf:{help m4_scalar:[M-4] Scalar}}{...}
{col 31}{...}
Scalar functions{...}

{col 11}{...}
{bf:{help m4_statistical:[M-4] Statistical}}{...}
{col 31}{...}
Statistical functions{...}

{col 11}{...}
{bf:{help m4_mathematical:[M-4] Mathematical}}{...}
{col 31}{...}
Other important functions

{col 9}{...}
Utility and manipulation{...}

{col 11}{...}
{bf:{help m4_standard:[M-4] Standard}}{...}
{col 31}{...}
Functions to create standard matrices{...}

{col 11}{...}
{bf:{help m4_utility:[M-4] Utility}}{...}
{col 31}{...}
Matrix utility functions{...}

{col 11}{...}
{bf:{help m4_manipulation:[M-4] Manipulation}}{...}
{col 31}{...}
Matrix manipulation functions

{col 9}{...}
Stata interface{...}

{col 11}{...}
{bf:{help m4_stata:[M-4] Stata}}{...}
{col 31}{...}
Stata interface functions

{col 9}{...}
String, I/O, and programming{...}

{col 11}{...}
{bf:{help m4_string:[M-4] String}}{...}
{col 31}{...}
String functions{...}

{col 11}{...}
{bf:{help m4_io:[M-4] IO}}{...}
{col 31}{...}
I/O functions{...}

{col 11}{...}
{bf:{help m4_programming:[M-4] Programming}}{...}
{col 31}{...}
Programming functions{...}

{col 9}{hline 61}


{marker references}{...}
{title:References}

{phang}
Baum, C. F. 2016.
{browse "http://www.stata-press.com/books/introduction-stata-programming/":{it:An Introduction to Stata Programming}}.
2nd ed.  College Station, TX: Stata Press.

{phang}
Gould, W. W. 2018.
{browse "http://www.stata-press.com/books/mata-book/":{it:The Mata Book: A Book for Serious Programmers and Those Who Want to Be}}.
College Station, TX: Stata Press.
{p_end}
