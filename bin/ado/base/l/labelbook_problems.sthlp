{smcl}
{* *! version 1.2.3  10aug2012}{...}
{vieweralsosee "[D] labelbook" "help labelbook"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] label" "help label"}{...}
{vieweralsosee "[D] codebook" "help codebook"}{...}
{viewerjumpto "Description" "labelbook_problems##description"}{...}
{viewerjumpto "Remarks" "labelbook_problems##remarks"}{...}
{viewerjumpto "Stored results" "labelbook_problems##results"}{...}
{title:Title}

{p 4 33 2}
{hi:labelbook} ...{hi:, problems} {hline 2} Potential problems reported by
labelbook


{marker description}{...}
{title:Description}

{pstd}
{helpb labelbook} with the {cmd:problems} option diagnoses possible problems
with value labels.

{p 8 10 2}
1. Value label has gaps in mapped values.
{p_end}
{p 8 10 2}
2. Value label strings contain leading or trailing blanks.
{p_end}
{p 8 10 2}
3. Value label contains duplicate labels.
{p_end}
{p 8 10 2}
4. Value label contains duplicate labels at length 12.
{p_end}
{p 8 10 2}
5. Value label contains numeric -> numeric mappings.
{p_end}
{p 8 10 2}
6. Value label contains numeric -> null string mappings.
{p_end}
{p 8 10 2}
7. Value label is not used by variables.
{p_end}

{pstd}
These possible problems are discussed below.


{marker remarks}{...}
{title:Remarks}

{phang}
1.  Value label has gaps in mapped values.

{pmore}
Suppose that in a value label you defined mappings for 1, 2, 4, and 5, and you
forgot to label the value 3.  Sometimes, however, value label may have gaps
purposely.  For instance, some dataset designers use numeric codes, such as 7,
8, 9 or 97, 98, 99, consistently for different types of missing values such as
"unreached", "not applicable", and "not answered".  Such a practice obviously
leads to gaps in value labels that can safely be ignored.

{pmore}
Advice:  verify the correctness of value labels with gaps.


{pstd}
2.  Value label strings contain leading or trailing blanks.

{pmore}
Leading or trailing blanks in value label texts may lead to misaligned output
or unnecessary truncation of value labels in output.  Such blanks may also
make it more difficult to process substrings of strings correctly and may
waste resources.

{pmore}
Advice:  remove leading and trailing blanks.


{pstd}
3.  Value label contains duplicate labels.

{pmore}
It is possible to map different numbers to the same string, but this does not
make Stata implicitly collapse the corresponding numerical codes.  Rather, you
may observe tables such as

{space 12}{cmd:. label define odd_label 0 null 1 null, modify}
{space 12}{cmd:. label value x odd_label}
{space 12}{cmd}. tab x

{space 12}          {txt}x {c |}      Freq.     Percent        Cum.
{space 12}{hline 12}{c +}{hline 35}
{space 12}{txt}       null {c |}{res}         56       56.00       56.00
{space 12}{txt}       null {c |}{res}         44       44.00      100.00
{space 12}{txt}{hline 12}{c +}{hline 35}
{space 12}      Total {c |}{res}        100      100.00{txt}

{pmore}
or

{space 12}{cmd:. label define odd_label 0 3 1 3, modify}
{space 12}{cmd:. label value x odd_label}
{space 12}{cmd}. tab x

{space 12}          {txt}x {c |}      Freq.     Percent        Cum.
{space 12}{hline 12}{c +}{hline 35}
{space 12}{txt}          3 {c |}{res}         56       56.00       56.00
{space 12}{txt}          3 {c |}{res}         44       44.00      100.00
{space 12}{txt}{hline 12}{c +}{hline 35}
{space 12}      Total {c |}{res}        100      100.00{txt}

{pmore}
To collapse values, generate a new variable; see {manhelp recode D}
and {manhelp generate D}.

{pmore}
Advice:  avoid duplicate labels.


{pstd}
4.  Value label contains duplicate labels at length 12.

{pmore}
Even if value label strings are different at full length, Stata often has to
truncate value labels in tables because it does not have space to display the
full label.  Truncation may create duplicates.  Many commands display only the
first 12 characters, and so {cmd:labelbook} finds duplicate value labels at
length 12.

{pmore}
Advice:  consider making the value labels unique in the first 12 characters.


{pstd}
5.  Value label contains numeric -> numeric mappings.

{pmore}
Stata allows value labels that map numbers (numeric values) to numbers, that
is, to strings that can be interpreted as numbers.  Although this feature is
sometimes  useful, it can be extremely confusing because it will not be clear
whether a number is a numeric value or a string that can be interpreted as a
number: if Stata displays 23, is this the number 23 or the string "23"?

