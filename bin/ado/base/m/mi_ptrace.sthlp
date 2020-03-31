{smcl}
{* *! version 1.0.16  19apr2019}{...}
{vieweralsosee "[MI] mi ptrace" "mansection MI miptrace"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi impute mvn" "help mi_impute_mvn"}{...}
{viewerjumpto "Syntax" "mi_ptrace##syntax"}{...}
{viewerjumpto "Description" "mi_ptrace##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_ptrace##linkspdf"}{...}
{viewerjumpto "Options" "mi_ptrace##options"}{...}
{viewerjumpto "Remarks" "mi_ptrace##remarks"}{...}
{viewerjumpto "Stored results" "mi_ptrace##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[MI] mi ptrace} {hline 2}}Load parameter-trace file into Stata
{p_end}
{p2col:}({mansection MI miptrace:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi} {cmd:ptrace}
{cmdab:d:escribe}
[{cmd:using}] {it:{help filename}}


{p 8 12 2}
{cmd:mi} {cmd:ptrace}
{cmd:use} {it:{help filename}}
[{cmd:,} 
{it:use_options}]

{synoptset 20}{...}
{synopthdr:use_options}
{synoptline}
{synopt:{cmd:clear}}okay to replace existing data in memory{p_end}
{synopt:{cmd:double}}load variables as doubles (default is floats){p_end}
{synopt:{cmdab:sel:ect(}{it:selections}{cmd:)}}what to load (default is all){p_end}
{synoptline}
{p2colreset}{...}

{pstd}
where {it:selections} is a space-separated list of individual selections.
Individual selections are of the form 

			{cmd:b[}{it:yname}{cmd:,} {it:xname}{cmd:]}
			{cmd:v[}{it:yname}{cmd:,} {it:yname}{cmd:]}

{pstd}
where {it:yname}s and {it:xname}s are displayed by {cmd:mi} {cmd:ptrace}
{cmd:describe}.  You may also specify 

			{cmd:b[}{it:#_y}{cmd:,} {it:#_x}{cmd:]}
			{cmd:v[}{it:#_y}{cmd:,} {it:#_y}{cmd:]}

{pstd}
where {it:#_y} and {it:#_x} are the variable numbers associated with 
{it:yname} and {it:xname}, and those too are shown by {cmd:mi} {cmd:ptrace}
{cmd:describe}.

{pstd}
For {cmd:b}, you may also specify {cmd:*} to mean all possible 
index elements.  For instance, 

{col 25}{cmd:b[*,*]}{col 38}all elements of {cmd:b}
{col 25}{cmd:b[}{it:yname}{cmd:,*]}{col 38}row corresponding to {it:yname}
{col 25}{cmd:b[*,}{it:xname}{cmd:]}{col 38}column corresponding to {it:xname}

{pstd}
Similarly, {cmd:b[}{it:#_y}{cmd:,*]} and 
{cmd:b[*,}{it:#_x}{cmd:]} are allowed.
The same is allowed for {cmd:v}, and also, the second element 
can be specified as 
{cmd:<}, {cmd:<=}, {cmd:=}, {cmd:>=}, or {cmd:>}.  For instance, 

{col 25}{cmd:v[}{it:yname}{cmd:,=]}{col 38}variance of {it:yname}
{col 25}{cmd:v[}{cmd:*,=]}{col 38}all variances (diagonal elements)
{col 25}{cmd:v[}{cmd:*,<]}{col 38}lower triangle
{col 25}{cmd:v[}{cmd:*,<=]}{col 38}lower triangle and diagonal
{col 25}{cmd:v[}{cmd:*,>=]}{col 38}upper triangle and diagonal
{col 25}{cmd:v[}{cmd:*,>]}{col 38}upper triangle

{p 4 4 2}
In {cmd:mi} {cmd:ptrace} {cmd:describe} and 
in {cmd:mi} {cmd:ptrace} {cmd:use}, 
{it:filename} must be specified in quotes if it contains special 
characters or blanks.  {it:filename} is assumed to be 
{it:filename}{cmd:.stptrace} if the suffix is not specified.


{marker description}{...}
{title:Description}

{p 4 4 2}
Parameter-trace files, files with suffix {cmd:.stptrace}, are created 
by the {cmd:saveptrace()} option of 
{bf:{help mi_impute_mvn:mi impute mvn}}.
These are not Stata datasets, but they can be loaded as if they were 
by using {cmd:mi} {cmd:ptrace} {cmd:use}.
Their contents can be described without loading them by using 
{cmd:mi} {cmd:ptrace} {cmd:describe}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miptraceRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{p 4 8 2}
{cmd:clear}
    specifies that it is okay to clear the dataset in memory, even if 
    it has not been saved to disk since it was last changed.

{p 4 8 2}
{cmd:double} 
    specifies that elements of {cmd:b} and {cmd:v} are to be loaded 
    as doubles; they are loaded as floats by default.

{p 4 8 2}
{cmd:select(}{it:selections}{cmd:)}
    allows you to load subsets of {cmd:b} and {cmd:v}.  If the option 
    is not specified, all of {cmd:b} and {cmd:v} are loaded.  That result 
    is equivalent to specifying {cmd:select(b[*,*]} {cmd:v[*,<=])}.
    The {cmd:<=} specifies that just the diagonal and lower triangle of 
    symmetric matrix {cmd:v} be loaded.

{p 8 8 2}
    Specifying {cmd:select(b[*,*])} would load just {cmd:b}.

{p 8 8 2}
    Specifying {cmd:select(v[*,<=])} would load just {cmd:v}.

{p 8 8 2}
    Specifying {cmd:select(b[*,*]} {cmd:v[*,=])} would load {cmd:b} and the 
    diagonal elements of {cmd:v}.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Say that we impute the values of {it:y1} and {it:y2} assuming that 
they are multivariate normal distributed, with 
their means determined by a linear combination of 
{it:x1}, {it:x2}, and {it:x3}, and their variance constant.
Writing this more concisely,
{bf:y} = ({it:y1},{it:y2})' is distributed MVN({bf:X}{bf:B}, {bf:V}),
where {bf:B}: 2 {it:x} 3 and {bf:V}: 2 {it:x} 2.
If we use MCMC or EM procedures to produce values of {bf:B} and {bf:V} 
to be used to generate values for {bf:y}, we must
ensure that we use sufficient iterations so that the iterative procedure
stabilizes.  {helpb mi impute mvn} provides the worst linear combination (WLC)
of the elements of {bf:B} and {bf:V}.  If we want to perform other checks, we
can specify {cmd:mi} {cmd:impute} {cmd:mvn}'s
{cmd:saveptrace(}{it:filename}{cmd:)} option.  {cmd:mi} {cmd:impute} then
produces a file containing {cmd:m} (imputation number), {cmd:iter} (overall
iteration number), and the corresponding {cmd:B} and {cmd:V}.  The last
{cmd:iter} for each {cmd:m} is the {cmd:B} and {cmd:V} that {cmd:mi}
{cmd:impute} {cmd:mvn} used to impute the missing values.

{p 4 4 2}
When we used {cmd:mi} {cmd:impute} {cmd:mvn}, we specified burn-in and
burn-between numbers, say, {cmd:burnin(300)} and {cmd:burnbetween(100)}.  If
we also specified {cmd:saveptrace()}, the file produced is organized 
as follows:

{col 9}record # {c |}    {cmd:m}    {cmd:iter}       {bf:B}       {bf:V}
{col 9}{hline 9}{c +}{hline 29}
{col 12}    1 {c |}    1    -299     ...     ...
{col 12}    2 {c |}    1    -298     ...     ...
{col 12}    . {c |}    .       .       .       . 
{col 12}    . {c |}    .       .       .       .
{col 12}  299 {c |}    1      -1     ...     ...
{col 12}  300 {c |}    1       0     ...     ...  <- used to impute {it:m}=1
{col 12}  301 {c |}    2       1       .       .
{col 12}  302 {c |}    2       2       .       .
{col 12}    . {c |}    .       .       .       . 
{col 12}    . {c |}    .       .       .       .
{col 12}  399.{c |}    1      99     ...     ...
{col 12}  400.{c |}    1     100     ...     ...  <- used to impute {it:m}=2
{col 12}  401.{c |}    2     101     ...     ...
{col 12}    . {c |}    .       .       .       . 
{col 12}    . {c |}    .       .       .       .
{col 9}{hline 9}{c BT}{hline 29}

{p 4 4 2} 
The file is not a Stata dataset, but 
{cmd:mi} {cmd:ptrace} {cmd:use} can load the file and convert it into 
Stata format, and then it will look just like the above except

{p 8 12 2}
o  Record number will become the Stata observation number. 

{p 8 12 2}
o  {bf:B} will become variables 
    {cmd:b_y1x1}, {cmd:b_y1x2}, and {cmd:b_y1x3}; and 
    {cmd:b_y2x1}, {cmd:b_y2x2}, and {cmd:b_y2x3}.
    (Remember, we had 2 {it:y} variables and 3 {it:x} variables.)

{p 8 12 2}
o  {bf:V} will become variables 
    {cmd:v_y1y1}, {cmd:v_y2y1}, and {cmd:v_y2y2}.
    (This is the diagonal and lower triangle of {bf:V}; 
     variable {cmd:v_y1y2} is not created because it would be equal 
     to {cmd:v_y2y1}.)

{p 8 12 2}
o  Variable labels will be filled in with the underlying names 
    of the variables.  For instance, the variable label for 
    {cmd:b_y1x1} might be "experience, age", and that would 
    remind us that {cmd:b_y1x1} contains the coefficient on 
    age used to predict experience.
    {cmd:v_y2y1} might be "education, experience", and that would 
    remind us that {cmd:v_y2y1} contains the covariance between 
    education and experience.


{marker results}{...}
{title:Stored results}

{p 4 4 2}
{cmd:mi ptrace describe} stores the following in {cmd:r()}:

	Scalars
	    {cmd:r(tc)}   {cmd:%tc} date-and-time file created
	    {cmd:r(nx)}   number of {it:x} variables (columns of {bf:B})
	    {cmd:r(ny)}   number of {it:y} variables (rows of {bf:B})

	Macros
	    {cmd:r(x)}    space-separated [{it:op}{cmd:.}]{it:varname} of {it:x}
	    {cmd:r(y)}    space-separated [{it:op}{cmd:.}]{it:varname} of {it:y}
