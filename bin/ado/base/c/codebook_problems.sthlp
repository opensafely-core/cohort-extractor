{smcl}
{* *! version 1.2.1  16may2013}{...}
{vieweralsosee "[D] codebook" "mansection D codebook"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] label" "help label"}{...}
{vieweralsosee "[D] labelbook" "help labelbook"}{...}
{viewerjumpto "Potential problems reported by codebook" "codebook problems##problems"}{...}
{viewerjumpto "Discussion" "codebook problems##discussion"}{...}
{viewerjumpto "Other potential problems" "codebook problems##other_problems"}{...}
{viewerjumpto "Stored results" "codebook problems##results"}{...}
{marker problems}{...}
{title:Potential problems reported by codebook}

{pstd}
{helpb codebook} with the {cmd:problems} option diagnoses possible
problems with variables.

{p 8 10 2}
1. Constant variables, including variables that are always missing
{p_end}
{p 8 10 2}
2. Variables with nonexisting value labels
{p_end}
{p 8 10 2}
3. Incompletely labeled variables
{p_end}
{p 8 10 2}
4. String variables that may be compressed
{p_end}
{p 8 10 2}
5. String variables with leading or trailing blanks
{p_end}
{p 8 10 2}
6. String variables with embedded blanks
{p_end}
{p 8 10 2}
7. String variables with embedded binary 0 (\0)
{p_end}
{p 8 10 2}
8. Noninteger-valued date variables
{p_end}

{pstd}
These possible problems are discussed below.


{marker discussion}{...}
{title:Discussion}

{pstd}
1.  Constant variables, including variables that are always missing

{pin}
Variables that are constant, taking the same value in all observations,
or that are always missing, are often superfluous.  Such variables,
however, may also indicate problems.  For instance,
variables that are always missing may occur when importing data with an
incorrect input specification.  Such variables may also occur if you generate
a new variable for a subset of the data, selected with an expression that
is false for all observations.

{pin}
Advice:  Carefully check the origin of constant variables.  If you are saving
a constant variable, be sure to {helpb compress} the variable to use minimal
storage.


{pstd}
2.  Variables with nonexisting value labels

{pin}
Stata treats value labels as separate objects that can be attached to one or
more variables.  A problem may arise if variables are linked to value labels
that are not yet defined or an incorrect value label name was used.

{pin}
Advice:  Attach the correct value label, or {helpb label define} the value
label.  See {manhelp label D}.


{pstd}
3.  Incompletely labeled variables

{pin}
A variable is called "incompletely value labeled" if the variable is value
labeled but no mapping is provided for some values of the variable.  An
example is a variable with values 0, 1, and 2 and value labels for 1, 2, and
3.  This situation usually indicates an error, either in the data or in the
value label.

{pin}
Advice:  Change either the data or the value label.


{pstd}
4.  String variables that may be compressed

{pin}
The storage space used by a string variable is determined by its
{help data types:data type}.  For instance, the storage type
{cmd:str20} indicates that 20 bytes are used per observation.  If the
declared storage type exceeds your requirements, memory and disk space are
wasted.

{pin}
Advice:  Use {helpb compress} to store the data as compactly as possible.


{pstd}
5.  String variables with leading or trailing blanks

{pin}
In most applications, leading and trailing spaces do not affect the
meaning of variables but are probably side effects from importing the
data or from data manipulation.  Spurious leading and trailing spaces force
Stata to use more memory than required.  In addition, manipulating strings with
leading and trailing spaces is harder.

{pin}
Advice:  Remove leading and trailing blanks from a string
variable {cmd:s} by typing

{space 12}{cmd:replace s = trim(s)}

{pin}
See {helpb trim()}.


{pstd}
6.  String variables with embedded blanks

{pin}
String variables with embedded blanks are often appropriate; however,
sometimes they indicate problems importing the data.

{pin}
Advice:  Verify that blanks are meaningful in the variables.


{pstd}
7.  String variables with embedded binary 0 (\0)

{pin}
String variables with embedded binary 0 (\0) are allowed; however, caution
should be used when working with them as some commands and functions may
only work with the plain-text portion of a binary string, ignoring anything
after the first binary 0.

{pin}
Advice:  Be aware of binary strings in your data and whether you are
manipulating them in a way that is only appropriate with plain-text
values.


{pstd}
8.  Noninteger-valued date variables

{pin}
Stata's {help datetime:date and time formats} were designed for use with 
integer values but will work with noninteger values.

{pin}Advice:  Carefully inspect the nature of the noninteger values.  If
noninteger values in a variable are the consequence of
roundoff error, you may want to round the variable to the nearest integer.

{pin2}
{cmd:replace time = round(time)}


{marker other_problems}{...}
{title:Other potential problems}

{pstd}
The list of potential problems in data is probably endless.  Therefore,
{cmd:codebook} cannot do a complete job.  A partial list of other
common problems and possible remedies in Stata follows.

{pstd}
a.  Numerical data stored as strings

{pin}
After importing data into Stata, you may discover that some
string variables can actually be interpreted as numbers.  Stata can
do much more with numerical data than with string data.  Moreover, string
representation usually makes less-efficient use of computer resources.
{helpb destring} will convert string variables to numeric.

{pin}
A string variable may contain a "field"
with numeric information.  An example is an address variable that contains
the street name followed by the house number.  The Stata
{help string functions} can extract the relevant substring.


{pstd}
b.  Categorical variables stored as strings

{pin}
Most statistical commands do not allow string variables.  Moreover,
string variables that take only a limited number of distinct values
are an inefficient storage method.  Use value-labeled
numeric values instead, which are easily created with {helpb encode}.


{pstd}
c.  Duplicate observations

{pin}
See {manhelp duplicates D}.


{pstd}
d.  Observations that are always missing

{pin}
Drop observations that are missing for all variables in {it:varlist} by using
the {cmd:rownonmiss()} {helpb egen} function:

{space 12}{cmd:egen nobs = rownonmiss(}{it:varlist}{cmd:)}
{space 12}{cmd:drop if nobs==0}

{pin}
Specify {cmd:_all} for {it:varlist} if only observations that are
always missing should be dropped.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:codebook} with the {cmd:problems} option stores the following lists of
variables with potential problems in {cmd:r()}:

{synoptset 24 tabbed}{...}
{p2col 5 24 28 2: Macros}{p_end}
{synopt:{cmd:r(cons)}}constant (or missing){p_end}
{synopt:{cmd:r(labelnotfound)}}undefined value labeled{p_end}
{synopt:{cmd:r(notlabeled)}}value labeled but with unlabeled categories{p_end}
{synopt:{cmd:r(str_type)}}compressible{p_end}
{synopt:{cmd:r(str_leading)}}leading blanks{p_end}
{synopt:{cmd:r(str_trailing)}}trailing blanks{p_end}
{synopt:{cmd:r(str_embedded)}}embedded blanks{p_end}
{synopt:{cmd:r(str_embedded0)}}embedded binary 0 (\0){p_end}
{synopt:{cmd:r(realdate)}}noninteger dates{p_end}
{p2colreset}{...}

{pstd}
After running {cmd:codebook}, you can review the lists of variables with
potential problems

{tab}{cmd:. return list}

{pstd}
To describe the variables with potential problem {it:prob}:

{tab}{cmd:. describe `r(}{it:prob}{cmd:)'}

{pstd}
For example, to describe the variables that are incompletely value labeled,

{tab}{cmd:. describe `r(notlabeled)'}