{pmore}
Here are examples using a 0-1
valued variable {cmd:x} that is currently not value labeled,

{space 12}{cmd:. tab x}

{space 12}{txt}          x {c |}      Freq.     Percent        Cum.
{space 12}{hline 12}{c +}{hline 35}
{space 12}{txt}          0 {c |}{res}         56       56.00       56.00
{space 12}{txt}          1 {c |}{res}         44       44.00      100.00
{space 12}{txt}{hline 12}{c +}{hline 35}
{space 12}{txt}      Total {c |}{res}        100      100.00{txt}

{space 12}{cmd:. label define odd_label 0 4 1 5, modify}
{space 12}{cmd:. label value x odd_label}
{space 12}{cmd}. tab x

{space 12}{txt}          x {c |}      Freq.     Percent        Cum.
{space 12}{hline 12}{c +}{hline 35}
{space 12}{txt}          4 {c |}{res}         56       56.00       56.00
{space 12}{txt}          5 {c |}{res}         44       44.00      100.00
{space 12}{txt}{hline 12}{c +}{hline 35}
{space 12}{txt}      Total {c |}{res}        100      100.00{txt}

{pmore}
or, worse

{space 12}{cmd:. label define odd_label 0 1 1 0, modify}
{space 12}{cmd:. label value x odd_label}
{space 12}{cmd}. tab x

{space 12}{txt}          x {c |}      Freq.     Percent        Cum.
{space 12}{hline 12}{c +}{hline 35}
{space 12}{txt}          1 {c |}{res}         56       56.00       56.00
{space 12}{txt}          0 {c |}{res}         44       44.00      100.00
{space 12}{txt}{hline 12}{c +}{hline 35}
{space 12}{txt}      Total {c |}{res}        100      100.00{txt}

{pmore}
This is sure to confuse you or someone else looking at your data at
some time.

{pmore}
Advice:  avoid numeric value labels.


{pstd}
6.  Value label contains numeric -> null string mappings.

{pmore}
It is possible to define value labels in which numbers are mapped to null
strings, that is, to one or more blanks.

{space 12}{cmd:. label define odd_label 0 odd 1 " ", modify}
{space 12}{cmd:. label value x odd_label}
{space 12}{cmd}. tab x

{space 12}{txt}          x {c |}      Freq.     Percent        Cum.
{space 12}{hline 12}{c +}{hline 35}
{space 12}{txt}        odd {c |}{res}         56       56.00       56.00
{space 12}{txt}            {c |}{res}         44       44.00      100.00
{space 12}{txt}{hline 12}{c +}{hline 35}
{space 12}{txt}      Total {c |}{res}        100      100.00{txt}

{pmore}
Advice:  avoid null labels.


{pstd}
7.  Value label is not used by variables.

{pmore}
If your dataset contains a value label that is not associated with any
variable, you may have forgotten to assign the value label after defining it
(using the statement "{cmd:label value} {it:varname labelname}").  If you save
the dataset, Stata will recognize that a value label is not used and silently
drop it.

{pmore}
You may also have dropped all variables to which the value label was attached.
In this case, you probably do not mind that the value label will be dropped
when you save the data.

{pmore}
Advice:  drop any value labels you no longer need
(with {cmd:label drop} {it:lblnamelist}), and assign the others to variables.

{pmore}
In multilingual datasets, value labels may be used only in the
inactive languages.  Such value labels are not dropped when the data are
saved.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:labelbook} stores the following list of value labels with potential
problems in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(names)}}{it:lblname-list}{p_end}
{synopt:{cmd:r(gaps)}}gaps in mapped values{p_end}
{synopt:{cmd:r(blanks)}}leading or trailing blanks{p_end}
{synopt:{cmd:r(null)}}name of value label containing null strings{p_end}
{synopt:{cmd:r(nuniq)}}duplicate labels{p_end}
{synopt:{cmd:r(nuniq_sh)}}duplicate labels at length 12{p_end}
{synopt:{cmd:r(ntruniq)}}duplicate labels at maximum string length{p_end}
{synopt:{cmd:r(notused)}}not used by any of the variables{p_end}
{synopt:{cmd:r(numeric)}}name of value label containing mappings to
numbers{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(}{it:lblname}{cmd:)}}list of variables that use value label
{it:lblname} (only when {cmd:var} option is specified{p_end}
{p2colreset}{...}

{pstd}
After running {cmd:labelbook}, you can review the lists of value labels with
potential problems by typing

	{cmd:. return list}

{pstd}
To show the value label definitions for labels with potential problem
{it:prob}, type

	{cmd:. label list `r(}{it:prob}{cmd:)'}

{pstd}
for example

	{cmd:. label list `r(numeric)'}
