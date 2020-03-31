{smcl}
{* *! version 1.1.0  15nov2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] cscript" "help cscript"}{...}
{viewerjumpto "Syntax" "storedresults##syntax"}{...}
{viewerjumpto "Description" "storedresults##description"}{...}
{viewerjumpto "Options" "storedresults##options"}{...}
{viewerjumpto "Remarks" "storedresults##remarks"}{...}
{title:Title}

{p 4 26 2}
{hi:[P] storedresults} {hline 2} Manipulate and verify stored results r() and e()


{marker syntax}{...}
{title:Syntax}

{p 8 30 2}{cmd:storedresults} {cmdab:sav:e} {space 3} {it:name} {{cmd:r()}|{cmd:e()}}

{p 8 30 2}{cmd:storedresults} {cmdab:comp:are} {it:name} {{cmd:r()}|{cmd:e()}}
[{cmd:,} {cmdab:tol:erance:(}{it:#}{cmd:)} {cmdab:rev:erse} {cmdab:v:erbose}
{cmdab:ex:clude:(}{it:list}{cmd:)} {cmdab:in:clude:(}{it:list}{cmd:)} ]

{p 8 30 2}{cmd:storedresults} {cmd:drop} {space 3} {it:name}


{p 4 4 2}where list is

{p 8 15 2}{it:class}{cmd::} {it:name} [{it:name} [{it:...}]] [{it:list}]

{pstd}
and {it:class} is {cmd:macro}, {cmd:macros}, {cmd:matrix}, {cmd:matrices},
{cmd:scalar}, or {cmd:scalars}.


{pstd}
This command is intended for authors of certification scripts -- do-files
used to test that commands work properly; see {manhelp cscript P}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:storedresults} allows easy saving of the {hi:r()} or {hi:e()} stored
results produced by a command and then later comparing other stored results
with them.

{pstd}
{cmd:storedresults save} saves {hi:r()} or {hi:e()} under the name specified.

{pstd}
{cmd:storedresults compare} compares the current {hi:r()} or {hi:e()}
results with those previously saved.  If they are different, return code 9 is
produced.

{pstd}
{cmd:storedresults drop} eliminates previously stored results from memory. 


{marker options}{...}
{title:Options}

{phang}
{cmd:tolerance(}{it:#}{cmd:)} specifies the tolerance for numeric
comparisons.  The default is 0, meaning numerical results are required to be
exactly equal.

{pmore}
Comparisons between scalars are made using the {cmd:reldif()} function
and comparing the results to {cmd:tolerance()}.

{pmore}
Comparisons between matrices are made using the {cmd:mreldif()}
function and comparing the results to {cmd:tolerance()}.

{pmore}
Comparisons between macros, if both contain numbers, is made using the
{cmd:reldif()} function and comparing the results to {cmd:tolerance()}.  If
the previous results, current results, or both, for a particular macro
do not contain numbers, then a string comparison is made between them and
{cmd:tolerance()} is irrelevant for that comparison.

{phang}
{cmd:reverse} might affect which {hi:r()} or {hi:e()} results are
checked.  The default is to compare all the previously stored results with
current results, which means if an extra result is currently stored, that will
not be detected.  On the other hand, if a result was previously stored and is
not stored now, that will be detected and, of course, when results were stored
both previously and currently, they will be compared.

{pmore}
{cmd:reverse} turns this around.  {cmd:reverse} specifies that the
currently stored results are to be compared with what was previously stored.
This means if a result is now stored that was not stored previously, it will be
detected but, of course, previously stored results that are not now stored will
go undetected.

{pmore}
The only way to be certain that the same results were stored both
previously and now is to run the command twice, once with and once without the
{cmd:reverse} option.  Most authors of certification scripts, however, do not
do that, nor do they bother to specify {cmd:reverse}.

{phang}
{cmd:verbose} specifies that a list is to be displayed of what is being
checked.  The default is to produce output only when there are problems.

{phang}
{cmd:exclude(}{it:list}{cmd:)} specifies that, from the list of all
stored results (meaning all stored results previously, or all stored results
now; see the {cmd:reverse} option above), the list of results specified is to be
excluded from the comparison.  The items in the {cmd:exclude()} list might not
be stored at all (in which case there would be no reason to specify them),
stored in previously but not currently, stored currently but not previously, or
stored both times but you do not care if they have different values.

{pmore}
Specifying {cmd:exclude()} allows you to check a subset of the returned
results.

{pmore}
For instance, if you wished to exclude the stored macros {hi:e(if)},
{hi:e(in)}, the stored scalar {hi:e(N)}, and the stored matrix {hi:e(V)}, you
could specify

{phang3}{cmd:. storedresults comp} {it:...}{cmd:, exclude(macros: if in  scalar: N  matrix: V)}

{phang}
{cmd:include(}{it:list}{cmd:)} specifies that only the stored results
specified are to be compared.  The {it:list} has the same syntax as when used
with {cmd:exclude()}, just the meaning is reversed.


{marker remarks}{...}
{title:Remarks}

{pstd}
In a certification script, one sometimes wants to verify that the same
results are obtained when the command is run two different ways.  For
instance, if we were testing {helpb summarize}, we might want to verify that
the {cmd:if} {it:exp} modifier works:

{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. keep if foreign}{p_end}
{phang2}{cmd:. summarize mpg}{p_end}
{phang2}{cmd:. storedresults save mustbetrue r()}

{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. summarize mpg if foreign}{p_end}
{phang2}{cmd:. storedresults compare mustbetrue r()}

{phang2}{cmd:. storedresults drop mustbetrue}

{pstd}
For your edification, it is useful to change the middle part of this script
to read

{phang2}{cmd:. use auto, clear}{p_end}
{phang2}{cmd:. summarize mpg} {space 2} /* omit the if foreign */{p_end}
{phang2}{cmd:. storedresults compare mustbetrue r()} {space 2} /* so this is not true */

{pstd}
Running the first version of the script, {cmd:storedresults} will produce no
output.  Running the second version, {cmd:storedresults} will produce detailed
output highlighting the differences in the stored result and, more importantly,
will end with a return code of 9, meaning the certification script will stop.

{pstd}
As a second example, consider writing a script to verify that
{helpb regress} works with frequency weights:

{phang2}{cmd:. use auto, clear}{p_end}
{phang2}{cmd:. expand mpg}{p_end}
{phang2}{cmd:. regress price weight foreign}{p_end}
{phang2}{cmd:. storedresults save unweighted e()}

{phang2}{cmd:. use auto, clear}{p_end}
{phang2}{cmd:. regress price weight foreign [fw=mpg]}{p_end}
{phang2}{cmd:. storedresults compare unweighted e(), tol(1e-14)}

{phang2}{cmd:. storedresults drop unweighted}

{pstd}
Here the {cmd:tolerance()} option is required because, when this
test script was tried without it, it was found that results had a maximum
relative difference of about 4e-15, which was deemed to be acceptable.  (In
the final form of the test script, the final tolerance was lightened from the
4e-15 observed to 1e-14, for no good reason).
{p_end}
