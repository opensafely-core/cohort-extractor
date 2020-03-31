{smcl}
{* *! version 1.2.4  15oct2018}{...}
{vieweralsosee "[R] net" "help net"}{...}
{vieweralsosee "[R] search" "help search"}{...}
{vieweralsosee "[R] sj" "help sj"}{...}
{vieweralsosee "[R] update" "help update"}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{viewerjumpto "Description" "stb##description"}{...}
{viewerjumpto "Obtaining community-contributed additions from the STB" "stb##software"}{...}
{viewerjumpto "STB Reprints" "stb##reprints"}{...}
{viewerjumpto "Obtaining STB Reprints" "stb##obtain_reprints"}{...}
{title:Title}

{phang}
Stata Technical Bulletin


{marker description}{...}
{title:Description}

{pstd}
The {hi:Stata Technical Bulletin} (STB) was the predecessor of the 
{hi:Stata Journal} (SJ); see {manhelp sj R}.  The STB is described here.

{pstd}
The STB was a publication for and by Stata users; it provided a forum for
users of all disciplines and levels of sophistication.  STB reprints are
available in both printed and electronic form.
The STB reprints contain articles written by StataCorp, Stata
users, and others.  Articles have included enhancements to Stata (ado-files),
tutorials on programming strategies, illustrations of data analysis
techniques, discussions on teaching statistics, debates on appropriate
statistical techniques, reports on other programs, along with interesting
datasets, announcements, questions, and suggestions.

{pstd}
If you want reprints of the STB you must order them from StataCorp
(information on how is found below).  However, the software is available for
free from our website {browse "https://www.stata.com"}.

{pstd}
The bimonthly STB began publication in May 1991 and continued for ten years
(through May 2001).  The STB was the first publication of its kind for
statistical software users.  The
{browse "https://www.stata-journal.com":Stata Journal}, which began publication
fourth quarter 2001, expands upon this foundation.

{pstd}
As an example of what is available in the STB, the table of contents for the
March 2000 issue of the STB was

{center:{hline 70}}
{center:Multiple curves plotted with stcurve command  . . . . . . . . . . .  2}
{center:Search web for installable packages . . . . . . . . . . . . . . . .  4}
{center:Contrasts for categorical variables: update . . . . . . . . . . . .  7}
{center:ICD-9 diagnostic and procedure codes  . . . . . . . . . . . . . . .  8}
{center:Removing duplicate observations in a dataset  . . . . . . . . . . . 16}
{center:An update to drawing Venn diagrams  . . . . . . . . . . . . . . . . 17}
{center:Overlaying graphs . . . . . . . . . . . . . . . . . . . . . . . . . 19}
{center:Metadata for user-written contributions: extensions . . . . . . . . 21}
{center:Automated outbreak detection from public health surveillance data . 23}
{center:Concordance correlation coefficient: update for Stata 6 . . . . . . 25}
{center:Update to hotdeck imputation  . . . . . . . . . . . . . . . . . . . 26}
{center:Correction to roccomp command . . . . . . . . . . . . . . . . . . . 26}
{center:Box--Cox regression models  . . . . . . . . . . . . . . . . . . . . 27}
{center:On the manipulability of Wald tests in Box--Cox regression models . 36}
{center:Analysis of variance from summary statistics  . . . . . . . . . . . 42}
{center:Sequential and drop one term likelihood-ratio tests . . . . . . . . 46}
{center:Model selection using the Akaike information criterion  . . . . . . 47}
{center:Random allocation of treatments balanced in blocks: update  . . . . 49}
{center:{hline 70}}

{pstd}
To see the table of contents for any STB you can follow the steps outlined
below.


{marker software}{...}
{title:Obtaining community-contributed additions from the STB}

{pstd}
The STB community-contributed additions are easily obtained.
You can {net "from https://www.stata.com/stb":click here}

{p 4 15 2}Or {space 4} 1) Select {bf:Help > SJ and community-contributed programs}{p_end}
{p 12 15 2}2) Click on STB{p_end}

{pstd}
Or use the command line and type

	    {inp:. net from https://www.stata.com/stb}

{pstd}
See {helpb net}.  What to do next will be obvious.


{marker reprints}{...}
{title:STB Reprints}

{pstd}
The ten years of Stata Technical Bulletins have been reprinted in a series
of ten books -- {hi:Stata Technical Bulletin Reprints}.  Each Reprint contains
a year of the STB.

{center:{c TLC}{hline 11}{c TT}{hline 13}{c TT}{hline 34}{c TRC}}
{center:{c |}  Reprint  {c |}{space 13}{c |}{space 34}{c |}}
{center:{c |}  Volume   {c |}   Editor    {c |}       Includes STB Issues        {c |}}
{center:{c LT}{hline 11}{c +}{hline 13}{c +}{hline 34}{c RT}}
{center:{c |}  1 (1992) {c |} J. Hilbe    {c |}  1 (May 1991) --  6 (March 1992) {c |}}
{center:{c |}  2 (1993) {c |} J. Hilbe    {c |}  7 (May 1992) -- 12 (March 1993) {c |}}
{center:{c |}  3 (1994) {c |} S. Becketti {c |} 13 (May 1993) -- 18 (March 1994) {c |}}
{center:{c |}  4 (1995) {c |} S. Becketti {c |} 19 (May 1994) -- 24 (March 1995) {c |}}
{center:{c |}  5 (1996) {c |} S. Becketti {c |} 25 (May 1995) -- 30 (March 1996) {c |}}
{center:{c |}  6 (1997) {c |} H.J. Newton {c |} 31 (May 1996) -- 36 (March 1997) {c |}}
{center:{c |}  7 (1998) {c |} H.J. Newton {c |} 32 (May 1997) -- 42 (March 1998) {c |}}
{center:{c |}  8 (1999) {c |} H.J. Newton {c |} 43 (May 1998) -- 48 (March 1999) {c |}}
{center:{c |}  9 (2000) {c |} H.J. Newton {c |} 49 (May 1999) -- 54 (March 2000) {c |}}
{center:{c |} 10 (2001) {c |} H.J. Newton {c |} 55 (May 2000) -- 61 (May   2001) {c |}}
{center:{c BLC}{hline 11}{c BT}{hline 13}{c BT}{hline 34}{c BRC}}

{pstd}
The table of contents for each of the STB Reprint Volumes is posted on our
website:  {browse "https://www.stata.com/bookstore/stbj.html"}.


{marker obtain_reprints}{...}
{title:Obtaining STB reprints}

{pstd}
STB Reprints are available from StataCorp.

	    StataCorp
	    4905 Lakeway Drive
	    College Station, Texas 77845

	    {browse "https://www.stata.com"}
	    {browse "https://www.stata.com/bookstore/stbr.html"}
	    {browse "mailto:stata@stata.com":stata@stata.com}

	    800-782-8272  (800-STATAPC, USA)
	    800-248-8272  (Canada)
	    979-696-4600  (Worldwide)
	    979-696-4601  (Fax)
