{smcl}
{* *! version 1.0.2  15may2016}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] dtaversion" "help dtaversion"}{...}
{viewerjumpto "Syntax" "dtaverify##syntax"}{...}
{viewerjumpto "Description" "dtaverify##description"}{...}
{viewerjumpto "Remarks" "dtaverify##remarks"}{...}
{viewerjumpto "Aside for programmers" "dtaverify##aside"}{...}
{title:Title}

{p 4 22 2}
{hi:[R] dtaverify} {hline 2} Verify .dta file construction


{marker syntax}{...}
{title:Syntax}

        {cmd:dtaverify} {it:{help filename}}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:dtaverify} verifies that the contents of {it:filename} are
properly constructed according to the standard specified by StataCorp.
If the file is constructed incorrectly, {cmd:dtaverify} details
how the file differs from the standard.

{p 4 4 2}
Also see {manhelp dtaversion R}.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:dtaverify} can be used to

{p 8 11 2}
o{bind:  }debug programs written in other 
languages and in packages that produce Stata {cmd:.dta} files by 
running {cmd:dtaverify} on the file those programs produce.

{p 8 11 2}
o{bind:  }verify that a {cmd:.dta} file 
has not been subsequently damaged. 

{p 4 4 2}
{cmd:dtaverify} provides useful debugging information. 
{cmd:dtaverify} returns 0 if the dataset matches the standard specified
by StataCorp, and it returns nonzero otherwise. 

{p 4 4 2}
The standard for {cmd:.dta} files can be found in
{manhelp dta P:File formats .dta}.  The
format of Stata {cmd:.dta} files has changed over time.  The standards are
known as format 102, format 103, and so on.  {cmd:.dta} files contain
identifiers that specify the standard used in the file and thus
current versions of
Stata can read datasets that meet previous standards.  See 
{manhelp dtaversion R} for more information, including a table relating
file formats to Stata versions.

{p 4 4 2}
{cmd:dtaverify} currently can verify standard format 115 and
subsequent.  If {cmd:dtaverify} is run on an older dataset,
{cmd:dtaverify} will provide instructions on how to verify its
construction.


{marker aside}{...}
{title:Aside for programmers} 

{p 4 4 2} 
The source code for {cmd:dtaverify} may be of interest 
to Stata programmers for two reasons:

{p 8 11 2}
1. It provides a useful secondary description of the file formats. 

{p 8 11 2}
2. It provides an example of how code can be written in Mata 
    to read complicated binary formats. 

{p 4 4 2}
{cmd:dtaverify}, a command stored in dtaverify.ado, is merely 
a switcher that jumps to other, standard-specific routines. 
It is not interesting, but the standard-specific routines are interesting.
We recommend you see {stata "viewsource dtaverify_118.ado"}. 
{p_end}
