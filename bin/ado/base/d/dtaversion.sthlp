{smcl}
{* *! version 1.1.2  19apr2019}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] dtaverify" "help dtaverify"}{...}
{viewerjumpto "Syntax" "dtaversion##syntax"}{...}
{viewerjumpto "Description" "dtaversion##description"}{...}
{viewerjumpto "Remarks" "dtaversion##remarks"}{...}
{viewerjumpto "Stored results" "dtaversion##results"}{...}
{title:Title}

{p 4 22 2}
{hi:[R] dtaversion} {hline 2} Report format and version of .dta file


{marker syntax}{...}
{title:Syntax}

	{cmd:dtaversion} {it:{help filename}}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:dtaversion} reports the {cmd:.dta} format and the Stata version
associated with the specified {cmd:.dta} file. 


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:dtaversion} is a certification tool used by StataCorp.

{p 4 4 2} 
A related command, {helpb dtaverify}, has uses other than certification.

{p 4 4 2}
Stata stores data in {cmd:.dta} files.  The format of these files has
changed over time.

        Stata version     .dta file format
	{hline 40}
               1               102
            2, 3               103
               4               104
               5               105
               6               108
               7            110 and 111
            8, 9            112 and 113
          10, 11               114
              12               115
              13               117
              14, 15, and 16   118 (# of variables <= 32,767)
              15 and 16        119 (# of variables > 32,767, Stata/MP only)
	{hline 40}
        file formats 103, 106, 107, 109, and 116
        were never used in any official release.

{p 4 4 2}
Many users are unaware that the file format has ever changed because 
each version of Stata reads the then current and previous formats. 

{p 4 4 2}
Documentation about the formats is available online; see
{manhelp dta P:File formats .dta}.


{marker results}{...}
{title:Stored results}

{p 4 4 2}
{cmd:dtaversion} stores the {cmd:.dta} file format in scalar {cmd:r(version)},
which is sometimes called the version number of the {cmd:.dta} file and 
should not be confused with the version number of Stata.
{p_end}
