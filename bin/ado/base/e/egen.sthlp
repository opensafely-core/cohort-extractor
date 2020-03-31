{smcl}
{* *! version 1.2.22  06aug2018}{...}
{viewerdialog egen "dialog egen"}{...}
{vieweralsosee "[D] egen" "mansection D egen"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] collapse" "help collapse"}{...}
{vieweralsosee "[D] generate" "help generate"}{...}
{viewerjumpto "Syntax" "egen##syntax"}{...}
{viewerjumpto "Menu" "egen##menu"}{...}
{viewerjumpto "Description" "egen##description"}{...}
{viewerjumpto "Links to PDF documentation" "egen##linkspdf"}{...}
{viewerjumpto "Examples" "egen##examples"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[D] egen} {hline 2}}Extensions to generate{p_end}
{p2col:}({mansection D egen:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:egen} {dtype} {newvar} {cmd:=} {it:fcn}{cmd:(}{it:arguments}{cmd:)} {ifin} 
[{cmd:,} {it:options}]

{phang}
{cmd:by} is allowed with some of the {cmd:egen} functions, as noted below.

{phang}
where depending on the {it:fcn}, {it:arguments} refers to an expression,
{it:varlist}, or {it:numlist}, and the {it:options} are also {it:fcn}
dependent, and where {it:fcn} is

{phang2}{opth anycount(varlist)}{cmd:,}
{opt v:alues}{cmd:(}{it:integer} {it:{help numlist}}{cmd:)}{p_end}
{pmore2}may not be combined with {cmd:by}.  It returns the number of variables 
in {it:varlist} for which values are equal to any integer value in a
supplied {it:numlist}.  Values for any observations excluded by either
{helpb if} or {helpb in} are set to 0 (not missing).  Also see
{opt anyvalue(varname)} and {opt anymatch(varlist)}.

{phang2}
{opth anymatch(varlist)}{cmd:,}
{opt v:alues}{cmd:(}{it:integer} {it:{help numlist}}{cmd:)}{p_end}
{pmore2}
may not be combined with {cmd:by}.  It is 1 if any variable in
{it:varlist} is equal to any integer value in a supplied
{it:numlist} and 0 otherwise.  Values for any observations excluded by either
{helpb if} or {helpb in} are set to 0 (not missing).  Also see
{opt anyvalue(varname)} and {opt anycount(varlist)}.

{phang2}
{opth anyvalue(varname)}{cmd:,}
{opt v:alues}{cmd:(}{it:integer} {it:{help numlist}}{cmd:)}{p_end}
{pmore2}
may not be combined with {cmd:by}.  It takes the value of {it:varname} if
{it:varname} is equal to any integer value in a supplied {it:numlist}
and is missing otherwise.  Also see {opt anymatch(varlist)} and 
{opt anycount(varlist)}.

{phang2}
{opth concat(varlist)} [{cmd:,} {opth f:ormat(%fmt)} {opt d:ecode}
{opt maxl:ength(#)} {opt p:unct}{cmd:(}{it:pchars}{cmd:)}]{p_end}
{pmore2}
may not be
combined with {cmd:by}.  It concatenates {it:varlist} to produce a string
variable.  Values of string variables are unchanged.  Values of numeric
variables are converted to string, as is, or are converted
using a numeric format under the {cmd:format(%}{it:fmt}{cmd:)} option or
decoded under the {opt decode} option, in which case {opt maxlength()} may also
be used to control the maximum label length used.  By default, variables are
added end to end: {opt punct(pchars)} may be used to specify punctuation, such
as a space, {cmd:punct(" ")}, or a comma, {cmd:punct(,)}.

        {opth count(exp)} {right:(allows {help by:{bf:by} {it:varlist}{bf::}})  }
{pmore2}
creates a constant (within {it:varlist}) containing the number of nonmissing
observations of {it:exp}.  Also see 
{help egen##rownonmiss():{bf:rownonmiss()}} and
{help egen##rowmiss():{bf:rowmiss()}}.

{phang2}
{opth cut(varname)}{cmd:,}
{c -(}{cmd:at(}{it:#}{cmd:,}{it:#}{cmd:,}{it:...}{cmd:,}{it:#}{cmd:)}|{opt g:roup}{cmd:(}{it:#}{cmd:)}{c )-} [{opt ic:odes} {opt lab:el}]{p_end}
{pmore2}
may not be combined with {cmd:by}.  It creates a new categorical variable
coded with the left-hand ends of the grouping intervals specified in the
{opt at()} option, which expects an ascending numlist.

{pmore2}
{cmd:at(}{it:#}{cmd:,}{it:#}{cmd:,}{it:...}{cmd:,}{it:#}{cmd:)}
supplies the breaks for the groups, in ascending order.  The list of
breakpoints may be simply a list of numbers separated by commas but can also
include the syntax {cmd:a(b)c}, meaning from {cmd:a} to {cmd:c} in steps of
size {cmd:b}.  {newvar} is set to missing for observations with {it:varname}
less than the first number specified in {cmd:at()} and for observations with
{it:varname} greater than or equal to the last number specified in {cmd:at()}.
If no breaks are specified, the command expects the {opt group()} option.  

{pmore2}
{opt group(#)} specifies the number of equal frequency grouping intervals to
be used in the absence of breaks.  Specifying this option automatically
invokes {opt icodes}.

{pmore2}
{opt icodes} requests that the codes 0, 1, 2, etc., be used in place of
the left-hand ends of the intervals.

{pmore2}
{cmd:label} requests that the integer-coded values of the grouped
variable be labeled with the left-hand ends of the grouping intervals.
Specifying this option automatically invokes {opt icodes}.

{phang2}
{opth diff(varlist)}{p_end}
{pmore2}
may not be combined with {cmd:by}.  It creates an indicator variable equal to
1 if the variables in {it:varlist} are not equal and 0 otherwise.

{phang2}
{opt ends}{cmd:(}{it:strvar}{cmd:)} [{cmd:,} {cmdab:p:unct:(}{it:pchars}{cmd:)}
{cmdab:tr:im} [{cmdab:h:ead}|{cmdab:l:ast}|{cmdab:t:ail}]]{p_end}
{pmore2}
may not be combined with {cmd:by}.  It gives the first "word" or head (with
the {opt head} option), the last "word" (with the {opt last} option), or the
remainder or tail (with the {opt tail} option) from string variable
{it:strvar}.

{pmore2}
{opt head}, {opt last}, and {opt tail} are determined by the occurrence
of {it:pchars}, which is by default one space (" ").

{pmore2}
The head is whatever precedes the first occurrence of {it:pchars}, or
the whole of the string if it does not occur.  For example, the head of
"frog toad" is "frog" and that of "frog" is "frog".  With {cmd:punct(,)}, the
head of "frog,toad" is "frog".

{pmore2}
The last word is whatever follows the last occurrence of {it:pchars} or
is the whole of the string if a space does not occur.  The last word of "frog
toad newt" is "newt" and that of "frog" is "frog".  With {cmd:punct(,)}, the
last word of "frog,toad" is "toad".

{pmore2}
The remainder or tail is whatever follows the first occurrence of {it:pchars},
which will be the empty string "" if {it:pchars} does not occur.  The 
tail of "frog toad newt" is "toad newt" and that of "frog" is "".  With
{cmd:punct(,)}, the tail of "frog,toad" is "toad".

{pmore2}
The {opt trim} option trims any leading or trailing spaces.

{phang2}
{opth fill(numlist)}{p_end}
{pmore2}
may not be combined with {cmd:by}.  It creates a variable of ascending or
descending numbers or complex repeating patterns.  {it:numlist} must contain
at least two numbers and may be specified using standard {it:numlist}
notation; see {help numlist}.  {helpb if} and {helpb in} are not
allowed with {opt fill()}.

{phang2}
{opth group(varlist)} [{cmd:,} {opt m:issing}
{opt l:abel} {opt lname}{cmd:(}{it:name}{cmd:)}
{opt t:runcate}{cmd:(}{it:num}{cmd:)}]{p_end}
{pmore2}
may not be combined with {cmd:by}.  It creates one variable taking on
values 1, 2, ... for the groups formed by {it:varlist}.  {it:varlist} may
contain numeric variables, string variables, or a combination of the two.  The
order of the groups is that of the sort order of {it:varlist}.  {opt missing}
indicates that missing values in {it:varlist}
{bind:(either {cmd:.} or {cmd:""}}) are to be treated like any other value
when assigning groups, instead of as missing values being assigned to the
group missing.  The {opt label} option returns integers from 1 up according to
the distinct groups of {it:varlist} in sorted order.  The integers are labeled
with the values of {it:varlist} or the value labels, if they exist.  
{opt lname()} specifies the name to be given to the value label created to
hold the labels; {opt lname()} implies {opt label}.  The {opt truncate()}
option truncates the values contributed to the label from each variable in
{it:varlist} to the length specified by the integer argument {it:num}.  The
{opt truncate} option cannot be used without specifying the {opt label}
option.  The {opt truncate} option does not change the groups that are
formed; it changes only their labels.

        {opth iqr(exp)}{right:(allows {help by:{bf:by} {it:varlist}{bf::}})  }
{pmore2}
creates a constant (within {it:varlist}) containing the interquartile range of
{it:exp}.  Also see {help egen##pctile():{bf:pctile()}}.

        {opth kurt(varname)}{right:(allows {help by:{bf:by} {it:varlist}{bf::}})  }
{pmore2}
returns the kurtosis (within {it:varlist}) of {it:varname}.  

        {opth mad(exp)}{right:(allows {help by:{bf:by} {it:varlist}{bf::}})  }
{pmore2}
returns the median absolute deviation from the median (within {it:varlist}) 
of {it:exp}.

        {opth max(exp)}{right:(allows {help by:{bf:by} {it:varlist}{bf::}})  }
{pmore2}
creates a constant (within {it:varlist}) containing the maximum value
of {it:exp}.

        {opth mdev(exp)}{right:(allows {help by:{bf:by} {it:varlist}{bf::}})  }
{pmore2}
returns the mean absolute deviation from the mean (within {it:varlist})
of {it:exp}.

{marker mean()}{...}
        {opth mean(exp)}{right:(allows {help by:{bf:by} {it:varlist}{bf::}})  }
{pmore2}
creates a constant (within {it:varlist}) containing the mean of
{it:exp}.

{marker median()}{...}
        {opth median(exp)}{right:(allows {help by:{bf:by} {it:varlist}{bf::}})  }
{pmore2}
creates a constant (within {it:varlist}) containing the median of
{it:exp}.  Also see {help egen##pctile():{bf:pctile()}}.

        {opth min(exp)}{right:(allows {help by:{bf:by} {it:varlist}{bf::}})  }
{pmore2}
creates a constant (within {it:varlist}) containing the minimum value
of {it:exp}.

        {opth mode(varname)} [{cmd:,} {opt min:mode} {opt max:mode} {opt num:mode}{cmd:(}{it:integer}{cmd:)} {opt miss:ing}] {right:(allows {help by:{bf:by} {it:varlist}{bf::}})  }
{pmore2}
produces the mode (within {it:varlist}) for {it:varname}, which may be numeric
or string.  The mode is the value occurring most frequently.  If two or more
modes exist or if {it:varname} contains all missing values, the mode produced
will be a missing value.  To avoid this, the {opt minmode}, {opt maxmode}, or
{opt nummode()} option may be used to specify choices for selecting among the
multiple modes, and the {opt missing} option will treat missing values as
categories.  {opt minmode} returns the lowest value, and {opt maxmode} returns
the highest value.  {opt nummode(#)} will return the {it:#}th mode, counting
from the lowest up.  Missing values are excluded from determination of the
mode unless {opt missing} is specified.  Even so, the value of the mode is
recorded for observations for which the values of {it:varname} are missing
unless they are explicitly excluded, that is, by
{bind:{cmd:if} {it:varname} {cmd:< .} or {cmd:if} {it:varname} {cmd:!= ""}}.

{phang2}
{opt mtr(year income)}{p_end}
{pmore2}
may not be combined with {cmd:by}.  It returns the U.S. marginal income tax
rate for a married couple with taxable income {it:income} in year {it:year},
where 1930 {ul:<} {it:year} {ul:<} 2019.  {it:year} and {it:income} may be
specified as variable names or constants; for example,
{bind:{cmd:mtr(1993 faminc)}},
{cmd:mtr(surveyyr 28000)}, or {cmd:mtr(surveyyr faminc)}.  A blank or comma
may be used to separate {it:income} from {it:year}.

        {opth pc(exp)} [{cmd:, prop}]{right:(allows {help by:{bf:by} {it:varlist}{bf::}})  }
{pmore2}
returns {it:exp} (within {it:varlist}) scaled to be a percentage of the total,
between 0 and 100.  The {opt prop} option returns {it:exp} scaled to be a
proportion of the total, between 0 and 1.

{marker pctile()}{...}
        {opth pctile(exp)} [{cmd:, p(}{it:#}{cmd:)}]{right:(allows {help by:{bf:by} {it:varlist}{bf::}})  }
{pmore2}
creates a constant (within {it:varlist}) containing the {it:#}th percentile
of {it:exp}.  If {opt p(#)} is not specified, 50 is assumed, meaning medians.
Also see {help egen##median():{bf:median()}}.

        {opth rank(exp)} [{cmd:,} {opt f:ield}|{opt t:rack}|{opt u:nique}]{right:(allows {help by:{bf:by} {it:varlist}{bf::}})  }
{pmore2}
creates ranks (within {it:varlist}) of {it:exp}; by default, equal
observations are assigned the average rank.  The {cmd:field} option calculates
the field rank of {it:exp}: the highest value is ranked 1, and there is no
correction for ties.  That is, the field rank is 1 + the number of values
that are higher.  The {opt track} option calculates the track rank of
{it:exp}:  the lowest value is ranked 1, and there is no correction for ties.
That is, the track rank is 1 + the number of values that are lower.  The
{opt unique} option calculates the unique rank of {it:exp}: values are ranked
1,...,{it:#}, and values and ties are broken arbitrarily.  Two values that
are tied for second are ranked 2 and 3.

{phang2}
{opth rowfirst(varlist)}{p_end}
{pmore2}
may not be combined with {cmd:by}.  It gives the first nonmissing value in
{it:varlist} for each observation (row).  If all values in {it:varlist} are
missing for an observation, {newvar} is set to missing.

{phang2}
{opth rowlast(varlist)}{p_end}
{pmore2}
may not be combined with {cmd:by}.  It gives the last nonmissing value in
{it:varlist} for each observation (row).  If all values in {it:varlist} are
missing for an observation, {newvar} is set to missing.

{phang2}
{opth rowmax(varlist)}{p_end}
{pmore2}
may not be combined with {cmd:by}.  It gives the maximum value (ignoring
missing values) in {it:varlist} for each observation (row).  If all values in
{it:varlist} are missing for an observation, {newvar} is set to missing.

{phang2}
{opth rowmean(varlist)}{p_end}
{pmore2}
may not be combined with {cmd:by}.  It creates the (row) means of the
variables in {it:varlist}, ignoring missing values; for example, if three
variables are specified and, in some observations, one of the variables is
missing, in those observations {newvar} will contain the mean of the two
variables that do exist.  Other observations will contain the mean of all
three variables.  Where none of the variables exist, {it:newvar} is set to
missing.

{marker rowmedian()}{...}
{phang2}
{opth rowmedian(varlist)}{p_end}
{pmore2}
may not be combined with {cmd:by}.  It gives the (row) median of the variables
in {it:varlist}, ignoring missing values.  If all variables in
{it:varlist} are missing for an observation, {newvar} is set to missing in
that observation.  Also see {help egen##rowpctile():{bf:rowpctile()}}.

{phang2}
{opth rowmin(varlist)}{p_end}
{pmore2}
may not be combined with {cmd:by}.  It gives the minimum value in {it:varlist}
for each observation (row).  If all values in {it:varlist} are missing for an
observation, {newvar} is set to missing.

{marker rowmiss()}{...}
{phang2}
{opth rowmiss(varlist)}{p_end}
{pmore2}
may not be combined with {cmd:by}.  It gives the number of missing values 
in {it:varlist} for each observation (row).  

{marker rownonmiss()}{...}
{phang2}
{opth rownonmiss(varlist)} [{cmd:,} {opt s:trok}]{p_end}
{pmore2}
may not be combined with {cmd:by}.  It gives the number of nonmissing
values in {it:varlist} for each observation (row) -- this is the value used
by {opt rowmean()} for the denominator in the mean calculation.

{pmore2}
String variables may not be specified unless the {opt strok} option is also
specified.  If {opt strok} is specified, string variables will be counted as
containing missing values when they contain "".  Numeric variables will be
counted as containing missing when their value is "{ul:>}{cmd:.}".

{marker rowpctile()}{...}
{phang2}
{opth rowpctile(varlist)} [{cmd:, p(}{it:#}{cmd:)}]{p_end}
{pmore2}
may not be combined with {cmd:by}.  It gives the {it:#}th percentile of the
variables in {it:varlist}, ignoring missing values.  If all variables
in {it:varlist} are missing for an observation, {it:newvar} is set to missing
in that observation.  If {cmd:p()} is not specified, {cmd:p(50)} is assumed,
meaning medians.  Also see {help egen##rowmedian():{bf:rowmedian()}}.

{phang2}
{opth rowsd(varlist)}{p_end}
{pmore2}
may not be combined with {cmd:by}.  It creates the (row) standard deviations
of the variables in {it:varlist}, ignoring missing values.

{phang2}
{opth rowtotal(varlist)} [{cmd:,} {opt m:issing}]{p_end}
{pmore2}
may not be combined with {cmd:by}.  It creates the (row) sum of the variables
in {it:varlist}, treating missing as 0.  If {opt missing} is specified and all
values in {it:varlist} are missing for an observation, {it:newvar} is set to
missing.

        {opth sd(exp)}{right:(allows {help by:{bf:by} {it:varlist}{bf::}})  }
{pmore2}
creates a constant (within {it:varlist}) containing the standard
deviation of {it:exp}.  Also see {help egen##mean():{bf:mean()}}.

        {opt seq()} [{cmd:,} {opt f:rom(#)} {opt t:o(#)} {opt b:lock(#)}]{right:(allows {help by:{bf:by} {it:varlist}{bf::}})  }
{pmore2}
returns integer sequences.  Values start from {opt from()} (default 1) and
increase to {opt to()} (the default is the maximum number of values) in
blocks (default size 1).  If {opt to()} is less than the maximum number,
sequences restart at {opt from()}.  Numbering may also be separate within groups
defined by {it:varlist} or decreasing if {opt to()} is less than {opt from()}.
Sequences depend on the sort order of observations, following three rules: 1)
observations excluded by {helpb if} or {helpb in} are not counted;
2) observations are sorted by {it:varlist}, if specified; and 3) otherwise,
the order is that when called.  No {it:arguments} are specified.

        {opth skew(varname)}{right:(allows {help by:{bf:by} {it:varlist}{bf::}})  }
{pmore2}
returns the skewness (within {it:varlist}) of {it:varname}.

{phang2}
{opth std(exp)} [{cmd:,} {opt m:ean(#)} {opt s:td(#)}]{p_end}
{pmore2}
may not be combined with {cmd:by}.  It creates the standardized values of
{it:exp}.  The options specify the desired mean and standard deviation.  The
default is {cmd:mean(0)} and {cmd:std(1)}, producing a variable with mean 0
and standard deviation 1.

{phang2}
{opth tag(varlist)} [{cmd:,} {opt m:issing}]{p_end}
{pmore2}
may not be combined with {cmd:by}.  It tags just one observation in each
distinct group defined by {it:varlist}.  When all observations in a group have
the same value for a summary variable calculated for the group, it will be
sufficient to use just one value for many purposes.  The result will be 1 if
the observation is tagged and never missing, and 0 otherwise.  Values
for any observations excluded by either {helpb if} or {helpb in}
are set to 0 (not missing).  Hence, if {opt tag} is the variable
produced by {cmd:egen tag =} {opt tag(varlist)}, the idiom {opt if tag}
is always safe.  {opt missing} specifies that missing values of {it:varlist}
may be included.

{marker total()}{...}
        {opth total(exp)} [{cmd:,} {opt m:issing}] {right:(allows {help by:{bf:by} {it:varlist}{bf::}})  }
{pmore2}
creates a constant (within {it:varlist}) containing the sum of {it:exp}
treating missing as 0.  If {opt missing} is specified and all values in
{it:exp} are missing, {it:newvar} is set to missing.  Also see
{help egen##mean():{bf:mean()}}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Create new variable (extended)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:egen} creates {newvar} of the optionally specified storage type equal to
{it:fcn}{cmd:(}{it:arguments}{cmd:)}.  Here {it:fcn}{cmd:()} is a function
specifically written for {cmd:egen}, as documented below or as written by
users.  Only {cmd:egen} functions may be used with {cmd:egen}, and
conversely, only {cmd:egen} may be used to run {cmd:egen} functions.

{pstd}
Depending on {it:fcn}{cmd:()}, {it:arguments}, if present, refers to an
expression, {varlist}, or a {it:{help numlist}}, and the {it:options}
are similarly {it:fcn} dependent.  Explicit subscripting (using
{cmd:_N} and {cmd:_n}), which is commonly used with {cmd:generate}, should not
be used with {cmd:egen}; see {help subscripting}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D egenQuickstart:Quick start}

        {mansection D egenRemarksandexamples:Remarks and examples}

        {mansection D egenMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse egenxmpl}

{pstd}Describe the data{p_end}
{phang2}{cmd:. describe}

{pstd}Create variable containing the mean value of {cmd:cholesterol}{p_end}
{phang2}{cmd:. egen avg = mean(cholesterol)}

{pstd}Create variable containing the deviation from the mean cholesterol
level{p_end}
{phang2}{cmd:. generate deviation = chol - avg}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse egenxmpl2, clear}

{pstd}Describe the data{p_end}
{phang2}{cmd:. describe}

{pstd}Create variable containing the median length of stay for each
diagnostic code{p_end}
{phang2}{cmd:. by dcode, sort: egen medstay = median(los)}

{pstd}Create variable containing the deviation from the median length of
stay{p_end}
{phang2}{cmd:. generate deltalos = los - medstay}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. clear}{p_end}
{phang2}{cmd:. set obs 5}{p_end}
{phang2}{cmd:. generate x = _n if _n != 3}

{pstd}Create variable containing the running sum of {cmd:x}{p_end}
{phang2}{cmd:. generate runsum = sum(x)}

{pstd}Create variable containing a constant equal to the overall sum of
{cmd:x}{p_end}
{phang2}{cmd:. egen totalsum = total(x)}

{pstd}List the results{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse egenxmpl3, clear}

{pstd}Describe the data{p_end}
{phang2}{cmd:. describe}

{pstd}Create {cmd:differ} containing 1 if {cmd:inc1}, {cmd:inc2}, and
{cmd:inc3} are not all equal, and 0 otherwise{p_end}
{phang2}{cmd:. egen byte differ = diff(inc1 inc2 inc3)}

{pstd}List the observations where incomes differ{p_end}
{phang2}{cmd:. list if differ == 1}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}

{pstd}Create variable containing the ranks of {cmd:mpg}{p_end}
{phang2}{cmd:. egen rank = rank(mpg)}

{pstd}Sort the data on {cmd:rank}{p_end}
{phang2}{cmd:. sort rank}

{pstd}List the results{p_end}
{phang2}{cmd:. list mpg rank}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse states1, clear}

{pstd}Describe the data{p_end}
{phang2}{cmd:. describe}

{pstd}Create {cmd:stdage} containing the standardized value of
{cmd:age}{p_end}
{phang2}{cmd:. egen stdage = std(age)}

{pstd}Summarize the results{p_end}
{phang2}{cmd:. summarize age stdage}

{pstd}Display the correlation between {cmd:age} and {cmd:stdage}{p_end}
{phang2}{cmd:. correlate age stdage}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse egenxmpl4, clear}

{pstd}Create {cmd:hsum} containing the row sum of {cmd:a}, {cmd:b},
and {cmd:c} for each row{p_end}
{phang2}{cmd:. egen hsum = rowtotal(a b c)}

{pstd}Create {cmd:havg} containing the row mean of {cmd:a}, {cmd:b},
and {cmd:c} for each row{p_end}
{phang2}{cmd:. egen havg = rowmean(a b c)}

{pstd}Create {cmd:hstd} containing the row standard deviation of {cmd:a},
{cmd:b}, and {cmd:c} for each row{p_end}
{phang2}{cmd:. egen hsd = rowsd(a b c)}

{pstd}Create {cmd:hnonmiss} containing the number of nonmissing observations
of {cmd:a}, {cmd:b}, and {cmd:c} for each row{p_end}
{phang2}{cmd:. egen hnonmiss = rownonmiss(a b c)}

{pstd}Create {cmd:hmiss} containing the number of missing observations
of {cmd:a}, {cmd:b}, and {cmd:c} for each row{p_end}
{phang2}{cmd:. egen hmiss = rowmiss(a b c)}

{pstd}List the results{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse egenxmpl5, clear}

{pstd}Create {cmd:rmin} containing the minimum within an observation (row) for
{cmd:x}, {cmd:y}, and {cmd:z}{p_end}
{phang2}{cmd:. egen rmin = rowmin(x y z)}

{pstd}Create {cmd:rmax} containing the maximum within an observation (row) for
{cmd:x}, {cmd:y}, and {cmd:z}{p_end}
{phang2}{cmd:. egen rmax = rowmax(x y z)}

{pstd}Create {cmd:rfirst} containing the first nonmissing value within an
observation (row) for {cmd:x}, {cmd:y}, and {cmd:z}{p_end}
{phang2}{cmd:. egen rfirst = rowfirst(x y z)}

{pstd}Create {cmd:rlast} containing the last nonmissing value within an
observation (row) for {cmd:x}, {cmd:y}, and {cmd:z}{p_end}
{phang2}{cmd:. egen rlast = rowlast(x y z)}

{pstd}List the results{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}

{pstd}Create {cmd:highrep78} containing the value of {cmd:rep78} if
{cmd:rep78} is equal to 3, 4, or 5, otherwise {cmd:highrep78} contains missing
({cmd:.}){p_end}
{phang2}{cmd:. egen highrep78 = anyvalue(rep78), v(3/5)}

{pstd}List the result{p_end}
{phang2}{cmd:. list rep78 highrep78}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse egenxmpl6, clear}

{pstd}Create {cmd:racesex} containing values 1, 2, ..., for the groups formed
by {cmd:race} and {cmd:sex} and containing missing if {cmd:race} or {cmd:sex}
are missing{p_end}
{phang2}{cmd:. egen racesex = group(race sex)}

{pstd}List the result{p_end}
{phang2}{cmd:. list race sex racesex in 1/7}

{pstd}Create {cmd:rs2} containing values 1, 2, ..., for the groups formed by
{cmd:race} and {cmd:sex}, treating missing like any other value{p_end}
{phang2}{cmd:. egen rs2 = group(race sex), missing}

{pstd}List the result{p_end}
{phang2}{cmd:. list race sex rs2 in 1/7}{p_end}
    {hline}
