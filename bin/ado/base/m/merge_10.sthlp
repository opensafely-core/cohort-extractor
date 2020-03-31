{smcl}
{* *! version 1.1.10  16apr2009}{...}
{* this help file does not appear in the manual}{...}
{cmd:help merge_10}{right:{help prdocumented:previously documented}}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{hi:[D] merge} {hline 2}}{cmd:merge} syntax prior to version 11{p_end}
{p2colreset}{...}

{p 12 12 8}
{it}[{bf:merge} syntax was changed as of version 11.
This help file documents {cmd:merge}'s old syntax and as such is 
probably of no interest to you.  You do not have to translate 
{cmd:merge}s in old do-files to modern syntax because Stata continues
to understand both old and new syntaxes.   This help file is 
provided for those wishing to debug or understand old code.
Click {help merge:here} for the help file of the modern 
{cmd:merge} command.]{rm}


{title:Syntax}

{p 8 15 2}
{opt mer:ge} [{varlist}] {cmd:using} {it:filename} [{it:filename} {cmd:...}]
[{cmd:,} {it:options}]

{synoptset 18 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Options}
{synopt :{opth keep(varlist)}}keep only the specified variables from data in
{it:filename}{p_end}
{synopt :{opth _merge(newvar)}}{it:newvar} marks source of resulting
observation; default is {opt _merge}{p_end}
{synopt :{opt nol:abel}}do not copy value label definitions from {it:filename}{p_end}
{synopt :{opt nonote:s}}do not copy notes from {it:filename}{p_end}
{synopt :{opt update}}replace missing data in memory with data from
{it:filename}{p_end}
{synopt :{opt replace}}replace nonmissing data in memory with data from
{it:filename}{p_end}
{synopt :{opt nok:eep}}drop observations in using dataset that do not match{p_end}
{synopt :{opt nos:ummary}}drop summary variables when multiple {it:filenames}
are specified{p_end}
{p2coldent :* {opt uniq:ue}}match variables uniquely identify observations in both
data in memory and in {it:filename}{p_end}
{p2coldent :* {opt uniqm:aster}}match variables uniquely identify observations in
memory{p_end}
{p2coldent :* {opt uniqus:ing}}match variables uniquely identify observations in
{it:filename}{p_end}
{p2coldent :* {opt sort}}sort master and using datasets by match
variables before merge; {opt sort} implies {opt unique} if {opt uniqmaster} or {opt uniqusing} is not specified{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt unique}, {opt uniqmaster}, {opt uniqusing}, and {opt sort}
require {it:varlist} (the match variables) be specified.{p_end}


{title:Description}

{pstd}
{cmd:merge} joins corresponding observations from the dataset currently
in memory (called the {it:master} dataset) with those from Stata-format
datasets stored as {it:filename} (called the {it:using} datasets) into
single observations.  If {it:filename} is specified without an extension,
{cmd:.dta} is assumed.

{pstd}
{cmd:merge} can perform both one-to-one and match merges.


{title:Options}

{dlgtab:Options}

{phang}
{opth keep(varlist)} specifies the variables to be kept from the using data.
If {opt keep()} is not specified, all variables are kept.

{pmore}
The {varlist} in {opt keep(varlist)} differs from standard Stata varlists in
two ways: variable names in {it:varlist} may not be abbreviated, except by the
use of wildcard characters; and you may not refer to a range of variables,
such as price-weight. 

{phang}
{opt _merge(newvar)} specifies the name of the variable to be created that
will mark the source of the resulting observation.  The default is
{cmd:_merge(_merge)}; that is, if you do not specify this option, the new
variable will be named {opt _merge}.

{phang}
{opt nolabel} prevents Stata from copying the value label definitions from the
using dataset into the result.  Even if you do not specify this
option, label definitions from the using dataset do not replace label
definitions in the master dataset.

{phang}
{opt nonotes} prevents {help notes} in the using data from being incorporated
into the result.  The default is to incorporate notes from the using data that
do not already appear in the master dataset.

{phang}
{opt update} specifies that the values from the using dataset be retained in
cases where the master dataset contains missing.  By default, the master
dataset is held inviolate -- values from the master dataset are retained
when the variables are found in both datasets.

{phang}
{opt replace}, allowed with {opt update} only, specifies that even when the
master dataset contains nonmissing values, they are to be replaced with
corresponding values from the using dataset when the corresponding values are
not equal.  A nonmissing value, however, will never be replaced with a missing
value.

{phang}
{opt nokeep} causes {cmd:merge} to ignore observations in the using dataset
that have no corresponding observation in the master.  The default is to add
these observations to the merged result and mark such observations with
{opt _merge}==2.

{phang}
{opt nosummary} causes {cmd:merge} to drop the summary variables created when
multiple using datasets are specified. The default is to create {cmd:_merge1}
recording results from merging the first disk dataset, {cmd:_merge2} recording
results from merging the second disk dataset, and so on.  {cmd:_merge1},
{cmd:_merge2}, ..., contain 1 if an observation was found in the respective
disk dataset and 0 otherwise.

{pmore}
Whether or not {cmd:nosummary} is specified, overall status variable
{cmd:_merge} is created.

{phang}
{opt unique}, {opt uniqmaster}, and {opt uniqusing} specify that the match
variables in a match-merge uniquely identify the observations.  Match variables
are required with {opt unique}, {opt uniqmaster}, and {opt uniqusing}.

{pmore}
{opt unique} specifies that the match variables uniquely identify the
observations in the master dataset and in the using dataset.  For most
match-merges, you should specify {opt unique}.  {cmd:merge} does nothing
differently when you specify the option, unless the assumption you are making
is false, in which case an error message is issued and the data are not merged. 

