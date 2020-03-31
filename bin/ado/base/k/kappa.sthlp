{smcl}
{* *! version 1.1.10  19oct2017}{...}
{viewerdialog "kap (2 raters)" "dialog kap_uniq"}{...}
{viewerdialog kapwgt "dialog kapwgt"}{...}
{viewerdialog "kap (2+ raters)" "dialog kap_nonuniq"}{...}
{viewerdialog kappa "dialog kappa"}{...}
{vieweralsosee "[R] kappa" "mansection R kappa"}{...}
{viewerjumpto "Syntax" "kappa##syntax"}{...}
{viewerjumpto "Menu" "kappa##menu"}{...}
{viewerjumpto "Description" "kappa##description"}{...}
{viewerjumpto "Links to PDF documentation" "kappa##linkspdf"}{...}
{viewerjumpto "Options" "kappa##options"}{...}
{viewerjumpto "Remarks" "kappa##remarks"}{...}
{viewerjumpto "Examples" "kappa##examples"}{...}
{viewerjumpto "Stored results" "kappa##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] kappa} {hline 2}}Interrater agreement{p_end}
{p2col:}({mansection R kappa:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Interrater agreement, two unique raters

{p 8 12 2}
{cmd:kap} {it:{help varname:varname1}} {it:{help varname:varname2}} {ifin}
[{it:{help kappa##weight:weight}}]
[{cmd:,} {it:{help kappa##options_table:options}}]


{phang}
Weights for weighting disagreements

{p 8 15 2}
{cmd:kapwgt} {it:wgtid} [{cmd:1} {cmd:\} {it:#} {cmd:1} [{cmd:\} {it:#}
{it:#} {cmd:1} {it:...}]]


{phang}
Interrater agreement, nonunique raters, variables record ratings for each rater

{p 8 12 2}
{cmd:kap} {it:{help varname:varname1}} {it:{help varname:varname2}}
{it:{help varname:varname3}} [{it:...}] {ifin}
[{it:{help kappa##weight:weight}}]


{phang}
Interrater agreement, nonunique raters, variables record frequency of ratings

{p 8 14 2}
{cmd:kappa} {varlist} {ifin}


{synoptset 14 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt t:ab}}display table of assessments{p_end}
{synopt :{opt w:gt(wgtid)}}specify how to weight disagreements; see 
          {it:{help kappa##options:Options}} for alternatives{p_end}
{synopt :{opt a:bsolute}}treat rating categories as absolute{p_end}
{synoptline}
{p2colreset}{...}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

    {title:kap: two unique raters}

{phang2}
{bf:Statistics > Epidemiology and related > Other >}
     {bf:Interrater agreement, two unique raters}

    {title:kapwgt}

{phang2}
{bf:Statistics > Epidemiology and related > Other >}
      {bf:Define weights for the above (kap)}

    {title:kap: nonunique raters}

{phang2}
{bf:Statistics > Epidemiology and related > Other >}
      {bf:Interrater agreement, nonunique raters}

    {title:kappa}

{phang2}
{bf:Statistics > Epidemiology and related > Other >}
       {bf:Interrater agreement, nonunique raters with frequencies}


{marker description}{...}
{title:Description}

{pstd}
{cmd:kap} and {cmd:kappa} calculate the kappa-statistic measure of interrater
agreement.  {cmd:kap} calculates the statistic for two unique raters or at
least two nonunique raters.  {cmd:kappa} calculates only the statistic for
nonunique raters, but it handles the case where data have been recorded as
rating frequencies.  {cmd:kapwgt} defines weights used by {cmd:kap} in
measuring the importance of disagreements.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R kappaQuickstart:Quick start}

        {mansection R kappaRemarksandexamples:Remarks and examples}

        {mansection R kappaMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt tab} displays a tabulation of the assessments by the two raters.

{phang}
{opt wgt(wgtid)} specifies that {it:wgtid} be used to weight disagreements.
You can define your own weights by using {cmd:kapwgt}; {opt wgt()} then
specifies the name of the user-defined matrix.  For instance, you might define

{phang3}
{cmd:. kapwgt mine 1 \ .8 1 \ 0 .8 1 \ 0 0 .8 1}

{pmore}
and then 

{phang3}
{cmd:. kap rata ratb, wgt(mine)}

{pmore}
Also, two prerecorded weights are available.

{pmore}
{cmd:wgt(w)} specifies weights 1-|i-j|/(k-1),
  where i and j index the rows and columns of the ratings by the two
  raters and k is the maximum number of possible ratings.

{pmore}
{cmd:wgt(w2)} specifies weights 1 - {c -(}(i-j)/(k-1){c )-}^2.

{phang}
{cmd:absolute} is relevant only if {opt wgt()} is also specified.  The
{opt absolute} option modifies how i, j, and k are defined and how corresponding
entries are found in a user-defined weighting matrix.  When {opt absolute} is
not specified, i and j refer to the row and column index, not to the ratings
themselves.  Say that the ratings are recorded as {c -(}0,1,1.5,2{c )-}.  There
are four ratings; k=4, and i and j are still 1, 2, 3, and 4 in the formulas
above.  Index 3, for instance, corresponds to rating=1.5.  This system is
convenient but can, with some data, lead to difficulties.

{pmore}
When {opt absolute} is specified, all ratings must be integers, and they
  must be coded from the set {c -(}1,2,3,...{c )-}.  Not all values need be
  used; integer values that do not occur are simply assumed to be unobserved.


{marker remarks}{...}
{title:Remarks}

{pstd}
You have data on individual patients.  There are two raters, and the possible 
ratings are 1, 2, 3, and 4, but neither rater ever used rating 3
Here {cmd:kap} would determine that the ratings
are from the set {c -(}1,2,4{c )-} because those were the only values
observed.  {cmd:kap} would expect a user-defined weighting matrix would be 3x3
and, if it were not, {cmd:kap} would issue an error message.  In the
formula-based weights, {cmd:wgt(w)} and {cmd:wgt(w2)}, the calculation would be
based on i,j = 1,2,3 corresponding to the three observed ratings 
{c -(}1,2,4{c )-}.

{pstd}
Specifying the {cmd:absolute} option would make it clear that the ratings are
1, 2, 3, and 4; it just so happens that rating==3 was never assigned.  If a 
user-defined weighting matrix were also specified, {cmd:kap} would expect it
to be 4x4 or larger (larger because one can think of the ratings being 1, 2,
3, 4, 5, ... and it just so happens that ratings 5, 6, ... were never
observed, just as rating==3 was not observed).  In the formula-based weights,
the calculation would be based on i,j = 1,2,4.

{pstd}
If all conceivable ratings are observed in the data, specifying
{cmd:absolute} makes no difference.


{marker examples}{...}
{title:Examples:  two raters}

{phang2}{cmd:. webuse rate2}{p_end}
{phang2}{cmd:. kap rada radb}{p_end}
{phang2}{cmd:. kap rada radb, tab}{p_end}
{phang2}{cmd:. kap rada radb, wgt(w)}{space 8}(weighted kappa, prerecorded
weight w){p_end}
{phang2}{cmd:. kap rada radb, wgt(w) absolute}{space 12}(some ratings unobserved)

{pstd}
Assume that the two raters rate patients into four categories.  You want to use
the weighting matrix:

{center:Rater A {c |}  normal  benign  suspect  cancer}
{center:{hline 8}{c +}{hline 33}}
{center: normal {c |}    1       .8       0        0  }
{center: benign {c |}   .8        1       0        0  }
{center:suspect {c |}    0        0       1       .8  }
{center: cancer {c |}    0        0      .8        1  }

    You type

{phang2}{cmd:. kapwgt xm 1 \ .8 1 \ 0 0 1 \ 0 0 .8 1} {space 13} (define matrix){p_end}
{phang2}{cmd:. kapwgt xm} {space 27} (print matrix, check correct){p_end}
{phang2}{cmd:. kap rada radb, wgt(xm)} {space 17} (calculate weighted kappa)

{phang2}{cmd:. kap rada radb, wgt(xm) absolute} {space 9} (some ratings unobserved)


{title:Example:  more than two raters, two ratings}

{phang2}{cmd:. webuse p612}{p_end}
{phang2}{cmd:. gen neg = raters - pos}{p_end}
{phang2}{cmd:. kappa pos neg}

{pstd}
{cmd:pos} records the number of raters assessing "positive", {cmd:neg} the
number of raters assessing "negative".

{pstd}
{cmd:pos} records the number of raters assessing "positive", {cmd:neg} the
number of raters assessing "negative".


{title:Example:  more than two raters, more than two ratings, fixed number of raters}

{phang2}{cmd:. webuse p615, clear}{p_end}
{phang2}{cmd:. kappa cat1 cat2 cat3}

{pstd}
{cmd:cat1} records the number of raters assessing category 1; {cmd:cat2}, the
number assessing category 2; and {cmd:cat3}, the number of raters assessing
category 3.  The sum of {cmd:cat1}, {cmd:cat2}, and {cmd:cat3} is constant for
each observation in the data.


{title:Example: more than two raters, more than two ratings, varying number of raters}

{phang2}{cmd:. webuse rvary}{p_end}
{phang2}{cmd:. kappa cat1 cat2 cat3}

{pstd}
This is the same as with a fixed number of raters, except {cmd:cat1} +
{cmd:cat2} + {cmd:cat3} is not constant across observations.  Kappa will be
calculated, but there is no statistic for testing kappa>0 and so none will be
reported.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:kap} and {cmd:kappa} store the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of subjects ({cmd:kap} only){p_end}
{synopt:{cmd:r(prop_o)}}observed proportion of agreement ({cmd:kap} only){p_end}
{synopt:{cmd:r(prop_e)}}expected proportion of agreement ({cmd:kap} only){p_end}
{synopt:{cmd:r(kappa)}}kappa{p_end}
{synopt:{cmd:r(z)}}z statistic{p_end}
{synopt:{cmd:r(se)}}standard error for kappa statistic{p_end}
{p2colreset}{...}