{pmore}
{opt uniqmaster} specifies that the match variables uniquely identify the
observations in memory, the master data, but not necessarily the ones in the
using dataset.

{pmore}
{opt uniqusing} specifies that the match variables uniquely identify the
observations in the using dataset, but not necessarily the ones in the master
dataset.

{pmore}
{opt unique} is thus equivalent to specifying {opt uniqmaster} and
{opt uniqusing}.

{pmore}
Things are more complicated when multiple using datasets are specified.
{opt unique} still means unique in all datasets, and {opt uniqusing} still
means unique in each of the using datasets, just as you would expect, but
{opt uniqmaster} takes on a whole new meaning:  {opt uniqmaster} means unique
in the master and in all using datasets except the last!  It asserts that the
match variables uniquely identify observations in the master at each step,
meaning that when the master is merged with the first using dataset, then when
the (new) master (equal to original plus first using) is merged with the
second using dataset, and so on.  In summary, {opt uniqmaster} is simply not
useful when multiple using datasets are specified.

{pmore}
If none of the three unique options are specified, observations in neither the
master nor the using dataset are required to be unique, although they could be.
If they are not unique, records that have the same values of the match
variables are joined by observation until all the records on one side or the
other are matched; after that, the final record on the shorter side is
duplicated over and over again to match with the remaining records needing 
to be matched on the longer side.

{phang}
{opt sort} specifies that the master and using datasets be sorted by
the match variables, before the datasets are merged, if they are not already
sorted by them.  Match variables are required with {opt sort}.  {opt sort}
implies {opt unique} if {opt uniqmaster} or {opt uniqusing} is not specified.


{title:Remarks}

{pstd}
{cmd:merge} can perform both one-to-one and match merges.  In either case,
the variable {cmd:_merge} (or the variable specified in {cmd:_merge()} if
provided) is added to the data containing

{center:_merge==1    obs. from master data                            }
{center:_merge==2    obs. from only one using dataset                 }
{center:_merge==3    obs. from at least two datasets, master or using }

{pstd}
{cmd:update} can be used only when there is one using file.  When
{cmd:update} is specified, the codes for {cmd:_merge} are

{center:_merge==1    obs. from master data                            }
{center:_merge==2    obs. from using data                             }
{center:_merge==3    obs. from both, master agrees with using         }
{center:_merge==4    obs. from both, missing in master updated        }
{center:_merge==5    obs. from both, master disagrees with using      }

{pstd}
When multiple using files are specified, a set of summary variables is created,
as long as {cmd:nosummary} is not used.  These summary variables are named
{cmd:_merge1} (related to the first using dataset), {cmd:_merge2} (related to
the second using dataset), etc. (or, once again, the variable specified in
{cmd:_merge()} if provided, followed by the number of the using file).  These
variables will contain 

{center:_merge{it:k}==0   obs. not present in corresponding using dataset  }
{center:_merge{it:k}==1   obs. present in corresponding using dataset      }

{pstd}
Variable labels identifying the dataset associated with each summary variable
are attached to these summary variables.


{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse odd}{p_end}
{phang2}{cmd:. list}{p_end}
{phang2}{cmd:. webuse even1}{p_end}
{phang2}{cmd:. list}

{pstd}Perform one-to-one merge{p_end}
{phang2}{cmd:. merge using http://www.stata-press.com/data/r11/odd}{p_end}
{phang2}{cmd:. list}

    {hline}
    Setup
{phang2}{cmd:. webuse even1, clear}{p_end}

{pstd}Perform match-merge{p_end}
{phang2}{cmd:. merge number using http://www.stata-press.com/data/r11/odd, sort}
{p_end}
{phang2}{cmd:. list}{p_end}
{phang2}{cmd:. sort number}{p_end}
{phang2}{cmd:. list}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse autotech, clear}{p_end}
{phang2}{cmd:. describe}{p_end}
{phang2}{cmd:. describe using http://www.stata-press.com/data/r11/autocost}
{p_end}

{pstd}Perform match-merge{p_end}
{phang2}{cmd:. merge make using http://www.stata-press.com/data/r11/autocost}{p_end}
{phang2}{cmd:. tabulate _merge}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse dollars, clear}{p_end}
{phang2}{cmd:. list}{p_end}
{phang2}{cmd:. webuse sforce}{p_end}
{phang2}{cmd:. list}{p_end}

{pstd}Perform match-merge with spreading{p_end}
{phang2}{cmd:. merge region using http://www.stata-press.com/data/r11/dollars}
{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse odd3, clear}{p_end}
{phang2}{cmd:. list}{p_end}
{phang2}{cmd:. webuse letter}{p_end}
{phang2}{cmd:. list}{p_end}
{phang2}{cmd:. webuse even}{p_end}
{phang2}{cmd:. list}{p_end}

{pstd}Perform match-merge with multiple datasets{p_end}
{phang2}{cmd:. merge number using http://www.stata-press.com/data/r11/odd3}
        {cmd:http://www.stata-press.com/data/r11/letter}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse original, clear}{p_end}
{phang2}{cmd:. list}{p_end}
{phang2}{cmd:. webuse updates}{p_end}
{phang2}{cmd:. list}{p_end}
{phang2}{cmd:. webuse original}{p_end}

{pstd}Update data with match-merge{p_end}
{phang2}{cmd:. merge make using http://www.stata-press.com/data/r11/updates,}
           {cmd:update}{p_end}
{phang2}{cmd:. list}{p_end}
    {hline}


{title:Also see}

{psee}
Manual:  {help prdocumented:previously documented}

{psee}
{space 2}Help:  {manhelp merge D}
{p_end}
